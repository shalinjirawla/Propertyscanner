import 'package:get/get.dart';

import '../controller/damage_repair_tab_controller.dart';

class DamageRepairTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DamageRepairTabController>(() => DamageRepairTabController());
  }
}