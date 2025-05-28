import 'package:intl/intl.dart';

// This class handles all date formatting in our app
class DateFormatter {
  // Format date to requirement: [16 April, 2025]
  static String formatPublishedDate(String publishedAt) {
    try {
      // Parse the date string from API (usually in ISO format)
      final DateTime date = DateTime.parse(publishedAt);
      
      // Format it to the required format: [16 April, 2025]
      final String formattedDate = DateFormat('d MMMM, y').format(date);
      
      // Add square brackets as required
      return '[$formattedDate]';
    } catch (e) {
      // If date parsing fails, return a default format
      return '[Date not available]';
    }
  }
} 