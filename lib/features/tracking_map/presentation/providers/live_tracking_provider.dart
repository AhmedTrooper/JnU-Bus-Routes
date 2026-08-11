import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:jnu_bus_routes/core/services/location_service.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/bus_enums.dart';

class LiveTrackingState {
  final LatLng? userLocation;
  final RouteDirection direction;
  final int activeStoppageIndex;
  final bool isSimulating;
  final double simulationProgress;

  LiveTrackingState({
    this.userLocation,
    this.direction = RouteDirection.up,
    this.activeStoppageIndex = 0,
    this.isSimulating = false,
    this.simulationProgress = 0.0,
  });

  LiveTrackingState copyWith({
    LatLng? userLocation,
    RouteDirection? direction,
    int? activeStoppageIndex,
    bool? isSimulating,
    double? simulationProgress,
  }) {
    return LiveTrackingState(
      userLocation: userLocation ?? this.userLocation,
      direction: direction ?? this.direction,
      activeStoppageIndex: activeStoppageIndex ?? this.activeStoppageIndex,
      isSimulating: isSimulating ?? this.isSimulating,
      simulationProgress: simulationProgress ?? this.simulationProgress,
    );
  }
}

class LiveTrackingNotifier extends StateNotifier<LiveTrackingState> {
  StreamSubscription<LatLng>? _locationSub;
  Timer? _simulationTimer;

  LiveTrackingNotifier() : super(LiveTrackingState()) {
    _initLocationStream();
  }

  void _initLocationStream() async {
    final initialPos = await LocationService.getCurrentPosition();
    if (initialPos != null) {
      state = state.copyWith(userLocation: initialPos);
    }

    _locationSub = LocationService.getPositionStream().listen((pos) {
      if (!state.isSimulating) {
        state = state.copyWith(userLocation: pos);
      }
    });
  }

  void toggleDirection() {
    final newDir = (state.direction == RouteDirection.up)
        ? RouteDirection.down
        : RouteDirection.up;
    state = state.copyWith(
      direction: newDir,
      activeStoppageIndex: 0,
      simulationProgress: 0.0,
    );
  }

  void setActiveStoppageIndex(int index) {
    state = state.copyWith(activeStoppageIndex: index);
  }

  void toggleSimulation(List<LatLng> polylinePoints, int totalStoppages) {
    if (state.isSimulating) {
      _simulationTimer?.cancel();
      state = state.copyWith(isSimulating: false);
    } else {
      if (polylinePoints.isEmpty) return;
      state = state.copyWith(isSimulating: true);

      _simulationTimer?.cancel();
      _simulationTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
        final nextProgress = state.simulationProgress + 0.05;
        if (nextProgress >= 1.0) {
          timer.cancel();
          state = state.copyWith(
            isSimulating: false,
            simulationProgress: 1.0,
            activeStoppageIndex: totalStoppages - 1,
          );
        } else {
          final polyIdx = (nextProgress * (polylinePoints.length - 1)).round().clamp(0, polylinePoints.length - 1);
          final simLoc = polylinePoints[polyIdx];
          final stopIdx = (nextProgress * (totalStoppages - 1)).round().clamp(0, totalStoppages - 1);

          state = state.copyWith(
            simulationProgress: nextProgress,
            userLocation: simLoc,
            activeStoppageIndex: stopIdx,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    _simulationTimer?.cancel();
    super.dispose();
  }
}

final liveTrackingProvider = StateNotifierProvider.family
    .autoDispose<LiveTrackingNotifier, LiveTrackingState, int>((ref, busId) {
  return LiveTrackingNotifier();
});
