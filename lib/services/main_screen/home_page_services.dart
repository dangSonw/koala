import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../asset/images_assets.dart';
import '../../utils/debug_utils.dart';
import 'package:dio/dio.dart';

class HomeService {

  final Dio _dio = Dio();

  static String? mammalUrlImage;
  static String? birdUrlImage;
  static String? reptileUrlImage;
  static String? fishUrlImage;
  static String? insectUrlImage;
  static String? amphibianUrlImage;

  HomeService();

  Future<void> loadAllImages() async {
    final urls = [
      'https://en.wikipedia.org/w/api.php?action=query&titles=African_elephant&prop=pageimages&pithumbsize=500&format=json&redirects=1',
      'https://en.wikipedia.org/w/api.php?action=query&titles=Peregrine_falcon&prop=pageimages&pithumbsize=500&format=json&redirects=1',
      'https://en.wikipedia.org/w/api.php?action=query&titles=Green_sea_turtle&prop=pageimages&pithumbsize=500&format=json&redirects=1',
      'https://en.wikipedia.org/w/api.php?action=query&titles=Clownfish&prop=pageimages&pithumbsize=500&format=json&redirects=1',
      'https://en.wikipedia.org/w/api.php?action=query&titles=Monarch_butterfly&prop=pageimages&pithumbsize=500&format=json&redirects=1',
      'https://en.wikipedia.org/w/api.php?action=query&titles=Axolotl&prop=pageimages&pithumbsize=500&format=json&redirects=1',
    ];

    final results = await Future.wait([
      _fetchImage(urls[0]),
      _fetchImage(urls[1]), 
      _fetchImage(urls[2]),
      _fetchImage(urls[3]),
      _fetchImage(urls[4]),
      _fetchImage(urls[5]), 
    ]);

    mammalUrlImage = results[0];
    birdUrlImage = results[1];
    reptileUrlImage = results[2];
    fishUrlImage = results[3];
    insectUrlImage = results[4];
    amphibianUrlImage = results[5];
    if (insectUrlImage == null) {
      debugPrintError('HOME_SERVICES', 'Error fetching image for insect');
    }
    if (amphibianUrlImage == null) {
      debugPrintError('HOME_SERVICES', 'Error fetching image for amphibian');
    }
    debugPrintSuccess('HOME_SERVICES', 'Fetched all images successfully');
  }

  Future<String?> _fetchImage(String url) async {
    try {
      final response = await _dio.get(url);
      if (response.statusCode != 200) {
        debugPrintError('HOME_SERVICES', 'API response code ${response.statusCode} for $url');
        return null;
      }
      final data = response.data;
      final pagesMap = data['query']['pages'] as Map<String, dynamic>;
      final pageId = pagesMap.keys.first;
      final pageData = pagesMap[pageId];
      if (pageData == null || pageData['thumbnail'] == null || pageData['thumbnail']['source'] == null) {
        debugPrintError('HOME_SERVICES', 'No thumbnail found for $url. Data: $pageData');
        return null;
      }
      final thumbnail = pageData['thumbnail']['source'].toString();
      debugPrintInfo('HOME_SERVICES', thumbnail);
      return thumbnail;
    } catch (e) {
      debugPrintError('HOME_SERVICES', 'Exception fetching image from $url: $e');
      return null;
    }
  }

  void dispose() {
    _dio.close();
  }

  List<String?> getFeaturedImages() {
    return [
      mammalUrlImage,
      birdUrlImage,
      reptileUrlImage,
      fishUrlImage,
      insectUrlImage,
      amphibianUrlImage,
    ];
  }

  static List<Map<String, dynamic>> getCategories() {
    return [
      {'name': 'Mammals', 'icon': Icons.pets, 'color': AppColors.mammals, 'count': 5416},
      {'name': 'Birds', 'icon': Icons.flutter_dash, 'color': AppColors.birds, 'count': 9993},
      {'name': 'Reptiles', 'icon': Icons.android, 'color': AppColors.reptiles, 'count': 8734},
      {'name': 'Fish', 'icon': Icons.set_meal, 'color': AppColors.fish, 'count': 28000},
      {'name': 'Insects', 'icon': Icons.bug_report, 'color': AppColors.insects, 'count': 925000},
      {'name': 'Amphibians', 'icon': Icons.water_drop, 'color': AppColors.amphibians, 'count': 7000},
    ];
  }

  List<Map<String, dynamic>> getRecentAnimals() {
    return [
      {'name': 'Bengal Tiger', 'image': AppImages.tiger, 'category': 'Mammals'},
      {'name': 'African Elephant', 'image': AppImages.elephant, 'category': 'Mammals'},
      {'name': 'Emperor Penguin', 'image': AppImages.penguin, 'category': 'Birds'},
      {'name': 'Green Sea Turtle', 'image': AppImages.turtle, 'category': 'Reptiles'},
    ];
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  String getFeaturedAnimalName(int index) {
    final names = ['Majestic Tiger', 'Gentle Elephant', 'Emperor Penguin'];
    return names[index % names.length];
  }

  String getFeaturedAnimalDescription(int index) {
    final descriptions = ['King of the jungle', 'Gentle giant', 'Emperor of the ice'];
    return descriptions[index % descriptions.length];
  }
}
