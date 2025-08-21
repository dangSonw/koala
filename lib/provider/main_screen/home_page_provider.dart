import 'package:flutter/material.dart';
import '../../services/main_screen/home_page_services.dart';

class HomeProvider extends ChangeNotifier {
  bool _loading = false;
  List<String> _featuredImages = [];
  List<Map<String, dynamic>> _recentAnimals = [];

  bool get isLoading => _loading;
  List<String> get featuredImages => _featuredImages;
  List<Map<String, dynamic>> get recentAnimals => _recentAnimals;

  HomeProvider() {
    load();
  }

  Future<void> load() async {
    _setLoading(true);
    try {
      _featuredImages = HomeService.getFeaturedImages();
      _recentAnimals = HomeService.getRecentAnimals();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh() async {
    await HomeService.refreshData();
    await load();
  }

  void _setLoading(bool value) {
    if (_loading == value) return;
    _loading = value;
    notifyListeners();
  }
}
