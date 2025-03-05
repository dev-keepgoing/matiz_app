import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:matiz/core/models/api_response.dart';
import 'package:matiz/features/authentication/data/respositories/authentication_repository.dart';

class MerchValidationRepository {
  final String baseUrl;
  final AuthenticationRepository authenticationRepository;

  MerchValidationRepository({
    required this.baseUrl,
    required this.authenticationRepository,
  });

  /// **📤 Validate Poster (Upload Image + Code)**
  Future<ApiResponse<Map<String, dynamic>>> validatePoster({
    required File imageFile,
    required String merchId,
    required String validationCode,
    required String artistId,
  }) async {
    final idToken = await authenticationRepository.getCurrentUserIdToken();
    if (idToken == null) {
      throw Exception('No user is logged in.');
    }

    try {
      // **🔥 Convert Image to Base64**
      final bytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(bytes);

      // **✅ Construct API Request**
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "artistId": artistId,
          "merchId": merchId,
          "validationCode": validationCode,
          "imageBase64": base64Image, // 🔥 Send as Base64
        }),
      );

      // **📡 Debug API Response**
      print("📡 Response Status Code: ${response.statusCode}");
      print("📡 Response Body: ${response.body}");

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        return ApiResponse<Map<String, dynamic>>.fromJson(
          jsonResponse,
          (data) => data,
        );
      } else {
        return ApiResponse<Map<String, dynamic>>(
          success: false,
          message: jsonResponse['message'] ?? 'Unknown error',
          data: {},
        );
      }
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: "🔥 API Call Failed: $e",
        data: {},
      );
    }
  }
}
