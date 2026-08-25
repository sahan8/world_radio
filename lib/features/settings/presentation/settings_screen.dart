import 'package:flutter/material.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/neumorphic.dart';
import '../../../core/theme/theme_controller.dart';
import '../../library/application/library_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final library = LibraryScope.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('SETTINGS'),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              key: const PageStorageKey('settings-scroll'),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
              children: [
                const Text('SYSTEM / RECEIVER', style: AppTextStyles.caption),
                const SizedBox(height: 24),
                const _SectionLabel('APPEARANCE'),
                const SizedBox(height: 10),
                _SettingsPanel(
                  child: _ThemeSelector(
                    selected: theme.mode,
                    onSelected: theme.setMode,
                  ),
                ),
                const SizedBox(height: 32),
                const _SectionLabel('LOCAL DATA'),
                const SizedBox(height: 8),
                _SettingsPanel(
                  child: Column(
                    children: [
                      _SettingRow(
                        icon: Icons.history,
                        title: 'CLEAR LISTENING HISTORY',
                        subtitle:
                            '${library.recentStations.length} recent stations',
                        onTap: library.recentStations.isEmpty
                            ? null
                            : () => _confirmClearHistory(context, library),
                      ),
                      const Divider(),
                      const _SettingRow(
                        icon: Icons.info_outline,
                        title: 'ABOUT WORLD RADIO',
                        subtitle: 'Version 1.0.0',
                      ),
                      const Divider(),
                      const _SettingRow(
                        icon: Icons.shield_outlined,
                        title: 'PRIVACY',
                        subtitle: 'Favorites and history stay on this device.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmClearHistory(
    BuildContext context,
    LibraryController library,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear listening history?'),
        content: const Text('This removes all recently played stations.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await library.clearHistory();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listening history cleared.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not clear listening history.')),
        );
      }
    }
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.selected, required this.onSelected});
  final ThemeMode selected;
  final ValueChanged<ThemeMode> onSelected;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final option in const [
        (ThemeMode.system, Icons.brightness_auto_rounded, 'SYSTEM'),
        (ThemeMode.dark, Icons.dark_mode_rounded, 'DARK'),
        (ThemeMode.light, Icons.light_mode_rounded, 'LIGHT'),
      ])
        ChoiceChip(
          avatar: Icon(option.$2, size: 18),
          label: Text(option.$3),
          selected: selected == option.$1,
          showCheckmark: false,
          onSelected: (_) => onSelected(option.$1),
        ),
    ],
  );
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadii.large),
      border: Border.all(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .04),
      ),
      boxShadow: Neumorphic.raised(context, depth: .7),
    ),
    child: Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadii.large),
      clipBehavior: Clip.antiAlias,
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) =>
      Text(label, style: AppTextStyles.caption);
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(AppRadii.medium),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.medium),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 72),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              Icon(icon, semanticLabel: title),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (onTap != null) const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    ),
  );
}
