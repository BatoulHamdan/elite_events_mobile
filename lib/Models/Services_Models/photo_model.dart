import 'dart:convert';

class Photo {
  final String id;
  final String eventName;
  final String eventType;
  final List<String> images;

  Photo({
    required this.id,
    required this.eventName,
    required this.eventType,
    required this.images,
  });

  // Factory method to create an instance from JSON
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['_id'] ?? '',
      eventName: json['eventName'] ?? '',
      eventType: json['eventType'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'eventName': eventName,
      'eventType': eventType,
      'images': images,
    };
  }

  // Convert a JSON string to a List of Photo
  static List<Photo> listFromJson(String str) {
    final List<dynamic> jsonData = json.decode(str)['data'];
    return jsonData.map((item) => Photo.fromJson(item)).toList();
  }
}
