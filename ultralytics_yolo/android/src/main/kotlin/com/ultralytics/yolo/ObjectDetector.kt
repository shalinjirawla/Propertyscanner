// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

package com.ultralytics.yolo

import android.content.Context
import android.graphics.Bitmap
import android.graphics.RectF
import android.util.Log
import org.tensorflow.lite.DataType
import org.tensorflow.lite.Interpreter
import org.tensorflow.lite.gpu.GpuDelegate
import org.tensorflow.lite.support.common.ops.CastOp
import org.tensorflow.lite.support.common.ops.NormalizeOp
import org.tensorflow.lite.support.image.ops.Rot90Op
import org.tensorflow.lite.support.image.ImageProcessor
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.support.image.ops.ResizeOp
import org.tensorflow.lite.support.metadata.MetadataExtractor
import org.yaml.snakeyaml.Yaml
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.MappedByteBuffer

/**
 * High-performance ObjectDetector for YOLOv8
 * - Optimized preprocessing with TensorImage
 * - Supports camera rotation and single image processing
 * - Efficient post-processing with NMS
 */
class ObjectDetector(
    context: Context,
    modelPath: String,
    override var labels: List<String>,
    private val useGpu: Boolean = true,
    private val customOptions: Interpreter.Options? = null
) : BasePredictor() {

    // Inference output dimensions
    private var out1 = 0  // e.g., 84 (4 box coords + 80 classes)
    private var out2 = 0  // e.g., 8400 (number of predictions)

    // Image processors for different scenarios
    private lateinit var imageProcessorCameraPortrait: ImageProcessor
    private lateinit var imageProcessorCameraPortraitFront: ImageProcessor
    private lateinit var imageProcessorCameraLandscape: ImageProcessor
    private lateinit var imageProcessorSingleImage: ImageProcessor

    // Reuse inference output array ([1][out1][out2])
    private lateinit var rawOutput: Array<Array<FloatArray>>

    // Workspace for preprocessing
    private lateinit var scaledBitmap: Bitmap
    private lateinit var intValues: IntArray
    private lateinit var inputBuffer: ByteBuffer

    // TFLite Interpreter options
    private val interpreterOptions: Interpreter.Options = (customOptions ?: Interpreter.Options()).apply {
        if (customOptions == null) {
            setNumThreads(Runtime.getRuntime().availableProcessors())
        }

        if (useGpu) {
            try {
                addDelegate(GpuDelegate())
                Log.d(TAG, "GPU delegate enabled")
            } catch (e: Exception) {
                Log.e(TAG, "GPU delegate error: ${e.message}")
            }
        }
    }

    init {
        val modelBuffer = YOLOUtils.loadModelFile(context, modelPath)

        // Load labels from metadata
        var loadedLabels = YOLOFileUtils.loadLabelsFromAppendedZip(context, modelPath)
        var labelsWereLoaded = loadedLabels != null

        if (labelsWereLoaded) {
            this.labels = loadedLabels!!
            Log.i(TAG, "Labels loaded from appended ZIP: ${labels.size} classes")
        } else {
            Log.w(TAG, "No labels in ZIP, trying FlatBuffers metadata...")
            if (loadLabelsFromFlatbuffers(modelBuffer)) {
                labelsWereLoaded = true
                Log.i(TAG, "Labels loaded from FlatBuffers: ${labels.size} classes")
            }
        }

        if (!labelsWereLoaded && this.labels.isEmpty()) {
            Log.w(TAG, "No labels loaded! Detections will show 'Unknown' class names")
        }

        // Special handling for 4-class damage detection model
        // If we have exactly 4 classes or labels weren't loaded properly
        if (this.labels.size != 4) {
            Log.w(TAG, "Expected 4 classes but got ${this.labels.size}, using default damage detection labels")
            this.labels = listOf("wall-crack", "wall-damage", "object", "damage_glass")
        }

        Log.i(TAG, "Final labels: ${this.labels.joinToString(", ")}")

        // Initialize TFLite interpreter
        interpreter = Interpreter(modelBuffer, interpreterOptions)
        interpreter.allocateTensors()
        Log.d(TAG, "TFLite model loaded: $modelPath")

        // Get input shape
        val inputShape = interpreter.getInputTensor(0).shape()
        val inBatch = inputShape[0]
        val inHeight = inputShape[1]
        val inWidth = inputShape[2]
        val inChannels = inputShape[3]

        require(inBatch == 1 && inChannels == 3) {
            "Unsupported input shape. Expected [1, H, W, 3], got ${inputShape.joinToString()}"
        }

        inputSize = Size(inWidth, inHeight)
        modelInputSize = Pair(inWidth, inHeight)
        Log.d(TAG, "Model input size: ${inWidth}x${inHeight}")

        // Get output shape
        val outputShape = interpreter.getOutputTensor(0).shape()
        out1 = outputShape[1]  // e.g., 84
        out2 = outputShape[2]  // e.g., 8400
        Log.d(TAG, "Model output shape: [1, $out1, $out2]")

        // Allocate resources
        initPreprocessingResources(inWidth, inHeight)
        rawOutput = Array(1) { Array(out1) { FloatArray(out2) } }

        // Initialize image processors
        initImageProcessors()

        Log.d(TAG, "ObjectDetector initialized successfully")
        Log.d(TAG, "Classes: ${labels.joinToString(", ")}")
    }

    /**
     * Initialize image processors for different use cases
     */
    private fun initImageProcessors() {
        // Camera portrait (back camera) - 270° rotation
        imageProcessorCameraPortrait = ImageProcessor.Builder()
            .add(Rot90Op(3))
            .add(ResizeOp(inputSize.height, inputSize.width, ResizeOp.ResizeMethod.BILINEAR))
            .add(NormalizeOp(INPUT_MEAN, INPUT_STANDARD_DEVIATION))
            .add(CastOp(INPUT_IMAGE_TYPE))
            .build()

        // Camera portrait (front camera) - 90° rotation
        imageProcessorCameraPortraitFront = ImageProcessor.Builder()
            .add(Rot90Op(1))
            .add(ResizeOp(inputSize.height, inputSize.width, ResizeOp.ResizeMethod.BILINEAR))
            .add(NormalizeOp(INPUT_MEAN, INPUT_STANDARD_DEVIATION))
            .add(CastOp(INPUT_IMAGE_TYPE))
            .build()

        // Camera landscape - no rotation
        imageProcessorCameraLandscape = ImageProcessor.Builder()
            .add(ResizeOp(inputSize.height, inputSize.width, ResizeOp.ResizeMethod.BILINEAR))
            .add(NormalizeOp(INPUT_MEAN, INPUT_STANDARD_DEVIATION))
            .add(CastOp(INPUT_IMAGE_TYPE))
            .build()

        // Single images - no rotation
        imageProcessorSingleImage = ImageProcessor.Builder()
            .add(ResizeOp(inputSize.height, inputSize.width, ResizeOp.ResizeMethod.BILINEAR))
            .add(NormalizeOp(INPUT_MEAN, INPUT_STANDARD_DEVIATION))
            .add(CastOp(INPUT_IMAGE_TYPE))
            .build()
    }

    /**
     * Load labels from FlatBuffers metadata
     */
    private fun loadLabelsFromFlatbuffers(buf: MappedByteBuffer): Boolean = try {
        val extractor = MetadataExtractor(buf)
        val files = extractor.associatedFileNames

        if (!files.isNullOrEmpty()) {
            for (fileName in files) {
                Log.d(TAG, "Found metadata file: $fileName")
                extractor.getAssociatedFile(fileName)?.use { stream ->
                    val fileString = String(stream.readBytes(), Charsets.UTF_8)
                    val yaml = Yaml()
                    @Suppress("UNCHECKED_CAST")
                    val data = yaml.load<Map<String, Any>>(fileString)

                    if (data?.containsKey("names") == true) {
                        val namesMap = data["names"] as? Map<Int, String>
                        if (namesMap != null) {
                            labels = namesMap.values.toList()
                            return true
                        }
                    }
                }
            }
        }
        false
    } catch (e: Exception) {
        Log.e(TAG, "Failed to extract metadata: ${e.message}")
        false
    }

    /**
     * Allocate preprocessing resources
     */
    private fun initPreprocessingResources(width: Int, height: Int) {
        scaledBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        intValues = IntArray(width * height)
        inputBuffer = ByteBuffer.allocateDirect(1 * width * height * 3 * 4).apply {
            order(ByteOrder.nativeOrder())
        }
    }

    /**
     * Main inference method
     */
    override fun predict(
        bitmap: Bitmap,
        origWidth: Int,
        origHeight: Int,
        rotateForCamera: Boolean,
        isLandscape: Boolean
    ): YOLOResult {
        val overallStartTime = System.nanoTime()
        var stageStartTime = System.nanoTime()

        // ======== Preprocessing ========
        Log.d(TAG, "Starting preprocessing...")

        val tensorImage = TensorImage(DataType.FLOAT32)
        tensorImage.load(bitmap)

        inputBuffer.clear()

        val processedImage = if (rotateForCamera) {
            if (isLandscape) {
                imageProcessorCameraLandscape.process(tensorImage)
            } else {
                if (isFrontCamera) {
                    imageProcessorCameraPortraitFront.process(tensorImage)
                } else {
                    imageProcessorCameraPortrait.process(tensorImage)
                }
            }
        } else {
            imageProcessorSingleImage.process(tensorImage)
        }

        inputBuffer.put(processedImage.buffer)
        inputBuffer.rewind()

        val preprocessTimeMs = (System.nanoTime() - stageStartTime) / 1_000_000.0
        Log.d(TAG, "Preprocessing: %.2f ms".format(preprocessTimeMs))
        stageStartTime = System.nanoTime()

        // ======== Inference ========
        Log.d(TAG, "Running inference...")
        interpreter.run(inputBuffer, rawOutput)

        val inferenceTimeMs = (System.nanoTime() - stageStartTime) / 1_000_000.0
        Log.d(TAG, "Inference: %.2f ms".format(inferenceTimeMs))
        stageStartTime = System.nanoTime()

        // ======== Post-processing ========
        Log.d(TAG, "Starting post-processing...")

        val shape = interpreter.getOutputTensor(0).shape()
        Log.d(TAG, "Output shape: " + shape.contentToString())

        // Debug: Log sample output values
        if (out2 > 0) {
            val cx = rawOutput[0][0][0]
            val cy = rawOutput[0][1][0]
            val w = rawOutput[0][2][0]
            val h = rawOutput[0][3][0]
            val s1 = rawOutput[0][4][0]
            val s2 = rawOutput[0][5][0]

            Log.d(TAG, "Sample output [0-3][0]: cx=%.3f, cy=%.3f, w=%.3f, h=%.3f".format(cx, cy, w, h))
            Log.d(TAG, "Sample scores [4-5][0]: %.3f, %.3f".format(s1, s2))
        }

        // Post-process using Kotlin implementation (YOLOv8 format)
        val resultBoxes = postprocessYOLOv8(
            rawOutput[0],
            out1 = out1,  // 84
            out2 = out2,  // 8400
            confidenceThreshold = confidenceThreshold,
            iouThreshold = iouThreshold,
            numItemsThreshold = numItemsThreshold,
            numClasses = labels.size,
            inputWidth = inputSize.width,
            inputHeight = inputSize.height,
            origWidth = origWidth,
            origHeight = origHeight
        )

        Log.d(TAG, "Post-processing found ${resultBoxes.size} detections")

        // Convert to Box list
        val boxes = mutableListOf<Box>()
        for (boxArray in resultBoxes) {
            if (boxArray.size >= 6) {
                // boxArray format: [x1, y1, x2, y2, confidence, classIndex]
                // Coordinates are in PIXEL space (already scaled to original image)
                val x1 = boxArray[0]
                val y1 = boxArray[1]
                val x2 = boxArray[2]
                val y2 = boxArray[3]
                val conf = boxArray[4]
                val cls = boxArray[5].toInt()

                // Create rectangles with PIXEL coordinates
                val rect = RectF(x1, y1, x2, y2)

                // Create normalized coordinates (0-1)
                val normRect = RectF(
                    x1 / origWidth.toFloat(),
                    y1 / origHeight.toFloat(),
                    x2 / origWidth.toFloat(),
                    y2 / origHeight.toFloat()
                )

                Log.d(TAG, "Final box: x1=%.1f, y1=%.1f, x2=%.1f, y2=%.1f, conf=%.3f, cls=%d".format(x1, y1, x2, y2, conf, cls))
                Log.d(TAG, "Normalized: x1=%.3f, y1=%.3f, x2=%.3f, y2=%.3f".format(normRect.left, normRect.top, normRect.right, normRect.bottom))

                // Validate coordinates - boxes should be in pixel space
                if (x1 >= 0 && y1 >= 0 && x2 <= origWidth && y2 <= origHeight &&
                    x2 > x1 && y2 > y1) {

                    val label = if (cls in labels.indices) labels[cls] else "Unknown"
                    boxes.add(Box(cls, label, conf, rect, normRect))
                    Log.d(TAG, "✓ Added: $label (${(conf * 100).toInt()}%) at pixels [${x1.toInt()}, ${y1.toInt()}, ${x2.toInt()}, ${y2.toInt()}]")
                } else {
                    Log.w(TAG, "✗ Invalid box coordinates: pixel=$rect, norm=$normRect")
                }
            }
        }

        val postprocessTimeMs = (System.nanoTime() - stageStartTime) / 1_000_000.0
        Log.d(TAG, "Post-processing: %.2f ms".format(postprocessTimeMs))

        val totalMs = (System.nanoTime() - overallStartTime) / 1_000_000.0
        Log.d(TAG, "Total: %.2f ms (Pre: %.2f, Inf: %.2f, Post: %.2f)".format(
            totalMs, preprocessTimeMs, inferenceTimeMs, postprocessTimeMs))
        Log.d(TAG, "Final result: ${boxes.size} valid detections")

        updateTiming()

        return YOLOResult(
            origShape = Size(origWidth, origHeight),
            boxes = boxes,
            speed = totalMs,
            fps = if (t4 > 0.0) 1.0 / t4 else 0.0,
            names = labels
        )
    }

    /**
     * YOLOv8-specific postprocessing in Kotlin
     * Handles transposed output format: [8, 8400] for 4-class model
     * Format: [cx, cy, w, h, class0_score, class1_score, class2_score, class3_score]
     */
    private fun postprocessYOLOv8(
        output: Array<FloatArray>,  // [8][8400] for 4-class model
        out1: Int,                   // 8 (4 coords + 4 classes)
        out2: Int,                   // 8400
        confidenceThreshold: Float,
        iouThreshold: Float,
        numItemsThreshold: Int,
        numClasses: Int,
        inputWidth: Int,
        inputHeight: Int,
        origWidth: Int,
        origHeight: Int
    ): List<FloatArray> {

        Log.d(TAG, "=== YOLOv8 Postprocessing ===")
        Log.d(TAG, "Output shape: [$out1][$out2]")
        Log.d(TAG, "Input size: ${inputWidth}x${inputHeight}, Orig: ${origWidth}x${origHeight}")
        Log.d(TAG, "Confidence threshold: $confidenceThreshold")
        Log.d(TAG, "Number of classes expected: $numClasses")

        // Determine actual number of class rows from output
        val numClassRows = out1 - 4  // out1 - 4 coords = class scores
        Log.d(TAG, "Actual class rows in output: $numClassRows")

        // Use the smaller of the two (in case labels list is wrong)
        val actualNumClasses = minOf(numClasses, numClassRows)
        Log.d(TAG, "Using $actualNumClasses classes for detection")

        // Debug: Check first 10 predictions
        Log.d(TAG, "=== First 10 Predictions Raw Data ===")
        for (i in 0 until minOf(10, out2)) {
            val cx = output[0][i]
            val cy = output[1][i]
            val w = output[2][i]
            val h = output[3][i]

            // Find max score from available class rows
            var maxScore = 0f
            var maxIdx = 0
            for (c in 0 until numClassRows) {
                val score = output[4 + c][i]
                if (score > maxScore) {
                    maxScore = score
                    maxIdx = c
                }
            }

            Log.d(TAG, "Pred[$i]: cx=$cx, cy=$cy, w=$w, h=$h, maxScore=$maxScore (cls=$maxIdx)")
        }

        // Check score ranges
        var maxScoreOverall = 0f
        var minScoreOverall = Float.MAX_VALUE
        for (i in 0 until out2) {
            for (c in 0 until numClassRows) {
                val score = output[4 + c][i]
                maxScoreOverall = maxOf(maxScoreOverall, score)
                minScoreOverall = minOf(minScoreOverall, score)
            }
        }
        Log.d(TAG, "Score range: min=$minScoreOverall, max=$maxScoreOverall")

        // Calculate scaling factors
        val scaleX = origWidth.toFloat() / inputWidth.toFloat()
        val scaleY = origHeight.toFloat() / inputHeight.toFloat()

        Log.d(TAG, "Scale factors: X=$scaleX, Y=$scaleY")

        val boxes = mutableListOf<FloatArray>()

        // Process each detection (column in the transposed output)
        for (i in 0 until out2) {
            // Extract box coordinates (relative to input image size)
            val cx = output[0][i]
            val cy = output[1][i]
            val w = output[2][i]
            val h = output[3][i]

            // Find best class and confidence from available classes
            var maxConf = 0f
            var maxClass = 0

            for (c in 0 until numClassRows) {
                val score = output[4 + c][i]
                if (score > maxConf) {
                    maxConf = score
                    maxClass = c
                }
            }

            // Filter by confidence
            if (maxConf < confidenceThreshold) continue

            // Log first few detections for debugging
            if (boxes.size < 5) {
                Log.d(TAG, "✓ Detection #${boxes.size}: cx=$cx, cy=$cy, w=$w, h=$h, conf=$maxConf, cls=$maxClass")
            }

            // CRITICAL: YOLOv8 outputs are relative to INPUT image size (0-640 for 640x640 input)
            // We need to convert to ORIGINAL image pixel coordinates

            // Convert from center coords to corner coords (in input image space 0-inputWidth)
            val x1_input = cx - w / 2f
            val y1_input = cy - h / 2f
            val x2_input = cx + w / 2f
            val y2_input = cy + h / 2f

            // Scale to original image pixel coordinates
            val x1_pixel = x1_input * origWidth
            val y1_pixel = y1_input * origHeight
            val x2_pixel = x2_input * origWidth
            val y2_pixel = y2_input * origHeight

            // Store as [x1, y1, x2, y2, conf, class] in PIXEL coordinates
            boxes.add(floatArrayOf(
                x1_pixel,
                y1_pixel,
                x2_pixel,
                y2_pixel,
                maxConf,
                maxClass.toFloat()
            ))
        }

        Log.d(TAG, "Before NMS: ${boxes.size} detections")

        // Apply Non-Maximum Suppression (NMS)
        val nmsBoxes = applyNMS(boxes, iouThreshold, numItemsThreshold)

        Log.d(TAG, "After NMS: ${nmsBoxes.size} detections")

        return nmsBoxes
    }

    /**
     * Non-Maximum Suppression
     */
    private fun applyNMS(
        boxes: List<FloatArray>,
        iouThreshold: Float,
        maxDetections: Int
    ): List<FloatArray> {
        if (boxes.isEmpty()) return emptyList()

        // Sort by confidence (descending)
        val sortedBoxes = boxes.sortedByDescending { it[4] }

        val keep = mutableListOf<FloatArray>()
        val suppressed = BooleanArray(sortedBoxes.size) { false }

        for (i in sortedBoxes.indices) {
            if (suppressed[i]) continue
            if (keep.size >= maxDetections) break

            val boxA = sortedBoxes[i]
            keep.add(boxA)

            // Suppress overlapping boxes
            for (j in (i + 1) until sortedBoxes.size) {
                if (suppressed[j]) continue

                val boxB = sortedBoxes[j]
                val iou = calculateIoU(boxA, boxB)

                if (iou > iouThreshold) {
                    suppressed[j] = true
                }
            }
        }

        return keep
    }

    /**
     * Calculate Intersection over Union
     */
    private fun calculateIoU(boxA: FloatArray, boxB: FloatArray): Float {
        val x1A = boxA[0]
        val y1A = boxA[1]
        val x2A = boxA[2]
        val y2A = boxA[3]

        val x1B = boxB[0]
        val y1B = boxB[1]
        val x2B = boxB[2]
        val y2B = boxB[3]

        // Calculate intersection
        val xLeft = maxOf(x1A, x1B)
        val yTop = maxOf(y1A, y1B)
        val xRight = minOf(x2A, x2B)
        val yBottom = minOf(y2A, y2B)

        if (xRight < xLeft || yBottom < yTop) return 0f

        val intersectionArea = (xRight - xLeft) * (yBottom - yTop)

        // Calculate union
        val boxAArea = (x2A - x1A) * (y2A - y1A)
        val boxBArea = (x2B - x1B) * (y2B - y1B)
        val unionArea = boxAArea + boxBArea - intersectionArea

        return if (unionArea > 0f) intersectionArea / unionArea else 0f
    }

    // ======== Threshold Management ========
    private var confidenceThreshold = 0.25f
    private var iouThreshold = 0.45f
    private var numItemsThreshold = 30

    override fun setConfidenceThreshold(conf: Double) {
        confidenceThreshold = conf.toFloat()
        Log.d(TAG, "Confidence threshold set to: $confidenceThreshold")
        super.setConfidenceThreshold(conf)
    }

    override fun setIouThreshold(iou: Double) {
        iouThreshold = iou.toFloat()
        Log.d(TAG, "IoU threshold set to: $iouThreshold")
        super.setIouThreshold(iou)
    }

    override fun getConfidenceThreshold(): Double {
        return confidenceThreshold.toDouble()
    }

    override fun getIouThreshold(): Double {
        return iouThreshold.toDouble()
    }

    override fun setNumItemsThreshold(n: Int) {
        numItemsThreshold = n
        Log.d(TAG, "Max detections set to: $numItemsThreshold")
    }

    companion object {
        private const val TAG = "ObjectDetector"

        // Normalization parameters
        private const val INPUT_MEAN = 0f
        private const val INPUT_STANDARD_DEVIATION = 255f
        private val INPUT_IMAGE_TYPE = DataType.FLOAT32

        // Default thresholds
        private const val CONFIDENCE_THRESHOLD = 0.25F
        private const val IOU_THRESHOLD = 0.45F
    }
}