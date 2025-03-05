import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateFormatHelper {
  static void initialize() {
    initializeDateFormatting('es', null);
  }

  /// Formats an ISO 8601 date string into a readable format.
  static String formatDate(String dateStr) {
    if (dateStr.isEmpty) return "FECHA DESCONOCIDA";
    try {
      final DateTime date = DateTime.parse(dateStr);
      return DateFormat('EEEE, d MMMM', 'es').format(date).toUpperCase();
    } catch (e) {
      return "FECHA INVÁLIDA";
    }
  }
}
