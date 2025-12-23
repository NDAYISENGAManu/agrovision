// Notifications API route
import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiResponse, apiError } from '@/utils/apiResponse';
import { requireAuth } from '@/middleware/auth';

// GET - Get user notifications
export async function GET(request: NextRequest) {
  const userOrError = await requireAuth(request);
  if (userOrError instanceof Response) return userOrError;

  try {
    const { searchParams } = new URL(request.url);
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '20');
    const unreadOnly = searchParams.get('unreadOnly') === 'true';

    const skip = (page - 1) * limit;

    const where: any = { userId: userOrError.id };
    if (unreadOnly) where.read = false;

    const [notifications, total, unreadCount] = await Promise.all([
      prisma.notification.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      prisma.notification.count({ where }),
      prisma.notification.count({
        where: { userId: userOrError.id, read: false },
      }),
    ]);

    return apiResponse({
      notifications,
      unreadCount,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error('Get notifications error:', error);
    return apiError('Failed to fetch notifications', 500);
  }
}

// PUT - Mark notifications as read
export async function PUT(request: NextRequest) {
  const userOrError = await requireAuth(request);
  if (userOrError instanceof Response) return userOrError;

  try {
    const body = await request.json();
    const { notificationIds, markAll } = body;

    if (markAll) {
      await prisma.notification.updateMany({
        where: { userId: userOrError.id, read: false },
        data: { read: true },
      });
    } else if (notificationIds?.length > 0) {
      await prisma.notification.updateMany({
        where: {
          id: { in: notificationIds },
          userId: userOrError.id,
        },
        data: { read: true },
      });
    }

    return apiResponse({ success: true, message: 'Notifications marked as read' });
  } catch (error) {
    console.error('Update notifications error:', error);
    return apiError('Failed to update notifications', 500);
  }
}
