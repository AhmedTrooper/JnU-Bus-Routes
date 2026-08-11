import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/location_helper.dart';
import '../../bus_routes/domain/models/route_stoppage.dart';

class PassedUpcomingSheet extends StatelessWidget {
  final List<RouteStoppage> stoppages;
  final VoidCallback onToggleDirection;
  final VoidCallback onToggleSimulation;
  final bool isSimulating;
  final Function(int index) onSelectStoppage;

  const PassedUpcomingSheet({
    super.key,
    required this.stoppages,
    required this.onToggleDirection,
    required this.onToggleSimulation,
    required this.isSimulating,
    required this.onSelectStoppage,
  });

  @override
  Widget build(BuildContext context) {
    final passedCount = stoppages.where((s) => s.status == StoppageStatus.passed).length;
    final upcomingCount = stoppages.where((s) => s.status == StoppageStatus.upcoming).length;
    final currentStop = stoppages.firstWhere(
      (s) => s.status == StoppageStatus.current,
      orElse: () => stoppages.isNotEmpty ? stoppages.first : RouteStoppage(
        stoppageNo: 0,
        placeId: 0,
        placeName: 'None',
        direction: stoppages.first.direction,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, -4)),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(100),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header summary & control buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.my_location_rounded, size: 16, color: AppColors.accentGold),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              currentStop.placeName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Passed: $passedCount  •  Upcoming: $upcomingCount',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: onToggleDirection,
                  tooltip: 'Switch Up / Down Route',
                  icon: const Icon(Icons.swap_vert_rounded),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onToggleSimulation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSimulating ? AppColors.dangerRed : AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: Icon(isSimulating ? Icons.stop_rounded : Icons.play_arrow_rounded, size: 18),
                  label: Text(isSimulating ? 'Pause' : 'Live Sim'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Timeline List of Passed, Current, and Upcoming Stoppages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: stoppages.length,
              itemBuilder: (context, index) {
                final stop = stoppages[index];
                return _buildStoppageTile(context, stop, index, stoppages.length);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoppageTile(
    BuildContext context,
    RouteStoppage stop,
    int index,
    int totalCount,
  ) {
    Color iconColor;
    IconData iconData;
    String statusText;

    switch (stop.status) {
      case StoppageStatus.passed:
        iconColor = AppColors.passedStoppage;
        iconData = Icons.check_circle_rounded;
        statusText = 'PASSED';
        break;
      case StoppageStatus.current:
        iconColor = AppColors.currentStoppage;
        iconData = Icons.radio_button_checked_rounded;
        statusText = 'NEXT / CURRENT';
        break;
      case StoppageStatus.upcoming:
        iconColor = AppColors.upcomingStoppage;
        iconData = Icons.circle_outlined;
        statusText = 'UPCOMING';
        break;
    }

    return InkWell(
      onTap: () => onSelectStoppage(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            // Sequence Number
            SizedBox(
              width: 24,
              child: Text(
                '#${stop.stoppageNo}',
                style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),

            // Timeline Icon & Line
            Column(
              children: [
                Icon(iconData, color: iconColor, size: 20),
              ],
            ),
            const SizedBox(width: 14),

            // Stoppage Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.placeName,
                    style: TextStyle(
                      fontWeight: stop.status == StoppageStatus.current ? FontWeight.bold : FontWeight.w500,
                      fontSize: stop.status == StoppageStatus.current ? 15 : 14,
                      color: stop.status == StoppageStatus.passed
                          ? Colors.grey
                          : (stop.status == StoppageStatus.current ? AppColors.accentGold : null),
                    ),
                  ),
                  if (stop.distanceInMeters != null)
                    Text(
                      'Distance: ${LocationHelper.formatDistance(stop.distanceInMeters)}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                ],
              ),
            ),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: iconColor.withAlpha(80)),
              ),
              child: Text(
                statusText,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: iconColor),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms, delay: (index * 20).ms);
  }
}
