import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sustainabowl_mobile/core/errors/app_failure.dart';
import 'package:sustainabowl_mobile/core/network/auth_token.dart';
import 'package:sustainabowl_mobile/core/network/http_api_client.dart';

void main() {
  tearDown(() => AuthToken.current = null);

  test('sends the DRF token and JSON body', () async {
    late http.Request captured;
    final client = HttpApiClient(
      client: MockClient((request) async {
        captured = request;
        return http.Response('{"ok": true}', 201);
      }),
    );
    AuthToken.current = 'abc123';

    final result = await client.patch('/api/v1/x/', body: {'quantity': 2});

    expect(captured.method, 'PATCH');
    expect(captured.headers['Authorization'], 'Token abc123');
    expect(captured.headers['Content-Type'], startsWith('application/json'));
    expect(jsonDecode(captured.body), {'quantity': 2});
    expect(result, {'ok': true});
  });

  test('omits the Authorization header without a token', () async {
    late http.Request captured;
    final client = HttpApiClient(
      client: MockClient((request) async {
        captured = request;
        return http.Response('[]', 200);
      }),
    );

    await client.get('/api/v1/x/');

    expect(captured.headers.containsKey('Authorization'), isFalse);
  });

  test('surfaces DRF error messages and the status code', () async {
    final client = HttpApiClient(
      client: MockClient((request) async {
        return http.Response.bytes(
          utf8.encode('{"detail": "Wadah habis — coba kompos."}'),
          400,
        );
      }),
    );

    await expectLater(
      client.post('/api/v1/x/'),
      throwsA(
        isA<AppFailure>()
            .having((e) => e.message, 'message', 'Wadah habis — coba kompos.')
            .having((e) => e.statusCode, 'statusCode', 400),
      ),
    );
  });

  test('uses the first field error and handles empty bodies', () async {
    final client = HttpApiClient(
      client: MockClient((request) async {
        if (request.method == 'DELETE') return http.Response('', 204);
        return http.Response(
          '{"address_id": ["Choose one of your saved addresses."]}',
          400,
        );
      }),
    );

    expect(await client.delete('/api/v1/x/'), isNull);
    await expectLater(
      client.post('/api/v1/x/'),
      throwsA(
        isA<AppFailure>().having(
          (e) => e.message,
          'message',
          'Choose one of your saved addresses.',
        ),
      ),
    );
  });
}
