import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

/// Authentication Provider using Provider package
/// Manages user registration, login, logout and profile updates
class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  /// Initialize auth state listener
  AuthProvider() {
    _initAuthStateListener();
  }

  /// Initialize authentication state listener
  void _initAuthStateListener() {
    _authService.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser != null) {
        try {
          _currentUser = await _firestoreService.getUserById(firebaseUser.uid);
          _error = null;
        } catch (e) {
          _error = e.toString();
        }
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  /// Register new user with email and password
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Create user in Firebase Auth
      final userCredential = await _authService.registerWithEmail(
        email: email,
        password: password,
      );

      if (userCredential?.user != null) {
        // Create user document in Firestore
        final user = UserModel(
          id: userCredential!.user!.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
          isAdmin: false,
        );

        await _firestoreService.createUser(user);
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      throw Exception('Registration failed');
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login user with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _authService.loginWithEmail(
        email: email,
        password: password,
      );

      if (userCredential?.user != null) {
        _currentUser = await _firestoreService.getUserById(
          userCredential!.user!.uid,
        );
        _isLoading = false;
        notifyListeners();
        return true;
      }
      throw Exception('Login failed');
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout current user
  Future<bool> logout() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.logout();
      _currentUser = null;
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

  /// Update user profile
  Future<bool> updateProfile(UserModel updatedUser) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestoreService.updateUser(updatedUser);
      _currentUser = updatedUser;
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

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.sendPasswordResetEmail(email);
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
