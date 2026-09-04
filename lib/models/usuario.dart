class Usuario {
  const Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.correo,
    required this.rol,
  });

  final int idUsuario;
  final String nombre;
  final String correo;
  final String rol;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    idUsuario: (json['idUsuario'] as num).toInt(),
    nombre: json['nombre'] as String? ?? '',
    correo: json['correo'] as String? ?? '',
    rol: json['rol'] as String? ?? '',
  );
}
