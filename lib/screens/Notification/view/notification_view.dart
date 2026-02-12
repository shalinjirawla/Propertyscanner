import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:property_scan_pro/screens/Notification/controller/notification_controller.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/theme/app_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme/app_colors.dart';
import '../model/notification_model.dart';
import 'notification_detail_view.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  var controller = Get.put(NotificationController());
  @override
  void initState() {
    controller.getNotificationPageList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDarkAppBar(
        actions: [
          TextButton(
            onPressed: () {
              controller.readNotification();
            },
            child: 'Mark as Read'.customText(
              fontWeight: FontWeight.w600,
              size: 12.sp,
              color: AppColors.primaryLight,
            ),
          ),
        ],
        height: 70,
        title: "Notifications",
      ),
      body: Obx(
        () => controller.isLoadingNotification.value
            ? Center(child: CircularProgressIndicator())
            : controller.notificationPageDataList.value.isEmpty
            ? Center(
                child: Text(
                  "Notification is empty",
                  style: AppTextStyles.bodyLarge,
                ),
              )
            : Column(
                children: [
                  // Notifications ListView
                  ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.notificationPageDataList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      //final notification = controller.notifications[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => NotificationDetailView(
                              notification:
                                  controller.notificationPageDataList[index],
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  controller
                                          .notificationPageDataList[index]
                                          .isRead ==
                                      false
                                  ? AppColors.primary.withOpacity(0.3)
                                  : AppColors.divider,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Notification Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              controller
                                                  .notificationPageDataList[index]
                                                  .title
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),

                                          controller
                                                      .notificationPageDataList[index]
                                                      .isRead ==
                                                  false
                                              ? Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.primary,
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        controller
                                            .notificationPageDataList[index]
                                            .message
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          height: 1.4,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        controller
                                            .notificationPageDataList[index]
                                            .createdAt
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
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
                ],
              ),
      ),
    );
  }
}
