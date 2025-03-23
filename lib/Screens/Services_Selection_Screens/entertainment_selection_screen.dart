import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/entertainment_model.dart';
import 'package:elite_events_mobile/Services/Services_Services/entertainment_service.dart';
import 'package:elite_events_mobile/Services/Event_Services/event_service.dart';

class EntertainmentSelectionScreen extends StatefulWidget {
  final String eventId;

  const EntertainmentSelectionScreen({super.key, required this.eventId});

  @override
  EntertainmentSelectionScreenState createState() =>
      EntertainmentSelectionScreenState();
}

class EntertainmentSelectionScreenState
    extends State<EntertainmentSelectionScreen> {
  final EventService _eventService = EventService();
  final EntertainmentService _entertainmentService = EntertainmentService();
  Map<String, dynamic>? eventData;
  List<Entertainment> entertainmentList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchEventData();
  }

  Future<void> _fetchEventData() async {
    try {
      final response = await _eventService.fetchEventDetail(widget.eventId);
      final event = response['data']['event'];

      if (event.containsKey('error')) {
        throw Exception(event['error']);
      }

      final entertainmentServices =
          await _entertainmentService.getEntertainments();
      setState(() {
        eventData = event;
        entertainmentList = entertainmentServices;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _bookEntertainment(Entertainment entertainment) async {
    if (eventData?['entertainment'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "You have already booked entertainment. Cancel it first.",
          ),
        ),
      );
      return;
    }

    try {
      await _eventService.updateEvent(widget.eventId, {
        'entertainment': entertainment.id,
      });
      setState(() {
        eventData?['entertainment'] = entertainment.id;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _cancelEntertainment() async {
    try {
      await _eventService.updateEvent(widget.eventId, {'entertainment': null});
      setState(() {
        eventData!['entertainment'] = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Entertainment Selection")),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/title.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                : entertainmentList.isEmpty
                ? const Center(
                  child: Text(
                    "No entertainment services found. Pull down to refresh.",
                  ),
                )
                : RefreshIndicator(
                  onRefresh: _fetchEventData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: entertainmentList.length,
                    itemBuilder: (context, index) {
                      final entertainment = entertainmentList[index];
                      bool isBooked =
                          eventData?['entertainment'] == entertainment.id;
                      bool anotherEntertainmentBooked =
                          eventData?['entertainment'] != null &&
                          eventData?['entertainment'] != entertainment.id;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          title: Text(
                            entertainment.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price: \$${entertainment.price.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 10),
                              if (isBooked)
                                ElevatedButton(
                                  onPressed: _cancelEntertainment,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text("Cancel"),
                                )
                              else if (!anotherEntertainmentBooked)
                                ElevatedButton(
                                  onPressed:
                                      () => _bookEntertainment(entertainment),
                                  child: const Text("Book"),
                                )
                              else
                                const SizedBox(),
                            ],
                          ),
                          leading:
                              entertainment.images.isNotEmpty
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'http://10.0.2.2:5000/api/user/service/images/${entertainment.images[0]}',
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                    ),
                                  )
                                  : const Icon(Icons.music_note, size: 60),
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
