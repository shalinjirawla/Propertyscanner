import 'package:get/get.dart';

import '../controller/3d_walkthrough_controller.dart';

class ThreeDWalkthroughBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThreeDWalkthroughController>(() => ThreeDWalkthroughController());
  }
}