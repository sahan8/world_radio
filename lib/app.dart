import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/navigation/presentation/world_radio_shell.dart';
import 'features/player/application/player_controller.dart';

class WorldRadioApp extends StatefulWidget {
  const WorldRadioApp({super.key});

  @override
  State<WorldRadioApp> createState() => _WorldRadioAppState();
}

class _WorldRadioAppState extends State<WorldRadioApp> {
  final _player = PlayerController();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PlayerScope(
    controller: _player,
    child: MaterialApp(
      title: 'World Radio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const WorldRadioShell(),
    ),
  );
}
