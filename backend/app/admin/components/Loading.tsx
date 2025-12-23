"use client";

import React from "react";

interface LoadingProps {
  text?: string;
}

export default function Loading({ text = "Loading dashboard..." }: LoadingProps) {
  return (
    <div className="loadingContainer">
      <div className="spinner"></div>
      <div className="loadingText">{text}</div>
    </div>
  );
}
