class Venue {
  final String id;
  String name;
  List<String> images;
  String description;
  String location;
  int capacity;
  ContactInfo contactInfo;
  double price;
  List<DateTime> unavailableDates;
  String eventType;

  Venue({
    required this.id,
    required this.name,
    required this.images,
    required this.description,
    required this.location,
    required this.capacity,
    required this.contactInfo,
    required this.price,
    required this.unavailableDates,
    required this.eventType,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['_id'] ?? '',
      name: json['name'],
      images: (json['images'] != null) ? List<String>.from(json['images']) : [],
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      capacity: json['capacity'] ?? 0,
      contactInfo: ContactInfo.fromJson(json['contactInfo'] ?? {}),
      price:
          (json['price'] is int)
              ? (json['price'] as int).toDouble()
              : (json['price'] as double? ?? 0.0),
      unavailableDates:
          (json['unavailableDates'] as List? ?? [])
              .map((date) => DateTime.parse(date))
              .toList(),
      eventType: json['eventType'] ?? 'other',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'images': images,
      'description': description,
      'location': location,
      'capacity': capacity,
      'contactInfo': contactInfo.toJson(),
      'price': price,
      'unavailableDates':
          unavailableDates.map((date) => date.toIso8601String()).toList(),
      'eventType': eventType,
    };
  }
}

class ContactInfo {
  String email;
  String phone;

  ContactInfo({required this.email, required this.phone});

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(email: json['email'], phone: json['phone']);
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'phone': phone};
  }
}
