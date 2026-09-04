import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class VehicleVisual extends StatelessWidget {
  const VehicleVisual({
    super.key,
    this.heroTag,
    this.height = 150,
    this.compact = false,
  });

  final Object? heroTag;
  final double height;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final visual = Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.black, AppColors.blackSoft, Color(0xFF590000)],
          stops: [0, .68, 1],
        ),
        borderRadius: BorderRadius.circular(
          compact ? AppRadii.medium : AppRadii.large,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: .08)),
              ),
            ),
          ),
          Positioned(
            right: -18,
            bottom: -10,
            child: Icon(
              Icons.directions_car_filled_rounded,
              size: compact ? 86 : 150,
              color: AppColors.white.withValues(alpha: .95),
              shadows: const [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 22,
                  offset: Offset(0, 12),
                ),
              ],
            ),
          ),
          Positioned(
            left: 18,
            top: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: compact ? 58 : 90,
                  height: 3,
                  color: AppColors.red,
                ),
                const SizedBox(height: 7),
                Container(
                  width: compact ? 38 : 62,
                  height: 2,
                  color: AppColors.red.withValues(alpha: .75),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return heroTag == null
        ? visual
        : Hero(
            tag: heroTag!,
            transitionOnUserGestures: true,
            child: Material(color: Colors.transparent, child: visual),
          );
  }
}
