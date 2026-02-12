import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:property_scan_pro/screens/YoloCamera/controller/yolocamera_controller.dart';
import 'package:sizer/sizer.dart';

import '../../../ApiManager/ApiService.dart';
import '../../../Environment/core/core_config.dart';
import '../../../components/custom_snackbar.dart';
import '../../../utils/config.dart';
import '../../../utils/full_screen_loader.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_log.dart';
import '../../DashBoard/controller/dash_controller.dart';
import '../model/pdf_model.dart';
import '../model/report_detail_model.dart';
import '../model/report_repair_model.dart';

Future<String?> transcribeWithWhisper(String audioPath) async {
  var apikey =
      '';
  var request = http.MultipartRequest(
    'POST',
    Uri.parse("https://api.openai.com/v1/audio/transcriptions"),
  );

  request.headers['Authorization'] = 'Bearer $apikey';
  request.files.add(await http.MultipartFile.fromPath('file', audioPath));
  request.fields['model'] = 'whisper-1';
  request.fields['language'] = 'en';

  var response = await request.send();
  if (response.statusCode == 200) {
    final res = await http.Response.fromStream(response);
    print('API Response: ${res.body}');
    print('API ResponseByte: ${res.bodyBytes}');
    return res.body; // contains transcription text
  } else {
    return "Failed: ${response.statusCode}";
  }
}

Future<void> transcribeAudio(
  String audioPath,
  YoloCameraController controller,
) async {
  try {
    final file = File(audioPath);
    if (!file.existsSync()) {
      throw Exception('Audio file not found');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://property-scan.staging-server.in/api/uploadAudio'),
      //Uri.parse('http://192.168.2.182:3000/api/uploadAudio'),
    );
    request.files.add(await http.MultipartFile.fromPath('audio', audioPath));

    http.StreamedResponse response = await request.send();

    final responses = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(responses.body);
      controller.isLoading.value = false;
      controller.speechController.value.text = jsonResponse['text'];
      print('ApiResponses: ${responses.body}');
    } else {
      controller.isLoading.value = false;
      // final errorData = json.decode(response.body);
      print('ApiResponse: error');
      //throw Exception('API Error: ${errorData['error']['message']}');
    }
  } catch (e) {
    controller.isLoading.value = false;
    print('error: $e');
  } finally {
    controller.isLoading.value = false;
    // Clean up the audio file
    if (File(audioPath).existsSync()) {
      File(audioPath).deleteSync();
    }
  }
}

class DamageRepo {
  static final box = GetSecureStorage();
  static var reportDetailData = ReportDetailData();
  static var reportRepairData = ReportRepairData();
  static var pdfGetData = pdfData();
  static var overlayLoader = LoadingOverlay();

  static Future<bool> saveSurveyReport({var bodyData}) async {
    var authToken = box.read(token);
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('${Config.BaseUrl}$surveyDetail'),
      );
      Console.Log(title: 'updateUserProfileResponse', message: request);
      request.fields["property_name"] = bodyData['property_name'];
      request.fields["property_address"] = bodyData['property_address'];
      request.fields["summary"] = bodyData['summary'];
      // if (bodyData['file_name'] != null && bodyData['file_name'] is List) {
      //   for (int i = 0; i < bodyData['file_name'].length; i++) {
      //     request.fields["file_name[$i]"] = bodyData['file_name'][i];
      //   }
      // }
      request.headers.addAll({
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
        'Access-Control-Allow-Origin': '*',
      });

      if (bodyData['damages'] != null && bodyData['damages'] is List) {
        for (int i = 0; i < bodyData['damages'].length; i++) {
          var damage = bodyData['damages'][i];

          // Add damage name
          if (damage['damage_name'] != null) {
            request.fields["damages[$i][damage_name]"] = damage['damage_name'];
          }

          // Add damage image (as bytes)
          if (damage['image'] != null) {
            var pic = http.MultipartFile.fromBytes(
              "damages[$i][image]",
              damage['image'], // Uint8List
              filename: "${damage['damage_name']}_$i.jpg",
              contentType: MediaType('image', 'jpeg'),
            );
            request.files.add(pic);
          }
        }
      }

