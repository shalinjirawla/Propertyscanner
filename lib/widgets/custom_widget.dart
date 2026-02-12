import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:sizer/sizer.dart';

import '../utils/Extentions.dart';
import '../utils/colors.dart';

final defaultPinTheme = PinTheme(
  width: 56,
  height: 60,
  padding: const EdgeInsets.symmetric(horizontal: 10),
  textStyle: primaryTextStyle(
    weight: FontWeight.w600,
    size: 16.sp.toInt(),
    color: appBarColor,
  ),
  decoration: BoxDecoration(
    color: containerColor,
    borderRadius: BorderRadius.circular(20),
  ),
);

class OTPField extends StatelessWidget {
  TextEditingController? controller;

  OTPField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Pinput(
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme,
      submittedPinTheme: defaultPinTheme,
      length: 4,
      obscureText: true,
      controller: controller,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      autofocus: true,
      enabled: true,
      keyboardType: TextInputType.number,
      disabledPinTheme: defaultPinTheme,
      onCompleted: (pin) => print(pin),
    );
  }
}

// class TimerText extends StatefulWidget {
//   TimerText({super.key});
//
//   @override
//   State<TimerText> createState() => _TimerTextState();
// }
//
// class _TimerTextState extends State<TimerText> {
//   var controller = Get.put(AuthController());
//
//   @override
//   Widget build(BuildContext context) {
//     controller.startTimer();
//     return GetBuilder<AuthController>(
//         id: 'timer',
//         builder: (context) {
//           return controller.start.value == 0
//               ? shrink
//               : Text(
//                   '00:${controller.start.value}',
//                   style: primaryTextStyle(
//                     weight: FontWeight.w400,
//                     color: appBarColor,
//                     size: 12.sp.toInt(),
//                   ),
//                 );
//         });
//   }
// }

// class EmailTimerText extends StatefulWidget {
//   const EmailTimerText({super.key});
//
//   @override
//   State<EmailTimerText> createState() => _EmailTimerTextState();
// }
//
// class _EmailTimerTextState extends State<EmailTimerText> {
//   var controller = Get.put(ProfileController());
//   @override
//   Widget build(BuildContext context) {
//     controller.startTimer();
//     return GetBuilder<ProfileController>(
//         id: 'timer',
//         builder: (context) {
//           return controller.start.value == 0
//               ? shrink
//               : Text(
//                   '00:${controller.start.value}',
//                   style: primaryTextStyle(
//                     weight: FontWeight.w400,
//                     color: appBarColor,
//                     size: 12.sp.toInt(),
//                   ),
//                 );
//         });
//   }
// }

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final VoidCallback? onConfirm;
  final Color confirmButtonColor;
  final Color confirmTextColor;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.onConfirm,
    this.confirmButtonColor = const Color(0xFFEF4444),
    this.confirmTextColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),

            // Message
            Text(
              message,
              style: TextStyle(
                color: const Color(0xFF9CA3AF),
                fontSize: 10.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24),

            // Buttons Row
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: const Color(0xFF3A3A3A),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      child: Text(
                        cancelText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // Confirm Button
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (onConfirm != null) {
                          onConfirm!();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmButtonColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        confirmText,
                        style: TextStyle(
                          color: confirmTextColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationDeleteDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final VoidCallback? onConfirm;
  final Color confirmButtonColor;
  final Color confirmTextColor;

  const ConfirmationDeleteDialog({
    Key? key,
    required this.title,
    required this.message,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.onConfirm,
    this.confirmButtonColor = const Color(0xFFEF4444),
    this.confirmTextColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.red,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.warning,color: Colors.red,),
                    ),
                  ),
                  width2,
                  Flexible(
                    child: Text(
                      'Are you sure you want to delete this item?',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            height2,
            // Message
            Text(
              message,
              style: TextStyle(
                color: const Color(0xFF9CA3AF),
                fontSize: 10.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24),

            // Buttons Row
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: const Color(0xFF3A3A3A),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      child: Text(
                        cancelText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // Confirm Button
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (onConfirm != null) {
                          onConfirm!();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmButtonColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        confirmText,
                        style: TextStyle(
                          color: confirmTextColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
