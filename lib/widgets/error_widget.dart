import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ApiErrorWidget extends StatelessWidget {
  const ApiErrorWidget({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final details = _details(message);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadii.large),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    details.icon,
                    size: 30,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  details.title,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _clean(message),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Intentar nuevamente'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  ({String title, IconData icon}) _details(String value) {
    final text = value.toLowerCase();
    if (text.contains('conectar') || text.contains('comunicación')) {
      return (title: 'Sin conexión con Wells', icon: Icons.wifi_off_rounded);
    }
    if (text.contains('demasiado') || text.contains('timeout')) {
      return (
        title: 'La conexión tardó demasiado',
        icon: Icons.schedule_rounded,
      );
    }
    if (text.contains('sesión') || text.contains('autoriz')) {
      return (
        title: 'Tu sesión necesita atención',
        icon: Icons.lock_outline_rounded,
      );
    }
    if (text.contains('no se encontr')) {
      return (
        title: 'No encontramos este contenido',
        icon: Icons.search_off_rounded,
      );
    }
    return (
      title: 'No pudimos completar la consulta',
      icon: Icons.cloud_off_rounded,
    );
  }

  String _clean(String value) => value
      .replaceFirst(RegExp(r'^(Exception|FormatException):\s*'), '')
      .trim();
}
