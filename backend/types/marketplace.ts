import { z } from 'zod';

export enum QualityGrade {
    GRADE_A = 'GRADE_A',
    GRADE_B = 'GRADE_B',
    GRADE_C = 'GRADE_C',
}

// ============= MARKETPLACE SCHEMAS =============
export const createListingSchema = z.object({
    cropType: z.string(),
    variety: z.string().optional(),
    quantity: z.number().positive(),
    unit: z.string().default('kg'),
    qualityGrade: z.nativeEnum(QualityGrade),
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

export const updateListingSchema = createListingSchema.partial();

export type CreateListingInput = z.infer<typeof createListingSchema>;
export type CreateOfferInput = z.infer<typeof createOfferSchema>;
export type UpdateListingInput = z.infer<typeof updateListingSchema>;

export interface MarketListing {
    id: string;
    userId: string;
    cropType: string;
    variety?: string;
    quantity: number;
    unit: string;
    qualityGrade: QualityGrade;
    pricePerUnit: number;
    totalPrice: number;
    description?: string;
    images: string[];
    harvestDate?: Date;
    availableFrom: Date;
    availableUntil?: Date;
    location: string;
    district: string;
    canDeliver: boolean;
    deliveryCost?: number;
    negotiable: boolean;
    status: string;
    views: number;
    createdAt: Date;
    updatedAt: Date;
}

export interface Offer {
    id: string;
    listingId: string;
    buyerId: string;
    quantity: number;
    pricePerUnit: number;
    totalPrice: number;
    message?: string;
    status: string;
    createdAt: Date;
    updatedAt: Date;
}
