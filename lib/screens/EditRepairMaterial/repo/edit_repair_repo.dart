import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';

import '../../../ApiManager/ApiService.dart';
import '../../../Environment/core/core_config.dart';
import '../../../utils/config.dart';
import '../../../widgets/custom_log.dart';
import '../../DamageRepairTab/widget/damage_report_screen.dart';
import '../model/damage_analysis_model.dart';
import '../../../components/custom_snackbar.dart';

class EditRepairRepo {
  static final box = GetSecureStorage();
  static Future<SurveyDamageResponse?> fetchDamageAnalysis(
    String? reportId,
    imageId,
  ) async {
    var authToken = box.read(token);
    try {
      // Hardcoded url as per requirement
      // Using ApiProviders with isPost = 0 (GET)
      var res = await ApiServices.ApiProvider(
        0,
        url: '${Config.BaseUrl}${surveyDetail}/${reportId}/damage/${imageId}',
        authToken: "Bearer ${authToken}",
      );

      Console.Log(title: 'fetchDamageAnalysis', message: res);

      // ApiServices returns String body or throws.
      // If it returns, we assume it's a valid JSON string.
      var jsonResponse = SurveyDamageResponse.fromJson(json.decode(res));
      return jsonResponse;
    } catch (e) {
      Console.Log(title: 'fetchDamageAnalysisError', message: e);
      return null;
    }
  }

  static Future<bool> updateDamageAnalysis({
    required Map<String, dynamic> bodyData,
    String? reportId
  }) async {
    var authToken = box.read(token);
    try {
      Console.Log(title: 'updateDamageAnalysisRequest', message: bodyData);

      var res = await ApiServices.ApiProvider(
        1,
        url: '${Config.BaseUrl}update-damage-analysis',
        body: bodyData,
        authToken: "Bearer $authToken",
      );

      Console.Log(title: 'updateDamageAnalysisResponse', message: res);

      if (res is String) {
        var data = json.decode(res);
        if (data['status'] == true) {
          Get.back();
          Get.back();
          Get.back();
          showSnackBar(
            message: data['message'] ?? 'Analysis updated successfully',
            isError: false,
          );
          return true;
        } else {
          Get.back();
          showSnackBar(
            message: data['message'] ?? 'Failed to update analysis',
            isError: true,
          );
          return false;
        }
      } else {
        Get.back();
        showSnackBar(message: "Something went wrong", isError: true);
        return false;
      }
    } catch (e) {
      Get.back();
      Console.Log(title: 'updateDamageAnalysisError', message: e);
      showSnackBar(message: e.toString(), isError: true);
      return false;
    }
  }
}
