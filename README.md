# 🌾 AgroVision - Smart Agriculture Platform

> Transforming African Agriculture with AI

<!-- [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT) -->
[![Next.js](https://img.shields.io/badge/Next.js-14-black)](https://nextjs.org/)
[![Flutter](https://img.shields.io/badge/Flutter-3.16-blue)](https://flutter.dev/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14-blue)](https://www.postgresql.org/)

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

AgroVision is a comprehensive smart agriculture platform designed for Rwandan farmers. It combines AI-powered disease diagnosis, real-time market prices, farm management tools, and an e-marketplace to help farmers increase productivity and income.

### The Problem We Solve

- **30-40% crop losses** due to diseases and lack of expert diagnosis
- **20-30% income loss** to middlemen due to price information asymmetry
- **Poor farm management** without digital tools for tracking and optimization
- **Weather uncertainty** affecting farming decisions

### Our Solution

A mobile-first platform that provides:
- 🤖 **AI Disease Diagnosis**: Instant crop disease detection with 94% accuracy
- 📊 **Market Prices**: Real-time prices from major Rwandan markets
- 🌦️ **Weather Forecasts**: Localized forecasts and smart alerts
- 🚜 **Farm Management**: Digital farm and crop tracking
- 🛒 **E-Marketplace**: Direct farmer-to-buyer connections
- 📚 **Learning Center**: Educational content in local languages
- 💬 **Community Forum**: Peer-to-peer knowledge sharing

## 🏗️ Architecture

AgroVision is built with a modern, decoupled architecture:

- **Backend (Next.js)**: A robust REST API built with Next.js 14, handling business logic, database management, and authentication. It also includes a comprehensive Admin Backoffice UI.
- **Mobile (Flutter)**: A cross-platform mobile application for farmers and buyers, built with Flutter for a seamless experience on both Android and iOS.
- **Database (PostgreSQL)**: A relational database managed via Prisma ORM for type-safe data access.
- **AI/ML**: Integrated on-device (mobile) and via API (backend) for real-time crop disease diagnosis.

## ✨ Features

### For Farmers

- **AI Crop Disease Diagnosis**
  - Take photo of affected crop
  - Instant diagnosis with confidence score
  - Treatment recommendations (chemical & organic)
  - Estimated treatment costs
  - Prevention tips

- **Farm Management Dashboard**
  - Manage multiple farms
  - Track planting dates and crop stages
  - Record costs (seeds, fertilizer, labor)
  - Set reminders for activities
  - Calculate profitability

- **Real-time Market Prices**
  - Daily prices for major crops
  - Compare prices across markets
  - Price trends and forecasts
  - Best time to sell indicators

- **Weather & Smart Alerts**
  - 7-day weather forecast
  - Rain probability and timing
  - Irrigation scheduling
  - Disease risk alerts
  - UV index and soil moisture estimates

- **E-Marketplace**
  - Create product listings
  - Upload photos and set prices
  - Receive buyer offers
  - Direct communication
  - Order tracking

- **Learning Center**
  - Video tutorials
  - Step-by-step guides
  - Expert tips
  - Multi-language content (Kinyarwanda, English, Swahili, French)

### For Buyers

- Browse quality-graded produce
- Make offers and negotiate
- Contact farmers directly
- Track orders
- Rate and review sellers

### For Experts

- Answer farmer questions
- Provide consultations
- Earn from expertise
- Build reputation

## 🛠️ Tech Stack

### Backend (Next.js)
- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript
- **Database**: PostgreSQL 14+
- **ORM**: Prisma
- **Authentication**: JWT + NextAuth
- **API**: RESTful APIs
- **File Storage**: Cloudinary
- **Payments**: Stripe + Mobile Money integration
- **SMS/Notifications**: Twilio, Firebase Cloud Messaging
- **Weather API**: OpenWeatherMap
- **Hosting**: Vercel / AWS

### Mobile (Flutter)
- **Framework**: Flutter 3.16+
- **Language**: Dart
- **State Management**: Riverpod
- **Navigation**: go_router
- **HTTP Client**: Dio + Retrofit
- **Local Storage**: Hive
- **Secure Storage**: flutter_secure_storage
- **Image Processing**: image_picker, image_cropper
- **Maps**: Google Maps Flutter
- **Charts**: fl_chart
- **Notifications**: Firebase Messaging + flutter_local_notifications
- **AI/ML**: TensorFlow Lite for on-device inference
- **Video**: video_player, youtube_player_flutter

### AI/ML
- **Framework**: TensorFlow / PyTorch
- **Model**: Custom CNN for disease classification
- **Training**: Transfer learning on ResNet50/MobileNetV2
- **Dataset**: 50,000+ labeled crop disease images
- **Deployment**: TensorFlow Lite (mobile), TensorFlow Serving (backend)
- **Inference**: <5 seconds on device

### DevOps
- **Version Control**: Git + GitHub
- **CI/CD**: GitHub Actions
- **Containerization**: Docker
- **Monitoring**: Sentry, Firebase Analytics
- **Logging**: Winston (backend), Logger (Flutter)

## 📁 Project Structure

The project is organized into two main standalone applications within this repository:

```
AgroVision/
├── backend/                    # Next.js Backend API + Admin Backoffice
│   ├── app/
│   │   ├── api/               # REST API Endpoints
│   │   │   ├── auth/          # Authentication (JWT)
│   │   │   ├── admin/         # Platform administration
│   │   │   ├── farms/         # Farm management
│   │   │   ├── crops/         # Crop tracking
│   │   │   ├── diagnosis/     # AI disease diagnosis
│   │   │   ├── marketplace/   # E-marketplace
│   │   │   ├── weather/       # Weather data
│   │   │   ├── learning/      # Educational content
│   │   │   └── forum/         # Community forum
│   │   └── admin/             # Admin Backoffice Dashboard UI
│   ├── lib/                   # Database & Auth shared utilities
│   ├── middleware/            # Security & Auth middleware
│   ├── utils/                 # Helper functions & validation
│   └── prisma/                # Database schema (schema.prisma)
│
├── mobile/                     # Flutter Mobile App
│   ├── lib/
│   │   ├── core/              # Global utilities, theme, and router
│   │   └── features/          # Feature-first modules
│   │       ├── auth/          # Login/Register & Onboarding
│   │       ├── dashboard/     # User home screen
│   │       ├── farms/         # Farm & Crop management
│   │       ├── diagnosis/     # AI camera & TFLite integration
│   │       ├── marketplace/   # P2P trading
│   │       ├── weather/       # Real-time weather alerts
│   │       ├── learning/      # Video & Article center
│   │       └── forum/         # Peer-to-peer discussions
│   └── assets/                # App assets & AI models (.tflite)
│
├── docs/                      # Comprehensive Project Documentation
│   ├── API_DOCUMENTATION.md
│   ├── UI_UX_DESIGN.md
│   ├── BUSINESS_PLAN.md
│   ├── PITCH_DECK.md
│   └── BACKOFFICE_GUIDE.md
│
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- **Node.js** 18+ and npm/yarn
- **PostgreSQL** 14+ (User: postgres, Password: 123)
- **Flutter** 3.16+
- **Git**
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)

### Backend Setup

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/AgroVision.git
cd AgroVision/backend
```

2. **Install dependencies**
```bash
npm install
```

3. **Set up environment variables**
```bash
cp .env.example .env
# Edit .env with your actual values
# Database is already configured: postgresql://postgres:123@localhost:5432/agri-db
```

4. **Create PostgreSQL database**
```bash
createdb -U postgres agri-db
```

5. **Run database migrations**
```bash
npm run db:generate
npm run db:push
# Optional: Seed database
npm run db:seed
```

6. **Start development server**
```bash
npm run dev
```

Backend API will be available at `http://localhost:3001`
Admin UI will be available at `http://localhost:3001/admin`

For detailed setup, see [backend/README.md](backend/README.md).

See [docs/BACKOFFICE_GUIDE.md](docs/BACKOFFICE_GUIDE.md) for detailed admin functionality.

### Mobile Setup

1. **Navigate to mobile directory**
```bash
cd ../mobile
```

2. **Install Flutter dependencies**
```bash
flutter pub get
```

3. **Configure API endpoint**
Edit `lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'http://YOUR_IP:3001/api';
```

4. **Run the app**
```bash
# For Android
flutter run

# For iOS (macOS only)
flutter run -d ios

# For specific device
flutter devices
flutter run -d <device_id>
```

### Database Schema

See `backend/prisma/schema.prisma` for the complete database schema including:
- Users & Authentication
- Farms & Crops
- Disease Diagnosis
- Market Prices & Listings
- Weather Data
- Learning Content
- Forum Posts & Comments
- Notifications
- Payments & Orders

Run Prisma Studio to explore the database:
```bash
npm run db:studio
```

## 📖 Documentation

Comprehensive documentation is available in the `/docs` folder:

- **[API Documentation](docs/API_DOCUMENTATION.md)** - Complete REST API reference
- **[UI/UX Design](docs/UI_UX_DESIGN.md)** - Screen designs and user flows
- **[Business Plan](docs/BUSINESS_PLAN.md)** - Business model and financial projections
- **[Pitch Deck](docs/PITCH_DECK.md)** - Investor presentation
- **[Backoffice Guide](docs/BACKOFFICE_GUIDE.md)** - Admin panel documentation
- **[Database Schema](backend/prisma/schema.prisma)** - Database structure
- **[Quick Start](QUICK_START.md)** - 30-minute setup guide

## 🔐 Admin Backoffice

AgroVision includes a powerful web-based admin panel for platform management.

### Features
- 📊 **Dashboard**: Real-time platform statistics and metrics
- 👥 **User Management**: View, edit, suspend, or delete users
- 🛒 **Marketplace Moderation**: Approve/reject listings, manage orders
- 📈 **Reports & Analytics**: Generate comprehensive reports (users, revenue, diagnoses)
- 📚 **Content Management**: Manage learning materials and forum posts
- ⚙️ **Settings**: Configure platform settings and integrations

### Access
- **URL**: `http://localhost:3001/admin`
- **Default Login**: 
  - Email: `admin@agrovision.rw`
  - Password: `Admin@123`

### API Routes
```
POST   /api/admin/auth/login          # Admin login
POST   /api/admin/auth/logout         # Admin logout
GET    /api/admin/dashboard           # Dashboard stats
GET    /api/admin/users               # List users
GET    /api/admin/users/:id           # User details
PUT    /api/admin/users/:id           # Update user
DELETE /api/admin/users/:id           # Delete user
GET    /api/admin/reports             # Generate reports
PUT    /api/admin/marketplace/:id     # Moderate listing
```

**See [docs/BACKOFFICE_GUIDE.md](docs/BACKOFFICE_GUIDE.md) for complete documentation.**

## 🎨 Key Features Demo

### AI Disease Diagnosis
```
1. Farmer takes photo of affected leaf
2. AI analyzes image (<5 seconds)
3. Returns disease name with 94% confidence
4. Provides treatment options with costs
5. Suggests prevention measures
```

### Smart Marketplace
```
1. Farmer creates listing with photos
2. Sets price, quantity, and quality grade
3. Buyers make offers
4. Negotiate within app
5. Complete transaction with mobile money
6. Platform takes 1-2% commission
```

### Weather Alerts
```
1. System monitors weather patterns
2. Detects adverse conditions
3. Sends push notification
4. "Heavy rain tomorrow - don't irrigate"
5. Farmer takes action, saves resources
```

## 💰 Monetization

### Subscription Tiers

1. **Free**: 5 AI scans/month, 2 farms, ads
2. **Basic** (5,000 RWF/month): 20 scans, 5 farms, ad-free
3. **Premium** (10,000 RWF/month): Unlimited scans, unlimited farms, 0% marketplace fee
4. **Enterprise** (Custom): Multi-user, API access, white-label

### Additional Revenue
- Marketplace commission (1-2%)
- Advertising (agricultural inputs)
- Expert consultations
- B2B partnerships

## 🌍 Impact

### Social Impact Goals (Year 3)
- **80,000 farmers** using the platform
- **$10M worth of crops** saved from disease
- **25-30% increase** in farmer income
- **50,000 tons** additional food produced
- **50 direct jobs**, 500+ indirect jobs created

### UN Sustainable Development Goals
- Goal 1: No Poverty
- Goal 2: Zero Hunger
- Goal 8: Decent Work and Economic Growth
- Goal 9: Industry, Innovation, and Infrastructure
- Goal 13: Climate Action

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Founder & CEO**: [Your Name]
- **CTO**: [Name]
- **Head of Agriculture**: [Name]
- **Head of Marketing**: [Name]

## 📞 Contact

- **Website**: www.agrovision.rw
- **Email**: info@agrovision.rw
- **Phone**: +250 788 XXX XXX
- **Twitter**: @AgroVisionRW
- **LinkedIn**: AgroVision Rwanda

## 🙏 Acknowledgments

- Rwanda Agriculture Board (RAB)
- Ministry of Agriculture (MINAGRI)
- All beta testing farmers
- Agricultural cooperatives
- Technology partners

---

**Built with ❤️ in Rwanda**
