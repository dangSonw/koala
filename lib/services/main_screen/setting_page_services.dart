import 'package:flutter/rendering.dart';
import '../../cache/storage_manager.dart';

class SettingsService {
  static SettingsService? _instance;
  
  // Keys for settings - using consistent naming with ThemeService
  static const String keyDarkMode = 'isDarkMode';
  static const String keyNotifications = 'notifications';
  static const String keyOfflineMode = 'offlineMode';
  static const String keyScientificNames = 'scientificNames';
  static const String keyAutoPlayVideo = 'autoPlayVideo';
  static const String keyHapticFeedback = 'hapticFeedback';
  static const String keySyncData = 'syncData';
  static const String keyLanguage = 'language';
  static const String keyImageQuality = 'imageQuality';
  static const String keyDownloadQuality = 'downloadQuality';

  // Private constructor
  SettingsService._();

  // Singleton instance
  static Future<SettingsService> getInstance() async {
    _instance ??= SettingsService._();
    return _instance!;
  }

  // Synchronous accessor to always get a non-null instance without awaiting
  static SettingsService get instance {
    _instance ??= SettingsService._();
    return _instance!;
  }

  // Generic method to get value using StorageManager
  T? getValue<T>(String key, {T? defaultValue}) {
    try {
      return StorageManager.getSetting<T>(key, defaultValue: defaultValue);
    } catch (e) {
      debugPrint('Error getting value for key $key: $e');
      return defaultValue;
    }
  }

  // Generic method to set value using StorageManager
  Future<bool> setValue<T>(String key, T value) async {
    try {
      await StorageManager.setSetting(key, value);
      return true;
    } catch (e) {
      debugPrint('Error setting value for key $key: $e');
      return false;
    }
  }

  // Getters for specific settings with default values - Safe null handling
  bool get darkMode => getValue<bool>(keyDarkMode, defaultValue: false) ?? false;
  bool get notifications => getValue<bool>(keyNotifications, defaultValue: true) ?? true;
  bool get offlineMode => getValue<bool>(keyOfflineMode, defaultValue: false) ?? false;
  bool get scientificNames => getValue<bool>(keyScientificNames, defaultValue: true) ?? true;
  bool get autoPlayVideo => getValue<bool>(keyAutoPlayVideo, defaultValue: false) ?? false;
  bool get hapticFeedback => getValue<bool>(keyHapticFeedback, defaultValue: true) ?? true;
  bool get syncData => getValue<bool>(keySyncData, defaultValue: true) ?? true;
  String get language => getValue<String>(keyLanguage, defaultValue: 'English') ?? 'English';
  String get imageQuality => getValue<String>(keyImageQuality, defaultValue: 'High') ?? 'High';
  String get downloadQuality => getValue<String>(keyDownloadQuality, defaultValue: 'Medium') ?? 'Medium';

  // Setters for specific settings
  Future<bool> setDarkMode(bool value) => setValue(keyDarkMode, value);
  Future<bool> setNotifications(bool value) => setValue(keyNotifications, value);
  Future<bool> setOfflineMode(bool value) => setValue(keyOfflineMode, value);
  Future<bool> setScientificNames(bool value) => setValue(keyScientificNames, value);
  Future<bool> setAutoPlayVideo(bool value) => setValue(keyAutoPlayVideo, value);
  Future<bool> setHapticFeedback(bool value) => setValue(keyHapticFeedback, value);
  Future<bool> setSyncData(bool value) => setValue(keySyncData, value);
  Future<bool> setLanguage(String value) => setValue(keyLanguage, value);
  Future<bool> setImageQuality(String value) => setValue(keyImageQuality, value);
  Future<bool> setDownloadQuality(String value) => setValue(keyDownloadQuality, value);
}
