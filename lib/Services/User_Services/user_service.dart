import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String baseUrl = 'http://10.0.2.2:5000';
  final http.Client client = http.Client();

  Future<Map<String, dynamic>> fetchUserDashboard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionCookie = prefs.getString('sessionCookie');

      if (sessionCookie == null) {
        return {'error': "Session expired. Please log in again."};
      }

      final response = await client.get(
        Uri.parse('$baseUrl/api/user/userDashboard'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        return {'error': errorData['message'] ?? 'Something went wrong'};
      }
    } catch (e) {
      log("Dashboard Error: $e");
      return {'error': "An error occurred: $e"};
    }
  }
}
