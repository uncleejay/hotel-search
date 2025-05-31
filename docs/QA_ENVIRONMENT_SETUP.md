# QA Environment Setup Documentation

## Overview
This document provides QA testing environment setup for the Hotel Booking Flutter application. This is a living document that will be expanded as I implement additional testing capabilities.

**Current Status**: Phase 1 - Basic Manual Testing Environment ✅  
**Next Phase**: Unit Testing Framework (Planned)

---

## Phase 1: Basic QA Environment (Current)

### System Verification
Environment verified and working as of 2025-05-31:

```bash
✅ Flutter 3.32.1 (Channel stable)
✅ Dart 3.8.1  
✅ Android SDK 35.0.1
✅ Xcode 16.2
✅ Java OpenJDK 21.0.6
✅ Android Studio 2024.3
```

### Prerequisites
- **macOS**: 14.6.1+ (required for iOS testing)
- **RAM**: 16GB minimum
- **Storage**: 20GB free space for emulators
- **Active SerpAPI key** (for hotel search functionality)

### Environment Setup Steps

#### 1. Verify Flutter Installation
```bash
# Check Flutter installation status
flutter doctor -v

# Expected: All items should show ✓ checkmarks
# If issues exist, follow Flutter doctor recommendations
```

#### 2. Configure Test Devices

**Available Emulators/Simulators:**
```bash
# List available devices
flutter emulators

# Example output:
# apple_ios_simulator (iOS Simulator)
# Pixel_API_30 (Android Emulator)
# Custom_Android_Device (Android Emulator)
```

**Launch Test Devices:**
```bash
# Launch any Android emulator (replace with your emulator name)
flutter emulators --launch <your_android_emulator_name>

# Launch any iOS simulator (replace with your simulator name)
flutter emulators --launch <your_ios_simulator_name>

# Verify devices are connected
flutter devices
```

#### 3. Application Setup
```bash
# Navigate to project directory
cd /path/to/hotel-search

# Install dependencies
flutter pub get

# Generate required files
flutter pub run build_runner build --delete-conflicting-outputs

# Configure API key in .env file
echo "SERPAPI_API_KEY=your_api_key_here" > .env
```

#### 4. Test Application Launch
```bash
# List connected devices
flutter devices

# Test on Android (replace with your emulator ID)
flutter run -d <your_android_device_id>

# Test on iOS (replace with your simulator ID)
flutter run -d <your_ios_device_id>
```

### Verified Functionality

#### ✅ Manual Testing Capabilities
- **App Launch**: Successfully launches on both iOS and Android
- **API Integration**: SerpAPI calls working with real hotel data
- **Search Functionality**: Real-time search with debounce
- **Hotel Display**: Hotels display with name, location, description
- **Favorites Feature**: Add/remove hotels from favorites
- **Cross-Platform**: Same functionality verified on both platforms

#### ✅ Current Test Scenarios
1. **App Startup Test**
   - Launch app on iOS simulator
   - Launch app on Android emulator
   - Verify no crashes on startup

2. **Search Functionality Test**
   - Enter search term (e.g., "Delhi")
   - Verify API call is made
   - Verify hotels are displayed
   - Test debounce behavior (rapid typing)

3. **Favorites Feature Test**
   - Add hotel to favorites
   - Navigate to favorites tab
   - Verify hotel appears in favorites
   - Remove hotel from favorites

4. **Cross-Platform Consistency Test**
   - Perform same actions on iOS and Android
   - Verify consistent behavior
   - Verify UI consistency

### Quick Test Commands

```bash
# Quick verification script
#!/bin/bash
echo "🧪 Basic QA Verification"
echo "======================="

# Check Flutter health
flutter doctor

# Check available devices
echo "\nAvailable devices:"
flutter devices

# Check app can build
echo "\nTesting app build:"
flutter build apk --debug
flutter build ios --debug --no-codesign

echo "\n✅ Basic environment verification complete"
```

### E2E Testing with Patrol (Bonus)

**Setup Commands:**
```bash
# Install Patrol CLI globally
dart pub global activate patrol_cli

# Add to PATH (add this to ~/.zshrc for permanent)
export PATH="$PATH:$HOME/.pub-cache/bin"

# Verify Patrol installation
patrol doctor
```

**Running E2E Tests:**
```bash
# List connected devices first
flutter devices

# Run E2E tests (replace with your device ID)
flutter test integration_test/app_test.dart -d <your_device_id>

# Examples:
# flutter test integration_test/app_test.dart -d <your_android_emulator>
# flutter test integration_test/app_test.dart -d <your_ios_simulator>

# List available test files
find integration_test -name "*.dart"
```

