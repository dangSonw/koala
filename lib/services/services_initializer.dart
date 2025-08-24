import '../utils/debug_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_screen/setting_page_services.dart';
import '../cache/storage_manager.dart';
import '../themes/theme_provider.dart';
import '../models/settings_keys.dart';

class AppInitializer {
  static SettingsService? _settingsService;
  static SettingsService get settingsService {
    if (_settingsService == null) {
      throw Exception('SettingsService not initialized. Call initialize() first.');
    }
    return _settingsService!;
  }

  static Future<SettingsService> initialize() async {
    try {
      await StorageManager.initialize();
      
      final settings = await _loadSettings();
      
  debugPrintSuccess('SERVICES', 'App initialization completed successfully');
      return settings;
    } catch (e) {
  debugPrintError('SERVICES', 'Error during app initialization: $e');
      rethrow;
    }
  }
  
  static Future<SettingsService> _loadSettings() async {
    try {
      final settingsService = await SettingsService.getInstance();
      _settingsService = settingsService;
      
  debugPrintSuccess('SERVICES', 'Settings loaded successfully');
      return settingsService;
    } catch (e) {
  debugPrintError('SERVICES', 'Error loading settings: $e');
      rethrow;
    }
  }
  
  static Future<void> loadSettingsAndUpdateTheme(BuildContext context) async {
  debugPrintSpecial('SERVICES', 'AppInitializer: Loading settings and updating theme...');
    try {
      final isDarkMode = StorageManager.getSetting<bool>(SettingsKeys.darkMode, defaultValue: false) ?? false;

      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      await themeProvider.setDarkMode(isDarkMode);
      
  debugPrintSuccess('SERVICES', 'AppInitializer: Theme updated from settings successfully');
    } catch (e) {
  debugPrintError('SERVICES', 'AppInitializer: Error updating theme from settings: $e');
    }
  }
  
  static Future<void> dispose() async {
  debugPrintSpecial('SERVICES', 'AppInitializer: Starting cleanup...');
    try {
      await StorageManager.dispose();
  debugPrintSuccess('SERVICES', 'AppInitializer: Cleanup completed successfully');
    } catch (e) {
  debugPrintError('SERVICES', 'AppInitializer: Error during cleanup: $e');
    }
  }
}
