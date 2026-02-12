import 'package:get/get.dart';
import 'package:property_scan_pro/screens/EditRepairMaterial/controller/edit_repair_material_controller.dart';

class EditRepairMaterialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditRepairMaterialController>(() => EditRepairMaterialController());
  }
}