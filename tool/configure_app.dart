#!/usr/bin/env dart

import 'dart:io';
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
    developer.log(message, name: 'AI4I Contribute Config');
  } else {
    // In development, use print for visibility
    print(message);
  }
}

/// Build-time configuration script for AI4I Contribute
/// This script configures the app name and package ID based on branding.yaml and environment
void main(List<String> arguments) async {
  final environment = arguments.isNotEmpty ? arguments[0] : 'development';

  log('🔧 Configuring AI4I Contribute for environment: $environment');

  try {
    // Use default configuration
    final appName = 'Bhashadaan';
    final displayName = 'Bhashadaan';
    final packageId = 'org.ai4voice.ai4icontribute';

    // Get environment-specific suffix
    final suffix = environment == 'production'
        ? ''
        : environment == 'staging'
            ? ' Staging'
            : ' Dev';
    final finalDisplayName = displayName + suffix;

    log('📱 App Name: $appName');
    log('📱 Display Name: $finalDisplayName');
    log('📦 Package ID: $packageId');

    // Configure Android
    await configureAndroid(finalDisplayName, packageId, environment);

    // Configure iOS
    // await configureIOS(finalDisplayName, packageId);

    // Update app icon
    await updateAppIcon();

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
Future<void> updateAppIcon() async {
  log('🎨 Configuring app icon...');

  final finalIconPath = 'assets/launcher/bhashadaan.png';
  log('  ✓ Using default icon: $finalIconPath');

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
