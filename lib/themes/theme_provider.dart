import '../utils/debug_utils.dart';
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
  debugPrintInfo('THEME', 'Already initialized, skipping');
      return;
    }
    
  debugPrintSpecial('THEME', 'Starting initialization...');
    try {
      _isDarkMode = ThemeService.getDarkMode(); // Now synchronous
      _isInitialized = true;
  debugPrintSuccess('THEME', 'Initialized successfully with darkMode: $_isDarkMode');
      notifyListeners();
    } catch (e) {
  debugPrintError('THEME', 'Error initializing theme: $e');
      _isDarkMode = false;
      _isInitialized = true;
  debugPrintWarning('THEME', 'Fallback to light mode due to error');
      notifyListeners();
    }
  }

  // Set theme mode
  Future<void> setDarkMode(bool mode) async {
    if (_isDarkMode == mode) {
  debugPrintInfo('THEME', 'Theme mode already set to $mode, skipping');
      return;
    }
    
  debugPrintSpecial('THEME', 'Setting theme mode to $mode...');
    try {
      final success = await ThemeService.setDarkMode(mode);
      if (success) {
        _isDarkMode = mode;
  debugPrintSuccess('THEME', 'Theme mode successfully changed to $mode');
        notifyListeners();
      } else {
  debugPrintError('THEME', 'Failed to save theme mode to storage');
      }
    } catch (e) {
  debugPrintError('THEME', 'Error setting theme: $e');
    }
  }

  // Toggle theme mode
  Future<void> toggleTheme() async {
  debugPrintSpecial('THEME', 'Toggling theme from $_isDarkMode to ${!_isDarkMode}...');
    try {
      final success = await ThemeService.toggleTheme();
      if (success) {
        _isDarkMode = !_isDarkMode;
  debugPrintSuccess('THEME', 'Theme toggled successfully to $_isDarkMode');
        notifyListeners();
      } else {
  debugPrintError('THEME', 'Failed to toggle theme in storage');
      }
    } catch (e) {
  debugPrintError('THEME', 'Error toggling theme: $e');
    }
  }

  // Legacy method for backward compatibility
  void toggleThemeLegacy(bool mode) {
    setDarkMode(mode);
  }
}
