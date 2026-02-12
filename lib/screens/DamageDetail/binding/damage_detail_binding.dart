import 'package:get/get.dart';
import 'package:property_scan_pro/screens/DamageDetail/controller/damage_detail_controller.dart';

class DamageDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DamageDetailController>(() => DamageDetailController());
  }
}