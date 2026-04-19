import { useCallback, useState } from 'react'
import { Button } from '@/components/ui/button'
import { createNodeId, type SceneNode } from '@/features/notes/scene/scene-schema'

interface Props {
  open: boolean
  onOpenChange: (open: boolean) => void
  onImport: (node: SceneNode) => void
  spawnIndex: number
}

export function ImportModal({ open, onOpenChange, onImport, spawnIndex }: Props) {
  const [fileName, setFileName] = useState('notes.md')
  const [body, setBody] = useState('# Imported\n\nPaste or choose a file.')

  const commit = useCallback(() => {
    const node: SceneNode = {
      id: createNodeId(),
      kind: 'import',
      title: fileName.trim() || 'import.md',
      x: 96 + (spawnIndex % 5) * 40,
      y: 96 + Math.floor(spawnIndex / 5) * 36,
      width: 360,
      height: 280,
      tags: [{ name: 'import', color: '#64748b' }],
      previewMarkdown: body,
      sourceFileName: fileName.trim() || 'import.md',
    }
    onImport(node)
    onOpenChange(false)
  }, [body, fileName, onImport, onOpenChange, spawnIndex])

  if (!open) return null

  return (
    <div
      className="fixed inset-0 z-[100] flex items-center justify-center bg-background/80 p-4"
      role="dialog"
      aria-modal="true"
      aria-label="Import markdown"
      onMouseDown={(e) => {
        if (e.target === e.currentTarget) onOpenChange(false)
      }}
    >
      <div
        className="w-full max-w-md rounded-lg border bg-card shadow-md p-4 space-y-3"
        onMouseDown={(e) => e.stopPropagation()}
      >
        <div className="text-base font-semibold">Import markdown</div>
        <div className="flex gap-2">
          <input
            className="flex-1 rounded-md border border-input bg-background px-3 py-2 text-base"
            value={fileName}
            onChange={(e) => setFileName(e.target.value)}
            placeholder="Title"
          />
          <label className="shrink-0 cursor-pointer rounded-md border border-input px-3 py-2 text-sm font-medium hover:bg-muted/50">
            File
            <input
              type="file"
              accept=".md,.markdown,.txt,text/markdown"
              className="hidden"
              onChange={(e) => {
                const f = e.target.files?.[0]
                if (!f) return
                setFileName(f.name)
                f.text().then(setBody).catch(() => {})
              }}
            />
          </label>
        </div>
        <textarea
          className="w-full min-h-[200px] rounded-md border border-input bg-background px-3 py-2 text-sm font-mono leading-relaxed"
          value={body}
          onChange={(e) => setBody(e.target.value)}
        />
        <div className="flex justify-end gap-2">
          <Button type="button" variant="ghost" size="sm" onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button type="button" size="sm" onClick={commit}>
            Add
          </Button>
        </div>
      </div>
    </div>
  )
}
