# AI4I Contribute Project Setup Guide

## Project Overview

AI4I Contribute is a Flutter-based UI application designed for language data collection and crowdsourcing initiatives. This project provides a complete, customizable user interface that can be adopted by organizations, government agencies, and developers to build their own language data collection applications with features like voice recording, text validation, and multi-language support.

The UI is built on a Swagger API specification, making it adaptable for different implementations. Adopters can:

- **Reference the API Documentation**: Use the provided Swagger specification to understand the complete API structure and endpoints
- **Build Custom APIs**: Implement their own backend services based on the API specification
- **Integrate with Existing UI**: Use this Flutter UI as a ready-made frontend that works with the API specification
- **Customize for Different Use Cases**: Adapt the UI components and API integration to meet specific organizational needs

## Prerequisites

Before setting up the AI4I Contribute project, ensure you have the following software and tools installed:

### Required Software
- **Flutter 3.27.1 • channel [user-branch] • unknown source
- **Framework • revision 17025dd882 (10 months ago) • 2024-12-17 03:23:09 +0900
- **Engine • revision cb4b5fff73
- **Tools • Dart 3.6.0 • DevTools 2.40.2

## System Requirements

### Minimum Hardware Requirements
- **RAM**: 8GB (16GB recommended)
- **Storage**: 10GB free space
- **Processor**: 64-bit processor
- **Display**: 1280x800 resolution

### Supported Operating Systems
- **Windows**: Windows 10 version 1903 or higher (64-bit)
- **macOS**: macOS 10.14 (Mojave) or higher
- **Linux**: Ubuntu 18.04 LTS or higher (64-bit)

## Installation Steps

### 1. Install Flutter SDK

#### Windows
1. Download the Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. Extract the zip file to `C:\flutter`
3. Add `C:\flutter\bin` to your system PATH
4. Verify installation by running `flutter doctor` in Command Prompt

#### macOS
1. Download the Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/macos)
2. Extract the zip file to your desired location (e.g., `/Users/username/flutter`)
3. Add Flutter to your PATH by editing `~/.zshrc` or `~/.bash_profile`:
   ```bash
   export PATH="$PATH:/Users/username/flutter/bin"
   ```
4. Run `source ~/.zshrc` or `source ~/.bash_profile`
5. Verify installation by running `flutter doctor`

#### Linux
1. Download the Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/linux)
2. Extract the tar file to your desired location (e.g., `/home/username/flutter`)
3. Add Flutter to your PATH by editing `~/.bashrc`:
   ```bash
   export PATH="$PATH:/home/username/flutter/bin"
   ```
4. Run `source ~/.bashrc`
5. Verify installation by running `flutter doctor`

### 2. Install Android Studio

