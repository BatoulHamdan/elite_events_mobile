import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Services/Event_Services/event_service.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  EventDetailScreenState createState() => EventDetailScreenState();
}

class EventDetailScreenState extends State<EventDetailScreen> {
  final EventService eventService = EventService();
  Map<String, dynamic>? eventDetails;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchEventDetails();
  }

  Future<void> fetchEventDetails() async {
    final response = await eventService.fetchEventDetail(widget.eventId);

    if (response.containsKey('error')) {
      setState(() {
        errorMessage = response['error'];
        isLoading = false;
      });
    } else {
      setState(() {
        eventDetails = response['data']['event'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventDetails?['eventName'] ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Date: ${eventDetails?['date'] ?? 'No Date'}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Location: ${eventDetails?['location'] ?? 'No Location'}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Description: ${eventDetails?['description'] ?? 'No Description'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
    );
  }
}
