import 'package:intl/intl.dart';

/// Helper utilities for the app
class Helpers {
  /// Format currency (RWF)
  static String formatCurrency(double amount, {String currency = 'RWF'}) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(amount)} $currency';
  }

  /// Format date
  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Format date relative (e.g., "2 hours ago")
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }

  /// Format phone number
  static String formatPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.startsWith('+250')) {
      return '+250 ${cleaned.substring(4, 7)} ${cleaned.substring(7, 10)} ${cleaned.substring(10)}';
    }
    return phone;
  }

  /// Get initials from name
  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Parse Rwanda phone to international format
  static String toInternationalPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.startsWith('0')) {
      return '+250${cleaned.substring(1)}';
    }
    if (cleaned.startsWith('250')) {
      return '+$cleaned';
    }
    if (!cleaned.startsWith('+')) {
      return '+250$cleaned';
    }
    return phone;
  }

  /// Calculate percentage
  static double calculatePercentage(double value, double total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  /// Get crop status color
  static int getCropStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PLANTED':
        return 0xFF2196F3; // Blue
      case 'GROWING':
        return 0xFF4CAF50; // Green
      case 'FLOWERING':
        return 0xFFFF9800; // Orange
      case 'HARVESTING':
        return 0xFF9C27B0; // Purple
      case 'HARVESTED':
        return 0xFF795548; // Brown
      default:
        return 0xFF9E9E9E; // Grey
    }
  }

  /// Get disease severity color
  static int getDiseaseSeverityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'LOW':
        return 0xFF4CAF50; // Green
      case 'MEDIUM':
        return 0xFFFF9800; // Orange
      case 'HIGH':
        return 0xFFF44336; // Red
      default:
        return 0xFF9E9E9E; // Grey
    }
  }

  /// Generate greeting based on time
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
