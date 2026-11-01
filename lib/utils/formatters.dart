import 'package:intl/intl.dart';

class Formatters {
  /// Format price with ₹ symbol → ₹25.00
  static String price(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  /// Format date → 20 Sep 2026
  static String date(DateTime dt) {
    return DateFormat('dd MMM yyyy').format(dt);
  }

  /// Format date + time → 20 Sep 2026, 2:30 PM
  static String dateTime(DateTime dt) {
    return DateFormat('dd MMM yyyy, h:mm a').format(dt);
  }

  /// Format phone → +91 98765 43210
  static String phone(String number) {
    if (number.length == 10) {
      return '+91 ${number.substring(0, 5)} ${number.substring(5)}';
    }
    return number;
  }
}
