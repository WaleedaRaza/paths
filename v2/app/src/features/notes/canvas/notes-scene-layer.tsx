import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import type { useWorldTransform } from '@/features/notes/canvas/use-world-transform'
import { EdgeLayer } from '@/features/notes/canvas/edge-layer'
import { SceneNodeView } from '@/features/notes/canvas/scene-node-view'
import type { LodBand } from '@/features/notes/canvas/get-lod'
import type { CanvasScene, EdgeKind, SceneNode } from '@/features/notes/scene/scene-schema'

type World = ReturnType<typeof useWorldTransform>

export type CanvasTool = 'select' | 'hand' | 'link' | 'lasso'

interface Props {
  scene: CanvasScene
  setScene: React.Dispatch<React.SetStateAction<CanvasScene>>
  effectiveLod: LodBand
  activeTool: CanvasTool
  selectedIds: Set<string>
  selectOnly: (id: string) => void
  toggleSelect: (id: string, additive: boolean) => void
  clearSelection: () => void
  world: World
  tagFilter: Set<string>
  filterOrMode: boolean
  linkFromId: string | null
  setLinkFromId: (id: string | null) => void
  onLinkNodes: (fromId: string, toId: string, kind?: EdgeKind) => void
  /** Viewport-relative screen → world (uses pan/zoom). */
  clientToWorld: (clientX: number, clientY: number) => { x: number; y: number }
  onLassoComplete: (polygon: { x: number; y: number }[]) => void
}

function pathLength(pts: { x: number; y: number }[]): number {
  let d = 0
  for (let i = 1; i < pts.length; i++) {
    const dx = pts[i].x - pts[i - 1].x
    const dy = pts[i].y - pts[i - 1].y
    d += Math.hypot(dx, dy)
  }
  return d
}

function lassoPathD(pts: { x: number; y: number }[]): string {
  if (pts.length === 0) return ''
  const [p0, ...rest] = pts
  return `M ${p0.x} ${p0.y}` + rest.map((p) => ` L ${p.x} ${p.y}`).join('') + ' Z'
}

