// Admin user management by ID
import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiResponse, apiError } from '@/utils/apiResponse';
import { requireAdmin } from '@/middleware/adminAuth';
import { z } from 'zod';

const updateUserSchema = z.object({
  subscriptionTier: z.enum(['FREE', 'BASIC', 'PREMIUM', 'ENTERPRISE']).optional(),
  role: z.enum(['FARMER', 'BUYER', 'EXPERT', 'ADMIN']).optional(),
  verified: z.boolean().optional(),
});

// GET user details
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const adminOrError = await requireAdmin(request);
  if (adminOrError instanceof Response) return adminOrError;

  const { id } = await params;

  try {
    const user = await prisma.user.findUnique({
      where: { id },
      include: {
        farms: {
          include: {
            crops: true,
          },
        },
        diagnoses: {
          orderBy: { createdAt: 'desc' },
          take: 10,
        },
        marketListings: true,
        orders: true,
        payments: true,
        _count: {
          select: {
            farms: true,
            diagnoses: true,
            marketListings: true,
            orders: true,
          },
        },
      },
    });

    if (!user) {
      return apiError('User not found', 404);
    }

    return apiResponse(user);
  } catch (error) {
    console.error('Get user error:', error);
    return apiError('Failed to fetch user', 500);
  }
}

// PUT update user
export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const adminOrError = await requireAdmin(request);
  if (adminOrError instanceof Response) return adminOrError;

  const { id } = await params;

  try {
    const body = await request.json();
    const data = updateUserSchema.parse(body);

    const user = await prisma.user.update({
      where: { id },
      data,
      select: {
        id: true,
        fullName: true,
        email: true,
        phoneNumber: true,
        role: true,
        verified: true,
        subscriptionTier: true,
      },
    });

    return apiResponse(user, 'User updated successfully');
  } catch (error) {
    if (error instanceof z.ZodError) {
      return apiError('Validation error: ' + JSON.stringify(error.errors), 400);
    }
    console.error('Update user error:', error);
    return apiError('Failed to update user', 500);
  }
}

// DELETE user
export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const adminOrError = await requireAdmin(request);
  if (adminOrError instanceof Response) return adminOrError;

  const { id } = await params;

  try {
    await prisma.user.delete({
      where: { id },
    });

    return apiResponse(null, 'User deleted successfully');
  } catch (error) {
    console.error('Delete user error:', error);
    return apiError('Failed to delete user', 500);
  }
}
