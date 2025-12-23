import { z } from 'zod';

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

export const updateCropSchema = createCropSchema.partial().omit({ farmId: true });

export type CreateCropInput = z.infer<typeof createCropSchema>;
export type UpdateCropInput = z.infer<typeof updateCropSchema>;

export interface Crop {
  id: string;
  farmId: string;
  cropType: string;
  variety?: string;
  plantingDate: Date;
  area: number;
  expectedHarvestDate?: Date;
  actualHarvestDate?: Date;
  seedCost?: number;
  fertilizerCost?: number;
  pesticideCost?: number;
  laborCost?: number;
  totalCost: number;
  yieldAmount?: number;
  revenue?: number;
  active: boolean;
  createdAt: Date;
  updatedAt: Date;
}
