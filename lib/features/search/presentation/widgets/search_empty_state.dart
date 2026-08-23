import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
    child: Column(
      children: [
        const Icon(Icons.cell_tower, size: 54),
        const SizedBox(height: 18),
        Text(
          'NO SIGNAL FOUND',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Try another station, country or genre.',
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
