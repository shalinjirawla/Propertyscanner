import 'dart:convert';

import 'package:get_secure_storage/get_secure_storage.dart';

import '../../../ApiManager/ApiService.dart';
import '../../../Environment/core/core_config.dart';
import '../../../utils/config.dart';
import '../../../widgets/custom_log.dart';
import '../model/notification_model.dart';

class NotificationRepo{

  static final box = GetSecureStorage();
  static var notificationMainData = NotificationData();


  static Future<bool> getNotificationPage() async {
    var authToken = box.read(token);
    try {
      var res = await ApiServices.ApiProvider(
        0,
        url: '${Config.BaseUrl}${notificationList}',
        authToken: "Bearer ${authToken}",
      );
      Console.Log(title: 'getNotificationPage', message: res);
      var data = getNotificationModelFromJson(res);
      if (data.status == true) {
        //Console.Log(title: 'getUserProfileResponse', message: data.data!);
        notificationMainData = data.notificationData!;
        return false;
      } else {
        Console.Log(title: 'getNotificationPageError', message: data);
        return false;
      }
    } catch (e) {
      Console.Log(title: 'getNotificationPageError', message: e);
      return false;
    }
  }

  static Future<bool> readNotification() async {
    var authToken = box.read(token);
    try {
      var res = await ApiServices.ApiProvider(
        1,
        url: "${Config.BaseUrl}$notificationRead",
        authToken: "Bearer ${authToken}",
        body: {},
      );
      Console.Log(title: 'readNotification', message: res);
      var data = json.decode(res);
      if (data['status'] == true) {
        Console.Log(title: 'NotificationRes', message: data);
        return false;
      } else {
        Console.Log(title: 'NotificationError', message: data);
        return false;
      }
    } catch (e) {
      Console.Log(title: 'NotificationError', message: e);
      return false;
    }
  }
}