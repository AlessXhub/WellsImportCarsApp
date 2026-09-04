class Adquisicion {
  const Adquisicion({
    required this.idVehiculo,
    required this.idCliente,
    this.observaciones,
  });
  final int idVehiculo;
  final int idCliente;
  final String? observaciones;

  Map<String, dynamic> toJson() => {
    'idVehiculo': idVehiculo,
    'idCliente': idCliente,
    'observaciones': observaciones,
  };
}
