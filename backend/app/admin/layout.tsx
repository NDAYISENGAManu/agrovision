import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Admin Backoffice - AgroVision",
  description: "AgroVision Admin Dashboard",
};

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
