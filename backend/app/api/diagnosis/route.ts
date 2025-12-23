// Disease diagnosis API route
import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiResponse, apiError } from '@/utils/apiResponse';
import { requireAuth } from '@/middleware/auth';

// GET - Get user's diagnosis history
export async function GET(request: NextRequest) {
  const userOrError = await requireAuth(request);
  if (userOrError instanceof Response) return userOrError;

  try {
    const { searchParams } = new URL(request.url);
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '20');
    const cropId = searchParams.get('cropId');

    const skip = (page - 1) * limit;

    const where: any = { userId: userOrError.id };
    if (cropId) where.cropId = cropId;

    const [diagnoses, total] = await Promise.all([
      prisma.diagnosis.findMany({
        where,
        skip,
        take: limit,
        include: {
          crop: {
            select: { id: true, cropType: true, variety: true }
          }
        },
        orderBy: { createdAt: 'desc' },
      }),
      prisma.diagnosis.count({ where }),
    ]);

    return apiResponse({
      diagnoses,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error('Get diagnoses error:', error);
    return apiError('Failed to fetch diagnoses', 500);
  }
}

// POST - Create new diagnosis
export async function POST(request: NextRequest) {
  const userOrError = await requireAuth(request);
  if (userOrError instanceof Response) return userOrError;

  try {
    const formData = await request.formData();
    const imageFile = formData.get('image') as File;
    const cropId = formData.get('cropId') as string;
    const notes = formData.get('notes') as string;

    if (!imageFile) {
      return apiError('Image is required', 400);
    }

    // TODO: Upload image to Cloudinary
    const imageUrl = 'https://placeholder.com/diagnosis-image.jpg';

    // TODO: Run AI model for disease detection
    // For now, return mock diagnosis
    const mockDiseases = [
      { name: 'Late Blight', confidence: 0.94, treatment: 'Apply fungicide containing chlorothalonil or mancozeb' },
      { name: 'Early Blight', confidence: 0.89, treatment: 'Remove affected leaves and apply copper-based fungicide' },
      { name: 'Bacterial Wilt', confidence: 0.87, treatment: 'Remove infected plants, improve drainage' },
      { name: 'Leaf Curl', confidence: 0.92, treatment: 'Use insecticides to control whiteflies' },
      { name: 'Healthy', confidence: 0.96, treatment: 'No treatment needed' },
    ];

    const randomDisease = mockDiseases[Math.floor(Math.random() * mockDiseases.length)];

    const diagnosis = await prisma.diagnosis.create({
      data: {
        userId: userOrError.id,
        cropId: cropId || null,
        imageUrl,
        cropType: 'TOMATOES',
        diseaseName: randomDisease.name,
        confidence: randomDisease.confidence,
        treatments: { treatment: randomDisease.treatment },
        severity: randomDisease.confidence > 0.9 ? 'SEVERE' : randomDisease.confidence > 0.7 ? 'MODERATE' : 'MILD',
        symptoms: [],
        causes: [],
        preventiveMeasures: [],
      },
      include: {
        crop: true,
      },
    });

    // Create notification for the user
    await prisma.notification.create({
      data: {
        userId: userOrError.id,
        title: 'Diagnosis Complete',
        message: `Your crop has been diagnosed with ${randomDisease.name} (${Math.round(randomDisease.confidence * 100)}% confidence)`,
        type: 'DIAGNOSIS',
        relatedId: diagnosis.id,
      },
    });

    return apiResponse({ diagnosis }, 'Diagnosis completed successfully');
  } catch (error) {
    console.error('Create diagnosis error:', error);
    return apiError('Failed to create diagnosis', 500);
  }
}
