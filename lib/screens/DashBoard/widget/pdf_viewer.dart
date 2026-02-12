import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../components/app_bar.dart';
import '../../../components/custom_snackbar.dart';
import '../../DamageRepairTab/controller/damage_repair_tab_controller.dart';

class PdfViewer extends StatefulWidget {
  String? pdf;
   PdfViewer({super.key,this.pdf});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  var damageRepairTabController = Get.put(DamageRepairTabController());

  @override
  void initState() {
    damageRepairTabController.getPDFData(widget.pdf);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:  const Color(0xFF3A3A3C),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title:  Text(
          'View Report',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              if(damageRepairTabController
                  .reportPDFData
                  .value
                  .pdfUrl != null){
                await Share.shareUri(
                  Uri.parse(
                    damageRepairTabController.reportPDFData.value.pdfUrl ??
                        '',
                  ),
                );
              }else{
                showWarningSnackBar(message: "Pdf not created please create pdf");
              }

            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.share_outlined, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Obx(
          ()=> damageRepairTabController.isLoadingPDF.value?Center(child: CircularProgressIndicator()):damageRepairTabController.reportPDFData.value.pdfUrl!.isNotEmpty? SfPdfViewer.network(damageRepairTabController.reportPDFData.value.pdfUrl!)
            : Center(child: Text('No PDF url provided')),
      ),
    );
  }
}
