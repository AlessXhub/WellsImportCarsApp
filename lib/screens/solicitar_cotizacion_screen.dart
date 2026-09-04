import 'package:flutter/material.dart';

import '../models/solicitud.dart';
import '../models/vehiculo.dart';
import '../models/view_state.dart';
import '../services/cotizacion_service.dart';
import '../services/session_service.dart';
import '../services/solicitud_service.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/section_header.dart';
import '../widgets/vehicle_visual.dart';

class SolicitarCotizacionScreen extends StatefulWidget {
  const SolicitarCotizacionScreen({
    super.key,
    this.vehiculo,
    required this.service,
    required this.solicitudService,
    required this.session,
  });

  final Vehiculo? vehiculo;
  final CotizacionService service;
  final SolicitudService solicitudService;
  final SessionService session;

  @override
  State<SolicitarCotizacionScreen> createState() =>
      _SolicitarCotizacionScreenState();
}

class _SolicitarCotizacionScreenState extends State<SolicitarCotizacionScreen> {
  final _observacionesController = TextEditingController();
  ViewState _state = ViewState.initial;
  List<Solicitud> _solicitudes = const [];
  int? _idSolicitud;
  String _error = '';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.vehiculo == null) {
      _loadSolicitudes();
    } else {
      _state = ViewState.success;
    }
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _loadSolicitudes() async {
    setState(() => _state = ViewState.loading);
    try {
      final data = await widget.solicitudService.getMine(widget.session.token!);
      if (!mounted) return;
      setState(() {
        _solicitudes = data;
        _idSolicitud = data.isEmpty ? null : data.first.idSolicitud;
        _state = data.isEmpty ? ViewState.empty : ViewState.success;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _state = ViewState.error;
      });
    }
  }

  Future<void> _submit() async {
    if (widget.vehiculo == null && _idSolicitud == null) return;
    setState(() => _saving = true);
    try {
      await widget.service.requestQuote(
        token: widget.session.token!,
        idSolicitud: widget.vehiculo == null ? _idSolicitud : null,
        idVehiculo: widget.vehiculo?.idVehiculo,
        observaciones: _observacionesController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud de cotización enviada.')),
      );
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Solicitar cotización')),
    body: switch (_state) {
      ViewState.loading || ViewState.initial => const LoadingWidget(
        message: 'Consultando tus solicitudes...',
      ),
      ViewState.error => ApiErrorWidget(
        message: _error,
        onRetry: _loadSolicitudes,
      ),
      ViewState.empty => _emptyContent(context),
      ViewState.success => _form(context),
    },
  );

  Widget _emptyContent(BuildContext context) => const EmptyWidget(
    title: 'Primero crea una solicitud',
    message:
        'También puedes cotizar directamente desde el detalle de un vehículo disponible.',
    icon: Icons.assignment_outlined,
  );

  Widget _form(BuildContext context) => ListView(
    padding: EdgeInsets.fromLTRB(
      16,
      8,
      16,
      MediaQuery.viewInsetsOf(context).bottom + 28,
    ),
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(AppRadii.hero),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.request_quote_rounded,
              color: AppColors.red,
              size: 34,
            ),
            const SizedBox(height: 24),
            Text(
              'Recibe una propuesta clara.',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 7),
            const Text(
              'El equipo revisará tu petición y detallará cada costo.',
              style: TextStyle(color: Color(0xFFB7B7BC), height: 1.45),
            ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      const SectionHeader(
        eyebrow: 'Origen de la cotización',
        title: 'Selecciona la referencia',
      ),
      const SizedBox(height: 14),
      if (widget.vehiculo != null)
        Column(
          children: [
            const VehicleVisual(height: 130, compact: true),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.directions_car_rounded),
                title: Text(
                  '${widget.vehiculo!.marca} ${widget.vehiculo!.modelo}',
                ),
                subtitle: Text('Vehículo #${widget.vehiculo!.idVehiculo}'),
              ),
            ),
          ],
        )
      else
        DropdownButtonFormField<int>(
          initialValue: _idSolicitud,
          decoration: const InputDecoration(
            labelText: 'Solicitud relacionada',
            prefixIcon: Icon(Icons.assignment_outlined),
          ),
          items: _solicitudes
              .map(
                (item) => DropdownMenuItem(
                  value: item.idSolicitud,
                  child: Text(
                    '#${item.idSolicitud} · ${item.marcaDeseada} ${item.modeloDeseado}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: _saving
              ? null
              : (value) => setState(() => _idSolicitud = value),
        ),
      const SizedBox(height: 22),
      const SectionHeader(
        eyebrow: 'Mensaje al equipo',
        title: '¿Qué deseas conocer?',
      ),
      const SizedBox(height: 14),
      TextField(
        controller: _observacionesController,
        enabled: !_saving,
        maxLength: 500,
        maxLines: 5,
        decoration: const InputDecoration(
          labelText: 'Observaciones (opcional)',
          hintText: 'Describe qué información deseas recibir en la cotización.',
          alignLabelWithHint: true,
        ),
      ),
      const SizedBox(height: 18),
      FilledButton.icon(
        onPressed: _saving ? null : _submit,
        icon: _saving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.send),
        label: Text(_saving ? 'Enviando...' : 'Enviar solicitud'),
      ),
      const SizedBox(height: 12),
      const Text(
        'Un empleado revisará la petición y generará la cotización final con sus precios y conceptos.',
        textAlign: TextAlign.center,
      ),
    ],
  );
}
