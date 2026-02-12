import 'package:get/get.dart';

import '../controller/suggetsed_repair_controller.dart';

class SuggestedRepairBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuggestedRepairController>(() => SuggestedRepairController());
  }
}