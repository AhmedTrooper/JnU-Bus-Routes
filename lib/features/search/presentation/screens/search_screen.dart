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

    return Scaffold(
      backgroundColor: AppColors.pitchBlack,
      appBar: AppBar(
        backgroundColor: AppColors.pitchBlack,
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          decoration: const InputDecoration(
            hintText: 'Search bus or stoppage (e.g. Uttoron, Jatrabari)...',
            hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 15),
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
              icon: const Icon(Icons.clear_rounded, color: AppColors.textMuted),
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
                  const Text(
                    'RECENT SEARCHES',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textMuted, letterSpacing: 1.0),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recentSearches.map((term) {
                      return ActionChip(
                        backgroundColor: AppColors.uberDarkElevated,
                        side: const BorderSide(color: AppColors.uberBorder),
                        label: Text(term, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
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
                  return const Center(
                    child: Text('No buses or stoppages match your search', style: TextStyle(color: AppColors.textSecondary)),
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
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.uberBlue)),
              error: (err, stack) => Center(child: Text('Search error: $err', style: const TextStyle(color: Colors.red))),
            ),
          ),
        ],
      ),
    );
  }
}
