import '../models/solicitud.dart';
import 'api_service.dart';

class SolicitudService {
  SolicitudService(this._api);
  final ApiService _api;

  Future<List<Solicitud>> getMine(String token) async =>
      ((await _api.get('/api/solicitudes', token: token)) as List)
          .map((e) => Solicitud.fromJson(e as Map<String, dynamic>))
          .toList();
  Future<Solicitud> create(Solicitud request, String token) async =>
      Solicitud.fromJson(
        (await _api.post(
              '/api/solicitudes',
              request.toCreateJson(),
              token: token,
            ))
            as Map<String, dynamic>,
      );
}
