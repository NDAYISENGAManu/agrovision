# AgroVision Backend API

Backend API for AgroVision Smart Agriculture Platform built with Next.js 14 and PostgreSQL.

## Features

- 🔐 JWT Authentication
- 👨‍🌾 Farm & Crop Management
- 🤖 AI Disease Diagnosis
- 📊 Market Price Tracking
- 🛒 E-Marketplace
- 🌦️ Weather Integration
- 📱 Real-time Notifications
- 💬 Community Forum & Chat
- 📚 Learning Center

## Getting Started

### Prerequisites

- Node.js 18+
- PostgreSQL 14+
- npm or yarn

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd backend
```

2. Install dependencies
```bash
npm install
```

3. Set up environment variables
```bash
cp .env.example .env
# Edit .env with your actual values
```

4. Set up database
```bash
# Generate Prisma client
npm run db:generate

# Run migrations
npm run db:migrate

# Seed database (optional)
npm run db:seed
```

5. Run development server
```bash
npm run dev
```

The API will be available at `http://localhost:3001`

## API Documentation

### Authentication

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "phoneNumber": "+250788123456",
  "password": "password123",
  "fullName": "John Doe",
  "email": "john@example.com",
  "role": "FARMER",
  "district": "Kigali",
  "sector": "Kimironko",
  "language": "en"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "phoneNumber": "+250788123456",
  "password": "password123"
}
```

### Farms

#### Create Farm
```http
POST /api/farms
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "My Farm",
  "location": "Nyagatare",
  "size": 2.5,
  "district": "Nyagatare",
  "sector": "Rwimiyaga",
  "soilType": "LOAMY"
}
```

#### Get User Farms
```http
GET /api/farms
Authorization: Bearer <token>
```

### Crops

#### Create Crop
```http
POST /api/crops
Authorization: Bearer <token>
Content-Type: application/json

{
  "farmId": "farm-id",
  "cropType": "MAIZE",
  "variety": "Hybrid",
  "plantingDate": "2024-01-15",
  "area": 1.5,
  "seedCost": 50000
}
```

### Disease Diagnosis

#### Submit Diagnosis
```http
POST /api/diagnosis
Authorization: Bearer <token>
Content-Type: multipart/form-data

image: <file>
cropType: MAIZE
cropId: crop-id (optional)
location: Kigali
```

### Market Prices

#### Get Market Prices
```http
GET /api/market/prices?commodity=MAIZE&market=KIGALI_KIMIRONKO
```

### Marketplace

#### Create Listing
```http
POST /api/marketplace/listings
Authorization: Bearer <token>
Content-Type: application/json

{
  "cropType": "MAIZE",
  "quantity": 1000,
  "qualityGrade": "GRADE_A",
  "pricePerUnit": 500,
  "location": "Kigali",
  "district": "Kigali"
}
```

#### Get Listings
```http
GET /api/marketplace/listings?cropType=MAIZE&district=Kigali
```

### Weather

#### Get Weather Data
```http
GET /api/weather?location=Kigali&forecast=true
Authorization: Bearer <token>
```

## Database Schema

See `prisma/schema.prisma` for the complete database schema.

## Project Structure

```
backend/
├── app/
│   └── api/
│       ├── auth/
│       ├── farms/
│       ├── crops/
│       ├── diagnosis/
│       ├── marketplace/
│       ├── weather/
│       ├── forum/
│       └── learning/
├── lib/
│   ├── prisma.ts
│   └── auth.ts
├── middleware/
│   └── auth.ts
├── utils/
│   ├── validation.ts
│   └── apiResponse.ts
├── prisma/
│   └── schema.prisma
└── package.json
```

## Environment Variables

See `.env.example` for all required environment variables.

## License

MIT
