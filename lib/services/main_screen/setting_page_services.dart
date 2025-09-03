import 'package:flutter/rendering.dart';
import '../../cache/storage_manager.dart';
import '../../models/settings_keys.dart';

class SettingsService {
  static SettingsService? _instance;
  
  SettingsService._();

  static Future<SettingsService> getInstance() async {
    _instance ??= SettingsService._();
    return _instance!;
  }

  static SettingsService get instance {
    _instance ??= SettingsService._();
    return _instance!;
  }

  T? getValue<T>(String key, {T? defaultValue}) {
    try {
      return StorageManager.getSetting<T>(key, defaultValue: defaultValue);
    } catch (e) {
      debugPrint('Error getting value for key $key: $e');
      return defaultValue;
    }
  }

  Future<bool> setValue<T>(String key, T value) async {
    try {
      await StorageManager.setSetting(key, value);
      return true;
    } catch (e) {
      debugPrint('Error setting value for key $key: $e');
      return false;
    }
  }

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

  // Reset all settings to defaults by clearing settings box
  Future<bool> resetAllSettings() async {
    try {
      await StorageManager.clearAllSettings();
      return true;
    } catch (e) {
      debugPrint('Error resetting all settings: $e');
      return false;
    }
  }

  // Clear all search history
  Future<bool> clearSearchHistory() async {
    try {
      await StorageManager.clearAllSearchHistory();
      return true;
    } catch (e) {
      debugPrint('Error clearing search history: $e');
      return false;
    }
  }
}
