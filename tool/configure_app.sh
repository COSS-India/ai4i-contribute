#!/bin/bash

# AI4I Contribute App Configuration Script
# Usage: ./configure_app.sh [environment]
# Example: ./configure_app.sh production

set -e

ENVIRONMENT=${1:-development}

echo "🔧 Configuring AI4I Contribute for environment: $ENVIRONMENT"

# Run the Dart configuration script
dart tool/configure_app.dart $ENVIRONMENT

echo "✅ App configuration completed!"