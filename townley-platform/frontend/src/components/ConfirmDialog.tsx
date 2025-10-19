import React from "react";

interface ConfirmDialogProps {
  open: boolean;
  title: string;
  description?: string;
  confirmText?: string;
  cancelText?: string;
  onConfirm: () => void;
  onCancel: () => void;
}

export default function ConfirmDialog({ open, title, description, confirmText="Confirm", cancelText="Cancel", onConfirm, onCancel }: ConfirmDialogProps) {
  if (!open) return null;
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4" role="dialog" aria-modal="true" aria-labelledby="confirm-title" aria-describedby="confirm-desc">
      <div className="absolute inset-0 bg-black/40" onClick={onCancel} aria-hidden="true" />
      <div className="relative z-10 w-full max-w-md rounded-xl bg-white p-4 shadow-xl">
        <h2 id="confirm-title" className="text-lg font-semibold">{title}</h2>
        {description && <p id="confirm-desc" className="mt-2 text-sm text-gray-600">{description}</p>}
        <div className="mt-4 flex justify-end gap-2">
          <button className="rounded-md border px-3 py-1" onClick={onCancel}>{cancelText}</button>
          <button className="rounded-md bg-red-600 px-3 py-1 text-white hover:bg-red-700" onClick={onConfirm}>{confirmText}</button>
        </div>
      </div>
    </div>
  );
}