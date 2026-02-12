import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../utils/Extentions.dart';
import '../utils/Height_Width.dart';
import '../utils/bounce_widget.dart';
import '../utils/colors.dart';
import '../utils/config.dart';
import '../utils/util.dart';
import '../widgets/custom_button.dart';

class CustomDialog {
  static void showLogOutDialog(BuildContext context
      /*DashboardController dashController*/, bool? isDelete) {
   // dashController.scaffoldKey.currentState!.closeDrawer();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        surfaceTintColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Bouncing(
                  onTap: Get.back,
                  child: Image.asset(
                    'assets/icons/cancel_icon.png',
                    scale: 3,
                  ),
                ),
              ),
              Image.asset(
                isDelete!
                    ? 'assets/icons/account_delete_icon.png'
                    : "assets/icons/logout_icon.png",
                scale: 3.5,
                filterQuality: FilterQuality.high,
              ),
              height1,
              Text(
                isDelete ? 'Delete Account' : "Log Out",
                style: primaryTextStyle(
                  size: 18.sp.toInt(),
                  color: appBarColor,
                  weight: FontWeight.w700,
                ),
              ),
              10.height,
              Text(
                isDelete!
                    ? 'Are you sure you want to delete your account?'
                    : "Are you sure you want to log out?",
                style: primaryTextStyle(
                  size: 13.sp.toInt(),
                  color: appBarColor,
                  weight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              20.height,
              Row(
                children: [
                  // Expanded(
                  //   child: Obx(
                  //     () => dashController.profileController.isLoading.value
                  //         ? CircularProgressIndicator(
                  //             color: primaryColor,
                  //           ).centerExtension()
                  //         : CustomButton(
                  //             buttonName: "Yes, I’m Sure",
                  //             onPressed: () async {
                  //               await dashController.profileController
                  //                   .logoutUser(
                  //                 isDelete: isDelete,
                  //               );
                  //             }),
                  //   ),
                  // ),
                  10.width,
                  Expanded(
                    child: CustomButton(
                      buttonName: "Cancel",
                      onPressed: Get.back,
                      textColor: appBarColor,
                      buttonColor: white,
                    ),
                  ),
                ],
              ),
              5.height,
            ],
          ),
        ),
      ),
    );
  }

  static void showConfirmLeaveDialog(BuildContext context,
      {Function()? onTap, String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        surfaceTintColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Bouncing(
                  onTap: Get.back,
                  child: Image.asset(
                    'assets/icons/cancel_icon.png',
                    scale: 3,
                  ),
                ),
              ),
              Image.asset(
                'assets/icons/exit_icon.png',
                scale: 3.5,
                filterQuality: FilterQuality.high,
              ),
              height1,
              'Are you sure you want to leave?'.customText(
                fontWeight: FontWeight.w700,
                size: 17.sp,
                textAlign: TextAlign.center,
              ),
              10.height,
              (message ?? 'Leaving this screen will your portfolio changes')
                  .customText(
                fontWeight: FontWeight.w400,
                size: 11.5.sp,
                textAlign: TextAlign.center,
              ),
              20.height,
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                        buttonName: "Yes, I’m Sure",
                        onPressed: onTap ??
                            () {
                              Get.back();
                              Get.back();
                              Get.back();
                              Get.back();
                              Get.back();
                              //Get.offAll(() => DashBoardScreen());
                            }),
                  ),
                  10.width,
                  Expanded(
                    child: CustomButton(
                      buttonName: "Cancel",
                      onPressed: Get.back,
                      textColor: appBarColor,
                      buttonColor: white,
                    ),
                  ),
                ],
              ),
              5.height,
            ],
          ),
        ),
      ),
    );
  }

  static void showCommonDialogBox({
    //BuildContext? context,
    Function()? onTap,
    Function()? onCloseTap,
    String? title,
    String? message,
    String? buttonName,
    String? image,
    double? scale,
    bool? isDismissible = false,
    bool? isPop = true,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: isDismissible ?? false,
      builder: (context) => PopScope(
        canPop: isPop ?? true,
        child: Dialog(
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.sp)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: buttonName != null,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Bouncing(
                      onTap: onCloseTap ?? Get.back,
                      child: Image.asset(
                        'assets/icons/cancel_icon.png',
                        scale: 3,
                      ).paddingOnly(right: 5, top: 5),
                    ),
                  ),
                ),
                10.height,
                Image.asset(
                  image ?? 'assets/icons/warning_icon.png',
                  scale: scale ?? 3.5,
                  filterQuality: FilterQuality.high,
                ),
                height1,
                title == null || title.isEmpty
                    ? shrink
                    : Column(
                        children: [
                          title.customText(
                            fontWeight: FontWeight.w700,
                            size: 17.sp,
                            color: white,
                            textAlign: TextAlign.center,
                          ),
                          10.height,
                        ],
                      ),
                message!.customText(
                  fontWeight: FontWeight.w400,
                  size: 11.5.sp,
                  color: white,
                  textAlign: TextAlign.center,
                ),
                20.height,
                CustomButton(
                  buttonName: buttonName ?? 'Ok',
                  onPressed: onTap ?? Get.back,
                ),
                5.height,
              ],
            ),
          ),
        ),
      ),
    );
  }



  static void showHomePageDialog({
    Function()? onTap,
    String? title,
    String? desc,
    String? imageUrl,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 🎃 Background Image (the full promo design)
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image:  DecorationImage(
                      image: NetworkImage(imageUrl??""),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // This padding allows spacing for the button inside image area
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 170), // adjust to push button near bottom
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 10),
  child: CustomButton(buttonName: "Get", onPressed: onTap),
)
                      // 🟩 Get Button (real Flutter widget)

                    ],
                  ),
                ),

                // ❌ Close Icon on top right of dialog
                Positioned(
                  top: 20,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.close, color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  static void showAlreadyLoginDialog({
    Function()? onTap,
    String? title,
    String? message,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => Dialog(
        surfaceTintColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/warning_icon.png',
                scale: 3.5,
                filterQuality: FilterQuality.high,
              ).paddingOnly(left: 10),
              height1,
              title!.customText(
                fontWeight: FontWeight.w700,
                size: 17.sp,
                textAlign: TextAlign.center,
              ),
              10.height,
              message!.customText(
                fontWeight: FontWeight.w400,
                size: 12.sp,
                textAlign: TextAlign.center,
              ),
              20.height,
              CustomButton(
                buttonName: 'Ok',
                onPressed: onTap,
              ),
              5.height,
            ],
          ),
        ),
      ),
    );
  }







  static void showUpgradeDialog({
    BuildContext? context,
    String? title,
    String? message,
    String? image,
    Function()? onTap,
  }) {
    showDialog(
      context: context!,
      barrierDismissible: true,
      builder: (context) => Dialog(
        surfaceTintColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          /* decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),*/
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              height2,
              'Upgrade Plan'
                  .customText(
                    fontWeight: FontWeight.w700,
                    size: 18.sp,
                    textAlign: TextAlign.center,
                  )
                  .paddingSymmetric(horizontal: 20),
              5.height,
              Text.rich(
                TextSpan(
                  text: 'Toro ',
                  children: [
                    TextSpan(
                      text: 'is not included in your current plan',
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),
              height1,
              Image.asset(
                'assets/images/rocket_icon.png',
                scale: 3,
              ),
              height2,
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text:
                      'You can upgrade your plan anytime and start accessing ',
                  children: [
                    TextSpan(
                      text: 'Toro',
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
              ),
              height2,
              Bouncing(
                onTap: onTap,
                child: Container(
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/star_icon.png',
                        scale: 4,
                      ),
                      5.width,
                      'Upgrade Plan'.customText(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        size: 14.sp,
                      ),
                    ],
                  ),
                ),
              ),
              height2,
            ],
          ),
        ),
      ),
    );
  }

  static void showCommonConfirmationDialog({
    BuildContext? context,
    String? title,
    String? message,
    String? image,
    Function()? onTap,
  }) {
    showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (context) => Dialog(
        surfaceTintColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Bouncing(
                  onTap: Get.back,
                  child: Image.asset(
                    'assets/icons/cancel_icon.png',
                    scale: 3,
                  ),
                ),
              ),
              Image.asset(
                image ?? 'assets/icons/warning_icon.png',
                scale: 3.5,
                filterQuality: FilterQuality.high,
              ),
              height1,
              Text(
                title!,
                style: primaryTextStyle(
                  size: 18.sp.toInt(),
                  color: appBarColor,
                  weight: FontWeight.w700,
                ),
              ),
              10.height,
              Text(
                message!,
                style: primaryTextStyle(
                  size: 13.sp.toInt(),
                  color: appBarColor,
                  weight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              20.height,
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      buttonName: "Yes, I’m Sure",
                      onPressed: onTap,
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: CustomButton(
                      buttonName: "Cancel",
                      onPressed: Get.back,
                      textColor: appBarColor,
                      buttonColor: white,
                    ),
                  ),
                ],
              ),
              5.height,
            ],
          ),
        ),
      ),
    );
  }









  static void showUpdateMaintenanceDialog({
    Function()? onTap,
    bool? isMaintenance,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => Dialog(
        surfaceTintColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isMaintenance!
                    ? 'assets/icons/maintenance_icon.png'
                    : 'assets/icons/update_app_icon.png',
                scale: 3.5,
                filterQuality: FilterQuality.high,
              ).paddingOnly(left: 10),
              height1,
              Text(
                isMaintenance ? 'Maintenance Mode' : 'Update Available',
                style: primaryTextStyle(
                  size: 18.sp.toInt(),
                  color: appBarColor,
                  weight: FontWeight.w700,
                ),
              ),
              10.height,
              Text(
                isMaintenance
                    ? 'Application is under maintenance'
                    : "Please update the application for better experience",
                style: primaryTextStyle(
                  size: 13.sp.toInt(),
                  color: appBarColor,
                  weight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              20.height,
              CustomButton(
                buttonName: isMaintenance ? 'Ok' : 'Update',
                onPressed: onTap,
              ),
              5.height,
            ],
          ),
        ),
      ),
    );
  }
}
