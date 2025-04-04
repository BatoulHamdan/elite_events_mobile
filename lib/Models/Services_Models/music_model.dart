import 'dart:convert';

class Music {
  final String id;
  final String name;
  final String type;
  final double price;
  final List<String> images;
  List<DateTime> unavailableDates;

  Music({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.images,
    required this.unavailableDates,
  });

  // Factory method to create an instance from JSON
  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      unavailableDates:
          (json['unavailableDates'] as List? ?? [])
              .map((date) => DateTime.parse(date))
              .toList(),
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'type': type,
      'price': price,
      'images': images,
      'unavailableDates':
          unavailableDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  // Convert a JSON string to a List of MusicModel
  static List<Music> listFromJson(String str) {
    final List<dynamic> jsonData = json.decode(str)['data'];
    return jsonData.map((item) => Music.fromJson(item)).toList();
  }
}
