import 'package:flutter/material.dart';
import '../models/importacion.dart';
import '../models/view_state.dart';
import '../services/seguimiento_service.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/reveal.dart';
import '../widgets/section_header.dart';
import '../widgets/status_chip.dart';
import 'seguimiento_detail_screen.dart';

class SeguimientosScreen extends StatefulWidget {
  const SeguimientosScreen({
    super.key,
    required this.service,
    required this.session,
  });
  final SeguimientoService service;
  final SessionService session;
  @override
  State<SeguimientosScreen> createState() => _SeguimientosScreenState();
}

class _SeguimientosScreenState extends State<SeguimientosScreen> {
  ViewState _state = ViewState.initial;
  List<Importacion> _items = const [];
  String _error = '';
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = ViewState.loading);
    try {
      final data = await widget.service.getMine(widget.session.token!);
      if (mounted) {
        setState(() {
          _items = data;
          _state = data.isEmpty ? ViewState.empty : ViewState.success;
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
    appBar: AppBar(title: const Text('Seguimiento')),
    body: switch (_state) {
      ViewState.loading || ViewState.initial => const LoadingWidget(
        message: 'Consultando seguimientos...',
      ),
      ViewState.error => ApiErrorWidget(message: _error, onRetry: _load),
      ViewState.empty => const EmptyWidget(
        title: 'Sin importaciones activas',
        message: 'Aquí verás la ruta y el avance de tus vehículos adquiridos.',
        icon: Icons.local_shipping_outlined,
      ),
      ViewState.success => RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const PremiumPageHeader(
              eyebrow: 'Logística en tiempo real',
              title: 'Seguimiento',
              subtitle:
                  'Compra, flete, aduana y entrega en una sola línea de tiempo.',
              icon: Icons.route_rounded,
            ),
            ..._items.map(
              (item) => Reveal(
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadii.large),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeguimientoDetailScreen(
                        id: item.idImportacion,
                        service: widget.service,
                        token: widget.session.token!,
                      ),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadii.large),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: AppColors.black,
                                borderRadius: BorderRadius.circular(
                                  AppRadii.medium,
                                ),
                              ),
                              child: const Icon(
                                Icons.local_shipping_rounded,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Vehículo #${item.idVehiculo}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Compra ${item.fechaCompra.toIso8601String().split('T').first}',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: StatusChip(
                                label:
                                    item.estadoActual?.nombre ?? 'Sin estado',
                                compact: true,
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    },
  );
}
