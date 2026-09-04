import 'package:flutter/material.dart';

import '../models/view_state.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';
import '../widgets/brand.dart';
import '../widgets/section_header.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.authService,
    required this.session,
  });
  final AuthService authService;
  final SessionService session;
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();
  final _nombre = TextEditingController(),
      _apellido = TextEditingController(),
      _dui = TextEditingController(),
      _fecha = TextEditingController(),
      _correo = TextEditingController(),
      _telefono = TextEditingController(),
      _password = TextEditingController();
  ViewState _state = ViewState.initial;
  String? _error;
  bool _obscurePassword = true;

  @override
  void dispose() {
    for (final controller in [
      _nombre,
      _apellido,
      _dui,
      _fecha,
      _correo,
      _telefono,
      _password,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 18, now.month, now.day),
      initialDate: DateTime(now.year - 25, now.month, now.day),
    );
    if (selected != null) {
      _fecha.text =
          '${selected.year.toString().padLeft(4, '0')}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;
    final birth = DateTime.tryParse(_fecha.text);
    if (birth == null || DateTime.now().difference(birth).inDays < 365 * 18) {
      setState(() => _error = 'El cliente debe ser mayor de 18 años.');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _state = ViewState.loading;
      _error = null;
    });
    try {
      final response = await widget.authService.register({
        'nombre': _nombre.text.trim(),
        'apellido': _apellido.text.trim(),
        'dui': _dui.text.trim(),
        'fechaNacimiento': _fecha.text.trim(),
        'correo': _correo.text.trim(),
        'telefono': _telefono.text.trim(),
        'contrasena': _password.text,
      });
      widget.session.start(response);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = ViewState.error;
          _error = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Crear cuenta')),
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
          child: AutofillGroup(
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(AppRadii.hero),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BrandLockup(onDark: true),
                        const SizedBox(height: 28),
                        Text(
                          'Empieza tu próxima importación.',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: AppColors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Crea tu perfil de cliente para solicitar vehículos y cotizaciones.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFFB7B7BC),
                                height: 1.45,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(
                    eyebrow: 'Paso 1 de 1',
                    title: 'Datos personales',
                    subtitle:
                        'Usaremos estos datos para identificar tu cuenta.',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _field(_nombre, 'Nombre')),
                      const SizedBox(width: 10),
                      Expanded(child: _field(_apellido, 'Apellido')),
                    ],
                  ),
                  _field(
                    _dui,
                    'DUI (00000000-0)',
                    keyboard: TextInputType.number,
                    validator: (v) => RegExp(r'^\d{8}-\d$').hasMatch(v ?? '')
                        ? null
                        : 'Formato de DUI inválido.',
                  ),
                  _field(
                    _fecha,
                    'Fecha de nacimiento',
                    readOnly: true,
                    onTap: _pickBirthDate,
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                    validator: (v) => DateTime.tryParse(v ?? '') == null
                        ? 'Seleccione una fecha válida.'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  const SectionHeader(
                    eyebrow: 'Acceso seguro',
                    title: 'Datos de contacto',
                  ),
                  const SizedBox(height: 16),
                  _field(
                    _correo,
                    'Correo electrónico',
                    keyboard: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: (v) =>
                        (v ?? '').contains('@') ? null : 'Correo inválido.',
                  ),
                  _field(
                    _telefono,
                    'Teléfono',
                    keyboard: TextInputType.phone,
                    autofillHints: const [AutofillHints.telephoneNumber],
                  ),
                  _field(
                    _password,
                    'Contraseña',
                    obscure: _obscurePassword,
                    autofillHints: const [AutofillHints.newPassword],
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    validator: (v) =>
                        (v ?? '').length < 8 ? 'Mínimo 8 caracteres.' : null,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: _state == ViewState.loading ? null : _submit,
                    icon: _state == ViewState.loading
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.person_add_alt_1_rounded),
                    label: Text(
                      _state == ViewState.loading
                          ? 'Creando cuenta...'
                          : 'Crear mi cuenta',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _field(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    TextInputType? keyboard,
    Iterable<String>? autofillHints,
    String? Function(String?)? validator,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboard,
      autofillHints: autofillHints,
      decoration: InputDecoration(labelText: label, suffixIcon: suffixIcon),
      validator:
          validator ??
          (v) => (v ?? '').trim().isEmpty ? 'Campo obligatorio.' : null,
    ),
  );
}
