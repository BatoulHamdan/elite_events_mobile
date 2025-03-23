import 'package:elite_events_mobile/Models/Services_Models/decoration_model.dart';
import 'package:elite_events_mobile/Services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DecorationService {
  final ApiService _apiService = ApiService();

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionCookie = prefs.getString('sessionCookie');
    if (sessionCookie == null) {
      throw Exception("Session expired. Please log in again.");
    }
    return {'Content-Type': 'application/json', 'Cookie': sessionCookie};
  }

  // Fetch list of decorations
  Future<List<Decorationn>> getDecorations() async {
    try {
      final headers = await _getAuthHeaders();
      return await _apiService.fetchData(
        'decorations',
        (json) => Decorationn.fromJson(json),
        headers: headers,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Fetch decoration details by ID
  Future<Decorationn> getDecorationDetails(String decorationId) async {
    try {
      final headers = await _getAuthHeaders();
      return await _apiService.fetchDetails(
        'decorations',
        int.parse(decorationId),
        (json) => Decorationn.fromJson(json),
        headers: headers,
      );
    } catch (e) {
      rethrow;
    }
  }
}
