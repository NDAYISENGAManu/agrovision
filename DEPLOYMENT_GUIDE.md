# AgroVision - Deployment & Setup Guide

## Complete Smart Agriculture Platform for Rwanda

This guide provides complete instructions for setting up and running the AgroVision platform, including the Next.js backend with admin backoffice and Flutter mobile application.

---

## 📋 Prerequisites

### Backend Requirements
- Node.js 18+ and npm
- PostgreSQL 14+
- Git

### Mobile Requirements
- Flutter SDK 3.16+
- Android Studio (for Android) or Xcode (for iOS)
- VS Code or Android Studio with Flutter plugins

---

## 🚀 Quick Start

### 1. Database Setup

```bash
# Start PostgreSQL service
sudo systemctl start postgresql

# Create database
psql -U postgres
CREATE DATABASE "agri-db";
\q
```

### 2. Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Configure environment
cp .env.example .env

# Update .env with your settings:
# DATABASE_URL="postgresql://postgres:123@localhost:5432/agri-db"
# JWT_SECRET="your-super-secret-jwt-key-change-in-production"
# ADMIN_EMAIL="admin@agrovision.rw"
# ADMIN_PASSWORD="Admin@123"

# Generate Prisma client
npx prisma generate

# Run migrations
npx prisma migrate dev

# Seed database with initial data
npx prisma db seed

# Start development server
npm run dev
```

Backend will run on: **http://localhost:3001**

Admin backoffice: **http://localhost:3001/admin**

### 3. Mobile App Setup

```bash
cd mobile

# Install Flutter dependencies
flutter pub get

# Update API base URL in lib/core/config/api_config.dart
# Change baseUrl to: "http://localhost:3001/api"
# For Android emulator: "http://10.0.2.2:3001/api"
# For real device: "http://YOUR_IP:3001/api"

# Run the app
flutter run
```

---

## 🔐 Admin Backoffice Access

### Default Admin Credentials
- **Email**: admin@agrovision.rw
- **Password**: Admin@123

### Admin Features
1. **Dashboard**: View statistics and analytics
2. **User Management**: Manage farmers, buyers, and experts
3. **Reports Management**: View and manage crop reports
4. **Marketplace Moderation**: Approve/reject product listings
5. **System Settings**: Configure platform settings

### Accessing Admin Panel
1. Navigate to: http://localhost:3001/admin
2. Login with admin credentials
3. Access all admin features from the sidebar

---

## 📱 Mobile App Features

### Authentication
- Phone/Email login
- User registration with role selection (Farmer/Buyer/Expert)
- Secure JWT authentication

### Main Features
1. **Dashboard**: Overview of farms and activities
2. **Farm Management**: Add, view, and manage farms
3. **AI Disease Diagnosis**: Upload plant images for diagnosis
4. **Marketplace**: Buy/sell agricultural products
5. **Weather Forecasts**: Location-based weather data
6. **Learning Center**: Educational agricultural content
7. **Community Forum**: Discussion and knowledge sharing
8. **Profile Management**: User settings and preferences

---

## 🗄️ Database Schema

### Main Tables
- **User**: Farmers, buyers, experts, admins
- **Farm**: Farm information and metadata
- **Crop**: Crop tracking and management
- **Diagnosis**: AI disease diagnosis results
- **MarketListing**: Product listings
- **MarketPrice**: Price tracking
- **Order**: Transaction records
- **WeatherData**: Weather information
- **LearningContent**: Educational resources
- **ForumPost**: Community discussions

### Seeded Data
The seed script creates:
- 1 admin user
- 10 sample farmers
- 30 farms with crops
- Market prices for common crops
- Learning content
- Forum discussions

---

## 🔧 Configuration

### Backend Environment Variables

```env
# Database
DATABASE_URL="postgresql://postgres:123@localhost:5432/agri-db"

# JWT
JWT_SECRET="your-super-secret-jwt-key-change-in-production"

# Admin
ADMIN_EMAIL="admin@agrovision.rw"
ADMIN_PASSWORD="Admin@123"

# External Services
OPENWEATHER_API_KEY="your-openweathermap-api-key"
TWILIO_ACCOUNT_SID="your-twilio-sid"
TWILIO_AUTH_TOKEN="your-twilio-token"
TWILIO_PHONE_NUMBER="+1234567890"
CLOUDINARY_CLOUD_NAME="your-cloudinary-name"
CLOUDINARY_API_KEY="your-cloudinary-key"
CLOUDINARY_API_SECRET="your-cloudinary-secret"
STRIPE_SECRET_KEY="your-stripe-key"

# Server
PORT=3001
NODE_ENV=development
```

### Mobile API Configuration

Edit `mobile/lib/core/config/api_config.dart`:

```dart
class ApiConfig {
  // Development
  static const String baseUrl = 'http://localhost:3001/api';
  
  // For Android emulator
  // static const String baseUrl = 'http://10.0.2.2:3001/api';
  
  // For real device (replace with your IP)
  // static const String baseUrl = 'http://192.168.1.100:3001/api';
  
  // Production
  // static const String baseUrl = 'https://your-domain.com/api';
}
```

---

## 🧪 Testing

### Backend API Testing

```bash
# Install Postman or use curl

# Test health endpoint
curl http://localhost:3001/api/health

# Test admin login
curl -X POST http://localhost:3001/api/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@agrovision.rw","password":"Admin@123"}'

# Test user registration
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "fullName":"Test User",
    "email":"test@example.com",
    "phone":"+250788123456",
    "password":"Test@123",
    "role":"FARMER"
  }'
```

### Mobile App Testing

```bash
# Run on specific device
flutter run -d <device-id>

