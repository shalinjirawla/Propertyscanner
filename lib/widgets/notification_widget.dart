// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// // import 'package:get/get_core/src/get_main.dart';
//
// import 'package:sizer/sizer.dart';
//
// import '../utils/Height_Width.dart';
// import '../utils/colors.dart';
//
// class NotificationWidget extends StatelessWidget {
//   //NotificationController? controller;
//   int? index;
//
//   NotificationWidget({
//     //this.controller,
//     this.index,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//             color: controller!.notificationList[index!].readMessage == 0
//                 ? primaryColor
//                 : listBorderColor),
//         color: controller!.notificationList[index!].readMessage == 0
//             ? primaryColor.withOpacity(0.1)
//             : listContainerColor,
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//       child: /*Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // controller!.notificationList[index!].image != null
//           //     ? Padding(
//           //         padding: const EdgeInsets.only(left: 8.0, top: 8.0),
//           //         child: _buildProfileImage(),
//           //       ).paddingRight(16)
//           //     : shrink,
//
//         ],
//       )*/
//           Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           4.height,
//           (controller!.notificationList[index!].title ?? '').customText(
//             size: 13.5.sp,
//             fontWeight: FontWeight.w700,
//           ),
//           (controller!.notificationList[index!].message ?? '').customText(
//             size: 10.sp,
//             fontWeight: FontWeight.w400,
//           ),
//           4.height,
//           Align(
//             alignment: Alignment.bottomRight,
//             child: (controller!.notificationList[index!].createdAt == null
//                     ? ''
//                     : controller!.notificationList[index!].createdAt!
//                         .toMMDDYYYY())
//                 .customText(
//               fontWeight: FontWeight.w400,
//               size: 9.sp,
//               //color: hintColor,
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfileImage() {
//     return CachedNetworkImage(
//       height: 30,
//       width: 30,
//       imageUrl: controller!.notificationList[index!].image ?? "",
//       placeholder: (context, url) => CircularProgressIndicator(
//         color: primaryColor,
//       ),
//       errorWidget: (context, url, error) => shrink,
//     );
//   }
// }
