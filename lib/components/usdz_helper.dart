/**
 * Created by Jaimin on 28/11/25.
 */

// define somewhere global / in a service
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const _roomplanChannel = MethodChannel('com.example.usdz_renderer');

Future<String?> generateUsdzThumbnail(String usdzPath) async {
  try {
    final path = await _roomplanChannel.invokeMethod<String>('renderUsdToPng', {
      'url': usdzPath,
    });
    return path;
  } on PlatformException catch (e) {
    debugPrint('Thumbnail generation failed: $e');
    return null;
  }
}
