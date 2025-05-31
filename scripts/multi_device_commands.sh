#!/bin/bash

# Multi-Device Command Examples
# Simple command-line examples for running tests across multiple devices

echo "📱 Multi-Device Testing Commands"
echo "==============================="
echo ""

# Get connected devices
echo "📋 Step 1: List all connected devices"
echo "flutter devices"
echo ""

# Store device info
echo "📋 Step 2: Store device IDs for testing"
echo 'ANDROID_DEVICE=$(flutter devices | grep "android" | head -1 | cut -d " " -f 1)'
echo 'IOS_DEVICE=$(flutter devices | grep "ios" | head -1 | cut -d " " -f 1)'
echo ""

# Run unit tests (once - no device needed)
echo "📋 Step 3: Run unit tests (device independent)"
echo "flutter test"
echo ""

# Run integration tests on multiple devices
echo "📋 Step 4: Run integration tests on Android"
echo 'flutter test integration_test/app_test.dart -d $ANDROID_DEVICE'
echo ""

echo "📋 Step 5: Run integration tests on iOS"
echo 'flutter test integration_test/app_test.dart -d $IOS_DEVICE'
echo ""

# Combined multi-device example
echo "📋 Step 6: Complete multi-device test sequence"
echo 'for device in $(flutter devices | grep -E "(android|ios)" | cut -d " " -f 1); do'
echo '  echo "Testing on device: $device"'
echo '  flutter test integration_test/app_test.dart -d $device'
echo 'done'
echo ""

echo "🎯 Usage Examples:"
echo "  ./scripts/run_tests_multi_device.sh all     # Run all tests on all devices"
echo "  ./scripts/run_tests_multi_device.sh unit    # Run unit tests only"
echo "  ./scripts/run_tests_multi_device.sh integration # Run integration tests on all devices"
echo ""
echo "📖 For more details, see: docs/QA_ENVIRONMENT_SETUP.md"

