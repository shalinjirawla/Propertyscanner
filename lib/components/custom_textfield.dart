import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/theme/app_colors.dart';
import 'package:sizer/sizer.dart';

import '../utils/colors.dart';
import '../utils/config.dart';
class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    this.controller,
    this.hintName,
    this.prefix,
    this.suffix,
    this.maxLine,
    this.fillColor,
    this.hintColor,
    this.textColor,
    this.readOnly = false,
    this.keyboardType,
    this.maxLength,
    this.cursorColor,
    this.errorText,
    this.textFieldHeight,
    this.validator,
    this.contentPadding,
    this.textInputAction,
    this.inputFormatters,
    this.textCapitalization,
    this.onTap,
    this.obscureText = false,
    this.onChanged,
  });

  String? hintName, errorText;
  TextEditingController? controller;
  Widget? prefix, suffix;
  int? maxLine, maxLength;
  TextInputType? keyboardType;
  double? textFieldHeight;
  EdgeInsetsGeometry? contentPadding;
  TextInputAction? textInputAction;
  TextCapitalization? textCapitalization;
  bool? readOnly;
  String? Function(String?)? validator;
  Color? fillColor, textColor, hintColor, cursorColor;
  List<TextInputFormatter>? inputFormatters;
  void Function()? onTap;
  Function(String)? onChanged;
  bool obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: textFieldHeight,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly!,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        keyboardType: keyboardType,
        maxLength: maxLength,
        cursorColor: cursorColor ?? white,
        obscureText: obscureText,
        validator: validator,
        onTap: onTap,
        textInputAction: textInputAction,
        // Use validator instead of errorText
        inputFormatters: inputFormatters ?? _getInputFormatters(),
        style: TextStyle(
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
            color: textColor ?? white,
            fontFamily: fontFamily),
        textAlignVertical: TextAlignVertical.center,
        maxLines: maxLine ?? 1,
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: fillColor ?? AppColors.divider,
          contentPadding: contentPadding,
          prefixIcon: prefix,
/*          error: errorText == null
              ? SizedBox.shrink()
              : errorText?.customText(
                  color: redColor, size: 9.sp, fontWeight: FontWeight.w600),*/
          suffixIcon: suffix,
          counter: const SizedBox.shrink(),
          suffixIconConstraints: const BoxConstraints(maxWidth: 90),
          prefixIconConstraints: const BoxConstraints(maxWidth: 70),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.sp),
              borderSide: BorderSide(
                color: AppColors.textSecondary,
                width: 1
              )),
          hintText: hintName,
          errorStyle: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              fontFamily: fontFamily),
          hintStyle: TextStyle(
            fontSize: 11.sp,
            color: hintColor ?? AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),
    );
  }

  List<TextInputFormatter> _getInputFormatters() {
    if (keyboardType == TextInputType.number) {
      return [FilteringTextInputFormatter.digitsOnly]; // Only numbers
    }
    return [];
  }
}
class TextFieldWithName extends StatelessWidget {
  TextFieldWithName({
    super.key,
    this.prefixIcon,
    this.fieldName,
    this.hintText,
    this.suffixIcon,
    this.maxLine,
    this.controller,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.containerColor,
    this.headingColor,
    this.imp,
    this.readOnly = false,
    this.isSuffixText = false,
    this.keyboardType,
    this.maxLength,
    this.cursorColor,
    this.errorText,
    this.validator,
    this.textInputAction,
    this.inputFormatters,
    this.textCapitalization,
    this.suffixIconColor,
    this.onTap,
    this.obscureText = false,
    this.iconTap,
    this.onChanged,
  });

  String? prefixIcon, fieldName, hintText, suffixIcon, imp, errorText;
  TextEditingController? controller;
  int? maxLine, maxLength;
  bool? readOnly, isSuffixText;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  String? Function(String?)? validator;
  List<TextInputFormatter>? inputFormatters;
  bool obscureText;
  void Function()? onTap;
  Color? fillColor,
      textColor,
      hintColor,
      containerColor,
      headingColor,
      cursorColor,
      suffixIconColor;
  TextCapitalization? textCapitalization;
  void Function()? iconTap;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            fieldName!.customText(
                size: 12.sp,
                color: headingColor ?? AppColors.white,
                fontWeight: FontWeight.w600),
            (imp ?? "").customText(
                size: 10.sp, color: redButtonColor, fontWeight: FontWeight.w600)
          ],
        ),
        5.height,
        CustomTextField(
          controller: controller,
          readOnly: readOnly,
          fillColor: fillColor,
          onTap: onTap,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          cursorColor: cursorColor,
          textCapitalization: textCapitalization,
          errorText: errorText,
          maxLength: maxLength,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          validator: validator ?? _getValidator(),
          suffix: suffixIcon == null
              ? const SizedBox.shrink()
              : isSuffixText!
              ? suffixIcon!
              .customText(
            size: 11.sp,
            color: suffixIconColor ?? primaryColor,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          )
              .paddingRight(10.sp)
              : GestureDetector(
            onTap: iconTap,
            child: suffixIcon!
                .customImage(
                scale: 3.5, color: suffixIconColor ?? white)
                .paddingRight(11.sp),
          ),
          maxLine: maxLine,
          textColor: textColor,
          hintColor: hintColor,
          prefix: prefixIcon == null
              ? 20.width
              : Row(
            children: [
              prefixIcon!.customImage(scale: 3.5),
              13.width,
              Container(
                height: 25,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5, color: containerColor ?? lightGrey)),
              )
            ],
          ).paddingOnly(left: 11.sp),
          hintName: hintText,
        )
      ],
    );
  }

  String? Function(String?)? _getValidator() {
    if (keyboardType == TextInputType.emailAddress) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      };
    } else if (keyboardType == TextInputType.number) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required';
        }
        final phoneRegex = RegExp(r'^[0-9]{10}$');
        if (!phoneRegex.hasMatch(value)) {
          return 'Enter a valid 10-digit phone number';
        }
        return null;
      };
    } else if (keyboardType == TextInputType.name) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      };
    } else if (keyboardType == TextInputType.streetAddress) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Blood group is required';
        }
        return null;
      };
    }
    return null;
  }
}