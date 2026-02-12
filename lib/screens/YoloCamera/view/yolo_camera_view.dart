/**
 * Created by Jaimin on 08/09/25.
 * Updated: Deferred duplicate image processing
 * File: yolo_view.dart
 */

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_scan_pro/screens/YoloCamera/controller/yolocamera_controller.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/image_hash.dart';
import '../../../utils/theme/app_colors.dart';
import '../../DamageRepairTab/controller/damage_repair_tab_controller.dart';

class YoloCameraView extends StatefulWidget {
  const YoloCameraView({super.key});

  @override
  State<YoloCameraView> createState() => _YoloCameraViewState();
}

class _YoloCameraViewState extends State<YoloCameraView>
    with WidgetsBindingObserver {



  var controller = Get.find<YoloCameraController>();


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    controller.initVideoRecord();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    try {
      controller.yoloController.stop();
      print("✅ YOLO controller disposed in view");
    } catch (e) {
      print("⚠️ Error disposing controller in view: $e");
    }
    controller.resultsNotifier.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        print("⏸️ App paused");
        break;
      case AppLifecycleState.resumed:
        print("▶️ App resumed");
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        await controller.endScanningSession();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // YOLO Camera View
              Positioned.fill(
                child: YOLOView(
                  controller: controller.yoloController,
                  modelPath: Platform.isAndroid
                      ? 'best_8s_float32.tflite'
                      : 'best',
                  task: YOLOTask.detect,
                  streamingConfig: const YOLOStreamingConfig.minimal(),
                  onResult: (result) {
                    //final filteredResults = result.where((results) {
                    //  return results.classIndex != 2;
                    //}).toList();
                    controller.onResult(result);
                  },
                ),
              ),

              // FPS Counter
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ValueListenableBuilder<List<YOLOResult>>(
                    valueListenable: controller.resultsNotifier,
                    builder: (context, results, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'FPS: ${controller.timestamps.length}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            'Detections: ${results.length}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            'Raw Captures: ${controller.rawCapturedFrames.length}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Bottom Control Buttons
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(
                    bottom: 30,
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // End Button
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: ()async{
                             await controller.endScanningSession();
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.fieldBorder,width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/pause_button.png',
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'End Survey',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(color: Colors.black54, blurRadius: 4),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 30),

                      // Manual Capture Button
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => controller.captureImage(isManual: true),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.cardBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.fieldBorder,width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 26,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Capture Damage',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(color: Colors.black54, blurRadius: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Captured Images Counter Badge
              Positioned(
                top: 20,
                right: 20,
                child: controller.rawCapturedFrames.isNotEmpty
                    ? Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        '${controller.rawCapturedFrames.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screen_recording/flutter_screen_recording.dart';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:property_scan_pro/screens/YoloCamera/controller/yolocamera_controller.dart';
// import 'package:ultralytics_yolo/ultralytics_yolo.dart';
// import '../../../routes/app_pages.dart';
// import '../../../utils/image_hash.dart';
// import '../../DamageRepairTab/controller/damage_repair_tab_controller.dart';
//
// class YoloCameraView extends StatefulWidget {
//   const YoloCameraView({super.key});
//
//   @override
//   State<YoloCameraView> createState() => _YoloCameraViewState();
// }
//
// class _YoloCameraViewState extends State<YoloCameraView>
//     with WidgetsBindingObserver {
//   var controller = Get.find<YoloCameraController>();
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     controller.initVideoRecord();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     try {
//       controller.yoloController.stop();
//       print("✅ YOLO controller disposed in view");
//     } catch (e) {
//       print("⚠️ Error disposing controller in view: $e");
//     }
//     controller.resultsNotifier.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//
//     switch (state) {
//       case AppLifecycleState.paused:
//         print("⏸️ App paused");
//         break;
//       case AppLifecycleState.resumed:
//         print("▶️ App resumed");
//         break;
//       case AppLifecycleState.inactive:
//       case AppLifecycleState.detached:
//       case AppLifecycleState.hidden:
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//
//     return WillPopScope(
//       onWillPop: () async {
//         // Handle back button press
//         await controller.endScanningSession();
//         return false;
//       },
//       child: Scaffold(
//         body: SafeArea(
//           child: Stack(
//             children: [
//               // YOLO Camera View
//               Positioned.fill(
//                 child: YOLOView(
//                   controller: controller.yoloController,
//                   modelPath: Platform.isAndroid
//                       ? 'best_8s_float32.tflite'
//                       : 'best',
//                   task: YOLOTask.detect,
//                   streamingConfig: const YOLOStreamingConfig.minimal(),
//                   onResult: (result) {
//                     controller.onResult(result);
//                   },
//                 ),
//               ),
//
//               // FPS Counter
//               Positioned(
//                 top: 20,
//                 left: 20,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.6),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: ValueListenableBuilder<List<YOLOResult>>(
//                     valueListenable: controller.resultsNotifier,
//                     builder: (context, results, child) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             'FPS: ${controller.timestamps.length}',
//                             style: TextStyle(color: Colors.white, fontSize: 12),
//                           ),
//                           Text(
//                             'Detections: ${results.length}',
//                             style: TextStyle(color: Colors.white, fontSize: 12),
//                           ),
//                           Text(
//                             'Raw Captures: ${controller.rawCapturedFrames.length}',
//                             style: TextStyle(color: Colors.white, fontSize: 12),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//
//               // Bottom Control Buttons
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   padding: const EdgeInsets.only(
//                     bottom: 30,
//                     left: 20,
//                     right: 20,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // End Button
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           GestureDetector(
//                             onTap: () async {
//                               await controller.endScanningSession();
//                             },
//                             child: Container(
//                               padding: EdgeInsets.all(15),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black26,
//                                     blurRadius: 8,
//                                     offset: Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Image.asset(
//                                 'assets/images/pause_button.png',
//                                 height: 25,
//                                 width: 25,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'End',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               shadows: [
//                                 Shadow(color: Colors.black54, blurRadius: 4),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       SizedBox(width: 30),
//
//                       // Manual Capture Button
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           GestureDetector(
//                             onTap: () => controller.captureImage(isManual: true),
//                             child: Container(
//                               padding: EdgeInsets.all(15),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black26,
//                                     blurRadius: 8,
//                                     offset: Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Icon(
//                                 Icons.camera_alt,
//                                 size: 26,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'Capture',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               shadows: [
//                                 Shadow(color: Colors.black54, blurRadius: 4),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Captured Images Counter Badge
//               Positioned(
//                 top: 20,
//                 right: 20,
//                 child: controller.rawCapturedFrames.isNotEmpty
//                     ? Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.green.withOpacity(0.8),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 4,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.photo_library,
//                         color: Colors.white,
//                         size: 16,
//                       ),
//                       SizedBox(width: 6),
//                       Text(
//                         '${controller.rawCapturedFrames.length}',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                     : SizedBox.shrink(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }