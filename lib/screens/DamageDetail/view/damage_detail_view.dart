import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/screens/DamageDetail/controller/damage_detail_controller.dart';
import 'package:property_scan_pro/screens/YoloCamera/controller/yolocamera_controller.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../components/custom_bottom_navigtion.dart';
import '../../../components/custom_snackbar.dart';
import '../../../components/custom_textfield.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme/app_colors.dart';

class DamageDetailView extends StatefulWidget {
  final int? index;
  final Map<String, dynamic>? item;
  const DamageDetailView({super.key,  this.index,
     this.item,});

  @override
  State<DamageDetailView> createState() => _DamageDetailViewState();
}

class _DamageDetailViewState extends State<DamageDetailView> {
  var controller = Get.put(DamageDetailController());
  var yoloController = Get.put(YoloCameraController());
  @override
  void initState() {
    controller.nameController = TextEditingController(text: widget.item?['name']);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return /*Scaffold(
   appBar:CustomAppBar(
        height: 12.h,userName: "Damage Details",),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 3.w,vertical: 3.h),
          child: Column(
            children: [
              Container(
                height: 40.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: MemoryImage( widget.item?['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              height2,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: white,
                  border: Border.all(color: hintColor,width: 1),
                ),
                child: TextFieldWithName(
                  fieldName: "Damage Title",
                  imp: "*",
                  controller: controller.nameController,
                  hintText: controller.title.toString(),
                ),
              ),
              height2,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: white,
                  border: Border.all(color: hintColor,width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Observation Notes".customText(
                        fontWeight: FontWeight.w600,
                        color: black,
                        size: 10.sp
                    ),
                    height1,
                    "Water stain visible near light fixture. Paint peeling.".customText(
                      fontWeight: FontWeight.w400,
                      color: grey,
                      size: 11.sp,
                    )
                  ],
                ),
              ),
              height2,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: white,
                  border: Border.all(color: hintColor,width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Date Captured".customText(
                        fontWeight: FontWeight.w600,
                        color: black,
                        size: 10.sp
                    ),
                    height1,
                    "Oct 24, 2023 at 10:45 AM".customText(
                      fontWeight: FontWeight.w400,
                      color: grey,
                      size: 11.sp,
                    )
                  ],
                ),
              ),
              height2,
              CustomRowButton(
                rowWidget: Icon(Icons.video_camera_back_rounded,color: white,size: 25,),
                title: "Save Changes",
                height: 7.h,
                buttonColor: primaryColor,
                textColor: white,
                onTap: (){
                  yoloController.editImageName(widget.index!, controller.nameController.text);
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );*/
      Scaffold(
        appBar: CustomDarkAppBar(
          height: 80,
          title: 'Damage Details',
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              height2,
              if (widget.item?['image'] != null)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 14),
                  height: Get.height/1.7,
                  decoration: BoxDecoration( color: AppColors.divider,
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: MemoryImage( widget.item?['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  height: Get.height/2,
                  color: AppColors.divider,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 80,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Text(
                    damage.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),*/

                    TextFieldWithName(
                      fieldName: 'Damage Name',
                      imp: "*",
                      controller: controller.nameController,
                      hintText: "e.g., 123 Main Street Condo",
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: (){
                    if (controller.nameController.text.isEmpty) {
                      showWarningSnackBar(message: 'Please enter Damage Name');
                      return;
                    }
                    yoloController.editImageName(widget.index!, controller.nameController.text);
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
      );
  }
}
