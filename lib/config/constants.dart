class AppConstants {
  // App Info
  static const String appName = 'OrderMyXerox';
  static const String appTagline = 'Your Reliable Printing Partner';
  static const String appVersion = '1.0.0';

  // API (placeholder — replace with real API later)
  static const String baseUrl = 'https://api.ordermyxerox.com';
  static const int apiTimeout = 30; // seconds

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String onboardingKey = 'onboarding_complete';
  static const String themeKey = 'theme_mode';

  // Pagination
  static const int pageSize = 20;

  // Upload Limits
  static const int maxFileSize = 25 * 1024 * 1024; // 25 MB
  static const List<String> allowedFileTypes = [
    'pdf',
    'jpg',
    'jpeg',
    'png',
    'doc',
    'docx'
  ];

  // Currency
  static const String currency = '₹';
}
