class ApiConstants {
  // Base URL - Change this to your actual backend URL
  static const String baseUrl = 'http://192.168.1.100:3001/api';
  
  // Endpoints
  static const String auth = '/auth';
  static const String farms = '/farms';
  static const String crops = '/crops';
  static const String diagnosis = '/diagnosis';
  static const String marketplace = '/marketplace';
  static const String weather = '/weather';
  static const String learning = '/learning';
  static const String forum = '/forum';
  static const String notifications = '/notifications';
  
  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

class AppConstants {
  // App Info
  static const String appName = 'AgroVision';
  static const String appVersion = '1.0.0';
  
  // Subscription Tiers
  static const String tierFree = 'FREE';
  static const String tierBasic = 'BASIC';
  static const String tierPremium = 'PREMIUM';
  static const String tierEnterprise = 'ENTERPRISE';
  
  // Free tier limits
  static const int freeAiScansPerMonth = 5;
  static const int freeFarmsLimit = 2;
  static const int freeCropsPerFarm = 5;
  
  // Premium tier limits
  static const int premiumAiScansPerMonth = 50;
  static const int premiumFarmsLimit = 10;
  static const int premiumCropsPerFarm = 50;
  
  // Marketplace commission
  static const double marketplaceCommissionRate = 0.02; // 2%
  
  // Supported Languages
  static const List<String> supportedLanguages = ['en', 'rw', 'sw', 'fr'];
  
  // Rwanda Districts
  static const List<String> districts = [
    'Kigali',
    'Nyarugenge',
    'Gasabo',
    'Kicukiro',
    'Nyanza',
    'Gisagara',
    'Nyaruguru',
    'Huye',
    'Nyamagabe',
    'Ruhango',
    'Muhanga',
    'Kamonyi',
    'Karongi',
    'Rutsiro',
    'Rubavu',
    'Nyabihu',
    'Ngororero',
    'Rusizi',
    'Nyamasheke',
    'Rulindo',
    'Gakenke',
    'Musanze',
    'Burera',
    'Gicumbi',
    'Rwamagana',
    'Nyagatare',
    'Gatsibo',
    'Kayonza',
    'Kirehe',
    'Ngoma',
    'Bugesera',
  ];
  
  // Market Locations
  static const List<String> marketLocations = [
    'KIGALI_KIMISAGARA',
    'KIGALI_KIMIRONKO',
    'MUSANZE',
    'HUYE',
    'RUBAVU',
    'RUSIZI',
    'NYAGATARE',
    'RWAMAGANA',
    'MUHANGA',
    'KARONGI',
  ];
}
