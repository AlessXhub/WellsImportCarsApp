import 'package:flutter/material.dart';
import '../models/solicitud.dart';
import '../models/view_state.dart';
import '../services/session_service.dart';
import '../services/solicitud_service.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/reveal.dart';
import '../widgets/section_header.dart';
import '../widgets/status_chip.dart';
import 'nueva_solicitud_screen.dart';

class MisSolicitudesScreen extends StatefulWidget {
  const MisSolicitudesScreen({
    super.key,
    required this.service,
    required this.session,
  });
  final SolicitudService service;
  final SessionService session;
  @override
  State<MisSolicitudesScreen> createState() => _MisSolicitudesScreenState();
}

class _MisSolicitudesScreenState extends State<MisSolicitudesScreen> {
  ViewState _state = ViewState.initial;
  List<Solicitud> _items = const [];
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

  Future<void> _new() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => NuevaSolicitudScreen(
          service: widget.service,
          session: widget.session,
        ),
      ),
    );
    if (created == true) _load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Solicitudes')),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _new,
      icon: const Icon(Icons.add),
      label: const Text('Nueva'),
    ),
    body: switch (_state) {
      ViewState.loading || ViewState.initial => const LoadingWidget(
        message: 'Consultando solicitudes...',
      ),
      ViewState.error => ApiErrorWidget(message: _error, onRetry: _load),
      ViewState.empty => EmptyWidget(
        title: 'Tu búsqueda comienza aquí',
        message: 'Cuéntanos qué vehículo buscas y prepararemos el proceso.',
        icon: Icons.assignment_outlined,
        actionLabel: 'Crear solicitud',
        onAction: _new,
      ),
      ViewState.success => RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 92),
          children: [
            const PremiumPageHeader(
              eyebrow: 'Búsquedas personalizadas',
              title: 'Mis solicitudes',
              subtitle:
                  'Consulta lo que pediste y el estado actual de cada búsqueda.',
              icon: Icons.manage_search_rounded,
            ),
            ..._items.map(
              (item) => Reveal(
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
                            width: 42,
                            height: 42,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(
                                AppRadii.medium,
                              ),
                            ),
                            child: Text(
                              '#${item.idSolicitud}',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${item.marcaDeseada} ${item.modeloDeseado}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          StatusChip(label: item.estado, compact: true),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Divider(height: 1),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _fact(
                              context,
                              'AÑO',
                              '${item.anioDeseado ?? 'Flexible'}',
                            ),
                          ),
                          Expanded(
                            child: _fact(
                              context,
                              'PRESUPUESTO',
                              '\$${item.presupuestoMax.toStringAsFixed(2)}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    },
  );

  Widget _fact(BuildContext context, String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 9,
          letterSpacing: 1,
        ),
      ),
      const SizedBox(height: 4),
      Text(value, style: Theme.of(context).textTheme.titleSmall),
    ],
  );
}
