import 'package:elite_events_mobile/Models/Services_Models/entertainment_model.dart';
import 'package:elite_events_mobile/Services/api_service.dart';

class EntertainmentService {
  final ApiService _apiService = ApiService();

  // Fetch list of entertainment
  Future<List<Entertainment>> getEntertainments() async {
    return await _apiService.fetchData(
      'entertainment',
      (json) => Entertainment.fromJson(json),
    );
  }

  // Fetch entertainment details by ID
  Future<Entertainment> getEntertainmentDetails(int entertainmentId) async {
    return await _apiService.fetchDetails(
      'entertainment',
      entertainmentId,
      (json) => Entertainment.fromJson(json),
    );
  }
}
