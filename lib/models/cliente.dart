class Cliente {
  const Cliente({
    required this.idCliente,
    required this.idUsuario,
    required this.nombre,
    required this.apellido,
    required this.dui,
    required this.fechaNacimiento,
    required this.correo,
    required this.telefono,
    required this.estado,
  });

  final int idCliente;
  final int idUsuario;
  final String nombre;
  final String apellido;
  final String dui;
  final DateTime fechaNacimiento;
  final String correo;
  final String telefono;
  final String estado;

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
    idCliente: (json['idCliente'] as num).toInt(),
    idUsuario: (json['idUsuario'] as num).toInt(),
    nombre: json['nombre'] as String? ?? '',
    apellido: json['apellido'] as String? ?? '',
    dui: json['dui'] as String? ?? '',
    fechaNacimiento: DateTime.parse(json['fechaNacimiento'] as String),
    correo: json['correo'] as String? ?? '',
    telefono: json['telefono'] as String? ?? '',
    estado: json['estado'] as String? ?? '',
  );
}
