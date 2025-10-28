#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:yaml/yaml.dart';

/// Validation constants
class ValidationConstants {
  static const int appNameTechnicalLimit = 255;
  static const int urlTechnicalLimit = 2083;
  static final RegExp appNamePattern = RegExp(r'^[a-zA-Z0-9\s_-]+$');
  static final RegExp urlPattern = RegExp(r'^https?:\/\/[^\s]+$');
}

/// Logger for build-time configuration
void log(String message) {
  if (bool.fromEnvironment('dart.vm.product')) {
    // In production, use developer.log
    developer.log(message, name: 'VoiceGive Config');
  } else {
    // In development, use print for visibility
    print(message);
  }
}

/// Build-time configuration script for VoiceGive
/// This script configures the app name and package ID based on branding.yaml and environment
void main(List<String> arguments) async {
  final environment = arguments.isNotEmpty ? arguments[0] : 'development';

  log('🔧 Configuring VoiceGive for environment: $environment');

  try {
    // Load branding configuration
    final brandingFile = File('branding.yaml');
    if (!brandingFile.existsSync()) {
      log('❌ branding.yaml not found. Please create it first.');
      exit(1);
    }

    final yamlString = await brandingFile.readAsString();
    final yamlData = loadYaml(yamlString);
    final config = Map<String, dynamic>.from(yamlData);

    // Get app configuration
    final app = Map<String, dynamic>.from(config['app'] ?? {});
    final appName = app['name'] ?? 'Contribute';
    final rawDisplayName = app['display_name'] ?? '';
    final displayName = rawDisplayName.toString().trim().isEmpty
        ? 'Contribute'
        : rawDisplayName;
    final packageId = app['package_id'] ?? 'com.voicegive.app';

    // Validate app configuration
    validateAppConfiguration(displayName, config);

    // Get environment-specific suffix
    final environments =
        Map<String, dynamic>.from(config['environments'] ?? {});
    final envConfig =
        Map<String, dynamic>.from(environments[environment] ?? {});
    final suffix = envConfig['app_name_suffix'] ?? '';
    final finalDisplayName = displayName + suffix;

    log('📱 App Name: $appName');
    log('📱 Display Name: $finalDisplayName');
    log('📦 Package ID: $packageId');

    // Configure Android
    await configureAndroid(finalDisplayName, packageId, environment);

    // Configure iOS
    // await configureIOS(finalDisplayName, packageId);

    // Update app icon
    await updateAppIcon(config);

    // Update environment file
    // await updateEnvironmentFile(environment, appName, finalDisplayName, packageId);

    log('✅ Configuration completed successfully!');
  } catch (e) {
    log('❌ Error configuring app: $e');
    exit(1);
  }
}

/// Configure Android manifest and build files
Future<void> configureAndroid(
    String displayName, String packageId, String environment) async {
  log('🤖 Configuring Android...');

  // Update AndroidManifest.xml
  final manifestFile = File('android/app/src/main/AndroidManifest.xml');
  if (manifestFile.existsSync()) {
    String content = await manifestFile.readAsString();

    // Replace app label
    content = content.replaceAll(
        RegExp(r'android:label="[^"]*"'), 'android:label="$displayName"');

    await manifestFile.writeAsString(content);
    log('  ✓ Updated AndroidManifest.xml');
  }

  // Update app-level build.gradle for package ID
  final buildGradleFile = File('android/app/build.gradle');
  if (buildGradleFile.existsSync()) {
    String content = await buildGradleFile.readAsString();

    // Update applicationId if it exists, otherwise add it
    if (content.contains('applicationId')) {
      content = content.replaceAll(
          RegExp(r'applicationId\\s+"[^"]*"'), 'applicationId "$packageId"');
    } else {
      // Add applicationId after defaultConfig
      content = content.replaceAll('defaultConfig {',
          'defaultConfig {\n        applicationId "$packageId"');
    }

    await buildGradleFile.writeAsString(content);
    log('  ✓ Updated build.gradle');
  }
}

/// Configure iOS Info.plist
// Future<void> configureIOS(String displayName, String packageId) async {
//   log('🍎 Configuring iOS...');

//   final infoPlistFile = File('ios/Runner/Info.plist');
//   if (infoPlistFile.existsSync()) {
//     String content = await infoPlistFile.readAsString();

