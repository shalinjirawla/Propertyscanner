import 'package:get/get.dart';

import '../controller/edit_property_info_controller.dart';

class EditPropertyInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPropertyInfoController>(() => EditPropertyInfoController());
  }
}