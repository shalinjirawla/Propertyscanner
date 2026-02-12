import 'package:flutter/material.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../utils/theme/app_colors.dart';
import '../model/notification_model.dart';

class NotificationDetailView extends StatelessWidget {
  final NotificationListData notification;

  const NotificationDetailView({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDarkAppBar(height: 70, title: "Notification Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            'Title'.customText(
              fontWeight: FontWeight.w600,
              size: 10.sp,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Text(
                notification.title ?? 'No Title',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Description Section
            'Description'.customText(
              fontWeight: FontWeight.w600,
              size: 10.sp,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Text(
                notification.message ?? 'No Description',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[400],
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Date Section
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16.sp,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  notification.createdAt ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
