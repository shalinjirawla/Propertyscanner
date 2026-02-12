import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:property_scan_pro/components/custom_bottom_navigtion.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../DashBoard/controller/dash_controller.dart';

class ThreeDVideoView extends StatefulWidget {
  const ThreeDVideoView({super.key});

  @override
  State<ThreeDVideoView> createState() => _ThreeDVideoViewState();
}

class _ThreeDVideoViewState extends State<ThreeDVideoView> {
  var dashController = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 12.h,userName: "Living Room & Kitchen",),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
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

          // App Bar



          // Drag Instruction


          // Property Details
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Living Room & Kitchen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sunset Vista - Unit 48',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Back Button
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: CustomRowButton(
              rowWidget: Icon(Icons.arrow_back,color: white,size: 25,),
              title: "Back to main menu",
              height: 6.h,
              buttonColor: primaryColor,
              textColor: white,
              onTap: (){
                // yoloCameraController.isVideoMode.value = true;
               // dashController.changeIndex(0,pageName: Routes.DASHBOARD);
                NavigationHelper.goToDashboardTabThenScreen(
                  tabIndex: 1,
                );
                print("tappppppp");
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreeDGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 0.5;

    // Draw grid lines
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    // Draw perspective lines
    final center = Offset(size.width / 2, size.height / 2);
    final perspectivePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1;

    canvas.drawLine(center, Offset(0, 0), perspectivePaint);
    canvas.drawLine(center, Offset(size.width, 0), perspectivePaint);
    canvas.drawLine(center, Offset(0, size.height), perspectivePaint);
    canvas.drawLine(center, Offset(size.width, size.height), perspectivePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
