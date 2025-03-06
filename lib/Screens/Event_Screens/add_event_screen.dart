import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Services/Event_Services/event_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  AddEventScreenState createState() => AddEventScreenState();
}

class AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final EventService eventService = EventService();

  String eventName = '';
  String description = '';
  String location = '';
  String date = '';
  String time = '';
  String eventType = '';

  bool isLoading = false;
  String errorMessage = '';

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => isLoading = true);

    final eventData = {
      'eventName': eventName,
      'description': description,
      'location': location,
      'date': date,
      'time': time,
      'eventType': eventType,
    };

    final response = await eventService.addEvent(eventData);

    setState(() => isLoading = false);

    if (response.containsKey('error')) {
      setState(() => errorMessage = response['error']);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Event Name'),
                  validator:
                      (value) => value!.isEmpty ? 'Required field' : null,
                  onSaved: (value) => eventName = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator:
                      (value) => value!.isEmpty ? 'Required field' : null,
                  onSaved: (value) => description = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator:
                      (value) => value!.isEmpty ? 'Required field' : null,
                  onSaved: (value) => location = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Date (YYYY-MM-DD)',
                  ),
                  validator:
                      (value) => value!.isEmpty ? 'Required field' : null,
                  onSaved: (value) => date = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Time (HH:MM)'),
                  validator:
                      (value) => value!.isEmpty ? 'Required field' : null,
                  onSaved: (value) => time = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Event Type'),
                  validator:
                      (value) => value!.isEmpty ? 'Required field' : null,
                  onSaved: (value) => eventType = value!,
                ),
                const SizedBox(height: 20),
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                      onPressed: _submitForm,
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
