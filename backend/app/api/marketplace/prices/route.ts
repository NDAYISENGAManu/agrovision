// Market prices API route
import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiResponse, apiError } from '@/utils/apiResponse';

// GET - Get market prices
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const category = searchParams.get('category');
    const market = searchParams.get('market');
    const product = searchParams.get('product');

    const where: any = {};
    if (market) where.market = market;
    if (product) where.commodity = product;

    const prices = await prisma.marketPrice.findMany({
      where,
      orderBy: [{ commodity: 'asc' }, { date: 'desc' }],
      take: 100,
    });

    // Get available markets
    const markets = await prisma.marketPrice.findMany({
      select: { market: true },
      distinct: ['market'],
    });

    // Get commodities
    const commodities = await prisma.marketPrice.findMany({
      select: { commodity: true },
      distinct: ['commodity'],
    });

    return apiResponse({
      prices,
      markets: markets.map(m => m.market),
      commodities: commodities.map(c => c.commodity),
    });
  } catch (error) {
    console.error('Get market prices error:', error);
    return apiError('Failed to fetch market prices', 500);
  }
}

// POST - Add/Update market price (Admin only)
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { commodity, market, price, unit = 'kg', source = 'MANUAL' } = body;
    const date = new Date();

    const marketPrice = await prisma.marketPrice.upsert({
      where: {
        commodity_market_date: { commodity, market, date }
      },
      update: {
        price,
        avgPrice: price,
        unit,
        source,
      },
      create: {
        commodity,
        market,
        price,
        avgPrice: price,
        unit,
        source,
        date,
      },
    });

    return apiResponse(marketPrice, 'Market price updated successfully');
  } catch (error) {
    console.error('Update market price error:', error);
    return apiError('Failed to update market price', 500);
  }
}
