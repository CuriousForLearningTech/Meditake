import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
/// ┌──────────────────────────────────────────────────────────────┐
/// │  Enterprise Theme Provider                                    │
/// │  3-way toggle: Light / Dark / System                         │
/// │  Persisted to SharedPreferences across sessions              │
/// └──────────────────────────────────────────────────────────────┘

const _prefKey = 'meditake_theme_mode';

/// Map between [ThemeMode] and the int stored in SharedPreferences.
const _themeModeMap = {
  0: ThemeMode.system,
  1: ThemeMode.light,
  2: ThemeMode.dark,
};

int _themeModeToInt(ThemeMode mode) {
  return _themeModeMap.entries.firstWhere((e) => e.value == mode).key;
}

/// Riverpod [StateNotifierProvider] — the single source of truth for theme.
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadFromPrefs();
  }

  /// Load persisted theme preference.
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getInt(_prefKey);
    if (stored != null && _themeModeMap.containsKey(stored)) {
      state = _themeModeMap[stored]!;
    }
  }

  /// Set theme and persist.
  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, _themeModeToInt(mode));
  }

  /// Convenience cycle:  System → Light → Dark → System
  Future<void> cycle() async {
    switch (state) {
      case ThemeMode.system:
        await setTheme(ThemeMode.light);
        break;
      case ThemeMode.light:
        await setTheme(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        await setTheme(ThemeMode.system);
        break;
    }
  }
}
