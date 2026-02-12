import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:sizer/sizer.dart';

import '../utils/colors.dart';
import '../utils/theme/app_colors.dart';

typedef ItemLabelBuilder<T> = String Function(T item);
typedef ItemValueBuilder<T> = dynamic Function(T item);

class GenericDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final List<T> items;
  final dynamic selectedValue;
  final bool error;
  final String? errorText;
  final ItemLabelBuilder<T> getLabel;
  final ItemValueBuilder<T> getValue;
  final ValueChanged<T> onChanged;
  final bool isLoading;

  const GenericDropdown({
    Key? key,
    required this.label,
    required this.hint,
    required this.items,
    this.selectedValue,
    this.error = false,
    this.errorText,
    required this.getLabel,
    required this.getValue,
    required this.onChanged,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    T? matchedItem;
    try {
      matchedItem = items.firstWhere(
            (item) => getValue(item) == selectedValue,
      );
    } catch (_) {
      matchedItem = null;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              label.customText(size: 10.sp, fontWeight: FontWeight.w600,color: white),
              "*".customText(
                size: 10.sp,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          5.height,
          isLoading
              ? Container(
            height: 55,
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Lottie.asset(
              'assets/icons/loading_dot_animation.json',
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
          )
              : DropdownButtonFormField<dynamic>(
            isExpanded: true,
            value: matchedItem != null ? getValue(matchedItem) : null,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.divider,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.fieldBorder
                ),
              ),
              errorText:
              error ? (errorText ?? 'This field is required') : null,
            ),
            hint: hint.customText(
              size: 11.5.sp,
              color: lightGrey,
              fontWeight: FontWeight.w600,
            ),
            items: items.map((item) {
              final value = getValue(item);
              return DropdownMenuItem<dynamic>(
                value: value,
                child: Text(
                  getLabel(item),
                  style: TextStyle(fontSize: 11.sp),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val == null) return;
              final selected = items.firstWhere(
                    (item) => getValue(item) == val,
              );
              onChanged(selected);
            },
          ),
        ],
      ),
    );
  }
}
