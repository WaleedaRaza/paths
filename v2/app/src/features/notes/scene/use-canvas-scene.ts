import { useCallback, useEffect, useState } from 'react'
import { dedupeUndirectedLinks } from '@/features/notes/scene/link-utils'
import {
  CANVAS_SCENE_STORAGE_KEY,
  type CanvasScene,
  emptyScene,
} from '@/features/notes/scene/scene-schema'

function parseScene(raw: string | null): CanvasScene {
  if (!raw) return emptyScene()
  try {
    const data = JSON.parse(raw) as Partial<CanvasScene>
    if (data.version !== 1 || !Array.isArray(data.nodes) || !Array.isArray(data.links)) {
      return emptyScene()
    }
    return {
      version: 1,
      nodes: data.nodes,
      links: dedupeUndirectedLinks(data.links as CanvasScene['links']),
    }
  } catch {
    return emptyScene()
  }
}

export function useCanvasScene() {
  const [scene, setScene] = useState<CanvasScene>(() => {
    if (typeof window === 'undefined') return emptyScene()
    return parseScene(window.localStorage.getItem(CANVAS_SCENE_STORAGE_KEY))
  })

  useEffect(() => {
    const t = window.setTimeout(() => {
      try {
        window.localStorage.setItem(CANVAS_SCENE_STORAGE_KEY, JSON.stringify(scene))
      } catch {
        /* quota or private mode */
      }
    }, 400)
    return () => window.clearTimeout(t)
  }, [scene])

  const replaceScene = useCallback((next: CanvasScene) => {
    setScene(next)
  }, [])

  return { scene, setScene, replaceScene }
}
