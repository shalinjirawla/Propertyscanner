import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_scan_pro/screens/YoloCamera/repo/yolo_repo.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:video_player/video_player.dart';

import '../../../Database/database_helper.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/image_hash.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/custom_log.dart';
import '../../DamageRepairTab/controller/damage_repair_tab_controller.dart';
import '../../DamageRepairTab/widget/damage_screen.dart';
import '../model/analyze_image_model.dart';

class YoloCameraController extends GetxController {
  var isLoading = true.obs, isLoadingImage = false.obs;
  var propertyNameController = TextEditingController().obs,
      propertyAddController = TextEditingController().obs,
      speechController = TextEditingController().obs,
      nameController = TextEditingController();
  var isVideoMode = true.obs, videoPath = ''.obs, pdfPath = ''.obs;
  var captureImages = [].obs, captureFile = <String>[].obs;
  VideoPlayerController? videoPlayerController;
  var speechEnabled = false.obs, isListening = false.obs;
  var pastSurveyList = <ReportModel>[].obs, damageNo = 0.obs;
  var dummyAnalyzeResponseListValue = <AnalyzeModeldata>[].obs;
  final ValueNotifier<List<YOLOResult>> resultsNotifier = ValueNotifier([]);
  var yoloController = YOLOViewController();

  final int _maxFps = 20;
  DateTime _lastUpdate = DateTime.fromMillisecondsSinceEpoch(0);
  double _confThreshold = 0.3;
  double _iouThreshold = 0.45;
  bool _isDetectionPaused = false;
  bool _isShowingConfirmationDialog = false;
  Uint8List? _tempCapturedImage;
  String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  DateTime? _lastDetectionTime;
  int _frameCount = 0;
  int _detectionFrameCount = 0;
  bool _isCapturing = false;

  // ⭐ NEW: Store ALL captured frames without processing
  final List<Map<String, dynamic>> rawCapturedFrames = [];

  final List<DateTime> timestamps = [];
  final Duration detectionIdleReset = Duration(
    milliseconds: Platform.isIOS ? 1600 : 500,
  );
  final int captureEveryNDetections = Platform.isIOS ? 40 : 5;

  /// Initialize video recording if video mode is enabled
  initVideoRecord() async {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String randomSuffix = generateRandomString(6); // 6-character random string
    String fileName = 'ScanVideo_${timestamp}_$randomSuffix';
    if (isVideoMode.value) {
      try {
        bool started = await FlutterScreenRecording.startRecordScreenAndAudio(
          fileName,
        );
        print('🎥 Video recording started: $started');
      } catch (e) {
        print('❌ Error starting video recording: $e');
      }
    }
  }

  /// ⭐ NEW: Quick capture without hash processing
  void _addRawCapturedImage(Uint8List imageBytes, String name) {
    print("🟢 Raw capture added: $name");

    rawCapturedFrames.add({
      'image': imageBytes,
      'name': name,
      'timestamp': DateTime.now(),
    });
  }

