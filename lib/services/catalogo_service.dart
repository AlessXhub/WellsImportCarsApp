import '../models/vehiculo.dart';
import 'api_service.dart';

class CatalogoService {
  CatalogoService(this._api);
  final ApiService _api;

  Future<List<Vehiculo>> getAll() async =>
      ((await _api.get('/api/catalogo')) as List)
          .map((e) => Vehiculo.fromCatalogJson(e as Map<String, dynamic>))
          .toList();
  Future<Vehiculo> getById(int idCatalogo) async => Vehiculo.fromCatalogJson(
    (await _api.get('/api/catalogo/$idCatalogo')) as Map<String, dynamic>,
  );
}
