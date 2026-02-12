import 'package:flutter/material.dart';
import 'package:property_scan_pro/components/app_bar.dart';

import '../../../utils/theme/app_colors.dart';
import '../model/damage_analysis_model.dart';
import 'package:get/get.dart';

class EditProductView extends StatefulWidget {
  final ProductItem product;

  const EditProductView({super.key, required this.product});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  late TextEditingController nameController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    // Use priceNumeric if available, otherwise strip non-numeric chars from price string
    String priceText =
        widget.product.priceNumeric?.toString() ??
        widget.product.price?.replaceAll(RegExp(r'[^0-9.]'), '') ??
        '0';
    priceController = TextEditingController(text: priceText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: CustomDarkAppBar(
        height: 80,
        iconBgColor: Colors.white.withOpacity(0.1),
        backgroundColor: AppColors.primary, // Match wireframe header
        title: "Edit Product",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation:
                    0, // Flat design as per wireframe might be better, but keeping card for container
                color: const Color(0xFF1E1E1E), // Dark card bg
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white10), // Subtle border
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: _inputField(
                    icon: Icons
                        .inventory_2_outlined, // Better icon than asset image if not available
                    controller: nameController,
                    label: 'Product Name',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: _inputField(
                    icon: Icons.attach_money,
                    controller: priceController,
                    label: 'Price Per Unit',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Cyan
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    _saveChanges();
                  },
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    // Update the product object directly
    widget.product.name = nameController.text;

    double? priceVal = double.tryParse(priceController.text);
    if (priceVal != null) {
      widget.product.priceNumeric = priceVal;
      widget.product.price = "\$${priceVal.toStringAsFixed(2)}";
    }

    // Return with true to indicate changes were made
    Get.back(result: true);
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF121212), // Darker input bg
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF33CCFF), width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
