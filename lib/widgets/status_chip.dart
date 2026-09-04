import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, this.compact = false});
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final normalized = label.toLowerCase();
    final isPositive =
        normalized.contains('disponible') ||
        normalized.contains('atendida') ||
        normalized.contains('aceptada') ||
        normalized.contains('entregado') ||
        normalized.contains('completada');
    final isNegative =
        normalized.contains('rechazada') ||
        normalized.contains('cancelada') ||
        normalized.contains('vencida');
    final foreground = isNegative
        ? colors.error
        : isPositive
        ? const Color(0xFF157347)
        : colors.primary;
    final background = isNegative
        ? colors.errorContainer
        : isPositive
        ? const Color(0xFFE8F7EF)
        : colors.primaryContainer;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9 : 11,
        vertical: compact ? 5 : 7,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? foreground.withValues(alpha: .16)
            : background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: foreground,
                fontSize: compact ? 9 : 10,
                letterSpacing: .15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.onDark = false});
  final String text;
  final bool onDark;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelSmall?.copyWith(
      color: onDark ? const Color(0xFFFF7777) : AppColors.red,
      fontSize: 9,
      letterSpacing: 1.6,
      fontWeight: FontWeight.w800,
    ),
  );
}
