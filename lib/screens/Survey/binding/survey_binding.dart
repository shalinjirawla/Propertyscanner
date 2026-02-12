import 'package:get/get.dart';
import 'package:property_scan_pro/screens/Survey/controller/survey_controller.dart';

class SurveyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SurveyController>(() => SurveyController());
  }
}