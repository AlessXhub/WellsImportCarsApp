import '../models/importacion.dart';
import 'api_service.dart';

class SeguimientoService {
  SeguimientoService(this._api);
  final ApiService _api;

  Future<List<Importacion>> getMine(String token) async =>
      ((await _api.get('/api/importaciones', token: token)) as List)
          .map((e) => Importacion.fromJson(e as Map<String, dynamic>))
          .toList();
  Future<Importacion> getById(int id, String token) async =>
      Importacion.fromJson(
        (await _api.get('/api/importaciones/$id', token: token))
            as Map<String, dynamic>,
      );
}
