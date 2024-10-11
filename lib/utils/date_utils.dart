import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }
}
