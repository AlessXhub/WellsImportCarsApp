import 'package:flutter/material.dart';

import '../models/vehiculo.dart';
import '../theme/app_theme.dart';
import 'status_chip.dart';
import 'vehicle_visual.dart';

class VehiculoCard extends StatelessWidget {
  const VehiculoCard({super.key, required this.vehiculo, required this.onTap});
  final Vehiculo vehiculo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.large),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                VehicleVisual(
                  heroTag: 'vehicle-${vehiculo.idVehiculo}',
                  height: 118,
                  compact: true,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: StatusChip(
                    label: vehiculo.disponibilidad,
                    compact: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              vehiculo.marca.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 9,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              vehiculo.modelo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              '${vehiculo.anio}  ·  ${vehiculo.condicion}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    vehiculo.precioVenta == null
                        ? 'Consultar precio'
                        : '\$${vehiculo.precioVenta!.toStringAsFixed(2)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    size: 17,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
