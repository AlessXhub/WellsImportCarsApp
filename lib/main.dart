import 'package:flutter/material.dart';

import 'screens/client_shell.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'services/catalogo_service.dart';
import 'services/cotizacion_service.dart';
import 'services/session_service.dart';
import 'services/solicitud_service.dart';
import 'theme/app_theme.dart';

void main() => runApp(const WellsImportCarsApp());

class WellsImportCarsApp extends StatefulWidget {
  const WellsImportCarsApp({super.key});
  @override
  State<WellsImportCarsApp> createState() => _WellsImportCarsAppState();
}

class _WellsImportCarsAppState extends State<WellsImportCarsApp> {
  final SessionService _session = SessionService();
  final ApiService _api = ApiService();
  void _sessionChanged() => setState(() {});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Wells Import Cars',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.system,
    home: _session.isAuthenticated
        ? ClientShell(
            session: _session,
            onLogout: () {
              _session.clear();
              _sessionChanged();
            },
          )
        : HomeScreen(
            catalogoService: CatalogoService(_api),
            cotizacionService: CotizacionService(_api),
            solicitudService: SolicitudService(_api),
            session: _session,
            onSessionChanged: _sessionChanged,
          ),
  );
}
