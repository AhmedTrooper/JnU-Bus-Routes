import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
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

    return Scaffold(
      backgroundColor: AppColors.pitchBlack,
      appBar: AppBar(
        backgroundColor: AppColors.pitchBlack,
        title: const Text('Route Stoppages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded, color: AppColors.uberGold),
            tooltip: 'Live Map',
            onPressed: () {
              final dirParam = (_direction == RouteDirection.up) ? 'up' : 'down';
              context.push('/bus/${widget.busId}/map?direction=$dirParam');
            },
          ),
        ],
      ),
      body: busAsync.when(
        data: (bus) {
          if (bus == null) {
            return const Center(child: Text('Bus not found', style: TextStyle(color: AppColors.textSecondary)));
          }

          return Column(
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.uberDarkCard,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.uberBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.uberDarkElevated,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.uberBorder),
                          ),
                          child: const Icon(Icons.directions_bus_filled_rounded, color: AppColors.uberGold, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bus.busName,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Terminal: ${bus.lastStoppage}',
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _infoTag(bus.userType.englishLabel, AppColors.uberGreen),
                        const SizedBox(width: 8),
                        _infoTag(bus.busType.englishLabel, AppColors.uberGold),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.uberBorder),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _timeCol('Up Trip Departure', bus.upTime, Icons.wb_sunny_rounded, AppColors.uberGold),
                        _timeCol('Down Trip Departure', bus.downTime, Icons.nights_stay_rounded, AppColors.uberBlue),
                      ],
                    ),
                  ],
                ),
              ),

              // Route Direction Switcher
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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

              // Timeline List
              Expanded(
                child: stoppagesAsync.when(
                  data: (stoppages) {
                    if (stoppages.isEmpty) {
                      return const Center(child: Text('No stoppages found', style: TextStyle(color: AppColors.textSecondary)));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      itemCount: stoppages.length,
                      separatorBuilder: (context, index) => Container(
                        margin: const EdgeInsets.only(left: 15),
                        height: 14,
                        width: 2,
                        color: AppColors.uberBorder,
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
                                color: isFirst ? AppColors.uberGreen : (isLast ? AppColors.uberRed : AppColors.uberDarkElevated),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.uberBorder),
                              ),
                              child: Center(
                                child: Text(
                                  '${stop.stoppageNo}',
                                  style: TextStyle(
                                    color: (isFirst || isLast) ? Colors.white : AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                stop.placeName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (isFirst)
                              _tag('START', AppColors.uberGreen)
                            else if (isLast)
                              _tag('TERMINAL', AppColors.uberRed),
                          ],
                        ).animate().fadeIn(duration: 150.ms, delay: (index * 15).ms);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.uberBlue)),
                  error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.uberBlue)),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.uberBlue,
        foregroundColor: Colors.white,
        onPressed: () {
          final dirParam = (_direction == RouteDirection.up) ? 'up' : 'down';
          context.push('/bus/${widget.busId}/map?direction=$dirParam');
        },
        icon: const Icon(Icons.navigation_rounded),
        label: const Text('Live Tracking', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _infoTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _timeCol(String label, String time, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}
