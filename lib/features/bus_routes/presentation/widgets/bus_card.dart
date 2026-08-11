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
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isVerySmall = constraints.maxWidth < 280;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push('/bus/${bus.id}'),
            child: Padding(
              padding: EdgeInsets.all(isVerySmall ? 8.0 : 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(isVerySmall ? 6 : 8),
                              decoration: BoxDecoration(
                                color: AppColors.accentGold.withAlpha(30),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.directions_bus_rounded,
                                color: AppColors.accentGold,
                                size: isVerySmall ? 18 : 22,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                bus.busName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isVerySmall ? 14 : 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        icon: Icon(
                          isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                          color: isFavorite ? Colors.amber : Colors.grey,
                          size: isVerySmall ? 20 : 24,
                        ),
                        onPressed: onToggleFavorite,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _buildChip(
                        label: isVerySmall ? bus.userType.englishLabel : '${bus.userType.englishLabel} (${bus.userType.bnLabel})',
                        color: _getUserTypeColor(bus.userType),
                      ),
                      _buildChip(
                        label: bus.busType.englishLabel,
                        color: _getBusTypeColor(bus.busType),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeInfo(
                          icon: Icons.wb_sunny_rounded,
                          label: 'Up Trip',
                          time: bus.upTime,
                          color: Colors.orangeAccent,
                          isVerySmall: isVerySmall,
                        ),
                      ),
                      Expanded(
                        child: _buildTimeInfo(
                          icon: Icons.nights_stay_rounded,
                          label: 'Down Trip',
                          time: bus.downTime,
                          color: Colors.blueAccent,
                          isVerySmall: isVerySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Term: ${bus.lastStoppage}',
                          style: TextStyle(fontSize: isVerySmall ? 11 : 12, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/bus/${bus.id}/map?direction=up'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.accent,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.map_rounded, size: 14),
                            SizedBox(width: 4),
                            Text('Live', style: TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(90), width: 1),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTimeInfo({
    required IconData icon,
    required String label,
    required String time,
    required Color color,
    required bool isVerySmall,
  }) {
    return Row(
      children: [
        Icon(icon, size: isVerySmall ? 12 : 14, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              Text(
                time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: isVerySmall ? 11 : 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getUserTypeColor(UserType type) {
    switch (type) {
      case UserType.student:
        return Colors.green;
      case UserType.teacherAndOfficer:
        return Colors.purpleAccent;
      case UserType.staff:
        return Colors.orangeAccent;
    }
  }

  Color _getBusTypeColor(BusType type) {
    switch (type) {
      case BusType.singleDecker:
        return Colors.blue;
      case BusType.doubleDecker:
        return AppColors.accentGold;
      case BusType.acOrSpecial:
        return Colors.tealAccent;
    }
  }
}
