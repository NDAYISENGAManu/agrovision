/// App-wide constants
class AppConstants {
  // App Info
  static const String appName = 'AgroVision';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Smart Agriculture for Rwanda';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String onboardingKey = 'onboarding_completed';
  static const String languageKey = 'app_language';
  static const String themeKey = 'app_theme';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Image
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Cache
  static const int cacheMaxAge = 7; // days
  static const int offlineCacheMaxAge = 30; // days

  // Rwanda Districts
  static const List<String> rwandaDistricts = [
    'Bugesera', 'Burera', 'Gakenke', 'Gasabo', 'Gatsibo',
    'Gicumbi', 'Gisagara', 'Huye', 'Kamonyi', 'Karongi',
    'Kayonza', 'Kicukiro', 'Kirehe', 'Muhanga', 'Musanze',
    'Ngoma', 'Ngororero', 'Nyabihu', 'Nyagatare', 'Nyamagabe',
    'Nyamasheke', 'Nyanza', 'Nyarugenge', 'Nyaruguru', 'Rubavu',
    'Ruhango', 'Rulindo', 'Rusizi', 'Rutsiro', 'Rwamagana',
  ];

  // Crop Types
  static const List<String> cropTypes = [
    'Tomato', 'Potato', 'Beans', 'Maize', 'Rice',
    'Coffee', 'Tea', 'Banana', 'Cassava', 'Sorghum',
    'Wheat', 'Soybean', 'Cabbage', 'Carrot', 'Onion',
    'Pepper', 'Eggplant', 'Peas', 'Groundnut', 'Other',
  ];

  // Market Categories
  static const List<String> marketCategories = [
    'VEGETABLES',
    'FRUITS',
    'GRAINS',
    'CASH_CROPS',
    'LIVESTOCK',
    'DAIRY',
    'OTHER',
  ];

  // Forum Categories
  static const List<String> forumCategories = [
    'PEST_DISEASE',
    'FARMING_TIPS',
    'MARKET_PRICES',
    'WEATHER',
    'EQUIPMENT',
    'GENERAL',
  ];

  // Subscription Tiers
  static const Map<String, Map<String, dynamic>> subscriptionTiers = {
    'FREE': {
      'name': 'Free',
      'price': 0,
      'scansPerMonth': 5,
      'maxFarms': 2,
      'marketplaceFee': 2.0,
    },
    'BASIC': {
      'name': 'Basic',
      'price': 5000,
      'scansPerMonth': 50,
      'maxFarms': 10,
      'marketplaceFee': 1.0,
    },
    'PREMIUM': {
      'name': 'Premium',
      'price': 10000,
      'scansPerMonth': -1, // Unlimited
      'maxFarms': -1, // Unlimited
      'marketplaceFee': 0.0,
    },
  };

  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Something went wrong. Please try again.';
  static const String sessionExpired = 'Your session has expired. Please login again.';
  static const String unknownError = 'An unexpected error occurred';
}