export function NotesSceneLayer({
  scene,
  setScene,
  effectiveLod,
  activeTool,
  selectedIds,
  selectOnly,
  toggleSelect,
  clearSelection,
  world,
  tagFilter,
  filterOrMode,
  linkFromId,
  setLinkFromId,
  onLinkNodes,
  clientToWorld,
  onLassoComplete,
}: Props) {
  const zoomRef = useRef(world.zoom)
  useEffect(() => {
    zoomRef.current = world.zoom
  }, [world.zoom])

  const [lassoDraft, setLassoDraft] = useState<{ x: number; y: number }[] | null>(null)
  const lassoAccRef = useRef<{ x: number; y: number }[]>([])

  useEffect(() => {
    if (activeTool !== 'lasso') {
      setLassoDraft(null)
      lassoAccRef.current = []
    }
  }, [activeTool])

  const moveNode = useCallback(
    (id: string, patch: Partial<SceneNode>) => {
      setScene((s) => {
        const node = s.nodes.find((n) => n.id === id)
        if (!node) return s
        const nx = patch.x !== undefined ? patch.x : node.x
        const ny = patch.y !== undefined ? patch.y : node.y
        const dx = nx - node.x
        const dy = ny - node.y
        if (dx === 0 && dy === 0) return s

        if (node.kind === 'cluster') {
          return {
            ...s,
            nodes: s.nodes.map((n) => {
              if (n.id === id) return { ...n, ...patch }
              if (n.clusterId === id) return { ...n, x: n.x + dx, y: n.y + dy }
              return n
            }),
          }
        }
        return {
          ...s,
          nodes: s.nodes.map((n) => (n.id === id ? { ...n, ...patch } : n)),
        }
      })
    },
    [setScene],
  )

  const memberCount = useMemo(() => {
    const m = new Map<string, number>()
    for (const n of scene.nodes) {
      if (n.clusterId) m.set(n.clusterId, (m.get(n.clusterId) ?? 0) + 1)
    }
    return m
  }, [scene.nodes])

  const sortedNodes = useMemo(() => {
    const clusters = scene.nodes.filter((n) => n.kind === 'cluster')
    const rest = scene.nodes.filter((n) => n.kind !== 'cluster')
    return [...clusters, ...rest]
  }, [scene.nodes])

  const nodeMatchesFilter = useCallback(
    (n: SceneNode) => {
      if (tagFilter.size === 0) return true
      const names = new Set(n.tags.map((t) => t.name))
      if (filterOrMode) {
        for (const t of tagFilter) {
          if (names.has(t)) return true
        }
        return false
      }
      for (const t of tagFilter) {
        if (!names.has(t)) return false
      }
      return true
    },
    [tagFilter, filterOrMode],
  )

  const nodesBlockPointer = activeTool === 'hand' || activeTool === 'lasso'

  const onNodePointerDown = useCallback(
    (e: React.PointerEvent, node: SceneNode) => {
      if (e.button !== 0) return

      if (activeTool === 'link') {
        e.stopPropagation()
        if (!linkFromId) {
          setLinkFromId(node.id)
          selectOnly(node.id)
          return
        }
        if (linkFromId === node.id) {
          setLinkFromId(null)
          return
        }
        onLinkNodes(linkFromId, node.id)
        setLinkFromId(null)
        selectOnly(node.id)
        return
      }

      if (activeTool !== 'select') return
      e.stopPropagation()
      const additive = e.shiftKey
      if (additive) toggleSelect(node.id, true)
      else selectOnly(node.id)

      const pointerId = e.pointerId
      const startClientX = e.clientX
      const startClientY = e.clientY
      const startX = node.x
      const startY = node.y

      const onMove = (ev: PointerEvent) => {
        if (ev.pointerId !== pointerId) return
        const z = zoomRef.current
        const dx = (ev.clientX - startClientX) / z
        const dy = (ev.clientY - startClientY) / z
        moveNode(node.id, { x: startX + dx, y: startY + dy })
      }
      const onUp = (ev: PointerEvent) => {
        if (ev.pointerId !== pointerId) return
        window.removeEventListener('pointermove', onMove)
        window.removeEventListener('pointerup', onUp)
      }
      window.addEventListener('pointermove', onMove)
      window.addEventListener('pointerup', onUp)
    },
    [
      activeTool,
      linkFromId,
      setLinkFromId,
      onLinkNodes,
      selectOnly,
      toggleSelect,
      moveNode,
    ],
  )

  const finishLasso = useCallback(
    (points: { x: number; y: number }[]) => {
      if (points.length >= 3 && pathLength(points) > 20) {
        onLassoComplete(points)
      }
      lassoAccRef.current = []
      setLassoDraft(null)
    },
    [onLassoComplete],
  )

  const onCanvasBackgroundPointerDown = useCallback(
    (e: React.PointerEvent) => {
      if (e.target !== e.currentTarget) return
      if (activeTool === 'link') {
        setLinkFromId(null)
        return
      }
      if (activeTool === 'lasso' && e.button === 0) {
        e.preventDefault()
        const p0 = clientToWorld(e.clientX, e.clientY)
        lassoAccRef.current = [p0]
        setLassoDraft([p0])
        const pointerId = e.pointerId

        const onMove = (ev: PointerEvent) => {
          if (ev.pointerId !== pointerId) return
          const p = clientToWorld(ev.clientX, ev.clientY)
          const acc = lassoAccRef.current
          const last = acc[acc.length - 1]
          if (last && Math.hypot(p.x - last.x, p.y - last.y) < 2.5) return
          acc.push(p)
          setLassoDraft([...acc])
        }
        const onUp = (ev: PointerEvent) => {
          if (ev.pointerId !== pointerId) return
          window.removeEventListener('pointermove', onMove)
          window.removeEventListener('pointerup', onUp)
          const final = lassoAccRef.current
          if (final.length >= 3) finishLasso(final)
          else setLassoDraft(null)
        }
        window.addEventListener('pointermove', onMove)
        window.addEventListener('pointerup', onUp)
        return
      }
      if (activeTool === 'select' && e.button === 0) clearSelection()
    },
    [activeTool, clearSelection, setLinkFromId, clientToWorld, finishLasso],
  )

  return (
    <div
      data-canvas-root
      className="relative w-[8000px] h-[8000px]"
      onPointerDown={onCanvasBackgroundPointerDown}
    >
      <EdgeLayer scene={scene} linkHighlightFromId={linkFromId} />
      {sortedNodes.map((node) => (
        <SceneNodeView
          key={node.id}
          node={node}
          lod={effectiveLod}
          viewZoom={world.zoom}
          selected={selectedIds.has(node.id)}
          filteredOut={!nodeMatchesFilter(node)}
          clusterMemberCount={node.kind === 'cluster' ? (memberCount.get(node.id) ?? 0) : undefined}
          interactionDisabled={nodesBlockPointer}
          onNodePointerDown={onNodePointerDown}
        />
      ))}
      {lassoDraft && lassoDraft.length > 0 ? (
        <svg
          className="absolute left-0 top-0 w-full h-full pointer-events-none z-[30]"
          aria-hidden
        >
          <path
            d={lassoPathD(lassoDraft)}
            fill="rgba(99, 102, 241, 0.14)"
            stroke="rgb(99, 102, 241)"
            strokeWidth={2}
            vectorEffect="non-scaling-stroke"
            strokeLinejoin="round"
          />
        </svg>
      ) : null}
      {scene.nodes.length === 0 ? (
        <div className="fixed left-8 top-28 z-50 w-80 max-w-[calc(100vw-4rem)] rounded-lg border border-dashed bg-card/95 p-5 text-sm text-muted-foreground shadow-md pointer-events-none backdrop-blur-[2px]">
          <p className="font-medium text-foreground mb-1">Empty canvas</p>
          <p>
            Add a <strong>note</strong> or <strong>conversation</strong>. Use the <strong>pencil</strong> to draw a loop around
            cards and create a cluster. <strong>Full demo</strong> loads a sample layout.
          </p>
        </div>
      ) : null}
    </div>
  )
}
