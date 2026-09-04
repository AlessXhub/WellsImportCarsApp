import 'package:flutter/material.dart';
import '../models/cotizacion.dart';
import '../models/view_state.dart';
import '../services/cotizacion_service.dart';
import '../theme/app_theme.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/reveal.dart';
import '../widgets/status_chip.dart';

class CotizacionDetailScreen extends StatefulWidget {
  const CotizacionDetailScreen({
    super.key,
    required this.id,
    required this.service,
    required this.token,
  });
  final int id;
  final CotizacionService service;
  final String token;
  @override
  State<CotizacionDetailScreen> createState() => _CotizacionDetailScreenState();
}

class _CotizacionDetailScreenState extends State<CotizacionDetailScreen> {
  ViewState _state = ViewState.initial;
  Cotizacion? _item;
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
    appBar: AppBar(title: Text('Cotización #${widget.id}')),
    body: _state == ViewState.loading || _state == ViewState.initial
        ? const LoadingWidget()
        : _state == ViewState.error
        ? ApiErrorWidget(message: _error, onRetry: _load)
        : _content(context),
  );
  Widget _content(BuildContext context) {
    final c = _item!;
    return ListView(
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
                  Color(0xFF4D0000),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StatusChip(label: c.estado),
                    const Spacer(),
                    Text(
                      '#${c.idCotizacion}',
                      style: const TextStyle(color: Color(0xFFAAAAAF)),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'TOTAL ESTIMADO',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFFFF7777),
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${c.montoTotal.toStringAsFixed(2)}',
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  'Vehículo #${c.idVehiculo}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppColors.white),
                ),
                Text(
                  'Solicitud #${c.idSolicitud}',
                  style: const TextStyle(color: Color(0xFFAAAAAF)),
                ),
                Text(
                  'Vencimiento: ${c.vencimiento.toIso8601String().split('T').first}',
                  style: const TextStyle(color: Color(0xFFAAAAAF)),
                ),
              ],
            ),
          ),
        ),
        if (c.observaciones?.isNotEmpty == true) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadii.medium),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.red),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    c.observaciones!,
                    style: const TextStyle(height: 1.45),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        Text('Desglose', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          'Conceptos incluidos en la propuesta.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        ...c.detalles.map(
          (d) => Container(
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadii.medium),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppRadii.small),
                  ),
                  child: const Icon(Icons.add_road_rounded, size: 19),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.descripcion,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '${d.cantidad} × \$${d.precioUnitario.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${d.subtotal.toStringAsFixed(2)}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: AppColors.red),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
