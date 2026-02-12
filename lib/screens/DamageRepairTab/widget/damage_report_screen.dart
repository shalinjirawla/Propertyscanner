import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/components/custom_snackbar.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/controller/damage_repair_tab_controller.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/widget/repair_screen.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/widget/summary_widget.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/widget/video_view.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../components/app_bar.dart';
import '../../../components/custom_bottom_navigtion.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/Height_Width.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_log.dart';
import '../../../widgets/custom_widget.dart';
import '../../../widgets/shimmer_widget.dart';
import '../../DashBoard/widget/pdf_viewer.dart';
import '../../EditRepairMaterial/view/damage_details_view.dart';
import '../../YoloCamera/controller/yolocamera_controller.dart';

class DamageReportScreen extends StatefulWidget {
  String? reportId;

  DamageReportScreen({super.key, this.reportId});

  @override
  State<DamageReportScreen> createState() => _DamageReportScreenState();
}

class _DamageReportScreenState extends State<DamageReportScreen> {
  var controller = Get.put(YoloCameraController());
  var damageRepairTabController = Get.put(DamageRepairTabController());

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Wait for the API call to complete
    await damageRepairTabController.getReportDetailData(widget.reportId);
    print(
      "VideoUrlApi>>>>>${damageRepairTabController.reportDetailPageData.value.captureVideo}",
    );
    // Now initialize the video player with the fetched URL
    final videoUrl =
        damageRepairTabController.reportDetailPageData.value.captureVideo;
    if (videoUrl != null && videoUrl.toString().isNotEmpty) {
      controller.videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl.toString()),
      );
      await controller.videoPlayerController!.initialize();
      print(
        "VideoUrl>>>>>${damageRepairTabController.reportDetailPageData.value.captureVideo}",
      );
      setState(() {}); // Rebuild to show the video player
    }
  }

  @override
  void dispose() {
    controller.videoPlayerController?.dispose();
    super.dispose();
  }

  // List<DamageItem> damages = [
  //   DamageItem(
  //     name: 'Ceiling Damage',
  //     description: 'Water damage with structural compromise',
  //     severity: 'HIGH',
  //     image: 'assets/damage1.jpg',
  //   ),
  //   DamageItem(
  //     name: 'Wall Crack',
  //     description: 'Vertical crack in load-bearing wall',
  //     severity: 'MEDIUM',
  //     image: 'assets/damage2.jpg',
  //   ),
  //   DamageItem(
  //     name: 'Floor Staining',
  //     description: 'Discoloration from previous water leak',
  //     severity: 'MEDIUM',
  //     image: 'assets/damage3.jpg',
  //   ),
  //   DamageItem(
  //     name: 'Door Misalignment',
  //     description: 'Front door needs adjustment',
  //     severity: 'LOW',
  //     image: 'assets/damage4.jpg',
  //   ),
  // ];

  void _showEditDialog(BuildContext context, int index) {
    TextEditingController nameController = TextEditingController(
      text: damageRepairTabController
          .reportDetailPageData
          .value
          .damages![index]
          .damageName,
    );

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Damage Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Damage Name',
                  style: TextStyle(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF3A3A3A),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: const Color(0xFF3A3A3A),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            if (nameController.text.trim().isEmpty) {
                              showWarningSnackBar(
                                message: 'Please enter damage name',
                              );
                              return;
                            }
                            setState(() {
                              damageRepairTabController
                                      .reportDetailPageData
                                      .value
                                      .damages![index]
                                      .damageName =
                                  nameController.text;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4DD0E1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'High':
        return const Color(0xFFEF4444);
      case 'Medium':
        return const Color(0xFFF59E0B);
      case 'Low':
        return const Color(0xFF4DD0E1);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3A3A3C),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: Text(
          'Inspection Report',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              if (!await checkInternetConnection()) return;
              if (damageRepairTabController.reportDetailPageData.value.id !=
                  null) {
                Get.to(
                  () => PdfViewer(
                    pdf:
                        damageRepairTabController.reportDetailPageData.value.id
                            .toString() ??
                        '',
                  ),
                );
              } else {
                showWarningSnackBar(
                  message: "Pdf not created please create pdf",
                );
              }
            },
            child: _buildActionButton("assets/images/pdf.png"),
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height / 6,
          ),
          child: Obx(
            () => damageRepairTabController.isLoadingReportDetail.value
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.cardBg,
                      highlightColor: Colors.grey.shade700,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 7,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.fieldBorder),
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 2.h,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.fieldBorder,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        damageRepairTabController
                            .reportDetailPageData
                            .value
                            .propertyName
                            .toString()
                            .customText(
                              fontWeight: FontWeight.w600,
                              color: white,
                              size: 12.sp,
                            ),
                        height1,
                        damageRepairTabController
                            .reportDetailPageData
                            .value
                            .propertyAddress
                            .toString()
                            .customText(
                              fontWeight: FontWeight.w600,
                              color: grey,
                              size: 10.sp,
                            ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => damageRepairTabController.isLoadingReportDetail.value
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10,
                ),
                child: CustomThemeButton(
                  backgroundColor: AppColors.primary,
                  height: 50,
                  text: "Update Report",
                  onPressed: () async {
                    if (!await checkInternetConnection()) return;
                    damageRepairTabController.updateReportAndPdf();
                  },
                  isOutlined: false,
                  textColor: Colors.black,
                  iconColor: Colors.black,
                  borderColor: AppColors.black,
                ),
              ),
      ),
      body: Obx(
        () => damageRepairTabController.isLoadingReportDetail.value
            ? DamageReportShimmer(damageCount: 6)
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /*height2,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 2.h,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.fieldBorder,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            damageRepairTabController
                                .reportDetailPageData
                                .value
                                .propertyName
                                .toString()
                                .customText(
                                  fontWeight: FontWeight.w600,
                                  color: white,
                                  size: 12.sp,
                                ),
                            height1,
                            damageRepairTabController
                                .reportDetailPageData
                                .value
                                .propertyAddress
                                .toString()
                                .customText(
                                  fontWeight: FontWeight.w600,
                                  color: grey,
                                  size: 10.sp,
                                ),
                          ],
                        ),
                      ),*/
                      height2,
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Scan Summary',
                              style: TextStyle(
                                color: white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: damageRepairTabController
                                    .reportDetailPageData
                                    .value
                                    .summary
                                    .toString(),
                              ),
                              maxLines: 6,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.cardBg,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: AppColors.fieldBorder,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: AppColors.fieldBorder,
                                  ),
                                ),
                                hintText: 'Scan Summary',
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
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
                      Visibility(
                        visible:
                            damageRepairTabController
                                .reportDetailPageData
                                .value
                                .captureVideo !=
                            null,
                        child: Container(
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
                                          if (!await checkInternetConnection())
                                            return;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => VideoView(
                                                videoUrl:
                                                    damageRepairTabController
                                                        .reportDetailPageData
                                                        .value
                                                        .captureVideo,
                                                isNetworkVideo: true,
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
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
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
                                    : SizedBox.shrink(),
                              ),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Video Walkthrough',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Recorded on ${DateTime.now().toString().substring(0, 10)}',
                                      style: TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 8.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      height3,
                      //SeveritySliderView(severity: ''),
                      DamageSummaryWidget(),
                      height3,
                      Column(
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
                            // padding: EdgeInsets.all(16),
                            itemCount: damageRepairTabController
                                .reportDetailPageData
                                .value
                                .damages!
                                .length,
                            itemBuilder: (context, index) {
                              final damage = damageRepairTabController
                                  .reportDetailPageData
                                  .value
                                  .damages![index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF3A3A3A),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Damage Image
                                    // Container(
                                    //   height: 60,
                                    //   width: 60,
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(8),
                                    //     image: DecorationImage(
                                    //       image: NetworkImage(
                                    //         damageRepairTabController
                                    //             .reportDetailPageData
                                    //             .value
                                    //             .damages![index]
                                    //             .mediaUrl
                                    //             .toString(),
                                    //       ),
                                    //       fit: BoxFit.cover,
                                    //     ),
                                    //   ),
                                    // ),
                                    Container(
                                      height: 65,
                                      width: 65,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              damageRepairTabController
                                                  .reportDetailPageData
                                                  .value
                                                  .damages?[index]
                                                  .mediaUrl ??
                                              '',
                                          fit: BoxFit.cover,
                                          placeholder: (_, __) => Container(
                                            color: Colors.grey.shade300,
                                          ),
                                          errorWidget: (_, __, ___) =>
                                              Container(
                                                color: Colors.grey.shade300,
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),

                                    // Damage Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  damage.damageName.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getSeverityColor(
                                                    damage.severity.toString(),
                                                  ).withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Text(
                                                  damage.severity.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: _getSeverityColor(
                                                      damage.severity
                                                          .toString(),
                                                    ),
                                                    fontSize: 8.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "Description",
                                            style: TextStyle(
                                              color: const Color(0xFF9CA3AF),
                                              fontSize: 8.sp,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  //Get.toNamed(Routes.EDITREPAIRMATERIAL);
                                                  if (!await checkInternetConnection())
                                                    return;
                                                  Get.to(
                                                    () => DamageDetailsView(
                                                      reportId:
                                                          damageRepairTabController
                                                              .reportDetailPageData
                                                              .value
                                                              .damages![index]
                                                              .surveyId
                                                              .toString(),
                                                      imageId:
                                                          damageRepairTabController
                                                              .reportDetailPageData
                                                              .value
                                                              .damages![index]
                                                              .id
                                                              .toString(),
                                                    ),
                                                  );
                                                  //Get.to(()=>RepairScreen(reportId: damageRepairTabController.reportDetailPageData.value.damages![index].surveyId.toString(),imageId: damageRepairTabController.reportDetailPageData.value.damages![index].id.toString()));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .primaryLight
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          18,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.visibility,
                                                        color: const Color(
                                                          0xFF4DD0E1,
                                                        ),
                                                        size: 16,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'View Details',
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFF4DD0E1,
                                                          ),
                                                          fontSize: 8.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              GestureDetector(
                                                onTap: () => _showEditDialog(
                                                  context,
                                                  index,
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.surface,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          18,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        color: const Color(
                                                          0xFF9CA3AF,
                                                        ),
                                                        size: 16,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'Edit',
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFF9CA3AF,
                                                          ),
                                                          fontSize: 8.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () async {
                                                  // Delete action
                                                  if (!await checkInternetConnection())
                                                    return;
                                                  showDialog(
                                                    context: context,
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.85),
                                                    builder: (context) => ConfirmationDeleteDialog(
                                                      title: 'Confirm Deletion',
                                                      message:
                                                          'This action cannot be undone. The damage report will be permanently removed from your inspection.',
                                                      cancelText: 'Cancel',
                                                      confirmText: 'Delete',
                                                      confirmButtonColor:
                                                          const Color(
                                                            0xFFEF4444,
                                                          ),
                                                      onConfirm: () async {
                                                        //Get.back();// Close dialog
                                                        await damageRepairTabController
                                                            .deleteDamageImage(
                                                              damageRepairTabController
                                                                  .reportDetailPageData
                                                                  .value
                                                                  .id
                                                                  .toString(),
                                                              damage.id
                                                                  .toString(),
                                                              index,
                                                            );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: const Color(
                                                    0xFFEF4444,
                                                  ),
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          /*ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: damageRepairTabController.reportDetailPageData.value.damages!.length,
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
                                        image: NetworkImage(
                                          damageRepairTabController.reportDetailPageData.value.damages![index].mediaUrl.toString(),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    damageRepairTabController.reportDetailPageData.value.damages![index].damageName
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(()=>RepairScreen(reportId: damageRepairTabController.reportDetailPageData.value.damages![index].surveyId.toString(),imageId: damageRepairTabController.reportDetailPageData.value.damages![index].id.toString()));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                           color:  AppColors.primaryLight.withOpacity(0.4),
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          border: Border.all(
                                            color: AppColors.primaryLight.withOpacity(0.4),
                                            width: 1,
                                          ),
                                        ),
                                        child: "Suggested Repair steps"
                                            .customText(
                                          fontWeight: FontWeight.w400,
                                          size: 8.sp,
                                          color: Colors.white,
                                          maxLines: 2,
                                          overflow:
                                          TextOverflow.ellipsis,
                                        )
                                            .paddingAll(8),
                                      ),
                                    ),
                                  )
                                ),
                              );
                            },
                          ),*/
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildActionButton(String imagePath) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3C),
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildSeverityIndicator({
    required Color color,
    required String count,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          // Color Bar
          Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 16),
          // Count
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          // Label
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class DamageItem {
  String name;
  String description;
  String severity;
  String image;

  DamageItem({
    required this.name,
    required this.description,
    required this.severity,
    required this.image,
  });
}
/*
*  final categories = data.keys.toList();
*  ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final products = data[category]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                return ProductTile(product: products[i]);
              },
            ),
          ],
        );
      },
    )
* */

//implement kare tyare keje hu explain kari dais

class SeveritySliderView extends StatefulWidget {
  final String severity; // "High", "Medium", or "Low"

  const SeveritySliderView({Key? key, required this.severity})
    : super(key: key);

  @override
  State<SeveritySliderView> createState() => _SeveritySliderViewState();
}

class _SeveritySliderViewState extends State<SeveritySliderView> {
  Color _getSeverityColor() {
    switch (widget.severity.toLowerCase()) {
      case 'high':
        return const Color(0xFFFF3B30); // Red
      case 'medium':
        return const Color(0xFFFF9500); // Orange
      case 'low':
        return const Color(0xFF34C759); // Green
      default:
        return Colors.grey;
    }
  }

  IconData _getSeverityIcon() {
    switch (widget.severity.toLowerCase()) {
      case 'high':
        return Icons.error;
      case 'medium':
        return Icons.warning;
      case 'low':
        return Icons.info;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Damage Summary",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          height2,
          Row(
            children: [
              // High Severity
              Expanded(
                child: _buildSeverityBox(
                  color: const Color(0xFFFF3B30),
                  label: 'High',
                  icon: Icons.dangerous,
                  isSelected: widget.severity.toLowerCase() == 'high',
                ),
              ),
              const SizedBox(width: 12),
              // Medium Severity
              Expanded(
                child: _buildSeverityBox(
                  color: const Color(0xFFFF9500),
                  label: 'Medium',
                  icon: Icons.warning,
                  isSelected: widget.severity.toLowerCase() == 'medium',
                ),
              ),
              const SizedBox(width: 12),
              // Low Severity
              Expanded(
                child: _buildSeverityBox(
                  color: const Color(0xFF34C759),
                  label: 'Low',
                  icon: Icons.info,
                  isSelected: widget.severity.toLowerCase() == 'low',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Severity Description
          Text(
            _getSeverityDescription(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSeverityBox({
    required Color color,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : color.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: isSelected ? 28 : 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? color : Colors.white.withOpacity(0.6),
              fontSize: isSelected ? 14 : 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getSeverityDescription() {
    switch (widget.severity.toLowerCase()) {
      case 'high':
        return 'Critical damage requiring immediate attention. May pose safety risks or lead to further deterioration if not addressed promptly.';
      case 'medium':
        return 'Moderate damage that should be addressed soon. May worsen over time but not immediately critical.';
      case 'low':
        return 'Minor damage with minimal impact. Can be scheduled for repair during routine maintenance.';
      default:
        return 'Damage severity information unavailable.';
    }
  }
}
