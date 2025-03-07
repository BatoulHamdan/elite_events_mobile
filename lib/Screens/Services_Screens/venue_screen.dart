import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/venue_model.dart';
import 'package:elite_events_mobile/Services/Services_Services/venue_service.dart';
import 'venue_detail_screen.dart';

class VenueScreen extends StatefulWidget {
  const VenueScreen({super.key});

  @override
  VenueScreenState createState() => VenueScreenState();
}

class VenueScreenState extends State<VenueScreen> {
  final VenueService venueService = VenueService();
  List<Venue> venueList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchVenues();
  }

  Future<void> _fetchVenues() async {
    setState(() => isLoading = true);
    try {
      List<Venue> fetchedVenues = await venueService.getVenues();
      setState(() {
        venueList = fetchedVenues;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load venues';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venues')),
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
                  : venueList.isEmpty
                  ? const Text("No venues found. Pull down to refresh.")
                  : RefreshIndicator(
                    onRefresh: _fetchVenues,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: venueList.length,
                      itemBuilder: (context, index) {
                        final venue = venueList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            title: Text(
                              venue.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Location: ${venue.location}'),
                                const SizedBox(height: 5),
                                Text('Capacity: ${venue.capacity} people'),
                                const SizedBox(height: 5),
                                Text(
                                  'Price: \$${venue.price.toStringAsFixed(2)}',
                                ),
                              ],
                            ),
                            leading:
                                venue.images.isNotEmpty
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        'http://10.0.2.2:5000/api/user/service/images/${venue.images[0]}',
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                      ),
                                    )
                                    : const Icon(Icons.location_city, size: 60),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          VenueDetailScreen(venue: venue),
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
