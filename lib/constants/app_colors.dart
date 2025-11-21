import 'package:flutter/material.dart';
import '../config/branding_config.dart';

class AppColors {
  // Branding colors
  static Color get darkBlue => BrandingConfig.instance.toastColor;
  static Color get lightBackground => BrandingConfig.instance.bgColor;
  static Color get backgroundColor => BrandingConfig.instance.bgColor;
  static Color get appBarBackground => BrandingConfig.instance.bgColor;
  static Color get orange => BrandingConfig.instance.secondaryColor;
  static Color get darkGreen => BrandingConfig.instance.primaryColor;
  static Color get green => Color(0xFF27C854);
  static Color get lightGreen =>
      BrandingConfig.instance.primaryColor.withOpacity(0.3);
  static Color get lightGreen2 =>
      BrandingConfig.instance.primaryColor.withOpacity(0.1);
  static Color get lightGreen3 =>
      BrandingConfig.instance.primaryColor.withOpacity(0.05);
  static Color get lightGreen4 =>
      BrandingConfig.instance.primaryColor.withOpacity(0.15);
  static Color get bannerColor {
    final branding = BrandingConfig.instance;
    if (branding.bannerColor != const Color.fromRGBO(33, 150, 243, 1.0)) {
      return branding.bannerColor;
    }
    return branding.secondaryColor;
  }

  // Theme-aware greys
  static Color _themeColor(double opacity) {
    final textColor = BrandingConfig.instance.textColor;
    return textColor.withOpacity(opacity);
  }

  static Color _inverseThemeColor(double opacity) {
    final textColor = BrandingConfig.instance.textColor;
    final isLight = textColor.computeLuminance() < 0.5;
    return isLight
        ? Colors.white.withOpacity(opacity)
        : Colors.black.withOpacity(opacity);
  }

  static Color get grey => _themeColor(0.62);
  static Color get greys => BrandingConfig.instance.textColor;
  static Color get greys87 => _themeColor(0.87);
  static Color get greys60 => _themeColor(0.6);
  static Color get grey40 => _themeColor(0.4);
  static Color get grey16 => _themeColor(0.16);
  static Color get grey08 => _themeColor(0.08);
  static Color get grey04 => _themeColor(0.04);
  static Color get grey24 => _themeColor(0.24);
  static Color get grey84 => _themeColor(0.84);
  static Color get lightGrey => _inverseThemeColor(0.96);
  static Color get darkGrey => _inverseThemeColor(0.85);
  static Color get lightGrey2 => _inverseThemeColor(0.97);
  static Color get slateText => _themeColor(0.75);

  // Fixed colors
  static const whiteGradientOne = Color.fromRGBO(239, 243, 249, 1);
  static const disabledTextGrey = Color.fromRGBO(102, 102, 102, 1);
  static const disabledTextGrey0 = Color.fromRGBO(102, 102, 102, 0);
  static const saffron = Color.fromRGBO(255, 153, 51, 1);
  static const blue1 = Color.fromRGBO(173, 189, 235, 1);
  static const blue2 = Color.fromRGBO(250, 251, 255, 1);
  static const positiveLight = Color.fromRGBO(29, 137, 35, 1);
  static const negativeLight = Color.fromRGBO(209, 57, 36, 1);
}
