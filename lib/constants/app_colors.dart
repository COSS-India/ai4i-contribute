import 'package:flutter/material.dart';
import '../config/branding_config.dart';

class AppColors {
  static Color get darkBlue => BrandingConfig.instance.toastColor;
  static const whiteGradientOne = Color.fromRGBO(239, 243, 249, 1);
  static const disabledTextGrey = Color.fromRGBO(102, 102, 102, 1);
  static const disabledTextGrey0 = Color.fromRGBO(102, 102, 102, 0);
  // static const lightBackground = Color.fromRGBO(240, 243, 244, 1);
  static Color get lightBackground => BrandingConfig.instance.bgColor;

  static const appBarBackground = Color.fromRGBO(255, 255, 255, 1);
  static const saffron = Color.fromRGBO(255, 153, 51, 1);
  static const blue1 = Color.fromRGBO(173, 189, 235, 1);
  static const blue2 = Color.fromRGBO(250, 251, 255, 1);
  // static const orange = Color.fromRGBO(231, 97, 32, 1);
  static Color get orange => BrandingConfig.instance.secondaryColor;
  static Color get darkGreen => BrandingConfig.instance.primaryColor;
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
    // First try banner_color from branding
    if (branding.bannerColor != const Color.fromRGBO(33, 150, 243, 1.0)) {
      return branding.bannerColor;
    }
    // Then try secondary_color from branding
    return branding.secondaryColor;
  }

  // Greys
  static const grey = Color.fromRGBO(158, 158, 158, 1);
  static const greys = Color.fromRGBO(0, 0, 0, 1);
  static const greys87 = Color.fromRGBO(0, 0, 0, 0.87);
  static const greys60 = Color.fromRGBO(0, 0, 0, 0.6);
  static const grey40 = Color.fromRGBO(0, 0, 0, 0.4);
  static const grey16 = Color.fromRGBO(0, 0, 0, 0.16);
  static const grey08 = Color.fromRGBO(0, 0, 0, 0.08);
  static const grey04 = Color.fromRGBO(0, 0, 0, 0.04);
  static const grey24 = Color.fromRGBO(0, 0, 0, 0.24);
  static const grey84 = Color.fromRGBO(84, 84, 84, 1);
  static const lightGrey = Color.fromRGBO(245, 245, 245, 1);
  static const darkGrey = Color.fromRGBO(216, 216, 216, 1);
  static const lightGrey2 = Color.fromRGBO(247, 248, 249, 1);
  // Text neutrals
  static const slateText = Color.fromRGBO(120, 131, 149, 1);

  static const positiveLight = Color.fromRGBO(29, 137, 35, 1);
  static const negativeLight = Color.fromRGBO(209, 57, 36, 1);
}
