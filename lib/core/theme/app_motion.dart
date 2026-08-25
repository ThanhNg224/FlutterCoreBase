import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Shared motion tokens and accessibility checks.
abstract class AppMotion {
  /// Stagger between successive items in a page entrance.
  static const Duration stagger = Duration(milliseconds: 70);

  /// Entrance fade/slide duration.
  static const Duration entrance = Duration(milliseconds: 260);

  /// Checks if the operating system has requested reduced motion.
  static bool isReduced(BuildContext context) => MediaQuery.disableAnimationsOf(context);
}

extension AppMotionList on List<Widget> {
  /// Staggered entrance animation that respects the platform's reduced-motion setting.
  List<Widget> staggeredEntrance(BuildContext context, {Duration? interval}) {
    if (AppMotion.isReduced(context)) return this;
    return animate(interval: interval ?? AppMotion.stagger)
        .fadeIn(duration: AppMotion.entrance)
        .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
  }
}
