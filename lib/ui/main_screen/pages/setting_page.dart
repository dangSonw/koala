import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../themes/theme_provider.dart';
import '../../../services/main_screen/setting_page_services.dart';

import '../../../models/settings_keys.dart';

import '../../../widgets/native/main_screen/setting_page/settings_section.dart';
import '../../../widgets/native/main_screen/setting_page/settings_tile.dart';
import '../../../widgets/native/main_screen/setting_page/profile_stats.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const List<String> _languages = ['English', 'Vietnamese', 'Spanish', 'French', 'German'];
  static const List<String> _imageQualities = ['Low', 'Medium', 'High', 'Ultra'];
  static const List<String> _downloadQualities = ['Low', 'Medium', 'High'];

  late SettingsService _settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settings = context.read<SettingsService>();
  }

  Future<void> _updateSetting<T>(String key, T value) async {
    try {
      bool success = false;
      switch (key) {
        case SettingsKeys.darkMode:
          success = await _settings.setDarkMode(value as bool);
          if (success) {
            if (!mounted) return;
            context.read<ThemeProvider>().toggleThemeLegacy(value);
          }
          break;
        case SettingsKeys.notifications:
          success = await _settings.setNotifications(value as bool);
          break;
        case SettingsKeys.offlineMode:
          success = await _settings.setOfflineMode(value as bool);
          break;
        case SettingsKeys.scientificNames:
          success = await _settings.setScientificNames(value as bool);
          break;
        case SettingsKeys.autoPlayVideo:
          success = await _settings.setAutoPlayVideo(value as bool);
          break;
        case SettingsKeys.hapticFeedback:
          success = await _settings.setHapticFeedback(value as bool);
          break;
        case SettingsKeys.syncData:
          success = await _settings.setSyncData(value as bool);
          break;
        case SettingsKeys.language:
          success = await _settings.setLanguage(value as String);
          break;
        case SettingsKeys.imageQuality:
          success = await _settings.setImageQuality(value as String);
          break;
        case SettingsKeys.downloadQuality:
          success = await _settings.setDownloadQuality(value as String);
          break;
        default:
          throw Exception('Unknown setting key: $key');
      }
      
      if (success) {
        debugPrint('Setting updated: $key = $value');
        setState(() {});
      } else {
        debugPrint('Failed to update setting: $key = $value');
      }
    } catch (e) {
      debugPrint('Error updating setting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Animal Explorer',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discovering the wonders of nature',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ProfileStats(label: 'Favorites', value: '12'),
                      ProfileStats(label: 'Searches', value: '45'),
                      ProfileStats(label: 'Categories', value: '6'),
                    ],
                  ),
                ],
              ),
            ),

            SettingsSection(
              title: 'Appearance',
              children: [
                SettingsTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  subtitle: 'Switch between light and dark themes',
                  trailing: Switch(
                    value: _settings.darkMode,
                    onChanged: (value) => _updateSetting(SettingsKeys.darkMode, value),
                  ),
                ),
                SettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: _settings.language,
                  onTap: _showLanguageSelector,
                ),
              ],
            ),

            SettingsSection(
              title: 'Content',
              children: [
                SettingsTile(
                  icon: Icons.science,
                  title: 'Scientific Names',
                  subtitle: 'Show scientific names for animals',
                  trailing: Switch(
                    value: _settings.scientificNames,
                    onChanged: (value) => _updateSetting(SettingsKeys.scientificNames, value),
                  ),
                ),
                SettingsTile(
                  icon: Icons.image,
                  title: 'Image Quality',
                  subtitle: _settings.imageQuality,
                  onTap: _showImageQualitySelector,
                ),
                SettingsTile(
                  icon: Icons.download,
                  title: 'Download Quality',
                  subtitle: _settings.downloadQuality,
                  onTap: _showDownloadQualitySelector,
                ),
              ],
            ),

            SettingsSection(
              title: 'Behavior',
              children: [
                SettingsTile(
                  icon: Icons.play_circle,
                  title: 'Auto-play Videos',
                  subtitle: 'Automatically play videos when viewing',
                  trailing: Switch(
                    value: _settings.autoPlayVideo,
                    onChanged: (value) => _updateSetting(SettingsKeys.autoPlayVideo, value),
                  ),
                ),
                SettingsTile(
                  icon: Icons.vibration,
                  title: 'Haptic Feedback',
                  subtitle: 'Provide tactile feedback for interactions',
                  trailing: Switch(
                    value: _settings.hapticFeedback,
                    onChanged: (value) => _updateSetting(SettingsKeys.hapticFeedback, value),
                  ),
                ),
              ],
            ),

            SettingsSection(
              title: 'Data & Sync',
              children: [
                SettingsTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  subtitle: 'Receive updates about new animals and features',
                  trailing: Switch(
                    value: _settings.notifications,
                    onChanged: (value) => _updateSetting(SettingsKeys.notifications, value),
                  ),
                ),
                SettingsTile(
                  icon: Icons.cloud_off,
                  title: 'Offline Mode',
                  subtitle: 'Access saved content without internet',
                  trailing: Switch(
                    value: _settings.offlineMode,
                    onChanged: (value) => _updateSetting(SettingsKeys.offlineMode, value),
                  ),
                ),
                SettingsTile(
                  icon: Icons.sync,
                  title: 'Sync Data',
                  subtitle: 'Keep your data synchronized across devices',
                  trailing: Switch(
                    value: _settings.syncData,
                    onChanged: (value) => _updateSetting(SettingsKeys.syncData, value),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _languages.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final lang = _languages[index];
              return RadioListTile<String>(
                title: Text(lang),
                value: lang,
                groupValue: _settings.language,
                onChanged: (value) async {
                  if (value == null) return;
                  await _updateSetting(SettingsKeys.language, value);
                  setState(() {});
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showImageQualitySelector() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _imageQualities.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final q = _imageQualities[index];
              return RadioListTile<String>(
                title: Text(q),
                value: q,
                groupValue: _settings.imageQuality,
                onChanged: (value) async {
                  if (value == null) return;
                  await _updateSetting(SettingsKeys.imageQuality, value);
                  setState(() {});
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showDownloadQualitySelector() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _downloadQualities.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final q = _downloadQualities[index];
              return RadioListTile<String>(
                title: Text(q),
                value: q,
                groupValue: _settings.downloadQuality,
                onChanged: (value) async {
                  if (value == null) return;
                  await _updateSetting(SettingsKeys.downloadQuality, value);
                  setState(() {});
                },
              );
            },
          ),
        );
      },
    );
  }
}
