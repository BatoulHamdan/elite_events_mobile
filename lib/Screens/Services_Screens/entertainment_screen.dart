import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/entertainment_model.dart';
import 'package:elite_events_mobile/Services/Services_Services/entertainment_service.dart';
import 'entertainment_detail_screen.dart';

class EntertainmentScreen extends StatefulWidget {
  const EntertainmentScreen({super.key});

  @override
  EntertainmentScreenState createState() => EntertainmentScreenState();
}

class EntertainmentScreenState extends State<EntertainmentScreen> {
  late Future<List<Entertainment>> _entertainmentList;

  @override
  void initState() {
    super.initState();
    _entertainmentList = EntertainmentService().getEntertainments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entertainment Services')),
      body: FutureBuilder<List<Entertainment>>(
        future: _entertainmentList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No entertainment available.'));
          } else {
            List<Entertainment> entertainmentList = snapshot.data!;

            return ListView.builder(
              itemCount: entertainmentList.length,
              itemBuilder: (context, index) {
                Entertainment entertainment = entertainmentList[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      entertainment.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price: \$${entertainment.price.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                    leading:
                        entertainment.images.isNotEmpty
                            ? Image.network(
                              'http://10.0.2.2:5000/api/user/service/images/${entertainment.images[0]}',
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            )
                            : const Icon(Icons.music_note, size: 60),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EntertainmentDetailScreen(
                                entertainment: entertainment,
                              ),
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
