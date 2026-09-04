import 'package:flutter/material.dart';

import '../models/estado_vehiculo.dart';
import '../theme/app_theme.dart';

class EstadoTimeline extends StatelessWidget {
  const EstadoTimeline({super.key, required this.estados});
  final List<EstadoVehiculo> estados;

  @override
  Widget build(BuildContext context) {
    final ordered = List<EstadoVehiculo>.from(estados)
      ..sort((a, b) => a.fechaEstado.compareTo(b.fechaEstado));
    if (ordered.isEmpty) {
      return Text(
        'Aún no se han registrado etapas para este proceso.',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ordered.length,
      itemBuilder: (context, index) {
        final item = ordered[index];
        final isCurrent = index == ordered.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 34,
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: AppMotion.duration(context, AppMotion.standard),
                      width: isCurrent ? 26 : 20,
                      height: isCurrent ? 26 : 20,
                      decoration: BoxDecoration(
                        color: isCurrent ? AppColors.red : AppColors.black,
                        shape: BoxShape.circle,
                        boxShadow: isCurrent
                            ? const [
                                BoxShadow(
                                  color: Color(0x44DF1717),
                                  blurRadius: 14,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: AppColors.white,
                        size: 14,
                      ),
                    ),
                    if (!isCurrent)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppRadii.medium),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.nombre,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            if (isCurrent)
                              Text(
                                'ACTUAL',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontSize: 9,
                                    ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _date(item.fechaEstado),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        if (item.descripcion?.isNotEmpty == true) ...[
                          const SizedBox(height: 8),
                          Text(item.descripcion!),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year} · ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}
