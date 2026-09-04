import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 44, this.dark = false});
  final double size;
  final bool dark;

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: -.08,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(size * .3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44DF1717),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'W',
        style: TextStyle(
          color: AppColors.white,
          fontSize: size * .5,
          height: 1,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
        ),
      ),
    ),
  );
}

class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key, this.compact = false, this.onDark = false});
  final bool compact;
  final bool onDark;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      BrandMark(size: compact ? 36 : 44),
      const SizedBox(width: 11),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wells',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: onDark ? AppColors.white : null,
              height: 1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'IMPORT CARS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: onDark
                  ? const Color(0xFFA7A7AC)
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: compact ? 7 : 8,
              letterSpacing: 2.1,
            ),
          ),
        ],
      ),
    ],
  );
}
