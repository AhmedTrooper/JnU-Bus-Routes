abstract class EnvConfig {
  /// OpenStreetMap / Custom Map Tile URL (configurable via --dart-define=MAP_TILE_URL=...)
  static const String defaultMapTileUrl = String.fromEnvironment(
    'MAP_TILE_URL',
    defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );

  /// Optional Custom API Key (configurable via --dart-define=MAP_API_KEY=...)
  static const String mapApiKey = String.fromEnvironment(
    'MAP_API_KEY',
    defaultValue: '',
  );

  /// App environment mode (development, staging, production)
  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'production',
  );
}
