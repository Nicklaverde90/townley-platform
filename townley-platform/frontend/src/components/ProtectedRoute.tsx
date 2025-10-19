import React from "react";
import { Navigate } from "react-router-dom";

type Role = "viewer" | "editor" | "admin";
const order: Record<Role, number> = { viewer: 0, editor: 1, admin: 2 };

interface Props {
  children: React.ReactNode;
  minRole?: Role;
}

export default function ProtectedRoute({ children, minRole = "viewer" }: Props) {
  const token = typeof window !== "undefined" ? localStorage.getItem("access_token") : null;
  const role = (typeof window !== "undefined" ? localStorage.getItem("role") : "viewer") as Role;

  if (!token) return <Navigate to="/login" replace />;
  if (order[role] < order[minRole]) return <Navigate to="/" replace />;
  return <>{children}</>;
}