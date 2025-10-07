import React, { useEffect } from 'react';
import { useAppStore } from '../store';
import { Calendar, Target, CheckSquare, MessageSquare, Home, Settings, Plus, Bookmark } from 'lucide-react';

interface AppShellProps {
  children: React.ReactNode;
}

const navigation = [
  { id: 'today', label: 'Today', icon: Home, shortcut: 'Y' },
  { id: 'tasks', label: 'Tasks', icon: CheckSquare, shortcut: 'T' },
  { id: 'goals', label: 'Goals', icon: Target, shortcut: 'G' },
  { id: 'calendar', label: 'Calendar', icon: Calendar, shortcut: 'C' },
  { id: 'reflections', label: 'Reflections', icon: MessageSquare, shortcut: 'R' },
  { id: 'saved', label: 'Saved Posts', icon: Bookmark, shortcut: 'B' },
  { id: 'settings', label: 'Settings', icon: Settings, shortcut: 'S' },
] as const;

export function AppShell({ children }: AppShellProps) {
  const { ui, updateUI, getCurrentStreak, getWeeklyMomentum } = useAppStore();
  const streak = getCurrentStreak();
  const momentum = getWeeklyMomentum();

  // Keyboard shortcuts
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      // Global shortcuts
      if (event.metaKey || event.ctrlKey) {
        switch (event.key.toLowerCase()) {
          case 'k':
            event.preventDefault();
            // TODO: Open command palette
            break;
        }
        return;
      }

      // Page shortcuts (only when not in input)
      if (
        event.target instanceof HTMLElement &&
        (event.target.tagName === 'INPUT' || 
         event.target.tagName === 'TEXTAREA' || 
         event.target.contentEditable === 'true')
      ) {
        return;
      }

      const shortcutMap: Record<string, typeof navigation[number]['id']> = {
        'y': 'today',
        't': 'tasks', 
        'g': 'goals',
        'c': 'calendar',
        'r': 'reflections',
        'b': 'saved',
        's': 'settings'
      };

      const page = shortcutMap[event.key.toLowerCase()];
      if (page) {
        event.preventDefault();
        updateUI({ currentPage: page });
      }
    };

    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [updateUI]);

  const formatDate = () => {
    return new Date().toLocaleDateString('en-US', {
      weekday: 'long',
      month: 'long',
      day: 'numeric'
    });
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-zinc-950 to-zinc-900">
      {/* Header */}
      <header className="sticky top-0 z-50 border-b border-zinc-800/50 backdrop-blur-xl">
        <div className="mx-auto max-w-7xl px-6">
          <div className="flex h-16 items-center justify-between">
            {/* Left: Navigation */}
            <nav className="flex items-center space-x-1">
              {navigation.map((item) => {
                const Icon = item.icon;
                const isActive = ui.currentPage === item.id;
                return (
                  <button
                    key={item.id}
                    onClick={() => updateUI({ currentPage: item.id })}
                    className={`
                      relative px-3 py-2 text-sm font-medium rounded-lg transition-colors duration-150 focus-glow
                      ${isActive 
                        ? 'bg-zinc-800 text-zinc-100' 
                        : 'text-zinc-400 hover:text-zinc-200 hover:bg-zinc-800/50'
                      }
                    `}
                    title={`${item.label} (${item.shortcut})`}
                  >
                    <div className="flex items-center gap-2">
                      <Icon size={16} />
                      <span>{item.label}</span>
                    </div>
                    {isActive && (
                      <div className="absolute bottom-0 left-1/2 h-0.5 w-8 -translate-x-1/2 bg-blue-500 rounded-full" />
                    )}
                  </button>
                );
              })}
            </nav>

            {/* Right: Stats and Actions */}
            <div className="flex items-center gap-3">
              {/* Momentum */}
              <div className="chip-muted">
                <span className="tabular-nums">{momentum} min</span>
                <span className="text-zinc-500">/wk</span>
              </div>

              {/* Streak */}
              <div className="chip-muted">
                <span className="text-orange-400">🔥</span>
                <span className="tabular-nums">{streak} days</span>
              </div>

              {/* Add Task */}
              <button className="btn-primary focus-glow">
                <Plus size={16} />
                <span>Add Task</span>
              </button>
            </div>
          </div>
        </div>
      </header>

      {/* Page Header */}
      <div className="border-b border-zinc-800/30 bg-zinc-900/50">
        <div className="mx-auto max-w-7xl px-6">
          <div className="flex h-20 items-center justify-between">
            <div>
              <h1 className="text-2xl font-semibold text-zinc-100">
                {navigation.find(n => n.id === ui.currentPage)?.label || 'Today'}
              </h1>
              {ui.currentPage === 'today' && (
                <p className="text-sm text-zinc-400 mt-1">{formatDate()}</p>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <main className="mx-auto max-w-7xl px-6 py-6">
        {children}
      </main>
    </div>
  );
}
