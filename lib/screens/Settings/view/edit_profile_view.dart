import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:property_scan_pro/components/custom_textfield.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:property_scan_pro/utils/colors.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../components/custom_bottom_navigtion.dart';
import '../../../utils/Extentions.dart';
import '../../../utils/bounce_widget.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../utils/util.dart';
import '../../../widgets/custom_avatar_widget.dart';
import '../../../widgets/generic_dropdown_widget.dart';
import '../controller/settings_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>  with SingleTickerProviderStateMixin{
 var settingController = Get.put(SettingsController());
  bool _countryError = false;
  bool _genderError = false;
 AnimationController? animationController;



  @override
  void initState() {
    settingController.getDataProfile();
    animationController = AnimationController(vsync: this);
    super.initState();
  }
 void openBottomSheet() {
   Get.bottomSheet(
     enableDrag: true,
     isDismissible: true,
     backgroundColor: white,
     BottomSheet(
       onClosing: Get.back,
       builder: (context) => StatefulBuilder(
         builder: (context, setState) => Container(
           height: 250,
           width: Get.width,
           decoration: const BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.only(
               topRight: Radius.circular(20),
               topLeft: Radius.circular(20),
             ),
           ),
           padding: const EdgeInsets.only(left: 20),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               height1,
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   'Select Source'.customText(),
                   IconButton(
                     onPressed: Get.back,
                     icon: const Icon(Icons.cancel),
                   ),
                 ],
               ),
               space,
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   Bouncing(
                     onTap: () => onButtonTap(isCamera: false),
                     child: Column(
                       children: [
                         Container(
                           decoration: BoxDecoration(
                             color: primaryColor.withOpacity(0.5),
                             border: Border.all(color: primaryColor, width: 3),
                             borderRadius: BorderRadius.circular(15),
                           ),
                           padding: const EdgeInsets.all(15),
                           child: const Icon(
                             Icons.image,
                             size: 50,
                             color: Colors.white,
                           ),
                         ),
                         10.height,
                         'Gallery'.customText(),
                       ],
                     ),
                   ),
                   10.width,
                   Bouncing(
                     onTap: () => onButtonTap(isCamera: true),
                     child: Column(
                       children: [
                         Container(
                           decoration: BoxDecoration(
                             color: primaryColor.withOpacity(0.5),
                             border: Border.all(color: primaryColor, width: 3),
                             borderRadius: BorderRadius.circular(15),
                           ),
                           padding: const EdgeInsets.all(15),
                           child: const Icon(
                             Icons.camera_alt,
                             size: 50,
                             color: Colors.white,
                           ),
                         ),
                         10.height,
                         'Camera'.customText()
                       ],
                     ),
                   ),
                 ],
               ),
               space2,
             ],
           ),
         ),
       ),
       animationController: animationController,
       enableDrag: true,
     ),
   );
 }

 onButtonTap({bool? isCamera}) async {
   Get.back();
   settingController.pickedFile = await PickFile(isImage: true, isCamera: isCamera);
   if (settingController.pickedFile != null) {
     settingController.selectedFile = settingController.pickedFile!.path;
     settingController.update(['file']);
     settingController.isImageAvailable.value = false;
   }
 }

 @override
 void dispose() {
   animationController!.dispose();
   super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDarkAppBar(
        height: 70,
        title: "Profile settings",),
      body: Obx(
          ()=>settingController.isLoadingProfile.value?CircularProgressIndicator().centerExtension(): SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    color: AppColors.divider,
                    child: Center(
                      child: Bouncing(
                        onTap: () async {
                          openBottomSheet();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GetBuilder<SettingsController>(
                              id: 'file',
                              builder: (controller) => CircleAvatar(
                                maxRadius: 50,
                                backgroundColor: grey,
                                child:
                                    settingController.isImageAvailable.value
                                    ? CustomNetworkAvatar(
                                  imageUrl: settingController.profileImage.value,
                                  radius: 50,
                                )
                                    : controller.selectedFile == null
                                    ? const Icon(
                                  Icons.person_2_outlined,
                                  size: 40,
                                )
                                    : ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(50),
                                  child: Image.file(
                                    File(
                                      controller.selectedFile,
                                    ),
                                    alignment: Alignment.topCenter,
                                    fit: BoxFit.cover,
                                    width: Get.width,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: -12.w,
                              left: 0,
                              child: CircleAvatar(
                                maxRadius: 20,
                                backgroundColor: white,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: containerColor,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 15,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Center(
                  //   child: const Text(
                  //     'Update Your Profile',
                  //     style: TextStyle(
                  //       fontSize: 24,
                  //       fontWeight: FontWeight.w700,
                  //       color:white,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // Center(
                  //   child: const Text(
                  //     'Keep your information up to date',
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       color: Colors.grey,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 32),

                  // Full Name

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFieldWithName(
                      fieldName: "Full Name",
                      imp: "*",
                      controller: settingController.fullNameController.value,
                      hintText: "Enter Name Here......",
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFieldWithName(
                      fillColor: AppColors.textSecondary,
                      textColor: AppColors.black,
                      hintColor: AppColors.black,
                      fieldName: "Email",
                      imp: "*",
                      readOnly: true,
                      controller:  settingController.emailController.value,
                      hintText: "Enter Email Here......",
                    ),
                  ),
                  const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GenericDropdown<String>(
                          label: 'Gender',
                          hint: 'Select Gender',
                          items: const ['female', 'male', "other"],
                          selectedValue: settingController.selectedGender.value,
                          getLabel: (item) => item, // String items don't need transformation
                          getValue: (item) => item, // The value is the string itself
                          error: _genderError, // Add this if you have validation
                          onChanged: (val) {
                            setState(() {
                              settingController.selectedGender.value = val;
                              _genderError = false;
                            });
                          },
                        ),
                      ),
                ],
              ),
              height2,
             settingController.isLoadingProfileUpdate.value ? CircularProgressIndicator().centerExtension():
             Padding(
               padding: const EdgeInsets.all(20),
               child: ElevatedButton(
                 onPressed: (){
                   settingController.validateEditProfile();
                 },
                 style: ElevatedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(vertical: 16),
                 ),
                 child: const Text(
                   'Update',
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