"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import styles from "../dashboard/dashboard.module.css";
import Loading from "../../components/Loading";

export default function AdminReports() {
  const router = useRouter();
  const [reportType, setReportType] = useState("overview");
  const [reportData, setReportData] = useState<any>(null);
  const [loading, setLoading] = useState(false);
  const [dateRange, setDateRange] = useState({
    startDate: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000)
      .toISOString()
      .split("T")[0],
    endDate: new Date().toISOString().split("T")[0],
  });

  const generateReport = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams({
        type: reportType,
        startDate: dateRange.startDate,
        endDate: dateRange.endDate,
      });

      const response = await fetch(`/api/admin/reports?${params}`);
      if (response.ok) {
        const data = await response.json();
        setReportData(data.data);
      }
    } catch (error) {
      console.error("Failed to generate report:", error);
    } finally {
      setLoading(false);
    }
  };

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
      }
    } catch (error) {
      console.error("Logout error:", error);
    } finally {
      setLoggingOut(false);
    }
  };

  return (
    <div className={styles.container}>
      <main className={styles.main}>
        <header className={styles.header}>
          <h1>Reports & Analytics</h1>
          <p>Generate and view comprehensive reports</p>
        </header>

        <div
          style={{ background: "white", padding: "24px", borderRadius: "12px" }}
        >
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "1fr 1fr 1fr auto",
              gap: "16px",
              marginBottom: "24px",
            }}
          >
            <div>
              <label
                style={{
                  display: "block",
                  marginBottom: "8px",
                  fontWeight: "500",
                }}
              >
                Report Type
              </label>
              <select
                value={reportType}
                onChange={(e) => setReportType(e.target.value)}
                style={{
                  width: "100%",
                  padding: "10px",
                  borderRadius: "8px",
                  border: "1px solid #ddd",
                }}
              >
                <option value="overview">Overview</option>
                <option value="users">Users Report</option>
                <option value="revenue">Revenue Report</option>
                <option value="diagnoses">Diagnoses Report</option>
                <option value="marketplace">Marketplace Report</option>
              </select>
            </div>

            <div>
              <label
                style={{
                  display: "block",
                  marginBottom: "8px",
                  fontWeight: "500",
                }}
              >
                Start Date
              </label>
              <input
                type="date"
                value={dateRange.startDate}
                onChange={(e) =>
                  setDateRange({ ...dateRange, startDate: e.target.value })
                }
                style={{
                  width: "100%",
                  padding: "10px",
                  borderRadius: "8px",
                  border: "1px solid #ddd",
                }}
              />
            </div>

            <div>
              <label
                style={{
                  display: "block",
                  marginBottom: "8px",
                  fontWeight: "500",
                }}
              >
                End Date
              </label>
              <input
                type="date"
                value={dateRange.endDate}
                onChange={(e) =>
                  setDateRange({ ...dateRange, endDate: e.target.value })
                }
                style={{
                  width: "100%",
                  padding: "10px",
                  borderRadius: "8px",
                  border: "1px solid #ddd",
                }}
              />
            </div>

            <div style={{ display: "flex", alignItems: "flex-end" }}>
              <button
                onClick={generateReport}
                disabled={loading}
                style={{
                  padding: "10px 24px",
                  background: "#2D6A4F",
                  color: "white",
                  border: "none",
                  borderRadius: "8px",
                  cursor: "pointer",
                  fontWeight: "500",
                }}
              >
                {loading ? "Generating..." : "Generate Report"}
              </button>
            </div>
          </div>

          {reportData && (
            <div style={{ marginTop: "24px" }}>
              <h3 style={{ marginBottom: "16px" }}>Report Results</h3>
              <pre
                style={{
                  background: "#F5F5F5",
                  padding: "16px",
                  borderRadius: "8px",
                  overflow: "auto",
                  fontSize: "14px",
                }}
              >
                {JSON.stringify(reportData, null, 2)}
              </pre>

              <button
                onClick={() => {
                  const blob = new Blob([JSON.stringify(reportData, null, 2)], {
                    type: "application/json",
                  });
                  const url = URL.createObjectURL(blob);
                  const a = document.createElement("a");
                  a.href = url;
                  a.download = `agrovision-report-${reportType}-${Date.now()}.json`;
                  a.click();
                }}
                style={{
                  marginTop: "16px",
                  padding: "10px 24px",
                  background: "#52B788",
                  color: "white",
                  border: "none",
                  borderRadius: "8px",
                  cursor: "pointer",
                  fontWeight: "500",
                }}
              >
                📥 Download Report
              </button>
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
