import { useEffect, useRef } from 'react'
import { cn } from '@/lib/utils'

interface Props {
  open: boolean
  onOpenChange: (open: boolean) => void
}

export function CommandPalette({ open, onOpenChange }: Props) {
  const inputRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    if (!open) return
    const id = requestAnimationFrame(() => inputRef.current?.focus())
    return () => cancelAnimationFrame(id)
  }, [open])

  useEffect(() => {
    if (!open) return
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        e.preventDefault()
        onOpenChange(false)
      }
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [open, onOpenChange])

  if (!open) return null

  return (
    <div
      className="fixed inset-0 z-50 flex items-start justify-center pt-[18vh] px-4 bg-background/80 backdrop-blur-[2px]"
      role="dialog"
      aria-modal="true"
      aria-label="Command palette"
      onMouseDown={(e) => {
        if (e.target === e.currentTarget) onOpenChange(false)
      }}
    >
      <div
        className="w-full max-w-lg rounded-md border bg-popover text-popover-foreground shadow-md p-2 space-y-2"
        onMouseDown={(e) => e.stopPropagation()}
      >
        <input
          ref={inputRef}
          placeholder="Search canvas… (stub)"
          aria-label="Command palette search"
          className={cn(
            'h-8 w-full min-w-0 rounded-md border-0 bg-transparent px-2 py-1 text-sm outline-none',
            'placeholder:text-muted-foreground focus-visible:ring-0',
          )}
        />
        <ul className="text-xs text-muted-foreground space-y-1 px-1 pb-1 max-h-48 overflow-auto">
          <li>Go to node… — later</li>
          <li>Filter by tag… — later</li>
          <li>Zoom: fit all — later</li>
          <li>New: note | chat | import — later</li>
        </ul>
      </div>
    </div>
  )
}
