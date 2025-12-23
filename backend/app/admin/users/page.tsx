"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import styles from "../dashboard/dashboard.module.css";

interface User {
  id: string;
  name: string;
  email: string;
  phone: string;
  role: string;
  status: string;
  subscriptionTier: string;
  createdAt: string;
  _count: {
    farms: number;
    crops: number;
    diagnoses: number;
  };
}

export default function AdminUsers() {
  const router = useRouter();
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [filters, setFilters] = useState({
    search: "",
    role: "",
    status: "",
  });

  useEffect(() => {
    fetchUsers();
  }, [filters]);

  const fetchUsers = async () => {
    try {
      const params = new URLSearchParams();
      if (filters.search) params.append("search", filters.search);
      if (filters.role) params.append("role", filters.role);
      if (filters.status) params.append("status", filters.status);

      const response = await fetch(`/api/admin/users?${params}`);
      if (response.ok) {
        const data = await response.json();
        setUsers(data.data.users);
      } else {
        router.push("/admin");
      }
    } catch (error) {
      console.error("Failed to fetch users:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = async () => {
    await fetch("/api/admin/auth/logout", { method: "POST" });
    router.push("/admin");
  };

  return (
    <div className={styles.container}>
      <aside className={styles.sidebar}>
        <div className={styles.logo}>
          <h2>🌾 AgroVision</h2>
          <p>Admin Panel</p>
        </div>

        <nav className={styles.nav}>
          <Link href="/admin/dashboard" className={styles.navItem}>
            📊 Dashboard
          </Link>
          <Link
            href="/admin/users"
            className={styles.navItem + " " + styles.active}
          >
            👥 Users
          </Link>
          <Link href="/admin/farms" className={styles.navItem}>
            🚜 Farms
          </Link>
          <Link href="/admin/marketplace" className={styles.navItem}>
            🛒 Marketplace
          </Link>
          <Link href="/admin/reports" className={styles.navItem}>
            📈 Reports
          </Link>
          <Link href="/admin/content" className={styles.navItem}>
            📚 Content
          </Link>
          <Link href="/admin/settings" className={styles.navItem}>
            ⚙️ Settings
          </Link>
        </nav>

        <button onClick={handleLogout} className={styles.logoutBtn}>
          🚪 Logout
        </button>
      </aside>

      <main className={styles.main}>
        <header className={styles.header}>
          <h1>User Management</h1>
          <p>Manage all registered users</p>
        </header>

        <div
          style={{
            background: "white",
            padding: "20px",
            borderRadius: "12px",
            marginBottom: "20px",
          }}
        >
          <div style={{ display: "flex", gap: "16px", marginBottom: "20px" }}>
            <input
              type="text"
              placeholder="Search users..."
              value={filters.search}
              onChange={(e) =>
                setFilters({ ...filters, search: e.target.value })
              }
              style={{
                flex: 1,
                padding: "10px",
                borderRadius: "8px",
                border: "1px solid #ddd",
              }}
            />
            <select
              value={filters.role}
              onChange={(e) => setFilters({ ...filters, role: e.target.value })}
              style={{
                padding: "10px",
                borderRadius: "8px",
                border: "1px solid #ddd",
              }}
            >
              <option value="">All Roles</option>
              <option value="FARMER">Farmer</option>
              <option value="BUYER">Buyer</option>
              <option value="EXPERT">Expert</option>
              <option value="ADMIN">Admin</option>
            </select>
            <select
              value={filters.status}
              onChange={(e) =>
                setFilters({ ...filters, status: e.target.value })
              }
              style={{
                padding: "10px",
                borderRadius: "8px",
                border: "1px solid #ddd",
              }}
            >
              <option value="">All Status</option>
              <option value="ACTIVE">Active</option>
              <option value="SUSPENDED">Suspended</option>
              <option value="BANNED">Banned</option>
            </select>
          </div>

          {loading ? (
            <p>Loading users...</p>
          ) : (
            <table style={{ width: "100%", borderCollapse: "collapse" }}>
              <thead>
                <tr
                  style={{
                    borderBottom: "2px solid #E0E0E0",
                    textAlign: "left",
                  }}
                >
                  <th style={{ padding: "12px" }}>Name</th>
                  <th style={{ padding: "12px" }}>Email</th>
                  <th style={{ padding: "12px" }}>Role</th>
                  <th style={{ padding: "12px" }}>Status</th>
                  <th style={{ padding: "12px" }}>Tier</th>
                  <th style={{ padding: "12px" }}>Farms</th>
                  <th style={{ padding: "12px" }}>Crops</th>
                  <th style={{ padding: "12px" }}>Actions</th>
                </tr>
              </thead>
              <tbody>
                {users.map((user) => (
                  <tr
                    key={user.id}
                    style={{ borderBottom: "1px solid #F0F0F0" }}
                  >
                    <td style={{ padding: "12px" }}>{user.name}</td>
                    <td style={{ padding: "12px" }}>{user.email}</td>
                    <td style={{ padding: "12px" }}>
                      <span
                        style={{
                          padding: "4px 8px",
                          borderRadius: "4px",
                          fontSize: "12px",
                          background: "#E3F2FD",
                          color: "#1565C0",
                        }}
                      >
                        {user.role}
                      </span>
                    </td>
                    <td style={{ padding: "12px" }}>
                      <span
                        style={{
                          padding: "4px 8px",
                          borderRadius: "4px",
                          fontSize: "12px",
                          background:
                            user.status === "ACTIVE" ? "#E8F5E9" : "#FFEBEE",
                          color:
                            user.status === "ACTIVE" ? "#2E7D32" : "#C62828",
                        }}
                      >
                        {user.status}
                      </span>
                    </td>
                    <td style={{ padding: "12px" }}>{user.subscriptionTier}</td>
                    <td style={{ padding: "12px" }}>{user._count.farms}</td>
                    <td style={{ padding: "12px" }}>{user._count.crops}</td>
                    <td style={{ padding: "12px" }}>
                      <Link
                        href={`/admin/users/${user.id}`}
                        style={{ color: "#2D6A4F", textDecoration: "none" }}
                      >
                        View →
                      </Link>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </main>
    </div>
  );
}
