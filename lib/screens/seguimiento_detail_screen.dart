import 'package:flutter/material.dart';
import '../models/importacion.dart';
import '../models/view_state.dart';
import '../services/seguimiento_service.dart';
import '../theme/app_theme.dart';
import '../widgets/error_widget.dart';
import '../widgets/estado_timeline.dart';
import '../widgets/loading_widget.dart';
import '../widgets/reveal.dart';
import '../widgets/status_chip.dart';

class SeguimientoDetailScreen extends StatefulWidget {
  const SeguimientoDetailScreen({
    super.key,
    required this.id,
    required this.service,
    required this.token,
  });
  final int id;
  final SeguimientoService service;
  final String token;
  @override
  State<SeguimientoDetailScreen> createState() =>
      _SeguimientoDetailScreenState();
}

class _SeguimientoDetailScreenState extends State<SeguimientoDetailScreen> {
  ViewState _state = ViewState.initial;
  Importacion? _item;
  String _error = '';
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = ViewState.loading);
    try {
      final data = await widget.service.getById(widget.id, widget.token);
      if (mounted) {
        setState(() {
          _item = data;
          _state = ViewState.success;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _state = ViewState.error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Seguimiento #${widget.id}')),
    body: _state == ViewState.loading || _state == ViewState.initial
        ? const LoadingWidget()
        : _state == ViewState.error
        ? ApiErrorWidget(message: _error, onRetry: _load)
        : ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            children: [
              Reveal(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(AppRadii.hero),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.black,
                        AppColors.blackSoft,
                        Color(0xFF420000),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(
                                AppRadii.medium,
                              ),
                            ),
                            child: const Icon(
                              Icons.local_shipping_rounded,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Vehículo #${_item!.idVehiculo}',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(color: AppColors.white),
                                ),
                                Text(
                                  'Importación #${_item!.idImportacion}',
                                  style: const TextStyle(
                                    color: Color(0xFFAAAAAF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      StatusChip(
                        label: _item!.estadoActual?.nombre ?? 'Sin estado',
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _routePoint(
                              context,
                              'ORIGEN',
                              _item!.puertoSalida ?? 'Pendiente',
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.red,
                            ),
                          ),
                          Expanded(
                            child: _routePoint(
                              context,
                              'DESTINO',
                              _item!.puertoLlegada ?? 'Pendiente',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _detail(
                    context,
                    'Naviera',
                    _item!.naviera ?? 'Por confirmar',
                    Icons.sailing_outlined,
                  ),
                  _detail(
                    context,
                    'Contenedor',
                    _item!.contenedor ?? 'Por confirmar',
                    Icons.inventory_2_outlined,
                  ),
                  _detail(
                    context,
                    'Llegada estimada',
                    _item!.fechaLlegadaEstimada
                            ?.toIso8601String()
                            .split('T')
                            .first ??
                        'Por confirmar',
                    Icons.event_available_outlined,
                  ),
                  _detail(
                    context,
                    'Costo de flete',
                    '\$${_item!.costoFlete.toStringAsFixed(2)}',
                    Icons.payments_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Text(
                'Progreso de la importación',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              Text(
                'Cada etapa registrada por el equipo aparece en orden cronológico.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              EstadoTimeline(estados: _item!.estados),
            ],
          ),
  );

  Widget _routePoint(BuildContext context, String label, String value) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFFFF7777),
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: AppColors.white),
          ),
        ],
      );

  Widget _detail(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) => Container(
    width: (MediaQuery.sizeOf(context).width - 42) / 2,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadii.medium),
      border: Border.all(color: Theme.of(context).colorScheme.outline),
    ),
    child: Row(
      children: [
        Icon(icon, size: 21, color: AppColors.red),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
