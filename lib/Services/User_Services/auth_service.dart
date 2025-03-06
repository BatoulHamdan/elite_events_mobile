import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:5000';
  final http.Client client = http.Client();

  Future<Map<String, dynamic>> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/user/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );

      log("Register Response Status: ${response.statusCode}");
      log("Register Response Headers: ${response.headers}");
      log("Register Response Body: ${response.body}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Extract session cookie from response headers
        String? rawCookie = response.headers['set-cookie'];
        if (rawCookie != null) {
          RegExp regex = RegExp(r'connect\.sid=([^;]+)');
          Match? match = regex.firstMatch(rawCookie);

          if (match != null) {
            String sessionCookie = 'connect.sid=${match.group(1)}';
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('sessionCookie', sessionCookie);
            log("Session cookie saved: $sessionCookie");
          } else {
            log("connect.sid not found in cookie!");
          }
        } else {
          log("No cookie received!");
        }
      }

      return responseData;
    } catch (e) {
      log("Registration Error: $e");
      return {'success': false, 'error': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      String? rawCookie = response.headers['set-cookie'];
      if (rawCookie != null) {
        RegExp regex = RegExp(r'connect\.sid=([^;]+)');
        Match? match = regex.firstMatch(rawCookie);

        if (match != null) {
          String sessionCookie = 'connect.sid=${match.group(1)}';
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('sessionCookie', sessionCookie);
        } else {
          log("connect.sid not found in cookie!");
        }
      } else {
        log("No cookie received!");
      }

      final responseData = jsonDecode(response.body);

      return responseData;
    } catch (e) {
      log("Login Error: $e");
      return {'success': false, 'error': 'Something went wrong'};
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionCookie = prefs.getString('sessionCookie');

      if (sessionCookie == null) {
        return false;
      }

      final response = await client.get(
        Uri.parse('$baseUrl/api/user/getUserId'),
        headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
      );

      return response.statusCode == 200;
    } catch (e) {
      log("Auth Check Error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    log("Logging out user...");

    try {
      await client.post(Uri.parse('$baseUrl/api/user/logout'));
    } catch (error) {
      log("Logout error: $error");
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionId');
    log("Session ID removed.");
  }
}
