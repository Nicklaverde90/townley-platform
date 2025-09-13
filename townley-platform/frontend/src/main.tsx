// src/main.tsx
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter, Routes, Route, Navigate, Link } from "react-router-dom";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import "./index.css";

// Pages (make sure these exist based on the patches you've applied)
import LoginPage from "./pages/Login";
import DashboardPage from "./pages/Dashboard";
import WorkOrdersPage from "./pages/WorkOrders";
import StagesPage from "./pages/Stages";
import AuditLogPage from "./pages/AuditLog";
import AuditLivePage from "./pages/AuditLive";

// Auth/role guard
import ProtectedRoute from "./components/ProtectedRoute";

// Toasts
import ToastProvider from "./components/Toast";

// Optional: tiny header component
function AppHeader() {
  return (
    <header className="sticky top-0 z-30 border-b bg-white/90 backdrop-blur">
      <div className="mx-auto flex max-w-6xl items-center justify-between px-4 py-3">
        <Link to="/" className="text-lg font-bold focus:outline-none focus:ring-2">
          Townley Platform
        </Link>
        <nav aria-label="Primary" className="flex gap-4 text-sm">
          <Link className="hover:underline focus:outline-none focus:ring-2" to="/">Dashboard</Link>
          <Link className="hover:underline focus:outline-none focus:ring-2" to="/workorders">Work Orders</Link>
          <Link className="hover:underline focus:outline-none focus:ring-2" to="/stages">Stages</Link>
          <Link className="hover:underline focus:outline-none focus:ring-2" to="/audit">Audit</Link>
          <Link className="hover:underline focus:outline-none focus:ring-2" to="/audit/live">Live</Link>
          <Link className="hover:underline focus:outline-none focus:ring-2" to="/login">Login</Link>
        </nav>
      </div>
    </header>
  );
}

// Basic 404
function NotFound() {
  return (
    <main className="mx-auto max-w-3xl p-6">
      <h1 className="mb-2 text-2xl font-bold">Page not found</h1>
      <p className="text-gray-600">The page you’re looking for doesn’t exist.</p>
      <div className="mt-4">
        <Link to="/" className="text-blue-700 underline">Go home</Link>
      </div>
    </main>
  );
}

const queryClient = new QueryClient();

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    {/* Skip link for keyboard users */}
    <a
      href="#main"
      className="sr-only focus:not-sr-only focus:fixed focus:left-4 focus:top-4 focus:z-[1000] focus:rounded-md focus:bg-black focus:px-3 focus:py-2 focus:text-white"
    >
      Skip to content
    </a>

    {/* Global ARIA live region for inline announcements (non-toast) */}
    <div aria-live="polite" aria-atomic="true" className="sr-only" />

    <QueryClientProvider client={queryClient}>
      <ToastProvider>
        <BrowserRouter>
          <AppHeader />
          <div id="main">
            <Routes>
              {/* Public */}
              <Route path="/login" element={<LoginPage />} />

              {/* Protected (viewer or higher) */}
              <Route
                path="/"
                element={
                  <ProtectedRoute minRole="viewer">
                    <DashboardPage />
                  </ProtectedRoute>
                }
              />
              <Route
                path="/workorders"
                element={
                  <ProtectedRoute minRole="viewer">
                    <WorkOrdersPage />
                  </ProtectedRoute>
                }
              />
              <Route
                path="/stages"
                element={
                  <ProtectedRoute minRole="editor">
                    <StagesPage />
                  </ProtectedRoute>
                }
              />

              {/* Audit: view requires viewer, live tail too */}
              <Route
                path="/audit"
                element={
                  <ProtectedRoute minRole="viewer">
                    <AuditLogPage />
                  </ProtectedRoute>
                }
              />
              <Route
                path="/audit/live"
                element={
                  <ProtectedRoute minRole="viewer">
                    <AuditLivePage />
                  </ProtectedRoute>
                }
              />

              {/* Redirect legacy or unknown */}
              <Route path="/home" element={<Navigate to="/" replace />} />
              <Route path="*" element={<NotFound />} />
            </Routes>
          </div>
        </BrowserRouter>
      </ToastProvider>
    </QueryClientProvider>
  </StrictMode>
);
