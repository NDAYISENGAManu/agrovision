// Admin marketplace moderation
import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiResponse, apiError } from '@/utils/apiResponse';
import { requireAdmin } from '@/middleware/adminAuth';
import { z } from 'zod';

const moderateSchema = z.object({
  action: z.enum(['APPROVE', 'REJECT', 'SUSPEND']),
  reason: z.string().optional(),
});

// GET listings for moderation
export async function GET(request: NextRequest) {
  const adminOrError = await requireAdmin(request);
  if (adminOrError instanceof Response) return adminOrError;

  try {
    const { searchParams } = new URL(request.url);
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '20');
    const status = searchParams.get('status') || 'PENDING';

    const skip = (page - 1) * limit;

    const [listings, total] = await Promise.all([
      prisma.marketListing.findMany({
        where: { status: status as any },
        skip,
        take: limit,
        include: {
          user: {
            select: {
              id: true,
              fullName: true,
              email: true,
              phoneNumber: true,
            },
          },
        },
        orderBy: { createdAt: 'desc' },
      }),
      prisma.marketListing.count({ where: { status: status as any } }),
    ]);

    return apiResponse({
      listings,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error('Get listings error:', error);
    return apiError('Failed to fetch listings', 500);
  }
}

// PUT moderate listing
export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const adminOrError = await requireAdmin(request);
  if (adminOrError instanceof Response) return adminOrError;

  const { id } = await params;

  try {
    const body = await request.json();
    const { action, reason } = moderateSchema.parse(body);

    const status = action === 'APPROVE' ? 'ACTIVE' : action === 'REJECT' ? 'REJECTED' : 'SUSPENDED';

    const listing = await prisma.marketListing.update({
      where: { id },
      data: {
        status: status as any,
      },
    });

    // Send notification to seller
    await prisma.notification.create({
      data: {
        userId: listing.userId,
        title: `Listing ${action.toLowerCase()}ed`,
        message: reason || `Your listing has been ${action.toLowerCase()}ed by an administrator.`,
        type: 'MARKETPLACE',
      },
    });

    return apiResponse({ listing, message: `Listing ${action.toLowerCase()}ed successfully` });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return apiError('Validation error: ' + error.errors.map(e => e.message).join(', '), 400);
    }
    console.error('Moderate listing error:', error);
    return apiError('Failed to moderate listing', 500);
  }
}
