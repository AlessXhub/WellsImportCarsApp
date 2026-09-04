import 'package:flutter/material.dart';

import '../models/cotizacion.dart';
import '../models/solicitud_cotizacion.dart';
import '../models/view_state.dart';
import '../services/cotizacion_service.dart';
import '../services/session_service.dart';
import '../services/solicitud_service.dart';
import '../theme/app_theme.dart';
import '../widgets/cotizacion_card.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/reveal.dart';
import '../widgets/section_header.dart';
import '../widgets/status_chip.dart';
import 'cotizacion_detail_screen.dart';
import 'solicitar_cotizacion_screen.dart';

class CotizacionesScreen extends StatefulWidget {
  const CotizacionesScreen({
    super.key,
    required this.service,
    required this.solicitudService,
    required this.session,
  });

  final CotizacionService service;
  final SolicitudService solicitudService;
  final SessionService session;

  @override
  State<CotizacionesScreen> createState() => _CotizacionesScreenState();
}

class _CotizacionesScreenState extends State<CotizacionesScreen> {
  ViewState _state = ViewState.initial;
  List<SolicitudCotizacion> _requests = const [];
  List<Cotizacion> _quotes = const [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = ViewState.loading);
    try {
      final requestFuture = widget.service.getMyRequests(widget.session.token!);
      final quoteFuture = widget.service.getMine(widget.session.token!);
      final requests = await requestFuture;
      final quotes = await quoteFuture;
      if (!mounted) return;
      setState(() {
        _requests = requests;
        _quotes = quotes;
        _state = ViewState.success;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _state = ViewState.error;
      });
    }
  }

  Future<void> _newRequest() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => SolicitarCotizacionScreen(
          service: widget.service,
          solicitudService: widget.solicitudService,
          session: widget.session,
        ),
      ),
    );
    if (created == true) _load();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Cotizaciones'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Solicitudes'),
            Tab(text: 'Recibidas'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _state == ViewState.loading ? null : _load,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newRequest,
        icon: const Icon(Icons.add_comment_outlined),
        label: const Text('Solicitar'),
      ),
      body: _content(),
    ),
  );

  Widget _content() {
    if (_state == ViewState.loading || _state == ViewState.initial) {
      return const LoadingWidget(message: 'Consultando cotizaciones...');
    }
    if (_state == ViewState.error) {
      return ApiErrorWidget(message: _error, onRetry: _load);
    }
    return Column(
      children: [
        const PremiumPageHeader(
          eyebrow: 'Decisiones transparentes',
          title: 'Tus cotizaciones',
          subtitle:
              'Solicita una propuesta y revisa costos, vigencia y conceptos.',
          icon: Icons.receipt_long_rounded,
        ),
        Expanded(
          child: TabBarView(
            children: [
              _requests.isEmpty
                  ? EmptyWidget(
                      title: 'Aún no has solicitado',
                      message:
                          'Pide una cotización desde una solicitud o desde un vehículo del catálogo.',
                      icon: Icons.mark_email_unread_outlined,
                      actionLabel: 'Solicitar cotización',
                      onAction: _newRequest,
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 92),
                        itemCount: _requests.length,
                        itemBuilder: (_, index) =>
                            Reveal(child: _requestCard(_requests[index])),
                      ),
                    ),
              _quotes.isEmpty
                  ? const EmptyWidget(
                      title: 'Sin propuestas recibidas',
                      message:
                          'Las cotizaciones preparadas por el equipo aparecerán aquí.',
                      icon: Icons.request_quote_outlined,
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 92),
                        itemCount: _quotes.length,
                        itemBuilder: (_, index) => Reveal(
                          child: CotizacionCard(
                            cotizacion: _quotes[index],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CotizacionDetailScreen(
                                  id: _quotes[index].idCotizacion,
                                  service: widget.service,
                                  token: widget.session.token!,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _requestCard(SolicitudCotizacion request) {
    final source = request.idSolicitud != null
        ? 'Solicitud #${request.idSolicitud}'
        : 'Vehículo #${request.idVehiculo}';
    final date = request.fechaSolicitud.toIso8601String().split('T').first;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadii.medium),
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 21,
                  color: AppColors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  source,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              StatusChip(label: request.estado, compact: true),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            date,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: .6,
            ),
          ),
          if (request.observaciones?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              request.observaciones!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
