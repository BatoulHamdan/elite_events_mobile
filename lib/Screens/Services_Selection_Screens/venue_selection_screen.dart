import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/venue_model.dart';
import 'package:elite_events_mobile/Services/Services_Services/venue_service.dart';

class VenueSelectionScreen extends StatefulWidget {
  const VenueSelectionScreen({super.key});

  @override
  VenueSelectionScreenState createState() => VenueSelectionScreenState();
}

class VenueSelectionScreenState extends State<VenueSelectionScreen> {
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

  void _bookVenue(Venue venue) {
    // Implement venue booking logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booked ${venue.name} successfully!')),
    );
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
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => _bookVenue(venue),
                                  child: const Text("Book"),
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
