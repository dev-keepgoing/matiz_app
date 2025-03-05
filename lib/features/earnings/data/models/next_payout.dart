class NextPayout {
  final double amount;
  final String date;
  final String updatedAt;
  int tiered = 5;
  int posterAmount = 0;

  NextPayout(
      {required this.amount,
      required this.date,
      required this.updatedAt,
      required this.tiered,
      required this.posterAmount});

  factory NextPayout.fromJson(Map<String, dynamic> json) {
    return NextPayout(
      amount: (json['amount'] as num).toDouble(),
      date: json['date'],
      updatedAt: json['updatedAt'],
      tiered: json['tiered'],
      posterAmount: json['posterAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'date': date,
      'updatedAt': updatedAt,
      'posterAmount': posterAmount,
      'tiered': tiered,
    };
  }
}
