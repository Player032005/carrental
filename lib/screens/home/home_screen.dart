import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_textstyles.dart';
import '../../providers/car_provider.dart';
import '../../providers/filter_provider.dart';
import '../../widgets/common/error_widget.dart' as custom_error_widget;
import '../../widgets/common/loading_widget.dart';
import '../../widgets/home/car_card_widget.dart';
import '../../widgets/home/search_bar_widget.dart';
import '../../widgets/home/filter_widget.dart';
import '../car_details/car_details_screen.dart';

/// Home screen displaying list of cars
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch cars when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CarProvider>(context, listen: false).fetchAllCars();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          AppStrings.availableCars,
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.white),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Consumer2<CarProvider, FilterProvider>(
        builder: (context, carProvider, filterProvider, _) {
          return Column(
            children: [
              // Search bar
              SearchBarWidget(
                controller: _searchController,
                onChanged: (query) {
                  carProvider.searchCars(query);
                },
                onClearPressed: () {
                  _searchController.clear();
                  carProvider.searchCars('');
                },
              ),

              // Filter bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Category filter chip
                            FilterChip(
                              label: const Text('Category'),
                              onSelected: (_) {
                                final categories = carProvider.getCategories();
                                final priceRange = carProvider.getPriceRange();

                                showFilterBottomSheet(
                                  context,
                                  selectedCategory:
                                      carProvider.selectedCategory,
                                  categories: categories,
                                  minPrice: carProvider.minPrice,
                                  maxPrice: carProvider.maxPrice,
                                  minPriceRange: priceRange['min'] ?? 0,
                                  maxPriceRange: priceRange['max'] ?? 1000,
                                  onCategoryChanged: () => setState(() {}),
                                  onPriceChanged: (min, max) {
                                    carProvider.filterByPrice(min, max);
                                  },
                                  onReset: () {
                                    carProvider.clearFilters();
                                  },
                                );
                              },
                              selected:
                                  filterProvider.hasActiveFilters,
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: filterProvider.hasActiveFilters
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Clear filters button
                    if (filterProvider.hasActiveFilters)
                      TextButton(
                        onPressed: () {
                          carProvider.clearFilters();
                          filterProvider.clearFilters();
                          _searchController.clear();
                        },
                        child: Text(
                          'Clear',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Car list
              Expanded(
                child: carProvider.isLoading
                    ? const LoadingWidget(message: AppStrings.loading)
                    : carProvider.error != null
                        ? custom_error_widget.ErrorWidget(
                            message: carProvider.error ?? AppStrings.somethingWentWrong,
                            onRetry: () => carProvider.fetchAllCars(),
                          )
                        : carProvider.filteredCars.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.directions_car,
                                      size: 64,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No cars found',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 16),
                                itemCount: carProvider.filteredCars.length,
                                itemBuilder: (context, index) {
                                  final car = carProvider.filteredCars[index];
                                  return CarCardWidget(
                                    car: car,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CarDetailsScreen(
                                            carId: car.id,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
              ),
            ],
          );
        },
      ),
    );
  }
}
