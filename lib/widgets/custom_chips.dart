import 'package:flutter/cupertino.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:sizer/sizer.dart';

import '../utils/bounce_widget.dart';
import '../utils/colors.dart';

class CustomChips extends StatelessWidget {
  Function()? onTap;
  final String title;
  final Color? boxColor, textColor, chipColor;
  double? width, height;
  FontWeight? fontWeight;
  bool? isArrow;

  CustomChips({
    super.key,
    required this.title,
    this.textColor,
    this.boxColor,
    this.onTap,
    this.chipColor,
    this.width,
    this.height,
    this.fontWeight,
    this.isArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingItem(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width ?? 10.sp),
        height: height ?? 5.h,
        decoration: BoxDecoration(
          border: Border.all(color: boxColor ?? black),
          borderRadius: BorderRadius.circular(17.sp),
          color: chipColor ?? white,
        ),
        alignment: Alignment.center,
        child: Row(
          children: [
            title.customText(
              size: 11.sp,
              fontWeight: fontWeight ?? FontWeight.w400,
              color: textColor ?? const Color(0xFF7D7D7D),
            ),
            Visibility(
              visible: isArrow!,
              child: 'assets/icons/arrow_down.png'
                  .customImage(
                    scale: 3,
                    color: appBarColor,
                  )
                  .paddingLeft(10),
            )
          ],
        ),
      ),
    );
  }
}
