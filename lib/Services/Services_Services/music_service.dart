import 'package:elite_events_mobile/Models/Services_Models/music_model.dart';
import 'package:elite_events_mobile/Services/api_service.dart';
import 'package:elite_events_mobile/Services/Event_Services/event_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicService {
  final ApiService _apiService = ApiService();
  final EventService _eventService = EventService();

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionCookie = prefs.getString('sessionCookie');
    if (sessionCookie == null) {
      throw Exception("Session expired. Please log in again.");
    }
    return {'Content-Type': 'application/json', 'Cookie': sessionCookie};
  }

  Future<List<Music>> getMusic() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiService.fetchData(
        'music',
        (json) => Music.fromJson(json),
        headers: headers,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Music> getMusicDetails(String musicId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiService.fetchDetails(
        'music',
        int.parse(musicId),
        (json) => Music.fromJson(json),
        headers: headers,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bookMusic(String musicId, String eventId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _eventService.fetchEventDetail(eventId);

      if (response.containsKey('error')) {
        throw Exception("Failed to fetch event details: ${response['error']}");
      }

      final eventDetails = response['data']['event'];
      final String eventDate = eventDetails['date'];
      if (eventDate.isEmpty) throw Exception("Event date is missing.");

      await _apiService.putData('music/$musicId/update-dates', {
        'unavailableDates': [eventDate],
      }, headers: headers);

      await _eventService.updateEvent(eventId, {'music': musicId});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelBooking(String musicId, String eventId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _eventService.fetchEventDetail(eventId);
      final eventDetails = response['data']['event'];

      if (eventDetails.containsKey('error')) {
        throw Exception("Failed to fetch event details.");
      }

      final String eventDate = eventDetails['date'];
      await _apiService.deleteData(
        'music/$musicId/delete-date',
        headers: headers,
        body: {'dateToDelete': eventDate},
      );

      await _eventService.updateEvent(eventId, {'music': null});
    } catch (e) {
      rethrow;
    }
  }
}
