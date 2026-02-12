import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_roomplan/flutter_roomplan.dart';
import 'package:flutter_viewer_usdz/flutter_viewer_usdz.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/screens/3DWalkthrough/view/3d_model_list_view.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:sizer/sizer.dart';

import '../../../components/custom_bottom_navigtion.dart';
import '../../../components/usdz_helper.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../utils/theme/app_textstyle.dart';
import '../../../widgets/custom_button.dart';
import '../../DamageRepairTab/widget/video_view.dart';
import '../controller/3d_walkthrough_controller.dart';

class ThreeDWalkthroughView extends StatefulWidget {
  const ThreeDWalkthroughView({super.key});

  @override
  State<ThreeDWalkthroughView> createState() => _ThreeDWalkthroughViewState();
}

class _ThreeDWalkthroughViewState extends State<ThreeDWalkthroughView> {
  var controller = Get.put(ThreeDWalkthroughController());


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.checkSupport();
      controller.getThreeDList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
      if (!controller.isSupported.value) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/3d-scanner.png",height: 8.h,fit: BoxFit.cover,color: AppColors.fieldBorder,),
                3.height,
                Text(
                  'App features only work on LiDAR supported devices',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 18.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "3D Walkthrough",
              style: AppTextStyles.titleLarge.copyWith(fontSize: 32),
            ),
            const SizedBox(height: 24),
            Center(
              child: VideoThumbnailWidget(
                videoUrl: "",
                height: 300,
              ),
            ),
            const SizedBox(height: 24),
            CustomThemeButton(
              backgroundColor: AppColors.primary,
              height: 60,
              text: 'Create New 3D Model',
              icon: Icons.qr_code_scanner,
              onPressed: () {
                Get.toNamed(Routes.THREEDSURVEYVIEW);
              },
              isOutlined: false,
              textColor: Colors.white,
              iconColor: Colors.white,
              borderColor: AppColors.black,
            ),
            const SizedBox(height: 24),
            CustomThemeButton(
              backgroundColor: AppColors.divider,
              height: 60,
              text: 'View 3D Models',
              icon: Icons.list,
              onPressed: () async {
                if (!await checkInternetConnection()) return;
                Get.toNamed(Routes.THREEDMODELLISTVIEW);
              },
              isOutlined: true,
              textColor: Colors.white,
              iconColor: Colors.white,
              borderColor: AppColors.black,
            ),
          ],
        ),
      );
    }),

    /*SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Obx(
          ()=> Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!controller.isSupported.value)...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'App features are only works on lidar supported devices',
                          style: TextStyle(color: AppColors.primary,fontSize: 18.sp),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),] else...[
              const SizedBox(height: 20),
              Text(
                "3D Walkthrough",
                style: AppTextStyles.titleLarge.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 24),
              Center(
                child: VideoThumbnailWidget(
                  videoUrl: "",
                  height: 300,
                ),
              ),
              const SizedBox(height: 24),
              CustomThemeButton(
                backgroundColor: AppColors.primary,
                height: 60,
                text: 'Create New 3D Model',
                icon: Icons.qr_code_scanner,
                onPressed: () {
                  Get.toNamed(Routes.THREEDSURVEYVIEW);
                },
                isOutlined: false,
                textColor: Colors.white,
                iconColor: Colors.white,
                borderColor: AppColors.black,
              ),
               const SizedBox(height: 24),
              CustomThemeButton(
                backgroundColor: AppColors.divider,
                height: 60,
                text: 'View 3D Models',
                icon: Icons.list,
                onPressed: () async {
                  if (!await checkInternetConnection()) return;
                  Get.toNamed(Routes.THREEDMODELLISTVIEW);
                },
                isOutlined: true,
                textColor: Colors.white,
                iconColor: Colors.white,
                borderColor: AppColors.black,
              ),]
            ],
          ),
        ),
      ),*/
    );
  }
}


class VideoThumbnailWidget extends StatelessWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const VideoThumbnailWidget({
    Key? key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.height,
    this.width,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoView(
              videoUrl:
             videoUrl,
              isNetworkVideo: true,
            ),
          ),
        );*/
      },
      child: Container(
        height: height ?? 200,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Thumbnail Image
            ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(16),
              child: thumbnailUrl != null
                  ? Image.network(
                thumbnailUrl!,
                height: height ?? 200,
                width: width ?? double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              )
                  : _buildPlaceholder(),
            ),

            // Dark Overlay
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: borderRadius ?? BorderRadius.circular(16),
              ),
            ),

            // Play Button (Center)
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height ?? 200,
      width: width ?? double.infinity,
      color: const Color(0xFF3A3A3A),
      child: Icon(
        Icons.videocam,
        color: Colors.grey,
        size: 50,
      ),
    );
  }
}

class ModelLists extends StatefulWidget {
  final List? scannedRoomsList;

  const ModelLists({super.key, this.scannedRoomsList});

  @override
  State<ModelLists> createState() => _ModelListsState();
}

class _ModelListsState extends State<ModelLists> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
            childAspectRatio: (size.height / size.width) * 0.35,
          ),
          itemBuilder: (context, index) {
            var items = widget.scannedRoomsList![index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              // padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      FlutterViewerUsdz().loadUSDZFileFromUrl(
                        'file://${items['model']}',
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      child: Image.file(
                        height: 93,
                        File(items['image']),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Room ${index + 1}',
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: widget.scannedRoomsList!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}