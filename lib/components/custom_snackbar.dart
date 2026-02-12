import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import '../utils/theme/app_colors.dart';

void showSnackBar({bool? isError, var message}) {
  Get.closeAllSnackbars();
  Get.snackbar(
    isError == true ? 'failed' : 'success',
    message,
    icon: Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5),
      child: Icon(
        isError == true ? Icons.cancel : Icons.done,
        color: isError == true ? Colors.red : Colors.green,
      ),
    ),
    backgroundColor: AppColors.cardBg,
    snackPosition: SnackPosition.TOP,
    borderColor: isError == true ? Colors.red : Colors.green,
    borderWidth: 1,
    colorText: isError == true ? Colors.red : Colors.green,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
  );
}

void showWarningSnackBar({var message}) {
  Get.closeAllSnackbars();
  Get.snackbar(
    'Attention',
    message,
    icon: Padding(
      padding: const EdgeInsets.only(left: 10, right: 5),
      child: Image.asset(
        'assets/images/warning_icon.png',
        scale: 3,
      ),
    ),
    backgroundColor: AppColors.cardBg,
    snackPosition: SnackPosition.TOP,
    borderColor: Colors.yellow,
    borderWidth: 1,
    colorText: AppColors.white,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
  );
}
