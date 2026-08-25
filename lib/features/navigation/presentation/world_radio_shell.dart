import 'dart:ui';

import 'package:flutter/material.dart';

import '../../explore/presentation/explore_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../home/presentation/widgets/mini_player.dart';
import '../../library/presentation/favorites_screen.dart';
import '../../search/presentation/search_screen.dart';
import '../../../core/motion/app_motion.dart';
import '../../../core/theme/neumorphic.dart';
import '../../../widgets/visuals/dot_matrix_text.dart';

class WorldRadioShell extends StatefulWidget {
  const WorldRadioShell({super.key});
  @override
  State<WorldRadioShell> createState() => _WorldRadioShellState();
}

class _WorldRadioShellState extends State<WorldRadioShell> {
  int _selectedIndex = 0;
  static const _screens = [
    HomeScreen(),
    ExploreScreen(),
    SearchScreen(embedded: true),
    FavoritesScreen(),
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
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const MiniPlayer(),
          ),
        ),
        _GlassNavigationDock(
          selectedIndex: _selectedIndex,
          onSelected: (index) => setState(() => _selectedIndex = index),
        ),
      ],
    ),
  );
}

class _GlassNavigationDock extends StatelessWidget {
  const _GlassNavigationDock({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    (Icons.home_outlined, Icons.home, 'HOME'),
    (Icons.explore_outlined, Icons.explore, 'EXPLORE'),
    (Icons.search, Icons.search, 'SEARCH'),
    (Icons.favorite_border, Icons.favorite, 'SAVED'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final reduced = AppMotion.reduce(context);
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: Neumorphic.raised(context, depth: .8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 68,
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: dark ? .82 : .72),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colors.onSurface.withValues(
                        alpha: dark ? .14 : .1,
                      ),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cell = constraints.maxWidth / _items.length;
                      return Stack(
                        children: [
                          AnimatedPositioned(
                            duration: reduced
                                ? Duration.zero
                                : AppMotion.emphasis,
                            curve: AppMotion.standardCurve,
                            left: selectedIndex * cell + 5,
                            top: 5,
                            width: cell - 10,
                            height: 58,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: Neumorphic.pressed(context),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              for (var i = 0; i < _items.length; i++)
                                Expanded(
                                  child: _DockItem(
                                    icon: i == selectedIndex
                                        ? _items[i].$2
                                        : _items[i].$1,
                                    label: _items[i].$3,
                                    selected: i == selectedIndex,
                                    onTap: () => onSelected(i),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatefulWidget {
  const _DockItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_DockItem> createState() => _DockItemState();
}

class _DockItemState extends State<_DockItem> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final reduced = AppMotion.reduce(context);
    final foreground = widget.selected
        ? colors.onSurface
        : colors.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.label,
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => hovered = true),
        onExit: (_) => setState(() => hovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: AnimatedScale(
              scale: !reduced && (widget.selected || hovered) ? 1.06 : 1,
              duration: AppMotion.fast,
              child: AnimatedSlide(
                offset: !reduced && widget.selected
                    ? const Offset(0, -.04)
                    : Offset.zero,
                duration: AppMotion.fast,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon, size: 21, color: foreground),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 9,
                      child: DotMatrixText(
                        widget.label,
                        fontSize: 9,
                        color: foreground,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
