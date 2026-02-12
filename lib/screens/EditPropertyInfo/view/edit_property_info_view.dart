import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/controller/damage_repair_tab_controller.dart';
import 'package:property_scan_pro/screens/EditPropertyInfo/controller/edit_property_info_controller.dart';
import 'package:property_scan_pro/screens/YoloCamera/controller/yolocamera_controller.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../components/custom_bottom_navigtion.dart';
import '../../../components/custom_snackbar.dart';
import '../../../components/custom_textfield.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/Height_Width.dart';
import '../../../utils/colors.dart';

class EditPropertyInfoView extends StatefulWidget {
  const EditPropertyInfoView({super.key});

  @override
  State<EditPropertyInfoView> createState() => _EditPropertyInfoViewState();
}

class _EditPropertyInfoViewState extends State<EditPropertyInfoView> {
  var editPropertyController = Get.put(EditPropertyInfoController());
  var yoloCameraController = Get.put(YoloCameraController());
  @override
  void initState() {
    editPropertyController.propertyNameController.text = yoloCameraController.propertyNameController.value.text;
   editPropertyController.propertyAddressController.text  = yoloCameraController.propertyAddController.value.text ;
    print("hhhhhhh${ editPropertyController.propertyAddressController.text}");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDarkAppBar(
        height: 80,
        title: "Edit Property Info",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 2.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 3.w,vertical: 3.h),
                  child: Column(
                    children: [
                      TextFieldWithName(
                        fieldName: "Property Name",
                        imp: "*",
                        controller: editPropertyController.propertyNameController,
                        hintText: "e.g., 123 Main Street Condo",
                      ),
                      height2,
                      TextFieldWithName(
                        fieldName: "Property Address",
                        imp: "*",
                        controller: editPropertyController.propertyAddressController,
                        hintText: "e.g., Apt 4B, Springfield, IL 62704",
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: (){
                    if (editPropertyController.propertyNameController.value.text.isEmpty) {
                      showWarningSnackBar(message: 'Please enter property name');
                      return;
                    }
                    if (editPropertyController.propertyAddressController.value.text.isEmpty) {
                      showWarningSnackBar(message: 'Please enter property address');
                      return;
                    }
                    yoloCameraController.propertyNameController.value.text = editPropertyController.propertyNameController.value.text;
                    yoloCameraController.propertyAddController.value.text = editPropertyController.propertyAddressController.value.text;
                    print("kkjkjksdj${yoloCameraController.propertyAddController.value.text}");
                    yoloCameraController.update(['propertyName']);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
