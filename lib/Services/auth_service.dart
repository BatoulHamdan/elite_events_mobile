import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:5000";

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

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

      log("Register API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey("userId")) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("userId", data["userId"]);

          return {
            "success": true,
            "message": data["message"] ?? "Registration successful",
            "userId": data["userId"],
          };
        } else {
          return {"error": "Invalid response from server"};
        }
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return {"error": errorData["message"] ?? "Registration failed"};
      }
    } catch (e) {
      log("Error in registerUser: $e");
      return {"error": "Could not register. Please try again later."};
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/api/user/login");

      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "email": email.toLowerCase(),
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      log("Login API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey("userId")) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("userId", data["userId"]);

          return {
            "success": true,
            "message": data["message"] ?? "Login successful",
            "userId": data["userId"],
          };
        } else {
          return {"error": "Invalid response from server"};
        }
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return {"error": errorData["message"] ?? "Login failed"};
      }
    } catch (e) {
      log("Error in loginUser: $e");
      return {"error": "Could not log in. Please try again later."};
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("userId");
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
        await prefs.remove("userId");
        log("User logged out successfully!");
      } else {
        log("Logout failed: ${response.body}");
      }
    } catch (e) {
      log("Error in logoutUser: $e");
    }
  }
}
