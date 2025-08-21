import '../cache/storage_manager.dart';
import 'settings_keys.dart';

class AppSettings {
  final bool darkMode;
  final bool notifications;
  final bool offlineMode;
  final bool scientificNames;
  final bool autoPlayVideo;
  final bool hapticFeedback;
  final bool syncData;
  final String language;
  final String imageQuality;
  final String downloadQuality;

  const AppSettings({
    this.darkMode = false,
    this.notifications = true,
    this.offlineMode = false,
    this.scientificNames = true,
    this.autoPlayVideo = false,
    this.hapticFeedback = true,
    this.syncData = true,
    this.language = 'English',
    this.imageQuality = 'High',
    this.downloadQuality = 'Medium',
  });

  factory AppSettings.fromStorage() {
    return AppSettings(
      darkMode: StorageManager.getSetting<bool>(SettingsKeys.darkMode, defaultValue: false) ?? false,
      notifications: StorageManager.getSetting<bool>(SettingsKeys.notifications, defaultValue: true) ?? true,
      offlineMode: StorageManager.getSetting<bool>(SettingsKeys.offlineMode, defaultValue: false) ?? false,
      scientificNames: StorageManager.getSetting<bool>(SettingsKeys.scientificNames, defaultValue: true) ?? true,
      autoPlayVideo: StorageManager.getSetting<bool>(SettingsKeys.autoPlayVideo, defaultValue: false) ?? false,
      hapticFeedback: StorageManager.getSetting<bool>(SettingsKeys.hapticFeedback, defaultValue: true) ?? true,
      syncData: StorageManager.getSetting<bool>(SettingsKeys.syncData, defaultValue: true) ?? true,
      language: StorageManager.getSetting<String>(SettingsKeys.language, defaultValue: 'English') ?? 'English',
      imageQuality: StorageManager.getSetting<String>(SettingsKeys.imageQuality, defaultValue: 'High') ?? 'High',
      downloadQuality: StorageManager.getSetting<String>(SettingsKeys.downloadQuality, defaultValue: 'Medium') ?? 'Medium',
    );
  }

  Future<void> save() async {
    await StorageManager.setSetting<bool>(SettingsKeys.darkMode, darkMode);
    await StorageManager.setSetting<bool>(SettingsKeys.notifications, notifications);
    await StorageManager.setSetting<bool>(SettingsKeys.offlineMode, offlineMode);
    await StorageManager.setSetting<bool>(SettingsKeys.scientificNames, scientificNames);
    await StorageManager.setSetting<bool>(SettingsKeys.autoPlayVideo, autoPlayVideo);
    await StorageManager.setSetting<bool>(SettingsKeys.hapticFeedback, hapticFeedback);
    await StorageManager.setSetting<bool>(SettingsKeys.syncData, syncData);
    await StorageManager.setSetting<String>(SettingsKeys.language, language);
    await StorageManager.setSetting<String>(SettingsKeys.imageQuality, imageQuality);
    await StorageManager.setSetting<String>(SettingsKeys.downloadQuality, downloadQuality);
  }

  AppSettings copyWith({
    bool? darkMode,
    bool? notifications,
    bool? offlineMode,
    bool? scientificNames,
    bool? autoPlayVideo,
    bool? hapticFeedback,
    bool? syncData,
    String? language,
    String? imageQuality,
    String? downloadQuality,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      notifications: notifications ?? this.notifications,
      offlineMode: offlineMode ?? this.offlineMode,
      scientificNames: scientificNames ?? this.scientificNames,
      autoPlayVideo: autoPlayVideo ?? this.autoPlayVideo,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      syncData: syncData ?? this.syncData,
      language: language ?? this.language,
      imageQuality: imageQuality ?? this.imageQuality,
      downloadQuality: downloadQuality ?? this.downloadQuality,
    );
  }
}
