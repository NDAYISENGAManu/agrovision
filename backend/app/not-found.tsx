"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

export default function NotFound() {
  const router = useRouter();
  const [canGoBack, setCanGoBack] = useState(false);

  useEffect(() => {
    // Check if browser history is available to go back
    setCanGoBack(window.history.length > 1);
  }, []);

  const handleBack = () => {
    router.back();
  };

  return (
    <main
      style={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        height: "100vh",
        background: "var(--background, #f5f5f5)",
        color: "var(--foreground, #333333)",
        padding: 24,
        fontFamily:
          '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
      }}
    >
      <div
        style={{
          textAlign: "center",
          maxWidth: "500px",
          animation: "fadeIn 0.6s ease-in-out",
        }}
      >
        <div
          style={{
            fontSize: 120,
            fontWeight: "bold",
            color: "var(--primary-light, #60ad5e)",
            margin: "0 0 8px 0",
            lineHeight: 1,
            // opacity: 0.2,
          }}
        >
          404
        </div>
        <h1
          style={{
            fontSize: 32,
            color: "var(--primary-dark, #005005)",
            margin: "0 0 12px 0",
            fontWeight: 600,
          }}
        >
          Page Not Found
        </h1>
        <p
          style={{
            fontSize: 16,
            color: "var(--foreground, #333333)",
            margin: "0 0 32px 0",
            lineHeight: 1.6,
          }}
        >
          Sorry, we couldn't find the page you're looking for. It might have
          been moved or deleted.
        </p>
        <div
          style={{
            display: "flex",
            gap: 12,
            justifyContent: "center",
            flexWrap: "wrap",
          }}
        >
          <button
            onClick={handleBack}
            style={{
              padding: "12px 28px",
              background: "var(--primary, #2e7d32)",
              color: "var(--white, #ffffff)",
              borderRadius: 8,
              border: "none",
              textDecoration: "none",
              fontWeight: 600,
              fontSize: 14,
              transition: "all 0.3s ease",
              boxShadow: "0 4px 15px rgba(46, 125, 50, 0.2)",
              cursor: "pointer",
            }}
          >
            ← Go Back
          </button>
          <button
            onClick={handleBack}
            style={{
              padding: "12px 28px",
              border: "2px solid var(--primary, #2e7d32)",
              background: "transparent",
              color: "var(--primary, #2e7d32)",
              borderRadius: 8,
              textDecoration: "none",
              fontWeight: 600,
              fontSize: 14,
              transition: "all 0.3s ease",
              cursor: "pointer",
            }}
          >
            ↻ Retry
          </button>
        </div>
      </div>
      <style>
        {`
          @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
          }
        `}
      </style>
    </main>
  );
}
