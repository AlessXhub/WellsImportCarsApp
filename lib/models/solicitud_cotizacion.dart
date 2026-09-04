class SolicitudCotizacion {
  const SolicitudCotizacion({
    required this.idSolicitudCotizacion,
    required this.idCliente,
    this.idSolicitud,
    this.idVehiculo,
    required this.fechaSolicitud,
    this.observaciones,
    required this.estado,
    this.fechaAtencion,
  });

  final int idSolicitudCotizacion;
  final int idCliente;
  final int? idSolicitud;
  final int? idVehiculo;
  final DateTime fechaSolicitud;
  final String? observaciones;
  final String estado;
  final DateTime? fechaAtencion;

  factory SolicitudCotizacion.fromJson(Map<String, dynamic> json) =>
      SolicitudCotizacion(
        idSolicitudCotizacion: (json['idSolicitudCotizacion'] as num).toInt(),
        idCliente: (json['idCliente'] as num).toInt(),
        idSolicitud: (json['idSolicitud'] as num?)?.toInt(),
        idVehiculo: (json['idVehiculo'] as num?)?.toInt(),
        fechaSolicitud: DateTime.parse(json['fechaSolicitud'] as String),
        observaciones: json['observaciones'] as String?,
        estado: json['estado'] as String? ?? '',
        fechaAtencion: json['fechaAtencion'] == null
            ? null
            : DateTime.parse(json['fechaAtencion'] as String),
      );
}
