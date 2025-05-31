#!/bin/bash

# Multi-Device Test Execution Script
# Usage: ./scripts/run_tests_multi_device.sh [unit|integration|all]
# Purpose: Execute tests across multiple devices and platforms

set -e

echo "🚀 Multi-Device Test Execution"
echo "=============================="
echo "Date: $(date)"
echo ""

# Configuration
TEST_TYPE=${1:-"all"}
LOG_DIR="test_results"
mkdir -p "$LOG_DIR"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
    fi
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Function to run unit tests
run_unit_tests() {
    echo -e "${YELLOW}📋 Running Unit Tests${NC}"
    echo "------------------"
    
    if flutter test > "$LOG_DIR/unit_tests.log" 2>&1; then
        print_status 0 "Unit tests passed"
        echo "  📊 Results saved to: $LOG_DIR/unit_tests.log"
        return 0
    else
        print_status 1 "Unit tests failed"
        echo "  📊 Error log: $LOG_DIR/unit_tests.log"
        return 1
    fi
}

# Function to get available devices
get_devices() {
    flutter devices --machine | jq -r '.[] | select(.category == "mobile") | "\(.id)|\(.name)|\(.platform)"' 2>/dev/null || {
        # Fallback if jq not available
        flutter devices | grep -E "(emulator|simulator|iPhone|android)" | awk '{print $1"|"\
$0"|unknown"}' | head -10
    }
}

# Function to run integration tests on a specific device
run_integration_test_on_device() {
    local device_id="$1"
    local device_name="$2"
    local platform="$3"
    
    print_info "Testing on: $device_name ($device_id)"
    
    local log_file="$LOG_DIR/integration_${platform}_$(echo $device_id | sed 's/[^a-zA-Z0-9]/_/g').log"
    
    if timeout 300 flutter test integration_test/app_test.dart -d "$device_id" > "$log_file" 2>&1; then
        print_status 0 "Integration tests passed on $platform: $device_name"
        echo "  📊 Results: $log_file"
        return 0
    else
        print_status 1 "Integration tests failed on $platform: $device_name"
        echo "  📊 Error log: $log_file"
        return 1
    fi
}

# Function to run integration tests on multiple devices
run_integration_tests() {
    echo -e "${YELLOW}📱 Running Integration Tests on Multiple Devices${NC}"
    echo "-----------------------------------------------"
    
    print_info "Detecting available devices..."
    
    # Get list of connected devices
    local devices
    devices=$(get_devices)
    
    if [ -z "$devices" ]; then
        print_warning "No mobile devices found. Please start emulators/simulators."
        echo "Run these commands to start devices:"
        echo "  flutter emulators --launch <android_emulator>"
        echo "  flutter emulators --launch <ios_simulator>"
        return 1
    fi
    
    local android_tested=false
    local ios_tested=false
    local total_tests=0
    local passed_tests=0
    
    # Test on each available device
    while IFS='|' read -r device_id device_name platform; do
        if [ -n "$device_id" ]; then
            total_tests=$((total_tests + 1))
            
            if run_integration_test_on_device "$device_id" "$device_name" "$platform"; then
                passed_tests=$((passed_tests + 1))
                
                # Track platform coverage
                case "$platform" in
                    *android*|*emulator*) android_tested=true ;;
                    *ios*|*iPhone*|*iPad*) ios_tested=true ;;
                esac
            fi
            
            echo "" # Add spacing between tests
        fi
    done <<< "$devices"
    
    # Summary
    echo -e "${BLUE}📊 Integration Test Summary${NC}"
    echo "Passed: $passed_tests/$total_tests devices"
    
    if [ "$android_tested" = true ] && [ "$ios_tested" = true ]; then
        print_status 0 "Cross-platform testing completed (Android + iOS)"
    elif [ "$android_tested" = true ]; then
        print_warning "Only Android testing completed"
    elif [ "$ios_tested" = true ]; then
        print_warning "Only iOS testing completed"
    else
        print_status 1 "No successful cross-platform tests"
    fi
    
    return $((total_tests - passed_tests))
}

# Main execution logic
echo "Test Type: $TEST_TYPE"
echo "Log Directory: $LOG_DIR"
echo ""

overall_result=0

# Run tests based on type
case "$TEST_TYPE" in
    "unit")
        run_unit_tests
        overall_result=$?
        ;;
    "integration")
        run_integration_tests
        overall_result=$?
        ;;
    "all")
        print_info "Running comprehensive test suite..."
        echo ""
        
        # Run unit tests first
        run_unit_tests
        unit_result=$?
        
        echo ""
        
        # Run integration tests
        run_integration_tests
        integration_result=$?
        
        overall_result=$((unit_result + integration_result))
        ;;
    *)
        echo "❌ Invalid test type: $TEST_TYPE"
        echo "Usage: $0 [unit|integration|all]"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}🏁 Final Results${NC}"
echo "================="

if [ $overall_result -eq 0 ]; then
    print_status 0 "All tests completed successfully!"
    echo "📊 Detailed logs available in: $LOG_DIR/"
else
    print_status 1 "Some tests failed. Check logs in: $LOG_DIR/"
fi

echo ""
echo "📁 Generated files:"
ls -la "$LOG_DIR/" 2>/dev/null || echo "  No log files generated"

echo ""
echo "🎯 Multi-device testing completed!"

exit $overall_result

