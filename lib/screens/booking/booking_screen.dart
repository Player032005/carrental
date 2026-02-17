import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_textstyles.dart';
import '../../models/car_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/date_formatter.dart';
import '../../utils/price_calculator.dart';
import '../../widgets/common/custom_button.dart';

/// Booking screen for selecting dates and confirming reservation
class BookingScreen extends StatefulWidget {
  final CarModel car;

  const BookingScreen({
    required this.car,
    Key? key,
  }) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _pickupDate;
  DateTime? _returnDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          AppStrings.bookingDetails,
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car info card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.lightGrey,
                    ),
                    child: Icon(
                      Icons.directions_car,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.car.name,
                          style: AppTextStyles.titleMedium,
                        ),
                        Text(
                          widget.car.model,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${widget.car.pricePerDay.toStringAsFixed(2)}/day',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Date selection section
            Text(
              AppStrings.selectAvailableDates,
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 12),

            // Pickup date
            _buildDatePickerField(
              label: AppStrings.pickupDate,
              selectedDate: _pickupDate,
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _pickupDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (selectedDate != null) {
                  setState(() {
                    _pickupDate = selectedDate;
                    // Reset return date if it's before pickup date
                    if (_returnDate != null &&
                        _returnDate!.isBefore(_pickupDate!)) {
                      _returnDate = null;
                    }
                  });
                }
              },
            ),
            const SizedBox(height: 12),

            // Return date
            _buildDatePickerField(
              label: AppStrings.returnDate,
              selectedDate: _returnDate,
              onPressed: _pickupDate == null
                  ? null
                  : () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _returnDate ??
                            _pickupDate!.add(const Duration(days: 1)),
                        firstDate: _pickupDate!.add(const Duration(days: 1)),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365),
                        ),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _returnDate = selectedDate;
                        });
                      }
                    },
            ),
            const SizedBox(height: 32),

            // Booking summary
            if (_pickupDate != null && _returnDate != null)
              _buildBookingSummary(),

            const SizedBox(height: 32),

            // Terms and conditions
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (_) {},
                ),
                Expanded(
                  child: Text(
                    'I agree to the terms and conditions',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Confirm button
            Consumer2<BookingProvider, AuthProvider>(
              builder: (context, bookingProvider, authProvider, _) {
                final isFormValid =
                    _pickupDate != null && _returnDate != null;

                return CustomButton(
                  text: AppStrings.confirmBooking,
                  onPressed: isFormValid
                      ? () => _handleConfirmBooking(
                            authProvider,
                            bookingProvider,
                          )
                      : null,
                  isLoading: bookingProvider.isLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build date picker field
  Widget _buildDatePickerField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  selectedDate != null
                      ? DateFormatter.formatDate(selectedDate)
                      : 'Select date',
                  style: selectedDate != null
                      ? AppTextStyles.bodyMedium
                      : AppTextStyles.hintText,
                ),
              ],
            ),
            Icon(
              Icons.calendar_today,
              color: onPressed == null
                  ? AppColors.lightGrey
                  : AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  /// Build booking summary section
  Widget _buildBookingSummary() {
    final numberOfDays =
        PriceCalculator.calculateNumberOfDays(_pickupDate!, _returnDate!);
    final totalPrice = PriceCalculator.calculateTotalPrice(
      widget.car.pricePerDay,
      numberOfDays,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.1),
        border: Border.all(
          color: AppColors.primary,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            label: AppStrings.numberOfDays,
            value: '$numberOfDays ${numberOfDays == 1 ? 'day' : 'days'}',
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            label: AppStrings.pricePerDayLabel,
            value:
                '\$${widget.car.pricePerDay.toStringAsFixed(2)}',
          ),
          const Divider(height: 16),
          _buildSummaryRow(
            label: AppStrings.totalPrice,
            value: '\$${totalPrice.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  /// Build summary row
  Widget _buildSummaryRow({
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTextStyles.titleSmall
              : AppTextStyles.bodyMedium,
        ),
        Text(
          value,
          style: isBold
              ? AppTextStyles.titleSmall.copyWith(
                  color: AppColors.primary,
                )
              : AppTextStyles.bodyMedium,
        ),
      ],
    );
  }

  /// Handle booking confirmation
  Future<void> _handleConfirmBooking(
    AuthProvider authProvider,
    BookingProvider bookingProvider,
  ) async {
    if (_pickupDate == null || _returnDate == null) return;

    final success = await bookingProvider.createBooking(
      userId: authProvider.currentUser!.id,
      carId: widget.car.id,
      carName: widget.car.name,
      pickupDate: _pickupDate!,
      returnDate: _returnDate!,
      pricePerDay: widget.car.pricePerDay,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Booking confirmed successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/home',
        (route) => false,
      );
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            bookingProvider.error ?? AppStrings.somethingWentWrong,
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
