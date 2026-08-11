import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/hive_service.dart';
import '../../../bus_routes/domain/models/bus_enums.dart';
import '../../../bus_routes/domain/models/route_stoppage.dart';
import '../../../bus_routes/presentation/providers/bus_providers.dart';
import '../providers/live_tracking_provider.dart';
import '../../widgets/passed_upcoming_sheet.dart';

class LiveMapScreen extends ConsumerStatefulWidget {
  final int busId;
  final RouteDirection initialDirection;

  const LiveMapScreen({
    super.key,
    required this.busId,
    this.initialDirection = RouteDirection.up,
  });

  @override
  ConsumerState<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends ConsumerState<LiveMapScreen> {
  final MapController _mapController = MapController();

  static final LatLng _dhakaDefaultCenter = LatLng(23.7087, 90.4118);

  @override
  Widget build(BuildContext context) {
    final liveState = ref.watch(liveTrackingProvider(widget.busId));
    final liveNotifier = ref.read(liveTrackingProvider(widget.busId).notifier);

    final busAsync = ref.watch(busDetailProvider(widget.busId));

    final polylineAsync = ref.watch(busRoutePolylineProvider((
      busId: widget.busId,
      direction: liveState.direction,
    )));

    final stoppagesAsync = ref.watch(busRouteStoppagesProvider((
      busId: widget.busId,
      direction: liveState.direction,
      userLocation: liveState.userLocation,
      activeIndex: liveState.activeStoppageIndex,
    )));

    final tileUrl = HiveService.customTileUrl;

    return Scaffold(
      appBar: AppBar(
        title: busAsync.when(
          data: (bus) => Text('${bus?.busName ?? 'Bus'} Map'),
          loading: () => const Text('Loading Map...'),
          error: (err, stack) => const Text('Live Map'),
        ),
        actions: [
          IconButton(
            icon: Icon(
              liveState.direction == RouteDirection.up
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: AppColors.accentGold,
            ),
            tooltip: 'Toggle Up/Down Direction',
            onPressed: () => liveNotifier.toggleDirection(),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: liveState.userLocation ?? _dhakaDefaultCenter,
              initialZoom: 13.5,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: tileUrl,
                userAgentPackageName: 'com.jnu.busroutes',
              ),

              polylineAsync.when(
                data: (points) {
                  if (points.isEmpty) return const SizedBox.shrink();
                  return PolylineLayer(
                    polylines: [
                      Polyline(
                        points: points,
                        strokeWidth: 5.0,
                        color: AppColors.accent,
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => const SizedBox.shrink(),
              ),

              stoppagesAsync.when(
                data: (stoppages) {
                  final markers = <Marker>[];

                  for (final stop in stoppages) {
                    if (stop.coordinates != null) {
                      markers.add(
                        Marker(
                          point: stop.coordinates!,
                          width: 40,
                          height: 40,
                          child: _buildStoppageMarker(stop),
                        ),
                      );
                    }
                  }

                  if (liveState.userLocation != null) {
                    markers.add(
                      Marker(
                        point: liveState.userLocation!,
                        width: 48,
                        height: 48,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 2)),
                            ],
                            border: Border.all(color: AppColors.accentGold, width: 3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/images/bus.png',
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.directions_bus_rounded, color: AppColors.accentGold);
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return MarkerLayer(markers: markers);
                },
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => const SizedBox.shrink(),
              ),
            ],
          ),

          Positioned(
            right: 16,
            top: 16,
            child: FloatingActionButton.small(
              heroTag: 'recenter_fab',
              backgroundColor: Theme.of(context).cardColor,
              foregroundColor: AppColors.accentGold,
              onPressed: () {
                final target = liveState.userLocation ?? _dhakaDefaultCenter;
                _mapController.move(target, 15.0);
              },
              child: const Icon(Icons.my_location_rounded),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.15,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return stoppagesAsync.when(
                data: (stoppages) {
                  final polylinePoints = polylineAsync.asData?.value ?? [];

                  return PassedUpcomingSheet(
                    stoppages: stoppages,
                    isSimulating: liveState.isSimulating,
                    onToggleDirection: () => liveNotifier.toggleDirection(),
                    onToggleSimulation: () => liveNotifier.toggleSimulation(polylinePoints, stoppages.length),
                    onSelectStoppage: (index) {
                      liveNotifier.setActiveStoppageIndex(index);
                      if (index >= 0 && index < stoppages.length) {
                        final coords = stoppages[index].coordinates;
                        if (coords != null) {
                          _mapController.move(coords, 15.0);
                        }
                      }
                    },
                  );
                },
                loading: () => Container(
                  color: Theme.of(context).cardColor,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => Container(
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $err'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoppageMarker(RouteStoppage stop) {
    Color color;
    IconData icon;

    switch (stop.status) {
      case StoppageStatus.passed:
        color = AppColors.passedStoppage;
        icon = Icons.check_circle_rounded;
        break;
      case StoppageStatus.current:
        color = AppColors.currentStoppage;
        icon = Icons.star_rounded;
        break;
      case StoppageStatus.upcoming:
        color = AppColors.upcomingStoppage;
        icon = Icons.location_on_rounded;
        break;
    }

    return Tooltip(
      message: '${stop.stoppageNo}. ${stop.placeName}',
      child: Container(
        decoration: BoxDecoration(
          color: color.withAlpha(220),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
