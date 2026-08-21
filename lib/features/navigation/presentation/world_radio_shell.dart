import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../home/presentation/home_screen.dart';
import '../../home/presentation/widgets/mini_player.dart';
import '../../placeholder/presentation/placeholder_screen.dart';

class WorldRadioShell extends StatefulWidget {
  const WorldRadioShell({super.key});
  @override
  State<WorldRadioShell> createState() => _WorldRadioShellState();
}

class _WorldRadioShellState extends State<WorldRadioShell> {
  int _selectedIndex = 0;
  static const _screens = [
    HomeScreen(),
    PlaceholderScreen(
      title: 'EXPLORE',
      eyebrow: 'FIND YOUR FREQUENCY',
      description: 'Countries, cultures, and sounds will live here.',
      icon: Icons.travel_explore,
    ),
    PlaceholderScreen(
      title: 'FAVORITES',
      eyebrow: 'YOUR SIGNALS',
      description: 'The stations you save will appear here.',
      icon: Icons.favorite_border,
    ),
    PlaceholderScreen(
      title: 'SETTINGS',
      eyebrow: 'TUNE THE EXPERIENCE',
      description: 'App preferences will live here.',
      icon: Icons.tune,
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      bottom: false,
      child: IndexedStack(index: _selectedIndex, children: _screens),
    ),
    bottomNavigationBar: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MiniPlayer(),
        DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.borderSubtle)),
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
