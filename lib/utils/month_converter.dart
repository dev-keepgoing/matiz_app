// utils/month_converter.dart
class MonthConverter {
  static const Map<String, String> _monthMap = {
    '01': 'JAN',
    '02': 'FEB',
    '03': 'MAR',
    '04': 'APR',
    '05': 'MAY',
    '06': 'JUN',
    '07': 'JUL',
    '08': 'AUG',
    '09': 'SEP',
    '10': 'OCT',
    '11': 'NOV',
    '12': 'DEC',
  };

  /// Converts a numeric month (MM) to its short name (e.g., "01" -> "JAN").
  static String convert(String monthNumber) {
    return _monthMap[monthNumber] ?? monthNumber;
  }
}
