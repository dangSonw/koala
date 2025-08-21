import 'package:flutter/rendering.dart';
import '../../cache/storage_manager.dart';
import '../../models/settings_keys.dart';

class SettingsService {
  static SettingsService? _instance;
  
  // Keys are centralized in SettingsKeys

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
  bool get darkMode => getValue<bool>(SettingsKeys.darkMode, defaultValue: false) ?? false;
  bool get notifications => getValue<bool>(SettingsKeys.notifications, defaultValue: true) ?? true;
  bool get offlineMode => getValue<bool>(SettingsKeys.offlineMode, defaultValue: false) ?? false;
  bool get scientificNames => getValue<bool>(SettingsKeys.scientificNames, defaultValue: true) ?? true;
  bool get autoPlayVideo => getValue<bool>(SettingsKeys.autoPlayVideo, defaultValue: false) ?? false;
  bool get hapticFeedback => getValue<bool>(SettingsKeys.hapticFeedback, defaultValue: true) ?? true;
  bool get syncData => getValue<bool>(SettingsKeys.syncData, defaultValue: true) ?? true;
  String get language => getValue<String>(SettingsKeys.language, defaultValue: 'English') ?? 'English';
  String get imageQuality => getValue<String>(SettingsKeys.imageQuality, defaultValue: 'High') ?? 'High';
  String get downloadQuality => getValue<String>(SettingsKeys.downloadQuality, defaultValue: 'Medium') ?? 'Medium';

  // Setters for specific settings
  Future<bool> setDarkMode(bool value) => setValue(SettingsKeys.darkMode, value);
  Future<bool> setNotifications(bool value) => setValue(SettingsKeys.notifications, value);
  Future<bool> setOfflineMode(bool value) => setValue(SettingsKeys.offlineMode, value);
  Future<bool> setScientificNames(bool value) => setValue(SettingsKeys.scientificNames, value);
  Future<bool> setAutoPlayVideo(bool value) => setValue(SettingsKeys.autoPlayVideo, value);
  Future<bool> setHapticFeedback(bool value) => setValue(SettingsKeys.hapticFeedback, value);
  Future<bool> setSyncData(bool value) => setValue(SettingsKeys.syncData, value);
  Future<bool> setLanguage(String value) => setValue(SettingsKeys.language, value);
  Future<bool> setImageQuality(String value) => setValue(SettingsKeys.imageQuality, value);
  Future<bool> setDownloadQuality(String value) => setValue(SettingsKeys.downloadQuality, value);
}
