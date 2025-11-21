import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';
import 'branding_config.dart';

/// AppConfig class manages environment variables and API endpoints
/// following Flutter enterprise standards
class AppConfig {
  static AppConfig? _instance;
  static AppConfig get instance {
    _instance ??= AppConfig._internal();
    return _instance!;
  }

  AppConfig._internal();

  /// Initialize the configuration with environment variables
  static Future<void> initialize({String? environment}) async {
    String envFile =
        environment ?? Environment.development; // Default to development

    // Load the environment file
    await dotenv.load(fileName: envFile);

    // Initialize branding configuration
    await BrandingConfig.initialize();
  }

  /// API Base URL
  String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';

  /// Application Environment (development, staging, production)
  String get appEnvironment =>
      dotenv.env['APP_ENVIRONMENT'] ?? Environment.development;

  /// Get environment-specific API endpoints
  Map<String, String> get apiEndpoints => {
        'login': '$apiBaseUrl/login-user',
        'skip': '$apiBaseUrl/skip',
        'mediaText': '$apiBaseUrl/media/text',
        'validateAccept': '$apiBaseUrl/validate',
        'validateReject': '$apiBaseUrl/validate',
        'contributions': '$apiBaseUrl/contributions/text',
        'captcha': '$apiBaseUrl/get-secure-cap',
      };

  /// Get default headers for API requests
  Map<String, String> get defaultHeaders => {
        'accept': '*/*',
        'accept-language': 'en-US,en;q=0.9',
        'content-type': 'application/json',
        'Cookie': 'SERVERID=GEN3',
      };

  /// Get minimal headers for API requests (used for CORS-sensitive endpoints)
  Map<String, String> get minimalHeaders => {
        'accept': 'application/json',
        'user-agent':
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36',
      };

  /// Validate that all required environment variables are present
  bool validateConfig() {
    final requiredVars = ['API_BASE_URL'];

    for (final varName in requiredVars) {
      if (dotenv.env[varName] == null || dotenv.env[varName]!.isEmpty) {
        throw Exception('Required environment variable $varName is not set');
      }
    }

    return true;
  }

  /// Get a specific environment variable
  String? getEnv(String key) => dotenv.env[key];

  /// Get app display name from environment or branding config
  String get appDisplayName => BrandingConfig.instance.appDisplayName;
}
