import '../utils/debug_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../themes/theme_provider.dart';
import '../services/main_screen/setting_page_services.dart';
import 'main_screen/home_page_provider.dart';
import 'main_screen/search_page_provider.dart';

class AppProviders {
  static List<SingleChildWidget> providers(SettingsService? settingsService) => [
        ChangeNotifierProvider(create: (_) => _createThemeProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        Provider<SettingsService>(
          create: (_) => _createSettingsService(settingsService),
        ),
      ];

  static ThemeProvider _createThemeProvider() {
  debugPrintSpecial('PROVIDER', 'Creating ThemeProvider...');
    final provider = ThemeProvider();

    WidgetsBinding.instance.addPostFrameCallback((_) {
  debugPrintSpecial('PROVIDER', 'Initializing ThemeProvider after UI render...');
      provider.initialize().catchError((e) {
  debugPrintError('PROVIDER', 'ThemeProvider initialization failed: $e');
  debugPrintWarning('PROVIDER', 'UI continues with default theme');
      });
    });

    return provider;
  }

  static SettingsService _createSettingsService(SettingsService? settingsService) {
  debugPrintSpecial('PROVIDER', 'Creating non-null SettingsService...');
    if (settingsService != null) {
  debugPrintSuccess('PROVIDER', 'Using initialized SettingsService');
      return settingsService;
    }
  debugPrintWarning('PROVIDER', 'Initialization failed, using fallback SettingsService.instance');
    return SettingsService.instance;
  }
}
