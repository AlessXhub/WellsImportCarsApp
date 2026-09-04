import '../models/cotizacion.dart';
import '../models/solicitud_cotizacion.dart';
import 'api_service.dart';

class CotizacionService {
  CotizacionService(this._api);
  final ApiService _api;

  Future<List<Cotizacion>> getMine(String token) async =>
      ((await _api.get('/api/cotizaciones', token: token)) as List)
          .map((e) => Cotizacion.fromJson(e as Map<String, dynamic>))
          .toList();
  Future<Cotizacion> getById(int id, String token) async => Cotizacion.fromJson(
    (await _api.get('/api/cotizaciones/$id', token: token))
        as Map<String, dynamic>,
  );

  Future<List<SolicitudCotizacion>> getMyRequests(String token) async =>
      ((await _api.get('/api/cotizaciones/solicitudes', token: token)) as List)
          .map((e) => SolicitudCotizacion.fromJson(e as Map<String, dynamic>))
          .toList();

  Future<SolicitudCotizacion> requestQuote({
    required String token,
    int? idSolicitud,
    int? idVehiculo,
    String? observaciones,
  }) async => SolicitudCotizacion.fromJson(
    (await _api.post('/api/cotizaciones/solicitudes', {
          'idSolicitud': idSolicitud,
          'idVehiculo': idVehiculo,
          'observaciones': observaciones?.trim().isEmpty == true
              ? null
              : observaciones?.trim(),
        }, token: token))
        as Map<String, dynamic>,
  );
}
