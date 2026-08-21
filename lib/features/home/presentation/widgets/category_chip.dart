import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({required this.label, super.key});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 48),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.small),
      border: Border.all(color: AppColors.border),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.bodyLarge
          ?.copyWith(color: AppColors.textPrimary),
    ),
  );
}
