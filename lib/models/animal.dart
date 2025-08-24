class Animal {
  final String name;     
  final String extract;  
  final String imageUrl;   
  final String wikiUrl;   

  Animal({
    required this.name,
    required this.extract,
    required this.imageUrl,
    required this.wikiUrl,
  });

  // Parse từ Wikipedia API JSON
  factory Animal.fromWikipediaJson(Map<String, dynamic> json) {
    return Animal(
      name: json['title'] ?? '',
      extract: json['extract'] ?? '', 
      imageUrl: json['thumbnail']?['source'] ?? '',
      wikiUrl: json['content_urls']?['desktop']?['page'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'extract': extract,
      'imageUrl': imageUrl,
      'wikiUrl': wikiUrl,
    };
  }
}
