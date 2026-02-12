



import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../Environment/core/core_config.dart';
import '../../../components/custom_snackbar.dart';
import '../../../utils/Extentions.dart';
import '../../../utils/config.dart';
import '../../../widgets/custom_log.dart';
import '../../Settings/controller/settings_controller.dart';
import '../model/analyze_image_model.dart';

class YoloRepo{
  static final box = GetSecureStorage();

  static var dummyAnalyzeResponseList = <AnalyzeModeldata>[];

  static Future<bool> analyzeImageApi({var bodyData}) async {
    var authToken = box.read(token);
    var imageName = generateTimestampFilename();
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('${Config.BaseUrl}$imageDetectAnalyze'),
      );
      Console.Log(title: 'updateUserProfileResponse', message: request);
      request.headers.addAll({
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
        'Access-Control-Allow-Origin': '*',
      });

      if (bodyData['image'] != null &&
          bodyData['image'].toString().isNotEmpty) {
        var pic = await http.MultipartFile.fromBytes(
            "image", bodyData['image'], filename: imageName,contentType: MediaType('image', 'jpeg'),);

        request.files.add(pic);
        // Console.Log(
        //     title: 'DetectImageBodyImage', message: bodyData['image']);
      }
      Console.Log(title: 'DetectImageBodyImage', message: bodyData);
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var data = json.decode(responseString);
      Console.Log(title: 'DetectImageSuccess', message: data);
      if (data['status'] == true) {
        var rawData = data["data"];
        if (rawData is Map<String, dynamic>) {
          // Single object response
          AnalyzeModeldata model = AnalyzeModeldata.fromJson(rawData);
          dummyAnalyzeResponseList.add(model);

          Console.Log(
              title: 'DetectDamageModel>>>>>',
              message: model.analysis
          );

          Console.Log(
              title: 'DetectDamageModelAnalysis>>>>',
              message: dummyAnalyzeResponseList.last.analysis
          );

          showSnackBar(message: data['message'], isError: false);
          return true;

        } else if (rawData is List) {
          // List response (multiple items)
          for (var item in rawData) {
            if (item is Map<String, dynamic>) {
              AnalyzeModeldata model = AnalyzeModeldata.fromJson(item);
              dummyAnalyzeResponseList.add(model);
            }
          }

          Console.Log(
              title: 'DetectDamageModels>>>>>',
              message: '${dummyAnalyzeResponseList.length} items added'
          );

          showSnackBar(message: data['message'], isError: false);
          return true;

        } else {
          Console.Log(
              title: 'UnexpectedDataType',
              message: 'Expected Map or List, got ${rawData.runtimeType}'
          );
          showSnackBar(
              message: 'Unexpected response format',
              isError: true
          );
          return false;
        }
        // AnalyzeModeldata model = AnalyzeModeldata.fromJson(data["data"]);
        // Console.Log(title: 'DetectDamageModxel>>>>>', message: model.analysis);
        // dummyAnalyzeResponseList.add(model);
        // Console.Log(title: 'DetectDamageModxelAnalysiiiii>>>>', message: dummyAnalyzeResponseList[0].analysis);
        // showSnackBar(message: data['message'], isError: false);
        // return false;
      } else {
        showSnackBar(message: data['message'], isError: true);
        return false;
      }
    } catch (e) {
      Console.Log(title: 'DetectImageCatch', message: e);
      showSnackBar(message: e.toString(), isError: true);
      return false;
    }
  }




}