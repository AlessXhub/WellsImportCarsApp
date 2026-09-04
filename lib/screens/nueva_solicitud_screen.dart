import 'package:flutter/material.dart';
import '../models/solicitud.dart';
import '../models/view_state.dart';
import '../services/session_service.dart';
import '../services/solicitud_service.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';

class NuevaSolicitudScreen extends StatefulWidget {
  const NuevaSolicitudScreen({
    super.key,
    required this.service,
    required this.session,
  });
  final SolicitudService service;
  final SessionService session;
  @override
  State<NuevaSolicitudScreen> createState() => _NuevaSolicitudScreenState();
}

class _NuevaSolicitudScreenState extends State<NuevaSolicitudScreen> {
  final _key = GlobalKey<FormState>();
  final _marca = TextEditingController(),
      _modelo = TextEditingController(),
      _anio = TextEditingController(),
      _presupuesto = TextEditingController(),
      _carroceria = TextEditingController(),
      _combustible = TextEditingController(),
      _observaciones = TextEditingController();
  ViewState _state = ViewState.initial;
  String? _error;

  @override
  void dispose() {
    for (final controller in [
      _marca,
      _modelo,
      _anio,
      _presupuesto,
      _carroceria,
      _combustible,
      _observaciones,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _state = ViewState.loading;
      _error = null;
    });
    final request = Solicitud(
      idSolicitud: 0,
      idCliente: widget.session.idCliente!,
      fechaSolicitud: DateTime.now(),
      marcaDeseada: _marca.text.trim(),
      modeloDeseado: _modelo.text.trim(),
      anioDeseado: int.tryParse(_anio.text),
      presupuestoMax: double.parse(_presupuesto.text),
      tipoCarroceria: _carroceria.text.trim(),
      tipoCombustible: _combustible.text.trim(),
      observaciones: _observaciones.text.trim(),
      estado: 'Pendiente',
    );
    try {
      await widget.service.create(request, widget.session.token!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solicitud creada correctamente.')),
        );
        Navigator.pop(context, true);
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
    appBar: AppBar(title: const Text('Solicitar vehículo')),
    body: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 28,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        Icons.manage_search_rounded,
                        color: AppColors.red,
                        size: 34,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Dinos qué vehículo buscas.',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: AppColors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Nuestro equipo usará estos criterios para preparar opciones reales.',
                        style: TextStyle(
                          color: Color(0xFFB7B7BC),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const SectionHeader(
                  eyebrow: 'Preferencias',
                  title: 'Vehículo ideal',
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: _field(_marca, 'Marca deseada')),
                    const SizedBox(width: 10),
                    Expanded(child: _field(_modelo, 'Modelo deseado')),
                  ],
                ),
                _field(
                  _anio,
                  'Año deseado',
                  keyboard: TextInputType.number,
                  validator: (v) {
                    final year = int.tryParse(v ?? '');
                    return year == null || year < 1900 || year > 2100
                        ? 'Ingrese un año entre 1900 y 2100.'
                        : null;
                  },
                ),
                _field(
                  _presupuesto,
                  'Presupuesto máximo',
                  keyboard: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0
                      ? 'El presupuesto debe ser mayor que cero.'
                      : null,
                ),
                _field(_carroceria, 'Tipo de carrocería'),
                _field(_combustible, 'Tipo de combustible'),
                const SizedBox(height: 8),
                const SectionHeader(
                  eyebrow: 'Detalles adicionales',
                  title: 'Observaciones',
                ),
                const SizedBox(height: 14),
                _field(
                  _observaciones,
                  'Información opcional',
                  required: false,
                  lines: 4,
                ),
                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(AppRadii.small),
                    ),
                    child: Text(_error!),
                  ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: _state == ViewState.loading ? null : _submit,
                  icon: _state == ViewState.loading
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded),
                  label: Text(
                    _state == ViewState.loading
                        ? 'Enviando...'
                        : 'Enviar solicitud',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  Widget _field(
    TextEditingController c,
    String label, {
    TextInputType? keyboard,
    String? Function(String?)? validator,
    bool required = true,
    int lines = 1,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: c,
      keyboardType: keyboard,
      maxLines: lines,
      decoration: InputDecoration(labelText: label),
      validator:
          validator ??
          (v) => required && (v ?? '').trim().isEmpty
              ? 'Campo obligatorio.'
              : null,
    ),
  );
}
