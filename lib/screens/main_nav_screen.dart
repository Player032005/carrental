import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_textstyles.dart';
import '../models/booking_model.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../utils/date_formatter.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';

/// Main navigation shell for MVP experience
class MainNavScreen extends StatefulWidget {
  const MainNavScreen({Key? key}) : super(key: key);

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showSupportMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.supportMessage),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _HomeOverviewTabScreen(
        onSearchTap: () => _onItemTapped(1),
        onBookingsTap: () => _onItemTapped(2),
      ),
      const HomeScreen(),
      const _BookingsTabScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _showSupportMessage,
        child: const Icon(Icons.support_agent, color: AppColors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: AppStrings.search,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online_outlined),
            activeIcon: Icon(Icons.book_online),
            label: AppStrings.bookings,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}

class _HomeOverviewTabScreen extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onBookingsTap;

  const _HomeOverviewTabScreen({
    required this.onSearchTap,
    required this.onBookingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          AppStrings.home,
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.homeOverviewTitle,
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.homeOverviewSubtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onSearchTap,
              icon: const Icon(Icons.search),
              label: const Text(AppStrings.exploreCars),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onBookingsTap,
              icon: const Icon(Icons.book_online_outlined),
              label: const Text(AppStrings.viewBookings),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingsTabScreen extends StatefulWidget {
  const _BookingsTabScreen();

  @override
  State<_BookingsTabScreen> createState() => _BookingsTabScreenState();
}

class _BookingsTabScreenState extends State<_BookingsTabScreen> {
  String? _loadedUserId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;

    if (userId != null && userId != _loadedUserId) {
      _loadedUserId = userId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Provider.of<BookingProvider>(
          context,
          listen: false,
        ).fetchUserBookings(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          AppStrings.bookings,
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
        ),
      ),
      body: authProvider.currentUser == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  AppStrings.login,
                  style: AppTextStyles.bodyLarge,
                ),
              ),
            )
          : Consumer<BookingProvider>(
              builder: (context, bookingProvider, _) {
                if (bookingProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (bookingProvider.error != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        bookingProvider.error!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  );
                }

                final upcoming = bookingProvider.upcomingBookings;
                final past = bookingProvider.completedBookings;

                if (upcoming.isEmpty && past.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        AppStrings.noBookings,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    final userId = authProvider.currentUser?.id;
                    if (userId != null) {
                      await bookingProvider.fetchUserBookings(userId);
                    }
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (upcoming.isNotEmpty) ...[
                        Text(
                          AppStrings.upcomingBookings,
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        ...upcoming.map(_buildBookingCard),
                        const SizedBox(height: 20),
                      ],
                      if (past.isNotEmpty) ...[
                        Text(
                          AppStrings.pastBookings,
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        ...past.map(_buildBookingCard),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
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
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(booking.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _statusColor(booking.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${AppStrings.pickupDate}: ${DateFormatter.formatDate(booking.pickupDate)}',
            style: AppTextStyles.bodySmall,
          ),
          Text(
            '${AppStrings.returnDate}: ${DateFormatter.formatDate(booking.returnDate)}',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 6),
          Text(
            '${AppStrings.totalPrice}: ₹${booking.totalPrice.toStringAsFixed(2)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'pending':
        return AppColors.warning;
      case 'completed':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }
}
