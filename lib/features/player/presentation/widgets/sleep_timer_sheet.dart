import 'package:flutter/material.dart';

import '../../application/player_controller.dart';

Future<void> showSleepTimerSheet(BuildContext context) async {
  final controller = PlayerScope.of(context);
  const options = [
    '15 minutes',
    '30 minutes',
    '45 minutes',
    '1 hour',
    'End of current session',
    'Off',
  ];
  await showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SLEEP TIMER',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            for (final option in options)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(option),
                trailing: controller.sleepTimer == option
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  controller.setSleepTimer(option);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    ),
  );
}
