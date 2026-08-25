import 'package:flutter/material.dart';

/// Shared soft-UI shadows. Keeping these in one place makes the depth system
/// consistent across light and dark themes.
abstract final class Neumorphic {
  static List<BoxShadow> raised(BuildContext context, {double depth = 1}) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: dark ? .62 : .16),
        offset: Offset(6 * depth, 6 * depth),
        blurRadius: 14 * depth,
      ),
      BoxShadow(
        color: Colors.white.withValues(alpha: dark ? .055 : .82),
        offset: Offset(-5 * depth, -5 * depth),
        blurRadius: 12 * depth,
      ),
    ];
  }

  static List<BoxShadow> pressed(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: dark ? .52 : .13),
        offset: const Offset(2, 2),
        blurRadius: 5,
      ),
      BoxShadow(
        color: Colors.white.withValues(alpha: dark ? .04 : .68),
        offset: const Offset(-2, -2),
        blurRadius: 5,
      ),
    ];
  }
}
