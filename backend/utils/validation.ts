import { z } from 'zod';

// Re-export all validation schemas from types
export {
  registerSchema,
  loginSchema,
  type RegisterInput,
  type LoginInput,
} from '@/types/auth';

export {
  createFarmSchema,
  updateFarmSchema,
  type CreateFarmInput,
  type UpdateFarmInput,
} from '@/types/farm';

export {
  createCropSchema,
  updateCropSchema,
  type CreateCropInput,
  type UpdateCropInput,
} from '@/types/crop';

export {
  createListingSchema,
  createOfferSchema,
  updateListingSchema,
  type CreateListingInput,
  type CreateOfferInput,
  type UpdateListingInput,
} from '@/types/marketplace';

export {
  createDiagnosisSchema,
  type CreateDiagnosisInput,
} from '@/types/diagnosis';

// Validation helper function
export const validate = <T>(schema: z.ZodSchema<T>, data: unknown): T => {
  return schema.parse(data);
};

