import 'dart:typed_data';
import 'package:image/image.dart' as img;

/**
 * Created by Jaimin on 28/11/25.
 * Image Hash Helper for Duplicate Detection
 */

class ImageHash {
  static const double SIMILARITY_THRESHOLD = 70.0; // 70% similarity

  /// Generate perceptual hash for an image
  static String getHash(Uint8List imageBytes) {
    try {
      // Decode image
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) return '';

      // Resize to 8x8 for faster comparison
      img.Image resized = img.copyResize(image, width: 8, height: 8);

      // Convert to grayscale
      img.Image grayscale = img.grayscale(resized);

      // Calculate average pixel value
      int sum = 0;
      for (int y = 0; y < 8; y++) {
        for (int x = 0; x < 8; x++) {
          var pixel = grayscale.getPixel(x, y);
          sum += pixel.r.toInt();
        }
      }
      int average = sum ~/ 64;

      // Generate hash based on whether pixel is above or below average
      String hash = '';
      for (int y = 0; y < 8; y++) {
        for (int x = 0; x < 8; x++) {
          var pixel = grayscale.getPixel(x, y);
          hash += pixel.r.toInt() >= average ? '1' : '0';
        }
      }

      return hash;
    } catch (e) {
      print('❌ Error generating hash: $e');
      return '';
    }
  }

  /// Calculate similarity between two hashes (returns percentage 0-100)
  static double similarity(String hash1, String hash2) {
    if (hash1.isEmpty || hash2.isEmpty || hash1.length != hash2.length) {
      return 0.0;
    }

    int matches = 0;
    for (int i = 0; i < hash1.length; i++) {
      if (hash1[i] == hash2[i]) {
        matches++;
      }
    }

    return (matches / hash1.length) * 100.0;
  }

  /// Check if image is duplicate (batch processing version)
  static bool isDuplicate(
      Uint8List newImageBytes,
      List<Map<String, dynamic>> existingImages,
      ) {
    String newHash = getHash(newImageBytes);

    if (newHash.isEmpty) return false;

    for (var existing in existingImages) {
      String existingHash = existing['hash'] ?? '';

      if (existingHash.isEmpty) continue;

      // Calculate similarity percentage
      double similarityPercent = similarity(newHash, existingHash);

      // If similarity is above threshold, it's a duplicate
      if (similarityPercent >= SIMILARITY_THRESHOLD) {
        print('⛔ Duplicate detected! Similarity: ${similarityPercent.toStringAsFixed(2)}%');
        return true;
      }
    }

    return false;
  }
}