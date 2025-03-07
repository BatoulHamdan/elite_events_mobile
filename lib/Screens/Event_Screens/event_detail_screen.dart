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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool isLoading = true;
  bool isEditing = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchEventDetails();
  }

  Future<void> fetchEventDetails() async {
    final response = await eventService.fetchEventDetail(widget.eventId);

    if (response.containsKey('error')) {
      setState(() {
        error = response['error'];
        isLoading = false;
      });
    } else {
      setState(() {
        final event = response['data']['event'];
        _eventNameController.text = event['eventName'] ?? '';
        _dateController.text = event['date'] ?? '';
        _locationController.text = event['location'] ?? '';
        _descriptionController.text = event['description'] ?? '';
        isLoading = false;
      });
    }
  }

  Future<void> updateEventDetails() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final updatedData = {
      'eventName': _eventNameController.text,
      'date': _dateController.text,
      'location': _locationController.text,
      'description': _descriptionController.text,
    };

    final response = await eventService.updateEvent(
      widget.eventId,
      updatedData,
    );
    setState(() => isLoading = false);

    if (response.containsKey('error')) {
      setState(() => error = response['error']);
    } else {
      setState(() => isEditing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elite Events'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.cancel : Icons.edit),
            onPressed: () => setState(() => isEditing = !isEditing),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Container(
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
                    : error.isNotEmpty
                    ? Center(
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                    : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const Text(
                                    'Event Details',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: _eventNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Event Name',
                                      prefixIcon: Icon(Icons.event),
                                      border: OutlineInputBorder(),
                                    ),
                                    readOnly: !isEditing,
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _dateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Date',
                                      prefixIcon: Icon(Icons.calendar_today),
                                      border: OutlineInputBorder(),
                                    ),
                                    readOnly: !isEditing,
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _locationController,
                                    decoration: const InputDecoration(
                                      labelText: 'Location',
                                      prefixIcon: Icon(Icons.location_on),
                                      border: OutlineInputBorder(),
                                    ),
                                    readOnly: !isEditing,
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                      labelText: 'Description',
                                      prefixIcon: Icon(Icons.description),
                                      border: OutlineInputBorder(),
                                    ),
                                    readOnly: !isEditing,
                                    maxLines: 3,
                                  ),
                                  const SizedBox(height: 20),
                                  if (isEditing)
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: updateEventDetails,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            side: const BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Save Changes',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
