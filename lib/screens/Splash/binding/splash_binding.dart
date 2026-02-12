/**
 * Created by Jaimin on 30/05/24.
 */
import 'package:get/get.dart';

import '../../../screens/Splash/controller/splash_controller.dart';


class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
