// Forum posts API route
import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiResponse, apiError } from '@/utils/apiResponse';
import { requireAuth } from '@/middleware/auth';
import { z } from 'zod';

const createPostSchema = z.object({
  title: z.string().min(5).max(200),
  content: z.string().min(10).max(5000),
  category: z.string(),
  tags: z.array(z.string()).optional(),
});

// GET - Get forum posts
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '20');
    const category = searchParams.get('category');
    const search = searchParams.get('search');
    const sortBy = searchParams.get('sortBy') || 'createdAt';

    const skip = (page - 1) * limit;

    const where: any = {};

    if (category) where.category = category;
    if (search) {
      where.OR = [
        { title: { contains: search, mode: 'insensitive' } },
        { content: { contains: search, mode: 'insensitive' } },
      ];
    }

    const orderBy: any = {};
    if (sortBy === 'popular') {
      orderBy.views = 'desc';
    } else if (sortBy === 'answers') {
      orderBy.comments = { _count: 'desc' };
    } else {
      orderBy.createdAt = 'desc';
    }

    const [posts, total] = await Promise.all([
      prisma.forumPost.findMany({
        where,
        skip,
        take: limit,
        include: {
          user: {
            select: {
              id: true,
              fullName: true,
              role: true,
            },
          },
          _count: {
            select: { comments: true },
          },
        },
        orderBy,
      }),
      prisma.forumPost.count({ where }),
    ]);

    // Get categories
    const categories = await prisma.forumPost.findMany({
      select: { category: true },
      distinct: ['category'],
    });

    return apiResponse({
      posts,
      categories: categories.map(c => c.category),
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error('Get forum posts error:', error);
    return apiError('Failed to fetch forum posts', 500);
  }
}

// POST - Create forum post
export async function POST(request: NextRequest) {
  const userOrError = await requireAuth(request);
  if (userOrError instanceof Response) return userOrError;

  try {
    const body = await request.json();
    const data = createPostSchema.parse(body);

    const post = await prisma.forumPost.create({
      data: {
        ...data,
        userId: userOrError.id,
        tags: data.tags || [],
      },
      include: {
        user: {
          select: {
            id: true,
            fullName: true,
            role: true,
          },
        },
      },
    });

    return apiResponse(post, 'Post created successfully');
  } catch (error) {
    if (error instanceof z.ZodError) {
      return apiError('Validation error: ' + JSON.stringify(error.errors), 400);
    }
    console.error('Create forum post error:', error);
    return apiError('Failed to create post', 500);
  }
}
