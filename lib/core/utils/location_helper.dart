import 'package:latlong2/latlong.dart';
import '../../features/bus_routes/domain/models/route_stoppage.dart';

abstract class LocationHelper {
  static const Distance _distanceCalculator = Distance();

  /// Assign coordinates to stoppages based on available route waypoints
  static List<RouteStoppage> attachCoordinatesToStoppages(
    List<RouteStoppage> stoppages,
    List<LatLng> routePoints,
  ) {
    if (stoppages.isEmpty) return stoppages;
    if (routePoints.isEmpty) return stoppages;

    final updated = <RouteStoppage>[];
    final totalStoppages = stoppages.length;
    final totalPoints = routePoints.length;

    for (int i = 0; i < totalStoppages; i++) {
      final stop = stoppages[i];
      LatLng assignedPoint;

      if (i == 0) {
        assignedPoint = routePoints.first;
      } else if (i == totalStoppages - 1) {
        assignedPoint = routePoints.last;
      } else {
        // Linearly map stoppage index to route point index
        final targetIndex = ((i / (totalStoppages - 1)) * (totalPoints - 1)).round();
        final safeIndex = targetIndex.clamp(0, totalPoints - 1);
        assignedPoint = routePoints[safeIndex];
      }

      updated.add(stop.copyWith(coordinates: assignedPoint));
    }

    return updated;
  }

  /// Calculate passed, current, and upcoming stoppages relative to current position or index
  static List<RouteStoppage> computeStoppageStatuses(
    List<RouteStoppage> stoppages, {
    LatLng? userLocation,
    int? activeIndex,
  }) {
    if (stoppages.isEmpty) return stoppages;

    // If explicit active index is provided
    int currentIdx = activeIndex ?? 0;

    // If user location is provided, find the closest stoppage index
    if (userLocation != null) {
      double minDistance = double.infinity;
      for (int i = 0; i < stoppages.length; i++) {
        final coords = stoppages[i].coordinates;
        if (coords != null) {
          final dist = _distanceCalculator.as(LengthUnit.Meter, userLocation, coords);
          if (dist < minDistance) {
            minDistance = dist;
            currentIdx = i;
          }
        }
      }
    }

    final result = <RouteStoppage>[];
    for (int i = 0; i < stoppages.length; i++) {
      final stop = stoppages[i];
      double? distToUser;

      if (userLocation != null && stop.coordinates != null) {
        distToUser = _distanceCalculator.as(LengthUnit.Meter, userLocation, stop.coordinates!);
      }

      StoppageStatus status;
      if (i < currentIdx) {
        status = StoppageStatus.passed;
      } else if (i == currentIdx) {
        status = StoppageStatus.current;
      } else {
        status = StoppageStatus.upcoming;
      }

      result.add(stop.copyWith(
        distanceInMeters: distToUser,
        status: status,
      ));
    }

    return result;
  }

  /// Formats distance in meters to a human-readable string (m or km)
  static String formatDistance(double? distanceInMeters) {
    if (distanceInMeters == null) return 'N/A';
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    }
    final km = distanceInMeters / 1000;
    return '${km.toStringAsFixed(1)} km';
  }
}
