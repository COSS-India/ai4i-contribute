class AppConstants {
  static const double defaultScreenWidth = 424;
  static const double defaultScreenHeight = 896;
  
  // App Name Limits
  static const int appNamePracticalLimit = 15;
  static const int appNameTechnicalLimit = 255;
  
  // URL Limits
  static const int urlPracticalLimit = 2000;
  static const int urlTechnicalLimit = 2083;
}

class Environment {
  static const String development = '.env.development';
  static const String staging = '.env.staging';
  static const String prod = '.env.production';
}

class RegExpressions {
  static RegExp alphabetsWithDot = RegExp(r"^[a-zA-Z\s.]+$");
  static RegExp appName = RegExp(r"^[a-zA-Z0-9\s_-]+$");
  static RegExp validUrl = RegExp(r"^https?:\/\/[^\s]+$");
  static RegExp validEmail = RegExp(
      r"[a-zA-Z0-9_-]+(?:\.[a-zA-Z0-9_-]+)*@((?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?){2,}\.){1,3}(?:\w){2,}");
}