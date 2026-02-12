import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';

import '../../../ApiManager/ApiService.dart';
import '../../../Environment/core/core_config.dart';
import '../../../components/custom_snackbar.dart';
import '../../../utils/config.dart';
import '../../../widgets/custom_log.dart';
import '../Model/ConfigModel.dart';

class ConfigRepo {
  static final box = GetSecureStorage();
  static var configsData = ConfigSplashData(),
      errorMessage = '';

  static Future<bool> getSplashConfig() async {
    var authToken = box.read(token);
    try {
      var res = await ApiServices.ApiProvider(
        0,
        url:'${Config.BaseUrl}${configSettingData}',
        authToken: "Bearer ${authToken}",
      );
      var data = splashConfigModelFromJson(res);
      if (data.status == true) {

        configsData = data.data!;
        Console.Log(title: 'getConfigData', message: configsData.androidVersion);
        return false;
      } else {
        Console.Log(title: 'getConfigError', message: data.toString());
        return false;
      }
    } catch (e) {
      Console.Log(title: 'getConfigError', message: e.toString());
      return false;
    }
  }





}
