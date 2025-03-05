import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matiz/core/models/api_response.dart';
import 'package:matiz/features/authentication/data/respositories/authentication_repository.dart';
import 'package:matiz/features/mycollection/data/models/collection_model.dart';

class CollectionRepository {
  final String baseUrl;
  final AuthenticationRepository authenticationRepository;

  CollectionRepository({
    required this.baseUrl,
    required this.authenticationRepository,
  });

  Future<ApiResponse<List<CollectionItem>>> fetchUserCollection() async {
    final idToken = await authenticationRepository.getCurrentUserIdToken();
    if (idToken == null) {
      throw Exception('No user is logged in.');
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final List<CollectionItem> items = [];
      final data = jsonResponse['data'] as Map<String, dynamic>;

      data.forEach((merchId, merchJson) {
        if (merchId != 'message') {
          items.add(CollectionItem.fromJson(merchId, merchJson));
        }
      });

      return ApiResponse<List<CollectionItem>>(
        success: jsonResponse['success'],
        data: items,
      );
    } else {
      throw Exception('Failed to fetch user collection: ${response.body}');
    }
  }
}
