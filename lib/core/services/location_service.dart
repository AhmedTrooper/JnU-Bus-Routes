import 'package:flutter/foundation.dart';
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
    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15, // Update when moving 15 meters
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 5), // Max update every 5 seconds
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15, // Update when moving 15 meters
        pauseLocationUpdatesAutomatically: true, // Auto-pause when stationary
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15,
      );
    }

    return Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (pos) => LatLng(pos.latitude, pos.longitude),
    ).handleError((error) {
      appLogger.e('Error in position stream: $error');
    });
  }
}
