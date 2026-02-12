import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/colors.dart';
import 'package:property_scan_pro/utils/strings.dart';
import 'package:property_scan_pro/widgets/shimmer_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../components/custom_bottom_navigtion.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/config.dart';
import '../../../utils/permission.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../utils/theme/app_textstyle.dart';
import '../../../widgets/report_card.dart';
import '../../Notification/controller/notification_controller.dart';
import '../controller/dash_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var dashController = Get.put(DashboardController());

  @override
  void initState() {
    dashController.getReportPageList();
    dashController.notificationController.getNotificationPageList();
    dashController.profileImage.value = dashController.box.read(userPicture??'');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar:  PreferredSize(
        preferredSize:  Size.fromHeight(7.h),
        child: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.primaryGradient
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child:  Icon(
              Icons.home_work_outlined,
              color: primaryColor,
              size: 24,
            ).gradient(AppGradients.primaryGradient),
          ),
        ),
        title: appName.customText(
          color: white,
          size: 13.sp,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          Padding(
            padding:  EdgeInsets.only(right: 3.w),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: (){
                    Get.toNamed(Routes.NOTIFICATION);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: const Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
            ),
      ),*/
      body: SafeArea(child: homePageBuild()),
      /*Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Transform(
          transform: Matrix4.translationValues(0, -5, 0),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/property_onboarding.png"),fit: BoxFit.fill)
                ),
              ),
              // ClipRRect(
              //   borderRadius: BorderRadiusGeometry.circular(15),
              //   child: Image.asset(
              //     'assets/images/property_onboarding.png',
              //     height: 500,
              //     width: double.infinity,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              Positioned(
                bottom: 50,
                left: 15,
                child: Container(
                  height: 120,
                  //width: 350,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: .17),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'See it. Say it. Fix it.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      10.height,
                      Text(
                        'Your all-in-one property inspection\nassistant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.5,
                        ),
                      ),
                    ],
                  ),
                ).asGlass(clipBorderRadius: BorderRadius.circular(15)),
              ),
            ],
          ).paddingSymmetric(horizontal: 20),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 4.w),
        child: CustomButton(
          title: "Start New Survey",
          height: 8.h,
          buttonColor: primaryColor,
          textColor: white,
          onTap: () async {
            final ok = await ensurePermissionsForFeature(context);
            if (ok) {
              Get.toNamed(Routes.SURVEYVIEW);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Permissions not granted')),
              );
            }

          },
        ),
      ),*/
    );
  }
  Widget homePageBuild(){
    return Obx(() {
      if (dashController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildPrimaryActionBox(),
            const SizedBox(height: 24),
            _buildActionGrid(),
            const SizedBox(height: 24),
            _buildMainActionButton(),
            const SizedBox(height: 32),

            // Recent Reports Section
            if(dashController.isLoadingReport.value) ...[
             SizedBox(height:Get.height/2,child: ShimmerList(itemCount: 15,))
            ]else if (dashController.reportPageDataList.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Reports',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      dashController.onNavBarTap(1);
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              //const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
                itemCount: dashController.reportPageDataList.length > 3
                    ? 3
                    : dashController.reportPageDataList.length,
                itemBuilder: (context, index) {
                  return ReportCard(report:dashController.reportPageDataList[index]);
                },
              ),
            ] else ...[
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.description_outlined,
                      size: 80,
                      color: AppColors.textTertiary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reports yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap "Start Survey" to start your scan',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome back", style: AppTextStyles.titleLarge),
            const SizedBox(height: 4),
            Text("Ready to inspect?", style: AppTextStyles.bodyMedium),
          ],
        ),
        Row(
          children: [
            GetBuilder<NotificationController>(
                id: 'newNotification',
                builder: (controller) {
                  return IconButton(
                    color: Colors.white,
                    icon: Stack(
                      children: [
                         CircleAvatar(
                           radius: 20,
                           backgroundColor: Colors.white.withOpacity(0.1),
                           child: const Icon(
                            Icons.notifications_none,
                            color: Colors.white70,
                             size: 25,
                                                   ),
                         ),
                        Visibility(
                          visible: controller.notificationValueCount.value != 0,
                          child: Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child:  Text(
                                controller.notificationValueCount.value.toString(),
                                style: TextStyle(fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      if (!await checkInternetConnection()) return;
                      Get.toNamed(Routes.NOTIFICATION);
                    },
                  );
                }),
            const SizedBox(width: 10),
             CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary,
    backgroundImage:dashController.profileImage.value != null || dashController.profileImage.value != ''? NetworkImage(dashController.profileImage.value??""):AssetImage("assets/images/splash_icon.png")
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrimaryActionBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.1),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          "AI-powered property inspection made simple",
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildActionGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            Icons.visibility_outlined,
            "AI Vision",
            "Analysis",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            Icons.label_outline,
            "Auto Damage",
            "Tagging",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            Icons.calculate_outlined,
            "Repair Cost",
            "Estimation",
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon, color: AppColors.primary, size: 28),
              )),
          const SizedBox(height: 12),
          Center(child: Text(title, style: AppTextStyles.titleSmall.copyWith(fontSize: 14,),textAlign: TextAlign.center,)),
          Text(sub, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildMainActionButton() {
    return ElevatedButton.icon(
      onPressed: () async{
        final ok = await ensurePermissionsForFeature(context);
        if (ok) {
          dashController.startNewSurvey();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Permissions not granted')),
          );
        }
      },
      icon: const Icon(Icons.crop_free, size: 24),
      label: const Text("Start New Survey"),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildRecentSurveysHeader() {
    return Text("Recent Surveys", style: AppTextStyles.titleSmall);
  }
}
