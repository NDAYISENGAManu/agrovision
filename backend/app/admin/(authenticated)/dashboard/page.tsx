"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import styles from "./dashboard.module.css";
import Loading from "../../components/Loading";

interface DashboardStats {
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

export default function AdminDashboard() {
  const router = useRouter();
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [loggingOut, setLoggingOut] = useState(false);

  useEffect(() => {
    fetchDashboardStats();
  }, []);

  const fetchDashboardStats = async () => {
    try {
      const response = await fetch("/api/admin/dashboard");
      if (response.ok) {
        const data = await response.json();
        setStats(data.data.stats);
      } else {
        router.push("/admin");
      }
    } catch (error) {
      console.error("Failed to fetch stats:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = async () => {
    if (loggingOut) return; // Prevent double-clicks
    
    setLoggingOut(true);
    try {
      const response = await fetch("/api/admin/auth/logout", { 
        method: "POST",
        credentials: 'include' // Include cookies
      });
      
      if (response.ok) {
        // Successfully logged out, redirect to login
        router.push("/admin");
      } else {
        console.error("Logout failed");
        alert("Failed to logout. Please try again.");
      }
    } catch (error) {
      console.error("Logout error:", error);
      alert("An error occurred during logout.");
    } finally {
      setLoggingOut(false);
    }
  };

  if (loading) {
    return <Loading />;
  }

  return (
    <div className={styles.container}>
      <main className={styles.main}>
        <header className={styles.header}>
          <h1>Dashboard Overview</h1>
          <p>Welcome to the AgroVision Admin Panel</p>
        </header>

        <div className={styles.statsGrid}>
          <div className={styles.statCard}>
            <div className={styles.statIcon}>👥</div>
            <div className={styles.statContent}>
              <h3>Total Users</h3>
              <p className={styles.statNumber}>{stats?.totalUsers || 0}</p>
              <span className={styles.statChange}>
                +{stats?.recentUsers || 0} this week
              </span>
            </div>
          </div>

          <div className={styles.statCard}>
            <div className={styles.statIcon}>🚜</div>
            <div className={styles.statContent}>
              <h3>Total Farms</h3>
              <p className={styles.statNumber}>{stats?.totalFarms || 0}</p>
              <span className={styles.statChange}>Registered</span>
            </div>
          </div>

          <div className={styles.statCard}>
            <div className={styles.statIcon}>🌱</div>
            <div className={styles.statContent}>
              <h3>Total Crops</h3>
              <p className={styles.statNumber}>{stats?.totalCrops || 0}</p>
              <span className={styles.statChange}>Being tracked</span>
            </div>
          </div>

          <div className={styles.statCard}>
            <div className={styles.statIcon}>🔬</div>
            <div className={styles.statContent}>
              <h3>Diagnoses</h3>
              <p className={styles.statNumber}>{stats?.totalDiagnoses || 0}</p>
              <span className={styles.statChange}>AI scans completed</span>
            </div>
          </div>

          <div className={styles.statCard}>
            <div className={styles.statIcon}>🛒</div>
            <div className={styles.statContent}>
              <h3>Orders</h3>
              <p className={styles.statNumber}>{stats?.totalOrders || 0}</p>
              <span className={styles.statChange}>
                +{stats?.recentOrders || 0} this week
              </span>
            </div>
          </div>

          <div className={styles.statCard}>
            <div className={styles.statIcon}>💰</div>
            <div className={styles.statContent}>
              <h3>Monthly Revenue</h3>
              <p className={styles.statNumber}>
                {(stats?.monthlyRevenue || 0).toLocaleString()} RWF
              </p>
              <span className={styles.statChange}>This month</span>
            </div>
          </div>

          <div className={styles.statCard}>
            <div className={styles.statIcon}>📦</div>
            <div className={styles.statContent}>
              <h3>Active Listings</h3>
              <p className={styles.statNumber}>{stats?.activeListings || 0}</p>
              <span className={styles.statChange}>In marketplace</span>
            </div>
          </div>

          <div className={styles.statCard}>
            <div className={styles.statIcon}>⚡</div>
            <div className={styles.statContent}>
              <h3>System Status</h3>
              <p className={styles.statNumber}>✓ Operational</p>
              <span className={styles.statChange}>All systems go</span>
            </div>
          </div>
        </div>

        <div className={styles.quickActions}>
          <h2>Quick Actions</h2>
          <div className={styles.actionsGrid}>
            <Link href="/admin/users" className={styles.actionCard}>
              <span className={styles.actionIcon}>👤</span>
              <span>Manage Users</span>
            </Link>
            <Link href="/admin/marketplace" className={styles.actionCard}>
              <span className={styles.actionIcon}>✅</span>
              <span>Moderate Listings</span>
            </Link>
            <Link href="/admin/reports" className={styles.actionCard}>
              <span className={styles.actionIcon}>📊</span>
              <span>View Reports</span>
            </Link>
            <Link href="/admin/content" className={styles.actionCard}>
              <span className={styles.actionIcon}>➕</span>
              <span>Add Content</span>
            </Link>
          </div>
        </div>
      </main>
    </div>
  );
}
