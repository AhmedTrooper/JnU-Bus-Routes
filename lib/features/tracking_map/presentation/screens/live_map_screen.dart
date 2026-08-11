import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/database/hive_service.dart';
import 'package:jnu_bus_routes/core/widgets/glass_card.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      body: Stack(
        children: [
          // Base Map Layer
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

              // Polyline Layer
              polylineAsync.when(
                data: (points) {
                  if (points.isEmpty) return const SizedBox.shrink();
                  return PolylineLayer(
                    polylines: [
                      Polyline(
                        points: points,
                        strokeWidth: 4.5,
                        color: AppColors.appleBlue,
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => const SizedBox.shrink(),
              ),

              // Marker Layer
              stoppagesAsync.when(
                data: (stoppages) {
                  final markers = <Marker>[];

                  for (final stop in stoppages) {
                    if (stop.coordinates != null) {
                      markers.add(
                        Marker(
                          point: stop.coordinates!,
                          width: 28,
                          height: 28,
                          child: _buildAppleStoppageMarker(context, stop),
                        ),
                      );
                    }
                  }

                  if (liveState.userLocation != null) {
                    markers.add(
                      Marker(
                        point: liveState.userLocation!,
                        width: 44,
                        height: 44,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.appleBlue, width: 3),
                            boxShadow: [
                              BoxShadow(color: AppColors.appleBlue.withAlpha(80), blurRadius: 10, spreadRadius: 1),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.directions_bus_rounded,
                              color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                              size: 20,
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

          // Floating Glass Top Navigation Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GlassCard(
                    borderRadius: 24,
                    padding: const EdgeInsets.all(4),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: GlassCard(
                      borderRadius: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: busAsync.when(
                        data: (bus) => Row(
                          children: [
                            Icon(Icons.directions_bus_rounded, color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                bus?.busName ?? 'Live Tracking',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        loading: () => Text('Loading...', style: TextStyle(color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary)),
                        error: (_, __) => Text('Live Tracking', style: TextStyle(color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  GlassCard(
                    borderRadius: 24,
                    padding: const EdgeInsets.all(4),
                    child: IconButton(
                      icon: const Icon(Icons.my_location_rounded, color: AppColors.appleBlue),
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

          // Floating Glass Bottom Sheet
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
                loading: () => GlassCard(
                  child: const Center(child: CircularProgressIndicator(color: AppColors.appleBlue)),
                ),
                error: (err, stack) => GlassCard(
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

  Widget _buildAppleStoppageMarker(BuildContext context, RouteStoppage stop) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color color;

    switch (stop.status) {
      case StoppageStatus.passed:
        color = AppColors.appleGreen;
        break;
      case StoppageStatus.current:
        color = AppColors.appleOrange;
        break;
      case StoppageStatus.upcoming:
        color = isDark ? AppColors.textDarkMuted : AppColors.textLightMuted;
        break;
    }

    return Tooltip(
      message: '${stop.stoppageNo}. ${stop.placeName}',
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: stop.status == StoppageStatus.current ? 2.5 : 1.5),
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
