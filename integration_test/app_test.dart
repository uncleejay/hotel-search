import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hotel_booking/main.dart';
import 'package:hotel_booking/core/di/injectable.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Hotel Booking App Tests', () {
    testWidgets('Basic app navigation test', (WidgetTester tester) async {
      // Setup Hive
      final directory = await getApplicationDocumentsDirectory();
      Hive.defaultDirectory = directory.path;
      
      // Setup dependency injection
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
      
      // Navigate to Favorites tab
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      
      // Verify we're on the Favorites page
      expect(find.text('Favorites'), findsOneWidget);
      print('Navigated to Favorites tab');
      
      // Navigate to Account tab
      await tester.tap(find.text('Account'));
      await tester.pumpAndSettle();
      
      // Verify we're on the Account page
      expect(find.text('Account'), findsOneWidget);
      print('Navigated to Account tab');
      
      // Navigate back to Overview
      await tester.tap(find.text('Overview'));
      await tester.pumpAndSettle();
      
      // Verify we're back on the Overview page
      expect(find.text('Overview'), findsOneWidget);
      print('Navigated to Overview tab');
      
      print('Test completed successfully');
    });
  });
}
