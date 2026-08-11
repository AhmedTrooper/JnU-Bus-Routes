abstract class EnvConfig {
  /// Default CartoDB Dark Map Tiles for signature Uber dark aesthetic
  static const String defaultMapTileUrl = String.fromEnvironment(
    'MAP_TILE_URL',
    defaultValue: 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
  );

  /// Optional Custom API Key (configurable via --dart-define=MAP_API_KEY=...)
  static const String mapApiKey = String.fromEnvironment(
    'MAP_API_KEY',
    defaultValue: '',
  );

  /// App environment mode
  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'production',
  );
}
