import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hotel_booking/main.dart';
import 'package:hotel_booking/core/di/injectable.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Hotel Booking App E2E Tests', () {
    testWidgets('Hotel search and navigation flow', (WidgetTester tester) async {
      try {
        print('Starting integration test');
        
        // Setup Hive directory for testing
        final directory = await getApplicationDocumentsDirectory();
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
      } catch (e) {
        print('Test failed with error: $e');
        rethrow;
      }
    });
  });
}

