import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('WORLD RADIO', style: Theme.of(context).textTheme.displayMedium),
      const SizedBox(height: 8),
      Text(
        'Listen beyond borders.',
        style: Theme.of(context).textTheme.bodyLarge
            ?.copyWith(color: AppColors.textSecondary),
      ),
    ],
  );
}
