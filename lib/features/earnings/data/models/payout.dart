class Payout {
  final double amount;
  final String day;
  final String month;
  final String paidOn;
  final String payoutId;

  Payout({
    required this.amount,
    required this.day,
    required this.month,
    required this.paidOn,
    required this.payoutId,
  });

  factory Payout.fromJson(Map<String, dynamic> json) {
    return Payout(
      amount: (json['amount'] as num).toDouble(),
      day: json['day'] ?? '',
      month: json['month'] ?? '',
      paidOn: json['paidOn'] ?? '',
      payoutId: json['payoutId'] ?? '',
    );
  }
}
