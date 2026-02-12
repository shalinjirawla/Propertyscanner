import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:property_scan_pro/utils/full_screen_loader.dart';

import '../../../ApiManager/ApiService.dart';
import '../../../Environment/core/core_config.dart';
import '../../../components/custom_snackbar.dart';
import '../../../utils/config.dart';
import '../../../widgets/custom_log.dart';
import '../../DashBoard/controller/dash_controller.dart';
import '../../DashBoard/model/report_model.dart';
import '../model/three_d_list_model.dart';

class ThreeDRepo{

  static final box = GetSecureStorage();

  static var threeDListData = <ThreeDModelData>[];
  static var overlay = LoadingOverlay();

  static Future<bool> getThreeDListPage() async {
    var authToken = box.read(token);
    try {
      var res = await ApiServices.ApiProvider(
        0,
        url: '${Config.BaseUrl}${walkthroughList}',
        authToken: "Bearer ${authToken}",
      );
      Console.Log(title: 'getThreeDmodel', message: res);
      var data = getThreeDModelFromJson(res);
      if (data.status == true) {
        //Console.Log(title: 'getUserProfileResponse', message: data.data!);
        threeDListData = data.data!;
        return false;
      } else {
        Console.Log(title: 'getThreeDmodelError', message: data);
        return false;
      }
    } catch (e) {
      Console.Log(title: 'getThreeDmodelError', message: e);
      return false;
    }
  }
  static Future<bool> addThreeDModel({var bodyData}) async {
    var authToken = box.read(token);
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('${Config.BaseUrl}$walkthroughAdd'),
      );
      Console.Log(title: 'updateUserProfileResponse', message: request);
      request.fields["property_name"] = bodyData['property_name'];
      request.fields["property_address"] = bodyData['property_address'];
      request.fields["dimensions"] = bodyData['dimensions'];
     // request.fields["model"] = bodyData['dimension'];
      request.headers.addAll({
        "Content-Type": "multipart/form-data",
        'Authorization': 'Bearer ${authToken}',
        'Access-Control-Allow-Origin': '*',
      });

      if (bodyData['model'] != null &&
          bodyData['model'].toString().isNotEmpty) {
        File file = File(bodyData['model']);
        if (await file.exists()) {
          var usdzFile = await http.MultipartFile.fromPath(
            "model",
            bodyData['model'],
            // Optional: specify content type if needed
            // contentType: MediaType('model', 'vnd.usdz+zip'),
          );
          request.files.add(usdzFile);
          Console.Log(title: 'USDZ File Added', message: bodyData['model']);
        } else {
          showSnackBar(message: 'USDZ file not found', isError: true);
          return false;
        }
      }
      Console.Log(title: 'addThreeDModelBody', message: request.fields);
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var data = json.decode(responseString);
      Console.Log(title: 'addThreeDModelSuccess', message: responseString);
      if (data['status'] == true) {
        NavigationHelper.goToDashboardTabThenScreen(
          tabIndex: 2,
        );
        print('ApiSucesssssss>>>.>>>>>>>>>>.${data['message']}');
        showSnackBar(message: data['message'], isError: false);
        overlay.hide();
        return false;
      } else {
        print('ApiFailedddd>>>.>>>>>>>>>>.${data['message']}');
        overlay.hide();
        showSnackBar(message: data['message'], isError: true);
        return false;
      }
    } catch (e) {
      print('ApiFailedddd>>>.>>>>>>>>>>.${e}');
      Console.Log(title: 'addThreeDModelError', message: e);
      overlay.hide();
      showSnackBar(message: e.toString(), isError: true);
      return false;
    }
  }
}