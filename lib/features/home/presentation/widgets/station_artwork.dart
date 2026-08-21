import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';

class StationArtwork extends StatelessWidget {
  const StationArtwork({required this.label, this.size, super.key});
  final String label;
  final double? size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppRadii.small),
      border: Border.all(color: AppColors.borderSubtle),
    ),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(letterSpacing: 1.5),
        ),
      ),
    ),
  );
}
