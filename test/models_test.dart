import 'package:flutter_test/flutter_test.dart';
import 'package:wells_import_cars_app/models/login_response.dart';
import 'package:wells_import_cars_app/models/solicitud_cotizacion.dart';
import 'package:wells_import_cars_app/models/vehiculo.dart';

void main() {
  test('LoginResponse obtiene idCliente y token reales', () {
    final result = LoginResponse.fromJson({
      'idUsuario': 4,
      'idCliente': 9,
      'idEmpleado': null,
      'nombre': 'Cliente Prueba',
      'correo': 'cliente@prueba.com',
      'rol': 'Cliente',
      'token': 'jwt-prueba',
      'expiraEnUtc': '2026-09-04T00:00:00Z',
    });
    expect(result.idCliente, 9);
    expect(result.token, 'jwt-prueba');
    expect(result.usuario.rol, 'Cliente');
  });

  test('Vehiculo interpreta la respuesta anidada del catálogo', () {
    final result = Vehiculo.fromCatalogJson({
      'idCatalogo': 3,
      'fechaPublicacion': '2026-09-03T12:00:00Z',
      'vehiculo': {
        'idVehiculo': 5,
        'vin': '1HGCM82633A654321',
        'marca': 'Toyota',
        'modelo': 'Corolla',
        'anio': 2020,
        'kilometraje': 45000,
        'precioCompra': 6500,
        'precioVenta': 8900,
        'condicion': 'Usado',
        'requiereReparacion': false,
        'enCatalogo': true,
        'disponibilidad': 'Disponible',
      },
    });
    expect(result.idCatalogo, 3);
    expect(result.idVehiculo, 5);
    expect(result.precioVenta, 8900);
  });

  test('SolicitudCotizacion interpreta la respuesta real de la API', () {
    final result = SolicitudCotizacion.fromJson({
      'idSolicitudCotizacion': 1,
      'idCliente': 2,
      'idSolicitud': 7,
      'idVehiculo': null,
      'fechaSolicitud': '2026-09-03T20:00:00',
      'observaciones': 'Cotizar transporte e impuestos.',
      'estado': 'Pendiente',
      'fechaAtencion': null,
    });

    expect(result.idSolicitud, 7);
    expect(result.idVehiculo, isNull);
    expect(result.estado, 'Pendiente');
  });
}
