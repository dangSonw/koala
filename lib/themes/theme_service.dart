import '../cache/storage_manager.dart';
import '../models/settings_keys.dart';
import '../utils/debug_utils.dart';

class ThemeService {
  static const String _themeKey = SettingsKeys.darkMode;
  
  // Get current theme mode from Hive
  static bool getDarkMode() {
    try {
      return StorageManager.getSetting<bool>(_themeKey, defaultValue: false) ?? false;
    } catch (e) {
  debugPrintError('THEME', 'Error getting theme: $e');
      return false;
    }
  }
  
  // Save theme mode to Hive
  static Future<bool> setDarkMode(bool isDarkMode) async {
    try {
      await StorageManager.setSetting(_themeKey, isDarkMode);
      return true;
    } catch (e) {
  debugPrintError('THEME', 'Error setting theme: $e');
      return false;
    }
  }
  
  // Toggle theme mode
  static Future<bool> toggleTheme() async {
    try {
      final currentMode = getDarkMode();
      final newMode = !currentMode;
      return await setDarkMode(newMode);
    } catch (e) {
  debugPrintError('THEME', 'Error toggling theme: $e');
      return false;
    }
  }
}
