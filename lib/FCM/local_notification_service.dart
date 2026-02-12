
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../screens/Notification/controller/notification_controller.dart';
import '../widgets/custom_log.dart';


class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false, //true,
      badge: false, //true,
      sound: false,
    );
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    ); /*onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        Console.Log(title: 'Notification Tap', message: payload);
      },*/
    //notificationCategories: darwinNotificationCategories,
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    onNotification();
  }

  static void notificationTapBackground(
      NotificationResponse notificationResponse) async {
    // handle action
    final String? payload = notificationResponse.payload;
    var data = json.decode(notificationResponse.payload ?? "");
     Console.Log(title: 'Notification Tap', message: payload);
     Console.Log(title: 'Notification Tap', message: data);
  }

  //after initialize we create channel in displayNotification method

  static void displayNotification(RemoteMessage message) async {
    Console.Log(message: message.notification!.title!, title: 'Notifications');
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "Property Scan Pro",
          "com.app.property_scan_pro",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: json.encode(message.data),
        //payload: message.data['USER_REQUEST_SEND'],
      );
    } on Exception catch (e) {
      print('Display Notification error : $e');
    }
  }

  static void getNotificationPermission() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  static void onNotification() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    // getInitialMessage: When the app is closed and it receives a push notification
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        Console.Log(title: 'KilledOpenedApp', message: message.data);
      }
    });

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        Console.Log(title: 'onNotificationPayload', message: message.data);
        LocalNotificationService.displayNotification(message);

        if (message.data.isNotEmpty) {
          if (message.data['type'].toString() != 'inapp') {
            displayNotification(message);
          }
          if (message.data['type'] != null ||
              message.data['type'].toString().isNotEmpty) {
            if (message.data['type'].toString() == 'badge') {
              // var profileController = Get.put(ProfileController());
              // profileController.getUserBadges();
              // Get.to(
              //   () => EarnedBadgeView(
              //     badgeData: message.data,
              //   ),
              // );
            }
            if (message.data['type'].toString() == 'inapp') {
              var notificationController = Get.put(NotificationController());
              notificationController.getNotificationPageList();
            }
          }
        }
      },
    );

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        Console.Log(title: 'onMessageOpenedApp', message: message.data);
      },
    );
  }


  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
  }
}
