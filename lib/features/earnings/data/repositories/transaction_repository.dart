import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matiz/core/models/api_response.dart';
import 'package:matiz/features/authentication/data/respositories/authentication_repository.dart';
import 'package:matiz/features/earnings/data/models/transaction.dart';

class TransactionRepository {
  final String baseUrl;
  final AuthenticationRepository authenticationRepository;

  TransactionRepository({
    required this.baseUrl,
    required this.authenticationRepository,
  });

  /// **📥 Fetch Transactions**
  Future<ApiResponse<List<Transaction>>> fetchTransactions() async {
    final idToken = await authenticationRepository.getCurrentUserIdToken();
    if (idToken == null) {
      throw Exception('No user is logged in.');
    }

    try {
      // **📡 API Call**
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonResponse['data'];
        final transactions = data.entries
            .where((entry) => entry.key != "message") // Ignore message key
            .map((entry) => Transaction.fromJson(entry.key, entry.value))
            .toList();

        return ApiResponse<List<Transaction>>(
          success: true,
          message: jsonResponse['message'] ?? 'Transactions retrieved',
          data: transactions,
        );
      } else {
        return ApiResponse<List<Transaction>>(
          success: false,
          message: jsonResponse['message'] ?? 'Failed to fetch transactions',
          data: [],
        );
      }
    } catch (e) {
      return ApiResponse<List<Transaction>>(
        success: false,
        message: "🔥 API Call Failed: $e",
        data: [],
      );
    }
  }
}
