import 'dart:typed_data';

import 'package:property_scan_pro/screens/DamageRepairTab/repo/azure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/model/report_repair_model.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/repo/damage_repair_repo.dart';
import 'package:property_scan_pro/screens/YoloCamera/controller/yolocamera_controller.dart';
import 'dart:io';

import '../../../components/custom_snackbar.dart';
import '../../../utils/full_screen_loader.dart';
import '../../../widgets/custom_log.dart';
import '../model/pdf_model.dart';
import '../model/report_detail_model.dart';
import '../widget/damage_report_screen.dart';

class DamageRepairTabController extends GetxController {
  var isEdit = true.obs;
  var reportId = ''.obs;
  // var propertyAddress = "".obs;
  // var propertyName = "".obs;
  // var propertyVideoPath = "".obs;
  var propertySummary = "".obs;
  var isLoadingReport = false.obs;
  var isLoadingReportDetail = false.obs;
  var isLoadingReportRepair = false.obs;
  var isLoadingPDF = false.obs;
  var overlay = LoadingOverlay();
  var reportDetailPageData = ReportDetailData().obs;
  var reportRepairPageData = ReportRepairData().obs;
  var reportPDFData = pdfData().obs;

  @override
  void onInit() {
    super.onInit();
    _extractArguments();
  }

  void _extractArguments() {
    final dynamic args = Get.arguments;
    // Map data was passed
    if (args != null && args is Map) {
      isEdit.value = args['isEdit'] ?? false;
      reportId.value = args['reportId'] ?? "";
      // propertyAddress.value = args['address'] ?? "";
      // propertyName.value = args['name'] ?? "";
      // propertySummary.value = args['summery'] ?? "";
      // propertyVideoPath.value = args['videoPath'] ?? "";
    } else {
      isEdit.value = false; // Default value
    }
  }

