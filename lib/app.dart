import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/navigation/presentation/world_radio_shell.dart';
import 'features/player/application/player_controller.dart';
import 'features/player/data/world_radio_audio_handler.dart';

class WorldRadioApp extends StatefulWidget {
  const WorldRadioApp({this.audioHandler, super.key});
  final AudioHandler? audioHandler;

  @override
  State<WorldRadioApp> createState() => _WorldRadioAppState();
}

class _WorldRadioAppState extends State<WorldRadioApp> {
  late final AudioHandler _handler;
  late final PlayerController _player;

  @override
  void initState() {
    super.initState();
    _handler = widget.audioHandler ?? WorldRadioAudioHandler();
    _player = PlayerController(_handler);
  }

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
