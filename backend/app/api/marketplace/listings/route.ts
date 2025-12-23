// Marketplace listings API route
import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiResponse, apiError } from '@/utils/apiResponse';
import { requireAuth } from '@/middleware/auth';
import { z } from 'zod';

const createListingSchema = z.object({
  cropType: z.enum(['MAIZE', 'BEANS', 'POTATOES', 'RICE', 'WHEAT', 'CASSAVA', 'SWEET_POTATO', 'COFFEE', 'TEA', 'BANANA', 'TOMATOES', 'ONIONS', 'CARROTS', 'CABBAGE', 'PEPPERS', 'AVOCADO', 'MANGO', 'PINEAPPLE', 'OTHER']),
  variety: z.string().optional(),
  description: z.string().min(10).max(1000).optional(),
  quantity: z.number().positive(),
  unit: z.string().default('kg'),
  qualityGrade: z.enum(['GRADE_A', 'GRADE_B', 'GRADE_C']),
  pricePerUnit: z.number().positive(),
  location: z.string(),
  district: z.string(),
  availableFrom: z.string().transform(s => new Date(s)),
  availableUntil: z.string().transform(s => new Date(s)).optional(),
  canDeliver: z.boolean().default(false),
  deliveryCost: z.number().optional(),
  negotiable: z.boolean().default(true),
  images: z.array(z.string()).optional(),
});

// GET - Get marketplace listings
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '20');
    const cropType = searchParams.get('cropType');
    const search = searchParams.get('search');
    const minPrice = searchParams.get('minPrice');
    const maxPrice = searchParams.get('maxPrice');
    const sortBy = searchParams.get('sortBy') || 'createdAt';
    const sortOrder = searchParams.get('sortOrder') || 'desc';

    const skip = (page - 1) * limit;

    const where: any = { status: 'ACTIVE' };

    if (cropType) where.cropType = cropType;
    if (search) {
      where.OR = [
        { variety: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } },
      ];
    }
    if (minPrice || maxPrice) {
      where.pricePerUnit = {};
      if (minPrice) where.pricePerUnit.gte = parseFloat(minPrice);
      if (maxPrice) where.pricePerUnit.lte = parseFloat(maxPrice);
    }

    const [listings, total] = await Promise.all([
      prisma.marketListing.findMany({
        where,
        skip,
        take: limit,
        include: {
          user: {
            select: {
              id: true,
              fullName: true,
              phoneNumber: true,
              district: true,
            },
          },
        },
        orderBy: { [sortBy]: sortOrder },
      }),
      prisma.marketListing.count({ where }),
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

// POST - Create new listing
export async function POST(request: NextRequest) {
  const userOrError = await requireAuth(request);
  if (userOrError instanceof Response) return userOrError;

  try {
    const body = await request.json();
    const data = createListingSchema.parse(body);

    const totalPrice = data.quantity * data.pricePerUnit;

    const listing = await prisma.marketListing.create({
      data: {
        userId: userOrError.id,
        cropType: data.cropType,
        variety: data.variety,
        quantity: data.quantity,
        unit: data.unit,
        qualityGrade: data.qualityGrade,
        pricePerUnit: data.pricePerUnit,
        totalPrice,
        negotiable: data.negotiable,
        description: data.description,
        images: data.images || [],
        availableFrom: data.availableFrom,
        availableUntil: data.availableUntil,
        location: data.location,
        district: data.district,
        canDeliver: data.canDeliver,
        deliveryCost: data.deliveryCost,
      },
      include: {
        user: {
          select: {
            id: true,
            fullName: true,
            phoneNumber: true,
          },
        },
      },
    });

    return apiResponse(listing, 'Listing created successfully.');
  } catch (error) {
    if (error instanceof z.ZodError) {
      return apiError('Validation error: ' + JSON.stringify(error.errors), 400);
    }
    console.error('Create listing error:', error);
    return apiError('Failed to create listing', 500);
  }
}
