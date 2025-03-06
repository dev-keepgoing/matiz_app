// monthly_earning.dart
class MonthlyEarning {
  final String month;
  final double earnings;
  final String? paidOn;

  const MonthlyEarning(
      {required this.month, required this.earnings, this.paidOn});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyEarning &&
          runtimeType == other.runtimeType &&
          month == other.month &&
          earnings == other.earnings;

  @override
  int get hashCode => month.hashCode ^ earnings.hashCode;
}
