import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/components/custom_bottom_navigtion.dart';
import 'package:property_scan_pro/screens/SuggestedRepair/controller/suggetsed_repair_controller.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../components/custom_textfield.dart';
import '../../../utils/Height_Width.dart';
import '../../../utils/colors.dart';

class EditDamageView extends StatefulWidget {
  const EditDamageView({super.key});

  @override
  State<EditDamageView> createState() => _EditDamageViewState();
}

class _EditDamageViewState extends State<EditDamageView> {
  var controller = Get.put(SuggestedRepairController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: CustomAppBar(
        height: 12.h,userName: "Edit Damage Name",),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 2.w),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: white,
                border: Border.all(color: hintColor,width: 1),
              ),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 3.w,vertical: 3.h),
                child: Column(
                  children: [
                    TextFieldWithName(
                      fieldName: "Damage Name",
                      imp: "*",
                      controller: controller.damageNameController,
                      hintText: "e.g., 123 Main Street Condo",
                    ),
                  ],
                ),
              ),
            ),
            height6,
            CustomButton(
              title: "Save Changes",
              height: 7.h,
              buttonColor: primaryColor,
              textColor: white,
              onTap: (){
                //Get.toNamed(Routes.YOLOCAMERAVIEW);
              },
            ),
          ],
        ),
      ),
    );
  }
}
