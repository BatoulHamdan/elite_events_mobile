import 'package:elite_events_mobile/Screens/Event_Screens/attendee_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Services/Event_Services/attendee_service.dart';
import 'package:elite_events_mobile/Screens/Event_Screens/add_attendee_screen.dart';

class ViewAttendeesScreen extends StatefulWidget {
  final String eventId;

  const ViewAttendeesScreen({super.key, required this.eventId});

  @override
  ViewAttendeesScreenState createState() => ViewAttendeesScreenState();
}

class ViewAttendeesScreenState extends State<ViewAttendeesScreen> {
  final AttendeeService attendeeService = AttendeeService();
  List<dynamic> attendees = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAttendees();
  }

  Future<void> _fetchAttendees() async {
    setState(() => isLoading = true);
    final response = await attendeeService.getAttendees(widget.eventId);
    setState(() {
      isLoading = false;
      if (response.containsKey('error')) {
        errorMessage = response['error'];
      } else {
        attendees = response['data'] ?? [];
      }
    });
  }

  Future<void> _deleteAttendee(String attendeeId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to remove this attendee?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      final response = await attendeeService.deleteAttendee(attendeeId);
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
          const SnackBar(content: Text("Attendee removed successfully")),
        );
        _fetchAttendees();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendees')),
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
                  : attendees.isEmpty
                  ? const Text("No attendees found. Tap '+' to add one!")
                  : RefreshIndicator(
                    onRefresh: _fetchAttendees,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: attendees.length,
                      itemBuilder: (context, index) {
                        final attendee = attendees[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              attendee['fullName'] ?? 'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(attendee['email'] ?? 'No email'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => _deleteAttendee(attendee['_id']),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => AttendeeDetailScreen(
                                        eventId: widget.eventId,
                                        attendeeId: attendee['_id'],
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
            MaterialPageRoute(
              builder: (context) => AddAttendeeScreen(eventId: widget.eventId),
            ),
          );
          if (result == true) {
            _fetchAttendees();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
