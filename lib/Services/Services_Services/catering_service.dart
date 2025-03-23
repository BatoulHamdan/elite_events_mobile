import 'package:elite_events_mobile/Models/Services_Models/catering_model.dart';
import 'package:elite_events_mobile/Services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CateringService {
  final ApiService _apiService = ApiService();

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionCookie = prefs.getString('sessionCookie');
    if (sessionCookie == null) {
      throw Exception("Session expired. Please log in again.");
    }
    return {'Content-Type': 'application/json', 'Cookie': sessionCookie};
  }

  // Fetch list of catering services
  Future<List<Catering>> getCaterings() async {
    try {
      final headers = await _getAuthHeaders();
      return await _apiService.fetchData(
        'catering',
        (json) => Catering.fromJson(json),
        headers: headers,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Fetch catering details by ID
  Future<Catering> getCateringDetails(String cateringId) async {
    try {
      final headers = await _getAuthHeaders();
      return await _apiService.fetchDetails(
        'catering',
        int.parse(cateringId),
        (json) => Catering.fromJson(json),
        headers: headers,
      );
    } catch (e) {
      rethrow;
    }
  }
}
