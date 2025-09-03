import 'package:flutter/material.dart';
import '../../services/main_screen/home_page_services.dart';

class HomeProvider extends ChangeNotifier {
  late HomeService homeService = HomeService();
  bool _loading = false;
  String? _error;
  List<String?> _featuredImages = [];
  List<Map<String, dynamic>> _recentAnimals = [];

  bool get isLoading => _loading;
  String? get error => _error;
  List<String?> get featuredImages => _featuredImages;
  List<Map<String, dynamic>> get recentAnimals => _recentAnimals;

  HomeProvider() {
    load();
  }

  Future<void> load() async {
    _setLoading(true);
    _setError(null);
    try {
      await homeService.loadAllImages();
      _featuredImages = homeService.getFeaturedImages();
      _recentAnimals = homeService.getRecentAnimals();
    } catch (e) {
      _setError('Failed to load featured images');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh() async {
    _setError(null);
    await homeService.refreshData();
    await load();
  }

  void _setLoading(bool value) {
    if (_loading == value) return;
    _loading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    if (_error == value) return;
    _error = value;
    notifyListeners();
  }
}
