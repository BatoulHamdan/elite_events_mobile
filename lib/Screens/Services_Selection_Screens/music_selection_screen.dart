import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/music_model.dart';
import 'package:elite_events_mobile/Services/Event_Services/event_service.dart';
import 'package:elite_events_mobile/Services/Services_Services/music_service.dart';

class MusicSelectionScreen extends StatefulWidget {
  final String eventId;

  const MusicSelectionScreen({super.key, required this.eventId});

  @override
  MusicSelectionScreenState createState() => MusicSelectionScreenState();
}

class MusicSelectionScreenState extends State<MusicSelectionScreen> {
  final EventService _eventService = EventService();
  final MusicService _musicService = MusicService();
  Map<String, dynamic>? eventData;
  List<Music> musicList = [];
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

      final musicServices = await _musicService.getMusic();
      setState(() {
        eventData = event;
        musicList = musicServices;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _bookMusic(Music music) async {
    if (eventData?['music'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You have already booked music. Cancel it first."),
        ),
      );
      return;
    }

    try {
      await _musicService.bookMusic(music.id.toString(), widget.eventId);
      await _eventService.updateEvent(widget.eventId, {'music': music.id});
      setState(() {
        eventData?['music'] = music.id;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _cancelBooking() async {
    try {
      await _musicService.cancelBooking(eventData!['music'], widget.eventId);
      await _eventService.updateEvent(widget.eventId, {'music': null});
      setState(() {
        eventData!['music'] = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  bool checkAvailability(Music music) {
    if (eventData == null || !eventData!.containsKey('date')) {
      return false;
    }

    DateTime eventDate = DateTime.parse(eventData!['date']);

    return !music.unavailableDates.any(
      (unavailableDate) =>
          unavailableDate.year == eventDate.year &&
          unavailableDate.month == eventDate.month &&
          unavailableDate.day == eventDate.day,
    );
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
                : musicList.isEmpty
                ? const Center(
                  child: Text("No music services found. Pull down to refresh."),
                )
                : RefreshIndicator(
                  onRefresh: _fetchEventData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: musicList.length,
                    itemBuilder: (context, index) {
                      final music = musicList[index];
                      bool isBooked = eventData?['music'] == music.id;
                      bool anotherMusicBooked =
                          eventData?['music'] != null &&
                          eventData?['music'] != music.id;
                      bool isAvailable = checkAvailability(music);

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          title: Text(
                            music.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(music.type),
                              Text(
                                'Price: \$${music.price.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 10),
                              if (!isAvailable)
                                const Text(
                                  "Not available on this date",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              else if (isBooked)
                                ElevatedButton(
                                  onPressed: _cancelBooking,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text("Cancel"),
                                )
                              else if (!anotherMusicBooked)
                                ElevatedButton(
                                  onPressed: () => _bookMusic(music),
                                  child: const Text("Book"),
                                )
                              else
                                const SizedBox(),
                            ],
                          ),
                          leading:
                              music.images.isNotEmpty
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'http://10.0.2.2:5000/api/user/service/images/${music.images[0]}',
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
