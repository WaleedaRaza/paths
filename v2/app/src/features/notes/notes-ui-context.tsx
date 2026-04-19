import { createContext, useContext, type ReactNode } from 'react'
import type { LodBand, LodMode } from '@/features/notes/canvas/get-lod'

export interface NotesUiContextValue {
  lodMode: LodMode
  setLodMode: (m: LodMode) => void
  effectiveLod: LodBand
  commandPaletteOpen: boolean
  setCommandPaletteOpen: (open: boolean) => void
}

const NotesUiContext = createContext<NotesUiContextValue | null>(null)

export function useNotesUi() {
  const v = useContext(NotesUiContext)
  if (!v) throw new Error('useNotesUi must be used under NotesUiProvider')
  return v
}

export function NotesUiProvider({
  children,
  value,
}: {
  children: ReactNode
  value: NotesUiContextValue
}) {
  return <NotesUiContext.Provider value={value}>{children}</NotesUiContext.Provider>
}
