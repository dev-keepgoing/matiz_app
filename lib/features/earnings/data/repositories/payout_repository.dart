import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matiz/core/models/api_response.dart';
import 'package:matiz/features/earnings/data/models/payout_history.dart';
import 'package:matiz/features/authentication/data/respositories/authentication_repository.dart';

class PayoutRepository {
  final String baseUrl;
  final AuthenticationRepository authenticationRepository;

  PayoutRepository(
      {required this.baseUrl, required this.authenticationRepository});

  Future<ApiResponse<PayoutHistory>> fetchPayoutHistory(String userId,
      {int monthsBack = 12}) async {
    final idToken = await authenticationRepository.getCurrentUserIdToken();
    if (idToken == null) {
      throw Exception('No user is logged in.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl?userId=$userId&monthsBack=$monthsBack'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ApiResponse<PayoutHistory>.fromJson(
        jsonResponse,
        (dataJson) => PayoutHistory.fromJson(dataJson),
      );
    } else {
      throw Exception('Failed to fetch payout history: ${response.body}');
    }
  }
}
