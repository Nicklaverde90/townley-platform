import React from "react";

type Toast = { id: number; message: string };
type ToastContextValue = (message: string) => void;

const ToastContext = React.createContext<ToastContextValue>(() => undefined);

export function useToast(): ToastContextValue {
  return React.useContext(ToastContext);
}

function ToastMessage({ message, onClose }: { message: string; onClose: () => void }) {
  React.useEffect(() => {
    const t = setTimeout(onClose, 3000);
    return () => clearTimeout(t);
  }, [onClose]);

  return (
    <div
      role="status"
      aria-live="polite"
      className="fixed bottom-4 right-4 rounded-md border bg-white px-4 py-3 shadow"
    >
      {message}
    </div>
  );
}

export default function ToastProvider({ children }: { children: React.ReactNode }) {
  const [toasts, setToasts] = React.useState<Toast[]>([]);
  const idRef = React.useRef(0);

  const pushToast = React.useCallback((message: string) => {
    setToasts((current) => [...current, { id: ++idRef.current, message }]);
  }, []);

  const dismiss = React.useCallback((id: number) => {
    setToasts((current) => current.filter((toast) => toast.id !== id));
  }, []);

  return (
    <ToastContext.Provider value={pushToast}>
      {children}
      {toasts.map((toast) => (
        <ToastMessage key={toast.id} message={toast.message} onClose={() => dismiss(toast.id)} />
      ))}
    </ToastContext.Provider>
  );
}
