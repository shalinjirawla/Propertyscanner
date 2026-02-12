import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/components/custom_bottom_navigtion.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/controller/damage_repair_tab_controller.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/widget/damage_report_screen.dart';
import 'package:property_scan_pro/screens/DashBoard/controller/dash_controller.dart';
import 'package:property_scan_pro/screens/YoloCamera/controller/yolocamera_controller.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../Database/database_helper.dart';
import '../../../components/app_bar.dart';
import '../../../components/custom_tabbar.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/config.dart';
import '../../../utils/sliver_delegate.dart';
import '../../DashBoard/widget/pdf_viewer.dart';
import '../widget/damage_screen.dart';
import '../widget/repair_screen.dart';

class DamageRepairTabView extends StatefulWidget {
  const DamageRepairTabView({super.key});

  @override
  State<DamageRepairTabView> createState() => _DamageRepairTabViewState();
}

class _DamageRepairTabViewState extends State<DamageRepairTabView>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    yoloCameraController.videoPath.value = '';
    super.dispose();
  }

  var dashController = Get.find<DashboardController>();
  var controller = Get.put(DamageRepairTabController());
  var yoloCameraController = Get.find<YoloCameraController>();
  var db = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: CustomAppBar(
        onBackTap: () {
          Get.delete<YoloCameraController>();
          Get.toNamed(Routes.DASHBOARD);
        },
        height: 12.h,
        userName: "Damage Repair",
      ),
      bottomNavigationBar: Obx(
          ()=> Container(
          padding: EdgeInsets.all(20),
          color: white,
          child: controller.isEdit.value == true?CustomButton(
            title: "Save Report",
            height: 7.h,
            buttonColor: primaryColor,
            textColor: white,
            onTap: ()async {
              controller.submitReport(yoloCameraController);
             // yoloCameraController.analyzeMultipleImagesSequentially();
              // if (yoloCameraController.pdfPath.value.isEmpty) {
              //   yoloCameraController.pdfPath.value = await PdfReport.createPdf(
              //     outFileName:
              //     'scan_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
              //     address:
              //     controller.propertyAddController.value.text,
              //     name: controller.propertyNameController.value.text,
              //     photoPaths: controller.captureImages,
              //     summary: controller.speechController.value.text,
              //     isVideoMode: controller.isVideoMode.value,
              //   );
              // }
              await db.insertReport(
                ReportModel(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: yoloCameraController.propertyNameController.value.text,
                  summary: yoloCameraController.speechController.value.text,
                  address:
                  yoloCameraController.propertyAddController.value.text,
                  pdfReport: yoloCameraController.pdfPath.value,
                  scanVideoPath: yoloCameraController.videoPath.value,
                  createdAt: DateTime.now(),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    'Report Save Successfully',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
              yoloCameraController.pastSurveyList.value = await db
                  .getAllReports();

              //Get.toNamed(Routes.YOLOCAMERAVIEW);
            },
          ):
          Row(
            children: [
              Flexible(
                child: CustomButton(
                  title: "View Report",
                  height: 7.h,
                  buttonColor: primaryColor,
                  textColor: white,
                  onTap: ()async {
                    Get.to(() =>PdfViewer(pdf: controller.reportDetailPageData.value.pdf??'',));
                      // if (yoloCameraController.pdfPath.value.isEmpty) {
                      //   yoloCameraController.pdfPath.value = await PdfReport.createPdf(
                      //     outFileName:
                      //     'scan_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
                      //     address:
                      //     controller.propertyAddController.value.text,
                      //     name: controller.propertyNameController.value.text,
                      //     photoPaths: controller.captureImages,
                      //     summary: controller.speechController.value.text,
                      //     isVideoMode: controller.isVideoMode.value,
                      //   );
                      // }

                    //Get.toNamed(Routes.YOLOCAMERAVIEW);
                  },
                ),
              ),
              width2,
              Flexible(
                child: CustomButton(
                  title: "Share",
                  height: 7.h,
                  buttonColor: primaryColor,
                  textColor: white,
                  onTap: ()async {
                    await Share.shareUri(Uri.parse(controller.reportDetailPageData.value.pdf??''));
                    //Get.toNamed(Routes.YOLOCAMERAVIEW);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverPersistentHeader(
                      delegate: SliverAppBarDelegate(
                        Container(
                          height: 55,
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            removeBottom: true,
                            child: CustomTabBar(
                              height: 55,
                              tabs: [
                                Tab(
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      'Damage',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      'Repair',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              tabController: tabController,
                            ),
                          ),
                        ),
                        55,
                        55,
                      ),
                      pinned: true,
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 4.h)),
                  ];
                },
            body: Obx(
              ()=> TabBarView(
                controller: tabController,
                children: [controller.isEdit.value == false ? DamageReportScreen(reportId: controller.reportId.value,):DamageScreen(), RepairScreen()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
