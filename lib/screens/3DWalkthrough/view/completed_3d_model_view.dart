import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/components/custom_bottom_navigtion.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';

class Completed3dModelView extends StatefulWidget {
  const Completed3dModelView({super.key});

  @override
  State<Completed3dModelView> createState() => _Completed3dModelViewState();
}

class _Completed3dModelViewState extends State<Completed3dModelView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: CustomAppBar(
        height: 12.h,userName: "Completed 3D Model",),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3D Model Preview Card
              GestureDetector(
                onTap: (){
                  Get.toNamed(Routes.THREEDVIDEOVIEW);
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=800&q=80',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Play button overlay
                      Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              height2,
              // Title
              const Text(
                'Living Room Scan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '22 Point Scans',
                style: TextStyle(
                  fontSize: 14,
                  color: black,
                ),
              ),
              const SizedBox(height: 20),

              // Info Cards
              _buildInfoCard(
                icon: Icons.calendar_today,
                iconColor: const Color(0xFF4F46E5),
                title: 'Scan Date',
                value: '2022-10-28',
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.straighten,
                iconColor: const Color(0xFFA855F7),
                title: 'Dimensions',
                value: '3.4m x 1.5m x 2.4m',
              ),
              const SizedBox(height: 24),

              // Open 3D Walkthrough Button
              CustomRowButton(
                rowWidget: Icon(Icons.play_arrow,color: white,size: 25,),
                title: "Open 3D Walkthrough",
                height: 6.h,
                buttonColor: primaryColor,
                textColor: white,
                onTap: (){
                  // yoloCameraController.isVideoMode.value = true;
                   Get.toNamed(Routes.THREEDSURVEYVIEW);
                },
              ),
             height2,
              CustomRowWithoutGradientButton(
                rowWidget: Icon(Icons.view_list,color: white,size: 25,).gradient(AppGradients.primaryGradient),
                title: "Models List",
                height: 6.h,
                buttonColor: white,
                textColor: white,
                onTap: (){
                  // yoloCameraController.isVideoMode.value = true;
                   Get.toNamed(Routes.THREEDMODELLISTVIEW);
                },
              ),
              // Models List Button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}