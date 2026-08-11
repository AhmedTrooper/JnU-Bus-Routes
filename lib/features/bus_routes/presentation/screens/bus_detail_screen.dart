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
      appBar: AppBar(
        title: const Text('Route & Stoppages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded, color: AppColors.accentGold),
            tooltip: 'Track Live on Map',
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
            return const Center(child: Text('Bus not found'));
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_bus_rounded, color: AppColors.accentGold, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            bus.busName,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _infoBadge(bus.userType.englishLabel, Colors.green),
                        const SizedBox(width: 8),
                        _infoBadge(bus.busType.englishLabel, AppColors.accentGold),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _timeText('Up Trip', bus.upTime, Icons.wb_sunny_rounded, Colors.amber),
                        _timeText('Down Trip', bus.downTime, Icons.nights_stay_rounded, Colors.blueAccent),
                        _timeText('Terminal', bus.lastStoppage, Icons.pin_drop_rounded, Colors.redAccent),
                      ],
                    ),
                  ],
                ),
              ),

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

              Expanded(
                child: stoppagesAsync.when(
                  data: (stoppages) {
                    if (stoppages.isEmpty) {
                      return const Center(
                        child: Text('No stoppages found for this route'),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      itemCount: stoppages.length,
                      separatorBuilder: (context, index) => Container(
                        margin: const EdgeInsets.only(left: 14),
                        height: 16,
                        width: 2,
                        color: Colors.grey.withAlpha(80),
                      ),
                      itemBuilder: (context, index) {
                        final stop = stoppages[index];
                        final isFirst = index == 0;
                        final isLast = index == stoppages.length - 1;

                        return Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: isFirst
                                    ? Colors.green
                                    : (isLast ? Colors.red : AppColors.accent),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${stop.stoppageNo}',
                                  style: const TextStyle(
                                    color: Colors.white,
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
                                ),
                              ),
                            ),
                            if (isFirst)
                              _labelTag('ORIGIN', Colors.green)
                            else if (isLast)
                              _labelTag('DESTINATION', Colors.red),
                          ],
                        ).animate().fadeIn(duration: 200.ms, delay: (index * 20).ms);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        onPressed: () {
          final dirParam = (_direction == RouteDirection.up) ? 'up' : 'down';
          context.push('/bus/${widget.busId}/map?direction=$dirParam');
        },
        icon: const Icon(Icons.navigation_rounded),
        label: const Text('Live Tracking'),
      ),
    );
  }

  Widget _infoBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _timeText(String label, String time, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 2),
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _labelTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}
