import { useCallback, useState } from 'react'

export function useSelection() {
  const [selectedIds, setSelectedIds] = useState<Set<string>>(() => new Set())

  const clear = useCallback(() => {
    setSelectedIds(new Set())
  }, [])

  const selectOnly = useCallback((id: string) => {
    setSelectedIds(new Set([id]))
  }, [])

  const toggle = useCallback((id: string, additive: boolean) => {
    setSelectedIds((prev) => {
      if (!additive) return new Set([id])
      const next = new Set(prev)
      if (next.has(id)) next.delete(id)
      else next.add(id)
      return next
    })
  }, [])

  const isSelected = useCallback((id: string) => selectedIds.has(id), [selectedIds])

  return { selectedIds, clear, selectOnly, toggle, isSelected }
}
