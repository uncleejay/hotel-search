#!/bin/bash

# QA Environment Verification Script
# Usage: ./scripts/qa_verify.sh
# Purpose: Verify QA environment is properly setup for Hotel Booking app testing

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Hotel Booking App - QA Environment Verification${NC}"
echo "======================================================"
echo "Date: $(date)"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
    fi
}

echo -e "${YELLOW}📋 System Requirements Check${NC}"
echo "----------------------------"

# Check Flutter
if command_exists flutter; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    echo -e "${GREEN}✅ Flutter installed: $FLUTTER_VERSION${NC}"
else
    echo -e "${RED}❌ Flutter not found${NC}"
    exit 1
fi

# Check Dart
if command_exists dart; then
    DART_VERSION=$(dart --version 2>&1 | head -n 1)
    echo -e "${GREEN}✅ Dart installed: $DART_VERSION${NC}"
else
    echo -e "${RED}❌ Dart not found${NC}"
fi

# Check Android tools
if command_exists adb; then
    echo -e "${GREEN}✅ Android Debug Bridge (adb) available${NC}"
else
    echo -e "${RED}❌ Android Debug Bridge (adb) not found${NC}"
fi

# Check Xcode (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if command_exists xcrun; then
        XCODE_VERSION=$(xcrun xcodebuild -version | head -n 1)
        echo -e "${GREEN}✅ Xcode available: $XCODE_VERSION${NC}"
    else
        echo -e "${RED}❌ Xcode not found${NC}"
    fi
fi

echo ""
echo -e "${YELLOW}🔧 Flutter Doctor Check${NC}"
echo "-------------------------"
flutter doctor

echo ""
echo -e "${YELLOW}📱 Available Test Devices${NC}"
echo "--------------------------"
flutter devices

echo ""
echo -e "${YELLOW}🏗️ Project Dependencies Check${NC}"
echo "------------------------------"

# Check if we're in the correct directory
if [ -f "pubspec.yaml" ]; then
    echo -e "${GREEN}✅ Found pubspec.yaml - in Flutter project directory${NC}"
    
    # Check if dependencies are installed
    if [ -d ".dart_tool" ]; then
        echo -e "${GREEN}✅ Dependencies appear to be installed${NC}"
    else
        echo -e "${YELLOW}⚠️  Dependencies may need installation - run 'flutter pub get'${NC}"
    fi
    
    # Check for .env file
    if [ -f ".env" ]; then
        echo -e "${GREEN}✅ Environment file (.env) found${NC}"
        if grep -q "SERPAPI_API_KEY" .env; then
            echo -e "${GREEN}✅ SerpAPI key configured in .env${NC}"
        else
            echo -e "${RED}❌ SerpAPI key not found in .env file${NC}"
        fi
    else
        echo -e "${RED}❌ Environment file (.env) not found${NC}"
    fi
else
    echo -e "${RED}❌ Not in Flutter project directory (pubspec.yaml not found)${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}🎯 Quick Build Test${NC}"
echo "-------------------"

# Test if app can build
echo "Testing debug build capability..."
flutter build apk --debug >/dev/null 2>&1
print_status $? "Android debug build test"

if [[ "$OSTYPE" == "darwin"* ]]; then
    flutter build ios --debug --no-codesign >/dev/null 2>&1
    print_status $? "iOS debug build test"
fi

echo ""
echo -e "${YELLOW}📊 Summary${NC}"
echo "----------"
echo "Environment verification completed."
echo "Check any ❌ items above and resolve before proceeding with testing."
echo ""
echo -e "${BLUE}📖 Next Steps:${NC}"
echo "1. Review docs/QA_ENVIRONMENT_SETUP.md for detailed setup"
echo "2. Launch test devices: flutter emulators --launch <device_id>"
echo "3. Run app: flutter run -d <device_id>"
echo "4. Begin manual testing scenarios"
echo ""
echo -e "${GREEN}✅ QA Environment Verification Complete${NC}"

