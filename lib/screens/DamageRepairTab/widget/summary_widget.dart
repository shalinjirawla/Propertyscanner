import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/controller/damage_repair_tab_controller.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/colors.dart' as Colors;

class DamageSummaryWidget extends StatelessWidget {
  var controller = Get.put(DamageRepairTabController());

  DamageSummaryWidget({Key? key}) : super(key: key);

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
    return Obx(() {
      final counts = controller.severityCounts;
      final total = controller.totalIssues;

      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Damage Summary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: const Color(0xFFEF4444),
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '$total issues',
                        style: TextStyle(
                          color: const Color(0xFFEF4444),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Severity Bars and Counts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSeverityColumn(
                  'High',
                  counts['High'] ?? 0,
                  const Color(0xFFEF4444),
                ),
                _buildSeverityColumn(
                  'Medium',
                  counts['Medium'] ?? 0,
                  const Color(0xFFF59E0B),
                ),
                _buildSeverityColumn(
                  'Low',
                  counts['Low'] ?? 0,
                  const Color(0xFF4DD0E1),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSeverityColumn(String label, int count, Color color) {
    return Expanded(
      child: Column(
        children: [
          // Color bar
          Container(
            height: 6,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          SizedBox(height: 12),
          // Count
          Text(
            count.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          SizedBox(height: 4),
          // Label
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }
}