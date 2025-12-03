import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

  /// Get app icon path
  String get appIcon =>
      _config['app']?['app_icon'] ?? 'assets/launcher/ai4i_logo.png';

  /// Get primary brand color
  Color get primaryColor {
    final colorRgba = _config['branding']?['primary_color'];
    if (colorRgba == null || colorRgba.toString().trim().isEmpty) {
      return const Color.fromRGBO(21, 125, 82, 1);
    }
    return _parseRgbaColor(colorRgba.toString());
  }

  /// Get secondary brand color
  Color get secondaryColor {
    final colorRgba = _config['branding']?['secondary_color'];
    if (colorRgba == null || colorRgba.toString().trim().isEmpty) {
      return const Color.fromRGBO(231, 97, 32, 1);
    }
    return _parseRgbaColor(colorRgba.toString());
  }

  /// Get background brand color
  Color get bgColor {
    final colorRgba = _config['branding']?['bg_color'] ?? '255, 255, 255, 1';
    if (colorRgba.isEmpty) {
      return const Color.fromRGBO(255, 255, 255, 1);
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
    final bannerColorRgba = _config['branding']?['banner_color'] ?? '';
    if (bannerColorRgba.isNotEmpty) {
      return _parseRgbaColor(bannerColorRgba);
    }
    // Fallback to secondary color
    return secondaryColor;
  }

  Color get toastColor {
    final colorRgba = _config['branding']?['toast_color'] ?? '27, 76, 161, 1';
    if (colorRgba.isEmpty) {
      return const Color.fromRGBO(27, 76, 161, 1);
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

  /// Get splash logo path
  String get splashLogo => _config['branding']?['splash_logo'] ?? '';

  /// Get splash name
  String get splashName => _config['branding']?['splash_name'] ?? 'Contribute';

  /// Get splash animation path
  String get splashAnimation => _config['branding']?['splash_animation'] ?? '';

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
  String get privacyPolicyUrl =>
      _config['branding']?['privacy_policy_url'] ?? '';
  String get copyrightPolicyUrl =>
      _config['branding']?['copyright_policy_url'] ?? '';

  /// Get badge image
  String get badgeImage => _config['branding']?['badge_image'] ?? '';

  String get certificateImage =>
      _config['branding']?['certificate_image'] ?? '';

  /// Get banner color string for checking if empty
  String get bannerColorString => _config['branding']?['banner_color'] ?? '';

  /// Get secondary color string for checking if empty
  String get secondaryColorString =>
      _config['branding']?['secondary_color'] ?? '';

  /// Get primary font path
  String get primaryFont => _config['branding']?['primary_font'] ?? '';

  /// Get secondary font path
  String get secondaryFont => _config['branding']?['secondary_font'] ?? '';

  /// Get tertiary font path
  String get tertiaryFont => _config['branding']?['tertiary_font'] ?? '';

  /// Module configuration getters
  bool get boloEnabled => _config['modules']?['bolo_enabled'] ?? true;
  bool get sunoEnabled => _config['modules']?['suno_enabled'] ?? true;
  bool get likhoEnabled => _config['modules']?['likho_enabled'] ?? true;
  bool get dekhoEnabled => _config['modules']?['dekho_enabled'] ?? true;

  /// Get primary text style - supports both TTF files and Google Fonts
  TextStyle getPrimaryTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    if (primaryFont.isNotEmpty) {
      if (primaryFont.contains('assets/')) {
        // TTF file path - use CustomPrimary font family
        return TextStyle(
          fontFamily: 'CustomPrimary',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
          decoration: decoration,
        );
      } else {
        // Google Font name
        try {
          return GoogleFonts.getFont(
            primaryFont,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            height: height,
            letterSpacing: letterSpacing,
            decoration: decoration,
          );
        } catch (e) {
          // Fallback if Google Font not found
        }
      }
    }
    return GoogleFonts.notoSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Get secondary text style - supports both TTF files and Google Fonts
  TextStyle getSecondaryTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    if (secondaryFont.isNotEmpty) {
      if (secondaryFont.contains('assets/')) {
        // TTF file path - use CustomSecondary font family
        return TextStyle(
          fontFamily: 'CustomSecondary',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      } else {
        // Google Font name
        try {
          return GoogleFonts.getFont(
            secondaryFont,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            height: height,
            letterSpacing: letterSpacing,
          );
        } catch (e) {
          // Fallback to primary font
        }
      }
    }
    return getPrimaryTextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Get tertiary text style with custom or Google font
  TextStyle getTertiaryTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    if (tertiaryFont.isNotEmpty) {
      try {
        return TextStyle(
          fontFamily: 'CustomTertiary',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
          decoration: decoration,
        );
      } catch (e) {
        // Fall back to primary font
      }
    }
    return getPrimaryTextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
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
        'primary_color': '21, 125, 82, 1',
        'secondary_color': '231, 97, 32, 1',
        'bg_color': '255,255,255,1',
        'text_color': '0,0,0,1',
        'app_icon': 'assets/launcher/ai4i_logo.png',
        'splash_logo': 'assets/images/bolo_logo.png',
        'organization_name': 'COSS India',
      },
      'modules': {
        'bolo_enabled': true,
        'suno_enabled': true,
        'likho_enabled': true,
        'dekho_enabled': true,
      },
      'environments': {
        'development': {'app_name_suffix': ' Dev', 'debug_mode': true},
        'staging': {'app_name_suffix': ' Staging', 'debug_mode': true},
        'production': {'app_name_suffix': '', 'debug_mode': false},
      }
    };
  }
}
