# VoiceGive App Branding Guide

This guide helps adopters customize the VoiceGive app with their own branding, including app name, icons, colors, images, animations, and consent forms.

## Quick Start

1. Edit `branding.yaml` in the root directory
2. Customize consent text in `lib/l10n/app_en.arb`
3. Add your assets to the `assets/` folder
4. Run the build script: `dart tool/configure_app.dart production`
5. Build your APK: `flutter build apk`

## Configuration File Structure

All branding is controlled through `branding.yaml`:

```yaml
app:
  display_name: "Your App Name"
  app_icon: "assets/launcher/your_icon.png"

branding:
  primary_color: "21, 125, 82, 1"
  secondary_color: "231, 97, 32, 1"
  banner_color: "231, 97, 32, 1"
  
  splash_logo: "assets/images/your_splash_logo.png"
  splash_name: "Your App Name"
  splash_animation: "assets/animations/your_splash.json"
  
  header_primary_image: "assets/images/header1.png"
  header_secondary_image: "assets/images/header2.png"
  header_tertiary_image: "assets/images/header3.png"
  
  banner_image: "assets/images/banner.png"
  home_screen_body_image: "assets/images/home_body.png"
  home_screen_footer_image: "assets/images/footer.png"
  home_screen_footer_url: "https://yourwebsite.com"
  
  badge_image: "assets/images/badge.png"
  
  terms_of_use_url: "https://yoursite.com/terms"
  privacy_policy_url: "https://yoursite.com/privacy"
  copyright_policy_url: "https://yoursite.com/copyright"
```

## App Name & Icon

### App Name
- **Field**: `app.display_name`
- **Character Limit**: 255 characters (15 recommended for visibility)
- **Allowed Characters**: Letters, numbers, spaces, hyphens (-), underscores (_)
- **Example**: `"MyVoice Contributor"`

### App Icon
- **Field**: `app.app_icon`
- **Format**: PNG (recommended)
- **Resolution**: 1024x1024 pixels
- **File Size**: < 1MB
- **Path**: Place in `assets/launcher/` folder
- **Example**: `"assets/launcher/my_app_icon.png"`

## Colors

All colors use RGBA format: `"R, G, B, A"`

### Primary Color
- **Field**: `branding.primary_color`
- **Usage**: Main UI elements, buttons
- **Example**: `"21, 125, 82, 1"` (green)

### Secondary Color
- **Field**: `branding.secondary_color`
- **Usage**: Accent elements, highlights
- **Example**: `"231, 97, 32, 1"` (orange)

### Banner Color
- **Field**: `branding.banner_color`
- **Usage**: Top banners, headers
- **Example**: `"231, 97, 32, 1"`

## Splash Screen

### Splash Logo
- **Field**: `branding.splash_logo`
- **Format**: PNG, SVG
- **Resolution**: 512x512 pixels recommended
- **File Size**: < 200KB
- **Usage**: Logo shown during app startup

### Splash Name
- **Field**: `branding.splash_name`
- **Usage**: Text displayed with splash logo
- **Character Limit**: 50 characters recommended

### Splash Animation
- **Field**: `branding.splash_animation`
- **Format**: Lottie JSON files only
- **File Size**: < 500KB recommended
- **Duration**: 2-3 seconds recommended
- **Path**: Place in `assets/animations/`
- **Example**: `"assets/animations/my_splash.json"`

## Home Screen Images

### Header Images
- **Fields**: 
  - `branding.header_primary_image`
  - `branding.header_secondary_image`
  - `branding.header_tertiary_image`
- **Format**: PNG, JPG
- **Resolution**: 1920x1080 pixels (16:9 aspect ratio) recommended
- **File Size**: < 500KB per image
- **Usage**: Images in header section

### Body Image
- **Field**: `branding.home_screen_body_image`
- **Format**: PNG, JPG
- **Resolution**: 1080x600 pixels recommended
- **File Size**: < 300KB
- **Usage**: Replaces default home content when provided
- **Note**: Makes image clickable for "Get Started" action

### Footer Image
- **Field**: `branding.home_screen_footer_image`
- **Format**: PNG, JPG
- **Resolution**: 1080x300 pixels recommended
- **File Size**: < 200KB
- **Usage**: Bottom section image
- **Clickable**: Links to `home_screen_footer_url` if provided

### Banner Image
- **Field**: `branding.banner_image`
- **Format**: PNG, JPG
- **Resolution**: 1080x200 pixels recommended
- **File Size**: < 150KB
- **Usage**: Top banner across app

### Badge Image
- **Field**: `branding.badge_image`
- **Format**: PNG (with transparency recommended)
- **Resolution**: 512x512 pixels recommended
- **File Size**: < 100KB
- **Usage**: Achievement badges and certificates

## URLs

### Character Limits
- **Technical Limit**: 2,083 characters
- **Practical Limit**: < 2,000 characters recommended
- **Format**: Must start with `http://` or `https://`
- **Validation**: No spaces allowed

### Required URLs
- **Terms of Use**: `branding.terms_of_use_url`
- **Privacy Policy**: `branding.privacy_policy_url`
- **Copyright Policy**: `branding.copyright_policy_url`
- **Footer Link**: `branding.home_screen_footer_url`

## Consent Form Configuration

