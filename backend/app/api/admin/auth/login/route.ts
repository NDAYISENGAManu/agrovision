// Admin login route
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { prisma } from '@/lib/prisma';
import { apiResponse, apiError } from '@/utils/apiResponse';
import { logger } from '@/lib/logger';

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
});

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { email, password } = loginSchema.parse(body);

    // Find admin user
    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (!user || user.role !== 'ADMIN') {
      logger.warning(`Failed login attempt for: ${email}`, 'AUTH');
      return apiError('Invalid credentials', 401);
    }

    // Verify password
    const isValid = await bcrypt.compare(password, user.password);
    if (!isValid) {
      logger.warning(`Invalid password for: ${email}`, 'AUTH');
      return apiError('Invalid credentials', 401);
    }

    // Generate token
    const token = jwt.sign(
      { userId: user.id, email: user.email, role: user.role },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    // Set cookie
    const response = apiResponse({
      user: {
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        role: user.role,
      },
      token,
    }, 'Login successful');

    response.cookies.set('admin-token', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 86400, // 24 hours
    });

    logger.success(`Admin logged in: ${user.email}`, 'AUTH', { userId: user.id });
    return response;
  } catch (error) {
    if (error instanceof z.ZodError) {
      logger.warning('Login validation error', 'AUTH', { errors: error.errors });
      return apiError('Validation error: ' + JSON.stringify(error.errors), 400);
    }
    logger.error('Admin login error', 'AUTH', error);
    return apiError('Login failed', 500);
  }
}
