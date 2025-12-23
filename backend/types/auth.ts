import { z } from 'zod';

export enum Role {
    FARMER = 'FARMER',
    BUYER = 'BUYER',
    EXPERT = 'EXPERT',
}

export enum Language {
    EN = 'en',
    RW = 'rw',
    SW = 'sw',
    FR = 'fr',
}

export const registerSchema = z.object({
    phoneNumber: z.string().regex(/^(\+250|0)[7][0-9]{8}$/, 'Invalid Rwandan phone number'),
    password: z.string().min(6, 'Password must be at least 6 characters'),
    fullName: z.string().min(2, 'Full name is required'),
    email: z.string().email().optional(),
    role: z.nativeEnum(Role).default(Role.FARMER),
    district: z.string().optional(),
    sector: z.string().optional(),
    language: z.nativeEnum(Language).default(Language.EN),
});

export const loginSchema = z.object({
    phoneNumber: z.string(),
    password: z.string(),
});

export type RegisterInput = z.infer<typeof registerSchema>;
export type LoginInput = z.infer<typeof loginSchema>;

export interface AuthResponse {
    success: boolean;
    message?: string;
    data?: {
        user: {
            id: string;
            phoneNumber: string;
            fullName: string;
            email?: string;
            role: Role;
        };
        token: string;
    };
    error?: string;
}

export interface JWTPayload {
    userId: string;
    role: Role;
    phoneNumber: string;
}
