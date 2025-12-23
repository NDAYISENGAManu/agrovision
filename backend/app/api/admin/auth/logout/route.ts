// Admin logout route
import { NextRequest, NextResponse } from 'next/server';
import { apiResponse } from '@/utils/apiResponse';

export async function POST(request: NextRequest) {
  const response = apiResponse(null, 'Logged out successfully');
  
  response.cookies.delete('admin-token');
  
  return response;
}
