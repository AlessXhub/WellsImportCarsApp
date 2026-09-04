import '../models/login_response.dart';
import '../models/usuario.dart';

class SessionService {
  LoginResponse? _session;
  LoginResponse? get session => _session;
  String? get token => _session?.token;
  int? get idCliente => _session?.idCliente;
  Usuario? get usuario => _session?.usuario;
  bool get isAuthenticated =>
      token?.isNotEmpty == true && usuario?.rol == 'Cliente';

  void start(LoginResponse response) => _session = response;
  void clear() => _session = null;
}
