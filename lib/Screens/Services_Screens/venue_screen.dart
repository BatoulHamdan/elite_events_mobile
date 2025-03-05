import 'package:elite_events_mobile/Models/Services_Models/venue_model.dart';
import 'package:elite_events_mobile/Services/Services_Services/venue_service.dart';
import 'package:flutter/material.dart';
import 'venue_detail_screen.dart';

class VenueScreen extends StatefulWidget {
  const VenueScreen({super.key});

  @override
  VenueScreenState createState() => VenueScreenState();
}

class VenueScreenState extends State<VenueScreen> {
  late Future<List<Venue>> _venues;

  @override
  void initState() {
    super.initState();
    _venues = VenueService().getVenues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venues')),
      body: FutureBuilder<List<Venue>>(
        future: _venues,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No venues found.'));
          } else {
            List<Venue> venues = snapshot.data!;

            return ListView.builder(
              itemCount: venues.length,
              itemBuilder: (context, index) {
                Venue venue = venues[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      venue.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(venue.location),
                        const SizedBox(height: 5),
                        Text('Capacity: ${venue.capacity}'),
                        const SizedBox(height: 5),
                        Text('Price: \$${venue.price.toStringAsFixed(2)}'),
                      ],
                    ),
                    leading:
                        venue.images.isNotEmpty
                            ? Image.network(
                              'http://10.0.2.2:5000/api/user/service/images/${venue.images[0]}',
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            )
                            : const Icon(Icons.location_city, size: 60),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VenueDetailScreen(venue: venue),
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
