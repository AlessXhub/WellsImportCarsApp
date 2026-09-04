import '../models/cliente.dart';
import 'api_service.dart';

class ClienteService {
  ClienteService(this._api);
  final ApiService _api;

  Future<Cliente> getProfile(int idCliente, String token) async =>
      Cliente.fromJson(
        (await _api.get('/api/clientes/$idCliente', token: token))
            as Map<String, dynamic>,
      );
}
