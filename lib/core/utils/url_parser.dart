import 'package:latlong2/latlong.dart';

abstract class UrlParser {
  /// Extract origin, waypoints, and destination as a continuous list of LatLng
  static List<LatLng> parseDirectionsUrl(String? urlString) {
    if (urlString == null || urlString.trim().isEmpty) return [];

    final List<LatLng> points = [];

    try {
      final uri = Uri.parse(urlString);
      final query = uri.queryParameters;

      // Parse origin
      final originStr = query['origin'];
      if (originStr != null) {
        final originPoint = _parseCoordString(originStr);
        if (originPoint != null) points.add(originPoint);
      }

      // Parse waypoints (separated by '|')
      final waypointsStr = query['waypoints'];
      if (waypointsStr != null) {
        final parts = waypointsStr.split('|');
        for (var part in parts) {
          final cleaned = part.replaceAll('via:', '').trim();
          final point = _parseCoordString(cleaned);
          if (point != null) points.add(point);
        }
      }

      // Parse destination
      final destStr = query['destination'];
      if (destStr != null) {
        final destPoint = _parseCoordString(destStr);
        if (destPoint != null) points.add(destPoint);
      }
    } catch (_) {
      // Gracefully handle malformed URLs
    }

    return points;
  }

  static LatLng? _parseCoordString(String coordStr) {
    final parts = coordStr.split(',');
    if (parts.length >= 2) {
      final lat = double.tryParse(parts[0].trim());
      final lng = double.tryParse(parts[1].trim());
      if (lat != null && lng != null) {
        return LatLng(lat, lng);
      }
    }
    return null;
  }
}
