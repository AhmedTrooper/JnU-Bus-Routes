import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/database/hive_service.dart';
import 'package:jnu_bus_routes/core/utils/recommendation_engine.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/bus_enums.dart';
import 'package:jnu_bus_routes/features/bus_routes/presentation/providers/bus_providers.dart';
import 'package:jnu_bus_routes/features/bus_routes/presentation/widgets/bus_card.dart';

class BusListScreen extends ConsumerWidget {
  const BusListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busesAsync = ref.watch(filteredBusesProvider);
    final allBusesAsync = ref.watch(allBusesProvider);
    final selectedFilter = ref.watch(selectedUserTypeFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final favorites = ref.watch(favoritesProvider);
    final recentSearches = HiveService.recentSearches;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(filteredBusesProvider);
          ref.invalidate(allBusesProvider);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar.large(
              expandedHeight: 140,
              floating: false,
              pinned: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.accentGold,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.directions_bus, color: Colors.black, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'JnU Bus Routes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  tooltip: 'Search Routes',
                  onPressed: () => context.push('/search'),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  tooltip: 'Settings & Map Config',
                  onPressed: () => context.push('/settings'),
                ),
              ],
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _FilterHeaderDelegate(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('All Buses'),
                          selected: selectedFilter == null,
                          onSelected: (_) {
                            ref.read(selectedUserTypeFilterProvider.notifier).state = null;
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('Students (ছাত্র)'),
                          selected: selectedFilter == UserType.student,
                          onSelected: (sel) {
                            ref.read(selectedUserTypeFilterProvider.notifier).state =
                                sel ? UserType.student : null;
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('Teachers / Officers'),
                          selected: selectedFilter == UserType.teacherAndOfficer,
                          onSelected: (sel) {
                            ref.read(selectedUserTypeFilterProvider.notifier).state =
                                sel ? UserType.teacherAndOfficer : null;
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('Staff (কর্মচারী)'),
                          selected: selectedFilter == UserType.staff,
                          onSelected: (sel) {
                            ref.read(selectedUserTypeFilterProvider.notifier).state =
                                sel ? UserType.staff : null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

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
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accent.withAlpha(40),
                            AppColors.accentGold.withAlpha(20),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.accent.withAlpha(60)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome_rounded, color: AppColors.accentGold, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  rec.recommendationReason,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: rec.recommendedBuses.map((bus) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ActionChip(
                                    avatar: const Icon(Icons.directions_bus_rounded, size: 16),
                                    label: Text(bus.busName),
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
                  error: (err, stack) => const SizedBox.shrink(),
                ),
              ),

            busesAsync.when(
              data: (buses) {
                if (buses.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.directions_bus_filled_outlined, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            searchQuery.isNotEmpty
                                ? 'No buses matching "$searchQuery"'
                                : 'No buses found',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.only(bottom: 32),
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
                        ).animate().fadeIn(duration: 250.ms, delay: (index * 25).ms);
                      },
                      childCount: buses.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                        const SizedBox(height: 12),
                        Text('Error loading database: $err', textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.invalidate(filteredBusesProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FilterHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant _FilterHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
