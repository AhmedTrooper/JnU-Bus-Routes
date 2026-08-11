import 'package:flutter_test/flutter_test.dart';
import 'package:jnu_bus_routes/core/utils/url_parser.dart';

void main() {
  group('UrlParser Tests', () {
    test('Parses origin, waypoints, and destination from Google Maps Directions URL', () {
      const url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=23.714850,90.430975&destination=23.708735,90.411804&mode=driving&waypoints=via:23.731247,90.428440|via:23.732348,90.425117&alternatives=false&key=';

      final points = UrlParser.parseDirectionsUrl(url);

      expect(points.length, equals(4));
      expect(points[0].latitude, equals(23.714850));
      expect(points[0].longitude, equals(90.430975));
      expect(points[1].latitude, equals(23.731247));
      expect(points[2].latitude, equals(23.732348));
      expect(points[3].latitude, equals(23.708735));
    });

    test('Handles null or invalid URL gracefully', () {
      final nullPoints = UrlParser.parseDirectionsUrl(null);
      expect(nullPoints, isEmpty);

      final emptyPoints = UrlParser.parseDirectionsUrl('');
      expect(emptyPoints, isEmpty);

      final invalidPoints = UrlParser.parseDirectionsUrl('not_a_valid_url');
      expect(invalidPoints, isEmpty);
    });
  });
}
