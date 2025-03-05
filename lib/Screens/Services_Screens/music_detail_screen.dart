import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/music_model.dart';

class MusicDetailScreen extends StatelessWidget {
  final Music music;

  const MusicDetailScreen({super.key, required this.music});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(music.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (music.images.isNotEmpty)
              Text(
                music.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 5),
            Text("Type: ${music.type}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 5),
            Text(
              "Price: \$${music.price.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Image.network(
              'http://10.0.2.2:5000/api/user/service/images/${music.images[0]}',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
