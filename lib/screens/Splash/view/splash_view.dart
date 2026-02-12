import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:property_scan_pro/utils/colors.dart';
import 'package:property_scan_pro/utils/strings.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../screens/Splash/controller/splash_controller.dart';
import '../../../utils/constant_images.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../utils/theme/app_textstyle.dart';


class SplashView extends StatelessWidget {
  SplashView({super.key});

  var splashController = Get.put(SplashController());
  // var connectivityService = Get.find<ConnectivityService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Image(image: AssetImage("assets/images/p_logo.png")),
      ),
    );
  }
}
