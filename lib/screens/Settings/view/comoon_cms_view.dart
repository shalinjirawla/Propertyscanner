import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:property_scan_pro/screens/Settings/controller/settings_controller.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/colors.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../utils/Height_Width.dart';
import '../../../utils/config.dart';
import '../../../utils/theme/app_colors.dart';


class CommonCmsView extends StatefulWidget {
   CommonCmsView({super.key});

  @override
  State<CommonCmsView> createState() => _CommonCmsViewState();
}

class _CommonCmsViewState extends State<CommonCmsView> {
  var controller = Get.put(SettingsController());
  String? pageTitle;

  @override
  void initState() {
    if (Get.arguments != null) {
      if (Get.arguments is Map) {
        pageTitle = Get.arguments['pageTitle'];
      } else {
        pageTitle = Get.arguments.toString();
      }
    }
    controller.getCmsListPage(pageTitle.toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: CustomDarkAppBar(
          height: 70,
      title: pageTitle.toString() == "term-and-condition"? "Terms & Conditions":"Privacy Policy",),
        body: Obx(
          ()=>controller.isLoading.value ? Center(child: CircularProgressIndicator()):  Column(
            children: [
              height2,
              Expanded(
                child: Container(
                  //height: Get.height,
                  width: Get.width,
                  decoration:  BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          HtmlWidget(
                        controller.cmsPageData.value.content??'',
                              onTapUrl: (url) {
                                return true;
                              },
                              textStyle: TextStyle(
                                color: white,
                                  fontFamily: fontFamily, fontSize: 12.3.sp),
                            ).paddingBottom(20),
                          height1,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  }
}
