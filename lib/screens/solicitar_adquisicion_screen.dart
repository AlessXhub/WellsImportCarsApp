import 'package:flutter/material.dart';
import '../models/vehiculo.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';
import '../widgets/feature_unavailable_widget.dart';
import '../widgets/status_chip.dart';
import '../widgets/vehicle_visual.dart';

class SolicitarAdquisicionScreen extends StatelessWidget {
  const SolicitarAdquisicionScreen({
    super.key,
    required this.vehiculo,
    required this.session,
  });
  final Vehiculo vehiculo;
  final SessionService session;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Solicitar adquisición')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const VehicleVisual(height: 170),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadii.large),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${vehiculo.marca} ${vehiculo.modelo}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  StatusChip(label: vehiculo.disponibilidad, compact: true),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Vehículo #${vehiculo.idVehiculo} · Cliente #${session.idCliente}',
              ),
              const SizedBox(height: 12),
              Text(
                vehiculo.precioVenta == null
                    ? 'Precio por consultar'
                    : '\$${vehiculo.precioVenta!.toStringAsFixed(2)}',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: AppColors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const FeatureUnavailableWidget(
          title: 'Adquisición pendiente en la API',
          message:
              'No existe un endpoint de reserva o solicitud de adquisición para Cliente. POST /api/ventas pertenece exclusivamente a Empleado y Administrador.',
        ),
      ],
    ),
  );
}
