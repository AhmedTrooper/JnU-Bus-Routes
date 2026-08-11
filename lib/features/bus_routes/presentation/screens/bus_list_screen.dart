import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/database/hive_service.dart';
import 'package:jnu_bus_routes/core/utils/recommendation_engine.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/bus_enums.dart';
import 'package:jnu_bus_routes/features/bus_routes/presentation/providers/bus_providers.dart';
import 'package:jnu_bus_routes/features/bus_routes/presentation/widgets/bus_card.dart';

class BusListScreen extends ConsumerWidget {
  const BusListScreen({super.key});

  static final LatLng _dhakaCenter = LatLng(23.7087, 90.4118);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busesAsync = ref.watch(filteredBusesProvider);
    final allBusesAsync = ref.watch(allBusesProvider);
    final selectedFilter = ref.watch(selectedUserTypeFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final favorites = ref.watch(favoritesProvider);
    final recentSearches = HiveService.recentSearches;
    final tileUrl = HiveService.customTileUrl;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Uber Base Dark Map View
          FlutterMap(
            options: MapOptions(
              initialCenter: _dhakaCenter,
              initialZoom: 13.0,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: tileUrl,
                userAgentPackageName: 'com.jnu.busroutes',
              ),
            ],
          ),

          // 2. Uber Floating Top Search Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Floating "Where to?" Search Card
                  GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.uberDarkCard.withAlpha(240),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.uberBorder),
                        boxShadow: const [
                          BoxShadow(color: Colors.black45, blurRadius: 16, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search_rounded, color: AppColors.uberGold, size: 22),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Where to? (Search bus or stoppage)',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(Icons.tune_rounded, color: AppColors.textMuted, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Quick Action Chips Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _quickChip(
                          icon: Icons.school_rounded,
                          label: 'JnU Campus',
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = 'Jagannath';
                            context.push('/search');
                          },
                        ),
                        const SizedBox(width: 8),
                        _quickChip(
                          icon: Icons.place_rounded,
                          label: 'Jatrabari',
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = 'Jatrabari';
                            context.push('/search');
                          },
                        ),
                        const SizedBox(width: 8),
                        _quickChip(
                          icon: Icons.star_rounded,
                          label: 'Favorites (${favorites.length})',
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = '';
                            ref.read(selectedUserTypeFilterProvider.notifier).state = null;
                          },
                        ),
                        const SizedBox(width: 8),
                        _quickChip(
                          icon: Icons.settings_rounded,
                          label: 'Settings',
                          onTap: () => context.push('/settings'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Uber Floating Bottom Bus Selection Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.25,
            maxChildSize: 0.90,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.uberDarkCard,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: const [
                    BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, -6)),
                  ],
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Handle Bar & Title
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 8),
                              width: 36,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.uberBorder,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Select Bus Route',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.refresh_rounded, color: AppColors.textMuted, size: 20),
                                  onPressed: () {
                                    ref.invalidate(filteredBusesProvider);
                                    ref.invalidate(allBusesProvider);
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Filter Segmented Chips
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: Row(
                              children: [
                                _filterPill('All', selectedFilter == null, () {
                                  ref.read(selectedUserTypeFilterProvider.notifier).state = null;
                                }),
                                const SizedBox(width: 8),
                                _filterPill('Students (ছাত্র)', selectedFilter == UserType.student, () {
                                  ref.read(selectedUserTypeFilterProvider.notifier).state =
                                      selectedFilter == UserType.student ? null : UserType.student;
                                }),
                                const SizedBox(width: 8),
                                _filterPill('Teachers / Officers', selectedFilter == UserType.teacherAndOfficer, () {
                                  ref.read(selectedUserTypeFilterProvider.notifier).state =
                                      selectedFilter == UserType.teacherAndOfficer ? null : UserType.teacherAndOfficer;
                                }),
                                const SizedBox(width: 8),
                                _filterPill('Staff (কর্মচারী)', selectedFilter == UserType.staff, () {
                                  ref.read(selectedUserTypeFilterProvider.notifier).state =
                                      selectedFilter == UserType.staff ? null : UserType.staff;
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Smart Recommendation Banner
                    if (searchQuery.isEmpty && selectedFilter == null)
                      SliverToBoxAdapter(
                        child: allBusesAsync.when(
                          data: (allBuses) {
                            final rec = RecommendationEngine.getSmartRecommendations(
                              allBuses: allBuses,
                              favoriteBusIds: favorites,
                              recentSearches: recentSearches,
                            );

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.uberDarkElevated,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: AppColors.uberBlue.withAlpha(80)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.auto_awesome_rounded, color: AppColors.uberGold, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          rec.recommendationReason,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Row(
                                      children: rec.recommendedBuses.map((bus) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 6.0),
                                          child: ActionChip(
                                            backgroundColor: AppColors.uberDarkCard,
                                            side: BorderSide(color: AppColors.uberBorder),
                                            avatar: const Icon(Icons.directions_bus_rounded, size: 14, color: AppColors.uberGold),
                                            label: Text(bus.busName, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                                            onPressed: () => context.push('/bus/${bus.id}'),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(duration: 300.ms);
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ),

                    // Buses List
                    busesAsync.when(
                      data: (buses) {
                        if (buses.isEmpty) {
                          return const SliverFillRemaining(
                            child: Center(
                              child: Text('No buses found', style: TextStyle(color: AppColors.textSecondary)),
                            ),
                          );
                        }

                        return SliverPadding(
                          padding: const EdgeInsets.only(bottom: 24),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final bus = buses[index];
                                final isFav = favorites.contains(bus.id);

                                return BusCard(
                                  bus: bus,
                                  isFavorite: isFav,
                                  onToggleFavorite: () {
                                    ref.read(favoritesProvider.notifier).toggle(bus.id);
                                  },
                                ).animate().fadeIn(duration: 200.ms, delay: (index * 20).ms);
                              },
                              childCount: buses.length,
                            ),
                          ),
                        );
                      },
                      loading: () => const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator(color: AppColors.uberBlue)),
                      ),
                      error: (err, stack) => SliverFillRemaining(
                        child: Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _quickChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.uberDarkCard.withAlpha(230),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.uberBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppColors.uberGold),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterPill(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : AppColors.uberDarkElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.textPrimary : AppColors.uberBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.pitchBlack : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
