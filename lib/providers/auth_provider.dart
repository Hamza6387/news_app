import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/hive_database_manager.dart';

// This provider manages the authentication state of the app
// It keeps track of whether a user is logged in and who they are

// State class to hold authentication information
class AuthState {
  final bool isLoggedIn;
  final User? user;
  final bool isLoading;

  const AuthState({
    required this.isLoggedIn,
    this.user,
    this.isLoading = false,
  });

  // Create a copy of the state with updated values
  AuthState copyWith({
    bool? isLoggedIn,
    User? user,
    bool? isLoading,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// The AuthNotifier manages authentication state changes
class AuthNotifier extends StateNotifier<AuthState> {
  final HiveDatabaseManager _databaseManager = HiveDatabaseManager.instance;

  AuthNotifier() : super(const AuthState(isLoggedIn: false)) {
    // Check if user is already logged in when app starts
    _checkLoginStatus();
  }

  // Check if user is logged in from storage
  Future<void> _checkLoginStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final isLoggedIn = _databaseManager.getLoginStatus();
      if (isLoggedIn) {
        final user = _databaseManager.getCurrentUser();
        state = AuthState(isLoggedIn: true, user: user, isLoading: false);
      } else {
        state = const AuthState(isLoggedIn: false, isLoading: false);
      }
    } catch (e) {
      state = const AuthState(isLoggedIn: false, isLoading: false);
    }
  }

  // Login user (simple validation since no backend)
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Simple validation - in a real app, you'd call an API
      if (email.isNotEmpty && password.length >= 6) {
        // Create user object
        final user = User(
          email: email,
          name: _getNameFromEmail(email),
        );
        
        // Save to storage
        await _databaseManager.saveUser(user);
        await _databaseManager.setLoginStatus(true);
        
        // Update state
        state = AuthState(isLoggedIn: true, user: user, isLoading: false);
        return true;
      } else {
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _databaseManager.removeCurrentUser();
      await _databaseManager.setLoginStatus(false);
      state = const AuthState(isLoggedIn: false, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  // Helper method to extract name from email
  String _getNameFromEmail(String email) {
    final username = email.split('@')[0];
    // Capitalize first letter
    return username.isNotEmpty 
        ? username[0].toUpperCase() + username.substring(1)
        : 'User';
  }
}

// Provider for authentication state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
}); 