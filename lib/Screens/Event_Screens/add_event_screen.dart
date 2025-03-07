import 'package:elite_events_mobile/Screens/Event_Screens/event_detail_screen.dart';
import 'package:elite_events_mobile/Services/Event_Services/event_service.dart';
import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  AddEventScreenState createState() => AddEventScreenState();
}

class AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for event details
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _eventType = 'other';
  String _error = '';
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = '';
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
  void dispose() {
    _eventNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_error.isNotEmpty) ...[
                  Text(_error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                ],

                // Event Name Field
                TextFormField(
                  controller: _eventNameController,
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                    prefixIcon: Icon(Icons.event),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Event Name is required' : null,
                ),
                const SizedBox(height: 16),

                // Date Field
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date (YYYY-MM-DD)',
                    prefixIcon: Icon(Icons.calendar_today),
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

                // Time Field
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: 'Time (HH:MM)',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  validator:
                      (value) => value!.isEmpty ? 'Time is required' : null,
                ),
                const SizedBox(height: 16),

                // Location Field
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator:
                      (value) => value!.isEmpty ? 'Location is required' : null,
                ),
                const SizedBox(height: 16),

                // Event Type Selection
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
                    DropdownMenuItem(value: 'Wedding', child: Text('Wedding')),
                    DropdownMenuItem(
                      value: 'Festival',
                      child: Text('Festival'),
                    ),
                    DropdownMenuItem(
                      value: 'Workshop',
                      child: Text('Workshop'),
                    ),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Event Type',
                    prefixIcon: Icon(Icons.category),
                  ),
                  validator:
                      (value) =>
                          value == null ? 'Event Type is required' : null,
                ),
                const SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Description is required' : null,
                ),
                const SizedBox(height: 16),

                // Submit Button or Loading Indicator
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add Event'),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
