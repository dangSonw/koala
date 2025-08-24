import '../../asset/images_assets.dart';

class SearchService {
  static List<Map<String, dynamic>> getAllAnimals() {
    return [
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
  }

  static Future<List<Map<String, dynamic>>> searchAnimals(String query, String filter) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final trimmed = query.trim().toLowerCase();
    final all = getAllAnimals();
    return all
        .where((e) => e['name'].toString().toLowerCase().contains(trimmed))
        .where((e) => filter == 'All' || e['category'] == filter)
        .toList();
  }
}