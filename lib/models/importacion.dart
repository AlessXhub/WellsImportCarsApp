import 'estado_vehiculo.dart';

class Importacion {
  const Importacion({
    required this.idImportacion,
    required this.idVehiculo,
    this.idCliente,
    required this.fechaCompra,
    this.fechaSalida,
    this.fechaLlegadaEstimada,
    this.puertoSalida,
    this.puertoLlegada,
    this.naviera,
    this.contenedor,
    required this.costoFlete,
    this.observaciones,
    required this.estados,
  });
  final int idImportacion;
  final int idVehiculo;
  final int? idCliente;
  final DateTime fechaCompra;
  final DateTime? fechaSalida;
  final DateTime? fechaLlegadaEstimada;
  final String? puertoSalida;
  final String? puertoLlegada;
  final String? naviera;
  final String? contenedor;
  final double costoFlete;
  final String? observaciones;
  final List<EstadoVehiculo> estados;

  factory Importacion.fromJson(Map<String, dynamic> json) => Importacion(
    idImportacion: (json['idImportacion'] as num).toInt(),
    idVehiculo: (json['idVehiculo'] as num).toInt(),
    idCliente: (json['idCliente'] as num?)?.toInt(),
    fechaCompra: DateTime.parse(json['fechaCompra'] as String),
    fechaSalida: json['fechaSalida'] == null
        ? null
        : DateTime.parse(json['fechaSalida'] as String),
    fechaLlegadaEstimada: json['fechaLlegadaEstimada'] == null
        ? null
        : DateTime.parse(json['fechaLlegadaEstimada'] as String),
    puertoSalida: json['puertoSalida'] as String?,
    puertoLlegada: json['puertoLlegada'] as String?,
    naviera: json['naviera'] as String?,
    contenedor: json['contenedor'] as String?,
    costoFlete: (json['costoFlete'] as num?)?.toDouble() ?? 0,
    observaciones: json['observaciones'] as String?,
    estados: ((json['estados'] as List?) ?? const [])
        .map((e) => EstadoVehiculo.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  EstadoVehiculo? get estadoActual => estados.isEmpty
      ? null
      : (List<EstadoVehiculo>.from(
          estados,
        )..sort((a, b) => b.fechaEstado.compareTo(a.fechaEstado))).first;
}
