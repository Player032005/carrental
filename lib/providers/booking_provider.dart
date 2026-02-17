import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/booking_model.dart';
import '../utils/price_calculator.dart';

/// Booking Provider for managing bookings
class BookingProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<BookingModel> _userBookings = [];
  List<BookingModel> _allBookings = [];
  BookingModel? _selectedBooking;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<BookingModel> get userBookings => _userBookings;
  List<BookingModel> get allBookings => _allBookings;
  BookingModel? get selectedBooking => _selectedBooking;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get upcoming bookings for user
  List<BookingModel> get upcomingBookings => _userBookings
      .where((booking) => booking.isUpcoming)
      .toList();

  /// Get completed bookings for user
  List<BookingModel> get completedBookings => _userBookings
      .where((booking) => booking.isCompleted)
      .toList();

  /// Fetch user bookings
  Future<void> fetchUserBookings(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _userBookings = await _firestoreService.getUserBookings(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch all bookings (admin)
  Future<void> fetchAllBookings() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final allBookings = <BookingModel>[];
      final booksSnapshot = await _firestoreService
          .getCarBookings(''); // This is a workaround, typically you'd fetch all

      _allBookings = allBookings;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create new booking
  Future<bool> createBooking({
    required String userId,
    required String carId,
    required String carName,
    required DateTime pickupDate,
    required DateTime returnDate,
    required double pricePerDay,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final numberOfDays =
          PriceCalculator.calculateNumberOfDays(pickupDate, returnDate);
      final totalPrice =
          PriceCalculator.calculateTotalPrice(pricePerDay, numberOfDays);

      final booking = BookingModel(
        id: '',
        userId: userId,
        carId: carId,
        carName: carName,
        pickupDate: pickupDate,
        returnDate: returnDate,
        totalPrice: totalPrice,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await _firestoreService.createBooking(booking);
      await fetchUserBookings(userId); // Refresh list
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

  /// Get booking by ID
  Future<BookingModel?> getBookingById(String bookingId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _selectedBooking = await _firestoreService.getBookingById(bookingId);
      _isLoading = false;
      notifyListeners();
      return _selectedBooking;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Update booking status
  Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestoreService.updateBookingStatus(bookingId, status);
      if (_selectedBooking != null) {
        _selectedBooking =
            _selectedBooking!.copyWith(status: status);
      }
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

  /// Cancel booking
  Future<bool> cancelBooking(String bookingId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestoreService.cancelBooking(bookingId);
      _userBookings.removeWhere((booking) => booking.id == bookingId);
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

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
