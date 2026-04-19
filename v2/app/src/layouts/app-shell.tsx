import { useCallback, useEffect, useState, type ReactNode } from 'react'
import {
  StickyNote,
  ListTodo,
  BookOpen,
  GitBranch,
  FlaskConical,
  Bot,
  Megaphone,
  Settings,
} from 'lucide-react'
import { NotesPage } from '@/pages/notes'
import { TasksPage } from '@/pages/tasks'
import { PortfolioPage } from '@/pages/portfolio'
import { CodeAgentsPage } from '@/pages/code-agents'
import { SandboxPage } from '@/pages/sandbox'
import { AgentRunnerPage } from '@/pages/agent-runner'
import { SocialsPage } from '@/pages/socials'
import { SetupConfigPage } from '@/pages/setup-config'
import {
  PATHS_ACTIVATE_NOTES_EVENT,
  type PathsActivateNotesDetail,
} from '@/lib/paths-notes-bridge'

type TenantId =
  | 'notes'
  | 'tasks'
  | 'portfolio'
  | 'code-agents'
  | 'sandbox'
  | 'agents'
  | 'socials'
  | 'setup'

interface Tenant {
  id: TenantId
  label: string
  icon: typeof StickyNote
  render: () => ReactNode
}

const TENANTS: Tenant[] = [
  { id: 'notes', label: 'Notes & Chats', icon: StickyNote, render: () => <NotesPage /> },
  { id: 'tasks', label: 'Tasks & Goals', icon: ListTodo, render: () => <TasksPage /> },
  { id: 'portfolio', label: 'Portfolio', icon: BookOpen, render: () => <PortfolioPage /> },
  { id: 'code-agents', label: 'GitHub & Code Agents', icon: GitBranch, render: () => <CodeAgentsPage /> },
  { id: 'sandbox', label: 'Sandbox', icon: FlaskConical, render: () => <SandboxPage /> },
  { id: 'agents', label: 'Agent Runner', icon: Bot, render: () => <AgentRunnerPage /> },
  { id: 'socials', label: 'Socials & Research', icon: Megaphone, render: () => <SocialsPage /> },
  { id: 'setup', label: 'Setup', icon: Settings, render: () => <SetupConfigPage /> },
]

const STORAGE_KEY = 'paths:nav:active'

export function AppShell() {
  const [active, setActive] = useState<TenantId>(() => {
    if (typeof window === 'undefined') return 'notes'
    const stored = window.localStorage.getItem(STORAGE_KEY)
    // Graph tenant removed: canvas is the graph; old prefs fall back to Notes.
    if (stored === 'graph') return 'notes'
    return (TENANTS.find((t) => t.id === stored)?.id ?? 'notes') as TenantId
  })
  const [notesFocusRequestId, setNotesFocusRequestId] = useState<string | null>(null)

  const go = useCallback((id: TenantId) => {
    setActive(id)
    try {
      window.localStorage.setItem(STORAGE_KEY, id)
    } catch {}
  }, [])

  useEffect(() => {
    const onActivateNotes = (e: Event) => {
      const ce = e as CustomEvent<PathsActivateNotesDetail>
      const id = ce.detail?.focusId
      setNotesFocusRequestId(id && id.length > 0 ? id : null)
      go('notes')
    }
    window.addEventListener(PATHS_ACTIVATE_NOTES_EVENT, onActivateNotes)
    return () => window.removeEventListener(PATHS_ACTIVATE_NOTES_EVENT, onActivateNotes)
  }, [go])

  const clearNotesFocusRequest = useCallback(() => {
    setNotesFocusRequestId(null)
  }, [])

  const current = TENANTS.find((t) => t.id === active) ?? TENANTS[0]

  return (
    <div className="flex min-h-screen bg-background text-foreground">
      <aside className="w-56 shrink-0 border-r flex flex-col">
        <div className="px-4 py-4 border-b">
          <div className="text-sm font-medium tracking-tight">paths</div>
          <div className="text-xs text-muted-foreground">v2 · hub</div>
        </div>
        <nav className="flex-1 p-2 space-y-0.5">
          {TENANTS.map((t) => {
            const Icon = t.icon
            const isActive = t.id === active
            return (
              <button
                key={t.id}
                type="button"
                onClick={() => go(t.id)}
                className={
                  'w-full flex items-center gap-2 px-2 py-1.5 rounded-sm text-sm text-left ' +
                  (isActive
                    ? 'bg-accent text-accent-foreground'
                    : 'text-muted-foreground hover:bg-accent/50 hover:text-foreground')
                }
              >
                <Icon size={16} strokeWidth={1.75} />
                <span>{t.label}</span>
              </button>
            )
          })}
        </nav>
        <div className="p-3 border-t text-[11px] text-muted-foreground leading-tight">
          Slice 0 shell. Tenant pages are stubs until their slice lands.
        </div>
      </aside>

      <div className="flex-1 min-w-0 overflow-auto">
        {active === 'notes' ? (
          <NotesPage
            focusRequestId={notesFocusRequestId}
            onFocusRequestHandled={clearNotesFocusRequest}
          />
        ) : (
          current.render()
        )}
      </div>
    </div>
  )
}
