
# AI4I-Contribute Flutter Application - Setup & Authentication Guide

This document provides a unified guide for setting up your environment, configuring authentication, and following best practices for the VoiceGive Flutter application.

---

## 1. Environment Setup

### Environment Files
- `.env` (default/development)
- `.env.development` (development)
- `.env.staging` (staging)
- `.env.production` (production)
- `.env.example` (template)

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

### Key Files

- `pubspec.yaml` - Project dependencies and configuration
- `main.dart` - App entry point
- `android/app/build.gradle` - Android build configuration
- `android/app/src/main/AndroidManifest.xml` - Android permissions and configuration
- `build_scripts/build.sh` - Build automation script
- `l10n.yaml` - Localization configuration

**Variables:**
```
API_BASE_URL=...
ENVIRONMENT=development
```

**Instructions:**
- Update `API_BEARER_TOKEN` in each file for the correct environment.
- Verify API URLs for each environment.
- Never commit sensitive tokens to version control.
- Use `.env.local` for local overrides (auto-ignored by git).

**Switch Environment:**
```
flutter run --dart-define=ENVIRONMENT=development
flutter run --dart-define=ENVIRONMENT=staging
flutter run --dart-define=ENVIRONMENT=production
```

**Access in Code:**
```dart
String baseUrl = AppConfig.instance.apiBaseUrl;
String token = AppConfig.instance.apiBearerToken;
String env = AppConfig.instance.environment;
bool isProduction = AppConfig.instance.isProduction;
```


## 3. Project Setup Guide
https://github.com/COSS-India/VoiceGive/blob/master/documentation/project_setup_instalation_guide.md

## 4. Testing Tracker
https://github.com/COSS-India/VoiceGive/blob/master/documentation/testing_tracker.md
---

## 5. Authentication System

### Features
- Secure login (email/password, captcha)
- JWT token management (secure storage)
- State management for authentication
- Automatic token injection in API calls

### Core Components
- **Models:** `lib/models/auth/`
- **Services:** `lib/services/`
- **State Management:** `lib/providers/`
- **UI:** `lib/screens/auth/login/widgets/`

### API Endpoints
- **Login:** `POST {API_BASE_URL}/login-user`
- **Captcha:** `GET {API_BASE_URL}/get-secure-cap`

### Usage Example
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final loginRequest = LoginRequest(
	email: 'user@example.com',
	password: 'password123',
	secureId: 'captcha_secure_id',
	captchaText: 'CAPTCHA',
);
final success = await authProvider.login(loginRequest);
if (success) {
	Navigator.pushReplacementNamed(context, '/home');
}
```

### Token Management
- Tokens are stored securely using `flutter_secure_storage`.
- `ApiService` automatically injects tokens into API requests.
- Use `AuthManager` for manual token access if needed.

---

## 6. Best Practices & Security
- **Never commit sensitive tokens** or production API keys to version control.
- Use environment-specific tokens and endpoints.
- Use `.env.local` for local development secrets.
- Validate all input before making API requests.
- Handle token expiration and errors gracefully.
- Use secure storage for all sensitive data.

---

## 7. Troubleshooting
- **Missing environment file:** Ensure `.env` exists in the project root.
- **Missing variables:** Check all required variables are defined.
- **Build errors:** Run `flutter pub get` after adding dependencies.
- **Token issues:** Verify tokens and permissions.
- **Authentication errors:** Check API endpoints and request formats.

---

## 8. Support
- For more details, see code comments and the `AppConfig`, `AuthManager`, and `AuthProvider` classes.
- Contact the development team for further help.
