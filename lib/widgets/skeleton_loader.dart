import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({super.key, this.type = SkeletonType.list});
  final SkeletonType type;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

enum SkeletonType { list, vehicleGrid, detail }

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = .55;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      final color = Color.lerp(
        Theme.of(context).colorScheme.surfaceContainerHigh,
        Theme.of(context).colorScheme.surfaceContainerHighest,
        _controller.value,
      )!;
      return switch (widget.type) {
        SkeletonType.vehicleGrid => _VehicleGridSkeleton(color: color),
        SkeletonType.detail => _DetailSkeleton(color: color),
        SkeletonType.list => _ListSkeleton(color: color),
      };
    },
  );
}

class _Bone extends StatelessWidget {
  const _Bone({
    required this.color,
    this.height = 16,
    this.width,
    this.radius = 8,
  });
  final Color color;
  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.all(AppSpacing.md),
    itemCount: 5,
    separatorBuilder: (_, _) => const SizedBox(height: 12),
    itemBuilder: (_, _) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadii.large),
      ),
      child: Row(
        children: [
          _Bone(color: color, width: 52, height: 52, radius: 14),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bone(color: color, width: 180),
                const SizedBox(height: 9),
                _Bone(color: color, width: 120, height: 11),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _VehicleGridSkeleton extends StatelessWidget {
  const _VehicleGridSkeleton({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 900
          ? 4
          : constraints.maxWidth >= 600
          ? 3
          : 2;
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: .64,
        ),
        itemCount: columns * 2,
        itemBuilder: (_, _) => Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadii.large),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Bone(color: color, width: double.infinity, radius: 14),
              ),
              const SizedBox(height: 12),
              _Bone(color: color, width: 130),
              const SizedBox(height: 8),
              _Bone(color: color, width: 82, height: 11),
              const SizedBox(height: 14),
              _Bone(color: color, width: 100, height: 14),
            ],
          ),
        ),
      );
    },
  );
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _Bone(color: color, width: double.infinity, height: 250, radius: 24),
      const SizedBox(height: 22),
      _Bone(color: color, width: 220, height: 28),
      const SizedBox(height: 12),
      _Bone(color: color, width: 150),
      const SizedBox(height: 24),
      Row(
        children: [
          Expanded(child: _Bone(color: color, height: 78, radius: 16)),
          const SizedBox(width: 12),
          Expanded(child: _Bone(color: color, height: 78, radius: 16)),
        ],
      ),
    ],
  );
}
