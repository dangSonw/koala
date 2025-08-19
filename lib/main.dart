import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'themes/theme_provider.dart';

import 'provider/provider_initializer.dart';
import 'services/services_initializer.dart';

import 'routes/router.dart';
import 'routes/routes.dart';

import 'themes/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _ = await initializeApp();
  runApp(MainApp(

  ));
}

class MainApp extends StatelessWidget {

  const MainApp({
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('[MainApp]: Building UI');
    debugPrint('[MainApp]: Building SV');
    
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