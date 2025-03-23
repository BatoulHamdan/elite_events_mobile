import 'package:elite_events_mobile/Models/Services_Models/venue_model.dart';
import 'package:elite_events_mobile/Services/Event_Services/event_service.dart';
import 'package:elite_events_mobile/Services/Services_Services/venue_service.dart';
import 'package:flutter/material.dart';

class VenueSelectionScreen extends StatefulWidget {
  final String eventId;

  const VenueSelectionScreen({super.key, required this.eventId});

  @override
  VenueSelectionScreenState createState() => VenueSelectionScreenState();
}

class VenueSelectionScreenState extends State<VenueSelectionScreen> {
  final EventService _eventService = EventService();
  final VenueService _venueService = VenueService();
  Map<String, dynamic>? eventData;
  List<Venue> venueList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchEventData();
  }

  Future<void> _fetchEventData() async {
    try {
      final response = await _eventService.fetchEventDetail(widget.eventId);
      final event = response['data']['event'];

      if (event.containsKey('error')) {
        throw Exception(event['error']);
      }

      final venues = await _venueService.getVenues();
      setState(() {
        eventData = event;
        venueList = venues;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _bookVenue(Venue venue) async {
    try {
      await _venueService.bookVenue(venue.id.toString(), widget.eventId);
      await _eventService.updateEvent(widget.eventId, {'venue': venue.id});
      setState(() {
        eventData?['venue'] = venue.id;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _cancelBooking() async {
    try {
      await _venueService.cancelBooking(eventData!['venue'], widget.eventId);
      await _eventService.updateEvent(widget.eventId, {'venue': null});
      setState(() {
        eventData!['venue'] = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  bool checkAvailability(Venue venue) {
    return eventData != null &&
        !venue.unavailableDates.contains(eventData!['date']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(eventData?['name'] ?? "Venue Selection")),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/title.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                : venueList.isEmpty
                ? const Center(
                  child: Text("No venues found. Pull down to refresh."),
                )
                : RefreshIndicator(
                  onRefresh: () async => _fetchEventData(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: venueList.length,
                    itemBuilder: (context, index) {
                      final venue = venueList[index];
                      bool isAvailable = checkAvailability(venue);
                      bool isBooked = eventData?['venue'] == venue.id;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          title: Text(
                            venue.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Location: ${venue.location}'),
                              Text('Capacity: ${venue.capacity} people'),
                              Text(
                                'Price: \$${venue.price.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 10),
                              if (isBooked)
                                ElevatedButton(
                                  onPressed: _cancelBooking,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text("Cancel Booking"),
                                )
                              else if (isAvailable)
                                ElevatedButton(
                                  onPressed: () => _bookVenue(venue),
                                  child: const Text("Book"),
                                )
                              else
                                const Text(
                                  "Unavailable",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                          leading:
                              (venue.images.isNotEmpty)
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
    );
  }
}
