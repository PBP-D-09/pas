import '../config/app_config.dart';

/// Penyimpanan token DRF yang dikirim [HttpApiClient] sebagai header
/// `Authorization: Token <key>`.
///
/// Modul Accounts mengisi [current] setelah login/register dan mengosongkannya
/// saat logout. Sebelum itu, nilai awalnya diambil dari
/// `--dart-define=API_TOKEN=<key>` (lihat [AppConfig.devApiToken]).
abstract final class AuthToken {
  static String? current = AppConfig.devApiToken.isEmpty
      ? null
      : AppConfig.devApiToken;

  static bool get isAvailable => current?.isNotEmpty ?? false;
}
