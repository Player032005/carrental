import 'package:logger/logger.dart';

/// Validation Service
/// Handles form validation for registration, login, and other forms
class ValidationService {
  final Logger _logger = Logger();

  /// Validate email format
  bool isValidEmail(String email) {
    try {
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      return emailRegex.hasMatch(email);
    } catch (e) {
      _logger.e('Error validating email: $e');
      return false;
    }
  }

  /// Validate password strength
  /// Minimum 6 characters, at least one uppercase, one lowercase, one number
  bool isValidPassword(String password) {
    try {
      if (password.length < 6) return false;
      if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
      if (!RegExp(r'[a-z]').hasMatch(password)) return false;
      if (!RegExp(r'[0-9]').hasMatch(password)) return false;
      return true;
    } catch (e) {
      _logger.e('Error validating password: $e');
      return false;
    }
  }

  /// Validate phone number
  bool isValidPhoneNumber(String phoneNumber) {
    try {
      final phoneRegex = RegExp(r'^[+]?[(]?[0-9]{1,4}[)]?[-\s.]?[(]?[0-9]{1,4}[)]?[-\s.]?[0-9]{1,9}$');
      return phoneRegex.hasMatch(phoneNumber.replaceAll(RegExp(r'\s'), ''));
    } catch (e) {
      _logger.e('Error validating phone number: $e');
      return false;
    }
  }

  /// Validate full name
  bool isValidFullName(String fullName) {
    try {
      if (fullName.trim().isEmpty) return false;
      if (fullName.trim().length < 2) return false;
      // Should contain at least one space (first and last name)
      return fullName.trim().split(' ').length >= 2;
    } catch (e) {
      _logger.e('Error validating full name: $e');
      return false;
    }
  }

  /// Validate password confirmation
  bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  /// Get password strength message
  String getPasswordStrengthMessage(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    } else if (password.length < 6) {
      return 'Password must be at least 6 characters';
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain uppercase letter';
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain lowercase letter';
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain a number';
    }
    return 'Strong password';
  }

  /// Validate all registration fields
  Map<String, String> validateRegistrationForm({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) {
    final errors = <String, String>{};

    if (fullName.trim().isEmpty) {
      errors['fullName'] = 'Full name is required';
    } else if (!isValidFullName(fullName)) {
      errors['fullName'] = 'Please enter first and last name';
    }

    if (email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!isValidEmail(email)) {
      errors['email'] = 'Please enter a valid email';
    }

    if (phoneNumber.trim().isEmpty) {
      errors['phoneNumber'] = 'Phone number is required';
    } else if (!isValidPhoneNumber(phoneNumber)) {
      errors['phoneNumber'] = 'Please enter a valid phone number';
    }

    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (!isValidPassword(password)) {
      errors['password'] = getPasswordStrengthMessage(password);
    }

    if (confirmPassword.isEmpty) {
      errors['confirmPassword'] = 'Please confirm password';
    } else if (!doPasswordsMatch(password, confirmPassword)) {
      errors['confirmPassword'] = 'Passwords do not match';
    }

    return errors;
  }

  /// Validate login form
  Map<String, String> validateLoginForm({
    required String email,
    required String password,
  }) {
    final errors = <String, String>{};

    if (email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!isValidEmail(email)) {
      errors['email'] = 'Please enter a valid email';
    }

    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    }

    return errors;
  }
}
