import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_scan_pro/screens/DamageDetail/view/damage_detail_view.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/controller/damage_repair_tab_controller.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/widget/video_view.dart';
import 'package:property_scan_pro/screens/YoloCamera/controller/yolocamera_controller.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

import '../../../Database/database_helper.dart';
import '../../../components/app_bar.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/custom_log.dart';
import '../../../components/custom_snackbar.dart';
import '../repo/damage_repair_repo.dart';

class DamageScreen extends StatefulWidget {
  DamageScreen({super.key});

  @override
  State<DamageScreen> createState() => _DamageScreenState();
}

class _DamageScreenState extends State<DamageScreen> {
  var controller = Get.put(YoloCameraController());
  var damageRepairController = Get.put(DamageRepairTabController());

  @override
  void initState() {
    print("ISEdit::::::::${damageRepairController.isEdit.value}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initVideo();
    });
    super.initState();
  }

  initVideo() async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (controller.isVideoMode.value) {
      if(controller.videoPath.value != null && controller.videoPath.value.isNotEmpty){
        controller.videoPlayerController = VideoPlayerController.file(
          File(controller.videoPath.value),
        );
        await controller.videoPlayerController!.initialize();
        controller.update();
        var audioPath = await _extractAudio(controller.videoPath.value);
        print('audioPath: $audioPath');
        if (audioPath.isNotEmpty) {
          transcribeAudio(audioPath, controller);
        } else {
          controller.isLoading.value = false;
        }
      }else{
        controller.isLoading.value = false;
      }

    } else {
      controller.isLoading.value = false;
    }
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getDownloadsDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<String> _extractAudio(String videoPath) async {
    controller.isLoading.value = true;
    var tempDir = await getDownloadPath();
    final String audioPath =
        '$tempDir/scan_${DateTime.now().millisecondsSinceEpoch}.mp3';

    final result = await FFmpegKit.execute(
      '-i "$videoPath" -vn -acodec libmp3lame -ar 16000 -ac 1 "$audioPath"',
    );
    print('audioConvertResult: $result');
    return audioPath;
  }

  var db = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomDarkAppBar(
        title: "Damage Details",
        onBackTap: () {
          Get.delete<YoloCameraController>();
          Get.offAllNamed(Routes.DASHBOARD);
        },
        height: 70,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () async {
            var connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult.contains(ConnectivityResult.none)) {
              // Offline Mode: Save to local DB

              // Validation Checks
              if (controller.propertyNameController.value.text.isEmpty) {
                showWarningSnackBar(message: 'Please enter property name');
                return;
              }
              if (controller.propertyAddController.value.text.isEmpty) {
                showWarningSnackBar(message: 'Please enter property address');
                return;
              }
              if (controller.speechController.value.text.isEmpty) {
                showWarningSnackBar(message: 'Please enter summary');
                return;
              }
              if (controller.captureImages.isEmpty) {
                showWarningSnackBar(message: 'Please add at least one image');
                return;
              }

              // Prepare damages list
              List<Map<String, dynamic>> damagesList = [];
              for (var item in controller.captureImages) {
                // Convert Uint8List image to Base64 string for JSON storage
                String? transformImage;
                if (item['image'] is Uint8List) {
                  transformImage = base64Encode(item['image']);
                } else if (item['image'] is String) {
                  // If it's already a path or string
                  transformImage = item['image'];
                }

                damagesList.add({
                  'damage_name': item['name'],
                  'image': transformImage, // Saved as Base64 string
                });
              }

              final report = ReportModel(
                title: controller.propertyNameController.value.text,
                address: controller.propertyAddController.value.text,
                summary: controller.speechController.value.text,
                scanVideoPath: controller.videoPath.value,
                damages: jsonEncode(damagesList), // Store as JSON string
                createdAt: DateTime.now(),
              );
              await db.insertReport(report);
              showSnackBar(
                isError: false,
                message: 'No Internet. Report saved locally.',
              );
              // Optional: Navigate back or clear
              Get.delete<YoloCameraController>();
              Get.offAllNamed(Routes.DASHBOARD);
            } else {
              // Online Mode: Existing flow
              damageRepairController.submitReport(controller);
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Save Report as Draft', style: TextStyle(fontSize: 16)),
        ),
      ),
      body: /*SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child:GetBuilder<YoloCameraController>(
                            id: 'propertyName', // unique id
                            builder: (controller) {
                              return controller.propertyNameController.value.text
                                  .customText(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                  size: 12.sp
                              );
                            }
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            GestureDetector(
                                onTap: (){
                                  Get.toNamed(Routes.EDITPROPERTYINFOVIEW);
                                },
                                child: Icon(Icons.edit,size: 3.h,color: white,)),

                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: GetBuilder<YoloCameraController>(
                            id: 'propertyName', // unique id
                            builder: (controller) {
                              return controller.propertyAddController.value.text
                                  .customText(
                                  fontWeight: FontWeight.w600,
                                  color: grey,
                                  size: 10.sp
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            height2,

            Obx(
                  () => controller.isVideoMode.value
                  ? Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan Summary:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5),
                    Obx(
                          () => controller.isLoading.value
                          ? Center(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            CircularProgressIndicator(
                              color: Colors.indigo,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Please wait... we are finalizing summary',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      )
                          : TextFormField(
                        controller:
                        controller.speechController.value,
                        maxLines: 6,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0XFFEFF1F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          hintText: 'Scan Summary',
                        ),
                        cursorColor: Colors.indigo,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : SizedBox.shrink(),
            ),
            height2,


            Obx(
                  () => controller.isVideoMode.value
                  ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF4F6F9),
                  borderRadius: BorderRadiusGeometry.circular(15),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Captured video:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 15),
                    GetBuilder<YoloCameraController>(
                      init: controller,
                      builder: (controller) =>
                      controller.videoPlayerController != null
                          ? GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoView(
                                videoPath:
                                controller.videoPath.value,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          height: 400,
                          width: double.infinity,
                          child: VideoPlayer(
                            controller.videoPlayerController!,
                          ),
                        ),
                      )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              )
                  : SizedBox.shrink(),
            ),

            height2,
            Obx(() =>
            controller.captureImages.isNotEmpty
                ?
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
                    "Damage Detected".customText(
                        fontWeight: FontWeight.w600,
                        color: black,
                        size: 12.sp
                    ),
                    height1,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.captureImages.length*/ /*damageItems.length*/ /*,
                      itemBuilder: (context, index) {
                        Console.Log(title: controller
                            .captureImages[index]['image'],message: "CaptureImagesss>>>>>>>");
                        Console.Log(title: controller
                            .captureImages[index]['name'],message: "CaptureName>>>>>>>");
                        return Container(
                          margin: EdgeInsets.only(bottom: 1.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white54,
                              border: Border.all(color: hintColor, width: 1),
                            ),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 10.h,
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: MemoryImage(controller
                                            .captureImages[index]['image']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                "${controller
                                    .captureImages[index]['name']}".toString().customText(
                                  size: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: grey,
                                ),
                                width3,

                                   Row(
                                     children: [
                                       GestureDetector(
                                           onTap: (){

                                             Get.to(DamageDetailView(
                                               index: index,
                                               item: controller.captureImages[index],
                                             ));
                                           },
                                       child: Icon(Icons.edit, size: 3.h).gradient(AppGradients.primaryGradient)),
                                       width3,
                                       GestureDetector(
                                           onTap: (){
                                            damageRepairController.showDeleteConfirmation(context, controller.captureImages[index]["name"], (){
                                              controller.deleteImage(index);
                                              Get.back();
                                            });
                                           },
                                           child: Icon(Icons.delete, size: 3.h,color: Colors.red,)),
                                     ],
                                   ),

                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
                : SizedBox.shrink()
            ),
          ],
        ),
      ),*/ SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Info Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.fieldBorder, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetBuilder<YoloCameraController>(
                        id: 'propertyName',
                        builder: (controller) {
                          return Text(
                            controller.propertyNameController.value.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.EDITPROPERTYINFOVIEW);
                        },
                        child: Icon(
                          Icons.edit_outlined,
                          size: 3.h,
                          color: AppColors.fieldBorder,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  GetBuilder<YoloCameraController>(
                    id: 'propertyName',
                    builder: (controller) {
                      return Text(
                        controller.propertyAddController.value.text,
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 11.sp,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            /*Obx(
                  () =>*/
            /*controller.isVideoMode.value
                  ?*/
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'Scan Summary:',
                  //   style: TextStyle(
                  //     color: white,
                  //     fontSize: 18,
                  //   ),
                  // ),
                  // SizedBox(height: 5),
                  Obx(
                    () => controller.isLoading.value
                        ? Center(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                CircularProgressIndicator(color: white),
                                SizedBox(height: 10),
                                Text(
                                  'Please wait... we are finalizing summary',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.fieldBorder,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Scan Summary',
                                        style: TextStyle(
                                          color: white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      /*Icon(
                                        Icons.edit_outlined,
                                        size: 3.h,
                                        color: AppColors.fieldBorder,
                                      ),*/
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                TextFormField(
                                  controller: controller.speechController.value,
                                  maxLines: 6,
                                  textInputAction:
                                      TextInputAction.done, // Add this
                                  onEditingComplete: () {
                                    FocusScope.of(
                                      context,
                                    ).unfocus(); // Dismiss keyboard
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.cardBg,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    // hintText: 'Scan Summary',
                                    // hintStyle: TextStyle(
                                    //   color: AppColors.textSecondary,
                                    // )
                                  ),
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
            /*: SizedBox.shrink()*/
            //),
            height2,

            // Video Walkthrough Section
            Obx(
              () => controller.isVideoMode.value
                  ? Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Captured Video",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        height2,
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GetBuilder<YoloCameraController>(
                                init: controller,
                                builder: (controller) =>
                                    controller.videoPlayerController != null
                                    ? GestureDetector(
                                        onTap: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => VideoView(
                                                videoPath:
                                                    controller.videoPath.value,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 250,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                                child: VideoPlayer(
                                                  controller
                                                      .videoPlayerController!,
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  height: 70,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    color: Color(0xFF00BCD4),
                                                    size: 40,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/warning_icon.png',
                                            scale: 3,
                                          ),
                                          2.height,
                                          "Screen recording permission is not enabled, so video recording is unavailable. You can continue without recording or start a new survey and grant permission.".customText(
                                            fontWeight: FontWeight.w500,
                                            size: 12.sp,
                                            color: white,
                                            textAlign: TextAlign.center
                                          ),
                                        ],
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ),

            SizedBox(height: 20),

            // Detailed Damages Section
            Obx(
              () => controller.captureImages.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Damages Detected',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.captureImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(12),
                                leading: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        controller
                                            .captureImages[index]['image'],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "${controller.captureImages[index]['name']}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          DamageDetailView(
                                            index: index,
                                            item:
                                                controller.captureImages[index],
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Color(0xFF00BCD4),
                                        size: 22,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () {
                                        damageRepairController
                                            .showDeleteConfirmation(
                                              context,
                                              controller
                                                  .captureImages[index]["name"],
                                              () {
                                                controller.deleteImage(index);
                                                Get.back();
                                              },
                                            );
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class DamageItem {
  final String title;
  final String imagePath;

  DamageItem(this.title, this.imagePath);
}




// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:property_scan_pro/screens/DamageDetail/view/damage_detail_view.dart';
// import 'package:property_scan_pro/screens/DamageRepairTab/controller/damage_repair_tab_controller.dart';
// import 'package:property_scan_pro/screens/DamageRepairTab/widget/video_view.dart';
// import 'package:property_scan_pro/screens/YoloCamera/controller/yolocamera_controller.dart';
// import 'package:property_scan_pro/utils/Extentions.dart';
// import 'package:property_scan_pro/utils/Height_Width.dart';
// import 'package:sizer/sizer.dart';
// import 'package:video_player/video_player.dart';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
//
// import '../../../Database/database_helper.dart';
// import '../../../components/app_bar.dart';
// import '../../../routes/app_pages.dart';
// import '../../../utils/colors.dart';
// import '../../../utils/theme/app_colors.dart';
// import '../../../widgets/custom_log.dart';
// import '../repo/damage_repair_repo.dart';
//
// class DamageScreen extends StatefulWidget {
//   DamageScreen({super.key});
//
//   @override
//   State<DamageScreen> createState() => _DamageScreenState();
// }
//
// class _DamageScreenState extends State<DamageScreen> {
//   var controller = Get.put(YoloCameraController());
//   var damageRepairController = Get.put(DamageRepairTabController());
//
//   @override
//   void initState() {
//     print("ISEdit::::::::${damageRepairController.isEdit.value}");
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       initVideo();
//     });
//     super.initState();
//   }
//
//   initVideo() async {
//     FocusManager.instance.primaryFocus!.unfocus();
//
//     // Determine which video to use
//     String videoToProcess = '';
//
//     if (controller.isUploadedVideo.value) {
//       // Use uploaded video
//       videoToProcess = controller.uploadedVideoPath.value;
//       print('📹 Using uploaded video: $videoToProcess');
//     } else if (controller.isVideoMode.value) {
//       // Use recorded video
//       videoToProcess = controller.videoPath.value;
//       print('📹 Using recorded video: $videoToProcess');
//     }
//
//     if (videoToProcess.isNotEmpty) {
//       controller.videoPlayerController = VideoPlayerController.file(
//         File(videoToProcess),
//       );
//       await controller.videoPlayerController!.initialize();
//       controller.update();
//
//       // ⭐ Extract and transcribe audio for BOTH recorded and uploaded videos
//       var audioPath = await _extractAudio(videoToProcess);
//       print('audioPath: $audioPath');
//       if (audioPath.isNotEmpty) {
//         transcribeAudio(audioPath, controller);
//       } else {
//         controller.isLoading.value = false;
//       }
//     } else {
//       controller.isLoading.value = false;
//     }
//   }
//
//   Future<String?> getDownloadPath() async {
//     Directory? directory;
//     try {
//       if (Platform.isIOS) {
//         directory = await getApplicationDocumentsDirectory();
//       } else {
//         directory = await getDownloadsDirectory();
//       }
//     } catch (err, stack) {
//       print("Cannot get download folder path");
//     }
//     return directory?.path;
//   }
//
//   Future<String> _extractAudio(String videoPath) async {
//     controller.isLoading.value = true;
//     var tempDir = await getDownloadPath();
//     final String audioPath =
//         '$tempDir/scan_${DateTime.now().millisecondsSinceEpoch}.mp3';
//
//     final result = await FFmpegKit.execute(
//       '-i "$videoPath" -vn -acodec libmp3lame -ar 16000 -ac 1 "$audioPath"',
//     );
//     print('audioConvertResult: $result');
//     return audioPath;
//   }
//
//   var db = DatabaseHelper.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: CustomDarkAppBar(
//         title: "Damage Details",
//         onBackTap: () {
//           Get.delete<YoloCameraController>();
//           Get.offAllNamed(Routes.DASHBOARD);
//         },
//         height: 70,
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(20),
//         child: ElevatedButton(
//           onPressed: () {
//             damageRepairController.submitReport(controller);
//           },
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//           ),
//           child: const Text(
//             'Save Report',
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Property Info Card
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: AppColors.cardBg,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: AppColors.fieldBorder,
//                   width: 2,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: GetBuilder<YoloCameraController>(
//                           id: 'propertyName',
//                           builder: (controller) {
//                             return Text(
//                               controller.propertyNameController.value.text,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Get.toNamed(Routes.EDITPROPERTYINFOVIEW);
//                         },
//                         child: Icon(Icons.edit_outlined,
//                             size: 3.h, color: AppColors.fieldBorder),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   GetBuilder<YoloCameraController>(
//                     id: 'propertyName',
//                     builder: (controller) {
//                       return Text(
//                         controller.propertyAddController.value.text,
//                         style: TextStyle(
//                           color: Color(0xFF9CA3AF),
//                           fontSize: 11.sp,
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 20),
//
//             // ⭐ Scan Summary Section - Show for BOTH recorded and uploaded videos
//             /*Obx(() => (controller.isVideoMode.value || controller.isUploadedVideo.value)
//                 ?*/ Padding(
//               padding: const EdgeInsets.only(bottom: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Obx(
//                         () => controller.isLoading.value
//                         ? Center(
//                       child: Column(
//                         children: [
//                           SizedBox(height: 20),
//                           CircularProgressIndicator(
//                             color: white,
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             controller.isUploadedVideo.value
//                                 ? 'Extracting audio from uploaded video...'
//                                 : 'Please wait... we are finalizing summary',
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           SizedBox(height: 15),
//                         ],
//                       ),
//                     )
//                         : Container(
//                       decoration: BoxDecoration(
//                         color: AppColors.cardBg,
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: AppColors.fieldBorder,
//                           width: 2,
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       controller.isUploadedVideo.value
//                                           ? 'Video Summary'
//                                           : 'Scan Summary',
//                                       style: TextStyle(
//                                         color: white,
//                                         fontSize: 18,
//                                       ),
//                                     ),
//                                     if (controller.isUploadedVideo.value)
//                                       Padding(
//                                         padding: EdgeInsets.only(left: 8),
//                                         child: Container(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: 8,
//                                             vertical: 4,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: AppColors.primary.withOpacity(0.2),
//                                             borderRadius: BorderRadius.circular(8),
//                                             border: Border.all(
//                                               color: AppColors.primary,
//                                               width: 1,
//                                             ),
//                                           ),
//                                           child: Row(
//                                             children: [
//                                               Icon(
//                                                 Icons.mic,
//                                                 size: 12,
//                                                 color: AppColors.primary,
//                                               ),
//                                               SizedBox(width: 4),
//                                               Text(
//                                                 'Audio Transcript',
//                                                 style: TextStyle(
//                                                   color: AppColors.primary,
//                                                   fontSize: 8.sp,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                                 Icon(Icons.edit_outlined,
//                                     size: 3.h,
//                                     color: AppColors.fieldBorder)
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           TextFormField(
//                             controller: controller
//                                 .speechController.value,
//                             maxLines: 6,
//                             textInputAction: TextInputAction.done,
//                             onEditingComplete: () {
//                               FocusScope.of(context).unfocus();
//                             },
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: AppColors.cardBg,
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide.none,
//                                 borderRadius:
//                                 BorderRadius.circular(16),
//                               ),
//                               hintText: controller.isUploadedVideo.value
//                                   ? 'Audio transcript from uploaded video...'
//                                   : 'Scan summary...',
//                               hintStyle: TextStyle(
//                                 color: AppColors.textSecondary.withOpacity(0.5),
//                               ),
//                             ),
//                             cursorColor: Colors.white,
//                             style: TextStyle(
//                               color: AppColors.white,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//                 /*: SizedBox.shrink()),*/
//
//             height2,
//
//             // Video Section - Show for both recorded and uploaded videos
//             Obx(() => (controller.isVideoMode.value || controller.isUploadedVideo.value)
//                 ? Column(
//               children: [
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: Row(
//                     children: [
//                       Text(
//                         controller.isUploadedVideo.value
//                             ? "Uploaded Video"
//                             : "Captured Video",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       if (controller.isUploadedVideo.value)
//                         Padding(
//                           padding: EdgeInsets.only(left: 8),
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: AppColors.primary.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(
//                                 color: AppColors.primary,
//                                 width: 1,
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.video_library,
//                                   size: 12,
//                                   color: AppColors.primary,
//                                 ),
//                                 SizedBox(width: 4),
//                                 Text(
//                                   'From Gallery',
//                                   style: TextStyle(
//                                     color: AppColors.primary,
//                                     fontSize: 8.sp,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 height2,
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Color(0xFF2A2A2A),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       GetBuilder<YoloCameraController>(
//                         init: controller,
//                         builder: (controller) =>
//                         controller.videoPlayerController != null
//                             ? GestureDetector(
//                           onTap: () async {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     VideoView(
//                                       videoPath: controller
//                                           .isUploadedVideo.value
//                                           ? controller
//                                           .uploadedVideoPath
//                                           .value
//                                           : controller
//                                           .videoPath.value,
//                                     ),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             height: 250,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(16),
//                                 topRight: Radius.circular(16),
//                               ),
//                             ),
//                             child: Stack(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius:
//                                   BorderRadius.all(
//                                       Radius.circular(16)),
//                                   child: VideoPlayer(
//                                     controller
//                                         .videoPlayerController!,
//                                   ),
//                                 ),
//                                 Center(
//                                   child: Container(
//                                     height: 70,
//                                     width: 70,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Icon(
//                                       Icons.play_arrow,
//                                       color: Color(0xFF00BCD4),
//                                       size: 40,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                             : SizedBox.shrink(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//                 : SizedBox.shrink()),
//
//             SizedBox(height: 20),
//
//             // Detailed Damages Section
//             Obx(() => controller.captureImages.isNotEmpty
//                 ? Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Damages Detected',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.red.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                           color: Colors.red,
//                           width: 1,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.warning_amber_rounded,
//                             size: 16,
//                             color: Colors.red,
//                           ),
//                           SizedBox(width: 6),
//                           Text(
//                             '${controller.captureImages.length} Found',
//                             style: TextStyle(
//                               color: Colors.red,
//                               fontSize: 9.sp,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: controller.captureImages.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       margin: EdgeInsets.only(bottom: 12),
//                       decoration: BoxDecoration(
//                         color: Color(0xFF2A2A2A),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Colors.red.withOpacity(0.3),
//                           width: 1,
//                         ),
//                       ),
//                       child: ListTile(
//                         contentPadding: EdgeInsets.all(12),
//                         leading: Container(
//                           height: 60,
//                           width: 60,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(
//                               color: Colors.red.withOpacity(0.5),
//                               width: 2,
//                             ),
//                             image: DecorationImage(
//                               image: MemoryImage(
//                                 controller.captureImages[index]
//                                 ['image'],
//                               ),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           "${controller.captureImages[index]['name']}",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         subtitle: Text(
//                           'Tap to view details',
//                           style: TextStyle(
//                             color: Colors.grey[500],
//                             fontSize: 8.sp,
//                           ),
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Get.to(DamageDetailView(
//                                   index: index,
//                                   item: controller.captureImages[index],
//                                 ));
//                               },
//                               child: Icon(
//                                 Icons.edit,
//                                 color: Color(0xFF00BCD4),
//                                 size: 22,
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             GestureDetector(
//                               onTap: () {
//                                 damageRepairController
//                                     .showDeleteConfirmation(
//                                   context,
//                                   controller.captureImages[index]
//                                   ["name"],
//                                       () {
//                                     controller.deleteImage(index);
//                                     Get.back();
//                                   },
//                                 );
//                               },
//                               child: Icon(
//                                 Icons.delete,
//                                 color: Colors.red,
//                                 size: 22,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             )
//                 : SizedBox.shrink()),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class DamageItem {
//   final String title;
//   final String imagePath;
//
//   DamageItem(this.title, this.imagePath);
// }