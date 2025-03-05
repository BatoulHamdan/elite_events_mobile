import 'package:elite_events_mobile/Models/Services_Models/Offer_model.dart';
import 'package:elite_events_mobile/Services/api_service.dart';

class PhotoService {
  final ApiService _apiService = ApiService();

  // Fetch list of photos
  Future<List<Offer>> getOffers() async {
    return await _apiService.fetchData('offer', (json) => Offer.fromJson(json));
  }
}
