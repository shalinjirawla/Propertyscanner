// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:rally_bulls/screens/Contests/controller/contest_fantasy_controller.dart';
// import 'package:rally_bulls/utils/Extentions.dart';
// import 'package:rally_bulls/widgets/custom_log.dart';
// import 'package:sizer/sizer.dart';
//
// import '../routes/app_pages.dart';
// import '../screens/Dashboard/controller/dashboard_controller.dart';
// import '../screens/Dashboard/controller/inApp_purchase_controller.dart';
// import '../screens/LMS/widgets/banner_ad_view.dart';
// import '../utils/Height_Width.dart';
// import '../utils/bounce_widget.dart';
// import '../utils/colors.dart';
// import '../utils/constant_images.dart';
// import '../utils/inAppPurchase.dart';
// import '../utils/strings.dart';
//
// class CustomNavigationBar extends StatelessWidget {
//   Function()? onTap;
//
//   CustomNavigationBar({super.key, this.onTap});
//
//   var dashController = Get.put(DashboardController()),
//       inAppController = Get.put(InAppPurchaseController());
//   final _inAppPurchase = InAppPurchaseService();
//   //height: dashController.profileController.isAdRemove.value == false
//   //    ? null
//   //    : 145,
//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//
//       color: bottomBarColor,
//       shadowColor: bottomBarColor,
//       surfaceTintColor: bottomBarColor,
//       shape: const CircularNotchedRectangle(),
//       //notchMargin: 3,
//       child: SizedBox(
//         height: 100,
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Obx(
//                   () => Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GetBuilder<DashboardController>(
//                         id: 'contestTitle',
//                         builder: (dashController) {
//                           return BottomItem(
//                             key: dashController
//                                 .profileController.keyBottomNavigation1,
//                             icon:
//                             bottomFantasyActive /*dashController.currentIndex.value == 0
//                                   ? bottomFantasyActive
//                                   : bottomFantasy*/
//                             ,
//                             selectedColor:
//                             dashController.currentIndex.value == 0
//                                 ? white
//                                 : bottomBarTextColor,
//                             title: fantasy,
//                             isSelected:
//                             dashController.currentIndex.value == 0,
//                             selectedTextColor:
//                             dashController.currentIndex.value == 0
//                                 ? white
//                                 : bottomBarTextColor,
//                             onTap: dashController.currentIndex.value == 0 &&
//                                 !dashController.isContest
//                                     .value //!dashController.isFantasy.value
//                                 ? () {}
//                                 : onTap ??
//                                     () {
//                                   dashController.myContestIndex.value = 0;
//                                   dashController.changeIndex(0,
//                                       pageName: Routes.CONTESTVIEW);
//                                   var controller = Get.put(
//                                       ContestFantasyController(),
//                                       permanent: true);
//                                   controller.isFilter.value = false;
//                                   controller.publicPage.value = 1;
//                                   controller.isPublicLoadMore.value =
//                                   false;
//                                   controller.hasPublicNextPage.value =
//                                   false;
//                                   controller.selectedCategory.value =
//                                   'normal';
//                                   controller.isFantasy.value = false;
//                                   dashController.contestTitle.value =
//                                   'Contest';
//                                   dashController.update(['contestTitle']);
//
//                                   controller.getPublicContestList(
//                                     pageNo: controller.publicPage.value
//                                         .toString(),
//                                     isFilter: true,
//                                     isLoad: false,
//                                     //stock_type: 'stock',
//                                     return_type: 'fantasy',
//                                     category: 'normal',
//                                   );
//                                 },
//                           );
//                         }),
//                     space,
//                     GetBuilder<DashboardController>(
//                         id: 'contestGame',
//                         builder: (dashController) {
//                           Console.Log(
//                               title: 'Rebuild', message: 'contestGame');
//                           Console.Log(
//                               title: 'Rebuild',
//                               message:
//                               dashController.currentIndex.value == 1 &&
//                                   !dashController.isContest.value);
//                           return BottomItem(
//                             key: dashController
//                                 .profileController.keyBottomNavigation2,
//                             icon: bottomContest,
//                             title: 'Games',
//                             //dashController.contestTitle.value,
//                             //contest,
//                             isSelected:
//                             dashController.currentIndex.value == 1,
//                             selectedColor:
//                             dashController.currentIndex.value == 1
//                                 ? white
//                                 : bottomBarTextColor,
//                             onTap: dashController.currentIndex.value == 1 &&
//                                 !dashController.isContest.value
//                                 ? () {}
//                                 : () {
//                               dashController.myContestIndex.value = 0;
//                               dashController.changeIndex(1,
//                                   pageName: Routes.CONTESTVIEW);
//                               var controller = Get.put(
//                                   ContestFantasyController(),
//                                   permanent: true);
//                               controller.publicPage.value = 1;
//                               controller.isFilter.value = false;
//                               controller.isPublicLoadMore.value = false;
//                               controller.hasPublicNextPage.value =
//                               false;
//                               controller.isFantasy.value = false;
//                               controller.selectedCategory.value =
//                               'game';
//                               dashController.contestTitle.value =
//                               'Game';
//                               dashController.update(['contestGame']);
//
//                               controller.getPublicContestList(
//                                 pageNo: controller.publicPage.value
//                                     .toString(),
//                                 isFilter: true,
//                                 isLoad: false,
//                                 stock_type: 'stock',
//                                 category: 'game',
//                                 return_type: 'game',
//                               );
//                             },
//                             selectedTextColor:
//                             dashController.currentIndex.value == 1
//                                 ? white
//                                 : bottomBarTextColor,
//                           );
//                         }),
//                     space,
//                     space,
//                     const Expanded(child: SizedBox()),
//                     space,
//                     space,
//                     BottomItem(
//                       key: dashController
//                           .profileController.keyBottomNavigation3,
//                       icon: bottomTrading,
//                       title: trading,
//                       selectedColor: dashController.currentIndex.value == 3
//                           ? Colors.white
//                           : bottomBarTextColor,
//                       isSelected: dashController.currentIndex.value == 3,
//                       onTap: dashController.currentIndex.value == 3
//                           ? () {}
//                           : () {
//                         dashController.changeIndex(3,
//                             pageName: Routes.TRADINGVIEW);
//                         //dashController.contestTitle.value = 'Game';
//                         //dashController.update(['contestTitle']);
//                       },
//                       selectedTextColor:
//                       dashController.currentIndex.value == 3
//                           ? white
//                           : bottomBarTextColor,
//                     ),
//                     space,
//                     BottomItem(
//                       key: dashController
//                           .profileController.keyBottomNavigation4,
//                       icon: bottomLMS,
//                       title: LMS,
//                       isSelected: dashController.currentIndex.value == 4,
//                       selectedColor: dashController.currentIndex.value == 4
//                           ? white
//                           : bottomBarTextColor,
//                       onTap: dashController.currentIndex.value == 4
//                           ? () {}
//                           : () {
//                         dashController.homeViewString.value =
//                             Routes.LMSVIEW;
//                         dashController.changeIndex(4,
//                             pageName: Routes.LMSVIEW);
//                         //dashController.contestTitle.value = 'Game';
//                         //dashController.update(['contestTitle']);
//                       },
//                       selectedTextColor:
//                       dashController.currentIndex.value == 4
//                           ? white
//                           : bottomBarTextColor,
//                     ),
//                   ]),
//             ),
//             /*Obx(
//                 () => dashController.profileController.isAdRemove.value == false
//                     ? shrink
//                     : Positioned(
//                         bottom: -10,
//                         left: 0,
//                         right: 0,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Stack(
//                               clipBehavior: Clip.none,
//                               alignment: Alignment.center,
//                               children: [
//                                 const Divider(color: Color(0xFF768AA4)),
//                                 Positioned(
//                                   right: -15,
//                                   child: Obx(
//                                     () => dashController.isPurchaseLoading.value
//                                         ? const CircularProgressIndicator(
//                                             color: Colors.white,
//                                           ).paddingRight(5)
//                                         : IconButton(
//                                             onPressed: () {
//                                               dashController.isPurchaseLoading
//                                                   .value = true;
//                                               _inAppPurchase.loadPaywall();
//                                               //_inAppPurchase.buyProduct(
//                                               //    inAppController
//                                               //        .removeAdProduct!);
//                                             },
//                                             icon: Container(
//                                               padding:
//                                                   const EdgeInsets.all(5.5),
//                                               decoration: BoxDecoration(
//                                                 color: appBarColor,
//                                                 shape: BoxShape.circle,
//                                                 border:
//                                                     Border.all(color: white),
//                                               ),
//                                               child: Image.asset(
//                                                 'assets/icons/cancel_icon.png',
//                                                 scale: 4.3,
//                                                 color: white,
//                                               ),
//                                             ),
//                                           ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             5.height,
//                             const SizedBox(
//                               height: 40,
//                               child: HomeAdWidget(),
//                             ),
//                           ],
//                         ),
//                       ),
//               ),*/
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class BottomItem extends StatelessWidget {
//   String? icon, title;
//   Function()? onTap;
//   Color? selectedColor, selectedTextColor;
//   bool? isSelected;
//
//   BottomItem({
//     super.key,
//     this.icon,
//     this.title,
//     this.onTap,
//     this.selectedColor,
//     this.selectedTextColor,
//     this.isSelected,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Bouncing(
//       onTap: onTap,
//       child: Transform(
//         transform: Matrix4.translationValues(0, -4, 0),
//         child: SizedBox(
//           height: Get.height,
//           //width: Get.width,
//           child: Column(
//             children: [
//               //3.height,
//               Container(
//                 padding: const EdgeInsets.all(7),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: isSelected! ? primaryColor : Colors.transparent,
//                 ),
//                 child: Image.asset(
//                   icon!,
//                   height: 3.5.h, // 25.5,
//                   width: 32, //25.5,
//                   color: selectedColor,
//                 ),
//               ),
//               Transform(
//                 transform: Matrix4.translationValues(0, -3, 0),
//                 child: title!.customText(
//                   fontWeight: FontWeight.w700,
//                   size: 10.5.sp,
//                   color: white, //selectedTextColor ?? bottomBarTextColor,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';

import '../utils/colors.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final Color? buttonColor;
  final Color? textColor;
  final double? height;

  const CustomButton({
    super.key,
    this.onTap,
    this.title,
    this.buttonColor,
    this.textColor,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!,
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: AppGradients.primaryGradient,
          color: buttonColor ?? primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Text(
          title!,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CustomRowButton extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final Color? buttonColor;
  final Color? textColor;
  final double? height;
  final Widget? rowWidget;

  const CustomRowButton({
    super.key,
    this.onTap,
    this.title,
    this.buttonColor,
    this.textColor,
    this.height,
    this.rowWidget
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!,
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: AppGradients.primaryGradient,
          color: buttonColor ?? primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            rowWidget!,
            width2,
            Text(
              title!,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomWithOutGradientButton extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final Color? buttonColor;
  final Color? textColor;
  final double? height;

  const CustomWithOutGradientButton({
    super.key,
    this.onTap,
    this.title,
    this.buttonColor,
    this.textColor,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!,
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: buttonColor ?? primaryColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: primaryColor)
        ),
        alignment: Alignment.center,
        child: Text(
          title!,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ).gradient(AppGradients.primaryGradient),
      ),
    );
  }
}

class CustomRowWithoutGradientButton extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final Color? buttonColor;
  final Color? textColor;
  final double? height;
  final Widget? rowWidget;

  const CustomRowWithoutGradientButton({
    super.key,
    this.onTap,
    this.title,
    this.buttonColor,
    this.textColor,
    this.height,
    this.rowWidget
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!,
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: buttonColor ?? primaryColor,
          borderRadius: BorderRadius.circular(15),
            border: Border.all(color: primaryColor)
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            rowWidget!,
            width2,
            Text(
              title!,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ).gradient(AppGradients.primaryGradient),
          ],
        ),
      ),
    );
  }
}