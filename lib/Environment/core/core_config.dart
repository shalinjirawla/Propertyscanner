import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_upgrade_version/flutter_upgrade_version.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';


import '../../Environment/Config/config_dev.dart' as dev;
import '../../Environment/Config/config_prod.dart' as prod;
import '../../Environment/Config/config_test.dart' as staging;
import '../../FCM/local_notification_service.dart';
import '../../Network/controller/network_service.dart';


enum Environment { dev, test, prod }

class ConfigApp {
  static Future<void> initApp() async {
    try{
    await Firebase.initializeApp();
    LocalNotificationService.initialize();
    FirebaseMessaging.onBackgroundMessage(
      LocalNotificationService.firebaseMessagingBackgroundHandler,
    );
    await GetSecureStorage.init();
    //await initServices();
    checkUpdate();
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
      // You might want to show an error dialog or handle this gracefully
      rethrow;
    }
  }


  static Future<void> initServices() async {
    await Get.putAsync(() async => ConnectivityService());
  }


  static void disableRotation() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        //statusBarBrightness: Brightness.light,
      ),
    );
  }

  static void checkUpdate() async {
    /// Android
    if (Platform.isAndroid) {
      //PackageInfo _packageInfo = await PackageManager.getPackageInfo();
      InAppUpdateManager manager = InAppUpdateManager();
      AppUpdateInfo? appUpdateInfo = await manager.checkForUpdate();
      if (appUpdateInfo == null) return; //Exception
      if (appUpdateInfo.updateAvailability ==
          UpdateAvailability.developerTriggeredUpdateInProgress) {
        ///If an in-app update is already running, resume the update.
        String? message =
            await manager.startAnUpdate(type: AppUpdateType.immediate);

        ///message return null when run update success
      } else if (appUpdateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        if (appUpdateInfo.flexibleAllowed) {
          debugPrint('Start an flexible update');
          String? message =
              await manager.startAnUpdate(type: AppUpdateType.flexible);
        } else {
          debugPrint(
              'Update available. Immediate & Flexible Update Flow not allow');
        }
      }
    }
  }
}

class Config {
  static Environment? appEnvironment;

  static String get appVersion {
    switch (appEnvironment) {
      case Environment.prod:
        return prod.AppVersion;
      case Environment.test:
        return staging.AppVersion;
      case Environment.dev:
      default:
        return dev.AppVersion;
    }
  }

  static String get BaseUrl {
    switch (appEnvironment) {
      case Environment.prod:
        return prod.BASEURL;
      case Environment.test:
        return staging.BASEURL;
      case Environment.dev:
      default:
        return dev.BASEURL;
    }
  }


  static String get storeUrl {
    switch (appEnvironment) {
      case Environment.prod:
        if (Platform.isAndroid) {
          return prod.PLAYSTOREURL;
        } else if (Platform.isIOS) {
          return prod.APPSTOREURL;
        } else {
          return prod.PLAYSTOREURL;
        }

      case Environment.test:
        if (Platform.isAndroid) {
          return staging.PLAYSTOREURL;
        } else if (Platform.isIOS) {
          return staging.APPSTOREURL;
        } else {
          return staging.PLAYSTOREURL;
        }

      case Environment.dev:
      default:
        if (Platform.isAndroid) {
          return dev.PLAYSTOREURL;
        } else if (Platform.isIOS) {
          return dev.APPSTOREURL;
        } else {
          return dev.PLAYSTOREURL;
        }
    }
  }

}
