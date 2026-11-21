import 'package:http/http.dart' as http;

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/auth_token.dart';

/// Pemeriksa token yang bisa diganti saat tes.
typedef TokenCheck = bool Function();

bool defaultTokenCheck() => AuthToken.isAvailable;

/// True jika error berarti user perlu login (token kosong/kedaluwarsa).
/// 403 (mis. akun tenant) tidak termasuk: pesannya ditampilkan apa adanya.
bool isUnauthorized(Object error) {
  return error is AppFailure && error.isUnauthorized;
}

/// Pesan yang aman ditampilkan ke pengguna untuk error dari lapisan data.
String describeError(Object error) {
  if (error is AppFailure) return error.message;
  if (error is http.ClientException) {
    return "Can't reach the SustainaBowl server. Check your connection.";
  }
  if (error is FormatException) {
    return 'The server sent an unexpected response.';
  }
  return error.toString();
}
