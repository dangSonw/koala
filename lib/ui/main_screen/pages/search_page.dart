import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/native/main_screen/search_page/search_bar.dart';
import '../../../widgets/native/main_screen/search_page/recent_searches.dart';
import '../../../widgets/native/main_screen/search_page/popular_searches.dart';

import '../../../provider/main_screen/search_page_provider.dart';

import '../../../utils/debug_utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchProvider get _provider => context.read<SearchProvider>();

  void _performSearch(String query) => _provider.performSearch(query);
  void _clearSearch() => _provider.clearSearch();
  void _onSearchTap(String search) {
    _provider.controller.text = search;
    _provider.performSearch(search);
  }
  void _clearRecentSearches() => _provider.clearRecentSearches();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                CustomSearchBar(
                  controller: provider.controller,
                  focusNode: provider.focusNode,
                  onSubmitted: _performSearch,
                  onClear: _clearSearch,
                  onVoiceSearch: () {
                    debugPrintInfo('[SEARCH]','Voice search');
                  },
                  onChanged: (value) {
                    provider.setQuery(value);
                  },
                ),
                
                const SizedBox(height: 12),
              ],
            ),
          ),

          Expanded(
            child: provider.query.isEmpty
                ? _buildSearchSuggestions()
                : provider.isLoading
                    ? _buildSearchLoading()
                    : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    final provider = context.watch<SearchProvider>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecentSearches(
            searches: provider.recentSearches,
            onSearchTap: _onSearchTap,
            onClear: _clearRecentSearches,
          ),

          PopularSearches(
            searches: provider.popularSearches,
            onSearchTap: _onSearchTap,
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    const SizedBox(width: 8),
                    Text(
                      'Search Tips',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Use scientific names for precise results\n• Try habitat or location terms\n• Use category filters to narrow results',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Searching...'),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final provider = context.watch<SearchProvider>();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.results.length,
      itemBuilder: (context, index) {
        final result = provider.results[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                result['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            title: Text(result['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result['scientificName']),
                Text('${result['category']} • ${result['habitat']}'),
              ],
            ),
            trailing: result['endangered']
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Endangered',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
            onTap: () {
              debugPrintInfo('SEARCH','Navigate to ${result['name']}');
            },
          ),
        );
      },
    );
  }
}