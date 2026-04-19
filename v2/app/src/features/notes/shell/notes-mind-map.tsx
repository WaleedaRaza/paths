import { useCallback, useEffect, useLayoutEffect, useMemo, useRef, useState } from 'react'
import { Hand, Keyboard, Link2, MousePointer2, Pencil, Plus, Trash2 } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { CanvasViewport } from '@/features/notes/canvas/canvas-viewport'
import { bboxOfNodes } from '@/features/notes/canvas/fit-scene'
import { getLod, type LodMode } from '@/features/notes/canvas/get-lod'
import { NotesSceneLayer, type CanvasTool } from '@/features/notes/canvas/notes-scene-layer'
import { useWorldTransform } from '@/features/notes/canvas/use-world-transform'
import { mockVendorLabel } from '@/features/notes/mock/mock-llm'
import { personaById } from '@/features/notes/data/personas'
import { CreateItemBar } from '@/features/notes/shell/create-item-bar'
import { NotesUiProvider } from '@/features/notes/notes-ui-context'
import { InspectorPanel } from '@/features/notes/inspector/inspector-panel'
import { CommandPalette } from '@/features/notes/shell/command-palette'
import { ImportModal } from '@/features/notes/shell/import-modal'
import { buildDemoScene } from '@/features/notes/scene/demo-scene'
import { useCanvasScene } from '@/features/notes/scene/use-canvas-scene'
import { useSelection } from '@/features/notes/scene/use-selection'
import {
  createClusterFromLassoPolygon,
  dissolveCluster as dissolveClusterScene,
} from '@/features/notes/scene/cluster-lasso'
import { linkConnectsPair, normalizeLinkEndpoints } from '@/features/notes/scene/link-utils'
import {
  createLinkId,
  createNodeId,
  createTurnId,
  emptyScene,
  type EdgeKind,
  type SceneNode,
  type Tag,
} from '@/features/notes/scene/scene-schema'

const LOD_OPTIONS: { value: LodMode; label: string }[] = [
  { value: 'auto', label: 'Auto' },
  { value: 'galaxy', label: 'Galaxy' },
  { value: 'neighborhood', label: 'Neighborhood' },
  { value: 'reading', label: 'Reading' },
]

interface MindMapProps {
  /** When set (e.g. from `paths:activate-notes`), select this node and frame it in the viewport. */
  focusRequestId?: string | null
  onFocusRequestHandled?: () => void
}

