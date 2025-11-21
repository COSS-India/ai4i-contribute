#!/bin/bash

# Build script for different environments with app configuration
# Usage: ./build_scripts/build.sh [development|staging|production]

set -e

ENVIRONMENT=${1:-development}

echo "🔧 Configuring and building for environment: $ENVIRONMENT"

# Configure app branding first
echo "📱 Configuring app branding..."
dart tool/configure_app.dart $ENVIRONMENT

# Clean and prepare
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

echo "🔤 Generating font configuration..."
dart run build_scripts/generate_fonts.dart

echo "🎨 Generating app icons..."
flutter pub run flutter_launcher_icons:main

flutter pub run build_runner build --delete-conflicting-outputs

case $ENVIRONMENT in
  development)
    echo "Building development version..."
    flutter build apk --dart-define=ENVIRONMENT=development --debug
    ;;
  staging)
    echo "Building staging version..."
    flutter build apk --dart-define=ENVIRONMENT=staging --release
    ;;
  production)
    echo "Building production version..."
    flutter build apk --dart-define=ENVIRONMENT=production --release
    ;;
  *)
    echo "Invalid environment. Use: development, staging, or production"
    exit 1
    ;;
esac

echo "Build completed for $ENVIRONMENT environment"
