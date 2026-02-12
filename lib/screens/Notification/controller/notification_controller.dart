import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/screens/Notification/repo/notification_repo.dart';

import '../../../widgets/custom_log.dart';
import '../../DashBoard/model/report_model.dart';
import '../model/notification_model.dart';
import '../view/notification_view.dart';

class NotificationController extends GetxController{

  var isLoadingNotification = false.obs;
  var notificationValueCount = 0.obs;
  var notificationPageDataList = <NotificationListData>[].obs;

  Future<void> getNotificationPageList() async {
    notificationPageDataList.clear();
    isLoadingNotification.value = true;
    isLoadingNotification.value = await NotificationRepo.getNotificationPage();
    Console.Log(
        message: NotificationRepo.notificationMainData,
        title: 'newNotification');
    notificationValueCount.value =
        NotificationRepo.notificationMainData.notificationCount ?? 0;
    if (NotificationRepo.notificationMainData.data != null) {
      notificationPageDataList.value = NotificationRepo.notificationMainData.data!;
    }
    update(['newNotification']);
  }

  void readNotification() async {
    await NotificationRepo.readNotification();
    getNotificationPageList();
  }
}