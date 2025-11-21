#!/bin/bash

# VoiceGive App Configuration Script
# Usage: ./configure_app.sh [environment]
# Example: ./configure_app.sh production

set -e

ENVIRONMENT=${1:-development}

echo "🔧 Configuring VoiceGive for environment: $ENVIRONMENT"

# Run the Dart configuration script
dart tool/configure_app.dart $ENVIRONMENT

echo "✅ App configuration completed!"