/**
 * Created by Jaimin on 01/01/25.
 */

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import '../widgets/custom_log.dart';
import 'colors.dart';
import 'config.dart';

class ImageCropperView extends StatefulWidget {
  String? image;

  ImageCropperView({Key? key, this.image}) : super(key: key);

  @override
  State<ImageCropperView> createState() => _ImageCropperViewState();
}

class _ImageCropperViewState extends State<ImageCropperView> {
  final controller = CropController(
    aspectRatio: 603 / 105,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );
  //var supportController = Get.put(SupportController());

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: _buildButtons()),
          body: Center(
            child: CropImage(
              controller: controller,
              image: Image.file(File(widget.image!)),
              paddingSize: 25.0,
              alwaysMove: true,
              minimumImageSize: 105,
              maximumImageSize: 603,
            ),
          ),
          //bottomNavigationBar: _buildButtons(),
        ),
      );

  Widget _buildButtons() => Container(
        decoration: BoxDecoration(color: white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _resetCrop,
            ),
            IconButton(
              icon: const Icon(Icons.rotate_90_degrees_ccw_outlined),
              onPressed: _rotateLeft,
            ),
            IconButton(
              icon: const Icon(Icons.rotate_90_degrees_cw_outlined),
              onPressed: _rotateRight,
            ),
            TextButton(
              onPressed: _finished,
              child: Text(
                'Done',
                style: TextStyle(
                  color: appBarColor,
                  fontFamily: fontFamily,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
      );

  void _resetCrop() {
    controller.rotation = CropRotation.up;
    controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
    controller.aspectRatio = 603 / 105;
    Get.back();
  }

  Future<void> _rotateLeft() async => controller.rotateLeft();

  Future<void> _rotateRight() async => controller.rotateRight();

  Future<void> _finished() async {
    final image = await controller.croppedImage();
    final filePath = await _saveCroppedImageToFile(image);
    Console.Log(title: 'cropped image', message: filePath);
    // supportController.selectedFile.value = filePath;
    // supportController.pickedFileName.value = 'cropped_banner_image.png';
    // supportController.update(['file']);
    // Console.Log(
    //     title: 'cropped image selected',
    //     message: supportController.selectedFile);
    Get.back();
  }

  Future<String> _saveCroppedImageToFile(Widget imageWidget) async {
    final renderObject = (imageWidget as Image).image;
    final completer = Completer<img.Image>();

    renderObject
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      final byteData = info.image.toByteData(format: ImageByteFormat.png);
      byteData.then((data) {
        final bytes = data!.buffer.asUint8List();
        final decodedImage = img.decodeImage(bytes);
        completer.complete(decodedImage);
      });
    }));

    final croppedImage = await completer.future;
    final resizedImage = img.copyResize(
      croppedImage,
      width: 603,
      height: 105, // Ensure the resized image matches exact dimensions
    );
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/cropped_ad_image.png');
    file.writeAsBytesSync(img.encodePng(resizedImage));

    return file.path;
  }
}
