import React from "react";

export default function Toast({ message, onClose }: { message: string; onClose: () => void }) {
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