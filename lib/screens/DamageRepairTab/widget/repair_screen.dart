import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/components/custom_snackbar.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/Height_Width.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../controller/damage_repair_tab_controller.dart';

class RepairScreen extends StatefulWidget {
  String? reportId,imageId;
   RepairScreen({super.key,this.reportId,this.imageId});

  @override
  State<RepairScreen> createState() => _RepairScreenState();
}

class _RepairScreenState extends State<RepairScreen> {
  final List<MaterialItem> materials = [
    MaterialItem(
      name: 'Moisture resistant drywall',
      unitPrice: 34.00,
      quantity: 8,
      image: Icons.house_siding,
    ),
    MaterialItem(
      name: 'Joint compound (bucket)',
      unitPrice: 19.50,
      quantity: 3,
      image: Icons.inventory,
    ),
    MaterialItem(
      name: 'Primer & ceiling paint',
      unitPrice: 42.00,
      quantity: 2,
      image: Icons.format_paint,
    ),
    MaterialItem(
      name: 'Protection & masking set',
      unitPrice: 85.00,
      quantity: 1,
      image: Icons.security,
    ),
  ];
  var damageRepairTabController = Get.put(DamageRepairTabController());

  @override
  void initState() {
     damageRepairTabController.getReportRepairData(widget.reportId,widget.imageId);
    super.initState();
  }
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    double partsTotal = materials.fold(0, (sum, item) => sum + item.total);
    double laborCost = 850.00;
    double totalEstimate = partsTotal + laborCost;
    final data = damageRepairTabController.getDynamicCategories();

    if (data.isEmpty) {
      //showSnackBar(isError: true,message: "Products is empty");
    }

