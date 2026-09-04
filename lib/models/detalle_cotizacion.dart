class DetalleCotizacion {
  const DetalleCotizacion({
    required this.idDetalle,
    required this.descripcion,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });
  final int idDetalle;
  final String descripcion;
  final double cantidad;
  final double precioUnitario;
  final double subtotal;

  factory DetalleCotizacion.fromJson(Map<String, dynamic> json) =>
      DetalleCotizacion(
        idDetalle: (json['idDetalle'] as num).toInt(),
        descripcion: json['descripcion'] as String? ?? '',
        cantidad: (json['cantidad'] as num).toDouble(),
        precioUnitario: (json['precioUnitario'] as num).toDouble(),
        subtotal: (json['subtotal'] as num).toDouble(),
      );
}
