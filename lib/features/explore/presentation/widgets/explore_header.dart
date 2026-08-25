import 'package:flutter/material.dart';

import '../../../../widgets/visuals/dot_matrix_text.dart';

class ExploreHeader extends StatelessWidget {
  const ExploreHeader({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 36, child: DotMatrixText('EXPLORE', fontSize: 34)),
      const SizedBox(height: 8),
      Text('AROUND THE WORLD', style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}
