import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/services/location_service.dart';
import 'package:jnu_bus_routes/core/widgets/shadcn_components.dart';
import 'package:jnu_bus_routes/features/bus_routes/data/models/bus_model.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/bus_enums.dart';

class BusCard extends StatelessWidget {
  final BusModel bus;
  final bool isFavorite;
  final bool isPrimary;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onSetPrimary;

  const BusCard({
    super.key,
    required this.bus,
    required this.isFavorite,
    this.isPrimary = false,
    required this.onToggleFavorite,
    this.onSetPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryTextColor = isDark ? AppColors.darkForeground : AppColors.lightForeground;
    final secondaryTextColor = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ShadcnCard(
        borderRadius: 16,
        borderColor: isPrimary
            ? AppColors.shadcnBlue
            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        onTap: () => context.push('/bus/${bus.id}'),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Circular Bus Badge Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkBorderActive : AppColors.lightBorderActive,
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.directions_bus_rounded,
                  color: primaryTextColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Bus Name & Route Destination
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          bus.busName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onToggleFavorite,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                            color: isFavorite ? AppColors.shadcnAmber : secondaryTextColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'To ${bus.lastStoppage}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ShadcnBadge(
                        label: bus.userType.englishLabel,
                        color: _getUserTypeColor(bus.userType),
                      ),
                      const SizedBox(width: 6),
                      ShadcnBadge(
                        label: bus.busType.englishLabel,
                        color: secondaryTextColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Schedule & Live Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  bus.upTime,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.shadcnBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Morning Up',
                  style: TextStyle(
                    fontSize: 10,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await LocationService.checkPermission();
                    if (context.mounted) {
                      context.push('/bus/${bus.id}/map?direction=up');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkForeground : AppColors.lightForeground,
                    foregroundColor: isDark ? AppColors.darkBackground : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Live', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getUserTypeColor(UserType type) {
    switch (type) {
      case UserType.student:
        return AppColors.shadcnEmerald;
      case UserType.teacherAndOfficer:
        return Colors.purpleAccent;
      case UserType.staff:
        return AppColors.shadcnAmber;
    }
  }
}
