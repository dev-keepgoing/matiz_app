// lib/services/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  // Use FirebaseAnalytics.instance instead of constructor
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Singleton Pattern for AnalyticsService
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  Future<void> logCheckEarnings({required String userId}) async {
    try {
      await _analytics.logEvent(
        name: 'check_earnings',
        parameters: {
          'screen': 'my_earnings',
          'user_id': userId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      if (kDebugMode) {
        print("Analytics Event Logged: check_earnings");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to log analytics event: $e");
      }
    }
  }

  /// **🛒 Log Click Compra Ahora Event**
  Future<void> logClickCompraAhora({
    required String albumId,
    required String albumTitle,
    required bool isUserLoggedin,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'click_compra_ahora',
        parameters: {
          'album_id': albumId,
          'album_title': albumTitle,
          'user_logged_in': isUserLoggedin.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      if (kDebugMode) {
        print("Analytics Event Logged: click_compra_ahora");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to log analytics event: $e");
      }
    }
  }
}
