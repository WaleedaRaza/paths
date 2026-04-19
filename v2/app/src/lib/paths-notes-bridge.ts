/** Cross-tenant bridge: jump to Notes & optionally focus a canvas node by id. */

export const PATHS_ACTIVATE_NOTES_EVENT = 'paths:activate-notes' as const

export type PathsActivateNotesDetail = {
  focusId?: string
}

export function dispatchActivateNotes(detail?: PathsActivateNotesDetail): void {
  if (typeof window === 'undefined') return
  window.dispatchEvent(
    new CustomEvent<PathsActivateNotesDetail>(PATHS_ACTIVATE_NOTES_EVENT, {
      detail: detail ?? {},
    }),
  )
}