  void showDeleteConfirmation(
    BuildContext context,
    String? name,
    void Function()? onButtonPress,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Image'),
        content: Text('Are you sure you want to delete "${name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: onButtonPress,
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> submitReport(YoloCameraController? yoloCameraController) async {
    // Validate
    if (yoloCameraController!.propertyNameController.value.text.isEmpty) {
      //showSnackBar(message: 'Please enter property name', isError: true);
      showWarningSnackBar(message: 'Please enter property name');
      return;
    }
    if (yoloCameraController!.propertyAddController.value.text.isEmpty) {
      //showSnackBar(message: 'Please enter property address', isError: true);
      showWarningSnackBar(message: 'Please enter property address');
      return;
    }
    if (yoloCameraController.speechController.value.text.isEmpty) {
      //showSnackBar(message: 'Please enter property address', isError: true);
      showWarningSnackBar(message: 'Please enter summary');
      return;
    }
    // if (yoloCameraController.videoPath.value.isEmpty) {
    //   //showSnackBar(message: 'Please enter property name', isError: true);
    //   showWarningSnackBar(message: 'Please Video');
    //   return;
    // }
    if (yoloCameraController!.captureImages.isEmpty) {
      showWarningSnackBar(message: 'Please add at least one image');
      //showSnackBar(message: 'Please add at least one image', isError: true);
      return;
    }

    // Prepare data
    List<Map<String, dynamic>> damages = [];

    for (var item in yoloCameraController!.captureImages) {
      damages.add({
        'damage_name': item['name'], // damage name from your captureImages
        'image': item['image'], // image bytes (Uint8List)
      });
    }
    isLoadingReport.value = true;
    overlay.show();

    String? videoUrl;

    // Azure Video Upload
    if (yoloCameraController.videoPath.value.isNotEmpty) {
      try {
        File videoFile = File(yoloCameraController.videoPath.value);
        if (videoFile.existsSync()) {
          // Show upload loading state if needed

          String? uploadedUrl = await AzureStorageService.uploadVideo(
            videoFile,
          );

          if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
            videoUrl = uploadedUrl;
            Console.Log(title: "Azure Upload Success", message: videoUrl);
          } else {
            throw Exception("Failed to get upload URL");
          }
        }
      } catch (e) {
        isLoadingReport.value = false;
        overlay.hide();
        Console.Log(title: "Azure Upload Error", message: e);
        showSnackBar(message: "Failed to upload video: $e", isError: true);
        return; // Stop execution on upload failure
      }
    }

    // Call API
    await DamageRepo.saveSurveyReport(
      bodyData: {
        'property_name':
            yoloCameraController!.propertyNameController.value.text,
        'property_address':
            yoloCameraController!.propertyAddController.value.text,
        'summary': yoloCameraController.speechController.value.text,
        'damages': damages,
        'video_url': videoUrl, // Pass URL if uploaded
        /*'capture_video': videoUrl == null
            ? yoloCameraController.videoPath.value
            : null,*/ // Fallback if logic changes, but typically null if URL sent
      },
    );
    isLoadingReport.value = false;
  }

  Future<void> getReportDetailData(String? reportId) async {
    isLoadingReportDetail.value = true;
    isLoadingReportDetail.value = await DamageRepo.getReportDetailPage(
      reportId,
    );
    if (DamageRepo.reportDetailData != null) {
      reportDetailPageData.value = DamageRepo.reportDetailData;
    }
  }

  Future<void> getReportRepairData(String? reportId, imageId) async {
    isLoadingReportRepair.value = true;
    isLoadingReportRepair.value = await DamageRepo.getReportRepairPage(
      reportId,
      imageId,
    );
    if (DamageRepo.reportDetailData != null) {
      reportRepairPageData.value = DamageRepo.reportRepairData;
      Console.Log(
        title: reportRepairPageData.value,
        message: "ReportRepairData>>>>>>",
      );
    }
  }

  Future<void> getPDFData(String? reportId) async {
    isLoadingPDF.value = true;
    isLoadingPDF.value = await DamageRepo.getPDFPage(reportId);
    if (DamageRepo.pdfGetData != null) {
      reportPDFData.value = DamageRepo.pdfGetData;
    }
  }

  // Add this method in your controller or widget
  Map<String, List<EpoxyWoodRepair>> getDynamicCategories() {
    final recommended =
        reportRepairPageData.value.analysis?.recommendedProducts;

    if (recommended == null || recommended.rawJson == null) {
      return {};
    }

    Map<String, List<EpoxyWoodRepair>> categories = {};

    // Loop through all keys in the raw JSON dynamically
    recommended.rawJson!.forEach((key, value) {
      // Check if value is a list and not empty
      if (value != null && value is List && value.isNotEmpty) {
        try {
          // Convert snake_case to Title Case
          String formattedName = key
              .split('_')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' ');

          // Parse the list of products
          List<EpoxyWoodRepair> products = List<EpoxyWoodRepair>.from(
            value.map((x) => EpoxyWoodRepair.fromJson(x)),
          );

          categories[formattedName] = products;
        } catch (e) {
          print('Error parsing category $key: $e');
        }
      }
    });

    return categories;
  }

  Map<String, int> get severityCounts {
    if (reportDetailPageData.value?.damages == null) {
      return {'High': 0, 'Medium': 0, 'Low': 0};
    }

    int high = 0;
    int medium = 0;
    int low = 0;

    for (var damage in reportDetailPageData.value!.damages!) {
      String severity = damage.severity?.toLowerCase() ?? '';
      if (severity == 'high') {
        high++;
      } else if (severity == 'medium') {
        medium++;
      } else if (severity == 'low') {
        low++;
      }
    }

    return {'High': high, 'Medium': medium, 'Low': low};
  }

  int get totalIssues {
    return reportDetailPageData.value?.damages?.length ?? 0;
  }

  Future<void> updateReportAndPdf() async {
    List<Map<String, dynamic>> damagesList = [];
    if (reportDetailPageData.value.damages != null) {
      for (var damage in reportDetailPageData.value.damages!) {
        damagesList.add({"id": damage.id, "name": damage.damageName});
      }
    }
    isLoadingReport.value = true;
    overlay.show();
    isLoadingReport.value = await DamageRepo.updateReportAndGeneratePdf(
      reportId: reportDetailPageData.value.id.toString(),
      damages: damagesList,
    );
    update();

    // overlay.hide();
    // isLoadingReport.value = false;
  }

  Future<void> deleteDamageImage(
    String reportId,
    String damageImageId,
    int index,
  ) async {
    overlay.show();
    bool success = await DamageRepo.deleteDamageImage(
      reportId: reportId,
      damageImageId: damageImageId,
    );
    overlay.hide();

    if (success) {
      // Remove from list
      reportDetailPageData.update((val) {
        val?.damages?.removeAt(index);
      });
      // Optionally refresh data
      // await getReportDetailData(reportId);
    }
  }
}
