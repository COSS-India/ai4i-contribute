import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../config/branding_config.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.darkGreen,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkGreen),
        titleTextStyle: BrandingConfig.instance.getPrimaryTextStyle(
          color: AppColors.darkGreen,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: BrandingConfig.instance.getPrimaryTextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        bodyMedium: BrandingConfig.instance.getPrimaryTextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        titleLarge: BrandingConfig.instance.getPrimaryTextStyle(
          color: AppColors.darkGreen,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColors.darkGreen,
        secondary: AppColors.orange,
        surface: Colors.black,
        error: Colors.red,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppColors.darkGreen),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreen,
          foregroundColor: Colors.white,
          textStyle: BrandingConfig.instance.getPrimaryTextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkGreen,
          side: BorderSide(color: AppColors.darkGreen),
          textStyle: BrandingConfig.instance.getPrimaryTextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkGreen),
        ),
        labelStyle: BrandingConfig.instance.getPrimaryTextStyle(color: AppColors.darkGreen),
      ),
    );
  }
}
