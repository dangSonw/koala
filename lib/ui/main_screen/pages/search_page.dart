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
  void _removeRecentSearch(int index) => _provider.removeRecentSearch(index);

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
            onRemove: _removeRecentSearch,
          ),

          PopularSearches(
            searches: provider.popularSearches,
            onSearchTap: _onSearchTap,
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
    
    if (provider.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No animals found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for different terms',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.results.length,
      itemBuilder: (context, index) {
        final animal = provider.results[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              debugPrintInfo('SEARCH', 'Navigate to ${animal.name}');
              // TODO: Navigate to animal detail page
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: animal.imageUrl.isNotEmpty
                        ? Image.network(
                            animal.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.pets,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  size: 32,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.pets,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              size: 32,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          animal.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          animal.extract.length > 100 
                              ? '${animal.extract.substring(0, 100)}...'
                              : animal.extract,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.open_in_new,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'View on Wikipedia',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}