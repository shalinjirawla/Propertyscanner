import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/Extentions.dart';
import '../utils/Height_Width.dart';
import '../utils/bounce_widget.dart';
import '../utils/colors.dart';
import '../utils/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    this.buttonHeight,
    this.buttonWidth,
    required this.buttonName,
    required this.onPressed,
    this.buttonColor,
    this.textColor,
    this.isImage = false,
    this.isIcon = false,
    this.points,
    this.isSupportADs = false,
    super.key,
  });

  final String buttonName;
  final void Function()? onPressed;
  final double? buttonWidth;
  final double? buttonHeight;
  final Color? buttonColor;
  final Color? textColor;
  final bool? isImage, isIcon;
  final String? points;
  final bool isSupportADs;

  @override
  Widget build(BuildContext context) {
    return Bouncing(
      onTap: onPressed,
      child: Container(
          width: buttonWidth ?? double.infinity,
          height: buttonHeight ?? 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.sp),
            color: buttonColor ?? primaryColor,
            border: Border.all(
              color: isSupportADs ? transparentColor : primaryColor,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isIcon!,
                child: Image.asset(
                  "assets/icons/ad_icon.png",
                  height: 7.h,
                  width: 7.w,
                ).paddingRight(10),
              ),
              Text(
                buttonName,
                style: primaryTextStyle(
                  color: textColor ?? white,
                  weight: FontWeight.w600,
                  letterSpacing: 0.3,
                  size: 14.sp.toInt(),
                ),
              ),
              isImage!
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/notification_coin.png",
                            height: 4.h,
                            width: 6.w,
                            color: white,
                          ),
                          3.width,
                          Text(
                            points!,
                            style: primaryTextStyle(
                              color: white,
                              size: 15.sp.toInt(),
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : shrink,
            ],
          )

          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: buttonColor ?? primaryColor,
          //
          //   ),
          //   onPressed: onPressed,
          //   child: Text(
          //     buttonName,
          //     style: primaryTextStyle(
          //       color: textColor ?? white,
          //       weight: FontWeight.w600,
          //       fontFamily: fontFamily,
          //       letterSpacing: 0.3,
          //       size: 15.sp.toInt(),
          //     ),
          //   ),
          // ),
          ),
    );
  }
}


class CustomThemeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color? iconColor;
  final double height;
  final double borderRadius;
  final bool isOutlined;
  final Color? borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomThemeButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.black,
    this.iconColor,
    this.height = 50,
    this.borderRadius = 20,
    this.isOutlined = false,
    this.borderColor,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: isOutlined
          ? OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(
          icon,
          color: iconColor ?? textColor,
          size: 27,
        )
            : const SizedBox.shrink(),
        label: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize ?? 10.sp,
            fontWeight: fontWeight ?? FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(
            color: borderColor ?? const Color(0xFF3A3A3A),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      )
          : ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(
          icon,
          color: iconColor ?? textColor,
          size: 27,
        )
            : const SizedBox.shrink(),
        label: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize ?? 10.sp,
            fontWeight: fontWeight ?? FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
