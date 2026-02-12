import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/widget/offline_report_view.dart';
import 'package:property_scan_pro/screens/DashBoard/controller/dash_controller.dart';
import 'package:property_scan_pro/screens/DashBoard/model/report_model.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/permission.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../utils/theme/app_textstyle.dart';
import '../../../widgets/report_card.dart';
import '../../../widgets/shimmer_widget.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  final DashboardController controller = Get.find<DashboardController>();

  @override
  void initState() {
    print("isSyncing>>>>>>>>>${controller.isSyncing.value}");
    if (controller.isSyncing.value == false) {
      controller.getOfflineReports();
      controller.setupConnectivityListener();
      print("isSyncingInside>>>>>>>>>");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure controller is found (though it should be put by DashboardView or binding)
    // Using Get.put here just in case, or rely on GetView's controller if already put.
    // If DashboardController is already in memory from Main/Dashboard view, GetView finds it.
    // However, the original code looked for it or put it.
    // Since we are extending GetView, 'controller' is available.
    // To be safe if it's not initialized:
    // Get.put(DashboardController()); // We use Get.find above, assuming it's injected.
    // If safety is needed:
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          color: AppColors.cardBg,
          child: SafeArea(
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!controller.isSearchActive.value) ...[
                    Text(
                      'Reports',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // Search Button
                    InkWell(
                      onTap: controller.uiToggleSearch,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.search,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: controller.updateSearchText,
                        autofocus: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          hintText: 'Search by Property Name',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          suffixIcon: IconButton(
                            onPressed: controller.uiCloseSearch,
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingReport.value) {
          return ShimmerList(itemCount: 15);
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.getReportPageList();
            // Search list update runs automatically via 'ever' in controller
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sync Progress Indicator
                if (controller.isSyncing.value) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Syncing Reports...",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              "${(controller.syncProgress.value * 100).toInt()}%",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: controller.syncProgress.value,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          color: AppColors.primary,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.syncStatusMessage.value,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],

                // Offline Reports Section
                if (controller.offlineReports.isNotEmpty &&
                    !controller.isSearchActive.value) ...[
                  Text(
                    'Offline Reports',
                    style: AppTextStyles.titleLarge.copyWith(
                      fontSize: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.offlineReports.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final report = controller.offlineReports[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: AppColors.divider,
                            width: 1.0,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () {
                            // Get.to(() => OfflineReportView(report: report));
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        report.title ?? "Unknown Property",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        report.address ?? "No Address",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Text(
                                                  'Offline',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              if (report.createdAt != null)
                                                Text(
                                                  (DateFormat(
                                                    'EEE, d MMM y, h:mm',
                                                  ).format(report.createdAt!)),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        AppColors.textTertiary,
                                                  ),
                                                ),
                                            ],
                                          ),

                                          // Sync Button
                                          // Note: Sync is now automatic, but we keep the button if user wants to force it?
                                          // Or simpler: disable it / remove it if auto-sync is main way.
                                          // The requirement was "Automatic sync", but originally there was "Sync Offline to Online".
                                          // Keeping it as a manual trigger for redundancy is safe.
                                          InkWell(
                                            onTap: () async {
                                              /*if (!await checkInternetConnection())
                                                return;
                                              await controller
                                                  .syncOfflineReport(report);*/
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.sync,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "Sync",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Divider(color: AppColors.divider),
                  const SizedBox(height: 16),
                ],

                // Recent Reports Section
                if (controller.searchList.isNotEmpty) ...[
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 2.h,
                    ),
                    itemCount: controller.searchList.length,
                    itemBuilder: (context, index) {
                      return ReportCard(report: controller.searchList[index]);
                    },
                  ),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        Icons.description_outlined,
                        size: 80,
                        color: AppColors.textTertiary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.isSearchActive.value
                            ? 'No results found'
                            : 'No reports yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ).centerExtension(),
                ],
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ok = await ensurePermissionsForFeature(context);
          if (ok) {
            controller.startNewSurvey();
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Permissions not granted')));
          }
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
