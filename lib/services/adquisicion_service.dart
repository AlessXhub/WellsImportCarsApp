import '../models/adquisicion.dart';

class AdquisicionService {
  static const bool isAvailable = false;

  // Contrato preparado; no se ejecuta porque la API no expone una operación
  // de reserva/adquisición para Cliente. POST /api/ventas es administrativo.
  Future<void> request(Adquisicion request, String token) =>
      throw UnsupportedError(
        'La API aún no expone la solicitud de adquisición para clientes.',
      );
}
