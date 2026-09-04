import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wells_import_cars_app/services/api_service.dart';
import 'package:wells_import_cars_app/services/cotizacion_service.dart';

void main() {
  test('envía la solicitud de cotización con JWT y origen correcto', () async {
    final client = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/api/cotizaciones/solicitudes');
      expect(request.headers['Authorization'], 'Bearer jwt-cliente');
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['idSolicitud'], 7);
      expect(body['idVehiculo'], isNull);
      expect(body['observaciones'], 'Cotizar transporte');
      return http.Response(
        jsonEncode({
          'idSolicitudCotizacion': 3,
          'idCliente': 2,
          'idSolicitud': 7,
          'idVehiculo': null,
          'fechaSolicitud': '2026-09-03T21:00:00',
          'observaciones': 'Cotizar transporte',
          'estado': 'Pendiente',
          'fechaAtencion': null,
        }),
        201,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
    final service = CotizacionService(ApiService(client: client));

    final result = await service.requestQuote(
      token: 'jwt-cliente',
      idSolicitud: 7,
      observaciones: '  Cotizar transporte  ',
    );

    expect(result.idSolicitudCotizacion, 3);
    expect(result.estado, 'Pendiente');
  });
}
