import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

/// User Provider for managing user profile and related data
class UserProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize user from ID
  Future<void> initializeUser(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _user = await _firestoreService.getUserById(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile(UserModel updatedUser) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestoreService.updateUser(updatedUser);
      _user = updatedUser;
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

  /// Update user profile image
  Future<bool> updateProfileImage(String imageUrl) async {
    try {
      if (_user == null) return false;

      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedUser = _user!.copyWith(profileImageUrl: imageUrl);
      await _firestoreService.updateUser(updatedUser);
      _user = updatedUser;
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

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear user data on logout
  void clearUser() {
    _user = null;
    _error = null;
    notifyListeners();
  }
}
