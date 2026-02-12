import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/theme/app_colors.dart';

class ShimmerList extends StatelessWidget {
  final int itemCount;

  const ShimmerList({Key? key, this.itemCount = 6}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade800,
          highlightColor: Colors.grey.shade700,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Image placeholder
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),

                // Text placeholders
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}





class DamageReportShimmer extends StatelessWidget {
  final int damageCount;

  const DamageReportShimmer({super.key, this.damageCount = 6});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerCard(height: 90), // Property card
          const SizedBox(height: 20),

          _shimmerTitle(width: 140),
          const SizedBox(height: 10),
          _shimmerCard(height: 120), // Summary box
          const SizedBox(height: 24),

          _shimmerVideo(),
          const SizedBox(height: 24),

          _shimmerTitle(width: 180),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: damageCount,
            itemBuilder: (_, __) => _damageItem(),
          ),
        ],
      ),
    );
  }

  // ---------- COMPONENTS ----------

  Widget _shimmerTitle({required double width}) {
    return Shimmer.fromColors(
      baseColor: AppColors.cardBg,
      highlightColor: Colors.grey.shade700,
      child: Container(
        height: 18,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget _shimmerCard({required double height}) {
    return Shimmer.fromColors(
      baseColor: AppColors.cardBg,
      highlightColor: Colors.grey.shade700,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.fieldBorder),
        ),
      ),
    );
  }

  Widget _shimmerVideo() {
    return Shimmer.fromColors(
      baseColor: AppColors.cardBg,
      highlightColor: Colors.grey.shade700,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _damageItem() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: Colors.grey.shade700,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(height: 14, width: double.infinity),
                  const SizedBox(height: 8),
                  _line(height: 12, width: 120),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _chip(width: 80),
                      const SizedBox(width: 12),
                      _chip(width: 60),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _chip({required double width}) {
    return Container(
      height: 26,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
