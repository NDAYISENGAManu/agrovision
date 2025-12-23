// Admin reports management
import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiResponse, apiError } from '@/utils/apiResponse';
import { requireAdmin } from '@/middleware/adminAuth';

export async function GET(request: NextRequest) {
  const adminOrError = await requireAdmin(request);
  if (adminOrError instanceof Response) return adminOrError;

  try {
    const { searchParams } = new URL(request.url);
    const type = searchParams.get('type'); // 'users', 'revenue', 'diagnoses', 'marketplace'
    const startDate = searchParams.get('startDate');
    const endDate = searchParams.get('endDate');

    const dateFilter = startDate && endDate ? {
      createdAt: {
        gte: new Date(startDate),
        lte: new Date(endDate),
      },
    } : {};

    let reportData: any = {};

    switch (type) {
      case 'users':
        reportData = await generateUsersReport(dateFilter);
        break;
      case 'revenue':
        reportData = await generateRevenueReport(dateFilter);
        break;
      case 'diagnoses':
        reportData = await generateDiagnosesReport(dateFilter);
        break;
      case 'marketplace':
        reportData = await generateMarketplaceReport(dateFilter);
        break;
      default:
        reportData = await generateOverviewReport(dateFilter);
    }

    return apiResponse(reportData);
  } catch (error) {
    console.error('Generate report error:', error);
    return apiError('Failed to generate report', 500);
  }
}

async function generateUsersReport(dateFilter: any) {
  const [totalUsers, usersByRole, usersByTier, userGrowth] = await Promise.all([
    prisma.user.count({ where: dateFilter }),
    prisma.user.groupBy({
      by: ['role'],
      where: dateFilter,
      _count: true,
    }),
    prisma.user.groupBy({
      by: ['subscriptionTier'],
      where: dateFilter,
      _count: true,
    }),
    prisma.$queryRaw`
      SELECT 
        DATE_TRUNC('day', "createdAt") as date,
        COUNT(*) as count
      FROM "User"
      WHERE "createdAt" >= COALESCE(${dateFilter.createdAt?.gte}, NOW() - INTERVAL '30 days')
        AND "createdAt" <= COALESCE(${dateFilter.createdAt?.lte}, NOW())
      GROUP BY date
      ORDER BY date ASC
    `,
  ]);

  return {
    totalUsers,
    usersByRole,
    usersByTier,
    userGrowth,
  };
}

async function generateRevenueReport(dateFilter: any) {
  const [totalRevenue, revenueByType, paymentStats] = await Promise.all([
    prisma.payment.aggregate({
      where: { ...dateFilter, status: 'COMPLETED' },
      _sum: { amount: true },
      _avg: { amount: true },
      _count: true,
    }),
    prisma.payment.groupBy({
      by: ['type'],
      where: { ...dateFilter, status: 'COMPLETED' },
      _sum: { amount: true },
      _count: true,
    }),
    prisma.$queryRaw`
      SELECT 
        DATE_TRUNC('day', "createdAt") as date,
        SUM(amount) as revenue,
        COUNT(*) as transactions
      FROM "Payment"
      WHERE status = 'COMPLETED'
        AND "createdAt" >= COALESCE(${dateFilter.createdAt?.gte}, NOW() - INTERVAL '30 days')
        AND "createdAt" <= COALESCE(${dateFilter.createdAt?.lte}, NOW())
      GROUP BY date
      ORDER BY date ASC
    `,
  ]);

  return {
    totalRevenue: totalRevenue._sum.amount || 0,
    averageTransaction: totalRevenue._avg.amount || 0,
    totalTransactions: totalRevenue._count,
    revenueByType,
    dailyRevenue: paymentStats,
  };
}

async function generateDiagnosesReport(dateFilter: any) {
  const [totalDiagnoses, diseaseDistribution, accuracyStats] = await Promise.all([
    prisma.diagnosis.count({ where: dateFilter }),
    prisma.diagnosis.groupBy({
      by: ['diseaseName'],
      where: dateFilter,
      _count: true,
      orderBy: { _count: { diseaseName: 'desc' } },
      take: 10,
    }),
    prisma.diagnosis.aggregate({
      where: dateFilter,
      _avg: { confidence: true },
    }),
  ]);

  return {
    totalDiagnoses,
    diseaseDistribution,
    averageConfidence: accuracyStats._avg.confidence || 0,
  };
}

async function generateMarketplaceReport(dateFilter: any) {
  const [totalListings, totalOrders, orderStats, topProducts] = await Promise.all([
    prisma.marketListing.count({ where: dateFilter }),
    prisma.order.count({ where: dateFilter }),
    prisma.order.groupBy({
      by: ['status'],
      where: dateFilter,
      _count: true,
      _sum: { totalAmount: true },
    }),
    prisma.marketListing.findMany({
      where: dateFilter,
      take: 10,
      orderBy: { views: 'desc' },
      select: {
        id: true,
        cropType: true,
        pricePerUnit: true,
        quantity: true,
        views: true,
        user: { select: { fullName: true } },
      },
    }),
  ]);

  return {
    totalListings,
    totalOrders,
    orderStats,
    topProducts,
  };
}

async function generateOverviewReport(dateFilter: any) {
  return {
    users: await generateUsersReport(dateFilter),
    revenue: await generateRevenueReport(dateFilter),
    diagnoses: await generateDiagnosesReport(dateFilter),
    marketplace: await generateMarketplaceReport(dateFilter),
  };
}
