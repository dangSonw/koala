import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_screen/setting_page_services.dart';
import '../cache/storage_manager.dart';
import '../themes/theme_provider.dart';

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
      // Khởi tạo StorageManager (bao gồm Hive)
      await StorageManager.initialize();
      
      // Load settings và khởi tạo SettingsService
      final settings = await _loadSettings();
      
      debugPrint('App initialization completed successfully');
      return settings;
    } catch (e) {
      debugPrint('Error during app initialization: $e');
      rethrow; // Để main có thể xử lý lỗi
    }
  }
  
  static Future<SettingsService> _loadSettings() async {
    try {
      // Khởi tạo SettingsService
      final settingsService = await SettingsService.getInstance();
      _settingsService = settingsService;
      
      // Settings are now automatically loaded through StorageManager
      // No need for manual loading as SettingsService uses StorageManager directly
      
      debugPrint('Settings loaded successfully');
      return settingsService;
    } catch (e) {
      debugPrint('Error loading settings: $e');
      rethrow;
    }
  }
  
  // Load settings and update ThemeProvider - Updated to use StorageManager
  static Future<void> loadSettingsAndUpdateTheme(BuildContext context) async {
    debugPrint('AppInitializer: Loading settings and updating theme...');
    try {
      final isDarkMode = StorageManager.getSetting<bool>('isDarkMode', defaultValue: false) ?? false;
      
      // Update ThemeProvider
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      await themeProvider.setDarkMode(isDarkMode);
      
      debugPrint('AppInitializer: Theme updated from settings successfully');
    } catch (e) {
      debugPrint('AppInitializer: Error updating theme from settings: $e');
    }
  }
  
  static Future<void> dispose() async {
    debugPrint('AppInitializer: Starting cleanup...');
    try {
      await StorageManager.dispose();
      debugPrint('AppInitializer: Cleanup completed successfully');
    } catch (e) {
      debugPrint('AppInitializer: Error during cleanup: $e');
    }
  }
}
