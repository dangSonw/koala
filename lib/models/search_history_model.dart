import '../cache/storage_manager.dart';

/// Wrapper around the `search_history` Hive box.
/// Stores recent search queries as a simple list under a single key.
class SearchHistoryBox {
  static const String _keyQueries = 'queries';

  /// Returns all queries (most recent last).
  static List<String> getAll() {
    final list = StorageManager.searchHistoryBox.get(_keyQueries, defaultValue: <String>[]) as List<dynamic>;
    return list.map((e) => e.toString()).toList(growable: false);
  }

  /// Adds a query to the end of the list. Removes duplicates by moving to the end.
  static Future<void> add(String query, {int maxLength = 50}) async {
    final list = List<String>.from(getAll());
    list.removeWhere((e) => e == query);
    list.add(query);
    if (list.length > maxLength) {
      list.removeRange(0, list.length - maxLength);
    }
    await StorageManager.searchHistoryBox.put(_keyQueries, list);
  }

  /// Removes the query at index.
  static Future<void> removeAt(int index) async {
    final list = List<String>.from(getAll());
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      await StorageManager.searchHistoryBox.put(_keyQueries, list);
    }
  }

  /// Clears all queries.
  static Future<void> clear() async {
    await StorageManager.searchHistoryBox.put(_keyQueries, <String>[]);
  }
}
