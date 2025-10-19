import React from "react";

interface Column<T> {
  header: string;
  accessor: (row: T) => React.ReactNode;
  key: string;
}

interface Props<T> {
  caption: string;
  columns: Column<T>[];
  data: T[];
  emptyMessage?: string;
}

export default function DataTable<T>({ caption, columns, data, emptyMessage = "No results." }: Props<T>) {
  return (
    <div className="overflow-auto rounded-xl border border-gray-200 focus-within:ring-2">
      <table className="min-w-full text-sm" role="table">
        <caption className="sr-only">{caption}</caption>
        <thead className="bg-gray-50">
          <tr>
            {columns.map((col) => (
              <th
                key={col.key}
                scope="col"
                className="px-3 py-2 text-left font-semibold text-gray-700"
                tabIndex={0}
              >
                {col.header}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {data.length === 0 ? (
            <tr>
              <td colSpan={columns.length} className="px-3 py-6 text-center text-gray-500">
                {emptyMessage}
              </td>
            </tr>
          ) : (
            data.map((row, i) => (
              <tr key={i} className="odd:bg-white even:bg-gray-50">
                {columns.map((col) => (
                  <td key={col.key} className="px-3 py-2 align-top">
                    {col.accessor(row)}
                  </td>
                ))}
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
}