import 'package:elite_events_mobile/Services/Event_Services/event_service.dart';
import 'package:elite_events_mobile/Services/api_service.dart';
import 'package:elite_events_mobile/Models/Services_Models/venue_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VenueService {
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

  Future<List<Venue>> getVenues() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiService.fetchData(
        'venue',
        (json) => Venue.fromJson(json),
        headers: headers,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Venue> getVenueDetails(String venueId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiService.fetchDetails(
        'venue',
        int.parse(venueId),
        (json) => Venue.fromJson(json),
        headers: headers,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bookVenue(String venueId, String eventId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _eventService.fetchEventDetail(eventId);

      if (response.containsKey('error')) {
        throw Exception("Failed to fetch event details: ${response['error']}");
      }

      final eventDetails = response['data']['event'];
      final String eventDate = eventDetails['date'];
      if (eventDate.isEmpty) throw Exception("Event date is missing.");

      await _apiService.putData('venue/$venueId/update-dates', {
        'unavailableDates': [eventDate],
      }, headers: headers);

      await _eventService.updateEvent(eventId, {'venue': venueId});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelBooking(String venueId, String eventId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _eventService.fetchEventDetail(eventId);
      final eventDetails = response['data']['event'];

      if (eventDetails.containsKey('error')) {
        throw Exception("Failed to fetch event details.");
      }

      final String eventDate = eventDetails['date'];
      await _apiService.deleteData(
        'venue/$venueId/delete-date',
        headers: headers,
        body: {'dateToDelete': eventDate},
      );

      await _eventService.updateEvent(eventId, {'venue': null});
    } catch (e) {
      rethrow;
    }
  }
}
