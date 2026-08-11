import 'package:latlong2/latlong.dart';
import 'bus_enums.dart';

enum StoppageStatus { passed, current, upcoming }

class RouteStoppage {
  final int stoppageNo;
  final int placeId;
  final String placeName;
  final LatLng? coordinates;
  final RouteDirection direction;
  final double? distanceInMeters;
  final StoppageStatus status;

  RouteStoppage({
    required this.stoppageNo,
    required this.placeId,
    required this.placeName,
    this.coordinates,
    required this.direction,
    this.distanceInMeters,
    this.status = StoppageStatus.upcoming,
  });

  RouteStoppage copyWith({
    int? stoppageNo,
    int? placeId,
    String? placeName,
    LatLng? coordinates,
    RouteDirection? direction,
    double? distanceInMeters,
    StoppageStatus? status,
  }) {
    return RouteStoppage(
      stoppageNo: stoppageNo ?? this.stoppageNo,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
      coordinates: coordinates ?? this.coordinates,
      direction: direction ?? this.direction,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
      status: status ?? this.status,
    );
  }
}
