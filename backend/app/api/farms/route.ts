import { NextRequest } from 'next/server';
import prisma from '@/lib/prisma';
import { authMiddleware } from '@/middleware/auth';
import { successResponse, handleApiError } from '@/utils/apiResponse';
import { validate, createFarmSchema } from '@/utils/validation';

// GET all farms for authenticated user
export const GET = authMiddleware(async (req: NextRequest) => {
  try {
    const user = (req as any).user;

    const farms = await prisma.farm.findMany({
      where: { userId: user.userId },
      include: {
        crops: {
          where: { active: true },
          orderBy: { createdAt: 'desc' },
        },
        _count: {
          select: { crops: true },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return successResponse(farms);
  } catch (error) {
    return handleApiError(error);
  }
});

// POST create new farm
export const POST = authMiddleware(async (req: NextRequest) => {
  try {
    const user = (req as any).user;
    const body = await req.json();
    const validatedData = validate(createFarmSchema, body);

    const farm = await prisma.farm.create({
      data: {
        ...validatedData,
        userId: user.userId,
      },
      include: {
        crops: true,
      },
    });

    return successResponse(farm, 'Farm created successfully');
  } catch (error) {
    return handleApiError(error);
  }
});
