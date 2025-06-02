import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hotel_booking/main.dart';
import 'package:hotel_booking/core/di/injectable.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Directory, File, Platform;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  // Track directory for cleanup
  Directory? hiveDirectory;

  group('Hotel Booking App E2E Tests', () {
    // Add tearDown for proper cleanup
    tearDown(() async {
      print('Cleaning up after test...');
      
      // Clean up Hive directory if possible
      if (hiveDirectory != null && hiveDirectory!.existsSync()) {
        try {
          // Only attempt to delete files, not the whole directory
          final files = hiveDirectory!.listSync();
          for (final file in files) {
            if (file is File && file.path.contains('.hive')) {
              file.deleteSync();
              print('Deleted Hive file: ${file.path}');
            }
          }
        } catch (e) {
          print('Warning when cleaning Hive files: $e');
        }
      }
    });
    testWidgets('Hotel search and navigation flow', (WidgetTester tester) async {
      try {
        print('Starting integration test');
        
        // Setup Hive directory for testing
        final directory = await getApplicationDocumentsDirectory();
        hiveDirectory = directory; // Store for cleanup
        Hive.defaultDirectory = directory.path;
        
        // Setup dependency injection for testing
        configureDependencies();
        
        // Launch the app
        print('Launching app');
        await tester.pumpWidget(App());
        await tester.pumpAndSettle();
        
        // Verify app launches successfully
        expect(find.text('Hotels'), findsOneWidget);
        print('App launched successfully');
        
        // Navigate to Hotels tab
        await tester.tap(find.text('Hotels'));
        await tester.pumpAndSettle();
        
        // Verify we're on the Hotels page
        expect(find.byType(TextField), findsOneWidget);
        print('Navigated to Hotels tab');
        
        // Perform hotel search
        await tester.enterText(find.byType(TextField), 'London');
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pumpAndSettle();
        print('Entered search text for London');
        
        // Wait for API response
        await tester.pumpAndSettle(const Duration(seconds: 5));
        print('Waited for search results');
        
        // Navigate to Favorites tab to verify navigation works
        await tester.tap(find.text('Favorites'));
        await tester.pumpAndSettle();
        
        // Verify we can navigate between tabs
        expect(find.text('Favorites'), findsOneWidget);
        print('Navigated to Favorites tab');
        
        // Navigate to Account tab
        await tester.tap(find.text('Account'));
        await tester.pumpAndSettle();
        
        // Verify account page loads
        expect(find.text('Account'), findsOneWidget);
        print('Navigated to Account tab');
        
        // Navigate back to Overview
        await tester.tap(find.text('Overview'));
        await tester.pumpAndSettle();
        
        // Verify we're back to overview
        expect(find.text('Overview'), findsOneWidget);
        print('Navigated to Overview tab');
        
        print('E2E Test completed successfully');
      } catch (e, stackTrace) {
        print('Test failed with error: $e');
        print('Stack trace: $stackTrace');
        
        // Try to capture diagnostic information on failure
        try {
          print('Diagnostic information:');
          print('Platform: ${Platform.operatingSystem}');
          final widgetsOnScreen = tester.widgetList(find.byType(Widget)).length;
          print('Widgets on screen: $widgetsOnScreen');
        } catch (diagnosticError) {
          print('Failed to capture diagnostics: $diagnosticError');
        }
        
        rethrow;
      }
    });
  });
}

