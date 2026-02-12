import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/components/app_bar.dart';
import 'package:property_scan_pro/screens/EditRepairMaterial/controller/edit_repair_material_controller.dart';

import '../../../utils/theme/app_colors.dart';
import '../../../widgets/shimmer_widget.dart';
import 'edit_repair_material_view.dart';

class DamageDetailsView extends StatefulWidget {
  String? reportId,imageId;
   DamageDetailsView({super.key,this.reportId,this.imageId});

  @override
  State<DamageDetailsView> createState() => _DamageDetailsViewState();
}

class _DamageDetailsViewState extends State<DamageDetailsView> {
  var controller = Get.put(EditRepairMaterialController());

  @override
  void initState() {
    controller.fetchDamageAnalysis(reportId: widget.reportId,imageId: widget.imageId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      appBar: CustomDarkAppBar(
        title:
          "Damage Details",
        height: 70,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ShimmerList(itemCount: 15,);
        }

        if (controller.damageAnalysisResponse.value == null) {
          return const Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        if(controller.damageAnalysisResponse.value!.data!.analysis == null){
          return const Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        var data = controller.damageAnalysisResponse.value!.data!;
        var analysis = data.analysis;


        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    // Image Header
                    _buildImageHeader(data.mediaUrl),
                    const SizedBox(height: 16),
                    // Description Card
                    _buildCard(
                      title: "Description",
                      content: Text(
                        analysis?.description ?? "No description available.",
                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Repairing Approach Card
                    _buildRepairApproachCard(analysis?.repairApproach),
                    const SizedBox(height: 100), // Spacing for button
                  ],
                ),
              ),
            ),
            // Bottom Button
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF121212),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Cyan accent
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => const EditRepairMaterialView());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.shopping_cart_outlined, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        "Suggested Products",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildImageHeader(String? url) {
    if (url == null) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: url,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,

        // While loading
        placeholder: (context, _) => Container(
          height: 200,
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),

        // On error
        errorWidget: (context, _, __) => Container(
          height: 200,
          color: Colors.grey[800],
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Slightly lighter dark
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildRepairApproachCard(List<String>? steps) {
    if (steps == null || steps.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Repairing Approach",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            int index = entry.key + 1;
            String step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      index.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
