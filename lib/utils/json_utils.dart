
String? getJsonString(dynamic jsonData, String keyPath, [String? defaultValue]) {
  if (jsonData == null) return defaultValue;
  
  List<String> keys = keyPath.split('.');
  dynamic current = jsonData;
  
  for (String key in keys) {
    if (current is Map<String, dynamic>) {
      current = current[key];
    } else if (current is List) {
      
      int? index = int.tryParse(key);
      if (index != null && index < current.length) {
        current = current[index];
      } else {
        return defaultValue;
      }
    } else {
      return defaultValue;
    }
  }
  

  if (current == null) return defaultValue;
  return current.toString();
}