      // if (bodyData['file_pics'] != null &&
      //     bodyData['file_pics'] is List) {
      //   for (int i = 0; i < bodyData['file_pics'].length; i++) {
      //     if (bodyData['file_pics'][i] != null) {
      //       var pic = http.MultipartFile.fromBytes(
      //         "file_pics[$i]",
      //         bodyData['file_pics'][i], // Uint8List or List<int>
      //         filename: "profile_$i.jpg",
      //         contentType: MediaType('image', 'jpeg'),
      //       );
      //       request.files.add(pic);
      //     }
      //   }
      // }

      if (bodyData['video_url'] != null &&
          bodyData['video_url'].toString().isNotEmpty) {
        request.fields['video_url'] = bodyData['video_url'];
        Console.Log(title: 'VideoURL', message: bodyData['video_url']);
      } /*else if (bodyData['capture_video'] != null &&
          bodyData['capture_video'].toString().isNotEmpty) {
        String filePath = bodyData['capture_video'];
        String extension = filePath.split('.').last.toLowerCase();

        // Determine content type based on extension
        String videoType = 'mp4'; // default
        if (extension == 'mov') {
          videoType = 'quicktime';
        } else if (extension == 'avi') {
          videoType = 'x-msvideo';
        } else if (extension == 'mkv') {
          videoType = 'x-matroska';
        } else if (extension == 'webm') {
          videoType = 'webm';
        }

        var video = await http.MultipartFile.fromPath(
          "capture_video", // Changed from "video[$i]" to just "video"
          filePath,
          contentType: MediaType('video', videoType),
        );
        request.files.add(video);
        Console.Log(title: 'VideoPath', message: filePath);
      }*/

