import 'package:intl/intl.dart';

class DateFormatter {
  static String formatPublishedDate(String publishedAt) {
    try {
      final DateTime date = DateTime.parse(publishedAt);

      final String formattedDate = DateFormat('d MMMM, y').format(date);

      return '[$formattedDate]';
    } catch (e) {
      return '[Date not available]';
    }
  }
}
