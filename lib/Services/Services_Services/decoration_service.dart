import 'package:elite_events_mobile/Models/Services_Models/decoration_model.dart';
import 'package:elite_events_mobile/Services/api_service.dart';

class DecorationService {
  final ApiService _apiService = ApiService();

  // Fetch list of decoration
  Future<List<Decorationn>> getDecorations() async {
    return await _apiService.fetchData(
      'decorations',
      (json) => Decorationn.fromJson(json),
    );
  }

  // Fetch decoration details by ID
  Future<Decorationn> getDecorationDetails(int decorationId) async {
    return await _apiService.fetchDetails(
      'decoration',
      decorationId,
      (json) => Decorationn.fromJson(json),
    );
  }
}
