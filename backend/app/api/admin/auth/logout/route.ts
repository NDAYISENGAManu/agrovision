import { NextRequest, NextResponse } from 'next/server';
import { successResponse } from '@/utils/apiResponse';

export async function POST(request: NextRequest) {
  try {
    // Create success response
    const response = successResponse(null, 'Logged out successfully');
    
    // Clear admin authentication cookie
    response.cookies.set('admin-token', '', {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 0, // Expire immediately
      path: '/',
    });
    
    return response;
  } catch (error) {
    return NextResponse.json(
      { success: false, error: 'Logout failed' },
      { status: 500 }
    );
  }
}
