import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/attendee_model.dart';
import 'package:elite_events_mobile/Services/Event_Services/attendee_service.dart';

class AttendeeDetailScreen extends StatefulWidget {
  final String eventId;
  final String attendeeId;

  const AttendeeDetailScreen({
    super.key,
    required this.eventId,
    required this.attendeeId,
  });

  @override
  AttendeeDetailScreenState createState() => AttendeeDetailScreenState();
}

class AttendeeDetailScreenState extends State<AttendeeDetailScreen> {
  final AttendeeService attendeeService = AttendeeService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool isLoading = true;
  bool isEditing = false;
  String error = '';

  Attendee? attendee;

  @override
  void initState() {
    super.initState();
    fetchAttendeeDetails();
  }

  Future<void> fetchAttendeeDetails() async {
    final response = await attendeeService.getAttendee(
      widget.eventId,
      widget.attendeeId,
    );

    if (response.containsKey('error')) {
      setState(() {
        error = response['error'];
        isLoading = false;
      });
    } else if (response['data'] != null) {
      setState(() {
        attendee = Attendee.fromJson(response['data']);
        _nameController.text = attendee!.fullName;
        _emailController.text = attendee!.email;
        isLoading = false;
      });
    } else {
      setState(() {
        error = 'Attendee details not found.';
        isLoading = false;
      });
    }
  }

  Future<void> updateAttendeeDetails() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final updatedAttendee = Attendee(
      id: widget.attendeeId,
      fullName: _nameController.text,
      email: _emailController.text,
      event: widget.eventId,
    );

    final response = await attendeeService.updateAttendee(
      widget.eventId,
      widget.attendeeId,
      updatedAttendee,
    );

    setState(() => isLoading = false);

    if (response.containsKey('error')) {
      setState(() => error = response['error']);
    } else {
      setState(() {
        isEditing = false;
        fetchAttendeeDetails();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendees'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.cancel : Icons.edit),
            onPressed: () => setState(() => isEditing = !isEditing),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/title.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Attendee Information',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(),
                                  ),
                                  readOnly: !isEditing,
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email),
                                    border: OutlineInputBorder(),
                                  ),
                                  readOnly: !isEditing,
                                ),
                                const SizedBox(height: 16),
                                if (isEditing)
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: updateAttendeeDetails,
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
    );
  }
}
