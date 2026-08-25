import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/visuals/dot_matrix_text.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.onAction, super.key});
  final String title;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: SizedBox(height: 22, child: DotMatrixText(title, fontSize: 21)),
      ),
      if (onAction != null)
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            minimumSize: const Size(48, 48),
            textStyle: AppTextStyles.caption,
          ),
          child: const Text('See all'),
        ),
    ],
  );
}
