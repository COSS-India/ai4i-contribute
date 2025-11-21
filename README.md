
# AI4I - Contribute Flutter Application - Setup & Authentication Guide

This document provides a unified guide for setting up your environment, configuring authentication, and following best practices for the AI4I - Contribute Flutter application.

---

## 1. Environment Setup

### Flutter Version
Flutter 3.27.1 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 17025dd882 (10 months ago) • 2024-12-17 03:23:09 +0900
Engine • revision cb4b5fff73
Tools • Dart 3.6.0 • DevTools 2.40.2


### Java Version
java 17.0.13 2024-10-15 LTS
Java(TM) SE Runtime Environment (build 17.0.13+10-LTS-268)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.13+10-LTS-268, mixed mode, sharing)


### Environment Files
- `.env.development` (development)
- `.env.staging` (staging)
- `.env.production` (production)


**Steps to run the app:**
- flutter clean
- flutter pub get
- dart run build_scripts/generate_fonts.dart
- flutter pub run build_runner build --delete-conflicting-outputs
- flutter run

**Production build:**
- ./build_scripts/build.sh production

## App Customization

For organizations wanting to customize the app with their own branding, see the [**Branding Guide**](BRANDING_GUIDE.md) for complete instructions on:
- App name and icon customization
- Color schemes and themes
- Images and animations
- Consent form configuration
- Build process

# API Specification Document

Ref Backend installation guide : https://github.com/COSS-India/ai4i-contribute/blob/release/v0.2/backend/README.md
Swagger UI : http://3.7.77.1:9000/docs

## Code Structure

### Key Directories

```
AI4I - Contribute/
├── android/                 # Android-specific configuration
├── ios/                     # iOS-specific configuration
├── lib/                     # Main Dart code
│   ├── common_widgets/      # Reusable UI components
│   ├── config/              # App configuration
│   ├── constants/           # App constants
│   ├── l10n/               # Localization files
│   ├── models/             # Data models
│   ├── providers/          # State management
│   ├── screens/            # App screens
│   ├── services/           # API and business logic
│   └── util/               # Utility functions
├── backend/                # Mock Backend
├── assets/                 # Images, icons, animations
├── build_scripts/          # Build automation scripts
├── documentation/          # Project documentation
└── test/                   # Test files
```
