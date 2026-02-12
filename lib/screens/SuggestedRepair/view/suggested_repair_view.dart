import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';

class SuggestedRepairView extends StatefulWidget {
  const SuggestedRepairView({super.key});

  @override
  State<SuggestedRepairView> createState() => _SuggestedRepairViewState();
}

class _SuggestedRepairViewState extends State<SuggestedRepairView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: CustomAppBar(
        height: 12.h,userName: "Suggested Repair Steps",),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Based on the uploaded damages, here are the recommended repair steps.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Damage 1 Card
            _buildDamageCard(
              title: 'Damage 1 - Carling Stain',
              subtitle: 'Carling stain:',
              steps: [
                'Isolate water supply and confirm no active leak above the ceiling',
                'Remove water supplies paint from the affected ceiling',
                'Test dronica area with stain-blocking colour before repairing',
              ],
              icon: Icons.water_damage,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            // Damage 2 Card
            _buildDamageCard(
              title: 'Damage 2 - Plastic Crack',
              subtitle: 'Waterproof',
              steps: [
                'Open out the cracks to remove weak plaster and freeze a clean edge',
                'Apply part tape and tear code of part cranculum, carefully cleaned',
                'Drive and repair required next to match surrounding sealing',
              ],
              icon: Icons.crisis_alert,
              color: Colors.orange,
            ),

            const SizedBox(height: 32),

            // Suggested Items Section
          ],
        ),
      ),
    );
  }
  Widget _buildDamageCard({
    required String title,
    required String subtitle,
    required List<String> steps,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(Routes.EDITDAMAGE);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.edit, color: color, size: 28),
                  ),
                ),
                width2,
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.delete, color: Colors.red, size: 28),
                ),

              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 16),
            ...steps.map((step) => _buildStepItem(step)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Icon(
              Icons.check_circle,
              color: Colors.green[600],
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.blueGrey[300],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
