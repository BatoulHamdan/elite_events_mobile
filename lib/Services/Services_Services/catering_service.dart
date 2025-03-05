import 'package:elite_events_mobile/Models/Services_Models/catering_model.dart';
import 'package:elite_events_mobile/Services/api_service.dart';

class CateringService {
  final ApiService _apiService = ApiService();

  // Fetch list of catering
  Future<List<Catering>> getCaterings() async {
    return await _apiService.fetchData(
      'catering',
      (json) => Catering.fromJson(json),
    );
  }

  // Fetch catering details by ID
  Future<Catering> getcateringDetails(int cateringId) async {
    return await _apiService.fetchDetails(
      'catering',
      cateringId,
      (json) => Catering.fromJson(json),
    );
  }
}
