class EstadoVehiculo {
  const EstadoVehiculo({
    required this.idEstado,
    required this.nombre,
    this.descripcion,
    required this.fechaEstado,
  });
  final int idEstado;
  final String nombre;
  final String? descripcion;
  final DateTime fechaEstado;

  factory EstadoVehiculo.fromJson(Map<String, dynamic> json) => EstadoVehiculo(
    idEstado: (json['idEstado'] as num).toInt(),
    nombre: json['nombre'] as String? ?? '',
    descripcion: json['descripcion'] as String?,
    fechaEstado: DateTime.parse(json['fechaEstado'] as String),
  );
}
