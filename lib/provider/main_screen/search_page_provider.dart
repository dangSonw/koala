import 'package:flutter/material.dart';
import '../../services/main_screen/search_page_services.dart';
import '../../models/animal.dart';
import '../../models/search_history_model.dart';
import '../../utils/debug_utils.dart';

class SearchProvider extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool _isLoading = false;
  String _selectedFilter = 'All';
  String _query = '';

  List<String> _recentSearches = [];
  List<String> _popularSearches = [];
  List<Animal> _results = [];

  bool get isLoading => _isLoading;
  String get selectedFilter => _selectedFilter;
  String get query => _query;
  List<String> get recentSearches => List.unmodifiable(_recentSearches);
  List<String> get popularSearches => List.unmodifiable(_popularSearches);
  List<Animal> get results => List.unmodifiable(_results);
  List<String> get suggestions => _query.isEmpty
      ? const []
      : _popularSearches
          .where((s) => s.toLowerCase().contains(_query.toLowerCase()))
          .toList(growable: false);

  SearchProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    _recentSearches = SearchHistoryBox.getAll().reversed.toList();
    _popularSearches = SearchService.getPopularSearches();
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
    if (_query.isNotEmpty) {
      performSearch(_query);
    }
  }

  Future<void> performSearch(String q) async {
    final trimmed = q.trim();
    if (trimmed.isEmpty) return;
    
    _query = trimmed;
    _setLoading(true);

    try {
      debugPrintInfo('[SEARCH_PROVIDER]', 'Performing search for: $trimmed');
      _results = await SearchService.searchAnimals(trimmed, filter: _selectedFilter);
      
      // Save to search history
      await SearchHistoryBox.add(trimmed);
      _recentSearches = SearchHistoryBox.getAll().reversed.toList();
      
      debugPrintInfo('[SEARCH_PROVIDER]', 'Found ${_results.length} results');
    } catch (e) {
      debugPrintInfo('[SEARCH_PROVIDER]', 'Search error: $e');
      _results = [];
    }
    
    _setLoading(false);
  }

  void clearSearch() {
    controller.clear();
    _query = '';
    _results = [];
    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearRecentSearches() async {
    await SearchHistoryBox.clear();
    _recentSearches = [];
    notifyListeners();
  }

  Future<void> removeRecentSearch(int index) async {
    if (index >= 0 && index < _recentSearches.length) {
      await SearchHistoryBox.removeAt(_recentSearches.length - 1 - index);
      _recentSearches = SearchHistoryBox.getAll().reversed.toList();
      notifyListeners();
    }
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