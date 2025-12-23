# AgroVision API Documentation

## Base URL
```
Production: https://api.agrovision.rw
Development: http://localhost:3001/api
```

## Authentication

All authenticated endpoints require a Bearer token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

---

## 1. Authentication Endpoints

### 1.1 Register User

**Endpoint:** `POST /auth/register`

**Description:** Create a new user account

**Request Body:**
```json
{
  "phoneNumber": "+250788123456",
  "password": "securePassword123",
  "fullName": "John Doe",
  "email": "john@example.com",
  "role": "FARMER",
  "district": "Nyagatare",
  "sector": "Rwimiyaga",
  "language": "en"
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "clx1234567890",
      "phoneNumber": "+250788123456",
      "email": "john@example.com",
      "fullName": "John Doe",
      "role": "FARMER",
      "district": "Nyagatare",
      "sector": "Rwimiyaga",
      "language": "en",
      "subscriptionTier": "FREE",
      "verified": false,
      "createdAt": "2024-01-15T10:30:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Errors:**
- `400 Bad Request` - Invalid input data
- `409 Conflict` - User already exists

---

### 1.2 Login

**Endpoint:** `POST /auth/login`

**Request Body:**
```json
{
  "phoneNumber": "+250788123456",
  "password": "securePassword123"
}
```

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "clx1234567890",
      "phoneNumber": "+250788123456",
      "fullName": "John Doe",
      "role": "FARMER",
      "subscriptionTier": "FREE",
      "lastLogin": "2024-01-15T10:30:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Errors:**
- `401 Unauthorized` - Invalid credentials

---

### 1.3 Get Current User

**Endpoint:** `GET /auth/me`

**Headers:** `Authorization: Bearer <token>`

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "id": "clx1234567890",
    "phoneNumber": "+250788123456",
    "fullName": "John Doe",
    "role": "FARMER",
    "subscriptionTier": "PREMIUM",
    "aiScansRemaining": 45,
    "farms": 3,
    "totalCrops": 12
  }
}
```

---

## 2. Farms Endpoints

### 2.1 Get All User Farms

**Endpoint:** `GET /farms`

**Headers:** `Authorization: Bearer <token>`

**Response:** `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "id": "farm_123",
      "name": "Valley Farm",
      "location": "Nyagatare, Rwimiyaga",
      "size": 2.5,
      "soilType": "LOAMY",
      "district": "Nyagatare",
      "sector": "Rwimiyaga",
      "waterSource": "Borehole",
      "createdAt": "2024-01-10T08:00:00Z",
      "crops": [
        {
          "id": "crop_456",
          "cropType": "MAIZE",
          "stage": "FLOWERING",
          "plantingDate": "2023-12-01"
        }
      ],
      "_count": {
        "crops": 5
      }
    }
  ]
}
```

---

### 2.2 Create Farm

**Endpoint:** `POST /farms`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "name": "Hilltop Farm",
  "location": "Kigali, Kimironko",
  "size": 1.8,
  "district": "Kigali",
  "sector": "Kimironko",
  "soilType": "CLAY",
  "waterSource": "Rain-fed",
  "latitude": -1.9536,
  "longitude": 30.0606
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "Farm created successfully",
  "data": {
    "id": "farm_789",
    "name": "Hilltop Farm",
    "location": "Kigali, Kimironko",
    "size": 1.8,
    "district": "Kigali",
    "sector": "Kimironko",
    "soilType": "CLAY",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}
```

---

### 2.3 Get Farm Details

**Endpoint:** `GET /farms/{farmId}`

**Headers:** `Authorization: Bearer <token>`

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "id": "farm_123",
    "name": "Valley Farm",
    "location": "Nyagatare, Rwimiyaga",
    "size": 2.5,
    "soilType": "LOAMY",
    "crops": [
      {
        "id": "crop_456",
        "cropType": "MAIZE",
        "variety": "Hybrid",
        "stage": "FLOWERING",
        "area": 1.5,
        "plantingDate": "2023-12-01",
        "expectedHarvestDate": "2024-03-01",
        "totalCost": 150000,
        "diagnoses": [],
        "recommendations": [
          {
            "type": "FERTILIZER",
            "title": "Apply NPK Fertilizer",
            "priority": 4
          }
        ]
      }
    ],
    "weatherData": [
      {
        "temperature": 24,
        "condition": "Partly Cloudy",
        "rainfall": 0,
        "date": "2024-01-15"
      }
    ]
  }
}
```

