-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('FARMER', 'BUYER', 'EXPERT', 'ADMIN');

-- CreateEnum
CREATE TYPE "SubscriptionTier" AS ENUM ('FREE', 'BASIC', 'PREMIUM', 'ENTERPRISE');

-- CreateEnum
CREATE TYPE "CropType" AS ENUM ('MAIZE', 'BEANS', 'POTATOES', 'RICE', 'WHEAT', 'CASSAVA', 'SWEET_POTATO', 'COFFEE', 'TEA', 'BANANA', 'TOMATOES', 'ONIONS', 'CARROTS', 'CABBAGE', 'PEPPERS', 'AVOCADO', 'MANGO', 'PINEAPPLE', 'OTHER');

-- CreateEnum
CREATE TYPE "CropStage" AS ENUM ('SEED_PREPARATION', 'PLANTING', 'GERMINATION', 'VEGETATIVE', 'FLOWERING', 'FRUITING', 'MATURATION', 'HARVEST_READY', 'HARVESTED');

-- CreateEnum
CREATE TYPE "SoilType" AS ENUM ('CLAY', 'SANDY', 'LOAMY', 'SILT', 'PEAT', 'CHALKY');

-- CreateEnum
CREATE TYPE "DiseaseSeverity" AS ENUM ('MILD', 'MODERATE', 'SEVERE', 'CRITICAL');

-- CreateEnum
CREATE TYPE "MarketLocation" AS ENUM ('KIGALI_KIMISAGARA', 'KIGALI_KIMIRONKO', 'MUSANZE', 'HUYE', 'RUBAVU', 'RUSIZI', 'NYAGATARE', 'RWAMAGANA', 'MUHANGA', 'KARONGI');

