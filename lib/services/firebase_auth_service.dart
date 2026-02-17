import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

/// Firebase Authentication Service
/// Handles user registration, login, logout, and authentication state management
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Get authentication state stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Register new user with email and password
  Future<UserCredential?> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _logger.i('Attempting to register user with email: $email');
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.i('User registered successfully: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _logger.e('Registration error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error during registration: $e');
      rethrow;
    }
  }

  /// Login user with email and password
  Future<UserCredential?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _logger.i('Attempting to login user with email: $email');
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.i('User logged in successfully: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _logger.e('Login error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error during login: $e');
      rethrow;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      _logger.i('Attempting to logout user');
      await _firebaseAuth.signOut();
      _logger.i('User logged out successfully');
    } catch (e) {
      _logger.e('Logout error: $e');
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      _logger.i('Sending password reset email to: $email');
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      _logger.i('Password reset email sent successfully');
    } on FirebaseAuthException catch (e) {
      _logger.e('Password reset error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error sending password reset email: $e');
      rethrow;
    }
  }

  /// Update user email
  Future<void> updateEmail(String newEmail) async {
    try {
      _logger.i('Attempting to update user email');
      await currentUser?.updateEmail(newEmail);
      _logger.i('Email updated successfully');
    } on FirebaseAuthException catch (e) {
      _logger.e('Email update error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error updating email: $e');
      rethrow;
    }
  }

  /// Update user password
  Future<void> updatePassword(String newPassword) async {
    try {
      _logger.i('Attempting to update user password');
      await currentUser?.updatePassword(newPassword);
      _logger.i('Password updated successfully');
    } on FirebaseAuthException catch (e) {
      _logger.e('Password update error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error updating password: $e');
      rethrow;
    }
  }

  /// Delete user account
  Future<void> deleteUser() async {
    try {
      _logger.i('Attempting to delete user account');
      await currentUser?.delete();
      _logger.i('User account deleted successfully');
    } on FirebaseAuthException catch (e) {
      _logger.e('Account deletion error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error deleting user account: $e');
      rethrow;
    }
  }

  /// Get user's ID token
  Future<String?> getUserToken() async {
    try {
      return await currentUser?.getIdToken();
    } catch (e) {
      _logger.e('Error getting user token: $e');
      rethrow;
    }
  }

  /// Check if user email is verified
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  /// Send email verification link
  Future<void> sendEmailVerification() async {
    try {
      _logger.i('Sending email verification');
      await currentUser?.sendEmailVerification();
      _logger.i('Email verification sent successfully');
    } on FirebaseAuthException catch (e) {
      _logger.e('Email verification error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error sending email verification: $e');
      rethrow;
    }
  }

  /// Reload user data
  Future<void> reloadUser() async {
    try {
      await currentUser?.reload();
    } catch (e) {
      _logger.e('Error reloading user: $e');
      rethrow;
    }
  }
}
