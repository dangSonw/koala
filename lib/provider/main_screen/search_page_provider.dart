import 'package:flutter/material.dart';
import '../../asset/images_assets.dart';

class SearchProvider extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool _isLoading = false;
  String _selectedFilter = 'All';
  String _query = '';

  final List<String> filters = const ['All', 'Mammals', 'Birds', 'Reptiles', 'Fish', 'Insects'];
  final List<String> _recentSearches = ['Tiger', 'Elephant', 'Penguin', 'Shark', 'Eagle'];
  final List<String> popularSearches = const ['Lion', 'Dolphin', 'Butterfly', 'Snake', 'Whale', 'Owl', 'Monkey', 'Turtle'];

  List<Map<String, dynamic>> _results = [];

  bool get isLoading => _isLoading;
  String get selectedFilter => _selectedFilter;
  String get query => _query;
  List<String> get recentSearches => List.unmodifiable(_recentSearches);
  List<Map<String, dynamic>> get results => List.unmodifiable(_results);

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
    // Optionally re-run search with new filter
    if (_query.isNotEmpty) {
      performSearch(_query);
    }
  }

  Future<void> performSearch(String q) async {
    final trimmed = q.trim();
    if (trimmed.isEmpty) return;
    _query = trimmed;
    _setLoading(true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Mocked results filtered by category when applicable
    final all = [
      {
        'name': 'Bengal Tiger',
        'scientificName': 'Panthera tigris tigris',
        'category': 'Mammals',
        'habitat': 'Tropical forests',
        'image': AppImages.tiger,
        'endangered': true,
      },
      {
        'name': 'African Elephant',
        'scientificName': 'Loxodonta africana',
        'category': 'Mammals',
        'habitat': 'Savanna',
        'image': AppImages.elephant,
        'endangered': true,
      },
      {
        'name': 'Emperor Penguin',
        'scientificName': 'Aptenodytes forsteri',
        'category': 'Birds',
        'habitat': 'Antarctica',
        'image': AppImages.penguin,
        'endangered': false,
      },
    ];

    _results = all
        .where((e) => e['name'].toString().toLowerCase().contains(trimmed.toLowerCase()))
        .where((e) => _selectedFilter == 'All' || e['category'] == _selectedFilter)
        .toList();

    _addRecent(trimmed);
    _setLoading(false);
  }

  void clearSearch() {
    controller.clear();
    _query = '';
    _results = [];
    _isLoading = false;
    notifyListeners();
  }

  void _addRecent(String value) {
    _recentSearches.remove(value);
    _recentSearches.insert(0, value);
    if (_recentSearches.length > 10) {
      _recentSearches.removeLast();
    }
  }

  void clearRecentSearches() {
    _recentSearches.clear();
    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