  /// ⭐ NEW: Process all captured frames and remove duplicates
  Future<void> _processAllCapturedFrames() async {
    if (rawCapturedFrames.isEmpty) {
      print("ℹ️ No frames to process");
      return;
    }

    print("🔄 Processing ${rawCapturedFrames.length} captured frames...");

    // Show processing dialog
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Processing images...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  'Removing duplicates',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Clear previous captures
      captureImages.clear();

      int duplicatesRemoved = 0;
      int processed = 0;

      for (var frame in rawCapturedFrames) {
        processed++;
        Uint8List imageBytes = frame['image'];
        String name = frame['name'];

        // Generate hash for current frame
        String newHash = ImageHash.getHash(imageBytes);

        if (newHash.isEmpty) {
          print("⚠️ Failed to generate hash for: $name");
          continue;
        }

        bool isDuplicate = false;

        // Check against already processed unique images
        for (var existingImg in captureImages) {
          String existingHash = existingImg['hash'] ?? '';

          if (existingHash.isEmpty) continue;

          // Calculate similarity percentage
          double similarity = ImageHash.similarity(newHash, existingHash);

          // Check if it's a duplicate (>70% similar)
          if (similarity > 70) {
            print(
              "⛔ Duplicate found: $name (${similarity.toStringAsFixed(2)}% similar to ${existingImg['name']})",
            );
            isDuplicate = true;
            duplicatesRemoved++;
            break;
          }
        }

        // If not duplicate, add to final list
        if (!isDuplicate) {
          captureImages.add({
            'image': imageBytes,
            'name': name,
            'hash': newHash,
          });
          print("✅ Unique image added: $name");
        }
      }

      print("✅ Processing complete!");
      print("📊 Total frames: ${rawCapturedFrames.length}");
      print("📊 Unique images: ${captureImages.length}");
      print("📊 Duplicates removed: $duplicatesRemoved");

      update();

      // Close processing dialog
      Get.back();

      // Show completion snackbar
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Processed: ${captureImages.length} unique images (${duplicatesRemoved} duplicates removed)',
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("❌ Error processing frames: $e");
      Get.back();

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('❌ Error processing images: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// ⭐ Capture image from YOLO frame (No hash processing)
  void captureImage({required bool isManual}) async {
    if (_isCapturing) {
      print("⚠️ Already capturing, skipping...");
      return;
    }

    _isCapturing = true;

    try {
      damageNo.value++;
      var captured = await yoloController.captureFrame();

      if (captured == null) {
        print("❌ Failed to capture frame");
        _isCapturing = false;
        return;
      }

      Uint8List imageBytes = Uint8List.fromList(captured);

      String name = isManual
          ? 'Manual ${damageNo.value}'
          : 'Detection ${damageNo.value}';

      // ⭐ Just store raw image, no processing
      _addRawCapturedImage(imageBytes, name);
      // analyzeDetectImage(imageBytes: imageBytes);
      // Show brief feedback for manual captures
      if (isManual) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('📸 Captured: $name'),
            duration: Duration(milliseconds: 800),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
          ),
        );
      }
    } catch (e) {
      print('❌ Error during image capture: $e');
    } finally {
      _isCapturing = false;
    }
  }

  void convertForIos(Uint8List? image, bool? isManual) async {
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(image!, flush: true);
    print('wrote screenshot to ${file.path}');
    captureFile.add(file.path);
    //controller.captureImages.add(image);
    captureImages.add({
      'image': image,
      'name': isManual!
          ? 'Manual ${damageNo.value}'
          : 'Detection ${damageNo.value}',
    });
  }

  /// ⭐ Show damage detected popup
  void _showDamageDetectedPopup() {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 60,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 20),
                // Title
                Text(
                  'Damage Detected!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                // Message
                Text(
                  'Frame captured successfully',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Auto-dismiss after 1.5 seconds
    Future.delayed(Duration(milliseconds: 1500), () {
      if (Navigator.canPop(Get.context!)) {
        Get.back();
      }
    });
  }

  /// ⭐ YOLO Result Callback - handles automatic detection
  void onResult(List<YOLOResult> result) {
    final now = DateTime.now();

    // Rate limiting check
    if (now.difference(_lastUpdate).inMilliseconds < (1000 / _maxFps)) {
      return;
    }
    _lastUpdate = now;

    // Track FPS
    timestamps.add(now);
    while (timestamps.isNotEmpty &&
        now.difference(timestamps.first) > Duration(seconds: 1)) {
      timestamps.removeAt(0);
    }

    _frameCount++;

    // ⭐ Filter out "object" class - only keep actual damages
    List<YOLOResult> validDetections = result.where((detection) {
      // Exclude "object" class from detections
      return detection.className.toLowerCase() != 'object';
    }).toList();

    // ⭐ Only process if there are valid damage detections (excluding "object")
    if (validDetections.isNotEmpty) {
      print(
        '🔍 Found ${validDetections.length} valid damage(s) (filtered ${result.length - validDetections.length} object(s))',
      );

      _lastDetectionTime = now;
      _detectionFrameCount++;

      // Reset counter if there was a long gap
      if (_lastDetectionTime != null &&
          now.difference(_lastDetectionTime!) > detectionIdleReset) {
        print("⏸️ Detection idle reset");
        _detectionFrameCount = 1;
      }

      // Capture every N detections
      if (_detectionFrameCount % captureEveryNDetections == 0) {
        print(
          "📸 Auto-capture triggered (every $captureEveryNDetections detections)",
        );
        //captureImage(isManual: false);

        // ⭐ Show damage detected popup
        showDamageConfirmationDialog();
        //_showDamageDetectedPopup();
      }
    } else {
      // No valid damage detection, check if we should reset
      if (_lastDetectionTime != null &&
          now.difference(_lastDetectionTime!) > detectionIdleReset) {
        print("🔄 Resetting detection counter (no valid damage detected)");
        _detectionFrameCount = 0;
        _lastDetectionTime = null;
      }
    }

    // Update results for display (use filtered results if you want to hide "object" from UI)
    resultsNotifier.value = validDetections;
  }

  Future<void> showDamageConfirmationDialog() async {
    if (_isShowingConfirmationDialog) {
      print("⚠️ Dialog already showing, skipping...");
      return;
    }

    // Pause detection immediately
    _isDetectionPaused = true;
    _isShowingConfirmationDialog = true;

    // ⭐ Capture frame immediately at detection time
    try {
      var captured = await yoloController.captureFrame();
      if (captured != null) {
        _tempCapturedImage = Uint8List.fromList(captured);
        print("📸 Frame captured immediately at detection time");
      } else {
        print("❌ Failed to capture frame at detection time");
        _tempCapturedImage = null;
      }
    } catch (e) {
      print("❌ Error capturing frame at detection time: $e");
      _tempCapturedImage = null;
    }

    await showDialog<bool>(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 60,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Title
                  Text(
                    'Damage Detected!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  // Question
                  Text(
                    'Do you want to save this damage frame?',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _tempCapturedImage = null;
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black87,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_tempCapturedImage != null) {
                              damageNo.value++;
                              String name = 'Detection ${damageNo.value}';
                              _addRawCapturedImage(_tempCapturedImage!, name);
                              _tempCapturedImage = null; // Clear after saving
                            } else {
                              print(
                                "⚠️ No frame was captured at detection time, capturing now as fallback",
                              );
                              captureImage(isManual: false);
                            }
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(Get.context!).showSnackBar(
                              SnackBar(
                                content: Text('✅ Damage frame saved'),
                                duration: Duration(milliseconds: 1000),
                                backgroundColor: AppColors.primary,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                  bottom: 100,
                                  left: 20,
                                  right: 20,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Yes, Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    _isShowingConfirmationDialog = false;

    // ⭐ Resume detection after a cooldown period to prevent immediate re-trigger
    print("⏳ Starting cooldown period (2 seconds)...");
    await Future.delayed(Duration(seconds: 2));
    _isDetectionPaused = false;
    _detectionFrameCount = 0; // Reset counter to avoid immediate re-trigger
    print("▶️ Detection RESUMED after cooldown");
  }

  Future<void> stopRecordingSafely() async {
    try {
      print("🛑 Stopping video recording...");
      String path = await FlutterScreenRecording.stopRecordScreen;
      final file = File(path);
      final exists = await file.exists();

      if (exists) {
        print('✅ Video saved at: $path');

        // Get original file size
        // int fileSizeInBytes = await file.length();
        // double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        print('✅ Video saved at: $path');
        //print('📊 Original video size: ${fileSizeInMB.toStringAsFixed(2)} MB');

        // Compress video if it's too large (e.g., > 10 MB)
        // if (fileSizeInMB > 10) {
        //   print('🗜️ Compressing video...');
        //   await _compressVideo(path);
        // } else {
        videoPath.value = path;
        //}
      } else {
        print('⚠️ Video file not found at: $path');
      }
    } catch (e) {
      debugPrint("❌ Stop recording failed: $e");
    }
  }

  /// ⭐ Handle end of scanning session with duplicate processing
  Future<void> endScanningSession() async {
    try {
      if (isVideoMode.value) {
        // print("🛑 Stopping video recording...");
        // String path = await FlutterScreenRecording.stopRecordScreen;
        // final file = File(path);
        // final exists = await file.exists();
        //
        // if (exists) {
        //   print('✅ Video saved at: $path');
        //
        //     // Get original file size
        //     // int fileSizeInBytes = await file.length();
        //     // double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        //     print('✅ Video saved at: $path');
        //     //print('📊 Original video size: ${fileSizeInMB.toStringAsFixed(2)} MB');
        //
        //     // Compress video if it's too large (e.g., > 10 MB)
        //     // if (fileSizeInMB > 10) {
        //     //   print('🗜️ Compressing video...');
        //     //   await _compressVideo(path);
        //     // } else {
        //       videoPath.value = path;
        //     //}
        // } else {
        //   print('⚠️ Video file not found at: $path');
        // }
        await stopRecordingSafely();
        await yoloController.stop();
      }

      // ⭐ Process all captured frames to remove duplicates
      if (rawCapturedFrames.isNotEmpty) {
        await _processAllCapturedFrames();
      }

      // Navigate based on capture mode
      if (!isVideoMode.value && captureImages.isEmpty) {
        print("ℹ️ No images captured, returning to previous screen");
        Get.back();
      } else {
        print("➡️ Moving to survey detail view");
        // var damageRepairController = Get.put(DamageRepairTabController());
        // damageRepairController.isEdit.value = true;
        await yoloController.stop();
        Get.to(() => DamageScreen());
      }
    } catch (e) {
      print("❌ Error ending session: $e");
      Get.back();
    }
  }

  // Future<void> _compressVideo(String originalPath) async {
  //   try {
  //     // Show compression progress (optional)
  //     VideoCompress.compressProgress$.subscribe((progress) {
  //       print('🗜️ Compression progress: ${progress.toStringAsFixed(0)}%');
  //     });
  //
  //     // Compress the video
  //     final info = await VideoCompress.compressVideo(
  //       originalPath,
  //       quality: VideoQuality.MediumQuality, // Options: LowQuality, MediumQuality, HighQuality, DefaultQuality
  //       deleteOrigin: false, // Set to true to delete original after compression
  //       includeAudio: true,
  //     );
  //
  //     if (info != null) {
  //       final compressedFile = File(info.path!);
  //       final compressedSizeInBytes = await compressedFile.length();
  //       final compressedSizeInMB = compressedSizeInBytes / (1024 * 1024);
  //
  //       print('✅ Video compressed successfully');
  //       print('📊 Compressed size: ${compressedSizeInMB.toStringAsFixed(2)} MB');
  //       print('📉 Size reduction: ${((1 - compressedSizeInBytes / info.filesize!) * 100).toStringAsFixed(1)}%');
  //
  //       videoPath.value = info.path!;
  //
  //       // Optionally delete original if compression successful
  //       if (compressedSizeInMB < info.filesize! / (1024 * 1024)) {
  //         await File(originalPath).delete();
  //         print('🗑️ Original video deleted');
  //       }
  //     } else {
  //       print('⚠️ Compression failed, using original video');
  //       videoPath.value = originalPath;
  //     }
  //   } catch (e) {
  //     print('❌ Error compressing video: $e');
  //     videoPath.value = originalPath; // Fallback to original
  //   } finally {
  //     VideoCompress.cancelCompression();
  //   }
  // }

  // Optional: Method to get file size as formatted string
  String _getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  void analyzeDetectImage({Uint8List? imageBytes}) async {
    isLoadingImage.value = true;
    isLoadingImage.value = await YoloRepo.analyzeImageApi(
      bodyData: {'image': imageBytes},
    );
    if (YoloRepo.dummyAnalyzeResponseList != null) {
      Console.Log(
        title: YoloRepo.dummyAnalyzeResponseList[0].mediaUrl,
        message: "DummyAnalyzeListYOLOOOOOOO>>>>>>>>>>>>>>>>>",
      );
      dummyAnalyzeResponseListValue.value = YoloRepo.dummyAnalyzeResponseList;
      Console.Log(
        title: dummyAnalyzeResponseListValue[0].analysis,
        message: "DummyAnalyzeList>>>>>>>>>>>>>>>>>",
      );
    }
  }

  void editImageName(int index, String newName) {
    if (index >= 0 && index < captureImages.length) {
      captureImages[index]['name'] = newName;
      captureImages.refresh(); // Refresh the observable list
    }
  }

  // Delete image at specific index
  void deleteImage(int index) {
    if (index >= 0 && index < captureImages.length) {
      captureImages.removeAt(index);
    }
  }

  @override
  void onClose() {
    captureImages.clear();
    captureFile.clear();
    videoPath.value = '';
    pdfPath.value = '';
    damageNo.value = 0;
    print("OnClose>>>>>>");
    super.onClose();
  }
}




//// timer wise video recording
/*import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_scan_pro/screens/YoloCamera/repo/yolo_repo.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:video_player/video_player.dart';

import '../../../Database/database_helper.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/image_hash.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/custom_log.dart';
import '../../DamageRepairTab/controller/damage_repair_tab_controller.dart';
import '../../DamageRepairTab/widget/damage_screen.dart';
import '../model/analyze_image_model.dart';

// ⭐ NEW: Subscription tier enum
enum SubscriptionTier {
  free,      // 30 seconds
  basic,     // 1 minute
  premium    // 5 minutes
}

class YoloCameraController extends GetxController {
  var isLoading = true.obs, isLoadingImage = false.obs;
  var propertyNameController = TextEditingController().obs,
      propertyAddController = TextEditingController().obs,
      speechController = TextEditingController().obs,
      nameController = TextEditingController();
  var isVideoMode = true.obs, videoPath = ''.obs, pdfPath = ''.obs;
  var captureImages = [].obs, captureFile = <String>[].obs;
  VideoPlayerController? videoPlayerController;
  var speechEnabled = false.obs, isListening = false.obs;
  var pastSurveyList = <ReportModel>[].obs, damageNo = 0.obs;
  var dummyAnalyzeResponseListValue = <AnalyzeModeldata>[].obs;
  final ValueNotifier<List<YOLOResult>> resultsNotifier = ValueNotifier([]);
  var yoloController = YOLOViewController();

  // ⭐ NEW: Recording time limit variables
  Timer? _recordingTimer;
  var recordingTimeRemaining = 0.obs; // Seconds remaining
  var isRecordingActive = false.obs;
  SubscriptionTier currentSubscriptionTier = SubscriptionTier.free; // Set based on user's subscription

  final int _maxFps = 20;
  DateTime _lastUpdate = DateTime.fromMillisecondsSinceEpoch(0);
  double _confThreshold = 0.3;
  double _iouThreshold = 0.45;
  bool _isDetectionPaused = false;
  bool _isShowingConfirmationDialog = false;

  String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
            (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  DateTime? _lastDetectionTime;
  int _frameCount = 0;
  int _detectionFrameCount = 0;
  bool _isCapturing = false;

  final List<Map<String, dynamic>> rawCapturedFrames = [];

  final List<DateTime> timestamps = [];
  final Duration detectionIdleReset = Duration(
    milliseconds: Platform.isIOS ? 1600 : 500,
  );
  final int captureEveryNDetections = Platform.isIOS ? 40 : 5;

  // ⭐ NEW: Get recording time limit based on subscription
  int getRecordingTimeLimit() {
    switch (currentSubscriptionTier) {
      case SubscriptionTier.free:
        return 600; // 10 minute
      case SubscriptionTier.basic:
        return 900; // 15 minute
      case SubscriptionTier.premium:
        return 1200; // 20 minutes
    }
  }

  // ⭐ NEW: Get subscription name
  String getSubscriptionName() {
    switch (currentSubscriptionTier) {
      case SubscriptionTier.free:
        return 'Free (30s)';
      case SubscriptionTier.basic:
        return 'Basic (1m)';
      case SubscriptionTier.premium:
        return 'Premium (5m)';
    }
  }

  // ⭐ NEW: Format time remaining
  String getFormattedTimeRemaining() {
    int minutes = recordingTimeRemaining.value ~/ 60;
    int seconds = recordingTimeRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// ⭐ MODIFIED: Initialize video recording with time limit
  initVideoRecord() async {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String randomSuffix = generateRandomString(6);
    String fileName = 'ScanVideo_${timestamp}_$randomSuffix';

    if (isVideoMode.value) {
      try {
        // Set time limit based on subscription
        int timeLimit = getRecordingTimeLimit();
        recordingTimeRemaining.value = timeLimit;

        bool started = await FlutterScreenRecording.startRecordScreenAndAudio(
          fileName,
        );

        if (started) {
          print('🎥 Video recording started: $started');
          print('⏱️ Time limit: ${timeLimit}s (${getSubscriptionName()})');

          isRecordingActive.value = true;

          // Start countdown timer
          _startRecordingTimer();
        }
      } catch (e) {
        print('❌ Error starting video recording: $e');
        isRecordingActive.value = false;
      }
    }
  }

  // ⭐ NEW: Start recording countdown timer
  void _startRecordingTimer() {
    _recordingTimer?.cancel(); // Cancel any existing timer

    _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (recordingTimeRemaining.value > 0) {
        recordingTimeRemaining.value--;

        // Warning at 10 seconds remaining
        if (recordingTimeRemaining.value == 10) {
          _showTimeWarning('10 seconds remaining!');
        }

        // Warning at 5 seconds remaining
        if (recordingTimeRemaining.value == 5) {
          _showTimeWarning('5 seconds remaining!');
        }
      } else {
        // Time's up! Auto-stop recording
        timer.cancel();
        _handleRecordingTimeUp();
      }
    });
  }

  // ⭐ NEW: Show time warning
  void _showTimeWarning(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text(message),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
      ),
    );
  }

  // ⭐ NEW: Handle recording time limit reached
  Future<void> _handleRecordingTimeUp() async {
    print('⏰ Recording time limit reached!');

    // Show dialog
    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Row(
            children: [
              Icon(Icons.timer_off, color: Colors.orange),
              SizedBox(width: 12),
              Text('Recording Time Limit Reached'),
            ],
          ),
          content: Text(
            'Your ${getSubscriptionName()} recording limit has been reached.\n\nThe recording will now stop automatically.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );

    // Auto-stop recording
    await endScanningSession();
  }

  // ⭐ NEW: Cancel recording timer
  void _cancelRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    isRecordingActive.value = false;
  }

  void _addRawCapturedImage(Uint8List imageBytes, String name) {
    print("🟢 Raw capture added: $name");

    rawCapturedFrames.add({
      'image': imageBytes,
      'name': name,
      'timestamp': DateTime.now(),
    });
  }

  Future<void> _processAllCapturedFrames() async {
    if (rawCapturedFrames.isEmpty) {
      print("ℹ️ No frames to process");
      return;
    }

    print("🔄 Processing ${rawCapturedFrames.length} captured frames...");

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Processing images...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  'Removing duplicates',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      captureImages.clear();

      int duplicatesRemoved = 0;
      int processed = 0;

      for (var frame in rawCapturedFrames) {
        processed++;
        Uint8List imageBytes = frame['image'];
        String name = frame['name'];

        String newHash = ImageHash.getHash(imageBytes);

        if (newHash.isEmpty) {
          print("⚠️ Failed to generate hash for: $name");
          continue;
        }

        bool isDuplicate = false;

        for (var existingImg in captureImages) {
          String existingHash = existingImg['hash'] ?? '';

          if (existingHash.isEmpty) continue;

          double similarity = ImageHash.similarity(newHash, existingHash);

          if (similarity > 70) {
            print(
              "⛔ Duplicate found: $name (${similarity.toStringAsFixed(2)}% similar to ${existingImg['name']})",
            );
            isDuplicate = true;
            duplicatesRemoved++;
            break;
          }
        }

        if (!isDuplicate) {
          captureImages.add({
            'image': imageBytes,
            'name': name,
            'hash': newHash,
          });
          print("✅ Unique image added: $name");
        }
      }

      print("✅ Processing complete!");
      print("📊 Total frames: ${rawCapturedFrames.length}");
      print("📊 Unique images: ${captureImages.length}");
      print("📊 Duplicates removed: $duplicatesRemoved");

      update();

      Get.back();

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Processed: ${captureImages.length} unique images (${duplicatesRemoved} duplicates removed)',
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("❌ Error processing frames: $e");
      Get.back();

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('❌ Error processing images: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void captureImage({required bool isManual}) async {
    if (_isCapturing) {
      print("⚠️ Already capturing, skipping...");
      return;
    }

    _isCapturing = true;

    try {
      damageNo.value++;
      var captured = await yoloController.captureFrame();

      if (captured == null) {
        print("❌ Failed to capture frame");
        _isCapturing = false;
        return;
      }

      Uint8List imageBytes = Uint8List.fromList(captured);

      String name = isManual
          ? 'Manual ${damageNo.value}'
          : 'Detection ${damageNo.value}';

      _addRawCapturedImage(imageBytes, name);

      if (isManual) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('📸 Captured: $name'),
            duration: Duration(milliseconds: 800),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
          ),
        );
      }
    } catch (e) {
      print('❌ Error during image capture: $e');
    } finally {
      _isCapturing = false;
    }
  }

  void convertForIos(Uint8List? image, bool? isManual) async {
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(image!, flush: true);
    print('wrote screenshot to ${file.path}');
    captureFile.add(file.path);
    captureImages.add({
      'image': image,
      'name': isManual!
          ? 'Manual ${damageNo.value}'
          : 'Detection ${damageNo.value}',
    });
  }

  void _showDamageDetectedPopup() {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 60,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Damage Detected!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'Frame captured successfully',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Future.delayed(Duration(milliseconds: 1500), () {
      if (Navigator.canPop(Get.context!)) {
        Get.back();
      }
    });
  }

  void onResult(List<YOLOResult> result) {
    final now = DateTime.now();

    if (now.difference(_lastUpdate).inMilliseconds < (1000 / _maxFps)) {
      return;
    }
    _lastUpdate = now;

    timestamps.add(now);
    while (timestamps.isNotEmpty &&
        now.difference(timestamps.first) > Duration(seconds: 1)) {
      timestamps.removeAt(0);
    }

    _frameCount++;

    List<YOLOResult> validDetections = result.where((detection) {
      return detection.className.toLowerCase() != 'object';
    }).toList();

    if (validDetections.isNotEmpty) {
      print(
        '🔍 Found ${validDetections.length} valid damage(s) (filtered ${result.length - validDetections.length} object(s))',
      );

      _lastDetectionTime = now;
      _detectionFrameCount++;

      if (_lastDetectionTime != null &&
          now.difference(_lastDetectionTime!) > detectionIdleReset) {
        print("⏸️ Detection idle reset");
        _detectionFrameCount = 1;
      }

      if (_detectionFrameCount % captureEveryNDetections == 0) {
        print(
          "📸 Auto-capture triggered (every $captureEveryNDetections detections)",
        );
        showDamageConfirmationDialog();
      }
    } else {
      if (_lastDetectionTime != null &&
          now.difference(_lastDetectionTime!) > detectionIdleReset) {
        print("🔄 Resetting detection counter (no valid damage detected)");
        _detectionFrameCount = 0;
        _lastDetectionTime = null;
      }
    }

    resultsNotifier.value = validDetections;
  }

  Future<void> showDamageConfirmationDialog() async {
    if (_isShowingConfirmationDialog) {
      print("⚠️ Dialog already showing, skipping...");
      return;
    }

    _isDetectionPaused = true;
    _isShowingConfirmationDialog = true;

    await showDialog<bool>(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 60,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Damage Detected!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Do you want to save this damage frame?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black87,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            captureImage(isManual: false);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(Get.context!).showSnackBar(
                              SnackBar(
                                content: Text('✅ Damage frame saved'),
                                duration: Duration(milliseconds: 1000),
                                backgroundColor: AppColors.primary,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                    bottom: 100, left: 20, right: 20),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Yes, Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    _isShowingConfirmationDialog = false;

    print("⏳ Starting cooldown period (2 seconds)...");
    await Future.delayed(Duration(seconds: 2));
    _isDetectionPaused = false;
    _detectionFrameCount = 0;
    print("▶️ Detection RESUMED after cooldown");
  }

  Future<void> stopRecordingSafely() async {
    try {
      print("🛑 Stopping video recording...");

      // ⭐ Cancel timer
      _cancelRecordingTimer();

      String path = await FlutterScreenRecording.stopRecordScreen;
      final file = File(path);
      final exists = await file.exists();

      if (exists) {
        print('✅ Video saved at: $path');
        videoPath.value = path;
      } else {
        print('⚠️ Video file not found at: $path');
      }
    } catch (e) {
      debugPrint("❌ Stop recording failed: $e");
    }
  }

  /// ⭐ MODIFIED: Handle end of scanning session
  Future<void> endScanningSession() async {
    try {
      if (isVideoMode.value) {
        await stopRecordingSafely();
        await yoloController.stop();
      }

      if (rawCapturedFrames.isNotEmpty) {
        await _processAllCapturedFrames();
      }

      if (!isVideoMode.value && captureImages.isEmpty) {
        print("ℹ️ No images captured, returning to previous screen");
        Get.back();
      } else {
        print("➡️ Moving to survey detail view");
        await yoloController.stop();
        Get.to(() => DamageScreen());
      }
    } catch (e) {
      print("❌ Error ending session: $e");
      Get.back();
    }
  }

  String _getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  void analyzeDetectImage({Uint8List? imageBytes}) async {
    isLoadingImage.value = true;
    isLoadingImage.value = await YoloRepo.analyzeImageApi(bodyData: {
      'image': imageBytes,
    });
    if (YoloRepo.dummyAnalyzeResponseList != null) {
      Console.Log(
          title: YoloRepo.dummyAnalyzeResponseList[0].mediaUrl,
          message: "DummyAnalyzeListYOLOOOOOOO>>>>>>>>>>>>>>>>>");
      dummyAnalyzeResponseListValue.value = YoloRepo.dummyAnalyzeResponseList;
      Console.Log(
          title: dummyAnalyzeResponseListValue[0].analysis,
          message: "DummyAnalyzeList>>>>>>>>>>>>>>>>>");
    }
  }

  void editImageName(int index, String newName) {
    if (index >= 0 && index < captureImages.length) {
      captureImages[index]['name'] = newName;
      captureImages.refresh();
    }
  }

  void deleteImage(int index) {
    if (index >= 0 && index < captureImages.length) {
      captureImages.removeAt(index);
    }
  }

  @override
  void onClose() {
    // ⭐ Cancel timer on close
    _cancelRecordingTimer();

    captureImages.clear();
    captureFile.clear();
    videoPath.value = '';
    pdfPath.value = '';
    damageNo.value = 0;
    print("OnClose>>>>>>");
    super.onClose();
  }
}*/









// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screen_recording/flutter_screen_recording.dart';
// import 'package:get/get.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:property_scan_pro/screens/YoloCamera/repo/yolo_repo.dart';
// import 'package:property_scan_pro/utils/Extentions.dart';
// import 'package:sizer/sizer.dart';
// import 'package:ultralytics_yolo/ultralytics_yolo.dart';
// import 'package:video_player/video_player.dart';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/return_code.dart';
//
// import '../../../Database/database_helper.dart';
// import '../../../routes/app_pages.dart';
// import '../../../utils/colors.dart';
// import '../../../utils/image_hash.dart';
// import '../../../utils/theme/app_colors.dart';
// import '../../../widgets/custom_log.dart';
// import '../../DamageRepairTab/controller/damage_repair_tab_controller.dart';
// import '../../DamageRepairTab/widget/damage_screen.dart';
// import '../model/analyze_image_model.dart';
//
// class YoloCameraController extends GetxController {
//   var isLoading = true.obs, isLoadingImage = false.obs;
//   var propertyNameController = TextEditingController().obs,
//       propertyAddController = TextEditingController().obs,
//       speechController = TextEditingController().obs,
//       nameController = TextEditingController();
//
//   var isVideoMode = true.obs,
//       isUploadedVideo = false.obs,
//       videoPath = ''.obs,
//       uploadedVideoPath = ''.obs,
//       pdfPath = ''.obs;
//
//   var captureImages = [].obs, captureFile = <String>[].obs;
//   VideoPlayerController? videoPlayerController;
//
//   var speechEnabled = false.obs, isListening = false.obs;
//   var pastSurveyList = <ReportModel>[].obs, damageNo = 0.obs;
//   var dummyAnalyzeResponseListValue = <AnalyzeModeldata>[].obs;
//
//   final ValueNotifier<List<YOLOResult>> resultsNotifier = ValueNotifier([]);
//   var yoloController = YOLOViewController();
//
//   // YOLO instance for uploaded video processing
//   YOLO? uploadedVideoYolo;
//
//   // Progress tracking
//   var processingProgress = 0.0.obs;
//   var currentFrame = 0.obs;
//   var totalFrames = 0.obs;
//   var processingStatus = ''.obs;
//
//   final int _maxFps = 20;
//   DateTime _lastUpdate = DateTime.fromMillisecondsSinceEpoch(0);
//   double _confThreshold = 0.3;
//   double _iouThreshold = 0.45;
//   bool _isDetectionPaused = false;
//   bool _isShowingConfirmationDialog = false;
//
//   String generateRandomString(int length) {
//     const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
//     final random = Random();
//     return String.fromCharCodes(
//       Iterable.generate(
//         length,
//             (_) => chars.codeUnitAt(random.nextInt(chars.length)),
//       ),
//     );
//   }
//
//   DateTime? _lastDetectionTime;
//   int _frameCount = 0;
//   int _detectionFrameCount = 0;
//   bool _isCapturing = false;
//   var isProcessImage = false.obs;
//
//   // ⭐ Store ALL captured frames without processing
//   final List<Map<String, dynamic>> rawCapturedFrames = [];
//
//   final List<DateTime> timestamps = [];
//   final Duration detectionIdleReset = Duration(
//     milliseconds: Platform.isIOS ? 1600 : 500,
//   );
//   final int captureEveryNDetections = Platform.isIOS ? 40 : 5;
//
//   /// Initialize video recording if video mode is enabled
//   initVideoRecord() async {
//     String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//     String randomSuffix = generateRandomString(6);
//     String fileName = 'ScanVideo_${timestamp}_$randomSuffix';
//     if (isVideoMode.value && !isUploadedVideo.value) {
//       try {
//         bool started = await FlutterScreenRecording.startRecordScreenAndAudio(
//           fileName,
//         );
//         print('🎥 Video recording started: $started');
//       } catch (e) {
//         print('❌ Error starting video recording: $e');
//       }
//     }
//   }
//
//   /// ⭐ NEW: Process uploaded video frame by frame
//   Future<void> processUploadedVideo(String videoPath) async {
//     try {
//       print('🎬 Starting video processing: $videoPath');
//
//       // Reset progress
//       processingProgress.value = 0.0;
//       currentFrame.value = 0;
//       totalFrames.value = 0;
//       processingStatus.value = 'Initializing...';
//
//       // Show processing dialog
//       _showProcessingDialog();
//
//       // Initialize YOLO model for processing
//       processingStatus.value = 'Loading AI model...';
//       uploadedVideoYolo = YOLO(
//         modelPath: Platform.isAndroid ? 'best_8s_float32.tflite' : 'best',
//         task: YOLOTask.detect,
//       );
//
//       bool modelLoaded = await uploadedVideoYolo!.loadModel();
//       if (!modelLoaded) {
//         throw Exception('Failed to load YOLO model');
//       }
//       print('✅ YOLO model loaded for video processing');
//
//       // Extract frames from video using FFmpeg
//       await _extractAndProcessFrames(videoPath);
//
//       // Close processing dialog
//       Get.back();
//
//       // Process all captured frames to remove duplicates
//       if (rawCapturedFrames.isNotEmpty) {
//         isProcessImage.value = true;
//         print('✅ YOLO model IsLoading${isProcessImage.value}');
//         await _processAllCapturedFrames();
//         isProcessImage.value = false;
//       }
//
//       // Navigate to results screen
//       Get.back();
//       print('➡️ Moving to damage screen');
//       Get.to(() => DamageScreen());
//
//     } catch (e) {
//       print('❌ Error processing uploaded video: $e');
//       Get.back(); // Close dialog
//
//       ScaffoldMessenger.of(Get.context!).showSnackBar(
//         SnackBar(
//           content: Text('❌ Failed to process video: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   /// Show processing dialog with progress
//   /*void _showProcessingDialog() {
//     Get.dialog(
//       WillPopScope(
//         onWillPop: () async => false,
//         child: Center(
//           child: Container(
//             margin: EdgeInsets.symmetric(horizontal: 40),
//             padding: EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: AppColors.background,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Circular Progress Indicator
//                 SizedBox(
//                   width: 80,
//                   height: 80,
//                   child: Obx(() => Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         value: processingProgress.value,
//                         strokeWidth: 6,
//                         backgroundColor: AppColors.primary,
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           AppColors.white,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           '${(processingProgress.value * 100).toInt()}%',
//                           style: TextStyle(
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                       ),
//                     ],
//                   )),
//                 ),
//                 SizedBox(height: 24),
//
//                 // Title
//                 Text(
//                   'Processing Video',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: white
//                   ),
//                 ),
//                 SizedBox(height: 12),
//
//                 // Status
//                 Obx(() => Text(
//                   processingStatus.value,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                   textAlign: TextAlign.center,
//                 )),
//                 SizedBox(height: 16),
//
//                 // Frame counter
//                 Obx(() => totalFrames.value > 0
//                     ? Column(
//                   children: [
//                     LinearProgressIndicator(
//                       value: currentFrame.value / totalFrames.value,
//                       backgroundColor: Colors.grey[200],
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         AppColors.primary,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Frame ${currentFrame.value} / ${totalFrames.value}',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[500],
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     *//*Obx(() =>*//* Text(
//                       'Detections found: ${rawCapturedFrames.length}',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.green[700],
//                       ),
//                     )*//*),*//*
//                   ],
//                 )
//                     : SizedBox.shrink()),
//               ],
//             ),
//           ),
//         ),
//       ),
//       barrierDismissible: false,
//     );
//   }*/
//
//   void _showProcessingDialog() {
//     Get.dialog(
//       WillPopScope(
//         onWillPop: () async => false,
//         child: Obx(
//             ()=>isProcessImage.value?Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//               CircularProgressIndicator(),
//               'Similarity Check Please Wait...........'.customText(
//                 size: 14.sp,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.primary,
//               ),
//             ],):Center(
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 36),
//               padding: const EdgeInsets.all(28),
//               decoration: BoxDecoration(
//                 color: AppColors.background,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: AppColors.fieldBorder),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.25),
//                     blurRadius: 30,
//                     offset: const Offset(0, 12),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//
//                   /// 🔄 Circular Progress
//                   SizedBox(
//                     width: 150,
//                     height: 150,
//                     child: Obx(
//                           () => Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           AnimatedContainer(
//                             width: 160,
//                             height: 160,
//                             duration: const Duration(milliseconds: 300),
//                             child: CircularProgressIndicator(
//                               value: processingProgress.value,
//                               strokeWidth: 4,
//                               backgroundColor:
//                               AppColors.primary.withOpacity(0.15),
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 AppColors.primary,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child:
//                               '${(processingProgress.value * 100).toInt()}%'.customText(
//                                 size: 16.sp,
//                                 fontWeight: FontWeight.w700,
//                                 color: AppColors.primary,
//                               )
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   /// 📹 Title
//                 'Processing Video'.customText(
//                     size: 14.sp,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.primary,
//                   ),
//                   const SizedBox(height: 10),
//
//                   /// 📝 Status Text
//                   Obx(
//                         () =>
//                       processingStatus.value.customText(
//                         textAlign: TextAlign.center,
//                       size: 14.sp,
//                         color: Colors.grey.shade600,
//                     ),
//                   ),
//
//                   const SizedBox(height: 22),
//
//                   /// 🎞 Frame Progress
//                   Obx(
//                         () => totalFrames.value > 0
//                         ? Column(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(6),
//                           child: LinearProgressIndicator(
//                             value: currentFrame.value /
//                                 totalFrames.value,
//                             minHeight: 6,
//                             backgroundColor:
//                             Colors.grey.shade200,
//                             valueColor:
//                             AlwaysStoppedAnimation<Color>(
//                               AppColors.primary,
//                             ),
//                           ),
//                         ),
//
//                         const SizedBox(height: 10),
//
//
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.orange.withOpacity(0.1)
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: 'Frame ${currentFrame.value} of ${totalFrames.value}'.customText(
//                               textAlign: TextAlign.center,
//                               size: 12.sp,
//                               color: Colors.orange,
//                             ),
//                           ),
//                         ),
//
//                         const SizedBox(height: 6),
//
//                         /// ✅ Detection Count
//                         Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               color: Colors.red.withOpacity(0.1)
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: 'Detections found: ${rawCapturedFrames.length}'.customText(
//                               textAlign: TextAlign.center,
//                               size: 13.sp,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.red,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                         : const SizedBox.shrink(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       barrierDismissible: false,
//     );
//   }
//
//
//   /// Extract frames and run YOLO detection with bounding boxes
//   Future<void> _extractAndProcessFrames(String videoPath) async {
//     try {
//       processingStatus.value = 'Extracting frames...';
//
//       final tempDir = await getTemporaryDirectory();
//       final framesDir = Directory('${tempDir.path}/video_frames');
//
//       if (await framesDir.exists()) {
//         await framesDir.delete(recursive: true);
//       }
//       await framesDir.create();
//
//       print('📁 Frames directory: ${framesDir.path}');
//
//       // Extract frames at 2 FPS (1 frame every 0.5 seconds)
//       final String outputPattern = '${framesDir.path}/frame_%04d.jpg';
//
//       final session = await FFmpegKit.execute(
//         '-i "$videoPath" -vf "fps=2,scale=640:-1" -q:v 2 "$outputPattern"',
//       );
//
//       final returnCode = await session.getReturnCode();
//
//       if (!ReturnCode.isSuccess(returnCode)) {
//         throw Exception('FFmpeg frame extraction failed');
//       }
//
//       print('✅ Frames extracted successfully');
//
//       // Get all extracted frame files
//       final frameFiles = framesDir
//           .listSync()
//           .whereType<File>()
//           .where((f) => f.path.endsWith('.jpg'))
//           .toList();
//
//       frameFiles.sort((a, b) => a.path.compareTo(b.path));
//
//       totalFrames.value = frameFiles.length;
//       print('📊 Total frames extracted: ${frameFiles.length}');
//
//       processingStatus.value = 'Detecting damages...';
//
//       // Process each frame with YOLO
//       for (var i = 0; i < frameFiles.length; i++) {
//         currentFrame.value = i + 1;
//         processingProgress.value = (i + 1) / frameFiles.length;
//
//         final frameFile = frameFiles[i];
//
//         // Read frame as bytes
//         final imageBytes = await frameFile.readAsBytes();
//
//         // Run YOLO detection
//         final results = await uploadedVideoYolo!.predict(
//           imageBytes,
//           confidenceThreshold: _confThreshold,
//           iouThreshold: _iouThreshold,
//         );
//
//         // Check if there are valid detections (excluding "object" class)
//         final detections = results['detections'] as List<dynamic>? ?? [];
//         final validDetections = detections.where((d) {
//           final className = d['className']?.toString().toLowerCase() ?? '';
//           return className != 'object';
//         }).toList();
//
//         if (validDetections.isNotEmpty) {
//           print('🔍 Frame ${i + 1}: Found ${validDetections.length} detections');
//
//           // ⭐ Draw bounding boxes on the frame
//           final imageWithBoxes = await _drawBoundingBoxes(
//             imageBytes,
//             validDetections,
//           );
//
//           // Add frame to raw captured frames
//           damageNo.value++;
//           rawCapturedFrames.add({
//             'image': imageWithBoxes,
//             'name': 'Detection ${damageNo.value}',
//             'timestamp': DateTime.now(),
//           });
//
//           processingStatus.value =
//           'Found ${rawCapturedFrames.length} damage(s)...';
//         }
//
//         // Update progress
//         if ((i + 1) % 10 == 0) {
//           print('📊 Progress: ${i + 1}/${frameFiles.length} frames processed');
//         }
//       }
//
//       // Clean up frames directory
//       await framesDir.delete(recursive: true);
//       print('🧹 Cleaned up temporary frames');
//
//     } catch (e) {
//       print('❌ Error extracting/processing frames: $e');
//       rethrow;
//     }
//   }
//
//   /// ⭐ Draw bounding boxes on image
//   Future<Uint8List> _drawBoundingBoxes(
//       Uint8List imageBytes,
//       List<dynamic> detections,
//       ) async {
//     try {
//       // Decode image
//       final codec = await ui.instantiateImageCodec(imageBytes);
//       final frame = await codec.getNextFrame();
//       final image = frame.image;
//
//       // Create canvas
//       final recorder = ui.PictureRecorder();
//       final canvas = Canvas(recorder);
//
//       // Draw original image
//       canvas.drawImage(image, Offset.zero, Paint());
//
//       // Draw each detection
//       for (var detection in detections) {
//         final box = detection['box'] as Map<String, dynamic>;
//         final className = detection['className']?.toString() ?? 'Unknown';
//         final confidence = (detection['confidence'] as num?)?.toDouble() ?? 0.0;
//
//         final x1 = (box['x1'] as num).toDouble();
//         final y1 = (box['y1'] as num).toDouble();
//         final x2 = (box['x2'] as num).toDouble();
//         final y2 = (box['y2'] as num).toDouble();
//
//         // Draw bounding box
//         final paint = Paint()
//           ..color = AppColors.primary
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 3.0;
//
//         canvas.drawRect(
//           Rect.fromLTRB(x1, y1, x2, y2),
//           paint,
//         );
//
//         // Draw label background
//         final label = '$className ${(confidence * 100).toInt()}%';
//         final textPainter = TextPainter(
//           text: TextSpan(
//             text: label,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           textDirection: TextDirection.ltr,
//         );
//         textPainter.layout();
//
//         final labelWidth = textPainter.width + 8;
//         final labelHeight = textPainter.height + 4;
//
//         // Draw label background
//         canvas.drawRect(
//           Rect.fromLTWH(x1, y1 - labelHeight, labelWidth, labelHeight),
//           Paint()..color = Colors.red,
//         );
//
//         // Draw label text
//         textPainter.paint(canvas, Offset(x1 + 4, y1 - labelHeight + 2));
//       }
//
//       // Convert canvas to image
//       final picture = recorder.endRecording();
//       final img = await picture.toImage(
//         image.width,
//         image.height,
//       );
//
//       // Convert to bytes
//       final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
//       return byteData!.buffer.asUint8List();
//     } catch (e) {
//       print('❌ Error drawing bounding boxes: $e');
//       return imageBytes; // Return original if drawing fails
//     }
//   }
//
//   /// ⭐ Quick capture without hash processing
//   void _addRawCapturedImage(Uint8List imageBytes, String name) {
//     print("🟢 Raw capture added: $name");
//
//     rawCapturedFrames.add({
//       'image': imageBytes,
//       'name': name,
//       'timestamp': DateTime.now(),
//     });
//   }
//
//   /// ⭐ Process all captured frames and remove duplicates
//   Future<void> _processAllCapturedFrames() async {
//     if (rawCapturedFrames.isEmpty) {
//       print("ℹ️ No frames to process");
//       return;
//     }
//
//     print("🔄 Processing ${rawCapturedFrames.length} captured frames...");
//
//     // Show processing dialog
//     showDialog(
//       context: Get.context!,
//       barrierDismissible: false,
//       builder: (context) => WillPopScope(
//         onWillPop: () async => false,
//         child: Center(
//           child: Container(
//             padding: EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 16),
//                 Text(
//                   'Processing images...',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Removing duplicates',
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//
//     try {
//       // Clear previous captures
//       captureImages.clear();
//
//       int duplicatesRemoved = 0;
//       int processed = 0;
//
//       for (var frame in rawCapturedFrames) {
//         processed++;
//         Uint8List imageBytes = frame['image'];
//         String name = frame['name'];
//
//         // Generate hash for current frame
//         String newHash = ImageHash.getHash(imageBytes);
//
//         if (newHash.isEmpty) {
//           print("⚠️ Failed to generate hash for: $name");
//           continue;
//         }
//
//         bool isDuplicate = false;
//
//         // Check against already processed unique images
//         for (var existingImg in captureImages) {
//           String existingHash = existingImg['hash'] ?? '';
//
//           if (existingHash.isEmpty) continue;
//
//           // Calculate similarity percentage
//           double similarity = ImageHash.similarity(newHash, existingHash);
//
//           // Check if it's a duplicate (>70% similar)
//           if (similarity > 75) {
//             print(
//               "⛔ Duplicate found: $name (${similarity.toStringAsFixed(2)}% similar to ${existingImg['name']})",
//             );
//             isDuplicate = true;
//             duplicatesRemoved++;
//             break;
//           }
//         }
//
//         // If not duplicate, add to final list
//         if (!isDuplicate) {
//           captureImages.add({
//             'image': imageBytes,
//             'name': name,
//             'hash': newHash,
//           });
//           print("✅ Unique image added: $name");
//         }
//       }
//
//       print("✅ Processing complete!");
//       print("📊 Total frames: ${rawCapturedFrames.length}");
//       print("📊 Unique images: ${captureImages.length}");
//       print("📊 Duplicates removed: $duplicatesRemoved");
//
//       update();
//
//       // Close processing dialog
//       Get.back();
//
//       // Show completion snackbar
//       ScaffoldMessenger.of(Get.context!).showSnackBar(
//         SnackBar(
//           content: Text(
//             '✅ Processed: ${captureImages.length} unique images (${duplicatesRemoved} duplicates removed)',
//           ),
//           duration: Duration(seconds: 2),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       print("❌ Error processing frames: $e");
//       Get.back();
//
//       ScaffoldMessenger.of(Get.context!).showSnackBar(
//         SnackBar(
//           content: Text('❌ Error processing images: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   /// ⭐ Capture image from YOLO frame (No hash processing)
//   void captureImage({required bool isManual}) async {
//     if (_isCapturing) {
//       print("⚠️ Already capturing, skipping...");
//       return;
//     }
//
//     _isCapturing = true;
//
//     try {
//       damageNo.value++;
//       var captured = await yoloController.captureFrame();
//
//       if (captured == null) {
//         print("❌ Failed to capture frame");
//         _isCapturing = false;
//         return;
//       }
//
//       Uint8List imageBytes = Uint8List.fromList(captured);
//
//       String name = isManual
//           ? 'Manual ${damageNo.value}'
//           : 'Detection ${damageNo.value}';
//
//       // ⭐ Just store raw image, no processing
//       _addRawCapturedImage(imageBytes, name);
//
//       // Show brief feedback for manual captures
//       if (isManual) {
//         ScaffoldMessenger.of(Get.context!).showSnackBar(
//           SnackBar(
//             content: Text('📸 Captured: $name'),
//             duration: Duration(milliseconds: 800),
//             behavior: SnackBarBehavior.floating,
//             margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
//           ),
//         );
//       }
//     } catch (e) {
//       print('❌ Error during image capture: $e');
//     } finally {
//       _isCapturing = false;
//     }
//   }
//
//   void convertForIos(Uint8List? image, bool? isManual) async {
//     final dir = await getTemporaryDirectory();
//     final file = File(
//       '${dir.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
//     );
//     await file.writeAsBytes(image!, flush: true);
//     print('wrote screenshot to ${file.path}');
//     captureFile.add(file.path);
//     captureImages.add({
//       'image': image,
//       'name': isManual!
//           ? 'Manual ${damageNo.value}'
//           : 'Detection ${damageNo.value}',
//     });
//   }
//
//   /// ⭐ Show damage detected popup
//   void _showDamageDetectedPopup() {
//     showDialog(
//       context: Get.context!,
//       barrierDismissible: true,
//       builder: (context) => Center(
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             margin: EdgeInsets.symmetric(horizontal: 40),
//             padding: EdgeInsets.all(32),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 20,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.red.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.warning_amber_rounded,
//                     size: 60,
//                     color: Colors.red,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Damage Detected!',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   'Frame captured successfully',
//                   style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//
//     Future.delayed(Duration(milliseconds: 1500), () {
//       if (Navigator.canPop(Get.context!)) {
//         Get.back();
//       }
//     });
//   }
//
//   /// ⭐ YOLO Result Callback - handles automatic detection
//   void onResult(List<YOLOResult> result) {
//     final now = DateTime.now();
//
//     if (now.difference(_lastUpdate).inMilliseconds < (1000 / _maxFps)) {
//       return;
//     }
//     _lastUpdate = now;
//
//     timestamps.add(now);
//     while (timestamps.isNotEmpty &&
//         now.difference(timestamps.first) > Duration(seconds: 1)) {
//       timestamps.removeAt(0);
//     }
//
//     _frameCount++;
//
//     List<YOLOResult> validDetections = result.where((detection) {
//       return detection.className.toLowerCase() != 'object';
//     }).toList();
//
//     if (validDetections.isNotEmpty) {
//       print(
//         '🔍 Found ${validDetections.length} valid damage(s) (filtered ${result.length - validDetections.length} object(s))',
//       );
//
//       _lastDetectionTime = now;
//       _detectionFrameCount++;
//
//       if (_lastDetectionTime != null &&
//           now.difference(_lastDetectionTime!) > detectionIdleReset) {
//         print("⏸️ Detection idle reset");
//         _detectionFrameCount = 1;
//       }
//
//       if (_detectionFrameCount % captureEveryNDetections == 0) {
//         print(
//           "📸 Auto-capture triggered (every $captureEveryNDetections detections)",
//         );
//         showDamageConfirmationDialog();
//       }
//     } else {
//       if (_lastDetectionTime != null &&
//           now.difference(_lastDetectionTime!) > detectionIdleReset) {
//         print("🔄 Resetting detection counter (no valid damage detected)");
//         _detectionFrameCount = 0;
//         _lastDetectionTime = null;
//       }
//     }
//
//     resultsNotifier.value = validDetections;
//   }
//
//   Future<void> showDamageConfirmationDialog() async {
//     if (_isShowingConfirmationDialog) {
//       print("⚠️ Dialog already showing, skipping...");
//       return;
//     }
//
//     _isDetectionPaused = true;
//     _isShowingConfirmationDialog = true;
//
//     await showDialog<bool>(
//       context: Get.context!,
//       barrierDismissible: false,
//       builder: (context) => WillPopScope(
//         onWillPop: () async => false,
//         child: Center(
//           child: Material(
//             color: Colors.transparent,
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 40),
//               padding: EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 20,
//                     offset: Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.orange.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.warning_amber_rounded,
//                       size: 60,
//                       color: Colors.orange,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Damage Detected!',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.orange[800],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 12),
//                   Text(
//                     'Do you want to save this damage frame?',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[700],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 24),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.grey[300],
//                             foregroundColor: Colors.black87,
//                             padding: EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: Text(
//                             'No',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             captureImage(isManual: false);
//                             Navigator.of(context).pop();
//                             ScaffoldMessenger.of(Get.context!).showSnackBar(
//                               SnackBar(
//                                 content: Text('✅ Damage frame saved'),
//                                 duration: Duration(milliseconds: 1000),
//                                 backgroundColor: AppColors.primary,
//                                 behavior: SnackBarBehavior.floating,
//                                 margin: EdgeInsets.only(
//                                     bottom: 100, left: 20, right: 20),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primary,
//                             foregroundColor: Colors.white,
//                             padding: EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: Text(
//                             'Yes, Save',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//
//     _isShowingConfirmationDialog = false;
//
//     print("⏳ Starting cooldown period (2 seconds)...");
//     await Future.delayed(Duration(seconds: 2));
//     _isDetectionPaused = false;
//     _detectionFrameCount = 0;
//     print("▶️ Detection RESUMED after cooldown");
//   }
//
//   Future<void> stopRecordingSafely() async {
//     try {
//       print("🛑 Stopping video recording...");
//       String path = await FlutterScreenRecording.stopRecordScreen;
//       final file = File(path);
//       final exists = await file.exists();
//
//       if (exists) {
//         print('✅ Video saved at: $path');
//         videoPath.value = path;
//       } else {
//         print('⚠️ Video file not found at: $path');
//       }
//     } catch (e) {
//       debugPrint("❌ Stop recording failed: $e");
//     }
//   }
//
//   /// ⭐ Handle end of scanning session with duplicate processing
//   Future<void> endScanningSession() async {
//     try {
//       if (isVideoMode.value && !isUploadedVideo.value) {
//         await stopRecordingSafely();
//         await yoloController.stop();
//       }
//
//       // ⭐ Process all captured frames to remove duplicates
//       if (rawCapturedFrames.isNotEmpty) {
//         await _processAllCapturedFrames();
//       }
//
//       // Navigate based on capture mode
//       if (!isVideoMode.value && captureImages.isEmpty && !isUploadedVideo.value) {
//         print("ℹ️ No images captured, returning to previous screen");
//         Get.back();
//       } else {
//         print("➡️ Moving to survey detail view");
//         await yoloController.stop();
//         Get.to(() => DamageScreen());
//       }
//     } catch (e) {
//       print("❌ Error ending session: $e");
//       Get.back();
//     }
//   }
//
//   String _getFileSizeString(int bytes) {
//     if (bytes < 1024) return '$bytes B';
//     if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
//     if (bytes < 1024 * 1024 * 1024)
//       return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
//     return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
//   }
//
//   void analyzeDetectImage({Uint8List? imageBytes}) async {
//     isLoadingImage.value = true;
//     isLoadingImage.value = await YoloRepo.analyzeImageApi(bodyData: {
//       'image': imageBytes,
//     });
//     if (YoloRepo.dummyAnalyzeResponseList != null) {
//       Console.Log(
//           title: YoloRepo.dummyAnalyzeResponseList[0].mediaUrl,
//           message: "DummyAnalyzeListYOLOOOOOOOO>>>>>>>>>>>>>>>>>");
//       dummyAnalyzeResponseListValue.value = YoloRepo.dummyAnalyzeResponseList;
//       Console.Log(
//           title: dummyAnalyzeResponseListValue[0].analysis,
//           message: "DummyAnalyzeList>>>>>>>>>>>>>>>>>");
//     }
//   }
//
//   void editImageName(int index, String newName) {
//     if (index >= 0 && index < captureImages.length) {
//       captureImages[index]['name'] = newName;
//       captureImages.refresh();
//     }
//   }
//
//   void deleteImage(int index) {
//     if (index >= 0 && index < captureImages.length) {
//       captureImages.removeAt(index);
//     }
//   }
//
//   @override
//   void onClose() {
//     captureImages.clear();
//     captureFile.clear();
//     rawCapturedFrames.clear();
//     videoPath.value = '';
//     uploadedVideoPath.value = '';
//     pdfPath.value = '';
//     damageNo.value = 0;
//     isUploadedVideo.value = false;
//     processingProgress.value = 0.0;
//     currentFrame.value = 0;
//     totalFrames.value = 0;
//     uploadedVideoYolo?.dispose();
//     print("OnClose>>>>>>");
//     super.onClose();
//   }
// }
