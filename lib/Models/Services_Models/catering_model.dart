class Catering {
  final String id;
  final String restaurantName;
  final List<MenuItem> drinkMenu;
  final List<MenuItem> foodMenu;
  final List<MenuItem> dessertMenu;
  final List<String> images;

  Catering({
    required this.id,
    required this.restaurantName,
    required this.drinkMenu,
    required this.foodMenu,
    required this.dessertMenu,
    required this.images,
  });

  factory Catering.fromJson(Map<String, dynamic> json) {
    return Catering(
      id: json['_id'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      drinkMenu:
          (json['drinkMenu'] as List?)
              ?.map((item) => MenuItem.fromJson(item))
              .toList() ??
          [],
      foodMenu:
          (json['foodMenu'] as List?)
              ?.map((item) => MenuItem.fromJson(item))
              .toList() ??
          [],
      dessertMenu:
          (json['dessertMenu'] as List?)
              ?.map((item) => MenuItem.fromJson(item))
              .toList() ??
          [],
      images:
          (json['images'] as List?)?.map((item) => item.toString()).toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'restaurantName': restaurantName,
      'drinkMenu': drinkMenu.map((item) => item.toJson()).toList(),
      'foodMenu': foodMenu.map((item) => item.toJson()).toList(),
      'dessertMenu': dessertMenu.map((item) => item.toJson()).toList(),
      'images': images,
    };
  }
}

class MenuItem {
  final String id;
  final String type;
  final double price;

  MenuItem({required this.id, required this.type, required this.price});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'type': type, 'price': price};
  }
}
