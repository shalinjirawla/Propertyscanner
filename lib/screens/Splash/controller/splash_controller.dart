import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:video_player/video_player.dart';

import '../../../Environment/core/core_config.dart';
import '../../../components/custom_dialogs.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/config.dart';
import '../../../utils/util.dart';
import '../../../widgets/custom_log.dart';
import '../repo/config_repo.dart';

class SplashController extends GetxController {
  final box = GetSecureStorage();
  var userToken, isNavigation = true.obs, isOnBoarding = false.obs;
  late VideoPlayerController controller;

  @override
  void onInit() {
    loadApp();
    //ConfigRepo.getSplashConfig();
    super.onInit();
  }

  loadApp() async {
    getMaintenanceConfig();
    getUpdateConfig();

        userToken = box.read(token);
        Console.Log(title: 'Token', message: userToken);
        isOnBoarding.value = box.read(onBoarding) ?? false;
        Timer(
          const Duration(seconds: 5),
          () {
            if (isNavigation.value) {
              if (userToken == null && !isOnBoarding.value) {
                Get.offAllNamed(Routes.ONBOARDING);
              } else if (userToken == null && isOnBoarding.value) {
                Get.offAllNamed(Routes.LOGIN);
              } else {
                Get.offAllNamed(Routes.DASHBOARD);
              }
            }
            //Get.delete<SplashController>();
          },
        );
        update();

  }

  Future<void> getUpdateConfig() async {
    await ConfigRepo.getSplashConfig();
    if (ConfigRepo.configsData != null) {
      Console.Log(title: 'ConfigRepo.configsData.forceUpdate', message: ConfigRepo.configsData.androidVersion);
      var isUpdateAvailable = ConfigRepo.configsData.forceUpdate;
      var updateVersionAndroid = ConfigRepo.configsData.androidVersion;
      var updateVersionIos = ConfigRepo.configsData.iosVersion;
      if(Platform.isAndroid){
        if (isUpdateAvailable == '1' &&
            updateVersionAndroid != Config.appVersion) {
          isNavigation.value = false;
          CustomDialog.showUpdateMaintenanceDialog(
            isMaintenance: false,
            onTap: () {
              launchUrls(url: Config.storeUrl);
            },
          );
        }
      }else{
        if (isUpdateAvailable == '1' &&
            updateVersionIos != Config.appVersion) {
          isNavigation.value = false;
          CustomDialog.showUpdateMaintenanceDialog(
            isMaintenance: false,
            onTap: () {
              launchUrls(url: Config.storeUrl);
            },
          );
        }
      }


    }
  }

  Future<void> getMaintenanceConfig() async {
    await ConfigRepo.getSplashConfig();
    if (ConfigRepo.configsData != null) {
      Console.Log(title: 'ConfigRepo.configsData.maintenanceMode', message: ConfigRepo.configsData.maintenanceMode);
      if (ConfigRepo.configsData.maintenanceMode == '1') {
        isNavigation.value = false;
        CustomDialog.showUpdateMaintenanceDialog(isMaintenance: true);
      }
    }
  }
}
