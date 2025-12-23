import { NextRequest } from 'next/server';
import prisma from '@/lib/prisma';
import { hashPassword, generateToken } from '@/lib/auth';
import { successResponse, errorResponse, handleApiError } from '@/utils/apiResponse';
import { validate, registerSchema } from '@/utils/validation';

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const validatedData = validate(registerSchema, body);

    // Check if user already exists
    const existingUser = await prisma.user.findFirst({
      where: {
        OR: [
          { phoneNumber: validatedData.phoneNumber },
          { email: validatedData.email || '' },
        ],
      },
    });

    if (existingUser) {
      return errorResponse('User already exists with this phone number or email', 409);
    }

    // Hash password
    const hashedPassword = await hashPassword(validatedData.password);

    // Create user
    const user = await prisma.user.create({
      data: {
        ...validatedData,
        password: hashedPassword,
        verified: false,
      },
      select: {
        id: true,
        phoneNumber: true,
        email: true,
        fullName: true,
        role: true,
        district: true,
        sector: true,
        language: true,
        subscriptionTier: true,
        createdAt: true,
      },
    });

    // Generate JWT token
    const token = generateToken({
      userId: user.id,
      role: user.role,
      phoneNumber: user.phoneNumber,
    });

    // TODO: Send verification SMS

    return successResponse(
      { user, token },
      'User registered successfully'
    );
  } catch (error) {
    return handleApiError(error);
  }
}
