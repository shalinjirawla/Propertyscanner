import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/screens/3DWalkthrough/controller/3d_walkthrough_controller.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../components/custom_bottom_navigtion.dart';
import '../../../components/custom_snackbar.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/usdz_helper.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/Height_Width.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/custom_button.dart';

class ThreeDSurveyView extends StatefulWidget {
  const ThreeDSurveyView({super.key});

  @override
  State<ThreeDSurveyView> createState() => _ThreeDSurveyViewState();
}

class _ThreeDSurveyViewState extends State<ThreeDSurveyView> {
  var controller = Get.put(ThreeDWalkthroughController());

  @override
  void initState() {
    finishedSurvey();
    super.initState();
  }

  void finishedSurvey(){
    controller.flutterRoomplan.onRoomCaptureFinished(() async {
      debugPrint('Room scan completed');
      // Get the USDZ and JSON file paths after scan is complete
      final usdzPath = await controller.flutterRoomplan.getUsdzFilePath();
      final jsonPath = await controller.flutterRoomplan.getJsonFilePath();
      print('usdzPath>>>. ${usdzPath}');
      final thumbPath = await generateUsdzThumbnail('file://${usdzPath!}');

      setState(() {
        controller.usdzFilePath = usdzPath;
        controller.jsonFilePath = jsonPath;
       // controller.currentModels.add({'image': thumbPath, 'model': usdzPath});
      });
      await controller.readAndComputeArea(jsonPath!);
      await controller.calculateAreaFromJson(jsonPath);
      print('usdzPath>>>.>>>>>>>>>>. ${controller.usdzFilePath}');
await controller.addThreeDModelApi(bodyData: {
    'property_name':controller.propertyNameController.text.trim(),
    'property_address': controller.propertyAddressController.text.trim(),
      'model':  controller.usdzFilePath,
      'dimensions':  "${controller.lengthMeters?.toStringAsFixed(2)}m × ${controller.heightMeters?.toStringAsFixed(2)}m × ${controller.widthMeters?.toStringAsFixed(2)}m",
});
      //await calculateAreaFromJson(jsonPath!);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDarkAppBar(
       title: "Start 3D Walkthrough",height: 70,),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 2.w),
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 3.w,vertical: 3.h),
                child: Column(
                  children: [
                    TextFieldWithName(
                      fieldName: "Property Name",
                      imp: "*",
                      controller: controller.propertyNameController,
                      hintText: "e.g., 123 Main Street Condo",
                    ),
                    height2,
                    TextFieldWithName(
                      fieldName: "Property Address",
                      imp: "*",
                      controller: controller.propertyAddressController,
                      hintText: "e.g., Apt 4B, Springfield, IL 62704",
                    ),
                  ],
                ),
              ),
              height6,
           controller.isLoadingModel.value ? CircularProgressIndicator():
              CustomThemeButton(
                backgroundColor: AppColors.primary,
                height: 60,
                text: "Start 3D Scan",
                icon: Icons.qr_code_scanner,
                onPressed: () async {
                  if (!await checkInternetConnection()) return;
                  if (controller!.propertyNameController.text.isEmpty) {
                    showWarningSnackBar(message: 'Please enter property name');
                    return;
                  }
                  if (controller!.propertyAddressController.text.isEmpty) {
                    showWarningSnackBar(message: 'Please enter property address');
                    return;
                  }
                  controller.flutterRoomplan.startScan(enableMultiRoom: false);
                },
                isOutlined: false,
                textColor: Colors.black,
                iconColor: Colors.black,
                borderColor: AppColors.black,
              ),
              height6,
              "Walk slowly around the property while scanning. Keep the device steady for best results.".customText(
                size: 10.sp,
                color: AppColors.textSecondary,
                textAlign: TextAlign.center
              )
            ],
          ),
        ),
      ),
    );
  }
}
