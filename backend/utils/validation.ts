import { z } from 'zod';

// Auth validation schemas
export const registerSchema = z.object({
  phoneNumber: z.string().regex(/^(\+250|0)[7][0-9]{8}$/, 'Invalid Rwandan phone number'),
  password: z.string().min(6, 'Password must be at least 6 characters'),
  fullName: z.string().min(2, 'Full name is required'),
  email: z.string().email().optional(),
  role: z.enum(['FARMER', 'BUYER', 'EXPERT']).default('FARMER'),
  district: z.string().optional(),
  sector: z.string().optional(),
  language: z.enum(['en', 'rw', 'sw', 'fr']).default('en'),
});

export const loginSchema = z.object({
  phoneNumber: z.string(),
  password: z.string(),
});

// Farm validation schemas
export const createFarmSchema = z.object({
  name: z.string().min(2),
  location: z.string(),
  size: z.number().positive(),
  district: z.string(),
  sector: z.string(),
  cell: z.string().optional(),
  soilType: z.enum(['CLAY', 'SANDY', 'LOAMY', 'SILT', 'PEAT', 'CHALKY']).optional(),
  waterSource: z.string().optional(),
  latitude: z.number().optional(),
  longitude: z.number().optional(),
});

// Crop validation schemas
export const createCropSchema = z.object({
  farmId: z.string(),
  cropType: z.string(),
  variety: z.string().optional(),
  plantingDate: z.string().or(z.date()),
  area: z.number().positive(),
  expectedHarvestDate: z.string().or(z.date()).optional(),
  seedCost: z.number().optional(),
  fertilizerCost: z.number().optional(),
  pesticideCost: z.number().optional(),
  laborCost: z.number().optional(),
});

// Marketplace validation schemas
export const createListingSchema = z.object({
  cropType: z.string(),
  variety: z.string().optional(),
  quantity: z.number().positive(),
  unit: z.string().default('kg'),
  qualityGrade: z.enum(['GRADE_A', 'GRADE_B', 'GRADE_C']),
  pricePerUnit: z.number().positive(),
  description: z.string().optional(),
  harvestDate: z.string().or(z.date()).optional(),
  location: z.string(),
  district: z.string(),
  canDeliver: z.boolean().default(false),
  deliveryCost: z.number().optional(),
  negotiable: z.boolean().default(true),
});

export const createOfferSchema = z.object({
  listingId: z.string(),
  quantity: z.number().positive(),
  pricePerUnit: z.number().positive(),
  message: z.string().optional(),
});

// Diagnosis validation schema
export const createDiagnosisSchema = z.object({
  cropId: z.string().optional(),
  cropType: z.string(),
  imageUrl: z.string().url(),
  latitude: z.number().optional(),
  longitude: z.number().optional(),
  location: z.string().optional(),
});

export const validate = <T>(schema: z.ZodSchema<T>, data: unknown): T => {
  return schema.parse(data);
};
