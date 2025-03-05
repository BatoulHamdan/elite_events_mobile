import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:5000";

  Future<Map<String, dynamic>> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/api/user/register');

      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "firstName": firstName,
              "lastName": lastName,
              "email": email,
              "password": password,
              "confirm_password": confirmPassword,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {
          "success": true,
          "message": data['message'] ?? 'Registration successful',
        };
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return {"error": errorData['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      log("Error in registerUser: $e");
      return {"error": "Could not register. Please try again later."};
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/user/login');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract sessionId from the cookie header
        final sessionId = response.headers['set-cookie']
            ?.split(';')
            .firstWhere(
              (cookie) => cookie.startsWith("sessionId="),
              orElse: () => "",
            )
            .replaceFirst("sessionId=", "");

        if (sessionId != null && sessionId.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("sessionId", sessionId);
          // Save userId in SharedPreferences
          await prefs.setString("userId", data["userId"].toString());
        }

        return {
          "status": "success",
          "message": data["message"],
          "userId": data["userId"],
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          "status": "error",
          "message": errorData["message"] ?? "Login failed!",
        };
      }
    } catch (e) {
      log("Error in loginUser: $e");
      return {
        "status": "error",
        "message": "An error occurred. Please try again later.",
      };
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("sessionId");
  }

  Future<void> logoutUser() async {
    try {
      final url = Uri.parse('$baseUrl/api/user/logout');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString("sessionId");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Cookie": "sessionId=$sessionId",
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove("sessionId");
        log("User logged out successfully!");
      } else {
        log("Logout failed: ${response.body}");
      }
    } catch (e) {
      log("Error in logoutUser: $e");
    }
  }
}
