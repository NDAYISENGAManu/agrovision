import { NextRequest } from 'next/server';
import prisma from '@/lib/prisma';
import { authMiddleware } from '@/middleware/auth';
import { successResponse, handleApiError } from '@/utils/apiResponse';
import { validate, createCropSchema } from '@/utils/validation';

// GET all crops for authenticated user
export const GET = authMiddleware(async (req: NextRequest) => {
  try {
    const user = (req as any).user;
    const { searchParams } = new URL(req.url);
    const farmId = searchParams.get('farmId');
    const active = searchParams.get('active');

    const where: any = {
      farm: { userId: user.userId },
    };

    if (farmId) where.farmId = farmId;
    if (active !== null) where.active = active === 'true';

    const crops = await prisma.crop.findMany({
      where,
      include: {
        farm: {
          select: {
            id: true,
            name: true,
            location: true,
          },
        },
        diagnoses: {
          orderBy: { createdAt: 'desc' },
          take: 3,
        },
        recommendations: {
          where: { applied: false },
          orderBy: { priority: 'desc' },
          take: 5,
        },
        _count: {
          select: {
            diagnoses: true,
            recommendations: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return successResponse(crops);
  } catch (error) {
    return handleApiError(error);
  }
});

// POST create new crop
export const POST = authMiddleware(async (req: NextRequest) => {
  try {
    const user = (req as any).user;
    const body = await req.json();
    const validatedData = validate(createCropSchema, body);

    // Verify farm ownership
    const farm = await prisma.farm.findFirst({
      where: {
        id: validatedData.farmId,
        userId: user.userId,
      },
    });

    if (!farm) {
      return errorResponse('Farm not found', 404);
    }

    // Calculate total cost
    const totalCost =
      (validatedData.seedCost || 0) +
      (validatedData.fertilizerCost || 0) +
      (validatedData.pesticideCost || 0) +
      (validatedData.laborCost || 0);

    const crop = await prisma.crop.create({
      data: {
        ...validatedData,
        totalCost,
        plantingDate: new Date(validatedData.plantingDate),
        expectedHarvestDate: validatedData.expectedHarvestDate
          ? new Date(validatedData.expectedHarvestDate)
          : undefined,
      },
      include: {
        farm: true,
      },
    });

    return successResponse(crop, 'Crop created successfully');
  } catch (error) {
    return handleApiError(error);
  }
});
