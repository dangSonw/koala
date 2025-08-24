import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../asset/images_assets.dart';

class HomeService {
  static List<String> getFeaturedImages() {
    return [
      AppImages.featured1,
      AppImages.featured2, 
      AppImages.featured3,
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

  static List<Map<String, dynamic>> getRecentAnimals() {
    return [
      {'name': 'Bengal Tiger', 'image': AppImages.tiger, 'category': 'Mammals'},
      {'name': 'African Elephant', 'image': AppImages.elephant, 'category': 'Mammals'},
      {'name': 'Emperor Penguin', 'image': AppImages.penguin, 'category': 'Birds'},
      {'name': 'Green Sea Turtle', 'image': AppImages.turtle, 'category': 'Reptiles'},
    ];
  }

  static Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  static String getFeaturedAnimalName(int index) {
    final names = ['Majestic Tiger', 'Gentle Elephant', 'Emperor Penguin'];
    return names[index % names.length];
  }

  static String getFeaturedAnimalDescription(int index) {
    final descriptions = ['King of the jungle', 'Gentle giant', 'Emperor of the ice'];
    return descriptions[index % descriptions.length];
  }
}
