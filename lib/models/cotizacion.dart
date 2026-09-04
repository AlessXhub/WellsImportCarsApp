import 'detalle_cotizacion.dart';

class Cotizacion {
  const Cotizacion({
    required this.idCotizacion,
    required this.idSolicitud,
    required this.idCliente,
    required this.idVehiculo,
    required this.fechaCotizacion,
    required this.vencimiento,
    required this.montoTotal,
    required this.estado,
    this.observaciones,
    required this.detalles,
  });
  final int idCotizacion;
  final int idSolicitud;
  final int idCliente;
  final int idVehiculo;
  final DateTime fechaCotizacion;
  final DateTime vencimiento;
  final double montoTotal;
  final String estado;
  final String? observaciones;
  final List<DetalleCotizacion> detalles;

  factory Cotizacion.fromJson(Map<String, dynamic> json) => Cotizacion(
    idCotizacion: (json['idCotizacion'] as num).toInt(),
    idSolicitud: (json['idSolicitud'] as num).toInt(),
    idCliente: (json['idCliente'] as num).toInt(),
    idVehiculo: (json['idVehiculo'] as num).toInt(),
    fechaCotizacion: DateTime.parse(json['fechaCotizacion'] as String),
    vencimiento: DateTime.parse(json['vencimiento'] as String),
    montoTotal: (json['montoTotal'] as num).toDouble(),
    estado: json['estado'] as String? ?? '',
    observaciones: json['observaciones'] as String?,
    detalles: ((json['detalles'] as List?) ?? const [])
        .map((e) => DetalleCotizacion.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
