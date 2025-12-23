import { NextRequest } from 'next/server';
import prisma from '@/lib/prisma';
import { authMiddleware } from '@/middleware/auth';
import { successResponse, errorResponse, handleApiError } from '@/utils/apiResponse';

interface RouteContext {
  params: { id: string };
}

// GET single farm
export const GET = authMiddleware(async (req: NextRequest, context: RouteContext) => {
  try {
    const user = (req as any).user;
    const { id } = context.params;

    const farm = await prisma.farm.findFirst({
      where: {
        id,
        userId: user.userId,
      },
      include: {
        crops: {
          where: { active: true },
          include: {
            diagnoses: {
              orderBy: { createdAt: 'desc' },
              take: 5,
            },
            recommendations: {
              where: { applied: false },
              orderBy: { priority: 'desc' },
            },
          },
        },
        weatherData: {
          orderBy: { date: 'desc' },
          take: 7,
        },
      },
    });

    if (!farm) {
      return errorResponse('Farm not found', 404);
    }

    return successResponse(farm);
  } catch (error) {
    return handleApiError(error);
  }
});

// PUT update farm
export const PUT = authMiddleware(async (req: NextRequest, context: RouteContext) => {
  try {
    const user = (req as any).user;
    const { id } = context.params;
    const body = await req.json();

    const farm = await prisma.farm.findFirst({
      where: { id, userId: user.userId },
    });

    if (!farm) {
      return errorResponse('Farm not found', 404);
    }

    const updatedFarm = await prisma.farm.update({
      where: { id },
      data: body,
    });

    return successResponse(updatedFarm, 'Farm updated successfully');
  } catch (error) {
    return handleApiError(error);
  }
});

// DELETE farm
export const DELETE = authMiddleware(async (req: NextRequest, context: RouteContext) => {
  try {
    const user = (req as any).user;
    const { id } = context.params;

    const farm = await prisma.farm.findFirst({
      where: { id, userId: user.userId },
    });

    if (!farm) {
      return errorResponse('Farm not found', 404);
    }

    await prisma.farm.delete({
      where: { id },
    });

    return successResponse(null, 'Farm deleted successfully');
  } catch (error) {
    return handleApiError(error);
  }
});