---

### 2.4 Update Farm

**Endpoint:** `PUT /farms/{farmId}`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "name": "Valley Farm Updated",
  "size": 3.0
}
```

**Response:** `200 OK`

---

### 2.5 Delete Farm

**Endpoint:** `DELETE /farms/{farmId}`

**Headers:** `Authorization: Bearer <token>`

**Response:** `200 OK`

---

## 3. Crops Endpoints

### 3.1 Get All Crops

**Endpoint:** `GET /crops`

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `farmId` (optional) - Filter by farm
- `active` (optional) - Filter active/inactive crops

**Response:** `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "id": "crop_456",
      "farmId": "farm_123",
      "farm": {
        "id": "farm_123",
        "name": "Valley Farm",
        "location": "Nyagatare"
      },
      "cropType": "MAIZE",
      "variety": "Hybrid",
      "plantingDate": "2023-12-01",
      "expectedHarvestDate": "2024-03-01",
      "area": 1.5,
      "stage": "FLOWERING",
      "totalCost": 150000,
      "active": true,
      "_count": {
        "diagnoses": 2,
        "recommendations": 3
      }
    }
  ]
}
```

---

### 3.2 Create Crop

**Endpoint:** `POST /crops`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "farmId": "farm_123",
  "cropType": "BEANS",
  "variety": "Climbing",
  "plantingDate": "2024-01-15",
  "area": 1.0,
  "expectedHarvestDate": "2024-04-15",
  "seedCost": 30000,
  "fertilizerCost": 40000,
  "pesticideCost": 20000,
  "laborCost": 50000
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "Crop created successfully",
  "data": {
    "id": "crop_789",
    "farmId": "farm_123",
    "cropType": "BEANS",
    "variety": "Climbing",
    "plantingDate": "2024-01-15",
    "area": 1.0,
    "stage": "PLANTING",
    "totalCost": 140000,
    "active": true,
    "createdAt": "2024-01-15T10:30:00Z"
  }
}
```

---

## 4. AI Diagnosis Endpoints

### 4.1 Submit Disease Diagnosis

**Endpoint:** `POST /diagnosis`

**Headers:** 
- `Authorization: Bearer <token>`
- `Content-Type: multipart/form-data`

**Request Body (Form Data):**
```
image: <file>
cropType: MAIZE
cropId: crop_456 (optional)
location: Nyagatare
latitude: -1.2884 (optional)
longitude: 30.1256 (optional)
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "Diagnosis completed successfully",
  "data": {
    "id": "diag_123",
    "userId": "user_789",
    "cropId": "crop_456",
    "cropType": "MAIZE",
    "imageUrl": "https://cloudinary.com/...",
    "diseaseName": "Northern Corn Leaf Blight",
    "confidence": 0.94,
    "severity": "MODERATE",
    "symptoms": [
      "Cigar-shaped gray-green lesions",
      "Lesions turn tan and develop parallel edges",
      "Severe infection causes entire leaves to die"
    ],
    "causes": [
      "Fungal pathogen Exserohilum turcicum",
      "Favored by warm, humid weather",
      "Spreads via wind and rain splash"
    ],
    "treatments": [
      {
        "type": "CHEMICAL",
        "name": "Azoxystrobin + Propiconazole",
        "tradeName": "Headline AMP",
        "dosage": "1 liter per hectare",
        "application": "Spray when symptoms first appear",
        "cost": 25000,
        "effectiveness": 92
      },
      {
        "type": "ORGANIC",
        "name": "Copper-based fungicide",
        "tradeName": "Copper oxychloride",
        "dosage": "3 kg per hectare",
        "application": "Preventive spraying every 7-10 days",
        "cost": 12000,
        "effectiveness": 75
      }
    ],
    "pesticides": [
      "Headline AMP",
      "Tilt",
      "Quadris"
    ],
    "organicSolutions": [
      "Copper oxychloride",
      "Neem oil spray",
      "Remove infected plant debris"
    ],
    "preventiveMeasures": [
      "Use resistant varieties",
      "Practice crop rotation",
      "Remove crop residue",
      "Ensure proper plant spacing"
    ],
    "estimatedCost": 25000,
    "treated": false,
    "createdAt": "2024-01-15T10:30:00Z"
  }
}
```

