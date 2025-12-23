# 📱 AgroVision Mobile App Documentation

## Overview

The AgroVision mobile app is a cross-platform Flutter application that provides farmers, buyers, and agricultural experts with powerful tools for crop management, disease diagnosis, marketplace access, and community engagement.

---

## 📋 Table of Contents

- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Features](#features)
- [State Management](#state-management)
- [API Integration](#api-integration)
- [Offline Mode](#offline-mode)
- [Testing](#testing)
- [Building](#building)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)

---

## 🏗️ Architecture

### Design Pattern

The app follows **Clean Architecture** principles with clear separation of concerns:

```
Presentation Layer (UI)
    ↓
Application Layer (State Management)
    ↓
Domain Layer (Business Logic)
    ↓
Data Layer (API & Storage)
```

### Key Architectural Decisions

1. **Feature-First Structure**: Organized by features rather than layers
2. **Riverpod for State**: Type-safe, testable state management
3. **Go Router**: Declarative routing with deep linking support
4. **Dio for HTTP**: Robust HTTP client with interceptors
5. **Hive for Storage**: Fast, lightweight local database
6. **TFLite for AI**: On-device machine learning

---

## 🛠️ Tech Stack

### Core Framework
- **Flutter**: 3.16+ (Dart 3.0+)
- **Material Design 3**: Modern UI components

### State Management
- **flutter_riverpod**: ^2.4.0
- **hooks_riverpod**: ^2.4.0

### Navigation
- **go_router**: ^12.0.0

### Networking
- **dio**: ^5.3.3
- **retrofit**: ^4.0.3
- **pretty_dio_logger**: ^1.3.1

### Local Storage
- **hive**: ^2.2.3
- **hive_flutter**: ^1.1.0
- **flutter_secure_storage**: ^9.0.0

### AI/ML
- **tflite_flutter**: ^0.10.3
- **image_picker**: ^1.0.4
- **camera**: ^0.10.5

### Maps & Location
- **google_maps_flutter**: ^2.5.0
- **geolocator**: ^10.1.0

### UI Components
- **cached_network_image**: ^3.3.0
- **shimmer**: ^3.0.0
- **lottie**: ^2.7.0
- **flutter_svg**: ^2.0.9

### Utilities
- **intl**: ^0.18.1
- **timeago**: ^3.5.0
- **url_launcher**: ^6.2.1
- **share_plus**: ^7.2.1

---

## 📁 Project Structure

```
mobile/
├── lib/
│   ├── main.dart                    # App entry point
│   │
│   ├── core/                        # Core utilities & shared code
│   │   ├── router/
│   │   │   └── app_router.dart     # Go Router configuration
│   │   ├── theme/
│   │   │   └── app_theme.dart      # Theme & design system
│   │   ├── services/
│   │   │   ├── api_service.dart    # API client
│   │   │   ├── storage_service.dart # Local storage
│   │   │   └── notification_service.dart # Push notifications
│   │   ├── constants/
│   │   │   ├── api_constants.dart  # API endpoints
│   │   │   └── app_constants.dart  # App constants
│   │   ├── utils/
│   │   │   ├── validators.dart     # Form validators
│   │   │   └── helpers.dart        # Helper functions
│   │   └── widgets/
│   │       ├── loading_widget.dart
│   │       ├── error_widget.dart
│   │       └── empty_state.dart
│   │
│   └── features/                    # Feature modules
│       ├── auth/                    # Authentication
│       │   ├── data/
│       │   │   ├── models/
│       │   │   └── repositories/
│       │   ├── domain/
│       │   │   └── entities/
│       │   └── presentation/
│       │       ├── pages/
│       │       │   ├── splash_page.dart
│       │       │   ├── onboarding_page.dart
│       │       │   ├── login_page.dart
│       │       │   └── register_page.dart
│       │       ├── widgets/
│       │       └── providers/
│       │
│       ├── dashboard/               # Home dashboard
│       │   ├── presentation/
│       │   │   ├── pages/
│       │   │   │   └── dashboard_page.dart
│       │   │   └── widgets/
│       │   │       ├── weather_card.dart
│       │   │       ├── quick_stats.dart
│       │   │       └── recent_activities.dart
│       │   └── providers/
│       │
│       ├── farms/                   # Farm management
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       ├── pages/
│       │       │   ├── farms_page.dart
│       │       │   ├── farm_detail_page.dart
│       │       │   └── add_farm_page.dart
│       │       └── widgets/
│       │
│       ├── crops/                   # Crop tracking
│       │   └── presentation/
│       │       ├── pages/
│       │       └── widgets/
│       │
│       ├── diagnosis/               # AI disease diagnosis
│       │   ├── data/
│       │   │   └── ml_service.dart
│       │   └── presentation/
│       │       ├── pages/
│       │       │   ├── diagnosis_page.dart
│       │       │   └── diagnosis_result_page.dart
│       │       └── widgets/
│       │
│       ├── marketplace/             # E-marketplace
│       │   └── presentation/
│       │       ├── pages/
│       │       │   ├── marketplace_page.dart
│       │       │   ├── listing_detail_page.dart
│       │       │   └── create_listing_page.dart
│       │       └── widgets/
│       │
│       ├── weather/                 # Weather & alerts
│       │   └── presentation/
│       │       ├── pages/
│       │       └── widgets/
│       │
│       ├── learning/                # Learning center
│       │   └── presentation/
│       │       ├── pages/
│       │       └── widgets/
│       │
│       ├── forum/                   # Community forum
│       │   └── presentation/
│       │       ├── pages/
│       │       └── widgets/
│       │
│       └── profile/                 # User profile
│           └── presentation/
│               ├── pages/
│               └── widgets/
│
├── assets/
│   ├── images/                      # Image assets
│   │   ├── logo.png
│   │   ├── splash.png
│   │   └── onboarding/
│   ├── icons/                       # Icon assets
│   ├── animations/                  # Lottie animations
│   │   ├── loading.json
│   │   └── success.json
│   └── models/                      # AI models
│       └── crop_disease_model.tflite
│
├── test/                            # Unit & widget tests
├── integration_test/                # Integration tests
├── android/                         # Android native code
├── ios/                             # iOS native code
├── pubspec.yaml                     # Dependencies
└── README.md                        # This file
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.16 or higher
- Dart 3.0 or higher
- Android Studio / Xcode
- VS Code with Flutter extension (recommended)

### Installation

1. **Navigate to mobile directory**
```bash
cd mobile
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code (if using code generation)**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Check Flutter setup**
```bash
flutter doctor -v
```

### Running the App

#### Development Mode

```bash
# Run on connected device
flutter run

# Run with hot reload
flutter run --hot

# Run on specific device
flutter devices
flutter run -d <device_id>

# Run with flavor
flutter run --flavor dev -t lib/main_dev.dart
```

#### Platform-Specific

```bash
# Android
flutter run -d android

# iOS (macOS only)
flutter run -d ios

# Web
flutter run -d chrome
```

---

## ⚙️ Configuration

### API Configuration

Edit `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  // Change this to your backend URL
  static const String baseUrl = 'http://YOUR_IP:3001/api';
  
  // For Android emulator use: http://10.0.2.2:3001/api
  // For iOS simulator use: http://localhost:3001/api
  // For physical device use: http://YOUR_COMPUTER_IP:3001/api
}
```

### Environment Setup

Create environment-specific configurations:

```dart
// lib/config/env.dart
abstract class Environment {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3001/api',
  );
  
  static const String env = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );
}
```

Run with environment variables:
```bash
flutter run --dart-define=API_URL=https://api.agrovision.rw --dart-define=ENV=prod
```

---

## 🎨 Features

### 1. Authentication

**Pages:**
- Splash Screen (auto-navigation after 3s)
- Onboarding (3 screens with skip)
- Login (email/phone + password)
- Registration (name, email, phone, password, role)

**Features:**
- JWT token storage (secure)
- Auto-login on app start
- Biometric authentication (optional)
- Password reset via SMS

**Usage:**
```dart
// Login
final authService = ref.read(authServiceProvider);
await authService.login(email, password);

// Check auth state
final isAuthenticated = ref.watch(authStateProvider);
```

### 2. Dashboard

**Features:**
- Weather widget with current conditions
- Quick stats (farms, crops, diagnoses)
- Recent activities timeline
- Quick actions (scan, add farm, marketplace)
- Notifications bell

### 3. Farm Management

**Features:**
- View all farms (list/map view)
- Add new farm (name, location, size)
- Edit farm details
- Delete farm
- View farm analytics
- Associate crops with farms

**Data Model:**
```dart
class Farm {
  final String id;
  final String name;
  final String location;
  final double size;
  final String? district;
  final String? sector;
  final List<Crop> crops;
  final DateTime createdAt;
}
```

### 4. Crop Tracking

**Features:**
- Add crops to farm
- Track growth stages
- Record activities (planting, watering, fertilizing)
- Monitor costs
- View harvest predictions
- Set reminders

### 5. AI Disease Diagnosis

**Features:**
- Camera integration
- Gallery image selection
- On-device AI inference (TFLite)
- Server-side inference (fallback)
- Disease identification (94% accuracy)
- Treatment recommendations
- Cost estimates
- Prevention tips
- History of diagnoses

**Flow:**
```
1. Take/select photo
2. Process image
3. Run AI model
4. Display results:
   - Disease name
   - Confidence score
   - Treatment options
   - Estimated costs
5. Save to history
```

### 6. Marketplace

**Features:**
- Browse listings (infinite scroll)
- Search & filters
- Product details with images
- Make offers
- Negotiate prices
- Track orders
- Rate sellers
- Create listings (farmers only)

**Listing Creation:**
```dart
CreateListingRequest(
  title: 'Fresh Tomatoes',
  description: '...',
  price: 5000,
  quantity: 100,
  unit: 'kg',
  category: 'VEGETABLES',
  quality: 'Grade A',
  images: [file1, file2],
);
```

### 7. Weather & Alerts

**Features:**
- Current weather
- 7-day forecast
- Hourly forecast
- Weather alerts (rain, frost, heat)
- Smart farming recommendations
- Historical weather data

### 8. Learning Center

**Features:**
- Video tutorials
- Articles & guides
- Best practices
- Pest & disease database
- Offline downloads
- Bookmarks
- Search

### 9. Community Forum

**Features:**
- Ask questions
- Answer questions
- Upvote/downvote
- Expert verification
- Categories/tags
- Search
- Notifications

### 10. Profile & Settings

**Features:**
- Edit profile
- Subscription management
- Notification settings
- Language selection
- Theme (light/dark)
- Privacy settings
- Help & support
- About

---

## 🔄 State Management

### Riverpod Architecture

```dart
// Provider example
final farmsProvider = FutureProvider<List<Farm>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getFarms();
});

// State Notifier example
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._apiService) : super(AuthState.initial());
  
  final ApiService _apiService;
  
  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await _apiService.login(email, password);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: response.user,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      );
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(apiServiceProvider));
});
```

### Usage in Widgets

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farms = ref.watch(farmsProvider);
    
    return farms.when(
      data: (farms) => ListView.builder(
        itemCount: farms.length,
        itemBuilder: (context, index) => FarmCard(farm: farms[index]),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error: error),
    );
  }
}
```

---

## 🌐 API Integration

### API Service

```dart
class ApiService {
  final Dio _dio;
  
  ApiService(this._dio) {
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
  }
  
  Future<LoginResponse> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return LoginResponse.fromJson(response.data);
  }
  
  Future<List<Farm>> getFarms() async {
    final response = await _dio.get('/farms');
    return (response.data['data'] as List)
        .map((json) => Farm.fromJson(json))
        .toList();
  }
}
```

### Auth Interceptor

```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = StorageService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
```

---

## 💾 Offline Mode

### Hive Storage

```dart
// Initialize Hive
await Hive.initFlutter();
await Hive.openBox('farms');
await Hive.openBox('crops');

// Store data
final box = Hive.box('farms');
await box.put('farm_123', farm.toJson());

// Retrieve data
final farmJson = box.get('farm_123');
final farm = Farm.fromJson(farmJson);

// Sync when online
if (await isOnline()) {
  await syncOfflineData();
}
```

### Offline-First Strategy

1. **Read**: Check local cache first, then API
2. **Write**: Save locally immediately, sync to API when online
3. **Sync**: Background sync when connection restored
4. **Conflict Resolution**: Last-write-wins or manual resolution

---

## 🧪 Testing

### Unit Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# View coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Widget Tests

```dart
testWidgets('Login button should be disabled when fields are empty', (tester) async {
  await tester.pumpWidget(MyApp());
  
  final loginButton = find.byType(ElevatedButton);
  expect(tester.widget<ElevatedButton>(loginButton).onPressed, isNull);
});
```

### Integration Tests

```bash
# Run integration tests
flutter test integration_test/app_test.dart

# Run on device
flutter drive --target=integration_test/app_test.dart
```

---

## 📦 Building

### Android

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release

# Split APKs by ABI
flutter build apk --split-per-abi
```

**Output**: `build/app/outputs/flutter-apk/`

### iOS

```bash
# Debug
flutter build ios --debug

# Release
flutter build ios --release

# Archive (requires Xcode)
flutter build ipa
```

**Output**: `build/ios/iphoneos/`

### Build Configuration

**Android**: `android/app/build.gradle`
```gradle
android {
    defaultConfig {
        applicationId "rw.agrovision.app"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
    }
}
```

**iOS**: `ios/Runner/Info.plist`
```xml
<key>CFBundleIdentifier</key>
<string>rw.agrovision.app</string>
<key>CFBundleVersion</key>
<string>1</string>
```

---

## 🚀 Deployment

### Google Play Store

1. **Prepare**
   - Create app in Play Console
   - Set up app signing
   - Prepare store listing

2. **Build**
```bash
flutter build appbundle --release
```

3. **Upload**
   - Upload AAB to Play Console
   - Fill in release notes
   - Submit for review

### Apple App Store

1. **Prepare**
   - Create app in App Store Connect
   - Set up certificates & profiles
   - Prepare store listing

2. **Build**
```bash
flutter build ipa
```

3. **Upload**
   - Use Xcode or Transporter
   - Submit for review

### Firebase App Distribution (Beta)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Build and deploy
flutter build apk --release
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app YOUR_APP_ID \
  --groups testers
```

---

## 🐛 Troubleshooting

### Common Issues

#### 1. "Unable to connect to API"

**Solution:**
- Check `api_constants.dart` has correct URL
- For Android emulator: use `http://10.0.2.2:3001/api`
- For physical device: use your computer's IP address
- Ensure backend is running

#### 2. "Camera permission denied"

**Solution:**
Add permissions to manifest files:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to diagnose crop diseases</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select images</string>
```

#### 3. "Build failed: Kotlin version"

**Solution:**
Update Kotlin version in `android/build.gradle`:
```gradle
ext.kotlin_version = '1.9.0'
```

#### 4. "CocoaPods not installed" (iOS)

**Solution:**
```bash
sudo gem install cocoapods
cd ios
pod install
```

#### 5. "TFLite model not loading"

**Solution:**
- Ensure model file is in `assets/models/`
- Add to `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/models/crop_disease_model.tflite
```

### Debug Tools

```bash
# Check device logs
flutter logs

# Inspect layout
flutter run --debug
# Then press 'p' to toggle debug painting

# Performance overlay
# Press 'P' during debug run

# Widget inspector
# In VS Code: Ctrl+Shift+P → "Flutter: Open Widget Inspector"
```

---

## 📊 Performance Optimization

### Best Practices

1. **Use const constructors**
```dart
const Text('Hello') // Reuses widget instance
```

2. **Optimize images**
```dart
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => Shimmer.fromColors(...),
  errorWidget: (context, url, error) => Icon(Icons.error),
  cacheKey: 'unique_key',
)
```

3. **Lazy loading**
```dart
ListView.builder( // Only builds visible items
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

4. **Pagination**
```dart
// Load data in chunks
final items = await api.getItems(page: currentPage, limit: 20);
```

5. **Debouncing**
```dart
Timer? _debounce;

void onSearchChanged(String query) {
  _debounce?.cancel();
  _debounce = Timer(Duration(milliseconds: 500), () {
    performSearch(query);
  });
}
```

---

## 🔒 Security

### Best Practices

1. **Secure token storage**
```dart
final storage = FlutterSecureStorage();
await storage.write(key: 'token', value: token);
```

2. **API key obfuscation**
```dart
// Use environment variables
const apiKey = String.fromEnvironment('API_KEY');
```

3. **SSL pinning**
```dart
_dio.httpClientAdapter = IOHttpClientAdapter()
  ..onHttpClientCreate = (client) {
    client.badCertificateCallback = (cert, host, port) => false;
    return client;
  };
```

4. **Input validation**
```dart
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Invalid email format';
  }
  return null;
}
```

---

## 📞 Support

### Resources

- **Flutter Docs**: https://docs.flutter.dev
- **Riverpod Docs**: https://riverpod.dev
- **API Docs**: See `/docs/API_DOCUMENTATION.md`
- **UI/UX Designs**: See `/docs/UI_UX_DESIGN.md`

### Getting Help

- **GitHub Issues**: Report bugs or request features
- **Email**: support@agrovision.rw
- **Documentation**: Check this README first

---

## 🔄 Updates & Maintenance

### Updating Dependencies

```bash
# Check for outdated packages
flutter pub outdated

# Update all packages
flutter pub upgrade

# Update Flutter SDK
flutter upgrade
```

### Version Management

Update version in `pubspec.yaml`:
```yaml
version: 1.0.0+1  # version+build_number
```

---

## 📝 Contributing

### Development Workflow

1. Create feature branch
2. Implement feature
3. Write tests
4. Update documentation
5. Submit pull request

### Code Style

Follow Flutter style guide:
```bash
# Format code
flutter format .

# Analyze code
flutter analyze
```

### Commit Messages

```
feat: Add crop disease diagnosis feature
fix: Fix marketplace listing pagination
docs: Update API integration guide
style: Format code according to style guide
refactor: Restructure farm management module
test: Add unit tests for auth service
```

---

## 📄 License

This project is licensed under the MIT License.

---

## 👥 Team

**Developed by the AgroVision Team**

- Product Manager: [Name]
- Lead Developer: [Name]
- UI/UX Designer: [Name]
- Backend Developer: [Name]

---

**Last Updated**: December 12, 2025  
**Version**: 1.0.0  
**Flutter**: 3.16+
