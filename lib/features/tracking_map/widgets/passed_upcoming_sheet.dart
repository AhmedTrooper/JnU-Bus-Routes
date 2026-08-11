import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/utils/location_helper.dart';
import 'package:jnu_bus_routes/core/widgets/shadcn_components.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryTextColor = isDark ? AppColors.darkForeground : AppColors.lightForeground;
    final secondaryTextColor = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;

    final currentStop = stoppages.firstWhere(
      (s) => s.status == StoppageStatus.current,
      orElse: () => stoppages.isNotEmpty
          ? stoppages.first
          : RouteStoppage(
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
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, -4)),
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
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Next Stop & Control Banner
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
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: AppColors.shadcnBlue,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentStop.placeName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ETA: Approx $nextDistance',
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onToggleDirection,
                  tooltip: 'Switch Trip Direction',
                  style: IconButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkMuted : AppColors.lightMuted,
                    foregroundColor: primaryTextColor,
                  ),
                  icon: const Icon(Icons.swap_vert_rounded, size: 20),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onToggleSimulation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSimulating ? AppColors.shadcnRose : AppColors.shadcnBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: Icon(isSimulating ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 16),
                  label: Text(
                    isSimulating ? 'Pause' : 'Live Sim',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

          // Route Timeline List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: stoppages.length,
              separatorBuilder: (context, index) {
                final isPassed = index < (stoppages.indexWhere((s) => s.status == StoppageStatus.current));
                return Container(
                  margin: const EdgeInsets.only(left: 35),
                  height: 14,
                  width: 1.5,
                  color: isPassed ? AppColors.shadcnEmerald : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkForeground : AppColors.lightForeground;
    final secondaryTextColor = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;

    Widget statusIndicator;
    String badgeLabel;
    Color badgeColor;

    switch (stop.status) {
      case StoppageStatus.passed:
        statusIndicator = Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(color: AppColors.shadcnEmerald, shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
        );
        badgeLabel = 'Passed';
        badgeColor = AppColors.shadcnEmerald;
        break;
      case StoppageStatus.current:
        statusIndicator = Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.shadcnAmber,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.radio_button_checked_rounded, color: Colors.white, size: 14),
          ),
        );
        badgeLabel = 'Next Stop';
        badgeColor = AppColors.shadcnAmber;
        break;
      case StoppageStatus.upcoming:
        statusIndicator = Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1.5,
            ),
          ),
        );
        badgeLabel = 'Upcoming';
        badgeColor = secondaryTextColor;
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
                      color: stop.status == StoppageStatus.passed ? secondaryTextColor : primaryTextColor,
                    ),
                  ),
                  if (stop.distanceInMeters != null)
                    Text(
                      LocationHelper.formatDistance(stop.distanceInMeters),
                      style: TextStyle(fontSize: 11, color: secondaryTextColor),
                    ),
                ],
              ),
            ),

            ShadcnBadge(
              label: badgeLabel,
              color: badgeColor,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 150.ms, delay: (index * 15).ms);
  }
}
