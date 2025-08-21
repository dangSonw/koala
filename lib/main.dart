import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themes/theme_provider.dart';
import 'routes/router.dart';
import 'routes/routes.dart';
import 'themes/themes.dart';

import 'provider/provider_initializer.dart';

import 'services/main_screen/setting_page_services.dart';
import 'services/services_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final (settingsService, initializationSuccess) = await initializeApp();
  runApp(MainApp(
    settingsService: settingsService,
    initializationSuccess: initializationSuccess,
  ));
}

class MainApp extends StatelessWidget {
  final SettingsService? settingsService;
  final bool initializationSuccess;

  const MainApp({
    super.key, 
    required this.settingsService, 
    required this.initializationSuccess
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('MainApp: Building UI with initializationSuccess: $initializationSuccess');
    
    return MultiProvider(
      providers: AppProviders.providers(settingsService),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Koala',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: Routes.mainScreen,
            onGenerateRoute: RouteGenerator.generateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

Future<(SettingsService?, bool)> initializeApp() async {
  debugPrint('Main: Starting app initialization...');
  SettingsService? settingsService;
  bool initializationSuccess = false;

  try {
    settingsService = await AppInitializer.initialize();
    initializationSuccess = true;
    debugPrint('Main: App initialization completed successfully');
  } catch (e) {
    debugPrint('Main: App initialization failed: $e');
    debugPrint('Main: App will continue with default settings');
  }

  return (settingsService, initializationSuccess);
}