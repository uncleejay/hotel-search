import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/hotels/presentation/widgets/hotel_card.dart';
import 'package:hotel_booking/features/hotels/domain/entities/entities.dart';

void main() {
  group('Hotel Card Widget Tests', () {
    testWidgets('HotelCard displays hotel information correctly', (WidgetTester tester) async {
      // Create test data with London-specific information
      final testHotel = Hotel(
        name: 'London Hotel',
        location: Location(latitude: 51.5074, longitude: -0.1278),
        description: 'Modern hotel in central London',
      );

      bool favoriteChanged = false;
      
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HotelCard(
              hotel: testHotel,
              isFavorite: false,
              onFavoriteChanged: (value) {
                favoriteChanged = true;
              },
            ),
          ),
        ),
      );

      // Verify hotel information is displayed
      expect(find.text('London Hotel'), findsOneWidget);
      expect(find.text('Modern hotel in central London'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_outline), findsOneWidget);

      // Test favorite button interaction
      await tester.tap(find.byIcon(Icons.favorite_outline));
      expect(favoriteChanged, isTrue);
    });

    testWidgets('HotelCard shows filled heart when favorited', (WidgetTester tester) async {
      final testHotel = Hotel(
        name: 'The Savoy London',
        location: Location(latitude: 51.5074, longitude: -0.1278),
        description: 'Luxury hotel on the River Thames',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HotelCard(
              hotel: testHotel,
              isFavorite: true,
              onFavoriteChanged: (value) {},
            ),
          ),
        ),
      );

      // Verify favorited state shows filled heart
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_outline), findsNothing);
    });
  });

  group('Basic Flutter Test Environment', () {
    test('Environment supports basic unit tests', () {
      // Simple test to verify flutter test command works
      expect(1 + 1, equals(2));
      expect('flutter test', isA<String>());
    });
  });
}

