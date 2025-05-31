#!/bin/bash

# Patrol E2E Test Runner Script
# Usage: ./scripts/run_e2e_tests.sh [android|ios]

set -e

echo "🤖 Patrol E2E Test Runner"
echo "========================"

# Setup environment
export PATH="$PATH:$HOME/.pub-cache/bin"
export ANDROID_HOME="/Users/josephcole-showers/Library/Android/sdk"
export PATH="$ANDROID_HOME/platform-tools:$PATH"

# Check if Patrol CLI is installed
if ! command -v patrol &> /dev/null; then
    echo "📦 Installing Patrol CLI..."
    dart pub global activate patrol_cli
fi

# Determine target platform
PLATFORM=${1:-"android"}

echo "📋 Listing available devices..."
flutter devices

echo "\n⚠️  Please select a device ID from the list above"
echo "Example usage:"
echo "  flutter test integration_test/app_test.dart -d <device_id>"
echo ""

if [ "$PLATFORM" = "android" ]; then
    echo "🤖 For Android testing, look for device IDs starting with 'emulator-' or containing 'android'"
elif [ "$PLATFORM" = "ios" ]; then
    echo "📱 For iOS testing, look for device IDs containing 'iPhone' or 'iPad'"
else
    echo "❌ Unknown platform: $PLATFORM"
    echo "Usage: $0 [android|ios]"
    exit 1
fi

echo "\n💡 Copy a device ID and run:"
echo "   flutter test integration_test/app_test.dart -d <device_id>"
echo "\n📖 Or see QA documentation for more details:"
echo "   open docs/README.md"

echo "\n📝 Ready to run tests! Use the command above with your chosen device ID."
echo "\n🎯 Pro tip: The script has shown you how to run the tests manually."
echo "   This ensures compatibility with any device setup!"

