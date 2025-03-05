import 'package:elite_events_mobile/Models/Services_Models/venue_model.dart';
import 'package:elite_events_mobile/Services/api_service.dart';

class VenueService {
  final ApiService _apiService = ApiService();

  // Fetch list of venues
  Future<List<Venue>> getVenues() async {
    return await _apiService.fetchData('venue', (json) => Venue.fromJson(json));
  }

  // Fetch venue details by ID
  Future<Venue> getVenueDetails(int venueId) async {
    return await _apiService.fetchDetails(
      'venue',
      venueId,
      (json) => Venue.fromJson(json),
    );
  }
}
