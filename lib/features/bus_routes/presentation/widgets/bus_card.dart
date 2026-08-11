import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/features/bus_routes/data/models/bus_model.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/bus_enums.dart';

class BusCard extends StatelessWidget {
  final BusModel bus;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const BusCard({
    super.key,
    required this.bus,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.uberDarkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.uberBorder, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('/bus/${bus.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Bus Icon Badge
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.uberDarkElevated,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.uberBorder),
                ),
                child: const Center(
                  child: Icon(
                    Icons.directions_bus_filled_rounded,
                    color: AppColors.uberGold,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Bus Details (Name, Destination, Demographics)
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onToggleFavorite,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                              color: isFavorite ? AppColors.uberGold : AppColors.textMuted,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'To ${bus.lastStoppage}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildSmallPill(bus.userType.englishLabel, _getUserTypeColor(bus.userType)),
                        const SizedBox(width: 6),
                        _buildSmallPill(bus.busType.englishLabel, AppColors.textMuted),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Trip Schedule & Live Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    bus.upTime,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.uberBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text('Morning Up', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.push('/bus/${bus.id}/map?direction=up'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.uberBlue,
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
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
        return AppColors.uberGreen;
      case UserType.teacherAndOfficer:
        return Colors.purpleAccent;
      case UserType.staff:
        return Colors.orangeAccent;
    }
  }
}
