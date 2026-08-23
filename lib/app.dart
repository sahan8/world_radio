import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/navigation/presentation/world_radio_shell.dart';
import 'features/player/application/player_controller.dart';
import 'features/player/data/world_radio_audio_handler.dart';
import 'features/library/application/library_controller.dart';
import 'features/library/data/local_storage_service.dart';

class WorldRadioApp extends StatefulWidget {
  const WorldRadioApp({this.audioHandler, super.key});
  final AudioHandler? audioHandler;

  @override
  State<WorldRadioApp> createState() => _WorldRadioAppState();
}

class _WorldRadioAppState extends State<WorldRadioApp> {
  late final AudioHandler _handler;
  late final bool _ownsHandler;
  late final LibraryController _library;
  late final PlayerController _player;

  @override
  void initState() {
    super.initState();
    _ownsHandler = widget.audioHandler == null;
    _handler = widget.audioHandler ?? WorldRadioAudioHandler();
    _library = LibraryController(_createStorage());
    _player = PlayerController(_handler, _library);
    _loadLibrary();
  }

  LocalStorageService _createStorage() {
    try {
      return SharedPreferencesLocalStorageService();
    } catch (error) {
      debugPrint(
        'Persistent storage unavailable; using memory storage: $error',
      );
      return InMemoryLocalStorageService();
    }
  }

  Future<void> _loadLibrary() async {
    await _library.load();
    final lastStation = _library.lastStation;
    if (lastStation != null) _player.restore(lastStation);
  }

  @override
  void dispose() {
    _player.dispose();
    _library.dispose();
    if (_ownsHandler && _handler is WorldRadioAudioHandler) {
      unawaited(_handler.disposeHandler());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LibraryScope(
    controller: _library,
    child: PlayerScope(
      controller: _player,
      child: MaterialApp(
        title: 'World Radio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: const WorldRadioShell(),
      ),
    ),
  );
}
