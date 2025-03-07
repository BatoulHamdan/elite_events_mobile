import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Services/Event_Services/event_service.dart';
import 'package:elite_events_mobile/Screens/Event_Screens/event_detail_screen.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  AddEventScreenState createState() => AddEventScreenState();
}

class AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _eventType = 'other';
  bool _isLoading = false;
  String _error = ''; // Error message variable

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = ''; // Clear previous errors
    });

    final eventData = {
      'eventName': _eventNameController.text,
      'date': _dateController.text,
      'time': _timeController.text,
      'location': _locationController.text,
      'description': _descriptionController.text,
      'eventType': _eventType,
    };

    final response = await EventService().addEvent(eventData);

    setState(() {
      _isLoading = false;
    });

    if (response.containsKey('error')) {
      setState(() {
        _error = response['error'];
      });
    } else {
      final eventId = response['data']['_id'];
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailScreen(eventId: eventId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elite Events')),
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/title.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Add Event',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _eventNameController,
                            decoration: const InputDecoration(
                              labelText: 'Event Name',
                              prefixIcon: Icon(Icons.event),
                              border: OutlineInputBorder(),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? 'Event Name is required'
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _dateController,
                            decoration: const InputDecoration(
                              labelText: 'Date (YYYY-MM-DD)',
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(3000),
                              );
                              if (pickedDate != null) {
                                _dateController.text =
                                    '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _timeController,
                            decoration: const InputDecoration(
                              labelText: 'Time (HH:MM)',
                              prefixIcon: Icon(Icons.access_time),
                              border: OutlineInputBorder(),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty ? 'Time is required' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              labelText: 'Location',
                              prefixIcon: Icon(Icons.location_on),
                              border: OutlineInputBorder(),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? 'Location is required'
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _eventType,
                            onChanged: (value) {
                              setState(() {
                                _eventType = value!;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 'Birthday',
                                child: Text('Birthday'),
                              ),
                              DropdownMenuItem(
                                value: 'Conference',
                                child: Text('Conference'),
                              ),
                              DropdownMenuItem(
                                value: 'Engagement',
                                child: Text('Engagement'),
                              ),
                              DropdownMenuItem(
                                value: 'Wedding',
                                child: Text('Wedding'),
                              ),
                              DropdownMenuItem(
                                value: 'Festival',
                                child: Text('Festival'),
                              ),
                              DropdownMenuItem(
                                value: 'Workshop',
                                child: Text('Workshop'),
                              ),
                              DropdownMenuItem(
                                value: 'other',
                                child: Text('Other'),
                              ),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Event Type',
                              prefixIcon: Icon(Icons.category),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              prefixIcon: Icon(Icons.description),
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 20),
                          if (_error.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _error,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                onPressed: _submitForm,
                                child: const Text('Add Event'),
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
