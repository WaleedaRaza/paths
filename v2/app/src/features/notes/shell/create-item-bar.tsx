import { useCallback, useEffect, useState } from 'react'
import { FileDown, MessageSquare, StickyNote, X } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { defaultMockModelId, MOCK_MODELS } from '@/features/notes/mock/mock-llm'
import { PERSONAS } from '@/features/notes/data/personas'
import { TAG_PRESETS } from '@/lib/tag-presets'
import type { Tag } from '@/features/notes/scene/scene-schema'

export type CreateBarMode = 'note' | 'chat'

interface Props {
  open: boolean
  onClose: () => void
  onImportClick: () => void
  onCommitNote: (payload: { title: string; tags: Tag[] }) => void
  onCommitChat: (payload: { title: string; tags: Tag[]; personaIds: string[]; mockModelId: string }) => void
}

export function CreateItemBar({
  open,
  onClose,
  onImportClick,
  onCommitNote,
  onCommitChat,
}: Props) {
  const [mode, setMode] = useState<CreateBarMode>('note')
  const [title, setTitle] = useState('')
  const [tagName, setTagName] = useState('')
  const [tagColor, setTagColor] = useState(TAG_PRESETS[0]?.color ?? '#64748b')
  const [draftTags, setDraftTags] = useState<Tag[]>([])
  const [personaId, setPersonaId] = useState(PERSONAS[2]?.id ?? 'planner')
  const [mockModelId, setMockModelId] = useState(defaultMockModelId())

  useEffect(() => {
    if (!open) return
    setTitle('')
    setTagName('')
    setDraftTags([])
    setTagColor(TAG_PRESETS[0]?.color ?? '#64748b')
    setPersonaId(PERSONAS[2]?.id ?? 'planner')
    setMockModelId(defaultMockModelId())
  }, [open, mode])

  const addDraftTag = useCallback(() => {
    const name = tagName.trim()
    if (!name) return
    if (draftTags.some((t) => t.name.toLowerCase() === name.toLowerCase())) return
    setDraftTags((t) => [...t, { name, color: tagColor }])
    setTagName('')
  }, [draftTags, tagColor, tagName])

  const removeDraftTag = useCallback((name: string) => {
    setDraftTags((t) => t.filter((x) => x.name !== name))
  }, [])

  const commit = useCallback(() => {
    const t = title.trim()
    if (mode === 'note') {
      onCommitNote({ title: t || 'Untitled note', tags: draftTags })
    } else {
      onCommitChat({
        title: t || 'Conversation',
        tags: draftTags,
        personaIds: personaId ? [personaId] : [],
        mockModelId,
      })
    }
    onClose()
  }, [mode, title, draftTags, personaId, mockModelId, onCommitNote, onCommitChat, onClose])

  if (!open) return null

  return (
    <div className="shrink-0 border-b bg-muted/25 px-3 py-2 z-20">
      <div className="flex flex-wrap items-center gap-2">
        <div className="flex rounded-md border border-input bg-background p-0.5 gap-0.5">
          <button
            type="button"
            className={
              'flex items-center gap-1 rounded-sm px-2 py-1 text-[11px] font-medium ' +
              (mode === 'note' ? 'bg-accent text-accent-foreground' : 'text-muted-foreground hover:text-foreground')
            }
            onClick={() => setMode('note')}
          >
            <StickyNote className="size-3" strokeWidth={1.75} />
            Note
          </button>
          <button
            type="button"
            className={
              'flex items-center gap-1 rounded-sm px-2 py-1 text-[11px] font-medium ' +
              (mode === 'chat' ? 'bg-accent text-accent-foreground' : 'text-muted-foreground hover:text-foreground')
            }
            onClick={() => setMode('chat')}
          >
            <MessageSquare className="size-3" strokeWidth={1.75} />
            Conversation
          </button>
        </div>
        <Button
          type="button"
          variant="ghost"
          size="sm"
          className="h-7 text-[11px] gap-1 text-muted-foreground"
          onClick={() => {
            onImportClick()
            onClose()
          }}
        >
          <FileDown className="size-3.5" strokeWidth={1.75} />
          Import
        </Button>
        <div className="flex-1" />
        <Button type="button" variant="ghost" size="icon" className="size-7 shrink-0" onClick={onClose} title="Close">
          <X className="size-4" strokeWidth={1.75} />
        </Button>
      </div>

      <div className="mt-2 flex flex-wrap gap-x-3 gap-y-2 items-end">
        <div className="min-w-[120px] flex-1">
          <input
            className="w-full rounded-md border border-input bg-background px-2 py-1.5 text-sm"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder={mode === 'chat' ? 'Conversation title' : 'Note title'}
          />
        </div>

        {mode === 'chat' ? (
          <>
            <div className="min-w-[160px] flex-1">
              <select
                className="w-full rounded-md border border-input bg-background px-2 py-1.5 text-sm"
                value={personaId}
                title={PERSONAS.find((p) => p.id === personaId)?.shortDescription}
                onChange={(e) => setPersonaId(e.target.value)}
              >
                {PERSONAS.map((p) => (
                  <option key={p.id} value={p.id} title={p.shortDescription}>
                    {p.icon} {p.name}
                  </option>
                ))}
              </select>
            </div>
            <div className="min-w-[140px]">
              <select
                className="w-full rounded-md border border-input bg-background px-2 py-1.5 text-sm"
                value={mockModelId}
                onChange={(e) => setMockModelId(e.target.value)}
              >
                {MOCK_MODELS.map((m) => (
                  <option key={m.id} value={m.id}>
                    {m.vendor} · {m.model}
                  </option>
                ))}
              </select>
            </div>
          </>
        ) : null}

        <div className="min-w-[180px] flex-[2] flex flex-wrap items-center gap-1">
          {draftTags.map((t) => (
            <button
              key={t.name}
              type="button"
              className="rounded-full px-2 py-0.5 text-[10px] text-white max-w-[100px] truncate"
              style={{ backgroundColor: t.color }}
              onClick={() => removeDraftTag(t.name)}
              title="Remove"
            >
              {t.name} ×
            </button>
          ))}
          <input
            className="w-24 rounded-md border border-input bg-background px-2 py-1 text-xs"
            value={tagName}
            onChange={(e) => setTagName(e.target.value)}
            placeholder="Tag"
            onKeyDown={(e) => {
              if (e.key === 'Enter') {
                e.preventDefault()
                addDraftTag()
              }
            }}
          />
          {TAG_PRESETS.map((p) => (
            <button
              key={p.color}
              type="button"
              className={'size-4 rounded-sm border ' + (tagColor === p.color ? 'border-foreground' : 'border-transparent')}
              style={{ backgroundColor: p.color }}
              title={p.label}
              onClick={() => setTagColor(p.color)}
            />
          ))}
          <Button type="button" variant="secondary" size="sm" className="h-7 text-[11px] px-2" onClick={addDraftTag}>
            +
          </Button>
        </div>

        <Button type="button" size="sm" className="h-8" onClick={commit}>
          Add
        </Button>
      </div>
    </div>
  )
}
