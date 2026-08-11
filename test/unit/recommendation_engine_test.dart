import 'package:flutter_test/flutter_test.dart';
import 'package:jnu_bus_routes/core/utils/recommendation_engine.dart';
import 'package:jnu_bus_routes/features/bus_routes/data/models/bus_model.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/bus_enums.dart';

void main() {
  group('RecommendationEngine Tests', () {
    final testBuses = [
      BusModel(
        id: 1,
        busName: 'Projonmo 2',
        userType: UserType.student,
        busType: BusType.doubleDecker,
        upTime: '7:15 AM',
        downTime: '3:40 PM',
        lastStoppage: 'Hatkhola Road',
      ),
      BusModel(
        id: 2,
        busName: 'Oitijjo',
        userType: UserType.student,
        busType: BusType.doubleDecker,
        upTime: '6:45 AM',
        downTime: '3:40 PM',
        lastStoppage: 'Bhulta',
      ),
    ];

    test('Suggests Up direction for morning commute (8:00 AM)', () {
      final morningTime = DateTime(2026, 8, 11, 8, 0);
      final rec = RecommendationEngine.getSmartRecommendations(
        allBuses: testBuses,
        favoriteBusIds: [2],
        recentSearches: [],
        currentTime: morningTime,
      );

      expect(rec.suggestedDirection, equals(RouteDirection.up));
      expect(rec.recommendedBuses.first.id, equals(2));
    });

    test('Suggests Down direction for afternoon commute (3:00 PM)', () {
      final afternoonTime = DateTime(2026, 8, 11, 15, 0);
      final rec = RecommendationEngine.getSmartRecommendations(
        allBuses: testBuses,
        favoriteBusIds: [],
        recentSearches: ['Projonmo'],
        currentTime: afternoonTime,
      );

      expect(rec.suggestedDirection, equals(RouteDirection.down));
      expect(rec.recommendedBuses.first.id, equals(1));
    });
  });
}
