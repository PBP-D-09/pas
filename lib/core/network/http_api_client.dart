import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../errors/app_failure.dart';
import 'api_client.dart';
import 'auth_token.dart';

class HttpApiClient implements ApiClient {
  const HttpApiClient({this.client});

  /// Diisi saat tes (mis. `MockClient`); null berarti client baru per request.
  final http.Client? client;

  @override
  Future<Object?> get(String path) {
    return _send('GET', path);
  }

  @override
  Future<Object?> post(
    String path, {
    Map<String, Object?> body = const <String, Object?>{},
  }) {
    return _send('POST', path, body: body);
  }

  @override
  Future<Object?> patch(
    String path, {
    Map<String, Object?> body = const <String, Object?>{},
  }) {
    return _send('PATCH', path, body: body);
  }

  @override
  Future<Object?> delete(String path) {
    return _send('DELETE', path);
  }

  Future<Object?> _send(
    String method,
    String path, {
    Map<String, Object?>? body,
  }) async {
    final request = http.Request(
      method,
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
    );
    request.headers['Accept'] = 'application/json';
    final token = AuthToken.current;
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Token $token';
    }
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }

    final injected = client;
    final streamed = injected != null
        ? await injected.send(request)
        : await request.send();
    final response = await http.Response.fromStream(streamed);

    // DRF tidak menyertakan charset, jadi decode sebagai UTF-8 secara eksplisit.
    final text = utf8.decode(response.bodyBytes);
    final decoded = text.isEmpty ? null : _tryDecode(text);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AppFailure(
        _errorMessage(decoded) ??
            '$method $path gagal dengan status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
    return decoded;
  }
}

Object? _tryDecode(String text) {
  try {
    return jsonDecode(text);
  } on FormatException {
    return null;
  }
}

/// Pesan error DRF: `{"detail": "..."}` atau `{"field": ["..."]}`.
String? _errorMessage(Object? body) {
  if (body is! Map) return null;
  final detail = body['detail'];
  if (detail is String && detail.isNotEmpty) return detail;
  for (final value in body.values) {
    if (value is String && value.isNotEmpty) return value;
    if (value is List && value.isNotEmpty && value.first is String) {
      return value.first as String;
    }
  }
  return null;
}
