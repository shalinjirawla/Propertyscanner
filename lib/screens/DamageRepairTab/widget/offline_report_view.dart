import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/Database/database_helper.dart';
import 'package:property_scan_pro/components/app_bar.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/widget/video_view.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:property_scan_pro/utils/colors.dart';
import 'package:property_scan_pro/utils/theme/app_colors.dart';
import 'package:property_scan_pro/utils/theme/app_textstyle.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../widgets/custom_log.dart';

class OfflineReportView extends StatefulWidget {
  final ReportModel report;

  const OfflineReportView({Key? key, required this.report}) : super(key: key);

  @override
  State<OfflineReportView> createState() => _OfflineReportViewState();
}

class _OfflineReportViewState extends State<OfflineReportView> {
  VideoPlayerController? _videoPlayerController;
  List<Map<String, dynamic>> damagesList = [];

  @override
  void initState() {
    super.initState();
    _parseDamages();
    _initVideo();
  }

  void _parseDamages() {
    if (widget.report.damages != null && widget.report.damages!.isNotEmpty) {
      try {
        List<dynamic> parsed = jsonDecode(widget.report.damages!);
        damagesList = List<Map<String, dynamic>>.from(parsed);
      } catch (e) {
        Console.Log(title: "ParseError", message: e.toString());
      }
    }
  }

  void _initVideo() {
    if (widget.report.scanVideoPath != null &&
        widget.report.scanVideoPath!.isNotEmpty) {
      final file = File(widget.report.scanVideoPath!);
      if (file.existsSync()) {
        _videoPlayerController = VideoPlayerController.file(file)
          ..initialize().then((_) {
            setState(() {});
          });
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomDarkAppBar(
        title: "Offline Report Details",
        onBackTap: () {
          Get.back();
        },
        height: 70,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.fieldBorder, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.report.title ?? "Unknown Property",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      fontSize: 14.sp,
                    ),
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
                        child: Text(
                          widget.report.address ?? "No Address",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            height2,

            // Summary Section
            Container(
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
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: widget.report.summary??''),
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
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            height2,

            // Video Section
            if (_videoPlayerController != null &&
                _videoPlayerController!.value.isInitialized) ...[
              Column(
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
                        GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoView(
                                    videoPath:
                                    widget.report.scanVideoPath,
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
                                      _videoPlayerController!,
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
                      ],
                    ),
                  ),
                ],
              ),
              height2,
            ],

            // Damages Section
            if (damagesList.isNotEmpty) ...[
              Text(
                'Damages Detected',
                style: TextStyle(
                  color: white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: damagesList.length,
                itemBuilder: (context, index) {
                  final damage = damagesList[index];
                  final name = damage['damage_name'] ?? 'Unknown Damage';
                  final imageBase64 = damage['image'];

                  Uint8List? imageBytes;
                  if (imageBase64 != null && imageBase64 is String) {
                    try {
                      imageBytes = base64Decode(imageBase64);
                    } catch (e) {
                      // Error decoding
                    }
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.fieldBorder,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imageBytes != null
                              ? Image.memory(
                                  imageBytes,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
