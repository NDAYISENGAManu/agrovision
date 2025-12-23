"use client";

import React, { useState } from "react";
import Link from "next/link";
import { useRouter, usePathname } from "next/navigation";
import styles from "./Sidebar.module.css";

const navItems = [
  { label: "Dashboard", href: "/admin/dashboard", icon: "📊" },
  { label: "Users", href: "/admin/users", icon: "👥" },
  { label: "Farms", href: "/admin/farms", icon: "🚜" },
  { label: "Marketplace", href: "/admin/marketplace", icon: "🛒" },
  { label: "Reports", href: "/admin/reports", icon: "📈" },
  { label: "Content", href: "/admin/content", icon: "📚" },
  { label: "Settings", href: "/admin/settings", icon: "⚙️" },
];

export default function Sidebar() {
  const router = useRouter();
  const pathname = usePathname();
  const [loggingOut, setLoggingOut] = useState(false);

  const handleLogout = async () => {
    if (loggingOut) return;
    
    setLoggingOut(true);
    try {
      const response = await fetch("/api/admin/auth/logout", { 
        method: "POST",
        credentials: 'include'
      });
      
      if (response.ok) {
        router.push("/admin");
      } else {
        alert("Failed to logout. Please try again.");
      }
    } catch (error) {
      console.error("Logout error:", error);
      alert("An error occurred during logout.");
    } finally {
      setLoggingOut(false);
    }
  };

  return (
    <aside className={styles.sidebar}>
      <div className={styles.logo}>
        <Link href="/admin/dashboard" style={{ textDecoration: 'none', color: 'inherit' }}>
          <h2>🌾 AgroVision</h2>
          <p>Admin Control Panel window</p>
        </Link>
      </div>

      <nav className={styles.nav}>
        {navItems.map((item) => (
          <Link
            key={item.href}
            href={item.href}
            className={`${styles.navItem} ${pathname === item.href ? styles.active : ""}`}
          >
            {item.icon} {item.label}
          </Link>
        ))}
      </nav>

      <button 
        onClick={handleLogout} 
        className={styles.logoutBtn}
        disabled={loggingOut}
      >
        {loggingOut ? "🔄 Logging out..." : "🚪 Logout"}
      </button>
    </aside>
  );
}
