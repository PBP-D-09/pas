class AppConfig {
  const AppConfig._();

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  /// Token DRF untuk pengembangan, dipakai selama alur login belum tersedia.
  /// Contoh: `flutter run --dart-define=API_TOKEN=<key>`.
  static const devApiToken = String.fromEnvironment('API_TOKEN');
}
