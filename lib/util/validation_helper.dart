import '../constants/app_constants.dart';

class ValidationHelper {
  static String? validateAppName(String? value) {
    if (value == null || value.isEmpty) return 'App name is required';
    if (value.length > AppConstants.appNameTechnicalLimit) {
      return 'App name must be less than ${AppConstants.appNameTechnicalLimit} characters';
    }
    if (!RegExpressions.appName.hasMatch(value)) {
      return 'App name can only contain letters, numbers, spaces, hyphens, and underscores';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) return 'URL is required';
    if (value.length > AppConstants.urlTechnicalLimit) {
      return 'URL must be less than ${AppConstants.urlTechnicalLimit} characters';
    }
    if (!RegExpressions.validUrl.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }
}