import 'package:flutter/foundation.dart';
import '../models/auth/login_request.dart';
import '../models/auth/user.dart';
import '../services/auth_service.dart';
import '../services/token_storage_service.dart';
import '../services/auth_manager.dart';

/// Authentication state enum
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Authentication provider for managing login state
class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _token;
  String? _errorMessage;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get token => _token;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated && _user != null;
  bool get isLoading => _status == AuthStatus.loading;
  bool get hasError => _status == AuthStatus.error;

  /// Initialize authentication state from stored data
  Future<void> initialize() async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      final isLoggedIn = await TokenStorageService.isLoggedIn();
      if (isLoggedIn) {
        final storedToken = await TokenStorageService.getToken();
        if (storedToken != null) {
          _token = storedToken;
          _status = AuthStatus.authenticated;
          // Note: In a real app, you might want to fetch fresh user data here
          // For now, we'll mark as authenticated with token
        } else {
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Failed to initialize authentication: $e';
    } finally {
      notifyListeners();
    }
  }

  /// Login user with credentials
  Future<bool> login(LoginRequest request) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      // Validate request
      if (!AuthService.validateLoginRequest(request)) {
        _status = AuthStatus.error;
        _errorMessage = 'Invalid login credentials';
        notifyListeners();
        return false;
      }

      // Perform login
      final response = await AuthService.login(request);

      if (response.isSuccess) {
        _user = response.result.user;
        _token = response.result.token;
        _status = AuthStatus.authenticated;

        // Store token securely
        await TokenStorageService.storeToken(_token!);
        
        // Update AuthManager
        AuthManager.instance.setToken(_token!);

        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      // Extract clean error message from AuthException
      if (e is AuthException) {
        // AuthException format: "Status: 500 - Actual error message"
        final message = e.message;
        if (message.startsWith('Status: ')) {
          // Extract everything after "Status: XXX - "
          final parts = message.split(' - ');
          if (parts.length > 1) {
            _errorMessage = parts.sublist(1).join(' - ');
          } else {
            _errorMessage = message;
          }
        } else {
          _errorMessage = message;
        }
      } else {
        _errorMessage = e.toString();
      }
      notifyListeners();
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      // Clear stored data
      await TokenStorageService.clearAuthData();

      // Clear AuthManager
      AuthManager.instance.clearToken();

      // Reset state
      _user = null;
      _token = null;
      _errorMessage = null;
      _status = AuthStatus.unauthenticated;

      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Failed to logout: $e';
      notifyListeners();
    }
  }

  /// Clear error state
  void clearError() {
    if (_status == AuthStatus.error) {
      _errorMessage = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  /// Check if the error requires captcha refresh
  bool get shouldRefreshCaptcha {
    if (_errorMessage == null) return false;
    
    // Refresh captcha for any non-2xx status codes or specific error messages
    final captchaErrors = [
      'Please Enter Valid Captcha',
      'Invalid captcha',
      'Captcha expired',
      'Captcha not found',
    ];
    
    // Check for specific captcha error messages
    final hasCaptchaError = captchaErrors.any((error) => 
        _errorMessage!.toLowerCase().contains(error.toLowerCase()));
    
    // Check for HTTP error status codes (non-2xx)
    // Look for patterns like "Status: 400", "Status: 401", etc.
    final statusMatch = RegExp(r'Status: (\d+)').firstMatch(_errorMessage!);
    if (statusMatch != null) {
      final statusCode = int.tryParse(statusMatch.group(1) ?? '');
      if (statusCode != null && (statusCode < 200 || statusCode >= 300)) {
        return true; // Non-2xx status code
      }
    }
    
    return hasCaptchaError;
  }

  /// Refresh authentication state
  Future<void> refreshAuth() async {
    if (_status == AuthStatus.authenticated) {
      final needsRefresh = await TokenStorageService.needsTokenRefresh();
      if (needsRefresh) {
        // In a real app, you might want to refresh the token here
        // For now, we'll just reinitialize
        await initialize();
      }
    }
  }

  /// Update user data
  void updateUser(User updatedUser) {
    if (_status == AuthStatus.authenticated) {
      _user = updatedUser;
      notifyListeners();
    }
  }

  /// Get current token for API calls
  String? getCurrentToken() {
    return _status == AuthStatus.authenticated ? _token : null;
  }

  /// Check if user has specific role
  bool hasRole(String roleName) {
    return _user?.roleName == roleName;
  }

  /// Check if user has complete profile
  bool get hasCompleteProfile {
    return _user?.hasCompleteProfile ?? false;
  }
}
