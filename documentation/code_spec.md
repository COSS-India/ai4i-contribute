## Code Structure

### Key Directories

```
ai4i-contribute/
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
