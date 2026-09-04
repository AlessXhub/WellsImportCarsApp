import '../models/login_response.dart';
import 'api_service.dart';

class AuthService {
  AuthService(this._api);
  final ApiService _api;

  Future<LoginResponse> login({
    required String correo,
    required String contrasena,
  }) async {
    final json = await _api.post('/api/auth/login', {
      'correo': correo.trim(),
      'contrasena': contrasena,
    });
    return LoginResponse.fromJson(json as Map<String, dynamic>);
  }

  Future<LoginResponse> register(Map<String, dynamic> body) async {
    final json = await _api.post('/api/auth/registro', body);
    return LoginResponse.fromJson(json as Map<String, dynamic>);
  }
}
