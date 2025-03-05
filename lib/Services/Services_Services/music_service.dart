import 'package:elite_events_mobile/Models/Services_Models/music_model.dart';
import 'package:elite_events_mobile/Services/api_service.dart';

class MusicService {
  final ApiService _apiService = ApiService();

  // Fetch list of music
  Future<List<Music>> getMusic() async {
    return await _apiService.fetchData('music', (json) => Music.fromJson(json));
  }

  // Fetch music details by ID
  Future<Music> getMusicDetails(int musicId) async {
    return await _apiService.fetchDetails(
      'music',
      musicId,
      (json) => Music.fromJson(json),
    );
  }
}
