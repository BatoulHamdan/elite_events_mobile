import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/catering_model.dart';
import 'package:elite_events_mobile/Services/Event_Services/event_service.dart';
import 'package:elite_events_mobile/Services/Services_Services/catering_service.dart';

class CateringSelectionScreen extends StatefulWidget {
  final String eventId;

  const CateringSelectionScreen({super.key, required this.eventId});

  @override
  CateringSelectionScreenState createState() => CateringSelectionScreenState();
}

class CateringSelectionScreenState extends State<CateringSelectionScreen> {
  final EventService _eventService = EventService();
  final CateringService _cateringService = CateringService();
  Map<String, dynamic>? eventData;
  List<Catering> cateringList = [];
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

      final cateringServices = await _cateringService.getCaterings();
      setState(() {
        eventData = event;
        cateringList = cateringServices;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _bookCatering(Catering catering) async {
    if (eventData?['catering'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You have already booked catering. Cancel it first."),
        ),
      );
      return;
    }

    try {
      await _eventService.updateEvent(widget.eventId, {
        'catering': catering.id,
      });
      setState(() {
        eventData?['catering'] = catering.id;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _cancelCatering() async {
    try {
      await _eventService.updateEvent(widget.eventId, {'catering': null});
      setState(() {
        eventData!['catering'] = null;
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
      appBar: AppBar(title: Text(eventData?['name'] ?? "Catering Selection")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : cateringList.isEmpty
              ? const Center(
                child: Text(
                  "No catering services found. Pull down to refresh.",
                ),
              )
              : RefreshIndicator(
                onRefresh: _fetchEventData,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: cateringList.length,
                  itemBuilder: (context, index) {
                    final catering = cateringList[index];
                    bool isBooked = eventData?['catering'] == catering.id;
                    bool anotherCateringBooked =
                        eventData?['catering'] != null &&
                        eventData?['catering'] != catering.id;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        title: Text(
                          catering.restaurantName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Food Menu: ${catering.foodMenu.length} items',
                            ),
                            Text(
                              'Drink Menu: ${catering.drinkMenu.length} items',
                            ),
                            Text(
                              'Dessert Menu: ${catering.dessertMenu.length} items',
                            ),
                            const SizedBox(height: 10),
                            if (isBooked)
                              ElevatedButton(
                                onPressed: _cancelCatering,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text("Cancel"),
                              )
                            else if (!anotherCateringBooked)
                              ElevatedButton(
                                onPressed: () => _bookCatering(catering),
                                child: const Text("Book"),
                              )
                            else
                              const SizedBox(),
                          ],
                        ),
                        leading:
                            catering.images.isNotEmpty
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    'http://10.0.2.2:5000/api/user/service/images/${catering.images[0]}',
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  ),
                                )
                                : const Icon(Icons.restaurant, size: 60),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
