import 'package:flutter/foundation.dart';
import '../cache/storage_manager.dart';

/// Lightweight wrapper around the `favorites` Hive box.
/// Stores favorite item IDs as keys with boolean `true` values.
class FavoritesBox {
  FavoritesBox._();

  static BoxInfo get _box => BoxInfo(StorageManager.favoritesBox);

  /// Returns all favorite IDs.
  static List<String> getAllIds() {
    return _box.box.keys.map((e) => e.toString()).toList(growable: false);
  }

  /// Check if an ID is favorite.
  static bool isFavorite(String id) {
    return _box.box.containsKey(id);
  }

  /// Add an ID to favorites.
  static Future<void> add(String id) async {
    await _box.box.put(id, true);
  }

  /// Remove an ID from favorites.
  static Future<void> remove(String id) async {
    await _box.box.delete(id);
  }

  /// Toggle favorite state for an ID.
  static Future<bool> toggle(String id) async {
    if (isFavorite(id)) {
      await remove(id);
      return false;
    } else {
      await add(id);
      return true;
    }
  }
}

class BoxInfo {
  final dynamic box;
  BoxInfo(this.box);
}
