import { UserRole, SubscriptionTier } from "@prisma/client";

export interface DashboardStats {
    totalUsers: number;
    totalFarms: number;
    totalCrops: number;
    totalDiagnoses: number;
    totalOrders: number;
    activeListings: number;
    recentUsers: number;
    recentOrders: number;
    monthlyRevenue: number;
}

export interface AdminUser {
    id: string;
    fullName: string;
    email: string;
    phoneNumber: string;
    role: UserRole;
    verified: boolean;
    subscriptionTier: SubscriptionTier;
    createdAt: string | Date;
    _count?: {
        farms: number;
        crops: number;
        diagnoses: number;
        orders?: number;
        marketListings?: number;
    };
}

export interface NavItem {
    label: string;
    href: string;
    icon: string;
}

export interface ReportParams {
    type: 'overview' | 'users' | 'revenue' | 'diagnoses' | 'marketplace';
    startDate: string;
    endDate: string;
}
