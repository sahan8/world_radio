import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/navigation/presentation/world_radio_shell.dart';

class WorldRadioApp extends StatelessWidget {
  const WorldRadioApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'World Radio',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.dark,
    home: const WorldRadioShell(),
  );
}
