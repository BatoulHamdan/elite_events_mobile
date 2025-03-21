import 'package:elite_events_mobile/Models/attendee_model.dart';
import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Services/Event_Services/attendee_service.dart';

class AddAttendeeScreen extends StatefulWidget {
  final String eventId;

  const AddAttendeeScreen({super.key, required this.eventId});

  @override
  AddAttendeeScreenState createState() => AddAttendeeScreenState();
}

class AddAttendeeScreenState extends State<AddAttendeeScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final AttendeeService attendeeService = AttendeeService();
  String error = '';
  bool isLoading = false;

  Future<void> _addAttendee() async {
    setState(() {
      isLoading = true;
    });

    Attendee attendee = Attendee(
      id: '',
      fullName: fullNameController.text,
      email: emailController.text,
      event: widget.eventId,
    );

    final response = await attendeeService.addAttendee(
      widget.eventId,
      attendee,
    );

    setState(() {
      isLoading = false;
    });

    if (response.containsKey('error')) {
      setState(() {
        error = response['error'];
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Attendee added successfully")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Attendee')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _addAttendee,
                  child: const Text('Add Attendee'),
                ),
          ],
        ),
      ),
    );
  }
}
