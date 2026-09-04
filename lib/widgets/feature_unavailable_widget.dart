import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'status_chip.dart';

class FeatureUnavailableWidget extends StatelessWidget {
  const FeatureUnavailableWidget({
    super.key,
    required this.title,
    required this.message,
  });
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: AppColors.black,
      borderRadius: BorderRadius.circular(AppRadii.large),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.black, AppColors.blackSoft, Color(0xFF3B0000)],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow('PRÓXIMAMENTE', onDark: true),
        const SizedBox(height: 14),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.circular(AppRadii.medium),
          ),
          child: const Icon(Icons.construction_rounded, color: AppColors.white),
        ),
        const SizedBox(height: 18),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: const Color(0xFFB7B7BC)),
        ),
        const SizedBox(height: 16),
        Text(
          'El flujo está preparado y se habilitará cuando la API publique el contrato correspondiente.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: const Color(0xFF8E8E94)),
        ),
      ],
    ),
  );
}
