import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/decoration_model.dart';
import 'package:elite_events_mobile/Services/Services_Services/decoration_service.dart';
import 'package:elite_events_mobile/Services/Event_Services/event_service.dart';

class DecorationSelectionScreen extends StatefulWidget {
  final String eventId;

  const DecorationSelectionScreen({super.key, required this.eventId});

  @override
  DecorationSelectionScreenState createState() =>
      DecorationSelectionScreenState();
}

class DecorationSelectionScreenState extends State<DecorationSelectionScreen> {
  final EventService _eventService = EventService();
  final DecorationService _decorationService = DecorationService();
  Map<String, dynamic>? eventData;
  List<Decorationn> decorationList = [];
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

      final decorationServices = await _decorationService.getDecorations();
      setState(() {
        eventData = event;
        decorationList = decorationServices;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _bookDecoration(Decorationn decoration) async {
    if (eventData?['decoration'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "You have already booked a decoration. Cancel it first.",
          ),
        ),
      );
      return;
    }

    try {
      await _eventService.updateEvent(widget.eventId, {
        'decoration': decoration.id,
      });
      setState(() {
        eventData?['decoration'] = decoration.id;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _cancelDecoration() async {
    try {
      await _eventService.updateEvent(widget.eventId, {'decoration': null});
      setState(() {
        eventData!['decoration'] = null;
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
      appBar: AppBar(title: Text(eventData?['name'] ?? "Music Selection")),
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
                : decorationList.isEmpty
                ? const Center(
                  child: Text(
                    "No decoration services found. Pull down to refresh.",
                  ),
                )
                : RefreshIndicator(
                  onRefresh: _fetchEventData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: decorationList.length,
                    itemBuilder: (context, index) {
                      final decoration = decorationList[index];
                      bool isBooked = eventData?['decoration'] == decoration.id;
                      bool anotherDecorationBooked =
                          eventData?['decoration'] != null &&
                          eventData?['decoration'] != decoration.id;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          title: Text(
                            decoration.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Type: ${decoration.type}'),
                              Text(
                                'Price: \$${decoration.price.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 10),
                              if (isBooked)
                                ElevatedButton(
                                  onPressed: _cancelDecoration,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text("Cancel"),
                                )
                              else if (!anotherDecorationBooked)
                                ElevatedButton(
                                  onPressed: () => _bookDecoration(decoration),
                                  child: const Text("Book"),
                                )
                              else
                                const SizedBox(),
                            ],
                          ),
                          leading:
                              decoration.images.isNotEmpty
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'http://10.0.2.2:5000/api/user/service/images/${decoration.images[0]}',
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                    ),
                                  )
                                  : const Icon(Icons.light, size: 60),
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
