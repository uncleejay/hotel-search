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
      // Setup Hive directory for testing
      final directory = await getApplicationDocumentsDirectory();
      Hive.defaultDirectory = directory.path;
      
      // Setup dependency injection for testing
      configureDependencies();
      
      // Launch the app
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();
      
      // Verify app launches successfully
      expect(find.text('Hotels'), findsOneWidget);
      
      // Navigate to Hotels tab
      await tester.tap(find.text('Hotels'));
      await tester.pumpAndSettle();
      
      // Verify we're on the Hotels page
      expect(find.byType(TextField), findsOneWidget);
      
      // Perform hotel search
      await tester.enterText(find.byType(TextField), 'London');
      await tester.pumpAndSettle();
      
      // Wait for potential API response
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Navigate to Favorites tab to verify navigation works
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      
      // Verify we can navigate between tabs
      expect(find.text('Favorites'), findsOneWidget);
      
      // Navigate to Account tab
      await tester.tap(find.text('Account'));
      await tester.pumpAndSettle();
      
      // Verify account page loads
      expect(find.text('Account'), findsOneWidget);
      
      // Navigate back to Overview
      await tester.tap(find.text('Overview'));
      await tester.pumpAndSettle();
      
      // Verify we're back to overview
      expect(find.text('Overview'), findsOneWidget);
      
      print('✅ E2E Test completed successfully');
    });
  });
}

