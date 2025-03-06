import 'dart:convert';

class Offer {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  // Factory method to create an instance from JSON
  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startDate:
          json['startDate'] != null
              ? DateTime.parse(json['startDate'])
              : DateTime.now(),
      endDate:
          json['endDate'] != null
              ? DateTime.parse(json['endDate'])
              : DateTime.now(),
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  // Convert a JSON string to a List of Photo
  static List<Offer> listFromJson(String str) {
    final List<dynamic> jsonData = json.decode(str)['data'];
    return jsonData.map((item) => Offer.fromJson(item)).toList();
  }
}
