import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';
import '../models/car_model.dart';
import '../models/booking_model.dart';
import '../models/review_model.dart';

/// Firestore Database Service
/// Handles all database operations for users, cars, bookings, and reviews
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  CarModel _carFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final currentId = (data['id'] as String?)?.trim() ?? '';
    if (currentId.isNotEmpty) {
      return CarModel.fromJson(data);
    }

    return CarModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }

  // Collection references
  static const String usersCollection = 'users';
  static const String carsCollection = 'cars';
  static const String bookingsCollection = 'bookings';
  static const String reviewsCollection = 'reviews';

  // =====================================================
  // USER OPERATIONS
  // =====================================================

  /// Create a new user document
  Future<void> createUser(UserModel user) async {
    try {
      _logger.i('Creating user: ${user.email}');
      await _firestore
          .collection(usersCollection)
          .doc(user.id)
          .set(user.toJson());
      _logger.i('User created successfully');
    } catch (e) {
      _logger.e('Error creating user: $e');
      rethrow;
    }
  }

  /// Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      _logger.i('Fetching user: $userId');
      final doc =
          await _firestore.collection(usersCollection).doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() ?? {});
      }
      return null;
    } catch (e) {
      _logger.e('Error fetching user: $e');
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateUser(UserModel user) async {
    try {
      _logger.i('Updating user: ${user.id}');
      await _firestore
          .collection(usersCollection)
          .doc(user.id)
          .update(user.toJson());
      _logger.i('User updated successfully');
    } catch (e) {
      _logger.e('Error updating user: $e');
      rethrow;
    }
  }

  /// Delete user account
  Future<void> deleteUser(String userId) async {
    try {
      _logger.i('Deleting user: $userId');
      await _firestore.collection(usersCollection).doc(userId).delete();
      _logger.i('User deleted successfully');
    } catch (e) {
      _logger.e('Error deleting user: $e');
      rethrow;
    }
  }

  // =====================================================
  // CAR OPERATIONS
  // =====================================================

  /// Add a new car
  Future<String> addCar(CarModel car) async {
    try {
      _logger.i('Adding new car: ${car.name}');
      final docRef = await _firestore.collection(carsCollection).add(car.toJson());
      final carId = docRef.id;
      // Update car document with its own ID
      await docRef.update({'id': carId});
      _logger.i('Car added successfully with ID: $carId');
      return carId;
    } catch (e) {
      _logger.e('Error adding car: $e');
      rethrow;
    }
  }

  /// Get all cars
  Future<List<CarModel>> getAllCars() async {
    try {
      _logger.i('Fetching all cars');
      final querySnapshot = await _firestore.collection(carsCollection).get();
      final cars = querySnapshot.docs
          .map((doc) => _carFromDoc(doc))
          .toList();
      _logger.i('Fetched ${cars.length} cars');
      return cars;
    } catch (e) {
      _logger.e('Error fetching cars: $e');
      rethrow;
    }
  }

  /// Get car by ID
  Future<CarModel?> getCarById(String carId) async {
    try {
      if (carId.trim().isEmpty) {
        throw ArgumentError('Car ID cannot be empty');
      }

      _logger.i('Fetching car: $carId');
      final doc = await _firestore.collection(carsCollection).doc(carId).get();
      if (doc.exists) {
        return _carFromDoc(doc);
      }

      final querySnapshot = await _firestore
          .collection(carsCollection)
          .where('id', isEqualTo: carId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return _carFromDoc(querySnapshot.docs.first);
      }

      return null;
    } catch (e) {
      _logger.e('Error fetching car: $e');
      rethrow;
    }
  }

  /// Get cars by category
  Future<List<CarModel>> getCarsByCategory(String category) async {
    try {
      _logger.i('Fetching cars by category: $category');
      final querySnapshot = await _firestore
          .collection(carsCollection)
          .where('category', isEqualTo: category)
          .get();
      final cars = querySnapshot.docs
          .map((doc) => _carFromDoc(doc))
          .toList();
      return cars;
    } catch (e) {
      _logger.e('Error fetching cars by category: $e');
      rethrow;
    }
  }

  /// Search cars by name
  Future<List<CarModel>> searchCars(String query) async {
    try {
      _logger.i('Searching cars for: $query');
      final allCars = await getAllCars();
      final filtered = allCars
          .where((car) =>
              car.name.toLowerCase().contains(query.toLowerCase()) ||
              car.model.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return filtered;
    } catch (e) {
      _logger.e('Error searching cars: $e');
      rethrow;
    }
  }

  /// Update car details
  Future<void> updateCar(CarModel car) async {
    try {
      _logger.i('Updating car: ${car.id}');
      await _firestore
          .collection(carsCollection)
          .doc(car.id)
          .update(car.toJson());
      _logger.i('Car updated successfully');
    } catch (e) {
      _logger.e('Error updating car: $e');
      rethrow;
    }
  }

  /// Delete car
  Future<void> deleteCar(String carId) async {
    try {
      _logger.i('Deleting car: $carId');
      await _firestore.collection(carsCollection).doc(carId).delete();
      _logger.i('Car deleted successfully');
    } catch (e) {
      _logger.e('Error deleting car: $e');
      rethrow;
    }
  }

  // =====================================================
  // BOOKING OPERATIONS
  // =====================================================

  /// Create a new booking
  Future<String> createBooking(BookingModel booking) async {
    try {
      _logger.i('Creating booking for user: ${booking.userId}');
      final docRef =
          await _firestore.collection(bookingsCollection).add(booking.toJson());
      final bookingId = docRef.id;
      // Update booking document with its own ID
      await docRef.update({'id': bookingId});
      _logger.i('Booking created successfully with ID: $bookingId');
      return bookingId;
    } catch (e) {
      _logger.e('Error creating booking: $e');
      rethrow;
    }
  }

  /// Get booking by ID
  Future<BookingModel?> getBookingById(String bookingId) async {
    try {
      _logger.i('Fetching booking: $bookingId');
      final doc =
          await _firestore.collection(bookingsCollection).doc(bookingId).get();
      if (doc.exists) {
        return BookingModel.fromJson(doc.data() ?? {});
      }
      return null;
    } catch (e) {
      _logger.e('Error fetching booking: $e');
      rethrow;
    }
  }

  /// Get user's bookings
  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      _logger.i('Fetching bookings for user: $userId');
      final querySnapshot = await _firestore
          .collection(bookingsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('pickupDate', descending: true)
          .get();
      final bookings = querySnapshot.docs
          .map((doc) => BookingModel.fromJson(doc.data()))
          .toList();
      return bookings;
    } catch (e) {
      _logger.e('Error fetching user bookings: $e');
      rethrow;
    }
  }

  /// Get car's bookings
  Future<List<BookingModel>> getCarBookings(String carId) async {
    try {
      _logger.i('Fetching bookings for car: $carId');
      final querySnapshot = await _firestore
          .collection(bookingsCollection)
          .where('carId', isEqualTo: carId)
          .where('status', whereIn: ['confirmed', 'pending'])
          .get();
      final bookings = querySnapshot.docs
          .map((doc) => BookingModel.fromJson(doc.data()))
          .toList();
      return bookings;
    } catch (e) {
      _logger.e('Error fetching car bookings: $e');
      rethrow;
    }
  }

  /// Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      _logger.i('Updating booking status: $bookingId -> $status');
      await _firestore
          .collection(bookingsCollection)
          .doc(bookingId)
          .update({'status': status});
      _logger.i('Booking status updated successfully');
    } catch (e) {
      _logger.e('Error updating booking status: $e');
      rethrow;
    }
  }

  /// Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      _logger.i('Cancelling booking: $bookingId');
      await updateBookingStatus(bookingId, 'cancelled');
      _logger.i('Booking cancelled successfully');
    } catch (e) {
      _logger.e('Error cancelling booking: $e');
      rethrow;
    }
  }

  // =====================================================
  // REVIEW OPERATIONS
  // =====================================================

  /// Add review for a car
  Future<String> addReview(ReviewModel review) async {
    try {
      _logger.i('Adding review for car: ${review.carId}');
      final docRef =
          await _firestore.collection(reviewsCollection).add(review.toJson());
      final reviewId = docRef.id;
      await docRef.update({'id': reviewId});
      _logger.i('Review added successfully');
      return reviewId;
    } catch (e) {
      _logger.e('Error adding review: $e');
      rethrow;
    }
  }

  /// Get car's reviews
  Future<List<ReviewModel>> getCarReviews(String carId) async {
    try {
      _logger.i('Fetching reviews for car: $carId');
      final querySnapshot = await _firestore
          .collection(reviewsCollection)
          .where('carId', isEqualTo: carId)
          .orderBy('createdAt', descending: true)
          .get();
      final reviews = querySnapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data()))
          .toList();
      return reviews;
    } catch (e) {
      _logger.e('Error fetching reviews: $e');
      rethrow;
    }
  }

  /// Delete review
  Future<void> deleteReview(String reviewId) async {
    try {
      _logger.i('Deleting review: $reviewId');
      await _firestore.collection(reviewsCollection).doc(reviewId).delete();
      _logger.i('Review deleted successfully');
    } catch (e) {
      _logger.e('Error deleting review: $e');
      rethrow;
    }
  }
}
