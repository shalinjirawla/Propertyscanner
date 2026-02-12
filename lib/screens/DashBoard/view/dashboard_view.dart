import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:property_scan_pro/screens/3DWalkthrough/view/3d_walthrough_view.dart';
import 'package:property_scan_pro/screens/DashBoard/controller/dash_controller.dart';
import 'package:property_scan_pro/screens/DashBoard/view/home_view.dart';
import 'package:property_scan_pro/screens/DashBoard/view/report_view.dart';
import 'package:property_scan_pro/screens/DashBoard/view/settings_view.dart';
import 'package:property_scan_pro/utils/colors.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/Extentions.dart';

class DashBoardView extends StatefulWidget {
  const DashBoardView({super.key});

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  var dashController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    //final List<Widget> _pages = dashController.getPages(context);
    return /*Scaffold(
      body: Obx(() => _pages[dashController.currentIndex.value]),
      bottomNavigationBar: Obx(() {
        final filteredItems = dashController.filteredNavItems;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              height: 8.4.h,
              decoration: BoxDecoration(
                color: white,
                gradient: AppGradients.primaryGradient,// Your custom background color
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    // Remove elevation effects
                    canvasColor: Colors.transparent,
                    // Customize icon colors
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      selectedItemColor: white,
                      unselectedItemColor: Colors.grey[300],
                    ),
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,  // This alone isn't enough
                    currentIndex: dashController.currentIndex.value,
                    onTap: dashController.changeTab,
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,  // CRITICAL: Remove elevation
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    selectedFontSize: 12,
                    unselectedFontSize: 12,
                    selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                    items: filteredItems.map((item) {
                      return BottomNavigationBarItem(
                        icon: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dashController.currentIndex.value ==
                                filteredItems.indexOf(item)
                                ? white.withOpacity(0.4)
                                : Colors.transparent,
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            size: 22,
                          ),
                        ),
                        label: item['label'] as String,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
        );*/
      Scaffold(
        body: SafeArea(
          child: PageView(
            controller: dashController.pageController,
            onPageChanged: dashController.onPageChanged,
            physics: const NeverScrollableScrollPhysics(), // Disable swipe gestures
            children: [
              HomeView(),
              ReportsView(),
             if(Platform.isIOS) ThreeDWalkthroughView(),
              SettingsView(),
            ],
          ),
        ),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
          currentIndex: dashController.currentIndex.value,
          onTap: dashController.onNavBarTap,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              activeIcon: Icon(Icons.description),
              label: 'Reports',
            ),
            if(Platform.isIOS) const BottomNavigationBarItem(
              icon: Icon(Icons.view_in_ar_outlined),
              activeIcon: Icon(Icons.view_in_ar),
              label: '3D Walkthrough',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        )),
      );
    }


}
