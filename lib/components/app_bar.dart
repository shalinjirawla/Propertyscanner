import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:sizer/sizer.dart';

import '../routes/app_pages.dart';
import '../utils/bounce_widget.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import 'custom_dialogs.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String? userName;
  final Widget? profileImage;
  final List<Widget>? icons;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double? iconLeft;
  final double? iconRight;
  final double? iconTop;
  final double? iconBottom;
  final bool? isProfile;
  void Function()? onBackTap;

  CustomAppBar({
    super.key,
    required this.height,
    this.userName = "",
    this.profileImage,
    this.icons,
    this.right,
    this.left,
    this.bottom,
    this.top,
    this.iconBottom,
    this.iconLeft,
    this.iconRight,
    this.iconTop,
    this.isProfile = false,
    this.onBackTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration:  BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        border: Border.all(color: hintColor,width: 1),

      ),
      child: AppBar(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark, // Ensures dark icons on white background
        surfaceTintColor: Colors.transparent,
        backgroundColor: white,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding:  EdgeInsets.only(top: 2.h),
          child: InkWell(
              onTap: onBackTap??(){
                Navigator.pop(context);
              },
              child: Padding(
                padding:  EdgeInsets.only(left: 6.w),
                child: Icon(Icons.arrow_back_ios,color: black,size: 3.h,),
              )),
        ),
        title: Padding(
          padding:  EdgeInsets.only(top: 2.h),
          child: '$userName'
              .customText(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                size: 13.sp,
              )
              .paddingBottom(7),
        ),
        actions: icons ?? [],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}



class CustomAppBarBolt extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  void Function()? onBackTap;

   CustomAppBarBolt({
    Key? key,
    required this.title,
    this.actions,
    this.onBackTap,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackTap??() => Get.back(),
      )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


class CustomDarkAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  final Color backgroundColor;
  final Color titleColor;
  final Color iconColor;
  final Color iconBgColor;
  final List<Widget>? actions;
  final double height;

  const CustomDarkAppBar({
    Key? key,
    required this.title,
    this.onBackTap,
    this.backgroundColor = const Color(0xFF2A2A2A),
    this.titleColor = Colors.white,
    this.iconColor = Colors.white,
    this.iconBgColor = const Color(0xFF3A3A3A),
    this.actions,
    this.height = 56,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: iconColor, size: 20),
            padding: EdgeInsets.zero,
            onPressed: onBackTap ?? () => Navigator.pop(context),
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: actions,
      toolbarHeight: height,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}