import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/components/app_bar.dart';
import 'package:property_scan_pro/screens/Survey/controller/survey_controller.dart';
import 'package:property_scan_pro/screens/YoloCamera/controller/yolocamera_controller.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:sizer/sizer.dart';

import '../../../components/custom_bottom_navigtion.dart';
import '../../../components/custom_snackbar.dart';
import '../../../components/custom_textfield.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../YoloCamera/repo/yolo_repo.dart';

class SurveyView extends StatefulWidget {
  const SurveyView({super.key});

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  var surveyController = Get.put(SurveyController());
  var yoloCameraController = Get.put(YoloCameraController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDarkAppBar(height: 80, title: 'Start New Survey'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                child: Column(
                  children: [
                    TextFieldWithName(
                      fieldName: "Property Name",
                      imp: "*",
                      controller:
                          yoloCameraController.propertyNameController.value,
                      hintText: "e.g., 123 Main Street Condo",
                    ),
                    height2,
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryLight.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xFF4DD0E1),
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Here you can add the name of the property you are going to scan. This helps organize your reports',
                              style: TextStyle(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 8.sp,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    height2,
                    TextFieldWithName(
                      fieldName: "Property Address",
                      imp: "*",
                      controller:
                          yoloCameraController.propertyAddController.value,
                      hintText: "e.g., Apt 4B, Springfield, IL 62704",
                    ),
                  ],
                ),
              ),

              height6,

              CustomThemeButton(
                height: 60,
                text: 'Start Video Mode',
                icon: Icons.video_camera_back_outlined,
                onPressed: () async {
                  if (yoloCameraController!
                      .propertyNameController
                      .value
                      .text
                      .isEmpty) {
                    showWarningSnackBar(message: 'Please enter property name');
                    return;
                  }
                  if (yoloCameraController!
                      .propertyAddController
                      .value
                      .text
                      .isEmpty) {
                    showWarningSnackBar(
                      message: 'Please enter property address',
                    );
                    return;
                  }

                  var connectivityResult = await Connectivity()
                      .checkConnectivity();
                  if (connectivityResult.contains(ConnectivityResult.none)) {
                    bool? proceed = await _showOfflineDialog();
                    if (proceed != true) return;
                  }

                  yoloCameraController.dummyAnalyzeResponseListValue.clear();
                  YoloRepo.dummyAnalyzeResponseList.clear();
                  yoloCameraController.isVideoMode.value = true;
                  Get.toNamed(Routes.YOLOCAMERAVIEW);
                },
                backgroundColor: AppColors.primary,
                textColor: Colors.black,
                iconColor: Colors.black,
              ),
              const SizedBox(height: 20),
              CustomThemeButton(
                backgroundColor: AppColors.divider,
                height: 60,
                text: 'Start Photo Mode',
                icon: Icons.camera_alt,
                onPressed: () async {
                  if (yoloCameraController!
                      .propertyNameController
                      .value
                      .text
                      .isEmpty) {
                    showWarningSnackBar(message: 'Please enter property name');
                    return;
                  }
                  if (yoloCameraController!
                      .propertyAddController
                      .value
                      .text
                      .isEmpty) {
                    showWarningSnackBar(
                      message: 'Please enter property address',
                    );
                    return;
                  }

                  var connectivityResult = await Connectivity()
                      .checkConnectivity();
                  if (connectivityResult.contains(ConnectivityResult.none)) {
                    bool? proceed = await _showOfflineDialog();
                    if (proceed != true) return;
                  }

                  yoloCameraController.dummyAnalyzeResponseListValue.clear();
                  YoloRepo.dummyAnalyzeResponseList.clear();
                  yoloCameraController.isVideoMode.value = false;
                  Get.toNamed(Routes.YOLOCAMERAVIEW);
                },
                isOutlined: true,
                textColor: Colors.white,
                iconColor: Colors.white,
                borderColor: AppColors.black,
              ),
              height3,
              "Video mode captures continuous footage while Photo mode lets you take individual shots of issues"
                  .customText(
                    size: 10.sp,
                    color: AppColors.textSecondary,
                    textAlign: TextAlign.center,
                  ),

              // CustomRowButton(
              //   rowWidget: Icon(Icons.video_camera_back_rounded,color: white,size: 25,),
              //   title: "Start Video Mode",
              //   height: 7.h,
              //   buttonColor: primaryColor,
              //   textColor: white,
              //   onTap: (){
              //     if (yoloCameraController!.propertyNameController.value.text.isEmpty) {
              //       showWarningSnackBar(message: 'Please enter property name');
              //       return;
              //     }
              //     if (yoloCameraController!.propertyAddController.value.text.isEmpty) {
              //       showWarningSnackBar(message: 'Please enter property address');
              //       return;
              //     }
              //     yoloCameraController.dummyAnalyzeResponseListValue.clear();
              //     YoloRepo.dummyAnalyzeResponseList.clear();
              //     yoloCameraController.isVideoMode.value = true;
              //     Get.toNamed(Routes.YOLOCAMERAVIEW);
              //   },
              // ),
              // height2,
              // CustomRowButton(
              //   rowWidget: Icon(Icons.camera_alt,color: white,size: 25,),
              //   title: "Start Photo Mode",
              //   height: 7.h,
              //   buttonColor: primaryColor,
              //   textColor: white,
              //   onTap: (){
              //     yoloCameraController.dummyAnalyzeResponseListValue.clear();
              //     YoloRepo.dummyAnalyzeResponseList.clear();
              //     yoloCameraController.isVideoMode.value = false;
              //     Get.toNamed(Routes.YOLOCAMERAVIEW);
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String description,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, size: 80, color: AppColors.white),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showOfflineDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.primary, width: 1),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.wifi_off_rounded,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Offline Mode",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "You are currently offline. Some features like speech-to-text and AI analysis may have limited functionality.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: CustomThemeButton(
                        text: 'OK',
                        onPressed: () => Navigator.pop(context, true),
                        backgroundColor: AppColors.primary,
                        textColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () => Get.back(result: false),
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/components/app_bar.dart';
import 'package:property_scan_pro/screens/Survey/controller/survey_controller.dart';
import 'package:property_scan_pro/screens/YoloCamera/controller/yolocamera_controller.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/custom_bottom_navigtion.dart';
import '../../../components/custom_snackbar.dart';
import '../../../components/custom_textfield.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../YoloCamera/repo/yolo_repo.dart';

class SurveyView extends StatefulWidget {
  const SurveyView({super.key});

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  var surveyController = Get.put(SurveyController());
  var yoloCameraController = Get.put(YoloCameraController());
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDarkAppBar(
        height: 80,
        title: 'Start New Survey',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                child: Column(
                  children: [
                    TextFieldWithName(
                      fieldName: "Property Name",
                      imp: "*",
                      controller: yoloCameraController.propertyNameController.value,
                      hintText: "e.g., 123 Main Street Condo",
                    ),
                    height2,
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryLight.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xFF4DD0E1),
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Here you can add the name of the property you are going to scan. This helps organize your reports',
                              style: TextStyle(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 8.sp,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    height2,
                    TextFieldWithName(
                      fieldName: "Property Address",
                      imp: "*",
                      controller: yoloCameraController.propertyAddController.value,
                      hintText: "e.g., Apt 4B, Springfield, IL 62704",
                    ),
                  ],
                ),
              ),

              height6,

              // Video Mode Button
              CustomThemeButton(
                height: 60,
                text: 'Start Video Mode',
                icon: Icons.video_camera_back_outlined,
                onPressed: () {
                  if (!_validatePropertyInfo()) return;

                  _clearPreviousData();
                  yoloCameraController.isVideoMode.value = true;
                  yoloCameraController.isUploadedVideo.value = false;
                  Get.toNamed(Routes.YOLOCAMERAVIEW);
                },
                backgroundColor: AppColors.primary,
                textColor: Colors.black,
                iconColor: Colors.black,
              ),

              const SizedBox(height: 20),

              // Photo Mode Button
              CustomThemeButton(
                backgroundColor: AppColors.divider,
                height: 60,
                text: 'Start Photo Mode',
                icon: Icons.camera_alt,
                onPressed: () {
                  if (!_validatePropertyInfo()) return;

                  _clearPreviousData();
                  yoloCameraController.isVideoMode.value = false;
                  yoloCameraController.isUploadedVideo.value = false;
                  Get.toNamed(Routes.YOLOCAMERAVIEW);
                },
                isOutlined: true,
                textColor: Colors.white,
                iconColor: Colors.white,
                borderColor: AppColors.black,
              ),

              const SizedBox(height: 20),

              // Upload Video Button
              CustomThemeButton(
                backgroundColor: AppColors.cardBg,
                height: 60,
                text: 'Upload Video from Gallery',
                icon: Icons.video_library,
                onPressed: () async {
                  if (!_validatePropertyInfo()) return;

                  await _pickAndProcessVideo();
                },
                isOutlined: true,
                textColor: Colors.white,
                iconColor: AppColors.primary,
                borderColor: AppColors.primary,
              ),

              height3,

              "Video mode captures continuous footage, Photo mode lets you take individual shots, and Upload mode processes existing videos"
                  .customText(
                  size: 10.sp,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  bool _validatePropertyInfo() {
    if (yoloCameraController.propertyNameController.value.text.isEmpty) {
      showWarningSnackBar(message: 'Please enter property name');
      return false;
    }
    if (yoloCameraController.propertyAddController.value.text.isEmpty) {
      showWarningSnackBar(message: 'Please enter property address');
      return false;
    }
    return true;
  }

  void _clearPreviousData() {
    yoloCameraController.dummyAnalyzeResponseListValue.clear();
    YoloRepo.dummyAnalyzeResponseList.clear();
    yoloCameraController.captureImages.clear();
    yoloCameraController.rawCapturedFrames.clear();
  }

  Future<void> _pickAndProcessVideo() async {
    try {
      // Pick video from gallery
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );

      if (video == null) {
        print('❌ No video selected');
        return;
      }

      print('✅ Video selected: ${video.path}');

      // Clear previous data
      _clearPreviousData();

      // Set upload mode flags
      yoloCameraController.isVideoMode.value = false;
      yoloCameraController.isUploadedVideo.value = true;
      yoloCameraController.uploadedVideoPath.value = video.path;

      // Start processing the video
      await yoloCameraController.processUploadedVideo(video.path);

    } catch (e) {
      print('❌ Error picking video: $e');
      showWarningSnackBar(message: 'Failed to pick video: $e');
    }
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String description,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 80,
                color: AppColors.white,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
