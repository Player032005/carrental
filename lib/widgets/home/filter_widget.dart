import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';

/// Filter widget for home screen filters
class FilterWidget extends StatefulWidget {
  final String? selectedCategory;
  final List<String> categories;
  final double minPrice;
  final double maxPrice;
  final double minPriceRange;
  final double maxPriceRange;
  final Function(String?)? onCategoryChanged;
  final Function(double, double)? onPriceChanged;
  final VoidCallback? onReset;

  const FilterWidget({
    this.selectedCategory,
    required this.categories,
    required this.minPrice,
    required this.maxPrice,
    required this.minPriceRange,
    required this.maxPriceRange,
    this.onCategoryChanged,
    this.onPriceChanged,
    this.onReset,
    Key? key,
  }) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late RangeValues _priceRange;
  late double _effectiveMin;
  late double _effectiveMax;

  @override
  void initState() {
    super.initState();
    _syncPriceRange();
  }

  @override
  void didUpdateWidget(covariant FilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.minPrice != widget.minPrice ||
        oldWidget.maxPrice != widget.maxPrice ||
        oldWidget.minPriceRange != widget.minPriceRange ||
        oldWidget.maxPriceRange != widget.maxPriceRange) {
      _syncPriceRange();
    }
  }

  void _syncPriceRange() {
    _effectiveMin = widget.minPriceRange;
    _effectiveMax = widget.maxPriceRange;

    if (_effectiveMax < _effectiveMin) {
      final temp = _effectiveMin;
      _effectiveMin = _effectiveMax;
      _effectiveMax = temp;
    }

    if (_effectiveMax == _effectiveMin) {
      _effectiveMax = _effectiveMin + 1;
    }

    final start = widget.minPrice.clamp(_effectiveMin, _effectiveMax);
    final end = widget.maxPrice.clamp(start, _effectiveMax);
    _priceRange = RangeValues(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: AppTextStyles.headlineSmall,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Category filter
            Text(
              'Category',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                // All categories button
                FilterChip(
                  label: const Text('All'),
                  selected: widget.selectedCategory == null,
                  onSelected: (_) {
                    widget.onCategoryChanged?.call(null);
                    Navigator.pop(context);
                  },
                ),
                // Category chips
                ...widget.categories.map((category) {
                  return FilterChip(
                    label: Text(category),
                    selected: widget.selectedCategory == category,
                    onSelected: (_) {
                      widget.onCategoryChanged?.call(category);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),

            // Price filter
            Text(
              'Price per Day',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 12),
            RangeSlider(
              values: _priceRange,
              min: _effectiveMin,
              max: _effectiveMax,
              onChanged: (RangeValues values) {
                setState(() {
                  _priceRange = values;
                });
                widget.onPriceChanged?.call(values.start, values.end);
              },
              activeColor: AppColors.primary,
              inactiveColor: AppColors.lightGrey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${_priceRange.start.toStringAsFixed(0)}',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  '₹${_priceRange.end.toStringAsFixed(0)}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onReset?.call();
                      Navigator.pop(context);
                    },
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Show filter bottom sheet
Future<void> showFilterBottomSheet(
  BuildContext context, {
  required String? selectedCategory,
  required List<String> categories,
  required double minPrice,
  required double maxPrice,
  required double minPriceRange,
  required double maxPriceRange,
  Function(String?)? onCategoryChanged,
  Function(double, double)? onPriceChanged,
  VoidCallback? onReset,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => FilterWidget(
      selectedCategory: selectedCategory,
      categories: categories,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minPriceRange: minPriceRange,
      maxPriceRange: maxPriceRange,
      onCategoryChanged: onCategoryChanged,
      onPriceChanged: onPriceChanged,
      onReset: onReset,
    ),
  );
}
