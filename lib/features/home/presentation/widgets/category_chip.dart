import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/neumorphic.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({required this.label, this.onTap, super.key});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.small),
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadii.small),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface
                .withValues(alpha: .04),
          ),
          boxShadow: Neumorphic.raised(context, depth: .55),
        ),
        child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      ),
    ),
  );
}
