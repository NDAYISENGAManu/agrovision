import { NextRequest } from 'next/server';
import prisma from '@/lib/prisma';
import { comparePassword, generateToken } from '@/lib/auth';
import { successResponse, errorResponse, handleApiError } from '@/utils/apiResponse';
import { validate, loginSchema } from '@/utils/validation';

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const { phoneNumber, password } = validate(loginSchema, body);

    // Find user
    const user = await prisma.user.findUnique({
      where: { phoneNumber },
    });

    if (!user) {
      return errorResponse('Invalid credentials', 401);
    }

    // Verify password
    const isValidPassword = await comparePassword(password, user.password);

    if (!isValidPassword) {
      return errorResponse('Invalid credentials', 401);
    }

    // Update last login
    await prisma.user.update({
      where: { id: user.id },
      data: { lastLogin: new Date() },
    });

    // Generate token
    const token = generateToken({
      userId: user.id,
      role: user.role,
      phoneNumber: user.phoneNumber,
    });

    // Return user data (excluding password)
    const { password: _, ...userData } = user;

    return successResponse(
      { user: userData, token },
      'Login successful'
    );
  } catch (error) {
    return handleApiError(error);
  }
}
