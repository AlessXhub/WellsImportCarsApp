import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wells_import_cars_app/services/api_service.dart';

void main() {
  test(
    'convierte una falla de conexión en ApiException y permite reintentar',
    () async {
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        if (calls == 1) throw const SocketException('API apagada');
        return http.Response(
          '[]',
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });
      final api = ApiService(client: client);

      await expectLater(api.get('/api/catalogo'), throwsA(isA<ApiException>()));
      expect(await api.get('/api/catalogo'), isEmpty);
      expect(calls, 2);
    },
  );
}
