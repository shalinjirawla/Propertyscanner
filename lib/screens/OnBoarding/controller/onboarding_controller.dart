import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/config.dart';

class OnboardingController extends GetxController {
  final RxInt currentPage = 0.obs;
  final PageController pageController = PageController();
  var box = GetSecureStorage();


  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      skip();
    }
  }

  void skip() {
    box.write(onBoarding, true);
    Get.offAllNamed(Routes.LOGIN);
  }

  void startApp() {
    skip();
  }


  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

