import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jnu_bus_routes/core/constants/app_colors.dart';
import 'package:jnu_bus_routes/core/database/hive_service.dart';
import 'package:jnu_bus_routes/core/widgets/glass_card.dart';

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
      appBar: AppBar(
        title: const Text('Settings & Map Config'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            activeThumbColor: AppColors.appleBlue,
            title: TextStyleText(
              'Dark Mode Theme',
              isDark: isDark,
              isBold: true,
            ),
            subtitle: Text(
              'Enable Apple dark mode glassmorphism',
              style: TextStyle(
                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
              ),
            ),
            secondary: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: isDark ? AppColors.appleOrange : AppColors.appleBlue,
            ),
            value: isDark,
            onChanged: (val) async {
              await HiveService.setDarkMode(val);
              ref.read(themeModeProvider.notifier).state = val;
            },
          ),
          Divider(height: 32, color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder),

          Text(
            'MAP ENGINE & TILE PROVIDER',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Uses free CartoDB / OpenStreetMap dark tiles by default (no API key required). You can also set a custom tile server or Google/Mapbox key.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _tileUrlController,
            style: TextStyle(
              color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'Map Tile URL Template',
              labelStyle: TextStyle(
                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.appleBlue),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                backgroundColor: isDark ? AppColors.darkGlassElevated : AppColors.lightGlassElevated,
                side: BorderSide(
                  color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
                  width: 0.5,
                ),
                label: Text(
                  'CartoDB Dark (Apple Style)',
                  style: TextStyle(
                    color: isDark ? AppColors.appleOrange : AppColors.appleBlue,
                    fontSize: 12,
                  ),
                ),
                onPressed: () {
                  _tileUrlController.text = 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
                },
              ),
              ActionChip(
                backgroundColor: isDark ? AppColors.darkGlassElevated : AppColors.lightGlassElevated,
                side: BorderSide(
                  color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
                  width: 0.5,
                ),
                label: Text(
                  'Standard OpenStreetMap',
                  style: TextStyle(
                    color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                    fontSize: 12,
                  ),
                ),
                onPressed: () {
                  _tileUrlController.text = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
                },
              ),
              ActionChip(
                backgroundColor: isDark ? AppColors.darkGlassElevated : AppColors.lightGlassElevated,
                side: BorderSide(
                  color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
                  width: 0.5,
                ),
                label: Text(
                  'CartoDB Voyager',
                  style: TextStyle(
                    color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                    fontSize: 12,
                  ),
                ),
                onPressed: () {
                  _tileUrlController.text = 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png';
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _apiKeyController,
            style: TextStyle(
              color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'Optional Custom API Key (Google / Mapbox)',
              labelStyle: TextStyle(
                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.appleBlue),
              ),
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Save Map Settings', style: TextStyle(fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.appleBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          Divider(height: 32, color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder),

          GlassCard(
            borderRadius: 20,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About JnU Bus Database',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• 40 Registered University Buses',
                  style: TextStyle(color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                ),
                Text(
                  '• 209 Unique Stoppage Places',
                  style: TextStyle(color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                ),
                Text(
                  '• 1,300 Sequential Route Mappings',
                  style: TextStyle(color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Apple Glassmorphism Architecture: Hive + Riverpod 2.x + Sqflite + GoRouter + Flutter Map',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextStyleText extends StatelessWidget {
  final String text;
  final bool isDark;
  final bool isBold;

  const TextStyleText(this.text, {super.key, required this.isDark, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}
