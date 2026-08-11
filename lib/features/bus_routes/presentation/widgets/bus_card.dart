import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/widgets/glass_card.dart';
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: GlassCard(
        borderRadius: 22,
        customBorderColor: isPrimary
            ? AppColors.appleBlue
            : (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder),
        onTap: () => context.push('/bus/${bus.id}'),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Circular Bus Icon Badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkGlassElevated : AppColors.lightGlassElevated,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.directions_bus_rounded,
                  color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
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
                            color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onToggleFavorite,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                            color: isFavorite ? AppColors.appleOrange : AppColors.textDarkMuted,
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
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildApplePill(bus.userType.englishLabel, _getUserTypeColor(bus.userType)),
                      const SizedBox(width: 6),
                      _buildApplePill(bus.busType.englishLabel, isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Schedule & Live Action Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  bus.upTime,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.appleBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Morning Up',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.push('/bus/${bus.id}/map?direction=up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appleBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  Widget _buildApplePill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Color _getUserTypeColor(UserType type) {
    switch (type) {
      case UserType.student:
        return AppColors.appleGreen;
      case UserType.teacherAndOfficer:
        return Colors.purpleAccent;
      case UserType.staff:
        return AppColors.appleOrange;
    }
  }
}
