import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DamageDetailController extends GetxController{

  var title = ''.obs;
  var damageImage = Rxn<Uint8List>();
var  nameController = TextEditingController();

  // @override
  // void onInit() {
  //   super.onInit();
  //   _extractArguments();
  // }
  void _extractArguments() {
    final dynamic args = Get.arguments;
      // Map data was passed

      title.value = args['title']?.toString() ?? 'No Title';
      damageImage.value = args['damageImage'] as Uint8List;

  }
  final TextEditingController damageNameController = TextEditingController();
}