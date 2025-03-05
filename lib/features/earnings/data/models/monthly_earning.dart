// monthly_earning.dart
class MonthlyEarning {
  final String month;
  final double earnings;

  const MonthlyEarning({
    required this.month,
    required this.earnings,
  });

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
