// Admin users management
import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiResponse, apiError } from '@/utils/apiResponse';
import { requireAdmin } from '@/middleware/adminAuth';

// GET all users with filters
export async function GET(request: NextRequest) {
  const adminOrError = await requireAdmin(request);
  if (adminOrError instanceof Response) return adminOrError;

  try {
    const { searchParams } = new URL(request.url);
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '20');
    const role = searchParams.get('role');
    const verified = searchParams.get('verified');
    const search = searchParams.get('search');

    const skip = (page - 1) * limit;

    const where: any = {};

    if (role) where.role = role;
    if (verified !== null) where.verified = verified === 'true';
    if (search) {
      where.OR = [
        { fullName: { contains: search, mode: 'insensitive' } },
        { email: { contains: search, mode: 'insensitive' } },
        { phoneNumber: { contains: search } },
      ];
    }

    const [users, total] = await Promise.all([
      prisma.user.findMany({
        where,
        skip,
        take: limit,
        select: {
          id: true,
          fullName: true,
          email: true,
          phoneNumber: true,
          role: true,
          subscriptionTier: true,
          createdAt: true,
          _count: {
            select: {
              farms: true,
              diagnoses: true,
            },
          },
        },
        orderBy: { createdAt: 'desc' },
      }),
      prisma.user.count({ where }),
    ]);

    return apiResponse({
      users,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error('Get users error:', error);
    return apiError('Failed to fetch users', 500);
  }
}