    final categories = data.keys.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomDarkAppBar(
        height: 70,title: "Repair Details",),
      body: Obx(
          ()=>damageRepairTabController.isLoadingReportRepair.value? Center(child: CircularProgressIndicator()): SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(1.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 14),
                  height: 300,
                  decoration: BoxDecoration( color: AppColors.divider,
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(damageRepairTabController.reportRepairPageData.value.mediaUrl.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                height2,
                ListView.builder(
                  shrinkWrap: true,
                  itemCount:damageRepairTabController.reportRepairPageData.value.analysis?.repairApproach?.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.background,
                          foregroundColor: Colors.white,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          '',//damageRepairTabController.reportRepairPageData.value.analysis?.repairApproach![index].toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: CustomThemeButton(
                    backgroundColor: AppColors.primary,
                    height: 60,
                    text: "Suggested Products",
                    icon: Icons.shopping_cart_outlined,
                    onPressed: (){
                      Get.toNamed(Routes.EDITREPAIRMATERIAL);
                    },
                    isOutlined: false,
                    textColor: Colors.black,
                    iconColor: Colors.black,
                    borderColor: AppColors.black,
                  ),
                ),
                // height2,
                //
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   itemCount: categories.length,
                //   itemBuilder: (context, index) {
                //     final category = categories[index];
                //     final products = data[category]!;
                //
                //     return Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         // Category Header
                //         Container(
                //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //           margin: const EdgeInsets.only(top: 8, bottom: 8),
                //           color: Colors.grey.shade100,
                //           child: Row(
                //             children: [
                //               Icon(Icons.category, color: Colors.deepPurple, size: 20),
                //               SizedBox(width: 8),
                //               Text(
                //                 category,
                //                 style: TextStyle(
                //                   fontSize: 18,
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.deepPurple,
                //                 ),
                //               ),
                //               Spacer(),
                //               Container(
                //                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                //                 decoration: BoxDecoration(
                //                   color: Colors.deepPurple,
                //                   borderRadius: BorderRadius.circular(12),
                //                 ),
                //                 child: Text(
                //                   '${products.length}',
                //                   style: TextStyle(
                //                     color: Colors.white,
                //                     fontSize: 12,
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //
                //         // Products List
                //         ListView.separated(
                //           shrinkWrap: true,
                //           physics: const NeverScrollableScrollPhysics(),
                //           itemCount: products.length,
                //           separatorBuilder: (_, __) => const Divider(height: 1),
                //           itemBuilder: (context, i) {
                //             final product = products[i];
                //             return ListTile(
                //               contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //               leading: product.imageUrl != null
                //                   ? ClipRRect(
                //                 borderRadius: BorderRadius.circular(8),
                //                 child: Image.network(
                //                   product.imageUrl!,
                //                   width: 60,
                //                   height: 60,
                //                   fit: BoxFit.cover,
                //                   errorBuilder: (context, error, stackTrace) {
                //                     return Container(
                //                       width: 60,
                //                       height: 60,
                //                       color: Colors.grey.shade200,
                //                       child: Icon(Icons.image_not_supported),
                //                     );
                //                   },
                //                 ),
                //               )
                //                   : Container(
                //                 width: 60,
                //                 height: 60,
                //                 decoration: BoxDecoration(
                //                   color: Colors.grey.shade200,
                //                   borderRadius: BorderRadius.circular(8),
                //                 ),
                //                 child: Icon(Icons.shopping_bag),
                //               ),
                //               title: Text(
                //                 product.name ?? 'Product',
                //                 style: TextStyle(
                //                   fontSize: 15,
                //                   fontWeight: FontWeight.w600,
                //                 ),
                //                 maxLines: 2,
                //                 overflow: TextOverflow.ellipsis,
                //               ),
                //               subtitle: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   SizedBox(height: 4),
                //                   if (product.price != null)
                //                     Text(
                //                       product.price!,
                //                       style: TextStyle(
                //                         fontSize: 16,
                //                         color: Colors.green.shade700,
                //                         fontWeight: FontWeight.bold,
                //                       ),
                //                     ),
                //                   if (product.source != null)
                //                     Text(
                //                       'From: ${product.source}',
                //                       style: TextStyle(
                //                         fontSize: 12,
                //                         color: Colors.grey.shade600,
                //                       ),
                //                     ),
                //                 ],
                //               ),
                //               trailing: Icon(Icons.arrow_forward_ios, size: 16),
                //               onTap: () {
                //                 if (product.url != null) {
                //                   // Open URL
                //                   print('Open: ${product.url}');
                //                 }
                //               },
                //             );
                //           },
                //         ),
                //
                //         SizedBox(height: 8),
                //       ],
                //     );
                //   },
                // ),
                // // // Table Header
                // // Container(
                // //   decoration: BoxDecoration(
                // //    gradient: AppGradients.primaryGradient,
                // //     borderRadius:  BorderRadius.only(
                // //       topLeft: Radius.circular(2.w),
                // //       topRight: Radius.circular(2.w),
                // //     ),
                // //   ),
                // //   padding:  EdgeInsets.symmetric(horizontal: 2.w, vertical: 12),
                // //   child: const Row(
                // //     children: [
                // //       Expanded(
                // //         flex: 2,
                // //         child: Text(
                // //           'MATERIAL',
                // //           style: TextStyle(
                // //             fontWeight: FontWeight.bold,
                // //             color: white,
                // //           ),
                // //         ),
                // //       ),
                // //       Expanded(
                // //         child: Text(
                // //           'UNIT',
                // //           style: TextStyle(
                // //             fontWeight: FontWeight.bold,
                // //             color: white,
                // //           ),
                // //         ),
                // //       ),
                // //       Expanded(
                // //         child: Text(
                // //           'QTY',
                // //           style: TextStyle(
                // //             fontWeight: FontWeight.bold,
                // //             color: white,
                // //           ),
                // //         ),
                // //       ),
                // //       Expanded(
                // //         child: Text(
                // //           'TOTAL',
                // //           style: TextStyle(
                // //             fontWeight: FontWeight.bold,
                // //             color: white,
                // //           ),
                // //         ),
                // //       ),
                // //       SizedBox(width: 40), // Space for edit button
                // //     ],
                // //   ),
                // // ),
                // //
                // // // Materials List
                // // Container(
                // //   decoration: BoxDecoration(
                // //     borderRadius:  BorderRadius.only(
                // //       bottomLeft: Radius.circular(2.w),
                // //       bottomRight: Radius.circular(2.w),
                // //     ),
                // //     color: Colors.white,
                // //   ),
                // //   child: ListView.separated(
                // //     shrinkWrap: true,
                // //     physics: const NeverScrollableScrollPhysics(),
                // //     itemCount: materials.length,
                // //     separatorBuilder: (context, index) => const Divider(height: 1),
                // //     itemBuilder: (context, index) {
                // //       final item = materials[index];
                // //       return Container(
                // //         color: Colors.white,
                // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                // //         child: Row(
                // //           children: [
                // //             // Material Icon and Name
                // //             Expanded(
                // //               flex: 2,
                // //               child: Row(
                // //                 children: [
                // //                   Container(
                // //                     padding: const EdgeInsets.all(6),
                // //                     decoration: BoxDecoration(
                // //                       color: Colors.blue[100],
                // //                       borderRadius: BorderRadius.circular(6),
                // //                     ),
                // //                     child: Icon(item.image, size: 20, color: Colors.blue[800]),
                // //                   ),
                // //                   const SizedBox(width: 12),
                // //                   Expanded(
                // //                     child: Text(
                // //                       item.name,
                // //                       style: const TextStyle(fontSize: 14),
                // //                       maxLines: 2,
                // //                     ),
                // //                   ),
                // //                 ],
                // //               ),
                // //             ),
                // //
                // //             // Unit Price
                // //             Expanded(
                // //               child: Text(
                // //                 '\$${item.unitPrice.toStringAsFixed(2)}',
                // //                 style: const TextStyle(fontSize: 14),
                // //               ),
                // //             ),
                // //
                // //             // Quantity
                // //             Expanded(
                // //               child: Text(
                // //                 item.quantity.toString(),
                // //                 style: const TextStyle(fontSize: 14),
                // //               ),
                // //             ),
                // //
                // //             // Total
                // //             Expanded(
                // //               child: Text(
                // //                 '\$${item.total.toStringAsFixed(2)}',
                // //                 style: const TextStyle(
                // //                   fontSize: 14,
                // //                   fontWeight: FontWeight.w600,
                // //                 ),
                // //               ),
                // //             ),
                // //
                // //             // Edit Button
                // //             SizedBox(
                // //               width: 40,
                // //               child: IconButton(
                // //                 icon: const Icon(Icons.edit, size: 20),
                // //                 color: Colors.blue,
                // //                 onPressed: () {
                // //                   Get.toNamed(Routes.EDITREPAIRMATERIAL);
                // //                   // Edit functionality
                // //                 },
                // //               ),
                // //             ),
                // //           ],
                // //         ),
                // //       );
                // //     },
                // //   ),
                // // ),
                //
                // // Summary Section
                // Container(
                //   margin: const EdgeInsets.only(top: 24),
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(12),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.1),
                //         blurRadius: 10,
                //         offset: const Offset(0, 4),
                //       ),
                //     ],
                //   ),
                //   child: Column(
                //     children: [
                //       _buildSummaryRow('Parts Total', '\$${partsTotal.toStringAsFixed(2)}',
                //           subtitle: 'Sum of all materials'),
                //       const SizedBox(height: 12),
                //       _buildSummaryRow('Labour Cost', '\$${laborCost.toStringAsFixed(2)}',
                //           subtitle: 'Estimated hours x rate'),
                //       const Divider(height: 24),
                //       _buildSummaryRow(
                //         'Total Estimate',
                //         '\$${totalEstimate.toStringAsFixed(2)}',
                //         isTotal: true,
                //         subtitle: 'Parts + Labour (Editable)',
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value,
      {bool isTotal = false, String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isTotal ? 18 : 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? Colors.blue[800] : Colors.black,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: isTotal ? 20 : 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                color: isTotal ? Colors.blue[800] : Colors.black,
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ],
    );
  }
}

class MaterialItem {
  final String name;
  final double unitPrice;
  final int quantity;
  final IconData image;

  MaterialItem({
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.image,
  });

  double get total => unitPrice * quantity;
}





