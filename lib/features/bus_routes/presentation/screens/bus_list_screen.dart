import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/database/hive_service.dart';
import 'package:jnu_bus_routes/core/utils/recommendation_engine.dart';
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

    return Scaffold(
      body: Stack(
        children: [
          // 1. Interactive Map View
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

          // 2. Floating Top Header with Direct Theme Toggle & Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Floating Search Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push('/search'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: theme.cardTheme.color?.withAlpha(240),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              ),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 4)),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search_rounded, color: AppColors.primaryRed, size: 22),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Where to? (Search bus or stoppage)',
                                    style: TextStyle(
                                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Direct Theme Toggle Button (Sun / Moon)
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: theme.cardTheme.color?.withAlpha(240),
                        child: IconButton(
                          icon: Icon(
                            isDark ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
                            color: isDark ? AppColors.accentGold : AppColors.primaryRed,
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

                  // Quick Action Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _quickChip(
                          context,
                          icon: Icons.school_rounded,
                          label: 'JnU Campus',
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = 'Jagannath';
                            context.push('/search');
                          },
                        ),
                        const SizedBox(width: 8),
                        _quickChip(
                          context,
                          icon: Icons.place_rounded,
                          label: 'Jatrabari',
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = 'Jatrabari';
                            context.push('/search');
                          },
                        ),
                        const SizedBox(width: 8),
                        _quickChip(
                          context,
                          icon: Icons.star_rounded,
                          label: 'Favorites (${favorites.length})',
                          onTap: () {
                            ref.read(searchQueryProvider.notifier).state = '';
                            ref.read(selectedUserTypeFilterProvider.notifier).state = null;
                          },
                        ),
                        const SizedBox(width: 8),
                        _quickChip(
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

          // 3. Floating Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.58,
            minChildSize: 0.25,
            maxChildSize: 0.92,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: const [
                    BoxShadow(color: Colors.black38, blurRadius: 20, offset: Offset(0, -6)),
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
                                    color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.refresh_rounded, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary, size: 20),
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
                                _filterPill(context, 'All', selectedFilter == null, () {
                                  ref.read(selectedUserTypeFilterProvider.notifier).state = null;
                                }),
                                const SizedBox(width: 8),
                                _filterPill(context, 'Students (ছাত্র)', selectedFilter == UserType.student, () {
                                  ref.read(selectedUserTypeFilterProvider.notifier).state =
                                      selectedFilter == UserType.student ? null : UserType.student;
                                }),
                                const SizedBox(width: 8),
                                _filterPill(context, 'Teachers / Officers', selectedFilter == UserType.teacherAndOfficer, () {
                                  ref.read(selectedUserTypeFilterProvider.notifier).state =
                                      selectedFilter == UserType.teacherAndOfficer ? null : UserType.teacherAndOfficer;
                                }),
                                const SizedBox(width: 8),
                                _filterPill(context, 'Staff (কর্মচারী)', selectedFilter == UserType.staff, () {
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
                                color: isDark ? AppColors.darkElevated : AppColors.lightElevated,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: AppColors.primaryRed.withAlpha(60)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryRed, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          rec.recommendationReason,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
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
                                            backgroundColor: theme.cardTheme.color,
                                            avatar: const Icon(Icons.directions_bus_rounded, size: 14, color: AppColors.primaryRed),
                                            label: Text(bus.busName, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary)),
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
                        child: Center(child: CircularProgressIndicator(color: AppColors.primaryRed)),
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

    return allBusesAsync.when(
      data: (buses) {
        BusModel? primaryBus;
        if (primaryBusId != null) {
          primaryBus = buses.firstWhere((b) => b.id == primaryBusId, orElse: () => buses.first);
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkElevated : AppColors.lightElevated,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryRed.withAlpha(120), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.pin_drop_rounded, color: AppColors.primaryRed, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'MY DAILY COMMUTE ROUTE',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.0, color: AppColors.primaryRed),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _showSelectPrimaryModal(context, ref, buses),
                    child: Text(
                      primaryBus != null ? 'Change' : 'Set Stoppage',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accentBlue),
                    ),
                  ),
                ],
              ),
              if (primaryBus != null && primaryStoppageName != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bus: ${primaryBus.busName}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary),
                          ),
                          Text(
                            'My Stop: $primaryStoppageName',
                            style: TextStyle(fontSize: 13, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/bus/${primaryBus!.id}/map?direction=up'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.successGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.navigation_rounded, size: 16),
                      label: const Text('Track Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 4),
                const Text(
                  'No primary bus/stoppage set. Click "Set Stoppage" to save your daily bus route for 1-tap live tracking!',
                  style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
                ),
              ],
            ],
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
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Set Your Primary Daily Bus', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Select your bus to permanently save your commute route:', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: buses.length,
                  itemBuilder: (context, index) {
                    final bus = buses[index];
                    return ListTile(
                      leading: const Icon(Icons.directions_bus_rounded, color: AppColors.primaryRed),
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

  Widget _quickChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color?.withAlpha(230),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppColors.primaryRed),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryRed
              : (isDark ? AppColors.darkElevated : AppColors.lightElevated),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : (isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
          ),
        ),
      ),
    );
  }
}
