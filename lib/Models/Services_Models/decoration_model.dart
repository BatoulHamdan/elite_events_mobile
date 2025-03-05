class Decorationn {
  final String id;
  final String name;
  final String type;
  final double price;
  final List<String> images;

  Decorationn({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.images,
  });

  // Factory method to create an instance from JSON
  factory Decorationn.fromJson(Map<String, dynamic> json) {
    return Decorationn(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'type': type,
      'price': price,
      'images': images,
    };
  }

  // Convert a list of JSON objects into a list of Decorationn
  static List<Decorationn> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Decorationn.fromJson(json)).toList();
  }
}
