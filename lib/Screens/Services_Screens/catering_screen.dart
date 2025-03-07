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
  final CateringService cateringService = CateringService();
  List<Catering> cateringList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCaterings();
  }

  Future<void> _fetchCaterings() async {
    setState(() => isLoading = true);
    try {
      List<Catering> fetchedCatering = await cateringService.getCaterings();
      setState(() {
        cateringList = fetchedCatering;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load catering services';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caterings')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/title.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child:
              isLoading
                  ? const CircularProgressIndicator()
                  : errorMessage.isNotEmpty
                  ? Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  )
                  : cateringList.isEmpty
                  ? const Text(
                    "No catering services found. Tap '+' to add one!",
                  )
                  : RefreshIndicator(
                    onRefresh: _fetchCaterings,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: cateringList.length,
                      itemBuilder: (context, index) {
                        final catering = cateringList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            title: Text(
                              catering.restaurantName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Food Menu: ${catering.foodMenu.length} items',
                                ),
                                Text(
                                  'Drink Menu: ${catering.drinkMenu.length} items',
                                ),
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
                            trailing: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CateringDetailScreen(
                                        catering: catering,
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
        ),
      ),
    );
  }
}