**Errors:**
- `400 Bad Request` - Invalid image or missing data
- `402 Payment Required` - No AI scans remaining (Free tier limit)
- `503 Service Unavailable` - AI model unavailable

---

### 4.2 Get User Diagnoses

**Endpoint:** `GET /diagnosis`

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `cropId` (optional) - Filter by crop
- `resolved` (optional) - Filter by resolution status
- `limit` (optional) - Number of results (default: 20)
- `offset` (optional) - Pagination offset

**Response:** `200 OK`

---

### 4.3 Mark Diagnosis as Treated

**Endpoint:** `PUT /diagnosis/{diagnosisId}/treat`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "treatmentApplied": "Headline AMP",
  "treatmentDate": "2024-01-16",
  "notes": "Applied as recommended"
}
```

**Response:** `200 OK`

---

## 5. Market Prices Endpoints

### 5.1 Get Market Prices

**Endpoint:** `GET /market/prices`

**Query Parameters:**
- `commodity` (optional) - Crop type (MAIZE, BEANS, etc.)
- `market` (optional) - Market location
- `date` (optional) - Specific date (default: latest)

**Response:** `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "id": "price_123",
      "commodity": "MAIZE",
      "market": "KIGALI_KIMIRONKO",
      "price": 500,
      "unit": "kg",
      "minPrice": 450,
      "maxPrice": 550,
      "avgPrice": 500,
      "quality": "A",
      "priceChange": 5.2,
      "trend": "UP",
      "source": "MINAGRI",
      "date": "2024-01-15",
      "updatedAt": "2024-01-15T06:00:00Z"
    }
  ]
}
```

---

### 5.2 Get Price Trends

**Endpoint:** `GET /market/prices/trends`

**Query Parameters:**
- `commodity` (required) - Crop type
- `market` (required) - Market location
- `period` (optional) - 7d, 30d, 90d (default: 30d)

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "commodity": "MAIZE",
    "market": "KIGALI_KIMIRONKO",
    "period": "30d",
    "trends": [
      {
        "date": "2024-01-01",
        "price": 480,
        "change": 0
      },
      {
        "date": "2024-01-08",
        "price": 490,
        "change": 2.08
      },
      {
        "date": "2024-01-15",
        "price": 500,
        "change": 2.04
      }
    ],
    "statistics": {
      "highest": 510,
      "lowest": 470,
      "average": 493,
      "volatility": "LOW"
    }
  }
}
```

---

## 6. E-Marketplace Endpoints

### 6.1 Get Marketplace Listings

**Endpoint:** `GET /marketplace/listings`

**Query Parameters:**
- `cropType` (optional) - Filter by crop type
- `district` (optional) - Filter by location
- `qualityGrade` (optional) - GRADE_A, GRADE_B, GRADE_C
- `minPrice` (optional) - Minimum price per unit
- `maxPrice` (optional) - Maximum price per unit
- `status` (optional) - ACTIVE, SOLD, CANCELLED
- `limit` (optional) - Results per page (default: 20)
- `offset` (optional) - Pagination offset

**Response:** `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "id": "listing_123",
      "userId": "user_456",
      "user": {
        "id": "user_456",
        "fullName": "John Farmer",
        "phoneNumber": "+250788123456",
        "district": "Nyagatare"
      },
      "cropType": "MAIZE",
      "variety": "Hybrid",
      "quantity": 1000,
      "unit": "kg",
      "qualityGrade": "GRADE_A",
      "pricePerUnit": 500,
      "totalPrice": 500000,
      "negotiable": true,
      "description": "Fresh maize harvest, properly dried",
      "images": [
        "https://cloudinary.com/image1.jpg",
        "https://cloudinary.com/image2.jpg"
      ],
      "harvestDate": "2024-01-10",
      "location": "Nyagatare, Rwimiyaga",
      "district": "Nyagatare",
      "canDeliver": true,
      "deliveryCost": 5000,
      "status": "ACTIVE",
      "views": 45,
      "createdAt": "2024-01-12T08:00:00Z"
    }
  ],
  "pagination": {
    "total": 156,
    "limit": 20,
    "offset": 0,
    "hasMore": true
  }
}
```

---

### 6.2 Create Listing

