import 'package:get/get.dart';
import 'package:property_scan_pro/screens/Auth/controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}