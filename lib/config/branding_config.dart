import 'dart:convert';
import 'dart:io';
import 'package:VoiceGive/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

/// BrandingConfig manages app branding and theming
class BrandingConfig {
  static BrandingConfig? _instance;
  static BrandingConfig get instance {
    _instance ??= BrandingConfig._internal();
    return _instance!;
  }

  BrandingConfig._internal();

  late Map<String, dynamic> _config;

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


  /// Get app display name
  String get appDisplayName => _config['app']?['display_name'] ?? 'VoiceGive';

  /// Get primary brand color
  Color get primaryColor {
    final colorRgba = _config['branding']?['primary_color'] ?? '21, 125, 82, 1';
    if (colorRgba.isEmpty) {
      return const Color.fromRGBO(21, 125, 82, 1);
    }
    return _parseRgbaColor(colorRgba);
  }

  /// Get secondary brand color
  Color get secondaryColor {
    final colorRgba =
        _config['branding']?['secondary_color'] ?? '231, 97, 32, 1';
    if (colorRgba.isEmpty) {
      return const Color.fromRGBO(231, 97, 32, 1);
    }
    return _parseRgbaColor(colorRgba);
  }

  /// Get background brand color
  Color get bgColor {
    final colorRgba = _config['branding']?['bg_color'] ?? '240, 243, 244, 1';
    if (colorRgba.isEmpty) {
      return const Color.fromRGBO(240, 243, 244, 1);
    }
    return _parseRgbaColor(colorRgba);
  }

  /// Get text color
  Color get textColor {
    final colorRgba = _config['branding']?['text_color'] ?? '0,0,0,1';
    if (colorRgba.isEmpty) {
      return const Color.fromRGBO(0, 0, 0, 1);
    }
    return _parseRgbaColor(colorRgba);
  }

  /// Get banner color
  Color get bannerColor {
    final colorRgba = _config['branding']?['banner_color'] ?? '231, 97, 32, 1';
    if (colorRgba.isEmpty) {
      return const Color.fromRGBO(231, 97, 32, 1);
    }
    return _parseRgbaColor(colorRgba);
  }

  /// Parse RGBA color string to Color object
  Color _parseRgbaColor(String rgbaString) {
    final parts = rgbaString.split(',');
    if (parts.length == 4) {
      final r = int.tryParse(parts[0].trim()) ?? 0;
      final g = int.tryParse(parts[1].trim()) ?? 0;
      final b = int.tryParse(parts[2].trim()) ?? 0;
      final a = double.tryParse(parts[3].trim()) ?? 1.0;
      return Color.fromRGBO(r, g, b, a);
    }
    return const Color.fromRGBO(33, 150, 243, 1.0); // Default blue
  }

  /// Get app icon path
  String get appIcon =>
      _config['branding']?['app_icon'] ?? 'assets/launcher/bhashadaan.png';

  /// Get splash logo path
  String get splashLogo => _config['branding']?['splash_logo'] ?? '';

  /// Get splash animation path
  String get splashAnimation =>
      _config['branding']?['splash_animation'] ??
      'assets/animations/bhashadaan_splash_screen.json';

  /// Get header image path
  String get headerPrimaryImage =>
      _config['branding']?['header_primary_image'] ?? '';

  String get headerSecondaryImage =>
      _config['branding']?['header_secondary_image'] ?? '';

  String get headerTertiaryImage =>
      _config['branding']?['header_tertiary_image'] ?? '';

  String get bannerImage => _config['branding']?['banner_image'] ?? '';

  String get homeScreenBodyImage =>
      _config['branding']?['home_screen_body_image'] ?? '';
      
  String get homeScreenFooterImage =>
      _config['branding']?['home_screen_footer_image'] ?? '';
      
  String get homeScreenFooterUrl =>
      _config['branding']?['home_screen_footer_url'] ?? '';

  /// Get consent document URLs
  String get termsOfUseUrl => _config['branding']?['terms_of_use_url'] ?? '';
  String get privacyPolicyUrl => _config['branding']?['privacy_policy_url'] ?? '';
  String get copyrightPolicyUrl => _config['branding']?['copyright_policy_url'] ?? '';

  /// Default configuration fallback
  static Map<String, dynamic> _getDefaultConfig() {
    return {
      'app': {
        'name': 'VoiceGive',
        'display_name': 'VoiceGive',
        'package_id': 'com.voicegive.app',
      },
      'branding': {
        'primary_color': '33,150,243,1',
        'secondary_color': '255,193,7,1',
        'bg_color': '255,87,34,1',
        'text_color': '33,33,33,1',
        'banner_color': '33,150,243,1',
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
