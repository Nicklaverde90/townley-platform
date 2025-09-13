import api from "./api";

export interface Me {
  email: string;
  is_admin?: boolean;
  role?: "viewer" | "editor" | "admin";
}

export async function me(): Promise<Me> {
  const resp = await api.get<Me>("/users/me");
  return resp.data;
}

export function auditStreamUrl(): string {
  const token = localStorage.getItem("access_token");
  const base = "/api/audit/stream";
  const url = new URL(base, window.location.origin);
  if (token) url.searchParams.set("token", token);
  return url.toString();
}