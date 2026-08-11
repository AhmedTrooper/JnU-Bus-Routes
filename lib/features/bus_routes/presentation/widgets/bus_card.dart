import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isPrimary
              ? AppColors.primaryRed
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isPrimary ? 2 : 1,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => context.push('/bus/${bus.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Circular Bus Badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withAlpha(20),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryRed.withAlpha(80), width: 1.5),
                ),
                child: const Center(
                  child: Icon(
                    Icons.directions_bus_filled_rounded,
                    color: AppColors.primaryRed,
                    size: 24,
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
                              fontWeight: FontWeight.bold,
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
                              color: isFavorite ? AppColors.accentGold : AppColors.textDarkSecondary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Terminal: ${bus.lastStoppage}',
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
                        _buildSmallPill(bus.userType.englishLabel, _getUserTypeColor(bus.userType)),
                        const SizedBox(width: 6),
                        _buildSmallPill(bus.busType.englishLabel, AppColors.accentBlue),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Times & Action Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    bus.upTime,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text('Morning Up', style: TextStyle(fontSize: 10, color: AppColors.textDarkSecondary)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.push('/bus/${bus.id}/map?direction=up'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Live', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Color _getUserTypeColor(UserType type) {
    switch (type) {
      case UserType.student:
        return AppColors.successGreen;
      case UserType.teacherAndOfficer:
        return Colors.purpleAccent;
      case UserType.staff:
        return Colors.orangeAccent;
    }
  }
}