### Multi-Device Testing (Step 1 Deliverable) ✅

**Automated Multi-Device Test Execution:**
```bash
# Run tests across ALL connected devices automatically
./scripts/run_tests_multi_device.sh all

# Run only unit tests (device independent)
./scripts/run_tests_multi_device.sh unit

# Run integration tests on all connected devices
./scripts/run_tests_multi_device.sh integration
```

**Manual Multi-Device Commands:**
```bash
# Show multi-device command examples
./scripts/multi_device_commands.sh

# Example manual multi-device sequence:
flutter devices  # List all devices
ANDROID_DEVICE=$(flutter devices | grep "android" | head -1 | cut -d " " -f 1)
iOS_DEVICE=$(flutter devices | grep "ios" | head -1 | cut -d " " -f 1)

# Run on both platforms
flutter test integration_test/app_test.dart -d $ANDROID_DEVICE
flutter test integration_test/app_test.dart -d $iOS_DEVICE
```

**Multi-Device Loop Example:**
```bash
# Test on all available mobile devices
for device in $(flutter devices | grep -E "(android|ios)" | cut -d " " -f 1); do
  echo "Testing on device: $device"
  flutter test integration_test/app_test.dart -d $device
done
```

**Test Coverage:**
- ✅ App launch and navigation testing
- ✅ Hotel search functionality validation
- ✅ Cross-tab navigation verification
- ✅ Dependency injection and state management
- ✅ Cross-platform compatibility (Android + iOS)

**Test Results:**
- ✅ Android: All tests passed
- ✅ iOS: All tests passed
- ✅ Both platforms: Clean execution, no exceptions

### Current Phase Status

#### Phase 1 Complete ✅
- ✅ Cross-platform manual testing environment
- ✅ Device configuration (Android + iOS)
- ✅ Environment verification script
- ✅ Build system compatibility resolved
- ✅ **Dev team tools support**: `flutter test` and `integration_test` working
- ✅ **Bonus**: Patrol E2E testing framework setup
- ✅ **Bonus**: Working E2E test implementation

#### Future Phases Planned 📋
- 📋 Expanded automated test suite
- 📋 CI/CD pipeline integration
- 📋 Performance testing framework
- 📋 Additional E2E test scenarios

#### Resolved Issues
- ✅ Android Gradle Plugin compatibility (updated to 8.3.0)
- ✅ Gradle wrapper version (updated to 8.4)
- ✅ Kotlin version compatibility (updated to 1.9.10)
- ✅ SerpAPI integration working

### Device Testing Matrix (Current)

| Platform | Device | API/iOS Version | Status | Notes |
|----------|--------|----------------|---------|-------|
| Android | Medium Phone API 36 | Android 16 (API 36) | ✅ Verified | Primary Android test device |
| iOS | iPhone SE (3rd gen) | iOS 18.3 | ✅ Verified | Primary iOS test device |
| macOS | Native macOS | macOS 14.6.1 | ✅ Verified | Development platform |

---

## Phase 2: Automated Testing (Planned)

### Upcoming Implementations
- [ ] Unit testing framework setup
- [ ] Widget testing implementation
- [ ] Integration testing framework
- [ ] Test coverage reporting
- [ ] CI/CD pipeline integration

### Future Phases
- **Phase 3**: E2E Testing (Patrol/Maestro)
- **Phase 4**: Performance Testing
- **Phase 5**: Accessibility Testing
- **Phase 6**: Visual Regression Testing

---

## Troubleshooting

### Common Issues

1. **"No devices found"**
   ```bash
   # List available emulators first
   flutter emulators
   
   # Start emulators manually (replace with your device names)
   flutter emulators --launch <your_android_emulator>
   flutter emulators --launch <your_ios_simulator>
   ```

2. **"Build failed" on Android**
   ```bash
   # Clean and rebuild
   flutter clean
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **"API key not working"**
   ```bash
   # Check .env file exists and has correct format
   cat .env
   # Should show: SERPAPI_API_KEY=your_actual_key
   ```

### Getting Help
- Check original project README.md for app-specific setup
- Run `flutter doctor` for system-level issues
- Verify API key is active at [SerpApi Dashboard](https://serpapi.com/dashboard)

---

**Document Version**: 1.0 (Phase 1)  
**Last Updated**: 2025-05-31  
**Next Review**: After Phase 2 implementation  
**Status**: Phase 1 Complete ✅

