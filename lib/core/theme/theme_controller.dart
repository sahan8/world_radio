import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeController([this._preferences]);

  static const _storageKey = 'theme_mode';
  final SharedPreferencesAsync? _preferences;
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  Future<void> load() async {
    final preferences = _preferences;
    if (preferences == null) return;
    try {
      final value = await preferences.getString(_storageKey);
      _mode = ThemeMode.values.firstWhere(
        (mode) => mode.name == value,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    } catch (_) {
      // System mode is the safe fallback when preferences are unavailable.
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    final preferences = _preferences;
    if (preferences == null) return;
    try {
      await preferences.setString(_storageKey, mode.name);
    } catch (_) {
      // Theme selection still applies for the current session.
    }
  }
}

class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    required ThemeController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope not found');
    return scope!.notifier!;
  }
}
