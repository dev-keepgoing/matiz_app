import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matiz/core/models/api_response.dart';
import 'package:matiz/features/authentication/data/respositories/authentication_repository.dart';
import 'package:matiz/features/earnings/data/models/fact.dart';

class FactRepository {
  final String baseUrl;
  final AuthenticationRepository authenticationRepository;

  FactRepository({
    required this.baseUrl,
    required this.authenticationRepository,
  });

  Future<ApiResponse<List<Fact>>> fetchFacts() async {
    // Get the authentication token
    final idToken = await authenticationRepository.getCurrentUserIdToken();
    if (idToken == null) {
      throw Exception('No user is logged in.');
    }

    // Make the HTTP GET request
    final response = await http.get(
      Uri.parse('$baseUrl?live=true'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final Map<String, dynamic> factsData = jsonResponse['data'];

      // Convert response data to a list of Fact objects
      List<Fact> facts = factsData.entries
          .where((entry) => entry.key != "message") // Exclude non-fact keys
          .map((entry) => Fact.fromJson(entry.key, entry.value))
          .toList();

      return ApiResponse<List<Fact>>(
        success: true,
        message: jsonResponse['message'] ?? 'Facts retrieved successfully.',
        data: facts,
      );
    } else {
      throw Exception('Failed to fetch facts: ${response.body}');
    }
  }
}
