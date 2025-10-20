import * as React from "react";

/**
 * Accessible Tabs with roving tabindex, arrow navigation, and ARIA roles.
 * Usage:
 * <Tabs labels={['One','Two']} value={idx} onChange={setIdx}>
 *   <Tabs.Panel>...</Tabs.Panel>
 *   <Tabs.Panel>...</Tabs.Panel>
 * </Tabs>
 */
type TabsProps = {
  labels: string[];
  value: number;
  onChange: (index: number) => void;
  className?: string;
  children: React.ReactNode;
};

export function Tabs({ labels, value, onChange, className, children }: TabsProps) {
  const ids = React.useMemo(
    () => labels.map((_, i) => ({
      tab: `tab-${i}-${Math.random().toString(36).slice(2,8)}`,
      panel: `panel-${i}-${Math.random().toString(36).slice(2,8)}`
    })),
    [labels]
  );
  const listRef = React.useRef<HTMLDivElement>(null);

  const onKeyDown = (e: React.KeyboardEvent) => {
    const last = labels.length - 1;
    if (e.key === "ArrowRight" || e.key === "ArrowDown") {
      e.preventDefault();
      onChange(value >= last ? 0 : value + 1);
    } else if (e.key === "ArrowLeft" || e.key === "ArrowUp") {
      e.preventDefault();
      onChange(value <= 0 ? last : value - 1);
    } else if (e.key === "Home") {
      e.preventDefault();
      onChange(0);
    } else if (e.key === "End") {
      e.preventDefault();
      onChange(last);
    }
  };

  return (
    <div className={className}>
      <div
        role="tablist"
        aria-label="Stages"
        className="flex flex-wrap gap-2 border-b border-gray-200"
        onKeyDown={onKeyDown}
        ref={listRef}
      >
        {labels.map((label, i) => (
          <button
            key={label}
            id={ids[i].tab}
            role="tab"
            aria-controls={ids[i].panel}
            aria-selected={value === i}
            tabIndex={value === i ? 0 : -1}
            className={
              "rounded-t-lg px-3 py-2 text-sm font-medium focus:outline-none focus:ring-2 " +
              (value === i
                ? "bg-white border-x border-t border-gray-200 -mb-px"
                : "bg-gray-100 text-gray-700 hover:bg-gray-200")
            }
            onClick={() => onChange(i)}
          >
            {label}
          </button>
        ))}
      </div>
      <div>
        {React.Children.map(children, (child, i) => {
          if (!React.isValidElement(child)) return null;
          return React.cloneElement(child as any, {
            id: ids[i].panel,
            tabId: ids[i].tab,
            active: value === i,
            hidden: value !== i,
          });
        })}
      </div>
    </div>
  );
}

type PanelProps = {
  children: React.ReactNode;
  id?: string;
  tabId?: string;
  active?: boolean;
  hidden?: boolean;
  className?: string;
};

Tabs.Panel = function Panel({ children, id, tabId, active, hidden, className }: PanelProps) {
  return (
    <section
      role="tabpanel"
      id={id}
      aria-labelledby={tabId}
      hidden={hidden}
      className={className}
      tabIndex={0}
    >
      {active ? children : null}
    </section>
  );
};
