import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../themes/theme_provider.dart';
import '../services/main_screen/setting_page_services.dart';
import 'main_screen/home_page_provider.dart';
// import 'main_screen/search_page_provider.dart';
// import 'main_screen/favorites_page_provider.dart';

class AppProviders {
  static List<SingleChildWidget> providers(SettingsService? settingsService) => [
        ChangeNotifierProvider(create: (_) => _createThemeProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        // ChangeNotifierProvider(create: (_) => SearchProvider()),
        // ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        Provider<SettingsService>(
          create: (_) => _createSettingsService(settingsService),
        ),
      ];

  static ThemeProvider _createThemeProvider() {
    debugPrint('[AppProviders]: Creating ThemeProvider...');
    final provider = ThemeProvider();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('[AppProviders]: Initializing ThemeProvider after UI render...');
      provider.initialize().catchError((e) {
        debugPrint('[AppProviders]: ThemeProvider initialization failed: $e');
        debugPrint('[AppProviders]: UI continues with default theme');
      });
    });

    return provider;
  }

  static SettingsService _createSettingsService(SettingsService? settingsService) {
    debugPrint('[AppProviders]: Creating non-null SettingsService...');
    if (settingsService != null) {
      debugPrint('[AppProviders]: Using initialized SettingsService');
      return settingsService;
    }
    debugPrint('[AppProviders]: Initialization failed, using fallback SettingsService.instance');
    return SettingsService.instance;
  }
}
