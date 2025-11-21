
# AI4I-Contribute Flutter Application - Setup & Authentication Guide

This document provides a unified guide for setting up your environment, configuring authentication, and following best practices for the VoiceGive Flutter application.

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
- flutter pub run build_runner build --delete-conflicting-outputs
- flutter run

## 2. API Specification Document

Ref Backend installation guide : https://github.com/COSS-India/VoiceGive/blob/master/backend/README.md

API Contracts : https://github.com/COSS-India/VoiceGive/blob/master/contracts/voicegive_backend_api_contracts.yaml

Swagger UI : http://43.205.235.156:9000/docs

## Code Structure

### Key Directories

```
VoiceGive/
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
├── assets/                 # Images, icons, animations
├── build_scripts/          # Build automation scripts
├── documentation/          # Project documentation
└── test/                   # Test files
```
