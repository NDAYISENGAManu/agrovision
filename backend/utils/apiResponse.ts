import { NextResponse } from 'next/server';

export class ApiError extends Error {
  statusCode: number;

  constructor(message: string, statusCode: number = 400) {
    super(message);
    this.statusCode = statusCode;
    this.name = 'ApiError';
  }
}

export const successResponse = (data: any, message: string = 'Success') => {
  return NextResponse.json({
    success: true,
    message,
    data,
  });
};

export const errorResponse = (message: string, statusCode: number = 400) => {
  return NextResponse.json(
    {
      success: false,
      message,
    },
    { status: statusCode }
  );
};

export const handleApiError = (error: any) => {
  console.error('API Error:', error);

  if (error instanceof ApiError) {
    return errorResponse(error.message, error.statusCode);
  }

  if (error.code === 'P2002') {
    return errorResponse('Record already exists', 409);
  }

  if (error.code === 'P2025') {
    return errorResponse('Record not found', 404);
  }

  return errorResponse(
    process.env.NODE_ENV === 'development' 
      ? error.message 
      : 'Internal server error',
    500
  );
};

// Alias functions for backward compatibility
export const apiResponse = (data: any, message?: string, status: number = 200) => {
  return NextResponse.json({
    success: true,
    message: message || 'Success',
    data,
  }, { status });
};

export const apiError = (message: string, status: number = 400) => {
  return NextResponse.json({
    success: false,
    error: message,
  }, { status });
};
