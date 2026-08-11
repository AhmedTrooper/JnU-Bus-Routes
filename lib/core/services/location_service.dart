import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:jnu_bus_routes/core/utils/app_logger.dart';

class LocationService {
  static Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      appLogger.w('Location services are disabled.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      appLogger.i('Requesting location permission...');
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        appLogger.w('Location permission denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      appLogger.w('Location permission denied forever.');
      return false;
    }
    
    appLogger.i('Location permission granted.');
    return true;
  }

  static Future<LatLng?> getCurrentPosition() async {
    final hasPermission = await checkPermission();
    if (!hasPermission) return null;

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      return LatLng(pos.latitude, pos.longitude);
    } catch (e) {
      appLogger.e('Error getting current position: $e');
      return null;
    }
  }

  static Stream<LatLng> getPositionStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // update every 5 meters
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (pos) => LatLng(pos.latitude, pos.longitude),
    ).handleError((error) {
      appLogger.e('Error in position stream: $error');
    });
  }
}
