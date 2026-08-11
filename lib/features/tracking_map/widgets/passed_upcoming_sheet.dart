import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/utils/location_helper.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/route_stoppage.dart';

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
    final currentStop = stoppages.firstWhere(
      (s) => s.status == StoppageStatus.current,
      orElse: () => stoppages.isNotEmpty ? stoppages.first : RouteStoppage(
        stoppageNo: 0,
        placeId: 0,
        placeName: 'Terminal',
        direction: stoppages.isNotEmpty ? stoppages.first.direction : RouteStoppage(stoppageNo: 0, placeId: 0, placeName: '', direction: stoppages.first.direction).direction,
      ),
    );

    final nextDistance = currentStop.distanceInMeters != null
        ? LocationHelper.formatDistance(currentStop.distanceInMeters)
        : '2.5 km away';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.uberDarkCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: AppColors.uberBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 24, offset: Offset(0, -8)),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle Bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.uberBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Uber Next Stop & Control Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NEXT STOPPAGE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: AppColors.uberBlue,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentStop.placeName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ETA: Approx $nextDistance',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onToggleDirection,
                  tooltip: 'Switch Trip Direction',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.uberDarkElevated,
                    foregroundColor: AppColors.textPrimary,
                  ),
                  icon: const Icon(Icons.swap_vert_rounded, size: 20),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onToggleSimulation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSimulating ? AppColors.uberRed : AppColors.uberBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  icon: Icon(isSimulating ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 16),
                  label: Text(isSimulating ? 'Pause' : 'Live Sim', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.uberBorder),

          // Uber Route Timeline List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: stoppages.length,
              separatorBuilder: (context, index) {
                final isPassed = index < (stoppages.indexWhere((s) => s.status == StoppageStatus.current));
                return Container(
                  margin: const EdgeInsets.only(left: 35),
                  height: 14,
                  width: 2,
                  color: isPassed ? AppColors.uberGreen : AppColors.uberBorder,
                );
              },
              itemBuilder: (context, index) {
                final stop = stoppages[index];
                return _buildTimelineItem(context, stop, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, RouteStoppage stop, int index) {
    Widget statusIndicator;
    String badgeLabel;
    Color badgeColor;

    switch (stop.status) {
      case StoppageStatus.passed:
        statusIndicator = Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(color: AppColors.uberGreen, shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
        );
        badgeLabel = 'Passed';
        badgeColor = AppColors.uberGreen;
        break;
      case StoppageStatus.current:
        statusIndicator = Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.uberGold,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: AppColors.uberGold.withAlpha(120), blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: const Center(
            child: Icon(Icons.radio_button_checked_rounded, color: AppColors.pitchBlack, size: 14),
          ),
        );
        badgeLabel = 'Next Stop';
        badgeColor = AppColors.uberGold;
        break;
      case StoppageStatus.upcoming:
        statusIndicator = Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.uberDarkElevated,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.uberBorder, width: 2),
          ),
        );
        badgeLabel = 'Upcoming';
        badgeColor = AppColors.textMuted;
        break;
    }

    return InkWell(
      onTap: () => onSelectStoppage(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            statusIndicator,
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.placeName,
                    style: TextStyle(
                      fontSize: stop.status == StoppageStatus.current ? 16 : 14,
                      fontWeight: stop.status == StoppageStatus.current ? FontWeight.bold : FontWeight.w500,
                      color: stop.status == StoppageStatus.passed ? AppColors.textMuted : AppColors.textPrimary,
                    ),
                  ),
                  if (stop.distanceInMeters != null)
                    Text(
                      LocationHelper.formatDistance(stop.distanceInMeters),
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: badgeColor.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeLabel,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 150.ms, delay: (index * 15).ms);
  }
}
