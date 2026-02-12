import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/colors.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_bar.dart';
import '../../../routes/app_pages.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBarBolt(
        showBackButton: true,
        title: 'Subscription Plans',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose the plan that works for you',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            _buildPlanCard(
              name: 'Basic',
              price: 'Free',
              features: [
                '5 reports per month',
                'Basic damage detection',
                'Email support',
                'Standard PDF exports',
              ],
              isPopular: false,
              buttonText: 'Current Plan',
              onTap: null,
            ),

            const SizedBox(height: 16),

            _buildPlanCard(
              name: 'Pro',
              price: '\$29/month',
              features: [
                'Unlimited reports',
                'Advanced AI detection',
                'Priority support',
                'Custom branding',
                '3D walkthroughs',
                'Repair estimates',
              ],
              isPopular: true,
              buttonText: 'Upgrade',
              onTap: () {
                _showUpgradeDialog('Pro', 29);
              },
            ),

            const SizedBox(height: 16),

            _buildPlanCard(
              name: 'Premium',
              price: '\$99/month',
              features: [
                'Everything in Pro',
                'Team collaboration',
                'API access',
                'White-label solution',
                'Dedicated account manager',
                'Custom integrations',
              ],
              isPopular: false,
              buttonText: 'Upgrade',
              onTap: () {
                _showUpgradeDialog('Premium', 99);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String name,
    required String price,
    required List<String> features,
    required bool isPopular,
    required String buttonText,
    required VoidCallback? onTap,
  }) {
    return Card(
      elevation: isPopular ? 4 : 2,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isPopular ? primaryColor : white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
                const SizedBox(height: 20),
                ...features.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 20,
                        ).gradient(AppGradients.primaryGradient),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 14,
                              color: grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isPopular ? primaryColor : Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(fontSize: 16,color: isPopular ? white : Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          if (isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: const Text(
                  'POPULAR',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showUpgradeDialog(String plan, int price) {
    Get.dialog(
      AlertDialog(
        title: Text('Upgrade to $plan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You are about to upgrade to the $plan plan.'),
            const SizedBox(height: 16),
            Text(
              '\$$price/month',
              style:  TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed(Routes.PAYMENTSUCCESS, arguments: plan);
            },
            child: const Text('Continue to Payment'),
          ),
        ],
      ),
    );
  }
}