//     // Update CFBundleDisplayName
//     content = content.replaceAll(
//       RegExp(r'<key>CFBundleDisplayName</key>\\s*<string>[^<]*</string>'),
//       '<key>CFBundleDisplayName</key>\n\t<string>$displayName</string>'
//     );

//     // Update CFBundleName
//     content = content.replaceAll(
//       RegExp(r'<key>CFBundleName</key>\\s*<string>[^<]*</string>'),
//       '<key>CFBundleName</key>\n\t<string>$displayName</string>'
//     );

//     await infoPlistFile.writeAsString(content);
//     log('  ✓ Updated Info.plist');
//   }
// }

/// Update app icon configuration
Future<void> updateAppIcon(Map<String, dynamic> config) async {
  log('🎨 Configuring app icon...');

  final branding = Map<String, dynamic>.from(config['app'] ?? {});
  final iconPath = branding['app_icon'] ?? 'assets/launcher/ai4i_logo.png';
  final iconFile = File(iconPath);

  String finalIconPath;
  if (iconFile.existsSync()) {
    finalIconPath = iconPath;
    log('  ✓ Using custom icon: $iconPath');
  } else {
    finalIconPath = 'assets/launcher/ai4i_logo.png';
    log('  ⚠️  Custom icon not found, using default: $finalIconPath');
  }

  // Update pubspec.yaml flutter_icons section
  final pubspecFile = File('pubspec.yaml');
  if (pubspecFile.existsSync()) {
    String content = await pubspecFile.readAsString();

    // Update both Android and iOS icon paths
    content = content.replaceAll(RegExp(r'image_path_android: "[^"]*"'),
        'image_path_android: "$finalIconPath"');
    content = content.replaceAll(
        RegExp(r'image_path_ios: "[^"]*"'), 'image_path_ios: "$finalIconPath"');

    await pubspecFile.writeAsString(content);
    log('  ✓ Updated pubspec.yaml icon paths');
  }
}

/// Update environment file with current configuration
// Future<void> updateEnvironmentFile(String environment, String appName, String displayName, String packageId) async {
//   log('🔧 Updating environment file...');

//   final envFile = File('.env.$environment');
//   if (envFile.existsSync()) {
//     String content = await envFile.readAsString();

//     // Update or add app configuration
//     content = _updateOrAddEnvVar(content, 'APP_NAME', appName);
//     content = _updateOrAddEnvVar(content, 'APP_DISPLAY_NAME', displayName);
//     content = _updateOrAddEnvVar(content, 'PACKAGE_ID', packageId);

//     await envFile.writeAsString(content);
//     log('  ✓ Updated .env.$environment');
//   }
// }

// /// Helper function to update or add environment variable
// String _updateOrAddEnvVar(String content, String key, String value) {
//   final regex = RegExp('^$key=.*\$', multiLine: true);
//   final newLine = '$key=$value';

//   if (content.contains(regex)) {
//     return content.replaceAll(regex, newLine);
//   } else {
//     return content + '\n$newLine';
//   }
// }

/// Validate app configuration values
void validateAppConfiguration(String displayName, Map<String, dynamic> config) {
  log('🔍 Validating configuration...');

  // Validate app name
  if (displayName.length > ValidationConstants.appNameTechnicalLimit) {
    log('❌ App name "$displayName" exceeds ${ValidationConstants.appNameTechnicalLimit} characters');
    exit(1);
  }

  if (!ValidationConstants.appNamePattern.hasMatch(displayName)) {
    log('❌ App name "$displayName" contains invalid characters. Only letters, numbers, spaces, hyphens, and underscores are allowed.');
    exit(1);
  }

  // Validate URLs in branding section
  final branding = Map<String, dynamic>.from(config['branding'] ?? {});
  final urlFields = [
    'home_screen_footer_url',
    'terms_of_use_url',
    'privacy_policy_url',
    'copyright_policy_url'
  ];

  for (final field in urlFields) {
    final url = branding[field]?.toString() ?? '';
    if (url.isNotEmpty) {
      if (url.length > ValidationConstants.urlTechnicalLimit) {
        log('❌ URL in $field exceeds ${ValidationConstants.urlTechnicalLimit} characters');
        exit(1);
      }

      if (!ValidationConstants.urlPattern.hasMatch(url)) {
        log('❌ Invalid URL format in $field: "$url"');
        exit(1);
      }
    }
  }

  log('✅ Configuration validation passed');
}
