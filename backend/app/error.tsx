"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState, useEffect } from "react";

export default function Error({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  const router = useRouter();
  const [showDetails, setShowDetails] = useState(false);
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
            color: "var(--secondary, #ffa000)",
            margin: "0 0 8px 0",
            lineHeight: 1,
            // opacity: 0.2,
          }}
        >
          500
        </div>
        <h1
          style={{
            fontSize: 32,
            color: "var(--primary-dark, #005005)",
            margin: "0 0 12px 0",
            fontWeight: 600,
          }}
        >
          Something Went Wrong
        </h1>
        <p
          style={{
            fontSize: 16,
            color: "var(--foreground, #333333)",
            margin: "0 0 24px 0",
            lineHeight: 1.6,
          }}
        >
          We're sorry! An unexpected error occurred. Our team has been notified.
        </p>
        {error?.message && (
          <div
            style={{
              marginBottom: 24,
              maxHeight: showDetails ? "200px" : "0",
              overflow: "hidden",
              transition: "max-height 0.3s ease",
            }}
          >
            <details
              style={{
                background: "rgba(46, 125, 50, 0.05)",
                border: "1px solid var(--primary-light, #60ad5e)",
                borderRadius: 8,
                padding: 12,
                cursor: "pointer",
              }}
              onClick={(e) => {
                e.preventDefault();
                setShowDetails(!showDetails);
              }}
            >
              <summary
                style={{
                  color: "var(--primary, #2e7d32)",
                  fontSize: 14,
                  fontWeight: 500,
                  cursor: "pointer",
                }}
              >
                {showDetails ? "Hide" : "Show"} Error Details
              </summary>
              {showDetails && (
                <pre
                  style={{
                    margin: "12px 0 0 0",
                    color: "var(--foreground, #333333)",
                    fontSize: 12,
                    whiteSpace: "pre-wrap",
                    wordBreak: "break-word",
                  }}
                >
                  {error.message}
                </pre>
              )}
            </details>
          </div>
        )}
        <div
          style={{
            display: "flex",
            gap: 12,
            justifyContent: "center",
            flexWrap: "wrap",
          }}
        >
          <button
            onClick={() => reset()}
            style={{
              padding: "12px 28px",
              background: "var(--secondary, #ffa000)",
              color: "var(--white, #ffffff)",
              borderRadius: 8,
              border: "none",
              fontWeight: 600,
              fontSize: 14,
              cursor: "pointer",
              transition: "all 0.3s ease",
              boxShadow: "0 4px 15px rgba(255, 160, 0, 0.2)",
            }}
          >
            ↻ Try Again
          </button>
          <button
            onClick={handleBack}
            style={{
              padding: "12px 28px",
              border: "2px solid var(--primary, #2e7d32)",
              background: "transparent",
              color: "var(--primary, #2e7d32)",
              borderRadius: 8,
              fontWeight: 600,
              fontSize: 14,
              cursor: "pointer",
              transition: "all 0.3s ease",
              display: "inline-block",
            }}
          >
            ← Go Back
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
