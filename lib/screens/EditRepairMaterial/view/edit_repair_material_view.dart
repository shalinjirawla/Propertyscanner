import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/screens/EditRepairMaterial/view/edit_product_view.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/Extentions.dart';
import '../../../utils/theme/app_colors.dart';
import '../controller/edit_repair_material_controller.dart';
import '../model/damage_analysis_model.dart';
import '../widget/product_image_view.dart';

class EditRepairMaterialView extends StatefulWidget {
  const EditRepairMaterialView({super.key});

  @override
  State<EditRepairMaterialView> createState() => _EditRepairMaterialViewState();
}

class _EditRepairMaterialViewState extends State<EditRepairMaterialView> {
  var controller = Get.put(EditRepairMaterialController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.cardBg,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: const Column(
          children: [
            Text(
              'Suggested Products',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Complete materials list for all damages',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.damageAnalysisResponse.value == null) {
          return const Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        var data = controller.damageAnalysisResponse.value!.data!;
        var analysis = data.analysis!;
        // Flatten products and map them to a structure we can use, keeping category if possible?
        // For now, we'll just get all products. The wireframe shows 'Ceiling Damage' as subtitle.
        // We can use data.damageName for that subtitle.
        var products = analysis.recommendedProducts?.getAllProducts() ?? [];

        // Calculate totals dynamically from API data
        double productsTotal = products.fold(
          0,
          (sum, item) =>
              sum + (double.tryParse(item.priceNumeric.toString()) ?? 0),
        );
        double labourCost =
            double.tryParse(controller.labourCostController.text) ?? 0;
        double totalCost = productsTotal + labourCost;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _productListCard(products, data.damageName ?? "Repair"),
              const SizedBox(height: 16),
              _costSummaryCard(productsTotal, labourCost, totalCost),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (!await checkInternetConnection()) return;
                    controller.updateAnalysis();
                  },
                  child: const Text(
                    "Update Analysis",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // Remove unused methods from previous implementation if any
  Widget _productListCard(List<ProductItem> products, String damageName) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "PRODUCT",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "PRICE",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          if (products.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "No recommended products found.",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
          ...products.asMap().entries.map(
            (entry) => _productRow(
              entry.key,
              entry.value,
              entry.value.category ?? damageName,
              isLast: entry.key == products.length - 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _productRow(
    int index,
    ProductItem product,
    String subtitle, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap:(){
                    Get.to(()=>FullImageView(
                      imageUrl: product.imageUrl.toString(),
                    ));
                    },
                  child: Hero(
                      tag: product.imageUrl.toString(),
                      child: _productImage(product.imageUrl))),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? 'Unknown Product',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.source ?? 'Unknown Product',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                product.price ?? '\$0.00',
                style: const TextStyle(
                  color: AppColors.primary, // Cyan color
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () async {
                  var result = await Get.to(
                    () => EditProductView(product: product),
                  );
                  if (result == true) {
                    setState(() {});
                  }
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(color: Colors.white10, height: 1),
      ],
    );
  }

  Widget _productImage(String? imageUrl) {
    return Container(
      height: 60,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white12,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          fadeInDuration: const Duration(milliseconds: 200),
          fadeOutDuration: const Duration(milliseconds: 150),
          imageUrl: imageUrl == null ? '' : _fixImageUrl(imageUrl),
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.image,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }


  Widget _costSummaryCard(
    double productsTotal,
    double labourCost,
    double totalCost,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cost Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _summaryRow('Products Cost', productsTotal),
          const SizedBox(height: 12),
          // Editable Labour Cost
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Labour Cost',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Container(
                width: 100,
                height: 35,
                child: TextField(
                  controller: controller.labourCostController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction:
                  TextInputAction.done,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.end,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    prefixStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 8,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF33CCFF)),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {}); // Trigger rebuild to update total
                  },
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.white24),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Cost',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              width2,
              Flexible(
                child: Text(
                  '\$${totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  String _fixImageUrl(String url) {
    if (url.contains("localhost")) {
      return url.replaceFirst("localhost", "10.0.2.2");
    }
    return url;
  }
}
