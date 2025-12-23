import { NextRequest, NextResponse } from 'next/server';
import { verifyToken } from '@/lib/auth';

export interface AuthenticatedRequest extends NextRequest {
  user?: {
    userId: string;
    role: string;
    phoneNumber: string;
  };
}

export const authMiddleware = (handler: Function) => {
  return async (req: NextRequest, context?: any) => {
    try {
      const authHeader = req.headers.get('authorization');
      
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return NextResponse.json(
          { success: false, message: 'No token provided' },
          { status: 401 }
        );
      }

      const token = authHeader.substring(7);
      const decoded = verifyToken(token);

      if (!decoded) {
        return NextResponse.json(
          { success: false, message: 'Invalid or expired token' },
          { status: 401 }
        );
      }

      // Attach user to request
      (req as AuthenticatedRequest).user = {
        userId: decoded.userId,
        role: decoded.role,
        phoneNumber: decoded.phoneNumber,
      };

      return handler(req, context);
    } catch (error) {
      return NextResponse.json(
        { success: false, message: 'Authentication failed' },
        { status: 401 }
      );
    }
  };
};

export const requireRole = (...roles: string[]) => {
  return (handler: Function) => {
    return authMiddleware(async (req: AuthenticatedRequest, context?: any) => {
      const user = req.user;
      
      if (!user || !roles.includes(user.role)) {
        return NextResponse.json(
          { success: false, message: 'Insufficient permissions' },
          { status: 403 }
        );
      }

      return handler(req, context);
    });
  };
};

// Helper function to verify auth and return user or error response
export const requireAuth = async (req: NextRequest): Promise<{ id: string; role: string; phoneNumber: string } | Response> => {
  try {
    const authHeader = req.headers.get('authorization');
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return NextResponse.json(
        { success: false, error: 'No token provided' },
        { status: 401 }
      );
    }

    const token = authHeader.substring(7);
    const decoded = verifyToken(token);

    if (!decoded) {
      return NextResponse.json(
        { success: false, error: 'Invalid or expired token' },
        { status: 401 }
      );
    }

    return {
      id: decoded.userId,
      role: decoded.role,
      phoneNumber: decoded.phoneNumber,
    };
  } catch (error) {
    return NextResponse.json(
      { success: false, error: 'Authentication failed' },
      { status: 401 }
    );
  }
};
