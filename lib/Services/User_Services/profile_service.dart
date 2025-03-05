import 'package:elite_events_mobile/Models/user_model.dart';
import 'package:elite_events_mobile/Services/user_service.dart';

class ProfileService {
  // Fetch user details by ID
  Future<User?> getUserById(String userId) async {
    try {
      return await UserService.fetchUserById(userId);
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
