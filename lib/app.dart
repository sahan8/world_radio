import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/theme_controller.dart';
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
  late final ThemeController _theme;

  @override
  void initState() {
    super.initState();
    _theme = _createThemeController()..load();
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

  ThemeController _createThemeController() {
    try {
      return ThemeController(SharedPreferencesAsync());
    } catch (_) {
      return ThemeController();
    }
  }

  Future<void> _loadLibrary() async {
    try {
      await _library.load();
      final lastStation = _library.lastStation;
      if (lastStation != null) _player.restore(lastStation);
    } catch (error) {
      debugPrint('Library initialization failed: $error');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _library.dispose();
    _theme.dispose();
    if (_ownsHandler && _handler is WorldRadioAudioHandler) {
      unawaited(_handler.disposeHandler());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _theme,
    builder: (context, _) => ThemeScope(
      controller: _theme,
      child: LibraryScope(
        controller: _library,
        child: PlayerScope(
          controller: _player,
          child: MaterialApp(
            title: 'World Radio',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: _theme.mode,
            builder: (context, child) {
              final dark = Theme.of(context).brightness == Brightness.dark;
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: dark
                      ? Brightness.light
                      : Brightness.dark,
                  systemNavigationBarColor: dark
                      ? AppColors.backgroundDeep
                      : AppColors.lightBackground,
                  systemNavigationBarIconBrightness: dark
                      ? Brightness.light
                      : Brightness.dark,
                ),
                child: child!,
              );
            },
            home: const WorldRadioShell(),
          ),
        ),
      ),
    ),
  );
}
