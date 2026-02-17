import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/car_model.dart';

/// Car Provider for managing cars list and car details
class CarProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<CarModel> _allCars = [];
  List<CarModel> _filteredCars = [];
  CarModel? _selectedCar;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategory;
  double _minPrice = 0;
  double _maxPrice = 1000;

  // Getters
  List<CarModel> get allCars => _allCars;
  List<CarModel> get filteredCars => _filteredCars;
  CarModel? get selectedCar => _selectedCar;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;

  /// Fetch all cars from Firestore
  Future<void> fetchAllCars() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _allCars = await _firestoreService.getAllCars();
      _filteredCars = _allCars;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get car by ID
  Future<CarModel?> getCarById(String carId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _selectedCar = await _firestoreService.getCarById(carId);
      _isLoading = false;
      notifyListeners();
      return _selectedCar;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Search cars by name
  Future<void> searchCars(String query) async {
    try {
      _searchQuery = query;
      _error = null;
      notifyListeners();

      if (query.isEmpty) {
        _filteredCars = _allCars;
      } else {
        _filteredCars = await _firestoreService.searchCars(query);
      }
      
      _applyFilters();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Filter cars by category
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  /// Filter cars by price range
  void filterByPrice(double minPrice, double maxPrice) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _applyFilters();
    notifyListeners();
  }

  /// Apply all filters
  void _applyFilters() {
    _filteredCars = _allCars.where((car) {
      // Search filter
      if (_searchQuery.isNotEmpty &&
          !car.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !car.model.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // Category filter
      if (_selectedCategory != null && car.category != _selectedCategory) {
        return false;
      }

      // Price filter
      if (car.pricePerDay < _minPrice || car.pricePerDay > _maxPrice) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _minPrice = 0;
    _maxPrice = 1000;
    _filteredCars = _allCars;
    notifyListeners();
  }

  /// Get unique categories
  List<String> getCategories() {
    final categories = <String>{};
    for (var car in _allCars) {
      categories.add(car.category);
    }
    return categories.toList();
  }

  /// Get min and max price from all cars
  Map<String, double> getPriceRange() {
    if (_allCars.isEmpty) {
      return {'min': 0, 'max': 1000};
    }

    double minPrice = _allCars.first.pricePerDay;
    double maxPrice = _allCars.first.pricePerDay;

    for (var car in _allCars) {
      if (car.pricePerDay < minPrice) minPrice = car.pricePerDay;
      if (car.pricePerDay > maxPrice) maxPrice = car.pricePerDay;
    }

    return {'min': minPrice, 'max': maxPrice};
  }

  /// Add new car (admin)
  Future<bool> addCar(CarModel car) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestoreService.addCar(car);
      await fetchAllCars(); // Refresh list
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update car (admin)
  Future<bool> updateCar(CarModel car) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestoreService.updateCar(car);
      await fetchAllCars(); // Refresh list
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete car (admin)
  Future<bool> deleteCar(String carId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestoreService.deleteCar(carId);
      await fetchAllCars(); // Refresh list
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
