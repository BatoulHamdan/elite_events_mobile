import 'package:elite_events_mobile/Models/user_model.dart';
import 'package:elite_events_mobile/Services/user_service.dart';

class ProfileService {
  static Future<User> getProfile() async {
    try {
      var data = await UserService.fetchData("profile");
      return User.fromJson(data);
    } catch (e) {
      throw Exception("Error fetching profile: $e");
    }
  }
}
