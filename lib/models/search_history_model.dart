import '../cache/storage_manager.dart';

class SearchHistoryBox {
  static const String _keyQueries = 'queries';

  static List<String> getAll() {
    final list = StorageManager.searchHistoryBox.get(_keyQueries, defaultValue: <String>[]) as List<dynamic>;
    return list.map((e) => e.toString()).toList(growable: false);
  }

  static Future<void> add(String query, {int maxLength = 50}) async {
    final list = List<String>.from(getAll());
    list.removeWhere((e) => e == query);
    list.add(query);
    if (list.length > maxLength) {
      list.removeRange(0, list.length - maxLength);
    }
    await StorageManager.searchHistoryBox.put(_keyQueries, list);
  }

  static Future<void> removeAt(int index) async {
    final list = List<String>.from(getAll());
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      await StorageManager.searchHistoryBox.put(_keyQueries, list);
    }
  }

  static Future<void> clear() async {
    await StorageManager.searchHistoryBox.put(_keyQueries, <String>[]);
  }
}
