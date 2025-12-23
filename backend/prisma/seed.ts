// Database seeder
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seed...');

  // Create admin user
  const adminPassword = await bcrypt.hash('Admin@123', 10);
  const admin = await prisma.user.upsert({
    where: { email: 'admin@agrovision.rw' },
    update: {},
    create: {
      fullName: 'Admin User',
      email: 'admin@agrovision.rw',
      phoneNumber: '+250788000000',
      password: adminPassword,
      role: 'ADMIN',
      subscriptionTier: 'ENTERPRISE',
      verified: true,
    },
  });
  console.log('✅ Admin user created:', admin.email);

  // Create test farmer
  const farmerPassword = await bcrypt.hash('Test@123', 10);
  const farmer = await prisma.user.upsert({
    where: { email: 'farmer@test.com' },
    update: {},
    create: {
      fullName: 'Test Farmer',
      email: 'farmer@test.com',
      phoneNumber: '+250788123456',
      password: farmerPassword,
      role: 'FARMER',
      subscriptionTier: 'FREE',
      district: 'Gasabo',
      sector: 'Kimironko',
      verified: true,
    },
  });
  console.log('✅ Test farmer created:', farmer.email);

  // Create test buyer
  const buyer = await prisma.user.upsert({
    where: { email: 'buyer@test.com' },
    update: {},
    create: {
      fullName: 'Test Buyer',
      email: 'buyer@test.com',
      phoneNumber: '+250788654321',
      password: farmerPassword,
      role: 'BUYER',
      subscriptionTier: 'FREE',
      verified: true,
    },
  });
  console.log('✅ Test buyer created:', buyer.email);

  // Create sample farms
  const farm1 = await prisma.farm.create({
    data: {
      name: 'Green Valley Farm',
      userId: farmer.id,
      location: 'Gasabo, Kigali',
      district: 'Gasabo',
      sector: 'Kimironko',
      size: 2.5,
      latitude: -1.9403,
      longitude: 29.8739,
      soilType: 'LOAMY',
    },
  });
  console.log('✅ Farm created:', farm1.name);

  const farm2 = await prisma.farm.create({
    data: {
      name: 'Sunrise Plantation',
      userId: farmer.id,
      location: 'Musanze',
      district: 'Musanze',
      sector: 'Muhoza',
      size: 5.0,
      latitude: -1.5003,
      longitude: 29.6347,
      soilType: 'CLAY',
    },
  });
  console.log('✅ Farm created:', farm2.name);

  // Create sample crops
  const crop1 = await prisma.crop.create({
    data: {
      farmId: farm1.id,
      cropType: 'TOMATOES',
      variety: 'Roma',
      plantingDate: new Date('2024-01-15'),
      expectedHarvestDate: new Date('2024-04-15'),
      area: 1.0,
      stage: 'VEGETATIVE',
    },
  });
  console.log('✅ Crop created:', crop1.cropType);

  const crop2 = await prisma.crop.create({
    data: {
      farmId: farm1.id,
      cropType: 'POTATOES',
      variety: 'Irish',
      plantingDate: new Date('2024-02-01'),
      expectedHarvestDate: new Date('2024-05-01'),
      area: 1.5,
      stage: 'FLOWERING',
    },
  });
  console.log('✅ Crop created:', crop2.cropType);

  const crop3 = await prisma.crop.create({
    data: {
      farmId: farm2.id,
      cropType: 'COFFEE',
      variety: 'Arabica',
      plantingDate: new Date('2023-06-01'),
      expectedHarvestDate: new Date('2024-12-01'),
      area: 3.0,
      stage: 'FRUITING',
    },
  });
  console.log('✅ Crop created:', crop3.cropType);

  // Create sample market prices
  const marketPrices = await Promise.all([
    prisma.marketPrice.create({
      data: {
        commodity: 'TOMATOES',
        market: 'KIGALI_KIMIRONKO',
        price: 800,
        avgPrice: 800,
        minPrice: 600,
        maxPrice: 1000,
        unit: 'kg',
        source: 'MINAGRI',
        date: new Date(),
        trend: 'STABLE',
      },
    }),
    prisma.marketPrice.create({
      data: {
        commodity: 'POTATOES',
        market: 'KIGALI_KIMIRONKO',
        price: 450,
        avgPrice: 450,
        minPrice: 350,
        maxPrice: 550,
        unit: 'kg',
        source: 'MINAGRI',
        date: new Date(),
        trend: 'UP',
      },
    }),
    prisma.marketPrice.create({
      data: {
        commodity: 'MAIZE',
        market: 'MUSANZE',
        price: 350,
        avgPrice: 350,
        minPrice: 300,
        maxPrice: 400,
        unit: 'kg',
        source: 'MINAGRI',
        date: new Date(),
        trend: 'DOWN',
      },
    }),
    prisma.marketPrice.create({
      data: {
        commodity: 'BEANS',
        market: 'HUYE',
        price: 700,
        avgPrice: 700,
        minPrice: 600,
        maxPrice: 800,
        unit: 'kg',
        source: 'MINAGRI',
        date: new Date(),
        trend: 'STABLE',
      },
    }),
    prisma.marketPrice.create({
      data: {
        commodity: 'COFFEE',
        market: 'KIGALI_KIMIRONKO',
        price: 2500,
        avgPrice: 2500,
        minPrice: 2000,
        maxPrice: 3000,
        unit: 'kg',
        source: 'NAEB',
        date: new Date(),
        trend: 'UP',
      },
    }),
  ]);
  console.log('✅ Market prices created:', marketPrices.length);

  // Create sample market listings
  const listing = await prisma.marketListing.create({
    data: {
      userId: farmer.id,
      cropType: 'TOMATOES',
      variety: 'Roma',
      quantity: 500,
      unit: 'kg',
      qualityGrade: 'GRADE_A',
      pricePerUnit: 850,
      totalPrice: 425000,
      description: 'Fresh organic tomatoes from Gasabo',
      location: 'Gasabo, Kigali',
      district: 'Gasabo',
      availableFrom: new Date(),
      status: 'ACTIVE',
      canDeliver: true,
      deliveryCost: 5000,
    },
  });
  console.log('✅ Market listing created:', listing.id);

  // Create sample learning content
  const learningContent = await prisma.learningContent.create({
    data: {
      title: 'Best Practices for Tomato Farming in Rwanda',
      description: 'Learn the optimal techniques for growing tomatoes in Rwanda\'s climate',
      content: 'https://example.com/tomato-farming-guide',
      type: 'ARTICLE',
      category: 'PLANTING',
      crops: ['TOMATOES'],
      duration: 15,
      published: true,
    },
  });
  console.log('✅ Learning content created:', learningContent.title);

  // Create sample forum posts
  const forumPost = await prisma.forumPost.create({
    data: {
      userId: farmer.id,
      title: 'Best time to plant maize in Eastern Province?',
      content: 'I\'m planning to start maize farming in Nyagatare. When is the best planting season?',
      category: 'CROPS',
    },
  });
  console.log('✅ Forum post created:', forumPost.title);

  // Create sample notification
  await prisma.notification.create({
    data: {
      userId: farmer.id,
      title: 'Welcome to AgroVision!',
      message: 'Start by adding your first farm and crops to track your agricultural activities.',
      type: 'SYSTEM',
    },
  });
  console.log('✅ Notification created');

  console.log('');
  console.log('🎉 Database seeding completed successfully!');
  console.log('');
  console.log('📧 Admin credentials:');
  console.log('   Email: admin@agrovision.rw');
  console.log('   Password: Admin@123');
  console.log('');
  console.log('📧 Test farmer credentials:');
  console.log('   Email: farmer@test.com');
  console.log('   Password: Test@123');
}

main()
  .catch((e) => {
    console.error('❌ Seeding failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