-- CreateEnum
CREATE TYPE "ListingStatus" AS ENUM ('ACTIVE', 'SOLD', 'CANCELLED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "QualityGrade" AS ENUM ('GRADE_A', 'GRADE_B', 'GRADE_C');

-- CreateEnum
CREATE TYPE "OfferStatus" AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('PENDING', 'CONFIRMED', 'IN_TRANSIT', 'DELIVERED', 'COMPLETED', 'CANCELLED', 'DISPUTED');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('MOBILE_MONEY', 'BANK_TRANSFER', 'CASH', 'STRIPE');

-- CreateEnum
CREATE TYPE "AlertType" AS ENUM ('WEATHER', 'DISEASE', 'IRRIGATION', 'FERTILIZER', 'PESTICIDE', 'HARVEST', 'MARKET', 'PRICE_CHANGE', 'SYSTEM');

-- CreateEnum
CREATE TYPE "AlertPriority" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL');

-- CreateEnum
CREATE TYPE "ContentType" AS ENUM ('VIDEO', 'ARTICLE', 'PDF', 'INFOGRAPHIC');

-- CreateEnum
CREATE TYPE "ContentCategory" AS ENUM ('PLANTING', 'FERTILIZATION', 'PEST_MANAGEMENT', 'DISEASE_CONTROL', 'IRRIGATION', 'HARVESTING', 'POST_HARVEST', 'MARKET_SKILLS', 'BUSINESS', 'WEATHER', 'SOIL_MANAGEMENT');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "phoneNumber" TEXT NOT NULL,
    "email" TEXT,
    "password" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "role" "UserRole" NOT NULL DEFAULT 'FARMER',
    "profileImage" TEXT,
    "language" TEXT NOT NULL DEFAULT 'en',
    "district" TEXT,
    "sector" TEXT,
    "cell" TEXT,
    "village" TEXT,
    "subscriptionTier" "SubscriptionTier" NOT NULL DEFAULT 'FREE',
    "subscriptionStart" TIMESTAMP(3),
    "subscriptionEnd" TIMESTAMP(3),
    "aiScansRemaining" INTEGER NOT NULL DEFAULT 0,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "verificationCode" TEXT,
    "resetToken" TEXT,
    "resetTokenExpiry" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "lastLogin" TIMESTAMP(3),

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ExpertProfile" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "specialization" TEXT[],
    "experience" INTEGER NOT NULL,
    "certification" TEXT,
    "rating" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalConsults" INTEGER NOT NULL DEFAULT 0,
    "bio" TEXT,
    "available" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ExpertProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Farm" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "size" DOUBLE PRECISION NOT NULL,
    "soilType" "SoilType",
    "waterSource" TEXT,
    "district" TEXT NOT NULL,
    "sector" TEXT NOT NULL,
    "cell" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Farm_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Crop" (
    "id" TEXT NOT NULL,
    "farmId" TEXT NOT NULL,
    "cropType" "CropType" NOT NULL,
    "variety" TEXT,
    "plantingDate" TIMESTAMP(3) NOT NULL,
    "expectedHarvestDate" TIMESTAMP(3),
    "actualHarvestDate" TIMESTAMP(3),
    "area" DOUBLE PRECISION NOT NULL,
    "stage" "CropStage" NOT NULL DEFAULT 'PLANTING',
    "seedCost" DOUBLE PRECISION,
    "fertilizerCost" DOUBLE PRECISION,
    "pesticideCost" DOUBLE PRECISION,
    "laborCost" DOUBLE PRECISION,
    "otherCosts" DOUBLE PRECISION,
    "totalCost" DOUBLE PRECISION,
    "expectedYield" DOUBLE PRECISION,
    "actualYield" DOUBLE PRECISION,
    "yieldPerHectare" DOUBLE PRECISION,
    "fertilizerSchedule" JSONB,
    "pesticideSchedule" JSONB,
    "irrigationSchedule" JSONB,
    "notes" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Crop_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Diagnosis" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "cropId" TEXT,
    "imageUrl" TEXT NOT NULL,
    "cropType" "CropType" NOT NULL,
    "diseaseName" TEXT NOT NULL,
    "confidence" DOUBLE PRECISION NOT NULL,
    "severity" "DiseaseSeverity" NOT NULL,
    "symptoms" TEXT[],
    "causes" TEXT[],
    "treatments" JSONB NOT NULL,
    "pesticides" JSONB,
    "organicSolutions" JSONB,
    "preventiveMeasures" TEXT[],
    "estimatedCost" DOUBLE PRECISION,
    "treated" BOOLEAN NOT NULL DEFAULT false,
    "treatmentApplied" TEXT,
    "treatmentDate" TIMESTAMP(3),
    "resolved" BOOLEAN NOT NULL DEFAULT false,
    "location" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Diagnosis_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MarketPrice" (
    "id" TEXT NOT NULL,
    "commodity" "CropType" NOT NULL,
    "market" "MarketLocation" NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "unit" TEXT NOT NULL DEFAULT 'kg',
    "quality" TEXT,
    "minPrice" DOUBLE PRECISION,
    "maxPrice" DOUBLE PRECISION,
    "avgPrice" DOUBLE PRECISION NOT NULL,
    "source" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "priceChange" DOUBLE PRECISION,
    "trend" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MarketPrice_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MarketListing" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "cropType" "CropType" NOT NULL,
    "variety" TEXT,
    "quantity" DOUBLE PRECISION NOT NULL,
    "unit" TEXT NOT NULL DEFAULT 'kg',
    "qualityGrade" "QualityGrade" NOT NULL,
    "pricePerUnit" DOUBLE PRECISION NOT NULL,
    "totalPrice" DOUBLE PRECISION NOT NULL,
    "negotiable" BOOLEAN NOT NULL DEFAULT true,
    "description" TEXT,
    "images" TEXT[],
    "harvestDate" TIMESTAMP(3),
    "availableFrom" TIMESTAMP(3) NOT NULL,
    "availableUntil" TIMESTAMP(3),
    "location" TEXT NOT NULL,
    "district" TEXT NOT NULL,
    "canDeliver" BOOLEAN NOT NULL DEFAULT false,
    "deliveryCost" DOUBLE PRECISION,
    "status" "ListingStatus" NOT NULL DEFAULT 'ACTIVE',
    "views" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MarketListing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Offer" (
    "id" TEXT NOT NULL,
    "listingId" TEXT NOT NULL,
    "buyerId" TEXT NOT NULL,
    "quantity" DOUBLE PRECISION NOT NULL,
    "pricePerUnit" DOUBLE PRECISION NOT NULL,
    "totalPrice" DOUBLE PRECISION NOT NULL,
    "message" TEXT,
    "status" "OfferStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Offer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Order" (
    "id" TEXT NOT NULL,
    "orderNumber" TEXT NOT NULL,
    "listingId" TEXT NOT NULL,
    "sellerId" TEXT NOT NULL,
    "buyerId" TEXT NOT NULL,
    "quantity" DOUBLE PRECISION NOT NULL,
    "pricePerUnit" DOUBLE PRECISION NOT NULL,
    "subtotal" DOUBLE PRECISION NOT NULL,
    "commission" DOUBLE PRECISION NOT NULL,
    "deliveryCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalAmount" DOUBLE PRECISION NOT NULL,
    "status" "OrderStatus" NOT NULL DEFAULT 'PENDING',
    "paymentMethod" "PaymentMethod",
    "paymentStatus" TEXT,
    "deliveryAddress" TEXT,
    "deliveryDate" TIMESTAMP(3),
    "completedDate" TIMESTAMP(3),
    "sellerRating" INTEGER,
    "buyerRating" INTEGER,
    "review" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Payment" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "orderId" TEXT,
    "type" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'RWF',
    "paymentMethod" "PaymentMethod" NOT NULL,
    "transactionId" TEXT,
    "status" TEXT NOT NULL,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Payment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WeatherData" (
    "id" TEXT NOT NULL,
    "farmId" TEXT,
    "location" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "temperature" DOUBLE PRECISION NOT NULL,
    "feelsLike" DOUBLE PRECISION NOT NULL,
    "humidity" INTEGER NOT NULL,
    "pressure" INTEGER NOT NULL,
    "windSpeed" DOUBLE PRECISION NOT NULL,
    "windDirection" INTEGER NOT NULL,
    "cloudCover" INTEGER NOT NULL,
    "uvIndex" DOUBLE PRECISION,
    "visibility" DOUBLE PRECISION,
    "condition" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "icon" TEXT NOT NULL,
    "rainfall" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "rainProbability" INTEGER,
    "soilMoisture" DOUBLE PRECISION,
    "isForecast" BOOLEAN NOT NULL DEFAULT false,
    "forecastDate" TIMESTAMP(3),
    "date" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WeatherData_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Alert" (
    "id" TEXT NOT NULL,
    "type" "AlertType" NOT NULL,
    "priority" "AlertPriority" NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "actionable" BOOLEAN NOT NULL DEFAULT false,
    "action" TEXT,
    "location" TEXT,
    "cropType" "CropType",
    "validFrom" TIMESTAMP(3) NOT NULL,
    "validUntil" TIMESTAMP(3),
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Alert_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "data" JSONB,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "sent" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Recommendation" (
    "id" TEXT NOT NULL,
    "cropId" TEXT,
    "type" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "reasoning" TEXT,
    "priority" INTEGER NOT NULL DEFAULT 3,
    "confidence" DOUBLE PRECISION,
    "estimatedBenefit" TEXT,
    "estimatedCost" DOUBLE PRECISION,
    "actionItems" JSONB,
    "timing" TEXT,
    "applied" BOOLEAN NOT NULL DEFAULT false,
    "appliedDate" TIMESTAMP(3),
    "feedback" INTEGER,
    "feedbackNote" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3),

    CONSTRAINT "Recommendation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LearningContent" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "titleRw" TEXT,
    "titleSw" TEXT,
    "titleFr" TEXT,
    "description" TEXT NOT NULL,
    "descriptionRw" TEXT,
    "descriptionSw" TEXT,
    "descriptionFr" TEXT,
    "type" "ContentType" NOT NULL,
    "category" "ContentCategory" NOT NULL,
    "content" TEXT NOT NULL,
    "thumbnail" TEXT,
    "duration" INTEGER,
    "crops" "CropType"[],
    "difficulty" TEXT,
    "views" INTEGER NOT NULL DEFAULT 0,
    "likes" INTEGER NOT NULL DEFAULT 0,
    "published" BOOLEAN NOT NULL DEFAULT true,
    "featured" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "LearningContent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ForumPost" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "images" TEXT[],
    "category" TEXT NOT NULL,
    "crops" "CropType"[],
    "tags" TEXT[],
    "views" INTEGER NOT NULL DEFAULT 0,
    "upvotes" INTEGER NOT NULL DEFAULT 0,
    "solved" BOOLEAN NOT NULL DEFAULT false,
    "pinned" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ForumPost_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ForumComment" (
    "id" TEXT NOT NULL,
    "postId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "images" TEXT[],
    "upvotes" INTEGER NOT NULL DEFAULT 0,
    "expertAnswer" BOOLEAN NOT NULL DEFAULT false,
    "acceptedAnswer" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ForumComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChatRoom" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "type" TEXT NOT NULL,
    "participants" TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ChatRoom_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChatMessage" (
    "id" TEXT NOT NULL,
    "roomId" TEXT NOT NULL,
    "senderId" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'text',
    "attachments" TEXT[],
    "read" BOOLEAN NOT NULL DEFAULT false,
    "readBy" TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ChatMessage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Analytics" (
    "id" TEXT NOT NULL,
    "eventType" TEXT NOT NULL,
    "userId" TEXT,
    "data" JSONB NOT NULL,
    "userAgent" TEXT,
    "ipAddress" TEXT,
    "location" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Analytics_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_phoneNumber_key" ON "User"("phoneNumber");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_phoneNumber_idx" ON "User"("phoneNumber");

-- CreateIndex
CREATE INDEX "User_email_idx" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_district_sector_idx" ON "User"("district", "sector");

-- CreateIndex
CREATE UNIQUE INDEX "ExpertProfile_userId_key" ON "ExpertProfile"("userId");

-- CreateIndex
CREATE INDEX "Farm_userId_idx" ON "Farm"("userId");

-- CreateIndex
CREATE INDEX "Farm_district_sector_idx" ON "Farm"("district", "sector");

-- CreateIndex
CREATE INDEX "Crop_farmId_idx" ON "Crop"("farmId");

-- CreateIndex
CREATE INDEX "Crop_cropType_idx" ON "Crop"("cropType");

-- CreateIndex
CREATE INDEX "Crop_stage_idx" ON "Crop"("stage");

-- CreateIndex
CREATE INDEX "Diagnosis_userId_idx" ON "Diagnosis"("userId");

-- CreateIndex
CREATE INDEX "Diagnosis_cropId_idx" ON "Diagnosis"("cropId");

-- CreateIndex
CREATE INDEX "Diagnosis_diseaseName_idx" ON "Diagnosis"("diseaseName");

-- CreateIndex
CREATE INDEX "Diagnosis_createdAt_idx" ON "Diagnosis"("createdAt");

-- CreateIndex
CREATE INDEX "MarketPrice_commodity_market_idx" ON "MarketPrice"("commodity", "market");

-- CreateIndex
CREATE INDEX "MarketPrice_date_idx" ON "MarketPrice"("date");

-- CreateIndex
CREATE UNIQUE INDEX "MarketPrice_commodity_market_date_key" ON "MarketPrice"("commodity", "market", "date");

-- CreateIndex
CREATE INDEX "MarketListing_userId_idx" ON "MarketListing"("userId");

-- CreateIndex
CREATE INDEX "MarketListing_cropType_idx" ON "MarketListing"("cropType");

-- CreateIndex
CREATE INDEX "MarketListing_status_idx" ON "MarketListing"("status");

-- CreateIndex
CREATE INDEX "MarketListing_district_idx" ON "MarketListing"("district");

-- CreateIndex
CREATE INDEX "MarketListing_createdAt_idx" ON "MarketListing"("createdAt");

-- CreateIndex
CREATE INDEX "Offer_listingId_idx" ON "Offer"("listingId");

-- CreateIndex
CREATE INDEX "Offer_buyerId_idx" ON "Offer"("buyerId");

-- CreateIndex
CREATE INDEX "Offer_status_idx" ON "Offer"("status");

-- CreateIndex
CREATE UNIQUE INDEX "Order_orderNumber_key" ON "Order"("orderNumber");

-- CreateIndex
CREATE INDEX "Order_sellerId_idx" ON "Order"("sellerId");

-- CreateIndex
CREATE INDEX "Order_buyerId_idx" ON "Order"("buyerId");

-- CreateIndex
CREATE INDEX "Order_status_idx" ON "Order"("status");

-- CreateIndex
CREATE INDEX "Order_createdAt_idx" ON "Order"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_orderId_key" ON "Payment"("orderId");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_transactionId_key" ON "Payment"("transactionId");

-- CreateIndex
CREATE INDEX "Payment_userId_idx" ON "Payment"("userId");

-- CreateIndex
CREATE INDEX "Payment_status_idx" ON "Payment"("status");

-- CreateIndex
CREATE INDEX "Payment_createdAt_idx" ON "Payment"("createdAt");

-- CreateIndex
CREATE INDEX "WeatherData_location_idx" ON "WeatherData"("location");

-- CreateIndex
CREATE INDEX "WeatherData_date_idx" ON "WeatherData"("date");

-- CreateIndex
CREATE INDEX "WeatherData_farmId_idx" ON "WeatherData"("farmId");

-- CreateIndex
CREATE UNIQUE INDEX "WeatherData_location_date_isForecast_key" ON "WeatherData"("location", "date", "isForecast");

-- CreateIndex
CREATE INDEX "Alert_type_idx" ON "Alert"("type");

-- CreateIndex
CREATE INDEX "Alert_location_idx" ON "Alert"("location");

-- CreateIndex
CREATE INDEX "Alert_active_idx" ON "Alert"("active");

-- CreateIndex
CREATE INDEX "Alert_validFrom_idx" ON "Alert"("validFrom");

-- CreateIndex
CREATE INDEX "Notification_userId_read_idx" ON "Notification"("userId", "read");

-- CreateIndex
CREATE INDEX "Notification_createdAt_idx" ON "Notification"("createdAt");

-- CreateIndex
CREATE INDEX "Recommendation_cropId_idx" ON "Recommendation"("cropId");

-- CreateIndex
CREATE INDEX "Recommendation_type_idx" ON "Recommendation"("type");

-- CreateIndex
CREATE INDEX "Recommendation_applied_idx" ON "Recommendation"("applied");

-- CreateIndex
CREATE INDEX "LearningContent_category_idx" ON "LearningContent"("category");

-- CreateIndex
CREATE INDEX "LearningContent_type_idx" ON "LearningContent"("type");

-- CreateIndex
CREATE INDEX "LearningContent_published_idx" ON "LearningContent"("published");

-- CreateIndex
CREATE INDEX "ForumPost_userId_idx" ON "ForumPost"("userId");

-- CreateIndex
CREATE INDEX "ForumPost_category_idx" ON "ForumPost"("category");

-- CreateIndex
CREATE INDEX "ForumPost_createdAt_idx" ON "ForumPost"("createdAt");

-- CreateIndex
CREATE INDEX "ForumComment_postId_idx" ON "ForumComment"("postId");

-- CreateIndex
CREATE INDEX "ForumComment_userId_idx" ON "ForumComment"("userId");

-- CreateIndex
CREATE INDEX "ForumComment_createdAt_idx" ON "ForumComment"("createdAt");

-- CreateIndex
CREATE INDEX "ChatRoom_participants_idx" ON "ChatRoom"("participants");

-- CreateIndex
CREATE INDEX "ChatMessage_roomId_idx" ON "ChatMessage"("roomId");

-- CreateIndex
CREATE INDEX "ChatMessage_senderId_idx" ON "ChatMessage"("senderId");

-- CreateIndex
CREATE INDEX "ChatMessage_createdAt_idx" ON "ChatMessage"("createdAt");

-- CreateIndex
CREATE INDEX "Analytics_eventType_idx" ON "Analytics"("eventType");

-- CreateIndex
CREATE INDEX "Analytics_userId_idx" ON "Analytics"("userId");

-- CreateIndex
CREATE INDEX "Analytics_createdAt_idx" ON "Analytics"("createdAt");

-- AddForeignKey
ALTER TABLE "ExpertProfile" ADD CONSTRAINT "ExpertProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Farm" ADD CONSTRAINT "Farm_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Crop" ADD CONSTRAINT "Crop_farmId_fkey" FOREIGN KEY ("farmId") REFERENCES "Farm"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Diagnosis" ADD CONSTRAINT "Diagnosis_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Diagnosis" ADD CONSTRAINT "Diagnosis_cropId_fkey" FOREIGN KEY ("cropId") REFERENCES "Crop"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MarketListing" ADD CONSTRAINT "MarketListing_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Offer" ADD CONSTRAINT "Offer_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES "MarketListing"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES "MarketListing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_sellerId_fkey" FOREIGN KEY ("sellerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_buyerId_fkey" FOREIGN KEY ("buyerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "Order"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WeatherData" ADD CONSTRAINT "WeatherData_farmId_fkey" FOREIGN KEY ("farmId") REFERENCES "Farm"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Recommendation" ADD CONSTRAINT "Recommendation_cropId_fkey" FOREIGN KEY ("cropId") REFERENCES "Crop"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ForumPost" ADD CONSTRAINT "ForumPost_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ForumComment" ADD CONSTRAINT "ForumComment_postId_fkey" FOREIGN KEY ("postId") REFERENCES "ForumPost"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ForumComment" ADD CONSTRAINT "ForumComment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChatMessage" ADD CONSTRAINT "ChatMessage_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES "ChatRoom"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChatMessage" ADD CONSTRAINT "ChatMessage_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
