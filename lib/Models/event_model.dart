import 'dart:convert';

class Event {
  final String id;
  final String eventName;
  final DateTime date;
  final String time;
  final String location;
  final String description;
  final String eventType;
  final String organizer;
  final String? music;
  final String? entertainment;
  final String? catering;
  final String? venue;
  final String? photo;
  final String? decoration;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.eventName,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.eventType,
    required this.organizer,
    this.music,
    this.entertainment,
    this.catering,
    this.venue,
    this.photo,
    this.decoration,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      eventName: json['eventName'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      eventType: json['eventType'] ?? 'other',
      organizer: json['organizer'] ?? '',
      music: json['music'],
      entertainment: json['entertainment'],
      catering: json['catering'],
      venue: json['venue'],
      photo: json['photo'],
      decoration: json['decoration'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'eventName': eventName,
      'date': date.toIso8601String(),
      'time': time,
      'location': location,
      'description': description,
      'eventType': eventType,
      'organizer': organizer,
      'music': music,
      'entertainment': entertainment,
      'catering': catering,
      'venue': venue,
      'photo': photo,
      'decoration': decoration,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Convert a JSON string to a List of Event objects
  static List<Event> listFromJson(String str) {
    final List<dynamic> jsonData = json.decode(str);
    return jsonData.map((item) => Event.fromJson(item)).toList();
  }
}
