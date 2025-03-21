import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.0.2.2:5000";

  Future<List<T>> fetchData<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final url = Uri.parse('$baseUrl/api/user/service/$endpoint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse == null || !jsonResponse.containsKey("data")) {
        throw Exception("Invalid response format: Missing 'data' key");
      }

      var data = jsonResponse["data"];
      if (data is List) {
        return data.map((json) => fromJson(json)).toList();
      } else {
        throw Exception("Unexpected format: 'data' is not a list");
      }
    } else {
      throw Exception(
        'Error: ${response.statusCode}, Message: ${response.body}',
      );
    }
  }

  Future<T> fetchDetails<T>(
    String endpoint,
    int id,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final url = Uri.parse('$baseUrl/api/services/$endpoint/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception('Failed to load $endpoint details');
    }
  }

  Future<void> postData(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/api/user/service/$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to process request: ${response.body}');
    }
  }
}
