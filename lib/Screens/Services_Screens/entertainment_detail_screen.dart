import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/entertainment_model.dart';

class EntertainmentDetailScreen extends StatelessWidget {
  final Entertainment entertainment;

  const EntertainmentDetailScreen({super.key, required this.entertainment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(entertainment.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              entertainment.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: \$${entertainment.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              "Images",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: entertainment.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Image.network(
                      'http://10.0.2.2:5000/api/user/service/images/${entertainment.images[index]}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
