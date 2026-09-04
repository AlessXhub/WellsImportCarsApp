import 'package:flutter/material.dart';

import '../models/vehiculo.dart';
import '../services/catalogo_service.dart';
import '../services/cotizacion_service.dart';
import '../services/session_service.dart';
import '../services/solicitud_service.dart';
import '../theme/app_theme.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/reveal.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/status_chip.dart';
import '../widgets/vehicle_visual.dart';
import 'solicitar_adquisicion_screen.dart';
import 'solicitar_cotizacion_screen.dart';

class VehiculoDetailScreen extends StatefulWidget {
  const VehiculoDetailScreen({
    super.key,
    required this.vehiculo,
    required this.catalogoService,
    required this.cotizacionService,
    required this.solicitudService,
    required this.session,
    required this.onRequireLogin,
  });

  final Vehiculo vehiculo;
  final CatalogoService catalogoService;
  final CotizacionService cotizacionService;
  final SolicitudService solicitudService;
  final SessionService session;
  final Future<void> Function() onRequireLogin;

  @override
  State<VehiculoDetailScreen> createState() => _VehiculoDetailScreenState();
}

class _VehiculoDetailScreenState extends State<VehiculoDetailScreen> {
  late Vehiculo _vehiculo;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _vehiculo = widget.vehiculo;
    if (_vehiculo.idCatalogo != null) {
      _load();
    }
  }

  Future<void> _load() async {
    final idCatalogo = _vehiculo.idCatalogo;
    if (idCatalogo == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final detail = await widget.catalogoService.getById(idCatalogo);
      if (!mounted) return;
      setState(() => _vehiculo = detail);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detalle del vehículo')),
    body: _loading
        ? const LoadingWidget(
            message: 'Cargando detalle del vehículo...',
            type: SkeletonType.detail,
          )
        : _error != null
        ? ApiErrorWidget(message: _error!, onRetry: _load)
        : _buildDetail(context),
    bottomNavigationBar: _loading || _error != null ? null : _actions(context),
  );

  Widget _buildDetail(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
    children: [
      Reveal(
        child: VehicleVisual(
          height: 235,
          heroTag: 'vehicle-${_vehiculo.idVehiculo}',
        ),
      ),
      const SizedBox(height: 22),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_vehiculo.marca} ${_vehiculo.modelo}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 7),
                Text(
                  '${_vehiculo.anio}  ·  ${_vehiculo.condicion}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          StatusChip(label: _vehiculo.disponibilidad),
        ],
      ),
      const SizedBox(height: 22),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadii.large),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PRECIO DE VENTA',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _vehiculo.precioVenta == null
                        ? 'Consultar'
                        : '\$${_vehiculo.precioVenta!.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.verified_outlined, color: AppColors.red),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Text('Especificaciones', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _info('VIN', _vehiculo.vin),
          _info('Carrocería', _vehiculo.tipoCarroceria ?? '-'),
          _info('Combustible', _vehiculo.tipoCombustible ?? '-'),
          _info('Color', _vehiculo.color ?? '-'),
          _info('Kilometraje', '${_vehiculo.kilometraje} km'),
          _info(
            'Reparación',
            _vehiculo.requiereReparacion ? 'Requerida' : 'No',
          ),
        ],
      ),
      if (_vehiculo.descripcion?.isNotEmpty == true) ...[
        const SizedBox(height: 26),
        Text('Descripción', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(AppRadii.medium),
          ),
          child: Text(
            _vehiculo.descripcion!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.55,
            ),
          ),
        ),
      ],
    ],
  );

  Widget _actions(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border(
        top: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
    ),
    child: SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: !widget.session.isAuthenticated
          ? FilledButton.icon(
              onPressed: widget.onRequireLogin,
              icon: const Icon(Icons.login_rounded),
              label: const Text('Iniciar sesión para solicitar'),
            )
          : Row(
              children: [
                Expanded(
                  flex: 3,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SolicitarCotizacionScreen(
                          vehiculo: _vehiculo,
                          service: widget.cotizacionService,
                          solicitudService: widget.solicitudService,
                          session: widget.session,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.request_quote_rounded),
                    label: const Text('Cotizar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    onPressed: _vehiculo.disponibilidad == 'Disponible'
                        ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SolicitarAdquisicionScreen(
                                vehiculo: _vehiculo,
                                session: widget.session,
                              ),
                            ),
                          )
                        : null,
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text('Adquirir'),
                  ),
                ),
              ],
            ),
    ),
  );

  Widget _info(String label, String value) => SizedBox(
    width: 158,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.medium),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 9,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    ),
  );
}