      Console.Log(title: 'saveSurveyReportBody', message: request.fields);
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var data = json.decode(responseString);
      Console.Log(
        title: 'saveSurveyReportBodySuccess',
        message: responseString,
      );
      if (data['status'] == true) {
        Get.back();

        showFinalModeInstructionDialog();

        showSnackBar(message: data['message'], isError: false);
        return true;
      } else {
        overlayLoader.hide();
        showSnackBar(message: data['message'], isError: true);
        return false;
      }
    } catch (e) {
      overlayLoader.hide();
      Console.Log(title: 'saveSurveyReportError', message: e);
      showSnackBar(message: e.toString(), isError: true);
      return false;
    }
  }

  static Future<bool> getReportDetailPage(String? reportId) async {
    var authToken = box.read(token);
    Console.Log(title: 'getReportDetailPageReportId', message: reportId);
    try {
      var res = await ApiServices.ApiProvider(
        0,
        url: '${Config.BaseUrl}${surveyDetail}/${reportId}',
        authToken: "Bearer ${authToken}",
      );
      Console.Log(title: 'getReportDetailPage', message: res);
      var data = getReportDetailFromJson(res);
      if (data.status == true) {
        Console.Log(title: 'getReportDetailResponse', message: data.data!);
        reportDetailData = data.data!;
        return false;
      } else {
        Console.Log(title: 'getReportDetailError', message: data);
        return false;
      }
    } catch (e) {
      Console.Log(title: 'getReportDetailError', message: e);
      return false;
    }
  }

  static Future<bool> getReportRepairPage(String? reportId, imageId) async {
    var authToken = box.read(token);
    Console.Log(title: 'getReportDetailPageReportId', message: reportId);
    try {
      var res = await ApiServices.ApiProvider(
        0,
        url: '${Config.BaseUrl}${surveyDetail}/${reportId}/damage/${imageId}',
        authToken: "Bearer ${authToken}",
      );
      Console.Log(title: 'getReportRepairPage', message: res);
      var data = getReportRepairModelFromJson(res);
      if (data.status == true) {
        Console.Log(title: 'getReportRepairResponse', message: data.data!);
        reportRepairData = data.data!;
        return false;
      } else {
        Console.Log(title: 'getReportRepairError', message: data);
        return false;
      }
    } catch (e) {
      Console.Log(title: 'getReportRepairError', message: e);
      return false;
    }
  }

  static Future<bool> getPDFPage(String? reportId) async {
    var authToken = box.read(token);
    Console.Log(title: 'getPDFPageReportId', message: reportId);
    try {
      var res = await ApiServices.ApiProvider(
        0,
        url: '${Config.BaseUrl}${surveyDetail}/${reportId}/pdf',
        authToken: "Bearer ${authToken}",
      );
      Console.Log(title: 'getPDFPagePage', message: res);
      var data = getPdfModelFromJson(res);
      if (data.status == true) {
        Console.Log(title: 'getPDFPageResponse', message: data.data!);
        pdfGetData = data.data!;
        return false;
      } else {
        Console.Log(title: 'getPDFPageError', message: data);
        return false;
      }
    } catch (e) {
      Console.Log(title: 'getPDFPageError', message: e);
      return false;
    }
  }

  static Future<bool> updateReportAndGeneratePdf({
    required String reportId,
    required List<Map<String, dynamic>> damages,
  }) async {
    var authToken = box.read(token);
    try {
      var bodyData = {"report_id": reportId, "damages": damages};

      Console.Log(
        title: 'updateReportAndGeneratePdfRequest',
        message: bodyData,
      );

      var res = await ApiServices.ApiProvider(
        1,
        url: '${Config.BaseUrl}$updateSurveyReport',
        body: bodyData,
        authToken: "Bearer $authToken",
      );

      Console.Log(title: 'updateReportAndGeneratePdfResponse', message: res);

      // ApiProvider returns dynamic (String usually) or Exception
      // If result is string, we parse it

      var data = json.decode(res);
      Console.Log(
        title: 'updateReportAndGeneratePdfResponseStatus',
        message: data['status'],
      );
      if (data['status'] == true) {
        Get.back();
        showSnackBar(
          message: data['message'] ?? 'Report updated successfully',
          isError: false,
        );
        NavigationHelper.goToDashboardTabThenScreen(tabIndex: 1);
        //overlayLoader.hide();
        return true;
      } else {
        Get.back();
        showSnackBar(
          message: data['message'] ?? 'Failed to update report',
          isError: true,
        );
        //overlayLoader.hide();
        return false;
      }
      /* } else {
        // If it's not a string, it might be an Exception or null
        // However ApiProvider catches exceptions and might return Exception object
        showSnackBar(message: "Something went wrong", isError: true);
        overlayLoader.hide();
        return false;
      }*/
    } catch (e) {
      Get.back();
      Console.Log(title: 'updateReportAndGeneratePdfError', message: e);
      showSnackBar(message: e.toString(), isError: true);
      //overlayLoader.hide();
      return false;
    }
  }

  static Future<bool> deleteDamageImage({
    required String reportId,
    required String damageImageId,
  }) async {
    var authToken = box.read(token);
    try {
      var bodyData = {"report_id": reportId, "damage_id": damageImageId};

      Console.Log(title: 'deleteDamageImageRequest', message: bodyData);

      // Using a hypothetical endpoint since none was provided in config
      // User requested to "create post api"
      var res = await ApiServices.ApiProvider(
        1,
        url: '${Config.BaseUrl}delete-damage-image',
        body: bodyData,
        authToken: "Bearer $authToken",
      );

      Console.Log(title: 'deleteDamageImageResponse', message: res);

      var data = json.decode(res);
      Console.Log(
        title: 'deleteDamageImageResponseStatus',
        message: data['status'],
      );

      if (data['status'] == true) {
        Get.back();
        showSnackBar(
          message: data['message'] ?? 'Damage image deleted successfully',
          isError: false,
        );
        return true;
      } else {
        showSnackBar(
          message: data['message'] ?? 'Failed to delete damage image',
          isError: true,
        );
        return false;
      }
    } catch (e) {
      Console.Log(title: 'deleteDamageImageError', message: e);
      showSnackBar(message: e.toString(), isError: true);
      return false;
    }
  }

  static Future<Map<String, dynamic>> uploadOfflineReport({
    required Map<String, dynamic> bodyData,
  }) async {
    var authToken = box.read(token);
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('${Config.BaseUrl}$surveyDetail'),
      );
      Console.Log(title: 'uploadOfflineReportRequest', message: request);
      request.fields["property_name"] = bodyData['property_name'];
      request.fields["property_address"] = bodyData['property_address'];
      request.fields["summary"] = bodyData['summary'];

      request.headers.addAll({
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
        'Access-Control-Allow-Origin': '*',
      });

      if (bodyData['damages'] != null && bodyData['damages'] is List) {
        for (int i = 0; i < bodyData['damages'].length; i++) {
          var damage = bodyData['damages'][i];

          // Add damage name
          if (damage['damage_name'] != null) {
            request.fields["damages[$i][damage_name]"] = damage['damage_name'];
          }

          // Add damage image (as bytes)
          if (damage['image'] != null) {
            var pic = http.MultipartFile.fromBytes(
              "damages[$i][image]",
              damage['image'], // Uint8List
              filename: "${damage['damage_name']}_$i.jpg",
              contentType: MediaType('image', 'jpeg'),
            );
            request.files.add(pic);
          }
        }
      }
      if (bodyData['video_url'] != null &&
          bodyData['video_url'].toString().isNotEmpty) {
        request.fields['video_url'] = bodyData['video_url'];
        Console.Log(title: 'VideoURL', message: bodyData['video_url']);
      }
      /*if (bodyData['capture_video'] != null &&
          bodyData['capture_video'].toString().isNotEmpty) {
        String filePath = bodyData['capture_video'];
        String extension = filePath.split('.').last.toLowerCase();

        // Determine content type based on extension
        String videoType = 'mp4'; // default
        if (extension == 'mov') {
          videoType = 'quicktime';
        } else if (extension == 'avi') {
          videoType = 'x-msvideo';
        } else if (extension == 'mkv') {
          videoType = 'x-matroska';
        } else if (extension == 'webm') {
          videoType = 'webm';
        }

        var video = await http.MultipartFile.fromPath(
          "capture_video",
          filePath,
          contentType: MediaType('video', videoType),
        );
        request.files.add(video);
      }*/

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var data = json.decode(responseString);

      Console.Log(
        title: 'uploadOfflineReportResponse',
        message: responseString,
      );

      if (data['status'] == true) {
        return {'success': true, 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      Console.Log(title: 'uploadOfflineReportError', message: e);
      return {'success': false, 'message': e.toString()};
    }
  }
}

Widget _buildStepItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> showFinalModeInstructionDialog() async {
  return showDialog(
    context: Get.context!,
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
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  /// Icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Title
                  const Center(
                    child: Text(
                      "Save Report in Final Mode",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Description
                  const Text(
                    "Your report is currently saved in Draft mode",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const Text(
                    "To save it in Final mode, please follow these steps:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  /// Steps
                  _buildStepItem(
                    "1. Go to the Reports section and select the Draft report.",
                  ),
                  _buildStepItem("2. Open the report to view details."),
                  _buildStepItem("3. Edit the report as required."),
                  _buildStepItem(
                    "4. Edit suggested products and labour costs.",
                  ),
                  _buildStepItem(
                    "5. Tap Update Report to save it in Final mode.",
                  ),

                  const SizedBox(height: 20),

                  /// Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomThemeButton(
                      text: 'Got it',
                      onPressed: () =>
                          NavigationHelper.goToDashboardTabThenScreen(
                            tabIndex: 1,
                          ),
                      backgroundColor: AppColors.primary,
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            /// Close Button
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () =>
                    NavigationHelper.goToDashboardTabThenScreen(tabIndex: 1),
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
