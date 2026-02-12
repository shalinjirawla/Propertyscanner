import 'package:flutter/material.dart';
import 'package:property_scan_pro/utils/Extentions.dart';

import '../utils/colors.dart';

class CustomTabBar extends StatelessWidget {
  TabController? tabController;
  List<Widget>? tabs;
  double? height, width;

  CustomTabBar({
    super.key,
    this.tabController,
    this.tabs,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5, left: 5, right: 5),
      height: height ?? 55, //7.3.h,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 0.5), //(x,y)
            blurRadius: 3.0,
          )
        ],
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          gradient: AppGradients.primaryGradient,
          color: primaryColor,
        ),
        dividerColor: transparentColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: appBarColor,
        tabs: tabs!,
      ),
    );
  }
}
