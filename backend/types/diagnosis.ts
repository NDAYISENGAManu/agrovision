import { z } from 'zod';

export enum Severity {
    MILD = 'MILD',
    MODERATE = 'MODERATE',
    SEVERE = 'SEVERE',
}

export const createDiagnosisSchema = z.object({
    cropId: z.string().optional(),
    cropType: z.string(),
    imageUrl: z.string().url(),
    latitude: z.number().optional(),
    longitude: z.number().optional(),
    location: z.string().optional(),
});

export type CreateDiagnosisInput = z.infer<typeof createDiagnosisSchema>;

export interface Diagnosis {
    id: string;
    userId: string;
    cropId?: string;
    cropType: string;
    imageUrl: string;
    diseaseName: string;
    confidence: number;
    severity: Severity;
    symptoms: string[];
    causes: string[];
    treatments: any;
    preventiveMeasures: string[];
    estimatedYieldLoss?: number;
    location?: string;
    latitude?: number;
    longitude?: number;
    createdAt: Date;
    updatedAt: Date;
}

export interface DiagnosisResult {
    diseaseName: string;
    confidence: number;
    severity: Severity;
    symptoms: string[];
    causes: string[];
    treatments: {
        treatment: string;
        organic?: string[];
        chemical?: string[];
    };
    preventiveMeasures: string[];
    estimatedYieldLoss?: number;
}
