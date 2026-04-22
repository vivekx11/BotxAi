import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Box _box = Hive.box('settings');
  
  ThemeModeNotifier() : super(ThemeMode.dark) {
    _loadThemeMode();
  }
  
  void _loadThemeMode() {
    final themeString = _box.get('theme_mode', defaultValue: 'dark');
    state = _themeModeFromString(themeString);
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _box.put('theme_mode', _themeModeToString(mode));
  }
  
  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }
  
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

final voiceSpeedProvider = StateNotifierProvider<VoiceSpeedNotifier, double>((ref) {
  return VoiceSpeedNotifier();
});

class VoiceSpeedNotifier extends StateNotifier<double> {
  final Box _box = Hive.box('settings');
  
  VoiceSpeedNotifier() : super(0.5) {
    _loadSpeed();
  }
  
  void _loadSpeed() {
    state = _box.get('voice_speed', defaultValue: 0.5);
  }
  
  Future<void> setSpeed(double speed) async {
    state = speed;
    await _box.put('voice_speed', speed);
  }
}

final voicePitchProvider = StateNotifierProvider<VoicePitchNotifier, double>((ref) {
  return VoicePitchNotifier();
});

class VoicePitchNotifier extends StateNotifier<double> {
  final Box _box = Hive.box('settings');
  
  VoicePitchNotifier() : super(1.0) {
    _loadPitch();
  }
  
  void _loadPitch() {
    state = _box.get('voice_pitch', defaultValue: 1.0);
  }
  
  Future<void> setPitch(double pitch) async {
    state = pitch;
    await _box.put('voice_pitch', pitch);
  }
}

final offlineModeProvider = StateNotifierProvider<OfflineModeNotifier, bool>((ref) {
  return OfflineModeNotifier();
});

class OfflineModeNotifier extends StateNotifier<bool> {
  final Box _box = Hive.box('settings');
  
  OfflineModeNotifier() : super(false) {
    _loadMode();
  }
  
  void _loadMode() {
    state = _box.get('offline_mode', defaultValue: false);
  }
  
  Future<void> setMode(bool enabled) async {
    state = enabled;
    await _box.put('offline_mode', enabled);
  }
}

final notificationsEnabledProvider = StateNotifierProvider<NotificationsNotifier, bool>((ref) {
  return NotificationsNotifier();
});

class NotificationsNotifier extends StateNotifier<bool> {
  final Box _box = Hive.box('settings');
  
  NotificationsNotifier() : super(true) {
    _loadEnabled();
  }
  
  void _loadEnabled() {
    state = _box.get('notifications_enabled', defaultValue: true);
  }
  
  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _box.put('notifications_enabled', enabled);
  }
}
