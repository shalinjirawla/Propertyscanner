import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:property_scan_pro/screens/EditRepairMaterial/model/damage_analysis_model.dart';

import 'package:property_scan_pro/screens/EditRepairMaterial/repo/edit_repair_repo.dart';
import 'package:property_scan_pro/utils/full_screen_loader.dart';

class EditRepairMaterialController extends GetxController {
  final TextEditingController labourCostController = TextEditingController();

  var isLoading = false.obs;
  var overlay = LoadingOverlay();
  var damageAnalysisResponse = Rxn<SurveyDamageResponse>();

  // @override
  // void onInit() {
  //   super.onInit();
  //   // Fetch data when controller is initialized
  //   fetchDamageAnalysis();
  // }

  Future<void> fetchDamageAnalysis({String? reportId, imageId}) async {
    try {
      isLoading(true);

      var response = await EditRepairRepo.fetchDamageAnalysis(
        reportId,
        imageId,
      );

      if (response != null && response.status == true) {
        damageAnalysisResponse.value = response;

        // Pre-fill labour cost if available
        if (damageAnalysisResponse
                .value
                ?.data
                ?.analysis
                ?.costEstimate
                ?.laborCost !=
            null) {
          labourCostController.text = damageAnalysisResponse
              .value!
              .data!
              .analysis!
              .costEstimate!
              .laborCost
              .toString();
        }
      } else {
        Get.snackbar("Error", response?.message ?? "Failed to fetch data");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateAnalysis() async {
    if (damageAnalysisResponse.value?.data == null) return;

    var data = damageAnalysisResponse.value!.data!;
    var analysis = data.analysis;

    if (analysis == null) return;

    //isLoading(true);
    overlay.show();
    try {
      // 1. Update Labor Cost from TextController
      double laborCost = double.tryParse(labourCostController.text) ?? 0.0;
      analysis.costEstimate?.laborCost = laborCost;

      // 2. Recalculate Total Cost
      double productsTotal = 0.0;
      if (analysis.recommendedProducts != null) {
        var allProducts = analysis.recommendedProducts!.getAllProducts();
        productsTotal = allProducts.fold(
          0,
          (sum, item) =>
              sum + (double.tryParse(item.priceNumeric.toString()) ?? 0),
        );
      }

      analysis.costEstimate?.materialCost = productsTotal;
      analysis.costEstimate?.totalCost = laborCost + productsTotal;

      // 3. Construct JSON Body
      Map<String, dynamic> bodyData = {
        "report_id": data.surveyId,
        "damage_id": data.damageId,
        "analysis": {
          "success": analysis.success,
          "severity": analysis.severity,
          "damage_type": analysis.damageType,
          "description": analysis.description,
          "original_index": analysis.imageIndex,
          "processing_time": 0.0, // Assuming static or not crucial for update
          "repair_approach": analysis.repairApproach,
          "cost_estimate": {
            "labor_cost": analysis.costEstimate?.laborCost,
            "labor_rate": analysis.costEstimate?.laborRate,
            "total_cost": analysis.costEstimate?.totalCost,
            "labor_hours": analysis.costEstimate?.laborHours,
            "material_cost": analysis.costEstimate?.materialCost,
          },
          "recommended_products": {},
        },
      };

      // Map Products
      if (analysis.recommendedProducts != null) {
        Map<String, List<Map<String, dynamic>>> productsMap = {};
        analysis.recommendedProducts!.products.forEach((key, value) {
          productsMap[key] = value.map((item) {
            return {
              "url": item.url,
              "name": item.name,
              "price": item.price,
              "source": item.source,
              "features": item.features,
              "image_url": item.imageUrl,
              "price_numeric": item.priceNumeric,
            };
          }).toList();
        });
        bodyData["analysis"]["recommended_products"] = productsMap;
      }

      // 4. Call Repo
      var success = await EditRepairRepo.updateDamageAnalysis(
        bodyData: bodyData,
        reportId: data.surveyId.toString(),
      );
      if (success) {
        // Just refresh the UI with potentially new data if needed
        Get.back();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update analysis: $e");
    } finally {
      isLoading(false);
    }
  }
}
