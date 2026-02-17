import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_textstyles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_widget.dart';

/// Profile screen showing user information and booking history
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load user bookings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser != null) {
        Provider.of<BookingProvider>(context, listen: false)
            .fetchUserBookings(authProvider.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          AppStrings.profile,
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
        ),
      ),
      body: Consumer3<AuthProvider, UserProvider, BookingProvider>(
        builder: (context, authProvider, userProvider, bookingProvider, _) {
          final user = authProvider.currentUser;

          if (user == null) {
            return const SizedBox.expand(
              child: Center(
                child: Text('User not found'),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User card
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Column(
                    children: [
                      // Profile avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                        child: Center(
                          child: Text(
                            user.initials,
                            style: AppTextStyles.headlineLarge.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // User name
                      Text(
                        user.fullName,
                        style: AppTextStyles.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      // User email
                      Text(
                        user.email,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Edit profile button
                      CustomButton(
                        text: AppStrings.editProfile,
                        onPressed: () {
                          // TODO: Navigate to edit profile screen
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // User information section
                Text(
                  AppStrings.personalInfo,
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.person,
                  label: 'Full Name',
                  value: user.fullName,
                ),
                const SizedBox(height: 8),
                _buildInfoCard(
                  icon: Icons.email,
                  label: AppStrings.email,
                  value: user.email,
                ),
                const SizedBox(height: 8),
                _buildInfoCard(
                  icon: Icons.phone,
                  label: AppStrings.phoneNumber,
                  value: user.phoneNumber,
                ),
                const SizedBox(height: 24),

                // Booking history section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.bookingHistory,
                      style: AppTextStyles.titleMedium,
                    ),
                    if (bookingProvider.userBookings.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          // Show all bookings dialog
                        },
                        child: Text(
                          'View All',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Upcoming bookings
                if (bookingProvider.upcomingBookings.isNotEmpty) ...[
                  Text(
                    AppStrings.upcomingBookings,
                    style: AppTextStyles.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  ...bookingProvider.upcomingBookings
                      .take(3)
                      .map((booking) => _buildBookingCard(booking)),
                  const SizedBox(height: 16),
                ],

                // Past bookings
                if (bookingProvider.completedBookings.isNotEmpty) ...[
                  Text(
                    AppStrings.pastBookings,
                    style: AppTextStyles.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  ...bookingProvider.completedBookings
                      .take(2)
                      .map((booking) => _buildBookingCard(booking)),
                  const SizedBox(height: 16),
                ] else if (bookingProvider.userBookings.isEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.car_rental,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppStrings.noBookings,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Logout button
                CustomButton(
                  text: AppStrings.logout,
                  onPressed: () => _handleLogout(context),
                  backgroundColor: AppColors.error,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build info card widget
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build booking card widget
  Widget _buildBookingCard(booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  booking.carName,
                  style: AppTextStyles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: booking.status == 'confirmed'
                      ? AppColors.success.withOpacity(0.2)
                      : AppColors.warning.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: booking.status == 'confirmed'
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormatter.formatDate(booking.pickupDate),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.textSecondary,
              ),
              Text(
                DateFormatter.formatDate(booking.returnDate),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${booking.numberOfDays} days',
                style: AppTextStyles.bodySmall,
              ),
              Text(
                '\$${booking.totalPrice.toStringAsFixed(2)}',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Handle logout
  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.logout),
        content: const Text(AppStrings.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.logout();

      if (success && mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    }
  }
}
