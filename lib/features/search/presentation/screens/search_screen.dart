import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/database/hive_service.dart';
import 'package:jnu_bus_routes/features/bus_routes/presentation/providers/bus_providers.dart';
import 'package:jnu_bus_routes/features/bus_routes/presentation/widgets/bus_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      HiveService.addSearchQuery(query.trim());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final busesAsync = ref.watch(filteredBusesProvider);
    final favorites = ref.watch(favoritesProvider);
    final recentSearches = HiveService.recentSearches;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: TextStyle(
            color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Search bus or stoppage (e.g. Uttoron, Jatrabari)...',
            hintStyle: TextStyle(
              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
              fontSize: 15,
            ),
            border: InputBorder.none,
          ),
          onChanged: (text) {
            ref.read(searchQueryProvider.notifier).state = text;
          },
          onSubmitted: _onSearchSubmitted,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear_rounded,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
              ),
              onPressed: () {
                _controller.clear();
                ref.read(searchQueryProvider.notifier).state = '';
              },
            ),
        ],
      ),
      body: Column(
        children: [
          if (_controller.text.isEmpty && recentSearches.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RECENT SEARCHES',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recentSearches.map((term) {
                      return ActionChip(
                        backgroundColor: isDark ? AppColors.darkGlassElevated : AppColors.lightGlassElevated,
                        side: BorderSide(
                          color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
                          width: 0.5,
                        ),
                        label: Text(
                          term,
                          style: TextStyle(
                            color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                            fontSize: 13,
                          ),
                        ),
                        onPressed: () {
                          _controller.text = term;
                          ref.read(searchQueryProvider.notifier).state = term;
                          _onSearchSubmitted(term);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          Expanded(
            child: busesAsync.when(
              data: (buses) {
                if (buses.isEmpty) {
                  return Center(
                    child: Text(
                      'No buses or stoppages match your search',
                      style: TextStyle(
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: buses.length,
                  padding: const EdgeInsets.only(bottom: 24),
                  itemBuilder: (context, index) {
                    final bus = buses[index];
                    final isFav = favorites.contains(bus.id);

                    return BusCard(
                      bus: bus,
                      isFavorite: isFav,
                      onToggleFavorite: () {
                        ref.read(favoritesProvider.notifier).toggle(bus.id);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.appleBlue)),
              error: (err, stack) => Center(child: Text('Search error: $err', style: const TextStyle(color: Colors.red))),
            ),
          ),
        ],
      ),
    );
  }
}
