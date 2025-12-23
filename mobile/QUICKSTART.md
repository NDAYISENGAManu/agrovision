# 🚀 AgroVision Mobile - Quick Start Guide

## 5-Minute Setup

### 1. Prerequisites Check
```bash
flutter --version  # Should be 3.16+
dart --version     # Should be 3.0+
```

### 2. Install Dependencies
```bash
cd mobile
flutter pub get
```

### 3. Configure API
Edit `lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'http://10.0.2.2:3001/api'; // Android emulator
// Or use your computer's IP for physical device
```

### 4. Run the App
```bash
flutter run
```

---

## Device-Specific Setup

### Android Emulator
```dart
baseUrl = 'http://10.0.2.2:3001/api'
```

### iOS Simulator
```dart
baseUrl = 'http://localhost:3001/api'
```

### Physical Device
```dart
baseUrl = 'http://192.168.1.100:3001/api' // Your computer's IP
```

---

## Common Commands

```bash
# Hot reload: Press 'r' in terminal
# Hot restart: Press 'R' in terminal
# Quit: Press 'q' in terminal

# Run on specific device
flutter devices
flutter run -d <device_id>

# Build APK
flutter build apk --release

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

---

## Test Credentials

### Farmer Account
- Phone: `+250788123456`
- Password: `Test@123`

### Buyer Account
- Phone: `+250788654321`
- Password: `Test@123`

---

## Quick Reference

### Project Structure
```
lib/
├── main.dart              # Entry point
├── core/                  # Shared utilities
│   ├── router/           # Navigation
│   ├── theme/            # Design system
│   ├── services/         # API & storage
│   └── constants/        # Constants
└── features/             # App features
    ├── auth/             # Login/Register
    ├── dashboard/        # Home screen
    ├── farms/            # Farm management
    ├── diagnosis/        # AI diagnosis
    └── marketplace/      # E-commerce
```

### Key Files
- `pubspec.yaml` - Dependencies
- `lib/main.dart` - App entry
- `lib/core/router/app_router.dart` - Routes
- `lib/core/theme/app_theme.dart` - Theme
- `lib/core/services/api_service.dart` - API client

---

## Troubleshooting

### Can't connect to backend?
1. Check backend is running: `http://localhost:3001/api`
2. Update IP in `api_constants.dart`
3. Check firewall settings

### Build errors?
```bash
flutter clean
flutter pub get
flutter run
```

### Camera not working?
Add permissions to:
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

---

## Next Steps

1. ✅ Run the app
2. 📱 Explore features
3. 🔧 Customize theme
4. 🚀 Build and deploy

**Full Documentation**: See `README.md` in this directory

**Support**: support@agrovision.rw
