import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/database/hive_service.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/bus_enums.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/route_stoppage.dart';
import 'package:jnu_bus_routes/features/bus_routes/presentation/providers/bus_providers.dart';
import 'package:jnu_bus_routes/features/tracking_map/presentation/providers/live_tracking_provider.dart';
import 'package:jnu_bus_routes/features/tracking_map/widgets/passed_upcoming_sheet.dart';

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
      backgroundColor: AppColors.pitchBlack,
      body: Stack(
        children: [
          // CartoDB Dark Base Map Layer
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

              // Uber Signature Electric Blue Polyline Layer
              polylineAsync.when(
                data: (points) {
                  if (points.isEmpty) return const SizedBox.shrink();
                  return PolylineLayer(
                    polylines: [
                      Polyline(
                        points: points,
                        strokeWidth: 5.0,
                        color: AppColors.uberBlue,
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => const SizedBox.shrink(),
              ),

              // Marker Layer for Stoppages & Live Vehicle Marker
              stoppagesAsync.when(
                data: (stoppages) {
                  final markers = <Marker>[];

                  for (final stop in stoppages) {
                    if (stop.coordinates != null) {
                      markers.add(
                        Marker(
                          point: stop.coordinates!,
                          width: 32,
                          height: 32,
                          child: _buildUberStoppageMarker(stop),
                        ),
                      );
                    }
                  }

                  if (liveState.userLocation != null) {
                    markers.add(
                      Marker(
                        point: liveState.userLocation!,
                        width: 50,
                        height: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.uberDarkCard,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.uberGold, width: 3),
                            boxShadow: [
                              BoxShadow(color: AppColors.uberGold.withAlpha(120), blurRadius: 12, spreadRadius: 2),
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.directions_bus_filled_rounded, color: AppColors.uberGold, size: 24),
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

          // Uber Top Header Bar (Back button & Bus name title)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.uberDarkCard.withAlpha(240),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.uberDarkCard.withAlpha(240),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.uberBorder),
                      ),
                      child: busAsync.when(
                        data: (bus) => Row(
                          children: [
                            const Icon(Icons.directions_bus_rounded, color: AppColors.uberGold, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                bus?.busName ?? 'Live Tracking',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        loading: () => const Text('Loading...', style: TextStyle(color: AppColors.textSecondary)),
                        error: (_, __) => const Text('Live Tracking', style: TextStyle(color: AppColors.textPrimary)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor: AppColors.uberDarkCard.withAlpha(240),
                    child: IconButton(
                      icon: const Icon(Icons.my_location_rounded, color: AppColors.uberGold),
                      onPressed: () {
                        final target = liveState.userLocation ?? _dhakaDefaultCenter;
                        _mapController.move(target, 15.0);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Uber Bottom Sheet for Passed/Upcoming Stoppages
          DraggableScrollableSheet(
            initialChildSize: 0.38,
            minChildSize: 0.16,
            maxChildSize: 0.88,
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
                  color: AppColors.uberDarkCard,
                  child: const Center(child: CircularProgressIndicator(color: AppColors.uberBlue)),
                ),
                error: (err, stack) => Container(
                  color: AppColors.uberDarkCard,
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUberStoppageMarker(RouteStoppage stop) {
    Color color;

    switch (stop.status) {
      case StoppageStatus.passed:
        color = AppColors.uberGreen;
        break;
      case StoppageStatus.current:
        color = AppColors.uberGold;
        break;
      case StoppageStatus.upcoming:
        color = AppColors.textMuted;
        break;
    }

    return Tooltip(
      message: '${stop.stoppageNo}. ${stop.placeName}',
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.uberDarkCard,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: stop.status == StoppageStatus.current ? 3 : 2),
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
