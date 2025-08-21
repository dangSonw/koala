import 'package:flutter/material.dart';
import 'theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isInitialized = false;

  bool get isDarkMode => _isDarkMode;
  bool get isInitialized => _isInitialized;

  // Initialize theme from storage
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('ThemeProvider: Already initialized, skipping');
      return;
    }
    
    debugPrint('ThemeProvider: Starting initialization...');
    try {
      _isDarkMode = ThemeService.getDarkMode(); // Now synchronous
      _isInitialized = true;
      debugPrint('ThemeProvider: Initialized successfully with darkMode: $_isDarkMode');
      notifyListeners();
    } catch (e) {
      debugPrint('ThemeProvider: Error initializing theme: $e');
      _isDarkMode = false;
      _isInitialized = true;
      debugPrint('ThemeProvider: Fallback to light mode due to error');
      notifyListeners();
    }
  }

  // Set theme mode
  Future<void> setDarkMode(bool mode) async {
    if (_isDarkMode == mode) {
      debugPrint('ThemeProvider: Theme mode already set to $mode, skipping');
      return;
    }
    
    debugPrint('ThemeProvider: Setting theme mode to $mode...');
    try {
      final success = await ThemeService.setDarkMode(mode);
      if (success) {
        _isDarkMode = mode;
        debugPrint('ThemeProvider: Theme mode successfully changed to $mode');
        notifyListeners();
      } else {
        debugPrint('ThemeProvider: Failed to save theme mode to storage');
      }
    } catch (e) {
      debugPrint('ThemeProvider: Error setting theme: $e');
    }
  }

  // Toggle theme mode
  Future<void> toggleTheme() async {
    debugPrint('ThemeProvider: Toggling theme from $_isDarkMode to ${!_isDarkMode}...');
    try {
      final success = await ThemeService.toggleTheme();
      if (success) {
        _isDarkMode = !_isDarkMode;
        debugPrint('ThemeProvider: Theme toggled successfully to $_isDarkMode');
        notifyListeners();
      } else {
        debugPrint('ThemeProvider: Failed to toggle theme in storage');
      }
    } catch (e) {
      debugPrint('ThemeProvider: Error toggling theme: $e');
    }
  }

  // Legacy method for backward compatibility
  void toggleThemeLegacy(bool mode) {
    setDarkMode(mode);
  }
}
