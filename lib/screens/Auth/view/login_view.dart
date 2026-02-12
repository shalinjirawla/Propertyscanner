
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:property_scan_pro/screens/Auth/controller/auth_controller.dart';
import 'package:property_scan_pro/screens/Settings/view/comoon_cms_view.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/colors.dart';
import 'package:property_scan_pro/utils/constant_images.dart';
import 'package:sizer/sizer.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/Height_Width.dart';
import '../../../utils/strings.dart';
import '../../../utils/theme/app_colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background,
      body:
      SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.08),

              // App Logo/Icon
              Image(image: AssetImage("assets/images/p_logo.png")),


              SizedBox(height: screenHeight * 0.08),

              // Login with Google Button
           Container(
                  width: screenWidth * 0.85,
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.fieldBorder,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                       // Get.offAllNamed(Routes.DASHBOARD);
                        authController.signInWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/google_logo.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          signInGoogle.customText(
                              size: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


              // Login with Apple Button
              if(Platform.isIOS)     Container(
                width: screenWidth * 0.85,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.fieldBorder,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      authController.signInWithApple();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/apple_logo.png",color: white,height: 25,),
                        const SizedBox(width: 12),
                         signInApple.customText(
                           size: 16,
                           fontWeight: FontWeight.w600,
                           color: white
                         ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.07),

              // Terms and Privacy Policy Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(
                  children: [
                    'By continuing, you agree to our'.customText(
                        size: 14,
                        fontWeight: FontWeight.w600,
                        color: grey,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                                Routes.COMMONCMSVIEW,
                                arguments: "term-and-condition"
                            );
                            // Get.toNamed(Routes.COMMONCMSVIEW,arguments: );
                            // Get.to(CommonCmsView(pageTitle: "term-and-condition",));
                            // Navigate to Terms & Conditions
                          },
                          child:'Terms & Conditions'.customText(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ' and '.customText(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            color: grey,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                                Routes.COMMONCMSVIEW,
                                arguments: "privacy-policy"
                            );
                            //Get.to(CommonCmsView(pageTitle: "privacy-policy",));
                          },
                          child:'Privacy Policy'.customText(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
        );
  }
}
