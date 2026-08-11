import 'package:latlong2/latlong.dart';
import '../../features/bus_routes/data/models/bus_model.dart';
import '../../features/bus_routes/domain/models/bus_enums.dart';
import 'url_parser.dart';

class RecommendedRouteResult {
  final RouteDirection suggestedDirection;
  final String recommendationReason;
  final List<BusModel> recommendedBuses;

  RecommendedRouteResult({
    required this.suggestedDirection,
    required this.recommendationReason,
    required this.recommendedBuses,
  });
}

abstract class RecommendationEngine {
  static const Distance _distanceCalculator = Distance();

  /// Analyzes current time of day, user location, and preferences to recommend routes
  static RecommendedRouteResult getSmartRecommendations({
    required List<BusModel> allBuses,
    required List<int> favoriteBusIds,
    required List<String> recentSearches,
    LatLng? userLocation,
    DateTime? currentTime,
  }) {
    final now = currentTime ?? DateTime.now();
    final hour = now.hour;

    RouteDirection suggestedDirection;
    String reason;

    if (hour < 13) {
      suggestedDirection = RouteDirection.up;
      reason = 'Morning commute: Campus-bound (Up Trip)';
    } else {
      suggestedDirection = RouteDirection.down;
      reason = 'Afternoon commute: Home-bound (Down Trip)';
    }

    if (userLocation != null) {
      reason += ' • Near your location';
    }

    final Map<BusModel, double> busScores = {};

    for (final bus in allBuses) {
      double score = 0.0;

      // Bonus for Favorites
      if (favoriteBusIds.contains(bus.id)) {
        score += 100.0;
      }

      // Bonus for Recent Searches
      for (final query in recentSearches) {
        if (query.trim().isNotEmpty &&
            (bus.busName.toLowerCase().contains(query.toLowerCase()) ||
                bus.lastStoppage.toLowerCase().contains(query.toLowerCase()))) {
          score += 50.0;
          break;
        }
      }

      // Proximity score if user location is available
      if (userLocation != null) {
        final dirUrl = (suggestedDirection == RouteDirection.up) ? bus.upDirUrl : bus.downDirUrl;
        final waypoints = UrlParser.parseDirectionsUrl(dirUrl);
        if (waypoints.isNotEmpty) {
          double minDistance = double.infinity;
          for (final point in waypoints) {
            final dist = _distanceCalculator.as(LengthUnit.Meter, userLocation, point);
            if (dist < minDistance) {
              minDistance = dist;
            }
          }
          // Closer routes get higher score (max 40 pts for < 1km)
          if (minDistance < 5000) {
            score += (5000 - minDistance) / 100.0;
          }
        }
      }

      busScores[bus] = score;
    }

    final sortedBuses = allBuses.toList()
      ..sort((a, b) => (busScores[b] ?? 0.0).compareTo(busScores[a] ?? 0.0));

    return RecommendedRouteResult(
      suggestedDirection: suggestedDirection,
      recommendationReason: reason,
      recommendedBuses: sortedBuses.take(6).toList(),
    );
  }
}
