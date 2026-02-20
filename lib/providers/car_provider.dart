import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../models/car_model.dart';

/// Car Provider for managing cars list and car details
class CarProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  /// Set error message
  void setError(String error) {
    _isLoading = false;
    _error = error;
    notifyListeners();
  }

  /// Add test cars to Firestore (admin feature for quick setup)
  Future<bool> addTestCars() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final testCars = [
        {
          'id': 'car_002',
          'name': 'Toyota Fortuner',
          'model': 'Fortuner',
          'year': 2023,
          'category': 'SUV',
          'pricePerDay': 4500.0,
          'rating': 4.8,
          'reviewCount': 45,
          'seats': 7,
          'transmission': 'Automatic',
          'fuelType': 'Diesel',
          'airConditioning': true,
          'description': 'Spacious SUV perfect for family trips',
          'imageUrls': [],
          'available': true,
        },
        {
          'id': 'car_003',
          'name': 'Hyundai Creta',
          'model': 'Creta',
          'year': 2024,
          'category': 'SUV',
          'pricePerDay': 3800.0,
          'rating': 4.6,
          'reviewCount': 32,
          'seats': 5,
          'transmission': 'Automatic',
          'fuelType': 'Petrol',
          'airConditioning': true,
          'description': 'Modern compact SUV with comfort',
          'imageUrls': [],
          'available': true,
        },
        {
          'id': 'car_004',
          'name': 'Honda City',
          'model': 'City',
          'year': 2023,
          'category': 'Sedan',
          'pricePerDay': 2500.0,
          'rating': 4.4,
          'reviewCount': 28,
          'seats': 5,
          'transmission': 'Manual',
          'fuelType': 'Petrol',
          'airConditioning': true,
          'description': 'Affordable and reliable sedan',
          'imageUrls': [],
          'available': true,
        },
        {
          'id': 'car_005',
          'name': 'BMW X5',
          'model': 'X5',
          'year': 2024,
          'category': 'Luxury',
          'pricePerDay': 8500.0,
          'rating': 4.9,
          'reviewCount': 18,
          'seats': 5,
          'transmission': 'Automatic',
          'fuelType': 'Petrol',
          'airConditioning': true,
          'description': 'Premium luxury SUV with all features',
          'imageUrls': [],
          'available': true,
        },
      ];

      for (var car in testCars) {
        await _firestore.collection('cars').doc(car['id'] as String).set(car);
      }

      await fetchAllCars(); // Refresh the car list
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
