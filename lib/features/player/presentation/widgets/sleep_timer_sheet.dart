import 'package:flutter/material.dart';

import '../../application/player_controller.dart';

Future<void> showSleepTimerSheet(BuildContext context) async {
  final controller = PlayerScope.of(context);
  const options = <(String, Duration?)>[
    ('15 minutes', Duration(minutes: 15)),
    ('30 minutes', Duration(minutes: 30)),
    ('45 minutes', Duration(minutes: 45)),
    ('1 hour', Duration(hours: 1)),
    ('Off', null),
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
                title: Text(option.$1),
                trailing: controller.sleepTimer == option.$1
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  controller.setSleepTimer(option.$1, option.$2);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    ),
  );
}
