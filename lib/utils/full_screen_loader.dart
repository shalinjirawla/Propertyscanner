import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/utils/Extentions.dart';

import 'Height_Width.dart';
import 'bounce_widget.dart';
import 'colors.dart';

class LoadingOverlay {
  //BuildContext _context;

  void hide() {
    Get.back();
  }

  void show({BuildContext? context}) {
    showDialog(
      context: context ?? Get.context!,
      barrierDismissible: false,
      builder: (ctx) => _FullScreenLoader(),
    );
  }

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }
}

class _FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Container(
        height: Get.height,
        width: Get.width,
        color: appBarColor.withOpacity(0.2),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            // Bouncing(
            //     onTap: () {
            //       //Get.back();
            //     },
            //     child: 'assets/images/psp_logo.png'.customImage(scale: 12)),
            height1,
            'Please wait...'.customText(color: white),
          ],
        ),
      ),
    );
  }
}

class BlockScreenTap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: SizedBox(
        height: Get.height,
        width: Get.width,
      ),
    );
  }
}