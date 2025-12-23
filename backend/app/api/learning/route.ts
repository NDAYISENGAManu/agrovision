// Learning content API route
import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiResponse, apiError } from '@/utils/apiResponse';

// GET - Get learning content
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '20');
    const category = searchParams.get('category');
    const type = searchParams.get('type'); // video, article, guide
    const search = searchParams.get('search');

    const skip = (page - 1) * limit;

    const where: any = { published: true };

    if (category) where.category = category;
    if (type) where.type = type;

    if (search) {
      where.OR = [
        { title: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } },
      ];
    }

    const [content, total] = await Promise.all([
      prisma.learningContent.findMany({
        where,
        skip,
        take: limit,
        select: {
          id: true,
          title: true,
          description: true,
          type: true,
          category: true,
          thumbnail: true,
          duration: true,
          views: true,
          createdAt: true,
        },
        orderBy: { createdAt: 'desc' },
      }),
      prisma.learningContent.count({ where }),
    ]);

    // Get categories
    const categories = await prisma.learningContent.findMany({
      where: { published: true },
      select: { category: true },
      distinct: ['category'],
    });

    return apiResponse({
      content,
      categories: categories.map(c => c.category),
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error('Get learning content error:', error);
    return apiError('Failed to fetch learning content', 500);
  }
}
