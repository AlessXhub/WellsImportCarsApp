import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/catalogo_service.dart';
import '../services/cliente_service.dart';
import '../services/cotizacion_service.dart';
import '../services/seguimiento_service.dart';
import '../services/session_service.dart';
import '../services/solicitud_service.dart';
import '../theme/app_theme.dart';
import 'cotizaciones_screen.dart';
import 'home_screen.dart';
import 'mis_solicitudes_screen.dart';
import 'perfil_screen.dart';
import 'seguimientos_screen.dart';

class ClientShell extends StatefulWidget {
  const ClientShell({super.key, required this.session, required this.onLogout});
  final SessionService session;
  final VoidCallback onLogout;
  @override
  State<ClientShell> createState() => _ClientShellState();
}

class _ClientShellState extends State<ClientShell> {
  int _index = 0;
  int _cotizacionesVersion = 0;
  late final ApiService _api = ApiService();
  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        catalogoService: CatalogoService(_api),
        cotizacionService: CotizacionService(_api),
        solicitudService: SolicitudService(_api),
        session: widget.session,
      ),
      MisSolicitudesScreen(
        service: SolicitudService(_api),
        session: widget.session,
      ),
      CotizacionesScreen(
        key: ValueKey(_cotizacionesVersion),
        service: CotizacionService(_api),
        solicitudService: SolicitudService(_api),
        session: widget.session,
      ),
      SeguimientosScreen(
        service: SeguimientoService(_api),
        session: widget.session,
      ),
      PerfilScreen(
        service: ClienteService(_api),
        session: widget.session,
        onLogout: widget.onLogout,
      ),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.black,
          border: Border(top: BorderSide(color: Color(0xFF2B2B2E))),
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (value) => setState(() {
              _index = value;
              if (value == 2) _cotizacionesVersion++;
            }),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.assignment_outlined),
                selectedIcon: Icon(Icons.assignment_rounded),
                label: 'Solicitudes',
              ),
              NavigationDestination(
                icon: Icon(Icons.request_quote_outlined),
                selectedIcon: Icon(Icons.request_quote_rounded),
                label: 'Cotizaciones',
              ),
              NavigationDestination(
                icon: Icon(Icons.local_shipping_outlined),
                selectedIcon: Icon(Icons.local_shipping_rounded),
                label: 'Seguimiento',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
