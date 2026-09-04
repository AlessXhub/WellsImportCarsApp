import 'package:flutter/material.dart';

import '../models/vehiculo.dart';
import '../models/view_state.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/catalogo_service.dart';
import '../services/cotizacion_service.dart';
import '../services/session_service.dart';
import '../services/solicitud_service.dart';
import '../theme/app_theme.dart';
import '../widgets/brand.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/reveal.dart';
import '../widgets/section_header.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/status_chip.dart';
import '../widgets/vehicle_visual.dart';
import '../widgets/vehiculo_card.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'vehiculo_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.catalogoService,
    required this.cotizacionService,
    required this.solicitudService,
    required this.session,
    this.onSessionChanged,
  });
  final CatalogoService catalogoService;
  final CotizacionService cotizacionService;
  final SolicitudService solicitudService;
  final SessionService session;
  final VoidCallback? onSessionChanged;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ViewState _state = ViewState.initial;
  List<Vehiculo> _vehicles = const [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = ViewState.loading);
    try {
      final result = await widget.catalogoService.getAll();
      if (!mounted) return;
      setState(() {
        _vehicles = result;
        _state = result.isEmpty ? ViewState.empty : ViewState.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _state = ViewState.error;
      });
    }
  }

  Future<void> _openLogin() async {
    final success = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          authService: AuthService(ApiService()),
          session: widget.session,
        ),
      ),
    );
    if (success == true) widget.onSessionChanged?.call();
  }

  Future<void> _openRegister() async {
    final success = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterScreen(
          authService: AuthService(ApiService()),
          session: widget.session,
        ),
      ),
    );
    if (success == true) widget.onSessionChanged?.call();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const BrandLockup(compact: true),
      actions: widget.session.isAuthenticated
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: StatusChip(label: 'Sesión activa', compact: true),
              ),
            ]
          : [
              TextButton(onPressed: _openLogin, child: const Text('Ingresar')),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilledButton.tonal(
                  onPressed: _openRegister,
                  child: const Text('Registro'),
                ),
              ),
            ],
    ),
    body: _content(),
  );

  Widget _content() => switch (_state) {
    ViewState.loading || ViewState.initial => const Column(
      children: [
        _HomeHero(),
        Expanded(
          child: LoadingWidget(
            message: 'Consultando catálogo...',
            type: SkeletonType.vehicleGrid,
          ),
        ),
      ],
    ),
    ViewState.error => Column(
      children: [
        const _HomeHero(),
        Expanded(
          child: ApiErrorWidget(message: _error, onRetry: _load),
        ),
      ],
    ),
    ViewState.empty => Column(
      children: [
        const _HomeHero(),
        Expanded(
          child: EmptyWidget(
            title: 'Inventario en actualización',
            message:
                'No hay vehículos publicados en este momento. Actualiza para consultar nuevamente.',
            icon: Icons.directions_car_outlined,
            actionLabel: 'Actualizar catálogo',
            onAction: _load,
          ),
        ),
      ],
    ),
    ViewState.success => RefreshIndicator(
      onRefresh: _load,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: _HomeHero()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 12),
            sliver: SliverToBoxAdapter(
              child: SectionHeader(
                eyebrow: 'Selección Wells',
                title: 'Vehículos disponibles',
                subtitle:
                    '${_vehicles.length} ${_vehicles.length == 1 ? 'unidad publicada' : 'unidades publicadas'}',
                action: IconButton(
                  tooltip: 'Actualizar',
                  onPressed: _load,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 28),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final columns = width >= 1000
                    ? 4
                    : width >= 650
                    ? 3
                    : 2;
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: width < 420 ? .58 : .66,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final vehicle = _vehicles[index];
                    return Reveal(
                      child: VehiculoCard(
                        vehiculo: vehicle,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VehiculoDetailScreen(
                              vehiculo: vehicle,
                              catalogoService: widget.catalogoService,
                              cotizacionService: widget.cotizacionService,
                              solicitudService: widget.solicitudService,
                              session: widget.session,
                              onRequireLogin: _openLogin,
                            ),
                          ),
                        ),
                      ),
                    );
                  }, childCount: _vehicles.length),
                );
              },
            ),
          ),
        ],
      ),
    ),
  };
}

class _HomeHero extends StatelessWidget {
  const _HomeHero();

  @override
  Widget build(BuildContext context) => Reveal(
    child: Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(AppRadii.hero),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Importación con respaldo', onDark: true),
          const SizedBox(height: 10),
          Text(
            'Tu próximo vehículo,\nsin vueltas.',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.white,
              fontSize: 34,
              height: 1.02,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Inventario real, cotización clara y seguimiento en cada etapa.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFB7B7BC),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
          const VehicleVisual(height: 126),
        ],
      ),
    ),
  );
}
