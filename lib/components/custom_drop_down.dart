// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
//
// import '../utils/Height_Width.dart';
// import '../utils/colors.dart';
// import '../widgets/custom_avatar_widget.dart';
// import '../widgets/custom_text.dart';
//
// class CustomDropDown extends StatefulWidget {
//   CustomDropDown({super.key});
//
//   @override
//   State<CustomDropDown> createState() => _CustomDropDownState();
// }
//
// class _CustomDropDownState extends State<CustomDropDown> {
//   //TextEditingController controller = TextEditingController();
//   //var filteredList = <City>[], isSearch = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return StatefulBuilder(
//       builder: (context, setState) => Dialog(
//         elevation: 0,
//         surfaceTintColor: Colors.transparent,
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
//         child: SizedBox(
//           height: 450,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CustomTextField(
//                 maxLines: 1,
//                 hintText: 'Search user..',
//                 prefixIcon: const Icon(Icons.search, color: hintColor),
//                 onChanged: (query) {
//                   if (query.isNotEmpty) {
//                     if (query.length > 3) {
//                       controller.isLoadMoreOppUser.value = false;
//                       controller.pageOppUser.value = 1;
//                       /* controller.getContestUsers(
//                         id: controller.contestId.value,
//                         isFilter: true,
//                         search: query,
//                       );*/
//                       controller.getContestOppUsers(
//                         id: controller.contestId.value,
//                         isFilter: true,
//                         page: '1', // controller.pageUser.value.toString(),
//                         search: query,
//                       );
//                     }
//                   } else {
//                     /* controller.getContestUsers(
//                       id: controller.contestId.value,
//                       isFilter: false,
//                       page: controller.pageUser.value.toString(),
//                     );*/
//                     controller.getContestOppUsers(
//                       id: controller.contestId.value,
//                       isFilter: true,
//                       page: '1', // controller.pageUser.value.toString(),
//                       //search: query,
//                     );
//                   }
//                 },
//               ).paddingSymmetric(horizontal: 15),
//               height1,
//               Expanded(
//                 child: Obx(
//                   () => Column(
//                     children: [
//                       if (controller.isLoadMoreOppUser.value == false &&
//                           controller.isUserLoading.value)
//                         LeaderBoardShimmer(itemCount: 5),
//                       if (!controller.isUserLoading.value &&
//                           controller.contestOppUserList.isEmpty)
//                         'User not found'
//                             .customText()
//                             .paddingTop(Get.height / 7.5)
//                             .centerExtension(),
//                       if (!controller.isUserLoading.value &&
//                           controller.contestOppUserList.isNotEmpty)
//                         MediaQuery.removePadding(
//                           context: context,
//                           removeTop: true,
//                           removeBottom: true,
//                           child: NotificationListener<ScrollEndNotification>(
//                             onNotification: (scrollEnd) {
//                               final metrics = scrollEnd.metrics;
//                               if (metrics.atEdge) {
//                                 bool isTop = metrics.pixels == 0;
//                                 if (!isTop) {
//                                   if (controller.hasNextOppUserPage.value &&
//                                       !controller.isUserLoading.value) {
//                                     controller.isLoadMoreOppUser.value = true;
//                                     controller.pageOppUser.value += 1;
//                                     /*controller.getContestUsers(
//                                       page:
//                                           controller.pageUser.value.toString(),
//                                       id: controller.contestId.value,
//                                       isFilter: false,
//                                     );*/
//                                     controller.getContestOppUsers(
//                                       id: controller.contestId.value,
//                                       isFilter: true,
//                                       page: controller.pageOppUser.value
//                                           .toString(),
//                                       //search: query,
//                                     );
//                                   }
//                                 }
//                               }
//                               return true;
//                             },
//                             child: Expanded(
//                               child: ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: const BouncingScrollPhysics(),
//                                 itemCount: controller.contestOppUserList.length,
//                                 //controller.contestUserList.length,
//                                 itemBuilder: (context, index) {
//                                   return ListTile(
//                                     onTap: () {
//                                       controller.oppStockList.clear();
//                                       controller.oppPageStock.value = 1;
//                                       controller.oppBearishStocks.clear();
//                                       controller.oppBullishStocks.clear();
//                                       controller.myIsLoadMoreStock.value =
//                                           false;
//                                       controller.tabName.value = controller
//                                                       .contestOppUserList[index]
//                                                       .user!
//                                                       .username ==
//                                                   null ||
//                                               controller
//                                                   .contestOppUserList[index]
//                                                   .user!
//                                                   .username!
//                                                   .isEmpty
//                                           ? 'Guest User'
//                                           : controller.contestOppUserList[index]
//                                               .user!.username!;
//                                       controller.getOpponentDetail(
//                                         oppId: controller
//                                             .contestOppUserList[index].user!.id,
//                                         isRefresh: false,
//                                       );
//                                       Get.back();
//                                     },
//                                     title: Row(
//                                       children: [
//                                         CustomNetworkAvatar(
//                                           imageUrl: controller
//                                                   .contestOppUserList[index]
//                                                   .user!
//                                                   .profilePic ??
//                                               '',
//                                         ),
//                                         5.width,
//                                         (controller.contestOppUserList[index]
//                                                             .user!.username ==
//                                                         null ||
//                                                     controller
//                                                         .contestOppUserList[
//                                                             index]
//                                                         .user!
//                                                         .username!
//                                                         .isEmpty
//                                                 ? 'Guest User'
//                                                 : controller
//                                                     .contestOppUserList[index]
//                                                     .user!
//                                                     .username!)
//                                             .customText(),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                       if (controller.isLoadMoreOppUser.value &&
//                           controller.isUserLoading.value) ...[
//                         CircularProgressIndicator(color: primaryColor)
//                             .centerExtension(),
//                         height2,
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ).paddingSymmetric(
//             vertical: 15,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class SelectedUserData {
//   String? userId;
//   String? userName;
//   String? userImage;
//   String? userRank;
//   String? userCoin;
//   var totalContestants;
//
//   SelectedUserData({
//     this.userId,
//     this.userName,
//     this.userImage,
//     this.userRank,
//     this.userCoin,
//     this.totalContestants,
//   });
// }
