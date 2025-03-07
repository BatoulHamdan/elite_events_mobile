import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Services/Event_Services/event_service.dart';
import 'package:elite_events_mobile/Screens/Event_Screens/add_event_screen.dart';
import 'package:elite_events_mobile/Screens/Event_Screens/event_detail_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends State<EventsScreen> {
  final EventService eventService = EventService();
  List<dynamic> events = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() => isLoading = true);
    final response = await eventService.fetchUserEvents();
    setState(() {
      isLoading = false;
      if (response.containsKey('error')) {
        errorMessage = response['error'];
      } else {
        events = response['data'] ?? [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Events')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : events.isEmpty
              ? const Center(
                child: Text("No events found. Tap '+' to add one!"),
              )
              : RefreshIndicator(
                onRefresh: _fetchEvents,
                child: ListView.separated(
                  itemCount: events.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      title: Text(
                        event['eventName'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    EventDetailScreen(eventId: event['_id']),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventScreen()),
          );
          if (result == true) {
            _fetchEvents();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
