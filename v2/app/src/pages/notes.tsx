import { NotesMindMap } from '@/features/notes/shell/notes-mind-map'

interface Props {
  focusRequestId?: string | null
  onFocusRequestHandled?: () => void
}

export function NotesPage({ focusRequestId = null, onFocusRequestHandled }: Props) {
  return (
    <NotesMindMap focusRequestId={focusRequestId} onFocusRequestHandled={onFocusRequestHandled} />
  )
}
