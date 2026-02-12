import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:property_scan_pro/screens/Settings/controller/settings_controller.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../utils/colors.dart';
import '../model/faq_model.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  var controller = Get.put(SettingsController());

  @override
  void initState() {
    super.initState();
    controller.getFaqListPage();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomDarkAppBar(
        height: 70,
        title: "FAQs",),
      body: Obx(
          () => controller.isFaqLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.faqPageDataList.length,
          itemBuilder: (context, index) {
            return FaqCard(faq: controller.faqPageDataList.value[index]);
          },
        ),
      ),
    );
  }
}

class FaqCard extends StatefulWidget {
  final FaqsData faq;

  const FaqCard({Key? key, required this.faq}) : super(key: key);

  @override
  State<FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.faq.question.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: white,
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  widget.faq.answer.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: white,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

