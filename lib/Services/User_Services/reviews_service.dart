import 'dart:convert';
import 'package:http/http.dart' as http;

class ReviewService {
  final String baseUrl = "http://10.0.2.2:5000";

  Future<List<Map<String, dynamic>>> fetchReviews() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/user/reviews'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        List<Map<String, dynamic>> reviewsWithNames =
            jsonData.map((review) {
              return {
                "id": review["_id"],
                "comment": review["comment"],
                "userId": review["userId"]["_id"],
                "firstName": review["userId"]["firstName"] ?? "Unknown",
                "lastName": review["userId"]["lastName"] ?? "Unknown",
              };
            }).toList();

        return reviewsWithNames;
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (error) {
      throw Exception('Error fetching reviews: $error');
    }
  }

  Future<bool> createReview(String userId, String comment) async {
    final url = Uri.parse('$baseUrl/api/user/reviews');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "comment": comment}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
        'Error creating review: ${response.statusCode}, Message: ${response.body}',
      );
    }
  }

  Future<bool> deleteReview(String reviewId) async {
    final url = Uri.parse('$baseUrl/api/user/reviews/$reviewId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        'Error deleting review: ${response.statusCode}, Message: ${response.body}',
      );
    }
  }
}
