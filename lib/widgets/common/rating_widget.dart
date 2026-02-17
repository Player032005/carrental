import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';

/// Rating widget to display star ratings
class RatingWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final int starCount;
  final double starSize;
  final Color? starColor;
  final bool isInteractive;
  final Function(double)? onRatingChanged;

  const RatingWidget({
    required this.rating,
    this.reviewCount = 0,
    this.starCount = 5,
    this.starSize = 16,
    this.starColor,
    this.isInteractive = false,
    this.onRatingChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: isInteractive
          ? _buildInteractiveRating()
          : _buildStaticRating(),
    );
  }

  /// Build interactive rating (for adding reviews)
  Widget _buildInteractiveRating() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            starCount,
            (index) => GestureDetector(
              onTap: () {
                onRatingChanged?.call(index + 1.0);
              },
              child: Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: starColor ?? AppColors.ratingColor,
                size: starSize,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${rating.toStringAsFixed(1)} / $starCount',
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  /// Build static rating display
  Widget _buildStaticRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(
            starCount,
            (index) => Icon(
              index < rating.floor()
                  ? Icons.star
                  : (index < rating ? Icons.star_half : Icons.star_border),
              color: starColor ?? AppColors.ratingColor,
              size: starSize,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${rating.toStringAsFixed(1)}',
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (reviewCount > 0) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ],
    );
  }
}
