import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'status_chip.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.subtitle,
    this.action,
  });

  final String title;
  final String? eyebrow;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (eyebrow != null) ...[
              Eyebrow(eyebrow!),
              const SizedBox(height: AppSpacing.xs),
            ],
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
      if (action != null) ...[const SizedBox(width: AppSpacing.sm), action!],
    ],
  );
}

class PremiumPageHeader extends StatelessWidget {
  const PremiumPageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(16, 8, 16, 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.black,
      borderRadius: BorderRadius.circular(AppRadii.large),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.black, AppColors.blackSoft, Color(0xFF410000)],
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(eyebrow, onDark: true),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFB7B7BC),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.circular(AppRadii.medium),
          ),
          child: Icon(icon, color: AppColors.white),
        ),
      ],
    ),
  );
}