Customize consent text by editing `lib/l10n/app_en.arb`. 
**Do not change the left-side keys**, only modify the right-side values:

### Editable Consent Fields

```json
{
  "weRespectYourPrivacy": "We Respect Your Privacy",
  "namasteContributor": "Namaste Contributor/Validator",
  "namasteEmoji": "🙏",
  "consentMessage": "Before you begin contributing...",
  "consentConfirm": "By clicking \"{button}\", you confirm that:",
  "consentPoint1": "are authorized to contribute and validate data...",
  "consentPoint2": "You grant the project maintainers and ...",
  "consentPoint3": "Except for personal information, all submitted data...",
  "consentPoint4": "You waive any claim to ownership...",
  "consentPoint5": "You have read, understood, and accepted...",
  "termsOfUse": "Terms of Use/ Contribution Terms",
  "privacyPolicy": "Privacy Policy",
  "copyrightPolicy": "Copyright & Licensing Policy"
}
```

### Linking External Documents

For the last 3 fields (`termsOfUse`, `privacyPolicy`, `copyrightPolicy`), users can:
1. **Keep default text** - Links to URLs in `branding.yaml`
2. **Customize text** - Still links to URLs in `branding.yaml`

The URLs are configured in `branding.yaml`:
```yaml
branding:
  terms_of_use_url: "https://yoursite.com/terms"
  privacy_policy_url: "https://yoursite.com/privacy"
  copyright_policy_url: "https://yoursite.com/copyright"
```

## Asset Organization

```
assets/
├── launcher/
│   └── your_app_icon.png          # App icon (1024x1024, <1MB)
├── images/
│   ├── your_splash_logo.png       # Splash logo (512x512, <200KB)
│   ├── header1.png                # Header images (1920x1080, <500KB)
│   ├── header2.png
│   ├── header3.png
│   ├── banner.png                 # Banner (1080x200, <150KB)
│   ├── home_body.png              # Home body (1080x600, <300KB)
│   ├── footer.png                 # Footer (1080x300, <200KB)
│   └── badge.png                  # Badge (512x512, <100KB)
└── animations/
    └── your_splash.json           # Lottie animation (<500KB)
```

## File Size Best Practices

### Image Optimization
- **App Icon**: < 1MB (PNG with transparency)
- **Splash Logo**: < 200KB (PNG recommended)
- **Header Images**: < 500KB each (JPG for photos, PNG for graphics)
- **Banner**: < 150KB (optimize for fast loading)
- **Home Images**: < 300KB (balance quality and performance)
- **Badge**: < 100KB (PNG with transparency)

### Animation Guidelines
- **Lottie Files**: < 500KB (keep animations simple)
- **Duration**: 2-3 seconds maximum
- **Frame Rate**: 30fps recommended
- **Complexity**: Avoid complex gradients and effects

## Build Process

Use the automated build script for all environments:

```bash
./build_scripts/build.sh [environment]
```

**Available environments:**
- `development` - Debug build with development configuration
- `staging` - Release build with staging configuration  
- `production` - Release build with production configuration

**Examples:**
```bash
./build_scripts/build.sh development
./build_scripts/build.sh staging
./build_scripts/build.sh production
```

The build script automatically:
- Validates branding configuration
- Configures app name and package ID
- Cleans previous builds
- Generates app icons
- Runs code generation
- Builds APK for the specified environment

## Validation Rules

The build process automatically validates:
- App name character limits and allowed characters
- URL format and length
- File existence for specified assets
- Color format (RGBA)

Build will fail with clear error messages if validation fails.

## Tips

- **Test on Device**: Always test your branding on actual devices
- **Image Optimization**: Use tools like TinyPNG or ImageOptim to compress images
- **Color Contrast**: Ensure good contrast for accessibility (WCAG 2.1 AA compliance)
- **Lottie Performance**: Keep animations simple for smooth playback on low-end devices
- **URL Testing**: Verify all URLs are accessible before building
- **Consent Text**: Keep consent language clear and legally compliant
- **File Naming**: Use descriptive names without spaces or special characters
- **Aspect Ratios**: Maintain recommended aspect ratios to prevent image distortion

## Troubleshooting

### Common Issues
- **Build Fails**: Check validation errors in console output
- **Images Not Showing**: Verify file paths and existence
- **Colors Wrong**: Check RGBA format with proper commas and spaces
- **Animation Not Playing**: Ensure Lottie JSON is valid and < 500KB
- **Consent Links Not Working**: Verify URLs in branding.yaml are accessible

### Default Fallbacks
If any branding element is missing or invalid, the app uses built-in defaults to ensure functionality.

## Advanced: Manual Flutter Commands

For advanced users who prefer manual control, here are the individual Flutter commands:

```bash
# Configure app branding
dart tool/configure_app.dart production

# Clean and prepare
flutter clean
flutter pub get

# Generate app icons
flutter pub run flutter_launcher_icons:main

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Build APK (choose one)
flutter build apk --dart-define=ENVIRONMENT=development --debug
flutter build apk --dart-define=ENVIRONMENT=staging --release
flutter build apk --dart-define=ENVIRONMENT=production --release
```

**Note:** Using the build script `./build_scripts/build.sh` is recommended as it handles all steps automatically and ensures proper configuration.