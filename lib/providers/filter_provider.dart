import 'package:flutter/material.dart';

/// Filter Provider for managing home screen filters
class FilterProvider extends ChangeNotifier {
  String? _selectedCategory;
  double _minPrice = 0;
  double _maxPrice = 1000;
  String _searchQuery = '';
  bool _showAvailableOnly = false;

  // Getters
  String? get selectedCategory => _selectedCategory;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  String get searchQuery => _searchQuery;
  bool get showAvailableOnly => _showAvailableOnly;

  /// Update search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Update category filter
  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Update price range filter
  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  /// Toggle available only filter
  void setShowAvailableOnly(bool value) {
    _showAvailableOnly = value;
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _selectedCategory = null;
    _minPrice = 0;
    _maxPrice = 1000;
    _searchQuery = '';
    _showAvailableOnly = false;
    notifyListeners();
  }

  /// Check if any filter is active
  bool get hasActiveFilters {
    return _selectedCategory != null ||
        _minPrice > 0 ||
        _maxPrice < 1000 ||
        _searchQuery.isNotEmpty ||
        _showAvailableOnly;
  }
}
