import '../utils/debug_utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/box_names.dart';

class StorageManager {
  static Box<dynamic>? _settingsBox;
  static Box<dynamic>? _searchHistoryBox;
  
  static bool _isInitialized = false;
  
  // Initialize all storage systems
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize Hive
      await Hive.initFlutter();
      
      // Open all required boxes
      _settingsBox = await Hive.openBox(BoxNames.settings);
      _searchHistoryBox = await Hive.openBox(BoxNames.searchHistory);
      
      _isInitialized = true;
      debugPrintSuccess('CACHE', 'StorageManager initialized successfully');
    } catch (e) {
      debugPrintError('CACHE', 'Error initializing StorageManager: $e');
      rethrow;
    }
  }
  
  // Get settings box
  static Box<dynamic> get settingsBox {
    if (!_isInitialized || _settingsBox == null) {
      throw Exception('StorageManager not initialized. Call initialize() first.');
    }
    return _settingsBox!;
  }
  
  // Get search history box
  static Box<dynamic> get searchHistoryBox {
    if (!_isInitialized || _searchHistoryBox == null) {
      throw Exception('StorageManager not initialized. Call initialize() first.');
    }
    return _searchHistoryBox!;
  }
  
  // Generic methods for settings
  static T? getSetting<T>(String key, {T? defaultValue}) {
    try {
      // Check if initialized before accessing settingsBox
      if (!_isInitialized || _settingsBox == null) {
  debugPrintWarning('CACHE', 'Not initialized, returning default value for $key');
        return defaultValue;
      }
      return _settingsBox!.get(key, defaultValue: defaultValue) as T?;
    } catch (e) {
  debugPrintError('CACHE', 'Error getting setting $key: $e');
      return defaultValue;
    }
  }
  
  static Future<void> setSetting<T>(String key, T value) async {
    try {
      // Check if initialized before accessing settingsBox
      if (!_isInitialized || _settingsBox == null) {
  debugPrintWarning('CACHE', 'Not initialized, cannot set $key');
        throw Exception('StorageManager not initialized. Call initialize() first.');
      }
      await _settingsBox!.put(key, value);
    } catch (e) {
  debugPrintError('CACHE', 'Error setting $key: $e');
      rethrow;
    }
  }

  // Clear all settings
  static Future<void> clearAllSettings() async {
    if (!_isInitialized || _settingsBox == null) {
  debugPrintWarning('CACHE', 'Not initialized, cannot clear settings');
      throw Exception('StorageManager not initialized. Call initialize() first.');
    }
    await _settingsBox!.clear();
  }

  // Clear all search history
  static Future<void> clearAllSearchHistory() async {
    if (!_isInitialized || _searchHistoryBox == null) {
  debugPrintWarning('CACHE', 'Not initialized, cannot clear search history');
      throw Exception('StorageManager not initialized. Call initialize() first.');
    }
    await _searchHistoryBox!.clear();
  }
  
  // Close all boxes
  static Future<void> dispose() async {
    try {
      await Hive.close();
      _isInitialized = false;
      _settingsBox = null;
      _searchHistoryBox = null;
  debugPrintSuccess('CACHE', 'StorageManager disposed successfully');
    } catch (e) {
  debugPrintError('CACHE', 'Error disposing StorageManager: $e');
    }
  }
}
