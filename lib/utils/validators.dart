// This class contains validation functions for our forms
class Validators {
  // Validate email address format
  static String? validateEmail(String? email) {
    // Check if email is empty
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }

    // Basic email format validation
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'Please enter a valid email address';
    }

    return null; // Return null if validation passes
  }

  // Validate password
  static String? validatePassword(String? password) {
    // Check if password is empty
    if (password == null || password.trim().isEmpty) {
      return 'Password is required';
    }

    // Check minimum length
    if (password.trim().length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null; // Return null if validation passes
  }

  // Validate required fields (general purpose)
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Check if email format is valid (returns boolean)
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email.trim());
  }

  // Check if password is strong enough
  static bool isStrongPassword(String password) {
    // For this simple app, we just check length
    // In a real app, you might check for uppercase, lowercase, numbers, etc.
    return password.trim().length >= 6;
  }
} 