**Endpoint:** `POST /marketplace/listings`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "cropType": "BEANS",
  "variety": "Climbing",
  "quantity": 500,
  "unit": "kg",
  "qualityGrade": "GRADE_A",
  "pricePerUnit": 800,
  "negotiable": true,
  "description": "High-quality climbing beans",
  "harvestDate": "2024-01-10",
  "availableFrom": "2024-01-15",
  "availableUntil": "2024-02-15",
  "location": "Kigali, Kimironko",
  "district": "Kigali",
  "canDeliver": false
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "Listing created successfully",
  "data": {
    "id": "listing_789",
    "cropType": "BEANS",
    "quantity": 500,
    "pricePerUnit": 800,
    "totalPrice": 400000,
    "status": "ACTIVE",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}
```

---

### 6.3 Get Listing Details

**Endpoint:** `GET /marketplace/listings/{listingId}`

**Response:** `200 OK`

---

### 6.4 Make Offer

**Endpoint:** `POST /marketplace/listings/{listingId}/offers`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "quantity": 300,
  "pricePerUnit": 750,
  "message": "Can you deliver to Musanze?"
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "Offer submitted successfully",
  "data": {
    "id": "offer_123",
    "listingId": "listing_789",
    "buyerId": "user_456",
    "quantity": 300,
    "pricePerUnit": 750,
    "totalPrice": 225000,
    "status": "PENDING",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}
```

---

### 6.5 Create Order

**Endpoint:** `POST /marketplace/orders`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "listingId": "listing_789",
  "quantity": 500,
  "paymentMethod": "MOBILE_MONEY",
  "deliveryAddress": "Musanze, Muhoza Sector",
  "notes": "Please call before delivery"
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "Order created successfully",
  "data": {
    "id": "order_456",
    "orderNumber": "AGV-2024-001",
    "listingId": "listing_789",
    "sellerId": "user_123",
    "buyerId": "user_456",
    "quantity": 500,
    "pricePerUnit": 800,
    "subtotal": 400000,
    "commission": 8000,
    "deliveryCost": 0,
    "totalAmount": 408000,
    "status": "PENDING",
    "paymentMethod": "MOBILE_MONEY",
    "paymentStatus": "PENDING",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}
```

---

## 7. Weather Endpoints

### 7.1 Get Weather Data

**Endpoint:** `GET /weather`

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `location` (required) - Location name or coordinates
- `forecast` (optional) - Include 7-day forecast (true/false)
- `farmId` (optional) - Get weather for specific farm

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "current": {
      "location": "Kigali",
      "latitude": -1.9536,
      "longitude": 30.0606,
      "temperature": 24,
      "feelsLike": 26,
      "humidity": 60,
      "pressure": 1013,
      "windSpeed": 12,
      "windDirection": 45,
      "cloudCover": 40,
      "uvIndex": 6,
      "visibility": 10,
      "condition": "Partly Cloudy",
      "description": "Partly cloudy with light winds",
      "icon": "partly-cloudy",
      "rainfall": 0,
      "rainProbability": 20,
      "soilMoisture": 65,
      "date": "2024-01-15T12:00:00Z"
    },
    "forecast": [
      {
        "date": "2024-01-16",
        "tempMax": 26,
        "tempMin": 18,
        "condition": "Rain",
        "rainProbability": 80,
        "rainfall": 15,
        "humidity": 75,
        "windSpeed": 15
      }
    ],
    "alerts": [
      {
        "type": "WEATHER",
        "priority": "HIGH",
        "title": "Heavy rain expected",
        "message": "Heavy rain expected tomorrow morning. Don't irrigate your crops today.",
        "validFrom": "2024-01-16T06:00:00Z",
        "validUntil": "2024-01-16T12:00:00Z"
      }
    ]
  }
}
```

---

## 8. Learning Content Endpoints

### 8.1 Get Learning Content

**Endpoint:** `GET /learning/content`

**Query Parameters:**
- `category` (optional) - Content category
- `type` (optional) - VIDEO, ARTICLE, PDF
- `cropType` (optional) - Filter by crop
- `language` (optional) - Content language
- `featured` (optional) - Featured content only

**Response:** `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "id": "content_123",
      "title": "How to Plant Maize Properly",
      "titleRw": "Uburyo bwo gutera ibigori neza",
      "description": "Learn the proper technique for planting maize...",
      "type": "VIDEO",
      "category": "PLANTING",
      "content": "https://youtube.com/watch?v=...",
      "thumbnail": "https://cloudinary.com/...",
      "duration": 765,
      "crops": ["MAIZE"],
      "difficulty": "BEGINNER",
      "views": 1245,
      "likes": 98,
      "published": true,
      "featured": true,
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ]
}
```

