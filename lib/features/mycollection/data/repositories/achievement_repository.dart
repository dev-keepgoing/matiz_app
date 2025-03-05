import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matiz/core/models/api_response.dart';
import 'package:matiz/features/authentication/data/respositories/authentication_repository.dart';
import 'package:matiz/features/mycollection/data/models/achievement_model.dart';

class AchievementRepository {
  final String baseUrl;
  final AuthenticationRepository authenticationRepository;

  AchievementRepository({
    required this.baseUrl,
    required this.authenticationRepository,
  });

  Future<ApiResponse<AchievementResponse>> fetchAchievements(
      String userId, String userType, int season) async {
    final idToken = await authenticationRepository.getCurrentUserIdToken();
    if (idToken == null) {
      throw Exception('No user is logged in.');
    }

    final response = await http.get(
      Uri.parse(
          '$baseUrl?userId=$userId&userType=$userType&season=$season&rewardId=-OIN2C5uj8SEG9jhOdAk'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    print("status code ${response.statusCode}");

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ApiResponse<AchievementResponse>.fromJson(
        jsonResponse,
        (dataJson) => AchievementResponse.fromJson(dataJson),
      );
    } else {
      throw Exception('Failed to fetch achievements: ${response.body}');
    }
  }
}
