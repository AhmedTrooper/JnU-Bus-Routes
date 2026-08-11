import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/database/hive_service.dart';
import 'package:jnu_bus_routes/core/utils/recommendation_engine.dart';
import 'package:jnu_bus_routes/core/widgets/shadcn_components.dart';
import 'package:jnu_bus_routes/features/bus_routes/data/models/bus_model.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/bus_enums.dart';
import 'package:jnu_bus_routes/features/bus_routes/presentation/providers/bus_providers.dart';
import 'package:jnu_bus_routes/features/bus_routes/presentation/widgets/bus_card.dart';
import 'package:jnu_bus_routes/features/settings/presentation/screens/settings_screen.dart';

class BusListScreen extends ConsumerStatefulWidget {
  const BusListScreen({super.key});

  @override
  ConsumerState<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends ConsumerState<BusListScreen> {
  static final LatLng _dhakaCenter = LatLng(23.7087, 90.4118);

  @override
  Widget build(BuildContext context) {
    final busesAsync = ref.watch(filteredBusesProvider);
    final allBusesAsync = ref.watch(allBusesProvider);
    final selectedFilter = ref.watch(selectedUserTypeFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final favorites = ref.watch(favoritesProvider);
    final isDark = ref.watch(themeModeProvider);
    final recentSearches = HiveService.recentSearches;

    final primaryBusId = HiveService.primaryBusId;
    final primaryStoppageName = HiveService.primaryStoppageName;

    final tileUrl = isDark ? AppColors.darkTileUrl : AppColors.lightTileUrl;
    final theme = Theme.of(context);

    final primaryTextColor = isDark ? AppColors.darkForeground : AppColors.lightForeground;
    final secondaryTextColor = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;

    return Scaffold(
      body: Stack(
        children: [
          // Map Background
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

          // Floating Top Header with Search & Direct Theme Toggle
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Shadcn Input Search Bar with ⌘K Badge
                      Expanded(
                        child: ShadcnInputBar(
                          hintText: 'Search bus or stoppage (⌘K)...',
                          onTap: () => context.push('/search'),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Direct Theme Switcher Button
                      Container(
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isDark ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
                            color: isDark ? AppColors.shadcnAmber : AppColors.shadcnBlue,
                            size: 20,
                          ),
                          tooltip: 'Toggle Theme',
                          onPressed: () async {
                            final next = !isDark;
                            await HiveService.setDarkMode(next);
                            ref.read(themeModeProvider.notifier).state = next;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Quick Action Chips Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _shadcnQuickChip(
                          context,
                          icon: Icons.school_rounded,
                          label: 'JnU Campus',
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = 'Jagannath';
                            context.push('/search');
                          },
                        ),
                        const SizedBox(width: 8),
                        _shadcnQuickChip(
                          context,
                          icon: Icons.place_rounded,
                          label: 'Jatrabari',
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = 'Jatrabari';
                            context.push('/search');
                          },
                        ),
                        const SizedBox(width: 8),
                        _shadcnQuickChip(
                          context,
                          icon: Icons.star_rounded,
                          label: 'Favorites (${favorites.length})',
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = '';
                            ref.read(selectedUserTypeFilterProvider.notifier).state = null;
                          },
                        ),
                        const SizedBox(width: 8),
                        _shadcnQuickChip(
                          context,
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

          // Floating Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.58,
            minChildSize: 0.25,
            maxChildSize: 0.92,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1.0,
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, -4)),
                  ],
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 8),
                              width: 36,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          // Permanent Daily Commute Selection Card
                          _buildDailyCommuteCard(context, ref, allBusesAsync, primaryBusId, primaryStoppageName),

                          // Header Title & Refresh
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'JnU Bus Routes',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.refresh_rounded, color: secondaryTextColor, size: 20),
                                  onPressed: () {
                                    ref.invalidate(filteredBusesProvider);
                                    ref.invalidate(allBusesProvider);
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Filter Segmented Pills
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: Row(
                              children: [
                                _filterPill(context, 'All', selectedFilter == null, () {
                                  ref.read(selectedUserTypeFilterProvider.notifier).state = null;
                                }),
                                const SizedBox(width: 8),
                                _filterPill(context, 'Students', selectedFilter == UserType.student, () {
                                  ref.read(selectedUserTypeFilterProvider.notifier).state =
                                      selectedFilter == UserType.student ? null : UserType.student;
                                }),
                                const SizedBox(width: 8),
                                _filterPill(context, 'Teachers', selectedFilter == UserType.teacherAndOfficer, () {
                                  ref.read(selectedUserTypeFilterProvider.notifier).state =
                                      selectedFilter == UserType.teacherAndOfficer ? null : UserType.teacherAndOfficer;
                                }),
                                const SizedBox(width: 8),
                                _filterPill(context, 'Staff', selectedFilter == UserType.staff, () {
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

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: ShadcnCard(
                                borderRadius: 16,
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.auto_awesome_rounded, color: AppColors.shadcnAmber, size: 16),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            rec.recommendationReason,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: primaryTextColor,
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
                                              backgroundColor: isDark ? AppColors.darkMuted : AppColors.lightMuted,
                                              side: BorderSide(
                                                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                              ),
                                              avatar: const Icon(Icons.directions_bus_rounded, size: 14, color: AppColors.shadcnBlue),
                                              label: Text(bus.busName, style: TextStyle(fontSize: 12, color: primaryTextColor)),
                                              onPressed: () => context.push('/bus/${bus.id}'),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate().fadeIn(duration: 250.ms);
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
                              child: Text('No buses found'),
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
                                  isPrimary: bus.id == primaryBusId,
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
                        child: Center(child: CircularProgressIndicator(color: AppColors.shadcnBlue)),
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

  Widget _buildDailyCommuteCard(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<BusModel>> allBusesAsync,
    int? primaryBusId,
    String? primaryStoppageName,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryTextColor = isDark ? AppColors.darkForeground : AppColors.lightForeground;
    final secondaryTextColor = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;

    return allBusesAsync.when(
      data: (buses) {
        BusModel? primaryBus;
        if (primaryBusId != null) {
          primaryBus = buses.firstWhere((b) => b.id == primaryBusId, orElse: () => buses.first);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ShadcnCard(
            borderRadius: 16,
            borderColor: AppColors.shadcnBlue.withAlpha(120),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.pin_drop_rounded, color: AppColors.shadcnBlue, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'MY DAILY COMMUTE',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: AppColors.shadcnBlue),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => _showSelectPrimaryModal(context, ref, buses),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Set / Change',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.shadcnBlue),
                      ),
                    ),
                  ],
                ),
                if (primaryBus != null && primaryStoppageName != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              primaryBus.busName,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryTextColor),
                            ),
                            Text(
                              'My Stop: $primaryStoppageName',
                              style: TextStyle(fontSize: 13, color: secondaryTextColor),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/bus/${primaryBus!.id}/map?direction=up'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.shadcnEmerald,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.navigation_rounded, size: 14),
                        label: const Text('Track', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 2),
                  Text(
                    'Set your primary bus and home stoppage for 1-tap live tracking!',
                    style: TextStyle(fontSize: 12, color: secondaryTextColor),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _showSelectPrimaryModal(BuildContext context, WidgetRef ref, List<BusModel> buses) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return ShadcnCard(
          borderRadius: 24,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Set Primary Daily Bus', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Select your bus to permanently save your commute route:', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 12),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.builder(
                  itemCount: buses.length,
                  itemBuilder: (context, index) {
                    final bus = buses[index];
                    return ListTile(
                      leading: const Icon(Icons.directions_bus_rounded, color: AppColors.shadcnBlue),
                      title: Text(bus.busName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Terminal: ${bus.lastStoppage}'),
                      onTap: () async {
                        await HiveService.setPrimaryRoute(
                          busId: bus.id,
                          stoppageId: 1,
                          stoppageName: bus.lastStoppage,
                        );
                        if (ctx.mounted) Navigator.pop(ctx);
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _shadcnQuickChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkForeground : AppColors.lightForeground;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: primaryTextColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterPill(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkForeground : AppColors.lightForeground)
              : (isDark ? AppColors.darkMuted : AppColors.lightMuted),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.darkForeground : AppColors.lightForeground)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? (isDark ? AppColors.darkBackground : Colors.white)
                : (isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground),
          ),
        ),
      ),
    );
  }
}
