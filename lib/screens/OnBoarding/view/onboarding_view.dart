import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/theme/app_colors.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import '../controller/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: [
              _buildPage1(),
              _buildPage2(),
              _buildPage3(),
              _buildPage4(),
            ],
          ),
          Positioned(
            top: 48,
            right: 24,
            child: Obx(
              () => controller.currentPage.value < 3
                  ? TextButton(
                      onPressed: controller.skip,
                      child: "Skip".customText(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        size: 11.sp,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomControls(),
          ),
        ],
      ),
    );
  }

  // Page 1: Hero / Overview
  Widget _buildPage1() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Hero Image Placeholder
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.9),
              ],
            ),
          ),
          child: Center(
            child: Image(
              image: AssetImage("assets/images/ic_onboarding_image1.png"),
            ),
          ),
        ),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          Center(
                            child: Container(
                              width: Get.width / 4,
                              height: Get.height / 8,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                ),
                                image: DecorationImage(
                                  image: AssetImage("assets/images/p_logo.png"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.black45),
                            child: const SizedBox(height: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.black45),
                            child: "One site visit\nEverything\nrecorded properly".customText(
                              size: 20.sp,
                              fontWeight: FontWeight.bold,
                              // height: 1.1, // CustomText might not support height directly, checking params. It doesn't.
                              // If critical, might need to wrap or accept fallback.
                              // CustomText uses TextStyle internally, let's see if I can pass height? No.
                              // But it has decoration etc.
                              // I'll skip height or rely on default.
                              color: AppColors
                                  .textPrimary, // Assuming titleLarge color
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.black45),
                            child: const SizedBox(height: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.black45),
                            child:
                                "Capture issues once. Auto-generate materials, suppliers, costs, reports, and quotes. No paperwork. No retyping. No office follow-up."
                                    .customText(
                                      color: Colors.white70,
                                      size: 12.sp,
                                    ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.black45),
                            child: const SizedBox(height: 180),
                          ),
                        ],
                      ),
                      // Space for bottom controls
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Page 2: The Old Way
  Widget _buildPage2() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 180),
          child: Column(
            children: [
              "Stop doing the same\njob twice.".customText(
                textAlign: TextAlign.center,
                size: 22.sp,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              "The old way".customText(color: Colors.grey, size: 12.sp),
              const SizedBox(height: 24),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/on_boarding_image1.png"),
                    fit: BoxFit.cover,
                    opacity: 0.3,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoCard(
                icon: Icons.access_time,
                title: "Day 1 - On Site",
                desc:
                    "Walk property, take photos with camera, scribble notes in notebook, try to remember everything",
              ),
              _buildInfoCard(
                icon: Icons.description,
                title: "Day 2 - Back Office",
                desc:
                    "Type up notes, organize photos in folders, research materials and pricing online, call suppliers",
              ),
              _buildInfoCard(
                icon: Icons.phone_in_talk,
                title: "Day 3 - Admin Work",
                desc:
                    "Build report in Word, create quote in Excel, format everything, email to client, hope they respond",
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.fieldBorder),
                ),
                child: Column(
                  children: [
                    "Takes hours to days".customText(
                      size: 13.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    "Spread across multiple locations and sessions".customText(
                      size: 10.sp,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Page 3: The Better Way (PropertyScan Pro Way)
  Widget _buildPage3() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 180),
          child: Column(
            children: [
              "One site visit.\nEverything done.".customText(
                textAlign: TextAlign.center,
                size: 22.sp,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              "The PropertyScan Pro way".customText(
                color: AppColors.primary,
                size: 12.sp,
              ),
              const SizedBox(height: 24),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/on_boarding_image2.png"),
                    fit: BoxFit.cover,
                    opacity: 0.6,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoCard(
                icon: Icons.query_builder,
                title: "Walk the site once",
                desc:
                    "Scan with your phone. Speak your notes. AI captures everything in real-time.",
                isBetterWay: true,
              ),
              _buildInfoCard(
                icon: Icons.bolt,
                title: "AI does the rest",
                desc:
                    "Auto-identifies materials, finds suppliers, calculates costs, builds professional report",
                isBetterWay: true,
              ),
              _buildInfoCard(
                icon: Icons.email_outlined,
                title: "Quote ready instantly",
                desc:
                    "Professional report with photos, findings, and itemized quote ready to send",
                isBetterWay: true,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    "Done in minutes".customText(
                      size: 13.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    "Everything in one visit, one app".customText(
                      size: 10.sp,
                      color: AppColors.primary.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Page 4: From site visit to quote. One flow.
  Widget _buildPage4() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 180),
          child: Column(
            children: [
              "From site visit to quote.\nOne flow.".customText(
                textAlign: TextAlign.center,
                size: 22.sp,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              "Everything you need, in the order you need it.".customText(
                color: Colors.grey,
                size: 12.sp,
              ),
              const SizedBox(height: 32),
              _buildFlowItem(
                icon: Icons.center_focus_strong,
                title: "Capture on site",
                desc:
                    "Take photos, add voice notes, mark locations. Works offline, syncs when connected.",
              ),
              const SizedBox(height: 16),
              _buildFlowItem(
                icon: Icons.psychology,
                title: "AI identifies everything",
                desc:
                    "Detects materials, damage types, and severity. Matches to suppliers and calculates quantities.",
              ),
              const SizedBox(height: 16),
              _buildFlowItem(
                icon: Icons.assignment_outlined,
                title: "Report auto-generated",
                desc:
                    "Professional PDF with photos, findings, recommendations, and itemized costs.",
              ),
              const SizedBox(height: 16),
              _buildFlowItem(
                icon: Icons.send_outlined,
                title: "Send and track",
                desc:
                    "Email quote directly to client. Track opens, approvals, and follow-ups.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String desc,
    bool isBetterWay = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: isBetterWay
            ? Border.all(color: AppColors.primary.withOpacity(0.1))
            : Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isBetterWay
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.divider,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isBetterWay ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.customText(
                  size: 12.sp,
                  color: isBetterWay ? AppColors.primary : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 4),
                desc.customText(size: 10.sp, color: AppColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.customText(
                  size: 11.sp, // approx 15px
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // titleSmall default
                ),
                const SizedBox(height: 4),
                desc.customText(
                  size: 9.sp, // approx 12px (bodySmall)
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.background.withOpacity(0.8),
            AppColors.background,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 4,
                  width: controller.currentPage.value == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: controller.currentPage.value == index
                        ? AppColors.primary
                        : AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Obx(() {
            String btnText = "Continue";
            if (controller.currentPage.value == 3) {
              btnText = "Get Started";
            } else if (controller.currentPage.value == 1) {
              btnText = "See the Better Way";
            }

            return ElevatedButton(
              onPressed: controller.nextPage,
              child: btnText.customText(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                size: 12.sp,
              ),
            );
          }),
          const SizedBox(height: 16),
          Obx(() {
            String bottomText = "Built for real site work.";
            if (controller.currentPage.value == 3) {
              bottomText = "Built for professionals who work on site.";
            }
            return bottomText.customText(color: Colors.white54, size: 10.sp);
          }),
        ],
      ),
    );
  }
}
