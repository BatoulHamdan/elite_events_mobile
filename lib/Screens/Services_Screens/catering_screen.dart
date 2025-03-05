import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/catering_model.dart';
import 'package:elite_events_mobile/Services/Services_Services/catering_service.dart';
import 'catering_detail_screen.dart';

class CateringScreen extends StatefulWidget {
  const CateringScreen({super.key});

  @override
  CateringScreenState createState() => CateringScreenState();
}

class CateringScreenState extends State<CateringScreen> {
  late Future<List<Catering>> _cateringList;

  @override
  void initState() {
    super.initState();
    _cateringList = CateringService().getCaterings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catering Services')),
      body: FutureBuilder<List<Catering>>(
        future: _cateringList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No catering services available.'));
          } else {
            List<Catering> cateringList = snapshot.data!;

            return ListView.builder(
              itemCount: cateringList.length,
              itemBuilder: (context, index) {
                Catering catering = cateringList[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      catering.restaurantName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Food Menu: ${catering.foodMenu.length} items'),
                        Text('Drink Menu: ${catering.drinkMenu.length} items'),
                        Text(
                          'Dessert Menu: ${catering.dessertMenu.length} items',
                        ),
                      ],
                    ),
                    leading:
                        catering.images.isNotEmpty
                            ? Image.network(
                              'http://10.0.2.2:5000/api/user/service/images/${catering.images[0]}',
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            )
                            : const Icon(Icons.restaurant, size: 60),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  CateringDetailScreen(catering: catering),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
