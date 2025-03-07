import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/catering_model.dart';

class CateringDetailScreen extends StatelessWidget {
  final Catering catering;

  const CateringDetailScreen({super.key, required this.catering});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(catering.restaurantName)),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/title.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (catering.images.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    'http://10.0.2.2:5000/api/user/service/images/${catering.images[0]}',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        catering.restaurantName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildMenuSection('Drink Menu', catering.drinkMenu),
                      _buildMenuSection('Food Menu', catering.foodMenu),
                      _buildMenuSection('Dessert Menu', catering.dessertMenu),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<MenuItem> menuItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        if (menuItems.isEmpty)
          const Text('No items available')
        else
          ...menuItems.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text('${item.type}: \$${item.price.toStringAsFixed(2)}'),
            );
          }),
        const SizedBox(height: 10),
      ],
    );
  }
}
