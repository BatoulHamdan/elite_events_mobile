import 'dart:convert';

class Entertainment {
  final String id;
  final String name;
  final double price;
  final List<String> images;

  Entertainment({
    required this.id,
    required this.name,
    required this.price,
    required this.images,
  });

  // Factory method to create an instance from JSON
  factory Entertainment.fromJson(Map<String, dynamic> json) {
    return Entertainment(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'price': price, 'images': images};
  }

  // Convert a JSON string to a List of Entertainment objects
  static List<Entertainment> listFromJson(String str) {
    final List<dynamic> jsonData = json.decode(str);
    return jsonData.map((item) => Entertainment.fromJson(item)).toList();
  }
}
