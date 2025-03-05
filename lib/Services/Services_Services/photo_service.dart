import 'package:elite_events_mobile/Models/Services_Models/photo_model.dart';
import 'package:elite_events_mobile/Services/api_service.dart';

class PhotoService {
  final ApiService _apiService = ApiService();

  // Fetch list of photos
  Future<List<Photo>> getPhotos() async {
    return await _apiService.fetchData('photo', (json) => Photo.fromJson(json));
  }
}
