// Admin authentication middleware
import { NextRequest, NextResponse } from 'next/server';
import jwt from 'jsonwebtoken';
import { prisma } from '@/lib/prisma';

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

export interface AdminUser {
  id: string;
  email: string | null;
  fullName: string;
  role: string;
}

export async function verifyAdminToken(token: string): Promise<AdminUser | null> {
  try {
    const decoded = jwt.verify(token, JWT_SECRET) as any;
    
    // Check if user exists and is admin
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
      select: {
        id: true,
        email: true,
        fullName: true,
        role: true,
      }
    });

    if (!user || user.role !== 'ADMIN') {
      return null;
    }

    return user;
  } catch (error) {
    return null;
  }
}

export async function requireAdmin(request: NextRequest): Promise<AdminUser | NextResponse> {
  try {
    const token = request.cookies.get('admin-token')?.value;

    if (!token) {
      return NextResponse.json(
        { error: 'Authentication required' },
        { status: 401 }
      );
    }

    const admin = await verifyAdminToken(token);

    if (!admin) {
      return NextResponse.json(
        { error: 'Admin access required' },
        { status: 403 }
      );
    }

    return admin;
  } catch (error) {
    return NextResponse.json(
      { error: 'Authentication failed' },
      { status: 401 }
    );
  }
}
