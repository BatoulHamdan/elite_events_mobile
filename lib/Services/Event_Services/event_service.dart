import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventService {
  final String baseUrl = 'http://10.0.2.2:5000';
  final http.Client client = http.Client();

  // Fetch the list of events for the logged-in user
  Future<Map<String, dynamic>> fetchUserEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionCookie = prefs.getString('sessionCookie');

      if (sessionCookie == null) {
        return {'error': "Session expired. Please log in again."};
      }

      final response = await client.get(
        Uri.parse('$baseUrl/api/user/event'),
        headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        return {'error': errorData['message'] ?? 'Something went wrong'};
      }
    } catch (e) {
      log("Fetch Events Error: $e");
      return {'error': "An error occurred: $e"};
    }
  }

  // Fetch the details of a specific event
  Future<Map<String, dynamic>> fetchEventDetail(String eventId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionCookie = prefs.getString('sessionCookie');

      if (sessionCookie == null) {
        return {'error': "Session expired. Please log in again."};
      }

      final response = await client.get(
        Uri.parse('$baseUrl/api/user/event/$eventId'),
        headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        return {'error': errorData['message'] ?? 'Something went wrong'};
      }
    } catch (e) {
      log("Fetch Event Detail Error: $e");
      return {'error': "An error occurred: $e"};
    }
  }

  // Add new event
  Future<Map<String, dynamic>> addEvent(Map<String, dynamic> eventData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionCookie = prefs.getString('sessionCookie');

      if (sessionCookie == null) {
        return {'error': "Session expired. Please log in again."};
      }

      final response = await client.post(
        Uri.parse('$baseUrl/api/user/event/create'),
        headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
        body: jsonEncode(eventData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Failed to add event'};
      }
    } catch (e) {
      log("Error adding event: $e");
      return {'error': "An error occurred: $e"};
    }
  }
}
