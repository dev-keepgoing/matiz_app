import 'package:http/http.dart' as http;
import 'package:matiz/core/exceptions/not_found.dart';
import 'package:matiz/core/models/api_response.dart';
import 'package:matiz/features/albums/data/models/album_model.dart';
import 'dart:convert';
import 'package:matiz/features/authentication/data/respositories/authentication_repository.dart';

class AlbumRepository {
  final String baseUrl;
  final AuthenticationRepository authenticationRepository;

  AlbumRepository(
      {required this.baseUrl, required this.authenticationRepository});

  Future<ApiResponse<List<Album>>> fetchAlbums(String type,
      [String? subtype]) async {
    // Step 1: Retrieve the ID token from AuthenticationRepository
    final idToken = await authenticationRepository.getCurrentUserIdToken();
    // if (idToken == null) {
    //   throw Exception("User is not authenticated or ID token is unavailable.");
    // }

    // Step 2: Construct the API URL
    final uri = Uri.parse(
        '$baseUrl?type=$type${subtype != null ? '&subtype=$subtype' : ''}');

    // Step 3: Make the API call with the ID token in the headers
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == true) {
        final data = jsonResponse['data'] as Map<String, dynamic>;
        final albums = <Album>[];

        // Parse the nested data (excluding the 'message' field)
        data.forEach((key, value) {
          if (key != 'message') {
            albums.add(Album.fromJson(value as Map<String, dynamic>, key));
          }
        });

        return ApiResponse<List<Album>>(
          success: jsonResponse['success'],
          data: albums,
          message: jsonResponse['data']['message'], // Optional message
        );
      } else {
        throw Exception(
            jsonResponse['error']['message'] ?? 'Failed to fetch albums');
      }
    } else if (response.statusCode == 404) {
      throw NotFoundException('No albums found');
    } else {
      print("API Error: ${response.body}");
      throw Exception('Failed to load albums: ${response.body}');
    }
  }
}
