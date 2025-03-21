import 'dart:convert';
import 'dart:developer';
import 'package:elite_events_mobile/Models/attendee_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AttendeeService {
  final String baseUrl = 'http://10.0.2.2:5000/api/user/';
  final http.Client client = http.Client();

  // Add an attendee to an event
  Future<Map<String, dynamic>> addAttendee(
    String eventId,
    Attendee attendee,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionCookie = prefs.getString('sessionCookie');

      if (sessionCookie == null) {
        return {'error': "Session expired. Please log in again."};
      }

      final response = await client.post(
        Uri.parse('$baseUrl/event/$eventId/attendees'),
        headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
        body: json.encode(attendee.toJson()),
      );

      final responseBody = json.decode(response.body);
      if (response.statusCode == 201) {
        return {
          'status': 'success',
          'message': 'Attendee added successfully',
          'data': responseBody,
        };
      } else {
        return {'error': responseBody['message'] ?? 'Failed to add attendee'};
      }
    } catch (error) {
      log("Error adding attendee: $error");
      return {'error': "An error occurred: $error"};
    }
  }

  // Get all attendees for an event
  Future<Map<String, dynamic>> getAttendees(String eventId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionCookie = prefs.getString('sessionCookie');

      if (sessionCookie == null) {
        return {'error': "Session expired. Please log in again."};
      }

      final response = await client.get(
        Uri.parse('$baseUrl/event/$eventId/attendees'),
        headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to load attendees'};
      }
    } catch (error) {
      log("Error loading attendees: $error");
      return {'error': "An error occurred: $error"};
    }
  }

  // Get a single attendee
  Future<Map<String, dynamic>> getAttendee(
    String eventId,
    String attendeeId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionCookie = prefs.getString('sessionCookie');

      if (sessionCookie == null) {
        return {'error': "Session expired. Please log in again."};
      }

      final response = await client.get(
        Uri.parse('$baseUrl/event/$eventId/attendees/$attendeeId'),
        headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to load attendee'};
      }
    } catch (error) {
      log("Error loading attendee: $error");
      return {'error': "An error occurred: $error"};
    }
  }

  // Update attendee details
  Future<Map<String, dynamic>> updateAttendee(
    String eventId,
    String attendeeId,
    Attendee updatedAttendee,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionCookie = prefs.getString('sessionCookie');

      if (sessionCookie == null) {
        return {'error': "Session expired. Please log in again."};
      }

      final response = await client.put(
        Uri.parse('$baseUrl/event/$eventId/attendees/$attendeeId'),
        headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
        body: json.encode(updatedAttendee.toJson()),
      );

      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return {
          'status': 'success',
          'message': 'Attendee updated successfully',
          'data': responseBody,
        };
      } else {
        return {
          'error': responseBody['message'] ?? 'Failed to update attendee',
        };
      }
    } catch (error) {
      log("Error updating attendee: $error");
      return {'error': "An error occurred: $error"};
    }
  }

  // Delete an attendee
  Future<Map<String, dynamic>> deleteAttendee(String attendeeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionCookie = prefs.getString('sessionCookie');

      if (sessionCookie == null) {
        return {'error': "Session expired. Please log in again."};
      }

      final response = await client.delete(
        Uri.parse('$baseUrl/event/attendees/$attendeeId'),
        headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
      );

      if (response.statusCode == 200) {
        return {
          'status': 'success',
          'message': 'Attendee deleted successfully',
        };
      } else {
        return {'error': 'Failed to delete attendee'};
      }
    } catch (error) {
      log("Error deleting attendee: $error");
      return {'error': "An error occurred: $error"};
    }
  }

  // Send invitations to all attendees
  Future<Map<String, dynamic>> sendInvitations(String eventId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionCookie = prefs.getString('sessionCookie');

      if (sessionCookie == null) {
        return {'error': "Session expired. Please log in again."};
      }

      final response = await client.post(
        Uri.parse('$baseUrl/event/$eventId/invitations'),
        headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
      );

      if (response.statusCode == 200) {
        return {
          'status': 'success',
          'message': 'Invitations sent successfully',
        };
      } else {
        return {'error': 'Failed to send invitations'};
      }
    } catch (error) {
      log("Error sending invitations: $error");
      return {'error': "An error occurred: $error"};
    }
  }
}
