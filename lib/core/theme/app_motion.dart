import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Shared motion tokens and accessibility checks.
abstract class AppMotion {
  /// Stagger between successive items in a page entrance.
  static const Duration stagger = Duration(milliseconds: 70);

  /// How many leading items of a list get a staggered entrance.
  ///
  /// Stagger delay grows with the index, so animating an unbounded paged list
  /// would leave item 100 blank for seven seconds. Only the items that can be
  /// on screen at first paint animate; everything after renders immediately.
  static const int maxStaggeredItems = 8;

  /// Entrance fade/slide duration.
  static const Duration entrance = Duration(milliseconds: 260);

  /// Checks if the operating system has requested reduced motion.
  static bool isReduced(BuildContext context) => MediaQuery.disableAnimationsOf(context);
}

extension AppMotionItem on Widget {
  /// Entrance animation for a single list item at [index].
  ///
  /// Returns the widget untouched past [AppMotion.maxStaggeredItems] and when
  /// the platform asks for reduced motion.
  ///
  /// Apply this per item inside a lazy `itemBuilder` — never by mapping a whole
  /// list into widgets up front, which defeats the viewport's lazy building.
  /// `AppPagedSliverList` already applies it for you.
  Widget entranceAt(BuildContext context, int index) {
    if (index >= AppMotion.maxStaggeredItems || AppMotion.isReduced(context)) return this;
    return animate(delay: AppMotion.stagger * index)
        .fadeIn(duration: AppMotion.entrance)
        .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
  }
}
