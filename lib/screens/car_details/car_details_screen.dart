import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_textstyles.dart';
import '../../providers/car_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/error_widget.dart' as custom_error_widget;
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/rating_widget.dart';
import '../booking/booking_screen.dart';

/// Car details screen
class CarDetailsScreen extends StatefulWidget {
  final String carId;

  const CarDetailsScreen({
    required this.carId,
    Key? key,
  }) : super(key: key);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch car details when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CarProvider>(context, listen: false)
          .getCarById(widget.carId);
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
          AppStrings.carDetails,
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
        ),
      ),
      body: Consumer2<CarProvider, AuthProvider>(
        builder: (context, carProvider, authProvider, _) {
          if (carProvider.isLoading) {
            return const LoadingWidget(message: AppStrings.loading);
          }

          if (carProvider.error != null) {
            return custom_error_widget.ErrorWidget(
              message:
                  carProvider.error ?? AppStrings.somethingWentWrong,
              onRetry: () {
                carProvider.getCarById(widget.carId);
              },
            );
          }

          if (carProvider.selectedCar == null) {
            return const SizedBox.expand(
              child: Center(
                child: Text('Car not found'),
              ),
            );
          }

          final car = carProvider.selectedCar!;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Car image carousel
                    Stack(
                      children: [
                        if (car.imageUrls.isNotEmpty)
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 250,
                              viewportFraction: 1.0,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                            ),
                            items: car.imageUrls.map((imageUrl) {
                              return CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Container(
                                  color: AppColors.lightGrey,
                                  child: Icon(
                                    Icons.directions_car,
                                    size: 100,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        else
                          Container(
                            height: 250,
                            color: AppColors.lightGrey,
                            child: Icon(
                              Icons.directions_car,
                              size: 100,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        // Image indicator dots
                        if (car.imageUrls.isNotEmpty)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                car.imageUrls.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == index
                                        ? AppColors.white
                                        : AppColors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Car info section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Car name and rating
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      car.displayName,
                                      style:
                                          AppTextStyles.headlineSmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    RatingWidget(
                                      rating: car.rating,
                                      reviewCount: car.reviewCount,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: car.isAvailable
                                      ? AppColors.success
                                      : AppColors.error,
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: Text(
                                  car.isAvailable
                                      ? AppStrings.available
                                      : AppStrings.unavailable,
                                  style: AppTextStyles.labelSmall
                                      .copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Price
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$${car.pricePerDay.toStringAsFixed(2)}',
                                  style: AppTextStyles.headlineLarge
                                      .copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: ' / day',
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Description
                          Text(
                            AppStrings.description,
                            style: AppTextStyles.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            car.description,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Features
                          Text(
                            AppStrings.features,
                            style: AppTextStyles.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _buildFeatureChip(
                                icon: Icons.person,
                                label:
                                    '${car.seats} ${AppStrings.seats}',
                              ),
                              _buildFeatureChip(
                                icon: Icons.speed,
                                label:
                                    car.transmission,
                              ),
                              _buildFeatureChip(
                                icon: Icons.local_gas_station,
                                label: car.fuelType,
                              ),
                              if (car.airConditioning)
                                _buildFeatureChip(
                                  icon: Icons.ac_unit,
                                  label: 'AC',
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Book button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: CustomButton(
                    text: AppStrings.bookNow,
                    onPressed: car.isAvailable
                        ? () {
                            if (authProvider.isLoggedIn) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingScreen(
                                    car: car,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please login to book a car'),
                                ),
                              );
                              Navigator.pushNamed(context, '/login');
                            }
                          }
                        : null,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build feature chip widget
  Widget _buildFeatureChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.1),
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
