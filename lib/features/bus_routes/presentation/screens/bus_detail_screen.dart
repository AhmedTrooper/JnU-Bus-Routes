import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/services/location_service.dart';
import 'package:jnu_bus_routes/core/widgets/glass_card.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/bus_enums.dart';
import 'package:jnu_bus_routes/features/bus_routes/presentation/providers/bus_providers.dart';

class BusDetailScreen extends ConsumerStatefulWidget {
  final int busId;

  const BusDetailScreen({super.key, required this.busId});

  @override
  ConsumerState<BusDetailScreen> createState() => _BusDetailScreenState();
}

class _BusDetailScreenState extends ConsumerState<BusDetailScreen> {
  RouteDirection _direction = RouteDirection.up;

  @override
  Widget build(BuildContext context) {
    final busAsync = ref.watch(busDetailProvider(widget.busId));
    final stoppagesAsync = ref.watch(
      busRouteStoppagesProvider((
        busId: widget.busId,
        direction: _direction,
        userLocation: null,
        activeIndex: null,
      )),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Stoppages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded, color: AppColors.appleBlue),
            tooltip: 'Live Map',
            onPressed: () async {
              await LocationService.checkPermission();
              if (context.mounted) {
                final dirParam = (_direction == RouteDirection.up) ? 'up' : 'down';
                context.push('/bus/${widget.busId}/map?direction=$dirParam');
              }
            },
          ),
        ],
      ),
      body: busAsync.when(
        data: (bus) {
          if (bus == null) {
            return const Center(child: Text('Bus not found'));
          }

          return Column(
            children: [
              // Glass Header Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkGlassElevated : AppColors.lightGlassElevated,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
                                width: 0.5,
                              ),
                            ),
                            child: Icon(
                              Icons.directions_bus_rounded,
                              color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bus.busName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.4,
                                    color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Terminal: ${bus.lastStoppage}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _infoTag(bus.userType.englishLabel, AppColors.appleGreen),
                          const SizedBox(width: 8),
                          _infoTag(bus.busType.englishLabel, isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Divider(height: 1, color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _timeCol(context, 'Up Trip (Morning)', bus.upTime, Icons.wb_sunny_rounded, AppColors.appleOrange),
                          _timeCol(context, 'Down Trip (Afternoon)', bus.downTime, Icons.nights_stay_rounded, AppColors.appleBlue),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Route Direction Switcher
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: SegmentedButton<RouteDirection>(
                  segments: const [
                    ButtonSegment(
                      value: RouteDirection.up,
                      label: Text('Up Route (Morning)'),
                      icon: Icon(Icons.arrow_upward_rounded),
                    ),
                    ButtonSegment(
                      value: RouteDirection.down,
                      label: Text('Down Route (Afternoon)'),
                      icon: Icon(Icons.arrow_downward_rounded),
                    ),
                  ],
                  selected: {_direction},
                  onSelectionChanged: (set) {
                    setState(() {
                      _direction = set.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),

              // Stoppage Timeline List
              Expanded(
                child: stoppagesAsync.when(
                  data: (stoppages) {
                    if (stoppages.isEmpty) {
                      return const Center(child: Text('No stoppages found'));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      itemCount: stoppages.length,
                      separatorBuilder: (context, index) => Container(
                        margin: const EdgeInsets.only(left: 15),
                        height: 14,
                        width: 1.5,
                        color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
                      ),
                      itemBuilder: (context, index) {
                        final stop = stoppages[index];
                        final isFirst = index == 0;
                        final isLast = index == stoppages.length - 1;

                        return Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isFirst
                                    ? AppColors.appleGreen
                                    : (isLast ? AppColors.appleRed : (isDark ? AppColors.darkGlassElevated : AppColors.lightGlassElevated)),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${stop.stoppageNo}',
                                  style: TextStyle(
                                    color: (isFirst || isLast) ? Colors.white : (isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                stop.placeName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                                ),
                              ),
                            ),
                            if (isFirst)
                              _tag('START', AppColors.appleGreen)
                            else if (isLast)
                              _tag('TERMINAL', AppColors.appleRed),
                          ],
                        ).animate().fadeIn(duration: 150.ms, delay: (index * 15).ms);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.appleBlue)),
                  error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.appleBlue)),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.appleBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        onPressed: () async {
          await LocationService.checkPermission();
          if (context.mounted) {
            final dirParam = (_direction == RouteDirection.up) ? 'up' : 'down';
            context.push('/bus/${widget.busId}/map?direction=$dirParam');
          }
        },
        icon: const Icon(Icons.navigation_rounded),
        label: const Text('Live Tracking', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _infoTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 11),
      ),
    );
  }

  Widget _timeCol(BuildContext context, String label, String time, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary)),
            Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 10),
      ),
    );
  }
}
