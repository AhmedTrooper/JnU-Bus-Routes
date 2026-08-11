import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        const SnackBar(content: Text('Settings saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Map Config'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode Theme'),
            subtitle: const Text('Enable ultra-modern dark aesthetics'),
            secondary: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
            value: isDark,
            onChanged: (val) async {
              await HiveService.setDarkMode(val);
              ref.read(themeModeProvider.notifier).state = val;
            },
          ),
          const Divider(height: 32),

          const Text(
            'Map Engine & API Configuration',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Uses free OpenStreetMap by default (no API key required). You can also set a custom tile server or Google/Mapbox API key.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _tileUrlController,
            decoration: const InputDecoration(
              labelText: 'Map Tile URL Template',
              hintText: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: const Text('Standard OpenStreetMap'),
                onPressed: () {
                  _tileUrlController.text = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
                },
              ),
              ActionChip(
                label: const Text('CartoDB Dark Tiles'),
                onPressed: () {
                  _tileUrlController.text =
                      'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
                },
              ),
              ActionChip(
                label: const Text('CartoDB Voyager'),
                onPressed: () {
                  _tileUrlController.text =
                      'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png';
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _apiKeyController,
            decoration: const InputDecoration(
              labelText: 'Optional Custom API Key (Google / Mapbox)',
              hintText: 'AIzaSy...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Save Map Settings'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const Divider(height: 32),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'About JnU Bus Database',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('• 40 Registered University Buses'),
                  Text('• 209 Unique Stoppage Places'),
                  Text('• 1,300 Sequential Route Mappings'),
                  SizedBox(height: 8),
                  Text(
                    'FAANG Clean Architecture: Hive + Riverpod 2.x + Sqflite + GoRouter + Flutter Map',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
