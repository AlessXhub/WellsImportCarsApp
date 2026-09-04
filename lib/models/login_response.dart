import 'usuario.dart';

class LoginResponse {
  const LoginResponse({
    required this.usuario,
    required this.token,
    this.idCliente,
    this.idEmpleado,
    required this.expiraEnUtc,
  });

  final Usuario usuario;
  final int? idCliente;
  final int? idEmpleado;
  final String token;
  final DateTime expiraEnUtc;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    usuario: Usuario.fromJson(json),
    idCliente: (json['idCliente'] as num?)?.toInt(),
    idEmpleado: (json['idEmpleado'] as num?)?.toInt(),
    token: json['token'] as String? ?? '',
    expiraEnUtc: DateTime.parse(json['expiraEnUtc'] as String),
  );
}
