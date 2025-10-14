class UsageLimitException implements Exception {
  final String message;

  UsageLimitException(this.message);

  @override
  String toString() => message;
}

class LimitReachedException extends UsageLimitException {
  final String scanType;
  final int currentCount;
  final int limit;
  final DateTime? resetDate;

  LimitReachedException({
    required this.scanType,
    required this.currentCount,
    required this.limit,
    this.resetDate,
  }) : super(_buildMessage(scanType, resetDate));

  static String _buildMessage(String scanType, DateTime? resetDate) {
    final scanName = _getScanTypeName(scanType);
    if (resetDate != null) {
      final resetDateStr = _formatResetDate(resetDate);
      return 'You\'ve reached your monthly limit for $scanName. Limits reset on $resetDateStr.';
    }
    return 'You\'ve reached your monthly limit for $scanName.';
  }

  static String _getScanTypeName(String scanType) {
    switch (scanType) {
      case 'text':
        return 'text analysis';
      case 'email':
        return 'email analysis';
      case 'link':
        return 'link analysis';
      case 'qr_url':
        return 'QR URL analysis';
      case 'qr_wifi':
        return 'QR WiFi analysis';
      default:
        return scanType;
    }
  }

  static String _formatResetDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class UserNotAuthenticatedException extends UsageLimitException {
  UserNotAuthenticatedException()
      : super('User not authenticated. Please sign in to continue.');
}

class PremiumRequiredException extends UsageLimitException {
  final String feature;

  PremiumRequiredException(this.feature)
      : super('This feature requires a Premium subscription: $feature');
}

class UsageLimitDatabaseException extends UsageLimitException {
  final dynamic originalError;

  UsageLimitDatabaseException(this.originalError)
      : super('Database error: ${originalError.toString()}');
}
