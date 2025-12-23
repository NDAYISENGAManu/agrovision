"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";

export function AuthRedirect() {
  const router = useRouter();

  useEffect(() => {
    const token = localStorage.getItem("token");

    if (token) {
      router.push("/admin/dashboard");
    } else {
      router.push("/admin");
    }
  }, [router]);

  return null;
}
