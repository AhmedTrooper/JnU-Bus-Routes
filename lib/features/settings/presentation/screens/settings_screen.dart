import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/database/hive_service.dart';

final themeModeProvider = StateProvider<bool>((ref) => HiveService.isDarkMode);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _tileUrlController;
  late final TextEditingController _apiKeyController;

  @override
  void initState() {
    super.initState();
    _tileUrlController = TextEditingController(text: HiveService.customTileUrl);
    _apiKeyController = TextEditingController(text: HiveService.customApiKey);
  }

  @override
  void dispose() {
    _tileUrlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    await HiveService.setCustomTileUrl(_tileUrlController.text.trim());
    await HiveService.setCustomApiKey(_apiKeyController.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Map settings saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: AppColors.pitchBlack,
      appBar: AppBar(
        backgroundColor: AppColors.pitchBlack,
        title: const Text('Settings & Map Config'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            activeThumbColor: AppColors.uberBlue,
            title: const Text('Dark Mode Theme', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            subtitle: const Text('Enable signature Uber dark aesthetic', style: TextStyle(color: AppColors.textSecondary)),
            secondary: const Icon(Icons.dark_mode_rounded, color: AppColors.uberGold),
            value: isDark,
            onChanged: (val) async {
              await HiveService.setDarkMode(val);
              ref.read(themeModeProvider.notifier).state = val;
            },
          ),
          const Divider(height: 32, color: AppColors.uberBorder),

          const Text(
            'MAP ENGINE & TILE PROVIDER',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textMuted, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          const Text(
            'Uses free CartoDB / OpenStreetMap dark tiles by default (no API key required). You can also set a custom tile server or Google/Mapbox key.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _tileUrlController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              labelText: 'Map Tile URL Template',
              labelStyle: TextStyle(color: AppColors.textSecondary),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.uberBorder)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.uberBlue)),
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                backgroundColor: AppColors.uberDarkElevated,
                side: const BorderSide(color: AppColors.uberBorder),
                label: const Text('CartoDB Dark (Uber Style)', style: TextStyle(color: AppColors.uberGold, fontSize: 12)),
                onPressed: () {
                  _tileUrlController.text = 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
                },
              ),
              ActionChip(
                backgroundColor: AppColors.uberDarkElevated,
                side: const BorderSide(color: AppColors.uberBorder),
                label: const Text('Standard OpenStreetMap', style: TextStyle(color: AppColors.textPrimary, fontSize: 12)),
                onPressed: () {
                  _tileUrlController.text = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
                },
              ),
              ActionChip(
                backgroundColor: AppColors.uberDarkElevated,
                side: const BorderSide(color: AppColors.uberBorder),
                label: const Text('CartoDB Voyager', style: TextStyle(color: AppColors.textPrimary, fontSize: 12)),
                onPressed: () {
                  _tileUrlController.text = 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png';
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _apiKeyController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              labelText: 'Optional Custom API Key (Google / Mapbox)',
              labelStyle: TextStyle(color: AppColors.textSecondary),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.uberBorder)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.uberBlue)),
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Save Map Settings', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.uberBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const Divider(height: 32, color: AppColors.uberBorder),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.uberDarkCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.uberBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'About JnU Bus Database',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                ),
                SizedBox(height: 8),
                Text('• 40 Registered University Buses', style: TextStyle(color: AppColors.textSecondary)),
                Text('• 209 Unique Stoppage Places', style: TextStyle(color: AppColors.textSecondary)),
                Text('• 1,300 Sequential Route Mappings', style: TextStyle(color: AppColors.textSecondary)),
                SizedBox(height: 8),
                Text(
                  'FAANG Clean Architecture: Hive + Riverpod 2.x + Sqflite + GoRouter + Flutter Map',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
