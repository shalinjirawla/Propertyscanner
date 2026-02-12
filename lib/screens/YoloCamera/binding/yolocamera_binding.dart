import 'package:get/get.dart';

import '../controller/yolocamera_controller.dart';

class YoloCameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YoloCameraController>(() => YoloCameraController());
  }
}