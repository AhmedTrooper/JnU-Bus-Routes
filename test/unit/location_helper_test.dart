import 'package:flutter_test/flutter_test.dart';
import 'package:jnu_bus_routes/core/utils/location_helper.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/bus_enums.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/route_stoppage.dart';

void main() {
  group('LocationHelper Tests', () {
    test('Calculates passed, current, and upcoming stoppage statuses based on active index', () {
      final stoppages = [
        RouteStoppage(stoppageNo: 1, placeId: 10, placeName: 'Stop A', direction: RouteDirection.up),
        RouteStoppage(stoppageNo: 2, placeId: 11, placeName: 'Stop B', direction: RouteDirection.up),
        RouteStoppage(stoppageNo: 3, placeId: 12, placeName: 'Stop C', direction: RouteDirection.up),
      ];

      final updated = LocationHelper.computeStoppageStatuses(stoppages, activeIndex: 1);

      expect(updated[0].status, equals(StoppageStatus.passed));
      expect(updated[1].status, equals(StoppageStatus.current));
      expect(updated[2].status, equals(StoppageStatus.upcoming));
    });

    test('Formats distance correctly in meters and kilometers', () {
      expect(LocationHelper.formatDistance(null), equals('N/A'));
      expect(LocationHelper.formatDistance(450.0), equals('450 m'));
      expect(LocationHelper.formatDistance(2500.0), equals('2.5 km'));
    });
  });
}
