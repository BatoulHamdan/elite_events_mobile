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

  Future<void> _deleteEvent(String eventId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this event?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      final response = await eventService.deleteEvent(eventId);
      if (response.containsKey('error')) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['error']),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event deleted successfully")),
        );
        _fetchEvents();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elite Events')),
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
                  : events.isEmpty
                  ? const Text("No events found. Tap '+' to add one!")
                  : RefreshIndicator(
                    onRefresh: _fetchEvents,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              event['eventName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteEvent(event['_id']),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EventDetailScreen(
                                        eventId: event['_id'],
                                      ),
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