---

## 9. Forum Endpoints

### 9.1 Get Forum Posts

**Endpoint:** `GET /forum/posts`

**Query Parameters:**
- `category` (optional) - QUESTION, DISCUSSION, SHOWCASE, TIP
- `cropType` (optional) - Filter by crop
- `solved` (optional) - Filter solved questions
- `limit` (optional)
- `offset` (optional)

**Response:** `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "id": "post_123",
      "userId": "user_456",
      "user": {
        "id": "user_456",
        "fullName": "John Farmer",
        "role": "FARMER"
      },
      "title": "Brown spots on tomato leaves",
      "content": "I noticed brown spots appearing on my tomato leaves...",
      "images": ["https://cloudinary.com/..."],
      "category": "QUESTION",
      "crops": ["TOMATOES"],
      "tags": ["disease", "tomatoes"],
      "views": 45,
      "upvotes": 8,
      "solved": true,
      "pinned": false,
      "createdAt": "2024-01-15T08:00:00Z",
      "comments": [
        {
          "id": "comment_789",
          "userId": "expert_123",
          "user": {
            "fullName": "Expert Sarah",
            "role": "EXPERT"
          },
          "content": "This looks like early blight...",
          "expertAnswer": true,
          "acceptedAnswer": true,
          "upvotes": 12,
          "createdAt": "2024-01-15T09:00:00Z"
        }
      ]
    }
  ]
}
```

---

### 9.2 Create Forum Post

**Endpoint:** `POST /forum/posts`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "title": "Best time to plant beans in Nyagatare?",
  "content": "I'm planning to plant beans next month...",
  "category": "QUESTION",
  "crops": ["BEANS"],
  "tags": ["planting", "timing", "beans"]
}
```

**Response:** `201 Created`

---

## 10. Notifications Endpoints

### 10.1 Get Notifications

**Endpoint:** `GET /notifications`

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `read` (optional) - Filter by read status
- `type` (optional) - Notification type
- `limit` (optional)

**Response:** `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "id": "notif_123",
      "userId": "user_456",
      "type": "WEATHER_ALERT",
      "title": "Heavy Rain Alert",
      "message": "Heavy rain expected tomorrow",
      "data": {
        "alertId": "alert_789"
      },
      "read": false,
      "createdAt": "2024-01-15T06:00:00Z"
    }
  ],
  "unreadCount": 5
}
```

---

### 10.2 Mark Notification as Read

**Endpoint:** `PUT /notifications/{notificationId}/read`

**Headers:** `Authorization: Bearer <token>`

**Response:** `200 OK`

---

## Error Responses

All error responses follow this format:

```json
{
  "success": false,
  "message": "Error description",
  "errors": [
    {
      "field": "email",
      "message": "Invalid email format"
    }
  ]
}
```

### Common HTTP Status Codes

- `200 OK` - Success
- `201 Created` - Resource created
- `400 Bad Request` - Invalid input
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `409 Conflict` - Resource already exists
- `422 Unprocessable Entity` - Validation failed
- `429 Too Many Requests` - Rate limit exceeded
- `500 Internal Server Error` - Server error
- `503 Service Unavailable` - Service temporarily unavailable

---

## Rate Limiting

API requests are rate-limited based on subscription tier:

- **Free**: 100 requests/hour
- **Basic**: 500 requests/hour
- **Premium**: 2000 requests/hour
- **Enterprise**: Unlimited

Rate limit headers:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1642252800
```

---

## Webhooks

Configure webhooks to receive real-time updates:

### Available Events
- `order.created`
- `order.completed`
- `offer.received`
- `diagnosis.completed`
- `payment.success`
- `payment.failed`

### Webhook Payload
```json
{
  "event": "order.created",
  "timestamp": "2024-01-15T10:30:00Z",
  "data": {
    "orderId": "order_456",
    "status": "PENDING"
  }
}
```

---

## SDKs & Libraries

Official SDKs coming soon:
- Flutter/Dart SDK
- JavaScript/TypeScript SDK
- Python SDK

---

## Support

- **Email**: api@agrovision.rw
- **Documentation**: https://docs.agrovision.rw
- **Status Page**: https://status.agrovision.rw
