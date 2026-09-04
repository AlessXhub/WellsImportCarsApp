class Vehiculo {
  const Vehiculo({
    required this.idVehiculo,
    this.idCatalogo,
    this.fechaPublicacion,
    required this.vin,
    required this.marca,
    required this.modelo,
    required this.anio,
    this.tipoCarroceria,
    this.tipoCombustible,
    this.color,
    required this.kilometraje,
    required this.precioCompra,
    this.precioVenta,
    required this.condicion,
    this.descripcion,
    required this.requiereReparacion,
    required this.enCatalogo,
    required this.disponibilidad,
  });

  final int idVehiculo;
  final int? idCatalogo;
  final DateTime? fechaPublicacion;
  final String vin;
  final String marca;
  final String modelo;
  final int anio;
  final String? tipoCarroceria;
  final String? tipoCombustible;
  final String? color;
  final int kilometraje;
  final double precioCompra;
  final double? precioVenta;
  final String condicion;
  final String? descripcion;
  final bool requiereReparacion;
  final bool enCatalogo;
  final String disponibilidad;

  factory Vehiculo.fromJson(Map<String, dynamic> json) => Vehiculo(
    idVehiculo: (json['idVehiculo'] as num).toInt(),
    vin: json['vin'] as String? ?? '',
    marca: json['marca'] as String? ?? '',
    modelo: json['modelo'] as String? ?? '',
    anio: (json['anio'] as num).toInt(),
    tipoCarroceria: json['tipoCarroceria'] as String?,
    tipoCombustible: json['tipoCombustible'] as String?,
    color: json['color'] as String?,
    kilometraje: (json['kilometraje'] as num?)?.toInt() ?? 0,
    precioCompra: (json['precioCompra'] as num?)?.toDouble() ?? 0,
    precioVenta: (json['precioVenta'] as num?)?.toDouble(),
    condicion: json['condicion'] as String? ?? '',
    descripcion: json['descripcion'] as String?,
    requiereReparacion: json['requiereReparacion'] as bool? ?? false,
    enCatalogo: json['enCatalogo'] as bool? ?? false,
    disponibilidad: json['disponibilidad'] as String? ?? '',
  );

  factory Vehiculo.fromCatalogJson(Map<String, dynamic> json) {
    final vehicle = Vehiculo.fromJson(json['vehiculo'] as Map<String, dynamic>);
    return Vehiculo(
      idVehiculo: vehicle.idVehiculo,
      idCatalogo: (json['idCatalogo'] as num).toInt(),
      fechaPublicacion: DateTime.parse(json['fechaPublicacion'] as String),
      vin: vehicle.vin,
      marca: vehicle.marca,
      modelo: vehicle.modelo,
      anio: vehicle.anio,
      tipoCarroceria: vehicle.tipoCarroceria,
      tipoCombustible: vehicle.tipoCombustible,
      color: vehicle.color,
      kilometraje: vehicle.kilometraje,
      precioCompra: vehicle.precioCompra,
      precioVenta: vehicle.precioVenta,
      condicion: vehicle.condicion,
      descripcion: vehicle.descripcion,
      requiereReparacion: vehicle.requiereReparacion,
      enCatalogo: vehicle.enCatalogo,
      disponibilidad: vehicle.disponibilidad,
    );
  }
}
