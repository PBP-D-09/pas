import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../errors/app_failure.dart';
import 'api_client.dart';

class HttpApiClient implements ApiClient {
  const HttpApiClient();

  @override
  Future<Object?> get(String path) async {
    final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}$path'));
    if (response.statusCode != 200) {
      throw AppFailure('GET $path gagal dengan status ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  @override
  Future<Object?> post(
    String path, {
    Map<String, Object?> body = const <String, Object?>{},
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw AppFailure('POST $path gagal dengan status ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }
}
