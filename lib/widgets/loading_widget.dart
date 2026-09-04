import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'skeleton_loader.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.message = 'Cargando información...',
    this.type = SkeletonType.list,
  });
  final String message;
  final SkeletonType type;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(child: SkeletonLoader(type: type)),
      Positioned(
        left: 16,
        right: 16,
        bottom: 16,
        child: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: .92),
              borderRadius: BorderRadius.circular(AppRadii.medium),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox.square(
                  dimension: 17,
                  child: CircularProgressIndicator(
                    color: AppColors.red,
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    message,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
