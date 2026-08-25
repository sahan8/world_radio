import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/visuals/dot_matrix_text.dart';
import '../../../settings/presentation/settings_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 27,
              child: DotMatrixText('WORLD RADIO', fontSize: 27),
            ),
            const SizedBox(height: 2),
            const Text(
              'GLOBAL BROADCAST // WR 001',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
      Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: IconButton(
          tooltip: 'Settings',
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          icon: const Icon(Icons.settings_outlined, size: 20),
        ),
      ),
    ],
  );
}
