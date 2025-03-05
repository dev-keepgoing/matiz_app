import 'package:matiz/features/earnings/data/models/payout.dart';

class PayoutHistory {
  final List<Payout> recentPayouts;
  final int totalCount;
  final double totalAmount;

  PayoutHistory({
    required this.recentPayouts,
    required this.totalCount,
    required this.totalAmount,
  });

  factory PayoutHistory.fromJson(Map<String, dynamic> json) {
    return PayoutHistory(
      recentPayouts: (json['recentPayouts'] as List)
          .map((item) => Payout.fromJson(item))
          .toList(),
      totalCount: json['allPayoutsSummary']['totalCount'] ?? 0,
      totalAmount: (json['allPayoutsSummary']['totalAmount'] as num).toDouble(),
    );
  }
}
