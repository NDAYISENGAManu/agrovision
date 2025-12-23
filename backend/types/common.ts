export interface ApiResponse<T = any> {
    success: boolean;
    message?: string;
    data?: T;
    error?: string;
}

export interface PaginationParams {
    page: number;
    limit: number;
}

export interface PaginationMeta {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
}

export interface PaginatedResponse<T> {
    data: T[];
    pagination: PaginationMeta;
}

export interface FilterParams {
    search?: string;
    role?: string;
    status?: string;
    verified?: boolean;
    [key: string]: any;
}

export interface DateRangeParams {
    startDate: string;
    endDate: string;
}

export type SortOrder = 'asc' | 'desc';

export interface SortParams {
    field: string;
    order: SortOrder;
}
