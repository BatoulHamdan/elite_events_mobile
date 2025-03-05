import 'dart:convert';
import 'package:elite_events_mobile/Models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = "http://10.0.2.2:5000";

  static Future<User> fetchUserById(String userId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/user/$userId"));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return User.fromJson(jsonData);
      } else {
        throw Exception("Failed to load user: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching user: $e");
    }
  }

  static Future<dynamic> postData(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/$endpoint"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to send data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error sending data: $e");
    }
  }
}
