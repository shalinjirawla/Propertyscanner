import 'package:flutter/material.dart';
import 'package:flutter_viewer_usdz/flutter_viewer_usdz.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:property_scan_pro/screens/3DWalkthrough/controller/3d_walkthrough_controller.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme/app_colors.dart';
import '../model/three_d_list_model.dart';

class ThreeDModelListView extends StatefulWidget {
  final List? scannedRoomsList;
  const ThreeDModelListView({super.key, this.scannedRoomsList});

  @override
  State<ThreeDModelListView> createState() => _ThreeDModelListViewState();
}

class _ThreeDModelListViewState extends State<ThreeDModelListView> {
  // final List<PropertyModel> propertyModels = [
  //   PropertyModel(
  //     title: 'Living Room & Kitchen',
  //     subtitle: 'Sunset Vista - Unit 48',
  //     icon: Icons.living_outlined,
  //     color: const Color(0xFF2196F3),
  //     gradient: [const Color(0xFF2196F3), const Color(0xFF64B5F6)],
  //     imageColor: const Color(0xFFE3F2FD),
  //     propertyType: 'Apartment',
  //   ),
  //   PropertyModel(
  //     title: 'Master Bedroom',
  //     subtitle: '42 West Street, Brighton',
  //     icon: Icons.bed_outlined,
  //     color: const Color(0xFF9C27B0),
  //     gradient: [const Color(0xFF9C27B0), const Color(0xFFCE93D8)],
  //     imageColor: const Color(0xFFF3E5F5),
  //     propertyType: 'Townhouse',
  //   ),
  //   PropertyModel(
  //     title: 'Quest Suite - 2nd Floor',
  //     subtitle: 'Lakedale Apartments',
  //     icon: Icons.meeting_room_outlined,
  //     color: const Color(0xFFFF9800),
  //     gradient: [const Color(0xFFFF9800), const Color(0xFFFFB74D)],
  //     imageColor: const Color(0xFFFFF3E0),
  //     propertyType: 'Hotel Suite',
  //   ),
  // ];
  var controller = Get.put(ThreeDWalkthroughController());

  @override
  void initState() {
    controller.getThreeDList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomDarkAppBar(title: "3D Models", height: 70),
      body: Obx(
        () => controller.isLoadingModelList.value
            ? Center(child: CircularProgressIndicator())
            : controller.threeDList.value.isEmpty
            ? RefreshIndicator(
                onRefresh: () async {
                  await controller.getThreeDList();
                },
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 100,
                    alignment: Alignment.center,
                    child: Text(
                      "Model not available",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              )
            : RefreshIndicator(
          onRefresh: () async {
            await controller.getThreeDList();
          },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                    children: [
                      // Search placeholder
                      // Reports List
                      ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.threeDList.length,
                        itemBuilder: (context, index) {
                          return buildModelCard(
                            threeDModelData: controller.threeDList[index],
                          );
                        },
                      ),
                    ],
                  ),
              ),
            ),
      ),
    );
  }
}

class buildModelCard extends StatelessWidget {
  ThreeDModelData? threeDModelData;
  buildModelCard({super.key, this.threeDModelData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.cardBg,
        border: Border.all(color: AppColors.divider, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            if (!await checkInternetConnection()) return;
            //Get.toNamed(Routes.THREEDVIDEOVIEW);
            FlutterViewerUsdz().loadUSDZFileFromUrl(
              "${threeDModelData!.modelUrl.toString()}",
            );
          },

          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  threeDModelData!.propertyName.toString(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: white,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            
                const SizedBox(height: 10),
            
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 2),
                    Text(
                      threeDModelData!.propertyAddress.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.view_in_ar, color: AppColors.primary),
                    SizedBox(width: 2),
                    Text(
                      threeDModelData!.dimension.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
            
                const SizedBox(height: 10),
                Divider(color: AppColors.divider),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: 2),
                    Text(
                      (DateFormat(
                        'EEE, d MMM y, h:mm',
                      ).format(threeDModelData!.createdAt!)),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
