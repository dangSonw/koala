import 'package:dio/dio.dart';
import '../../models/animal.dart';
import '../../utils/debug_utils.dart';

class SearchService {
  static final Dio _dio = Dio();
  
  static const String _baseUrl = 'https://en.wikipedia.org/api/rest_v1';
  
  // Popular animal searches for suggestions
  static const List<String> popularAnimals = [
    'Lion', 'Tiger', 'Elephant', 'Giraffe', 'Zebra', 'Penguin',
    'Dolphin', 'Whale', 'Shark', 'Eagle', 'Owl', 'Butterfly',
    'Snake', 'Turtle', 'Monkey', 'Panda', 'Koala', 'Kangaroo'
  ];

  static Future<List<Animal>> searchAnimals(String query, {String filter = 'All'}) async {
    try {
      final trimmedQuery = query.trim();
      if (trimmedQuery.isEmpty) return [];

      debugPrintInfo('[SEARCH_SERVICE]', 'Searching for: $trimmedQuery');
      
      // Search Wikipedia for animal-related articles
      final searchResponse = await _dio.get(
        '$_baseUrl/page/summary/${Uri.encodeComponent(trimmedQuery)}',
        options: Options(
          headers: {
            'User-Agent': 'KoalaApp/1.0 (https://example.com/contact)'
          },
        ),
      );

      if (searchResponse.statusCode == 200) {
        final data = searchResponse.data;
        if (data != null && data['extract'] != null) {
          final animal = Animal.fromWikipediaJson(data);
          return [animal];
        }
      }
      
      // If direct search fails, try opensearch API for suggestions
      return await _searchMultipleAnimals(trimmedQuery);
      
    } catch (e) {
      debugPrintInfo('[SEARCH_SERVICE]', 'Search error: $e');
      // Fallback to local search if API fails
      return _searchLocalAnimals(query, filter);
    }
  }

  static Future<List<Animal>> _searchMultipleAnimals(String query) async {
    try {
      final searchResponse = await _dio.get(
        'https://en.wikipedia.org/w/api.php',
        queryParameters: {
          'action': 'opensearch',
          'search': '$query animal',
          'limit': 5,
          'format': 'json',
        },
        options: Options(
          headers: {
            'User-Agent': 'KoalaApp/1.0 (https://example.com/contact)'
          },
        ),
      );

      if (searchResponse.statusCode == 200) {
        final data = searchResponse.data as List;
        if (data.length >= 2) {
          final titles = data[1] as List;
          // final descriptions = data.length > 2 ? data[2] as List : <String>[];
          // final urls = data.length > 3 ? data[3] as List : <String>[];
          
          List<Animal> animals = [];
          for (int i = 0; i < titles.length && i < 3; i++) {
            try {
              final summaryResponse = await _dio.get(
                '$_baseUrl/page/summary/${Uri.encodeComponent(titles[i])}',
                options: Options(
                  headers: {
                    'User-Agent': 'KoalaApp/1.0 (https://example.com/contact)'
                  },
                ),
              );
              
              if (summaryResponse.statusCode == 200) {
                final animal = Animal.fromWikipediaJson(summaryResponse.data);
                animals.add(animal);
              }
            } catch (e) {
              // Skip this result if there's an error
              continue;
            }
          }
          return animals;
        }
      }
    } catch (e) {
      debugPrintInfo('[SEARCH_SERVICE]', 'Multiple search error: $e');
    }
    return [];
  }

  static List<Animal> _searchLocalAnimals(String query, String filter) {
    // Fallback local data when API is unavailable
    final localAnimals = [
      {
        'title': 'Lion',
        'extract': 'The lion is a large cat of the genus Panthera native to Africa and India.',
        'thumbnail': {'source': 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Lion_waiting_in_Namibia.jpg/320px-Lion_waiting_in_Namibia.jpg'},
        'content_urls': {'desktop': {'page': 'https://en.wikipedia.org/wiki/Lion'}}
      },
      {
        'title': 'Tiger',
        'extract': 'The tiger is the largest living cat species and a member of the genus Panthera.',
        'thumbnail': {'source': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Tiger.50.jpg/320px-Tiger.50.jpg'},
        'content_urls': {'desktop': {'page': 'https://en.wikipedia.org/wiki/Tiger'}}
      },
      {
        'title': 'Elephant',
        'extract': 'Elephants are the largest existing land animals.',
        'thumbnail': {'source': 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/African_Bush_Elephant.jpg/320px-African_Bush_Elephant.jpg'},
        'content_urls': {'desktop': {'page': 'https://en.wikipedia.org/wiki/Elephant'}}
      },
    ];

    return localAnimals
        .where((animal) => animal['title'].toString().toLowerCase().contains(query.toLowerCase()))
        .map((animal) => Animal.fromWikipediaJson(animal))
        .toList();
  }

  static List<String> getPopularSearches() {
    return popularAnimals;
  }
}