// Admin dashboard stats
import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiResponse, apiError } from '@/utils/apiResponse';
import { requireAdmin } from '@/middleware/adminAuth';
import { logger } from '@/lib/logger';

export async function GET(request: NextRequest) {
  const adminOrError = await requireAdmin(request);
  if (adminOrError instanceof Response) return adminOrError;

  try {
    // Get dashboard statistics
    const [
      totalUsers,
      totalFarms,
      totalCrops,
      totalDiagnoses,
      totalOrders,
      activeListings,
      recentUsers,
      recentOrders,
      monthlyRevenue,
    ] = await Promise.all([
      // Total counts
      prisma.user.count(),
      prisma.farm.count(),
      prisma.crop.count(),
      prisma.diagnosis.count(),
      prisma.order.count(),
      prisma.marketListing.count({ where: { status: 'ACTIVE' } }),

      // Recent users (last 7 days)
      prisma.user.count({
        where: {
          createdAt: {
            gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
          },
        },
      }),

      // Recent orders (last 7 days)
      prisma.order.count({
        where: {
          createdAt: {
            gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
          },
        },
      }),

      // Monthly revenue
      prisma.payment.aggregate({
        where: {
          status: 'COMPLETED',
          createdAt: {
            gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1),
          },
        },
        _sum: {
          amount: true,
        },
      }),
    ]);

    // Get user growth data (last 12 months)
    const userGrowthRaw: any[] = await prisma.$queryRaw`
      SELECT 
        DATE_TRUNC('month', "createdAt") as month,
        COUNT(*) as count
      FROM "User"
      WHERE "createdAt" >= NOW() - INTERVAL '12 months'
      GROUP BY month
      ORDER BY month ASC
    `;

    // Convert BigInt to number for JSON serialization
    const userGrowth = userGrowthRaw.map(row => ({
      month: row.month,
      count: Number(row.count),
    }));

    // Get top farmers by farms
    const topFarmers = await prisma.user.findMany({
      where: { role: 'FARMER' },
      take: 10,
      select: {
        id: true,
        fullName: true,
        email: true,
        phoneNumber: true,
        _count: {
          select: {
            farms: true,
          },
        },
      },
      orderBy: {
        farms: {
          _count: 'desc',
        },
      },
    });

    return apiResponse({
      stats: {
        totalUsers,
        totalFarms,
        totalCrops,
        totalDiagnoses,
        totalOrders,
        activeListings,
        recentUsers,
        recentOrders,
        monthlyRevenue: monthlyRevenue._sum.amount || 0,
      },
      userGrowth,
      topFarmers,
    });
  } catch (error) {
    logger.error('Dashboard stats error', 'ADMIN', error);
    return apiError('Failed to fetch dashboard stats', 500);
  }
}
