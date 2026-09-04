import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class Reveal extends StatelessWidget {
  const Reveal({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.emphasized,
      curve: AppMotion.curve,
      child: child,
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: child,
        ),
      ),
    );
  }
}

class AnimatedStateSwitcher extends StatelessWidget {
  const AnimatedStateSwitcher({
    super.key,
    required this.stateKey,
    required this.child,
  });
  final Object stateKey;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: AppMotion.duration(context, AppMotion.standard),
    switchInCurve: AppMotion.curve,
    switchOutCurve: Curves.easeInCubic,
    transitionBuilder: (child, animation) => FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: .985, end: 1).animate(animation),
        child: child,
      ),
    ),
    child: KeyedSubtree(key: ValueKey(stateKey), child: child),
  );
}
