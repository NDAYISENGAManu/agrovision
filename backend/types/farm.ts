import { z } from 'zod';

export enum SoilType {
    CLAY = 'CLAY',
    SANDY = 'SANDY',
    LOAMY = 'LOAMY',
    SILT = 'SILT',
    PEAT = 'PEAT',
    CHALKY = 'CHALKY',
}

export const createFarmSchema = z.object({
    name: z.string().min(2),
    location: z.string(),
    size: z.number().positive(),
    district: z.string(),
    sector: z.string(),
    cell: z.string().optional(),
    soilType: z.nativeEnum(SoilType).optional(),
    waterSource: z.string().optional(),
    latitude: z.number().optional(),
    longitude: z.number().optional(),
});

export const updateFarmSchema = createFarmSchema.partial();

export type CreateFarmInput = z.infer<typeof createFarmSchema>;
export type UpdateFarmInput = z.infer<typeof updateFarmSchema>;

export interface Farm {
    id: string;
    userId: string;
    name: string;
    location: string;
    size: number;
    district: string;
    sector: string;
    cell?: string;
    soilType?: SoilType;
    waterSource?: string;
    latitude?: number;
    longitude?: number;
    createdAt: Date;
    updatedAt: Date;
}
