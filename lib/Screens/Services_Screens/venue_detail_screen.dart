import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/venue_model.dart';

class VenueDetailScreen extends StatelessWidget {
  final Venue venue;

  const VenueDetailScreen({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(venue.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              venue.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${venue.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Capacity: ${venue.capacity}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: \$${venue.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Description:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(venue.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            venue.images.isNotEmpty
                ? Image.network(
                  'http://10.0.2.2:5000/api/user/service/images/${venue.images[0]}',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                )
                : const Icon(Icons.location_city, size: 200),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