1. Download Android Studio from [developer.android.com](https://developer.android.com/studio)
2. Follow the installation wizard
3. During setup, ensure you install:
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device
   - Android SDK Build-Tools

### 3. Configure Android SDK

1. Open Android Studio
2. Go to **File > Settings** (Windows/Linux) or **Android Studio > Preferences** (macOS)
3. Navigate to **Appearance & Behavior > System Settings > Android SDK**
4. Install the following:
   - **Android 13 (API level 33)** or higher
   - **Android SDK Build-Tools** (latest version)
   - **Android SDK Platform-Tools**
   - **Android SDK Tools**

## Repository Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd ai4i-contribute
```

### 2. Verify Flutter Installation

```bash
flutter doctor
```

Ensure all checks pass, especially:
- ✅ Flutter (Channel stable, Flutter 3.27.1)
- ✅ Android toolchain - develop for Android devices
- ✅ Android Studio (version 2022.1 or higher)
- ✅ VS Code (optional but recommended)

### 3. Check Flutter Version

```bash
flutter --version
```

Expected output should show Flutter 3.6.0 or higher.

## Environment Configuration

### 1. Create Environment Files

The project supports multiple environments. Create the following files in the root directory:

#### For Development
```bash
# Create .env.development file
touch .env.development
```

Add the following content to `.env.development`:
```env
# API Configuration
API_BASE_URL=https://example.com
```

#### For Staging
```bash
# Create .env.staging file
touch .env.staging
```

Add the following content to `.env.staging`:
```env
# API Configuration
API_BASE_URL=https://staging.example.com
```

#### For Production
```bash
# Create .env.production file
touch .env.production
```

Add the following content to `.env.production`:
```env
# API Configuration
API_BASE_URL=https://production.example.com
```

### 2. Verify Environment Configuration

Check that your environment files are properly configured by examining the app configuration:

```bash
# Check if environment files exist
ls -la | grep .env
```

Expected output should show:
- `.env.development`
- `.env.staging` 
- `.env.production`

### 3. Environment Variable Requirements

Ensure each environment file contains the following required variables that match `lib/config/app_config.dart`:

- `API_BASE_URL` - The base URL for API endpoints

**Note**: Replace the placeholder bearer tokens with actual values for each environment.

## Dependencies Installation

### 1. Install Flutter Dependencies

```bash
flutter pub get
```

### 2. Verify Dependencies

```bash
flutter pub deps
```

### 3. Check for Dependency Issues

```bash
flutter pub outdated
```

### 4. Clean and Rebuild (if needed)

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Android Setup

### 1. Configure Android SDK

Ensure your Android SDK is properly configured:

```bash
flutter doctor --android-licenses
```

Accept all licenses when prompted.

### 2. Set Up Android Emulator

#### Option A: Using Android Studio
1. Open Android Studio
2. Go to **Tools > AVD Manager**
3. Click **Create Virtual Device**
4. Choose a device (e.g., Pixel 6)
5. Select **API Level 33** or higher
6. Click **Finish**

#### Option B: Using Command Line
```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_id>
```

### 3. Connect Physical Device (Alternative)

1. Enable **Developer Options** on your Android device
2. Enable **USB Debugging**
3. Connect device via USB
4. Verify connection:
   ```bash
   flutter devices
   ```

### 4. Verify Android Configuration

```bash
flutter doctor -v
```

Ensure Android toolchain shows:
- ✅ Android SDK at [your-sdk-path]
- ✅ Android NDK location not configured
- ✅ Platform android-33, build-tools 33.0.0
- ✅ Java binary at [java-path]

## Running the Application

### 1. Development Mode

```bash
# Run on connected device/emulator
flutter run

# Run in debug mode with verbose output
flutter run --verbose

# Run on specific device
flutter run -d <device_id>
```

### 2. Release Mode

```bash
# Build release APK
flutter build apk --release

# Build release app bundle
flutter build appbundle --release
```

### 3. Using Build Scripts

The project includes build scripts for different environments:

```bash
# Make build script executable
chmod +x build_scripts/build.sh

# Run build script
./build_scripts/build.sh
```

## Troubleshooting

### Common Issues and Solutions

#### 1. Flutter Doctor Issues

**Issue**: Android toolchain not found
```bash
# Solution: Install Android SDK
flutter doctor --android-licenses
```

**Issue**: Flutter version mismatch
```bash
# Solution: Update Flutter
flutter upgrade
```

#### 2. Build Issues

**Issue**: Gradle build failed
```bash
# Solution: Clean and rebuild
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

**Issue**: Android SDK not found
```bash
# Solution: Set ANDROID_HOME
export ANDROID_HOME=/path/to/android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

#### 3. Dependency Issues

**Issue**: Package not found
```bash
# Solution: Update dependencies
flutter pub get
flutter pub upgrade
```

**Issue**: Version conflict
```bash
# Solution: Check pubspec.yaml and resolve conflicts
flutter pub deps
```

#### 4. Emulator Issues

**Issue**: Emulator not starting
```bash
# Solution: Check emulator configuration
flutter emulators
flutter emulators --launch <emulator_id>
```

**Issue**: Device not recognized
```bash
# Solution: Check USB debugging and drivers
adb devices
```

#### 5. Audio Recording Issues

**Issue**: Microphone permission denied
- Check Android permissions in `android/app/src/main/AndroidManifest.xml`
- Ensure `RECORD_AUDIO` permission is granted

**Issue**: Audio quality issues
- Check audio configuration in environment files
- Verify device microphone functionality

### Debug Commands

```bash
# Check Flutter installation
flutter doctor -v

# List connected devices
flutter devices

# Check Flutter version
flutter --version

# Analyze project
flutter analyze

# Check for issues
flutter doctor --android-licenses
```

## Additional Resources

### Official Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Android Studio Documentation](https://developer.android.com/studio)

### Project-Specific Resources
- [README.md](../README.md) - Project overview and authentication details
- [API Documentation](api_doc.yaml) - API endpoint documentation
- [Build Scripts](../build_scripts/build.sh) - Environment-specific build scripts

### Community Resources
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter GitHub](https://github.com/flutter/flutter)

---

## Quick Start Checklist

- [ ] Flutter SDK installed and configured
- [ ] Android Studio installed with SDK
- [ ] Repository cloned successfully
- [ ] Environment files created
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Android emulator or device connected
- [ ] App runs successfully (`flutter run`)
- [ ] All features working as expected