# Run with hot reload
flutter run --hot

# Build APK for testing
flutter build apk --debug
```

---

## 📦 Production Deployment

### Backend Deployment

1. **Environment Setup**
```bash
# Update .env for production
NODE_ENV=production
DATABASE_URL="your-production-database-url"
# Add all production API keys
```

2. **Build Application**
```bash
npm run build
```

3. **Deploy Options**
- **Vercel**: `vercel deploy`
- **Heroku**: `git push heroku main`
- **Docker**: Use provided Dockerfile
- **VPS**: Use PM2 for process management

4. **Database Migration**
```bash
npx prisma migrate deploy
npx prisma db seed
```

### Mobile App Deployment

1. **Android**
```bash
# Build release APK
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release
```

2. **iOS**
```bash
# Build for iOS
flutter build ios --release
```

3. **Update API URL**
- Set production API URL in `api_config.dart`
- Update app version in `pubspec.yaml`

---

## 🐛 Troubleshooting

### Backend Issues

**Database Connection Failed**
```bash
# Check PostgreSQL is running
sudo systemctl status postgresql

# Test connection
psql -U postgres -d agri-db

# Reset database
npx prisma migrate reset
```

**Port Already in Use**
```bash
# Find and kill process on port 3001
lsof -ti:3001 | xargs kill -9

# Or change PORT in .env
```

**Prisma Errors**
```bash
# Regenerate client
npx prisma generate

# Reset and migrate
npx prisma migrate reset
npx prisma migrate dev
```

### Mobile Issues

**Flutter Doctor Issues**
```bash
flutter doctor -v
flutter doctor --android-licenses
```

**Build Errors**
```bash
# Clean build
flutter clean
flutter pub get
flutter pub upgrade

# Clear cache
rm -rf ~/.pub-cache
flutter pub cache repair
```

**API Connection Failed**
- Check backend is running on correct port
- Update API URL for device type (emulator/real device)
- Check network permissions in AndroidManifest.xml
- Disable SSL pinning for local development

---

## 📚 API Documentation

### Authentication Endpoints
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout
- `GET /api/auth/me` - Get current user

### Admin Endpoints (Requires Admin Token)
- `POST /api/admin/auth/login` - Admin login
- `GET /api/admin/dashboard` - Dashboard stats
- `GET /api/admin/users` - List all users
- `GET /api/admin/reports` - List all reports
- `PUT /api/admin/marketplace/:id` - Moderate listing

### Farm Endpoints (Requires Auth)
- `GET /api/farms` - List user farms
- `POST /api/farms` - Create farm
- `GET /api/farms/:id` - Get farm details
- `PUT /api/farms/:id` - Update farm
- `DELETE /api/farms/:id` - Delete farm

### Diagnosis Endpoints (Requires Auth)
- `POST /api/diagnosis` - Submit diagnosis
- `GET /api/diagnosis` - List diagnoses
- `GET /api/diagnosis/:id` - Get diagnosis details

### Marketplace Endpoints
- `GET /api/marketplace/listings` - List products
- `POST /api/marketplace/listings` - Create listing
- `GET /api/marketplace/prices` - Get market prices

### Weather Endpoint (Requires Auth)
- `GET /api/weather?lat=&lon=` - Get weather data

### Learning Endpoints
- `GET /api/learning` - List content
- `GET /api/learning/:id` - Get content details

### Forum Endpoints (Requires Auth)
- `GET /api/forum/posts` - List posts
- `POST /api/forum/posts` - Create post
- `POST /api/forum/posts/:id/comments` - Add comment

### Notifications (Requires Auth)
- `GET /api/notifications` - Get notifications
- `PUT /api/notifications/:id/read` - Mark as read

---

## 🔒 Security Considerations

### Backend Security
- JWT tokens with secure secrets
- Password hashing with bcrypt
- Input validation and sanitization
- Rate limiting on sensitive endpoints
- CORS configuration
- SQL injection prevention via Prisma

### Mobile Security
- Secure token storage with Hive
- HTTPS-only API calls
- Input validation
- Secure password fields
- Session management

---

## 📈 Performance Optimization

### Backend
- Database indexing on frequently queried fields
- Query optimization with Prisma
- Caching with Redis (optional)
- Image optimization with Cloudinary
- API response compression

### Mobile
- Image caching
- Lazy loading for lists
- Pagination for large datasets
- Optimized asset sizes
- State management with Riverpod

---

## 🤝 Support & Contribution

### Getting Help
- Check documentation in `/backend/README.md` and `/mobile/README.md`
- Review code comments
- Check API examples in Postman collection

### Project Structure
```
AgroVision/
├── backend/                 # Next.js backend + admin backoffice
│   ├── app/                # Next.js app directory
│   │   ├── api/           # API routes
│   │   └── admin/         # Admin UI pages
│   ├── prisma/            # Database schema and migrations
│   └── middleware/        # Authentication middleware
│
└── mobile/                 # Flutter mobile app
    ├── lib/
    │   ├── core/          # Core utilities and config
    │   └── features/      # Feature modules
    ├── android/           # Android configuration
    └── ios/              # iOS configuration
```

---

## 📝 License

This project is developed for AgroVision platform in Rwanda.

---

## 🎯 Next Steps

1. ✅ Set up database
2. ✅ Start backend server
3. ✅ Access admin panel
4. ✅ Run mobile app
5. ✅ Create test accounts
6. ✅ Test all features
7. 🔄 Configure external APIs (OpenWeather, Twilio, etc.)
8. 🔄 Customize branding and content
9. 🔄 Deploy to production

---

**Built with ❤️ for Rwandan Farmers**
