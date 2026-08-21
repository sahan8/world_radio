import 'package:flutter/material.dart';

class ExploreHeader extends StatelessWidget {
  const ExploreHeader({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('EXPLORE', style: Theme.of(context).textTheme.displayMedium),
      const SizedBox(height: 8),
      Text('Tune into anywhere.', style: Theme.of(context).textTheme.bodyLarge),
    ],
  );
}
