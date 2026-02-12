import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:property_scan_pro/components/custom_snackbar.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/widget/damage_report_screen.dart';

import '../routes/app_pages.dart';
import '../screens/DashBoard/model/report_model.dart';
import '../utils/Extentions.dart';
import '../utils/theme/app_colors.dart';

class ReportCard extends StatelessWidget {
  final ReportData report;

  const ReportCard({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.divider, // Customize your border color
          width: 1.0,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () async {
          if (!await checkInternetConnection()) return;
          if(report.status == 'processing'){
            showWarningSnackBar(message: "We’re generating your report. This may take a few moments…");
          }else{
            Get.to(()=> DamageReportScreen(reportId: report.id.toString(),));
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Container(
              //   padding: const EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     color: AppColors.divider,
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: const Icon(
              //     Icons.assignment_outlined,
              //     color: AppColors.primary,
              //   ),
              // ),
              // const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.propertyName.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.propertyAddress.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: report.status == 'processing'
                                ? AppColors.primaryLight.withOpacity(0.1):report.status == 'draft'?
                                 AppColors.warning.withOpacity(0.1): AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                              report.status == 'processing'?
                           'Processing':report.status == 'draft'?'Draft':'Final',
                            style: TextStyle(
                              color:report.status == 'processing'
                                  ? AppColors.primaryLight:report.status == 'draft'?
                              AppColors.warning: AppColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          (DateFormat('EEE, d MMM y, h:mm').format(
                            report.createdAt!,
                          )),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
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
  }
}