class Solicitud {
  const Solicitud({
    required this.idSolicitud,
    required this.idCliente,
    required this.fechaSolicitud,
    required this.marcaDeseada,
    required this.modeloDeseado,
    this.anioDeseado,
    required this.presupuestoMax,
    this.tipoCarroceria,
    this.tipoCombustible,
    this.observaciones,
    required this.estado,
  });

  final int idSolicitud;
  final int idCliente;
  final DateTime fechaSolicitud;
  final String marcaDeseada;
  final String modeloDeseado;
  final int? anioDeseado;
  final double presupuestoMax;
  final String? tipoCarroceria;
  final String? tipoCombustible;
  final String? observaciones;
  final String estado;

  factory Solicitud.fromJson(Map<String, dynamic> json) => Solicitud(
    idSolicitud: (json['idSolicitud'] as num).toInt(),
    idCliente: (json['idCliente'] as num).toInt(),
    fechaSolicitud: DateTime.parse(json['fechaSolicitud'] as String),
    marcaDeseada: json['marcaDeseada'] as String? ?? '',
    modeloDeseado: json['modeloDeseado'] as String? ?? '',
    anioDeseado: (json['anioDeseado'] as num?)?.toInt(),
    presupuestoMax: (json['presupuestoMax'] as num).toDouble(),
    tipoCarroceria: json['tipoCarroceria'] as String?,
    tipoCombustible: json['tipoCombustible'] as String?,
    observaciones: json['observaciones'] as String?,
    estado: json['estado'] as String? ?? '',
  );

  Map<String, dynamic> toCreateJson() => {
    'idCliente': idCliente,
    'marcaDeseada': marcaDeseada,
    'modeloDeseado': modeloDeseado,
    'anioDeseado': anioDeseado,
    'presupuestoMax': presupuestoMax,
    'tipoCarroceria': tipoCarroceria,
    'tipoCombustible': tipoCombustible,
    'observaciones': observaciones,
  };
}
