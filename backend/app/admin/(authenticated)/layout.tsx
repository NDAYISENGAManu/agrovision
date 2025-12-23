"use client";

import React from "react";
import Sidebar from "../components/Sidebar";
import styles from "../admin.module.css";

export default function AdminAuthenticatedLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className={styles.container}>
      <Sidebar />
      <main className={styles.main}>
        {children}
      </main>
    </div>
  );
}
