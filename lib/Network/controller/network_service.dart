import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../components/custom_dialogs.dart';
import '../../routes/app_pages.dart';
import '../../widgets/custom_log.dart' show Console;

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  var isConnected = false.obs, isDialogOpen = false.obs;

  @override
  void onReady() {
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      Console.Log(title: 'Network', message: result[0]);
      isConnected.value = result[0] != ConnectivityResult.none;
      if (result[0] == ConnectivityResult.none &&
          Get.currentRoute != Routes.SPLASH) {
        isDialogOpen.value = true;
        CustomDialog.showCommonDialogBox(
          //context: Get.context!,
          title: 'No Internet',
          message: 'Please check your internet connection',
          image: 'assets/images/no_internet_icon.png',
          onTap: () async {
            await _connectivity.checkConnectivity();
          },
        );
      } else {
        if (isDialogOpen.value == true) {
          Get.back();
        }
      }
    });
    checkInitialConnectivity();
    super.onReady();
  }

  Future<void> checkInitialConnectivity() async {
    List<ConnectivityResult> result = await _connectivity.checkConnectivity();
    isConnected.value = result[0] != ConnectivityResult.none;
  }
}
