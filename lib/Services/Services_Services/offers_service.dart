import 'package:elite_events_mobile/Models/Services_Models/Offer_model.dart';
import 'package:elite_events_mobile/Services/api_service.dart';

class OffersService {
  final ApiService _apiService = ApiService();

  // Fetch list of offers
  Future<List<Offer>> getOffers() async {
    return await _apiService.fetchData(
      'offers',
      (json) => Offer.fromJson(json),
    );
  }
}