export function NotesMindMap({ focusRequestId = null, onFocusRequestHandled }: MindMapProps) {
  const viewportRef = useRef<HTMLDivElement>(null)
  const { scene, setScene } = useCanvasScene()
  const sceneRef = useRef(scene)
  sceneRef.current = scene
  const world = useWorldTransform()
  const [lodMode, setLodMode] = useState<LodMode>('auto')
  const [paletteOpen, setPaletteOpen] = useState(false)
  const [importOpen, setImportOpen] = useState(false)
  const [activeTool, setActiveTool] = useState<CanvasTool>('select')
  const [linkFromId, setLinkFromId] = useState<string | null>(null)
  const [tagFilter, setTagFilter] = useState<Set<string>>(() => new Set())
  const [filterOrMode, setFilterOrMode] = useState(true)
  const [createOpen, setCreateOpen] = useState(false)

  const selection = useSelection()
  const { selectOnly } = selection
  const { focusWorldRect } = world
  const effectiveLod = useMemo(() => getLod(world.zoom, lodMode), [world.zoom, lodMode])

  useEffect(() => {
    if (!focusRequestId) return
    const node = scene.nodes.find((n) => n.id === focusRequestId)
    if (!node) {
      onFocusRequestHandled?.()
      return
    }
    selectOnly(focusRequestId)
    setActiveTool('select')
    setLinkFromId(null)
    const id = requestAnimationFrame(() => {
      const el = viewportRef.current
      if (el) {
        focusWorldRect(el.getBoundingClientRect(), node.x, node.y, node.width, node.height)
      }
      onFocusRequestHandled?.()
    })
    return () => cancelAnimationFrame(id)
  }, [focusRequestId, scene.nodes, selectOnly, focusWorldRect, onFocusRequestHandled])

  const fitEntireScene = useCallback(
    (nodes?: SceneNode[]) => {
      const list = nodes ?? sceneRef.current.nodes
      const el = viewportRef.current
      if (!el || list.length === 0) return
      const box = bboxOfNodes(list)
      if (!box) return
      const r = el.getBoundingClientRect()
      if (r.width < 16 || r.height < 16) return
      focusWorldRect(r, box.x, box.y, box.w, box.h)
    },
    [focusWorldRect],
  )

  /** First paint with a persisted scene: camera was stuck at origin while nodes sat at ~2k px — frame everything once. */
  useLayoutEffect(() => {
    if (scene.nodes.length === 0) return
    let inner = 0
    const outer = requestAnimationFrame(() => {
      inner = requestAnimationFrame(() => fitEntireScene(scene.nodes))
    })
    return () => {
      cancelAnimationFrame(outer)
      cancelAnimationFrame(inner)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- mount / first-load only (uses `scene` from first commit)
  }, [])

  const selectedNodes = useMemo(() => {
    return scene.nodes.filter((n) => selection.selectedIds.has(n.id))
  }, [scene.nodes, selection.selectedIds])

  const allTags = useMemo(() => {
    const m = new Map<string, string>()
    for (const n of scene.nodes) {
      for (const t of n.tags) m.set(t.name, t.color)
    }
    return [...m.entries()].sort(([a], [b]) => a.localeCompare(b))
  }, [scene.nodes])

  const toggleTagFilter = useCallback((name: string) => {
    setTagFilter((prev) => {
      const next = new Set(prev)
      if (next.has(name)) next.delete(name)
      else next.add(name)
      return next
    })
  }, [])

  const patchNode = useCallback(
    (id: string, patch: Partial<SceneNode>) => {
      setScene((s) => ({
        ...s,
        nodes: s.nodes.map((n) => (n.id === id ? { ...n, ...patch } : n)),
      }))
    },
    [setScene],
  )

  const onRemoveLink = useCallback((linkId: string) => {
    setScene((s) => ({ ...s, links: s.links.filter((l) => l.id !== linkId) }))
  }, [setScene])

  const onLinkNodes = useCallback((fromId: string, toId: string, kind?: EdgeKind) => {
    if (fromId === toId) return
    const [a, b] = normalizeLinkEndpoints(fromId, toId)
    setScene((s) => {
      if (s.links.some((l) => linkConnectsPair(l, a, b))) return s
      return {
        ...s,
        links: [...s.links, { id: createLinkId(), fromId: a, toId: b, kind: kind ?? 'ref' }],
      }
    })
  }, [setScene])

  const onAutofitCluster = useCallback((clusterId: string) => {
    setScene((s) => {
      const members = s.nodes.filter((n) => n.clusterId === clusterId)
      if (members.length === 0) return s
      let minX = Infinity
      let minY = Infinity
      let maxX = -Infinity
      let maxY = -Infinity
      for (const m of members) {
        minX = Math.min(minX, m.x)
        minY = Math.min(minY, m.y)
        maxX = Math.max(maxX, m.x + m.width)
        maxY = Math.max(maxY, m.y + m.height)
      }
      const pad = 36
      return {
        ...s,
        nodes: s.nodes.map((n) =>
          n.id === clusterId
            ? {
                ...n,
                x: minX - pad,
                y: minY - pad,
                width: Math.max(240, maxX - minX + pad * 2),
                height: Math.max(160, maxY - minY + pad * 2),
              }
            : n,
        ),
      }
    })
  }, [setScene])

  const deleteNode = useCallback(
    (id: string) => {
      setScene((s) => ({
        ...s,
        nodes: s.nodes
          .filter((n) => n.id !== id)
          .map((n) => (n.clusterId === id ? { ...n, clusterId: undefined } : n)),
        links: s.links.filter((l) => l.fromId !== id && l.toId !== id),
      }))
      selection.clear()
    },
    [setScene, selection],
  )

  const onCommitNote = useCallback(
    (payload: { title: string; tags: Tag[] }) => {
      const i = scene.nodes.length
      const node: SceneNode = {
        id: createNodeId(),
        kind: 'note',
        title: payload.title,
        x: 96 + (i % 6) * 44,
        y: 96 + Math.floor(i / 6) * 40,
        width: 340,
        height: 240,
        tags: payload.tags,
        previewMarkdown: '',
      }
      setScene((s) => ({ ...s, nodes: [...s.nodes, node] }))
      selection.selectOnly(node.id)
      requestAnimationFrame(() => requestAnimationFrame(() => fitEntireScene()))
    },
    [scene.nodes.length, setScene, selection, fitEntireScene],
  )

  const onCommitChat = useCallback(
    (payload: { title: string; tags: Tag[]; personaIds: string[]; mockModelId: string }) => {
      const i = scene.nodes.length
      const persona = payload.personaIds[0] ? personaById(payload.personaIds[0]) : undefined
      const seedTurn = {
        id: createTurnId(),
        role: 'assistant' as const,
        vendorLabel: persona
          ? `${persona.name} · ${mockVendorLabel(payload.mockModelId)}`
          : mockVendorLabel(payload.mockModelId),
        text: persona
          ? `[${persona.name}] Session ready (mock). Add more personas in the inspector, then send a message.`
          : 'Session ready (mock). Choose personas in the inspector.',
      }
      const node: SceneNode = {
        id: createNodeId(),
        kind: 'chat',
        title: payload.title,
        x: 112 + (i % 5) * 52,
        y: 112 + Math.floor(i / 5) * 48,
        width: 380,
        height: 320,
        tags: payload.tags,
        previewMarkdown: '',
        mockModelId: payload.mockModelId,
        personaIds: payload.personaIds,
        chatTurns: [seedTurn],
      }
      setScene((s) => ({ ...s, nodes: [...s.nodes, node] }))
      selection.selectOnly(node.id)
      requestAnimationFrame(() => requestAnimationFrame(() => fitEntireScene()))
    },
    [scene.nodes.length, setScene, selection, fitEntireScene],
  )

  const onImportNode = useCallback(
    (node: SceneNode) => {
      const wasEmpty = sceneRef.current.nodes.length === 0
      setScene((s) => ({ ...s, nodes: [...s.nodes, node] }))
      selection.selectOnly(node.id)
      if (wasEmpty) {
        requestAnimationFrame(() => requestAnimationFrame(() => fitEntireScene()))
      }
    },
    [setScene, selection, fitEntireScene],
  )

  const loadDemo = useCallback(() => {
    const demo = buildDemoScene()
    setScene(demo)
    selection.clear()
    setLinkFromId(null)
    setActiveTool('select')
    setCreateOpen(false)
    requestAnimationFrame(() => {
      requestAnimationFrame(() => fitEntireScene(demo.nodes))
    })
  }, [setScene, selection, fitEntireScene])

  const clearCanvas = useCallback(() => {
    if (!window.confirm('Clear all nodes and links from this canvas?')) return
    setScene(emptyScene())
    selection.clear()
    setLinkFromId(null)
    setCreateOpen(false)
  }, [setScene, selection])

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      const mod = e.metaKey || e.ctrlKey
      if (mod && e.key.toLowerCase() === 'k') {
        e.preventDefault()
        setPaletteOpen((v) => !v)
      }
      if (e.key === 'Escape') {
        if (createOpen) {
          setCreateOpen(false)
          return
        }
        selection.clear()
        setLinkFromId(null)
        setActiveTool('select')
      }
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [selection, createOpen])

  const visibleCount = useMemo(() => {
    if (tagFilter.size === 0) return scene.nodes.length
    return scene.nodes.filter((n) => {
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
    }).length
  }, [scene.nodes, tagFilter, filterOrMode])

  const ctx = useMemo(
    () => ({
      lodMode,
      setLodMode,
      effectiveLod,
      commandPaletteOpen: paletteOpen,
      setCommandPaletteOpen: setPaletteOpen,
    }),
    [lodMode, effectiveLod, paletteOpen],
  )

  const clientToWorld = useCallback(
    (clientX: number, clientY: number) => {
      const el = viewportRef.current
      if (!el) return { x: 0, y: 0 }
      return world.screenToWorld(clientX, clientY, el.getBoundingClientRect())
    },
    [world],
  )

  const onLassoComplete = useCallback(
    (polygon: { x: number; y: number }[]) => {
      setScene((s) => createClusterFromLassoPolygon(s, polygon))
    },
    [setScene],
  )

  const onDissolveCluster = useCallback(
    (clusterId: string) => {
      setScene((s) => dissolveClusterScene(s, clusterId))
      selection.clear()
    },
    [setScene, selection],
  )

  return (
    <NotesUiProvider value={ctx}>
      <CommandPalette open={paletteOpen} onOpenChange={setPaletteOpen} />
      <ImportModal
        open={importOpen}
        onOpenChange={setImportOpen}
        onImport={onImportNode}
        spawnIndex={scene.nodes.length}
      />
      <div className="flex h-full min-h-[calc(100vh-0px)] flex-col">
        <header className="shrink-0 border-b px-3 py-2 flex flex-wrap items-center gap-2 gap-y-1">
          <span className="text-sm font-medium">Notes · mind map</span>
          <span className="text-xs text-muted-foreground hidden sm:inline">
            Pencil → draw a cluster · link tool for mutual links · inspector for tags
          </span>
          <div className="flex-1 min-w-[8rem]" />
          {activeTool === 'link' ? (
            <span className="text-[11px] text-primary font-medium">
              {linkFromId ? 'Link: pick 2nd node (one mutual link per pair)' : 'Link: pick first node'}
            </span>
          ) : null}
          {activeTool === 'lasso' ? (
            <span className="text-[11px] text-primary font-medium">
              Draw a loop around 2+ cards on the canvas, release to create a cluster
            </span>
          ) : null}
          <Button
            type="button"
            variant={createOpen ? 'secondary' : 'default'}
            size="sm"
            className="h-7 text-xs gap-1"
            onClick={() => setCreateOpen((v) => !v)}
          >
            <Plus className="size-3.5" strokeWidth={1.75} />
            {createOpen ? 'Close add' : 'Add…'}
          </Button>
          <Button type="button" variant="outline" size="sm" className="h-7 text-xs" onClick={loadDemo}>
            Full demo
          </Button>
          <Button
            type="button"
            variant="outline"
            size="sm"
            className="h-7 text-xs"
            title="Frame all nodes in the viewport"
            onClick={() => fitEntireScene()}
            disabled={scene.nodes.length === 0}
          >
            Fit view
          </Button>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            className="h-7 text-xs text-muted-foreground"
            onClick={clearCanvas}
          >
            <Trash2 className="size-3.5 mr-1" strokeWidth={1.75} />
            Clear
          </Button>
          <label className="flex items-center gap-1.5 text-xs text-muted-foreground">
            <span>LOD</span>
            <select
              value={lodMode}
              onChange={(e) => setLodMode(e.target.value as LodMode)}
              className="rounded-md border border-input bg-background px-2 py-1 text-foreground text-xs"
            >
              {LOD_OPTIONS.map((o) => (
                <option key={o.value} value={o.value}>
                  {o.label}
                </option>
              ))}
            </select>
          </label>
          <span className="text-[11px] text-muted-foreground tabular-nums">
            {effectiveLod} · {(world.zoom * 100).toFixed(0)}%
          </span>
        </header>

        <CreateItemBar
          open={createOpen}
          onClose={() => setCreateOpen(false)}
          onImportClick={() => setImportOpen(true)}
          onCommitNote={onCommitNote}
          onCommitChat={onCommitChat}
        />

        <div className="flex flex-1 min-h-0">
          <aside className="w-11 shrink-0 border-r flex flex-col items-center py-2 gap-1 bg-muted/20">
            <Button
              type="button"
              size="icon"
              variant={activeTool === 'select' ? 'secondary' : 'ghost'}
              className="size-9"
              title="Select"
              onClick={() => {
                setActiveTool('select')
                setLinkFromId(null)
              }}
            >
              <MousePointer2 className="size-4" strokeWidth={1.75} />
            </Button>
            <Button
              type="button"
              size="icon"
              variant={activeTool === 'hand' ? 'secondary' : 'ghost'}
              className="size-9"
              title="Hand (drag canvas)"
              onClick={() => {
                setActiveTool('hand')
                setLinkFromId(null)
              }}
            >
              <Hand className="size-4" strokeWidth={1.75} />
            </Button>
            <Button
              type="button"
              size="icon"
              variant={activeTool === 'link' ? 'secondary' : 'ghost'}
              className="size-9"
              title="Link two nodes"
              onClick={() => {
                setActiveTool((t) => (t === 'link' ? 'select' : 'link'))
                setLinkFromId(null)
              }}
            >
              <Link2 className="size-4" strokeWidth={1.75} />
            </Button>
            <Button
              type="button"
              size="icon"
              variant={activeTool === 'lasso' ? 'secondary' : 'ghost'}
              className="size-9"
              title="Cluster: draw a loop around cards"
              onClick={() => {
                setActiveTool((t) => (t === 'lasso' ? 'select' : 'lasso'))
                setLinkFromId(null)
              }}
            >
              <Pencil className="size-4" strokeWidth={1.75} />
            </Button>
            <div className="flex-1" />
            <Button
              type="button"
              size="icon"
              variant={createOpen ? 'secondary' : 'ghost'}
              className="size-9"
              title="Add note or conversation"
              onClick={() => setCreateOpen(true)}
            >
              <Plus className="size-4" strokeWidth={1.75} />
            </Button>
            <Button
              type="button"
              size="icon"
              variant="ghost"
              className="size-9"
              title="Command palette (⌘K)"
              onClick={() => setPaletteOpen(true)}
            >
              <Keyboard className="size-4" strokeWidth={1.75} />
            </Button>
          </aside>

          <div className="flex flex-1 min-w-0 flex-col min-h-0">
            <div className="shrink-0 border-b px-3 py-2 min-h-10 flex flex-wrap items-center gap-2 text-xs text-muted-foreground">
              <span className="text-foreground/80">Tags</span>
              {allTags.length === 0 ? (
                <span className="opacity-60">—</span>
              ) : (
                allTags.map(([name, color]) => {
                  const on = tagFilter.has(name)
                  return (
                    <button
                      key={name}
                      type="button"
                      className={
                        'rounded-full px-2 py-0.5 text-[11px] font-medium transition-opacity border ' +
                        (on ? 'opacity-100 ring-2 ring-ring' : 'opacity-70 hover:opacity-100')
                      }
                      style={{
                        backgroundColor: /^#[0-9a-fA-F]{6}$/.test(color) ? color : undefined,
                        color: /^#[0-9a-fA-F]{6}$/.test(color) ? '#fff' : undefined,
                      }}
                      onClick={() => toggleTagFilter(name)}
                    >
                      {name}
                    </button>
                  )
                })
              )}
              <label className="ml-auto flex items-center gap-1 cursor-pointer select-none">
                <input
                  type="checkbox"
                  checked={filterOrMode}
                  onChange={(e) => setFilterOrMode(e.target.checked)}
                />
                <span>Any tag</span>
              </label>
              <span className="tabular-nums">
                {visibleCount}/{scene.nodes.length} visible
              </span>
            </div>
            <CanvasViewport ref={viewportRef} world={world} panPrimaryButton={activeTool === 'hand'}>
              <NotesSceneLayer
                scene={scene}
                setScene={setScene}
                effectiveLod={effectiveLod}
                activeTool={activeTool}
                selectedIds={selection.selectedIds}
                selectOnly={selection.selectOnly}
                toggleSelect={selection.toggle}
                clearSelection={selection.clear}
                world={world}
                tagFilter={tagFilter}
                filterOrMode={filterOrMode}
                linkFromId={linkFromId}
                setLinkFromId={setLinkFromId}
                onLinkNodes={onLinkNodes}
                clientToWorld={clientToWorld}
                onLassoComplete={onLassoComplete}
              />
            </CanvasViewport>
          </div>

          <aside className="w-[min(100%,400px)] shrink-0 border-l flex flex-col bg-card/50 min-h-0">
            <div className="px-3 py-2 border-b text-sm font-medium shrink-0">Inspector</div>
            <InspectorPanel
              scene={scene}
              selected={selectedNodes}
              onPatch={patchNode}
              onDelete={deleteNode}
              onRemoveLink={onRemoveLink}
              onAddLink={onLinkNodes}
              onAutofitCluster={onAutofitCluster}
              onDissolveCluster={onDissolveCluster}
            />
          </aside>
        </div>
      </div>
    </NotesUiProvider>
  )
}
