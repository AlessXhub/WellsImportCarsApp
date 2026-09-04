import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../models/view_state.dart';
import '../services/cliente_service.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/status_chip.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({
    super.key,
    required this.service,
    required this.session,
    required this.onLogout,
  });
  final ClienteService service;
  final SessionService session;
  final VoidCallback onLogout;
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  ViewState _state = ViewState.initial;
  Cliente? _client;
  String _error = '';
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = ViewState.loading);
    try {
      final data = await widget.service.getProfile(
        widget.session.idCliente!,
        widget.session.token!,
      );
      if (mounted) {
        setState(() {
          _client = data;
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
    appBar: AppBar(title: const Text('Mi perfil')),
    body: _state == ViewState.loading || _state == ViewState.initial
        ? const LoadingWidget()
        : _state == ViewState.error
        ? ApiErrorWidget(message: _error, onRetry: _load)
        : ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
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
                child: Row(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(AppRadii.large),
                      ),
                      child: Text(
                        '${_client!.nombre[0]}${_client!.apellido.isEmpty ? '' : _client!.apellido[0]}'
                            .toUpperCase(),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: AppColors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_client!.nombre} ${_client!.apellido}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: AppColors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _client!.correo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFFB7B7BC)),
                          ),
                          const SizedBox(height: 10),
                          StatusChip(label: _client!.estado, compact: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Información personal',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.badge_outlined),
                      title: const Text('DUI'),
                      subtitle: Text(_client!.dui),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone_outlined),
                      title: const Text('Teléfono'),
                      subtitle: Text(_client!.telefono),
                    ),
                    ListTile(
                      leading: const Icon(Icons.cake_outlined),
                      title: const Text('Fecha de nacimiento'),
                      subtitle: Text(
                        _client!.fechaNacimiento
                            .toIso8601String()
                            .split('T')
                            .first,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.verified_user_outlined),
                      title: const Text('Estado'),
                      subtitle: Text(_client!.estado),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: widget.onLogout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Cerrar sesión'),
              ),
            ],
          ),
  );
}
