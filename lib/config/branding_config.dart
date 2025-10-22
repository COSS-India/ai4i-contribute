import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

/// BrandingConfig manages app branding and theming
/// This allows easy customization for different organizations
class BrandingConfig {
  static BrandingConfig? _instance;
  static BrandingConfig get instance {
    _instance ??= BrandingConfig._internal();
    return _instance!;
  }

  BrandingConfig._internal();

  late Map<String, dynamic> _config;

  /// Initialize branding configuration
  static Future<void> initialize() async {
    try {
      final yamlString = await rootBundle.loadString('branding.yaml');
      final yamlMap = loadYaml(yamlString);
      instance._config = Map<String, dynamic>.from(yamlMap);
    } catch (e) {
      // Fallback to default configuration if branding.yaml is not found
      instance._config = _getDefaultConfig();
    }
  }

  /// Get app name
  String get appName => _config['app']?['name'] ?? 'VoiceGive';

  /// Get app display name
  String get appDisplayName => _config['app']?['display_name'] ?? 'VoiceGive';

  /// Get package ID
  String get packageId => _config['app']?['package_id'] ?? 'com.voicegive.app';

  /// Get primary brand color
  Color get primaryColor {
    final colorHex = _config['branding']?['primary_color'] ?? '#2196F3';
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  /// Get secondary brand color
  Color get secondaryColor {
    final colorHex = _config['branding']?['secondary_color'] ?? '#FFC107';
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  /// Get accent brand color
  Color get accentColor {
    final colorHex = _config['branding']?['accent_color'] ?? '#FF5722';
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  /// Get app icon path
  String get appIcon => _config['branding']?['app_icon'] ?? 'assets/launcher/bhashadaan.png';

  /// Get splash logo path
  String get splashLogo => _config['branding']?['splash_logo'] ?? 'assets/images/bolo_logo.png';

  /// Get splash animation path
  String get splashAnimation => _config['branding']?['splash_animation'] ?? 'assets/animations/bhashadaan_splash_screen.json';

  /// Get organization name
  String get organizationName => _config['branding']?['organization_name'] ?? 'COSS India';

  /// Get organization logo path
  String get organizationLogo => _config['branding']?['organization_logo'] ?? 'assets/images/bhashini_logo.svg';

  /// Get partner logos
  List<String> get partnerLogos {
    final logos = _config['branding']?['partner_logos'];
    if (logos is List) {
      return List<String>.from(logos);
    }
    return [
      'assets/images/digital_india_logo.png',
      'assets/images/meity_logo.png',
      'assets/images/mygov_logo.png',
    ];
  }

  /// Get environment-specific app name suffix
  String getAppNameSuffix(String environment) {
    return _config['environments']?[environment]?['app_name_suffix'] ?? '';
  }

  /// Check if debug mode is enabled for environment
  bool isDebugMode(String environment) {
    return _config['environments']?[environment]?['debug_mode'] ?? false;
  }

  /// Get complete app name with environment suffix
  String getEnvironmentAppName(String environment) {
    return appDisplayName + getAppNameSuffix(environment);
  }

  /// Default configuration fallback
  static Map<String, dynamic> _getDefaultConfig() {
    return {
      'app': {
        'name': 'VoiceGive',
        'display_name': 'VoiceGive',
        'package_id': 'com.voicegive.app',
      },
      'branding': {
        'primary_color': '#2196F3',
        'secondary_color': '#FFC107',
        'accent_color': '#FF5722',
        'app_icon': 'assets/launcher/bhashadaan.png',
        'splash_logo': 'assets/images/bolo_logo.png',
        'organization_name': 'COSS India',
      },
      'environments': {
        'development': {'app_name_suffix': ' Dev', 'debug_mode': true},
        'staging': {'app_name_suffix': ' Staging', 'debug_mode': true},
        'production': {'app_name_suffix': '', 'debug_mode': false},
      }
    };
  }
}