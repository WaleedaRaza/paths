import { useEffect, useMemo, useState } from 'react'
import { Button } from '@/components/ui/button'
import {
  defaultMockModelId,
  MOCK_MODELS,
  mockAssistantReply,
  mockVendorLabel,
} from '@/features/notes/mock/mock-llm'
import { PERSONAS, personaById } from '@/features/notes/data/personas'
import { TAG_PRESETS } from '@/lib/tag-presets'
import {
  createTurnId,
  type CanvasScene,
  type EdgeKind,
  type SceneLink,
  type SceneNode,
  type Tag,
} from '@/features/notes/scene/scene-schema'

type Tab = 'main' | 'edit' | 'personas' | 'model' | 'links'

const EDGE_KINDS: { id: EdgeKind; label: string }[] = [
  { id: 'ref', label: 'Reference' },
  { id: 'continues', label: 'Continues' },
  { id: 'cross_talk', label: 'Cross-talk' },
  { id: 'cluster_member', label: 'Cluster' },
]

interface Props {
  scene: CanvasScene
  selected: SceneNode[]
  onPatch: (id: string, patch: Partial<SceneNode>) => void
  onDelete: (id: string) => void
  onRemoveLink: (linkId: string) => void
  onAddLink: (fromId: string, toId: string, kind?: EdgeKind) => void
  onAutofitCluster: (clusterId: string) => void
  onDissolveCluster: (clusterId: string) => void
}

export function InspectorPanel({
  scene,
  selected,
  onPatch,
  onDelete,
  onRemoveLink,
  onAddLink,
  onAutofitCluster,
  onDissolveCluster,
}: Props) {
  const [tab, setTab] = useState<Tab>('main')
  const [chatDraft, setChatDraft] = useState('')
  const [newTagName, setNewTagName] = useState('')
  const [newTagColor, setNewTagColor] = useState(TAG_PRESETS[0]?.color ?? '#64748b')
  const [linkTargetId, setLinkTargetId] = useState('')
  const [linkKind, setLinkKind] = useState<EdgeKind>('ref')

  const primary = selected.length === 1 ? selected[0] : null

  const nodeById = useMemo(() => new Map(scene.nodes.map((n) => [n.id, n])), [scene.nodes])

  const linkTargets = useMemo(() => {
    if (!primary) return []
    return scene.nodes.filter((n) => n.id !== primary.id)
  }, [primary, scene.nodes])

  const linksForNode = useMemo(() => {
    if (!primary) return []
    const out: { link: SceneLink; other: SceneNode }[] = []
    for (const link of scene.links) {
      if (link.fromId === primary.id) {
        const o = nodeById.get(link.toId)
        if (o) out.push({ link, other: o })
      } else if (link.toId === primary.id) {
        const o = nodeById.get(link.fromId)
        if (o) out.push({ link, other: o })
      }
    }
    return out
  }, [primary, scene.links, nodeById])

  const clusterMembers = useMemo(() => {
    if (!primary || primary.kind !== 'cluster') return []
    return scene.nodes.filter((n) => n.clusterId === primary.id)
  }, [primary, scene.nodes])

  useEffect(() => {
    if (primary?.kind !== 'note' && tab === 'edit') setTab('main')
    if (primary?.kind !== 'chat' && (tab === 'model' || tab === 'personas')) setTab('main')
  }, [primary, tab])

  const addTag = (name: string, color: string) => {
    if (!primary) return
    const n = name.trim()
    if (!n) return
    if (primary.tags.some((t) => t.name.toLowerCase() === n.toLowerCase())) return
    const next: Tag[] = [...primary.tags, { name: n, color }]
    onPatch(primary.id, { tags: next })
    setNewTagName('')
  }

  const removeTag = (name: string) => {
    if (!primary) return
    onPatch(primary.id, { tags: primary.tags.filter((t) => t.name !== name) })
  }

  const togglePersona = (id: string) => {
    if (!primary || primary.kind !== 'chat') return
    const cur = new Set(primary.personaIds ?? [])
    if (cur.has(id)) cur.delete(id)
    else cur.add(id)
    onPatch(primary.id, { personaIds: [...cur] })
  }

  if (selected.length === 0) {
    return (
      <div className="p-3 text-xs text-muted-foreground flex-1 overflow-auto">
        <p className="text-foreground font-medium mb-1">Nothing selected</p>
        <p>
          <strong>Add…</strong> creates a note or conversation. Use the <strong>pencil</strong> tool to draw a loop
          around cards and create a cluster. Use the <strong>Links</strong> tab or the link tool.
        </p>
      </div>
    )
  }

  if (selected.length > 1) {
    return (
      <div className="p-3 text-xs text-muted-foreground flex-1 overflow-auto space-y-2">
        <p className="text-foreground font-medium">{selected.length} items selected</p>
        <p>Open the inspector for one card to edit tags and links.</p>
        <ul className="list-disc pl-4 space-y-0.5">
          {selected.map((n) => (
            <li key={n.id} className="truncate">
              {n.title}
            </li>
          ))}
        </ul>
      </div>
    )
  }

  if (!primary) return null

  const tabsForKind = (): { id: Tab; label: string }[] => {
    switch (primary.kind) {
      case 'note':
        return [
          { id: 'main', label: 'Preview' },
          { id: 'edit', label: 'Edit' },
          { id: 'links', label: 'Links' },
        ]
      case 'chat':
        return [
          { id: 'main', label: 'Chat' },
          { id: 'personas', label: 'Personas' },
          { id: 'model', label: 'Model' },
          { id: 'links', label: 'Links' },
        ]
      case 'import':
        return [
          { id: 'main', label: 'Raw' },
          { id: 'links', label: 'Links' },
        ]
      case 'cluster':
        return [
          { id: 'main', label: 'Cluster' },
          { id: 'links', label: 'Links' },
        ]
      default:
        return [
          { id: 'main', label: 'Preview' },
          { id: 'links', label: 'Links' },
        ]
    }
  }

  const tabs = tabsForKind()

  const sendMockChat = () => {
    const text = chatDraft.trim()
    if (!text || primary.kind !== 'chat') return
    const modelId = primary.mockModelId ?? defaultMockModelId()
    const turns = primary.chatTurns ?? []
    const userTurn = { id: createTurnId(), role: 'user' as const, vendorLabel: 'You', text }
    const assistantText = mockAssistantReply(modelId, text)
    const persona = primary.personaIds?.[0] ? personaById(primary.personaIds[0]) : undefined
    const vendorLabel = persona
      ? `${persona.name} · ${mockVendorLabel(modelId)}`
      : mockVendorLabel(modelId)
    const aTurn = {
      id: createTurnId(),
      role: 'assistant' as const,
      vendorLabel,
      text: assistantText,
    }
    onPatch(primary.id, { chatTurns: [...turns, userTurn, aTurn], mockModelId: modelId })
    setChatDraft('')
  }

  return (
    <div className="flex flex-col flex-1 min-h-0 text-xs">
      <div className="p-3 border-b space-y-2 shrink-0 bg-muted/10">
        <div>
          <label className="text-muted-foreground block mb-1">Title</label>
          <input
            className="w-full rounded-md border border-input bg-background px-2 py-1.5 text-sm text-foreground"
            value={primary.title}
            onChange={(e) => onPatch(primary.id, { title: e.target.value })}
          />
        </div>
        <div>
          <label className="text-muted-foreground block mb-1">Tags</label>
          <div className="flex flex-wrap gap-1 items-center">
            {primary.tags.map((t) => (
              <button
                key={t.name}
                type="button"
                className="rounded-full px-2 py-0.5 text-[10px] text-white max-w-[130px] truncate"
                style={{ backgroundColor: /^#[0-9a-fA-F]{6}$/.test(t.color) ? t.color : '#64748b' }}
                onClick={() => removeTag(t.name)}
                title="Remove tag"
              >
                {t.name} ×
              </button>
            ))}
            <input
              className="w-24 rounded-md border border-input bg-background px-1.5 py-1 text-[11px]"
              placeholder="new tag"
              value={newTagName}
              onChange={(e) => setNewTagName(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter') {
                  e.preventDefault()
                  addTag(newTagName, newTagColor)
                }
              }}
            />
            <div className="flex gap-0.5">
              {TAG_PRESETS.map((p) => (
                <button
                  key={p.color}
                  type="button"
                  className={
                    'size-4 rounded border ' + (newTagColor === p.color ? 'ring-2 ring-ring' : 'border-transparent')
                  }
                  style={{ backgroundColor: p.color }}
                  title={p.label}
                  onClick={() => setNewTagColor(p.color)}
                />
              ))}
            </div>
            <Button
              type="button"
              variant="secondary"
              size="sm"
              className="h-6 text-[10px] px-2"
              onClick={() => addTag(newTagName, newTagColor)}
            >
              Add
            </Button>
          </div>
        </div>
      </div>

      <div className="flex border-b shrink-0 overflow-x-auto">
        {tabs.map((t) => (
          <button
            key={t.id}
            type="button"
            className={
              'flex-1 px-2 py-2 text-[11px] font-medium transition-colors whitespace-nowrap ' +
              (tab === t.id
                ? 'text-foreground border-b-2 border-primary bg-muted/30'
                : 'text-muted-foreground hover:text-foreground')
            }
            onClick={() => setTab(t.id)}
          >
            {t.label}
          </button>
        ))}
      </div>

      <div className="p-3 flex-1 min-h-0 overflow-auto space-y-3">
        {primary.kind === 'cluster' && tab === 'main' ? (
          <div className="space-y-2">
            <p className="text-muted-foreground">
              Created with the <strong>pencil</strong> tool (lasso). The frame moves with{' '}
              <strong>{clusterMembers.length}</strong> member cards.
            </p>
            <Button
              type="button"
              variant="outline"
              size="sm"
              className="w-full text-xs"
              onClick={() => onAutofitCluster(primary.id)}
            >
              Autofit frame to members
            </Button>
            <Button
              type="button"
              variant="destructive"
              size="sm"
              className="w-full text-xs"
              onClick={() => onDissolveCluster(primary.id)}
            >
              Dissolve cluster
            </Button>
            <p className="text-[10px] text-muted-foreground">
              Dissolve removes the frame only; cards stay on the canvas.
            </p>
            <div className="rounded-md border bg-muted/20 p-2 max-h-40 overflow-auto">
              <div className="text-[10px] text-muted-foreground mb-1">Members</div>
              <ul className="space-y-1">
                {clusterMembers.map((m) => (
                  <li key={m.id} className="truncate text-foreground">
                    · {m.title}{' '}
                    <span className="text-muted-foreground">({m.kind})</span>
                  </li>
                ))}
              </ul>
            </div>
          </div>
        ) : null}

        {primary.kind === 'import' && tab === 'main' ? (
          <div className="space-y-2">
            {primary.sourceFileName ? (
              <p className="text-muted-foreground">
                Source file: <span className="text-foreground font-mono">{primary.sourceFileName}</span>
              </p>
            ) : null}
            <div className="rounded-md border bg-muted/20 p-2 min-h-[160px] text-sm whitespace-pre-wrap font-mono">
              {primary.previewMarkdown?.trim() ? primary.previewMarkdown : '—'}
            </div>
          </div>
        ) : null}

        {primary.kind === 'note' && tab === 'main' ? (
          <div className="rounded-md border bg-muted/20 p-2 min-h-[120px] text-sm text-foreground whitespace-pre-wrap">
            {primary.previewMarkdown?.trim() ? primary.previewMarkdown : '—'}
          </div>
        ) : null}

        {primary.kind === 'note' && tab === 'edit' ? (
          <div>
            <label className="text-muted-foreground block mb-1">Markdown</label>
            <textarea
              className="w-full min-h-[200px] rounded-md border border-input bg-background px-2 py-1.5 text-sm font-mono text-foreground"
              value={primary.previewMarkdown ?? ''}
              onChange={(e) => onPatch(primary.id, { previewMarkdown: e.target.value })}
            />
          </div>
        ) : null}

        {primary.kind === 'chat' && tab === 'personas' ? (
          <div className="space-y-2">
            <p className="text-muted-foreground leading-snug">
              Toggle who participates in this conversation (mock UI). First persona also prefixes assistant labels.
            </p>
            <ul className="space-y-1.5 max-h-64 overflow-auto">
              {PERSONAS.map((p) => {
                const on = (primary.personaIds ?? []).includes(p.id)
                return (
                  <li key={p.id}>
                    <label className="flex items-start gap-2 cursor-pointer rounded-md border bg-background/50 px-2 py-1.5 hover:bg-muted/40">
                      <input
                        type="checkbox"
                        checked={on}
                        onChange={() => togglePersona(p.id)}
                        className="mt-0.5"
                      />
                      <span className="min-w-0">
                        <span className="text-foreground font-medium">
                          {p.icon} {p.name}
                        </span>
                        <span className="block text-[10px] text-muted-foreground">{p.shortDescription}</span>
                      </span>
                    </label>
                  </li>
                )
              })}
            </ul>
          </div>
        ) : null}

        {primary.kind === 'chat' && tab === 'model' ? (
          <div>
            <label className="text-muted-foreground block mb-1">Mock provider</label>
            <select
              className="w-full rounded-md border border-input bg-background px-2 py-1.5 text-sm"
              value={primary.mockModelId ?? defaultMockModelId()}
              onChange={(e) => onPatch(primary.id, { mockModelId: e.target.value })}
            >
              {MOCK_MODELS.map((m) => (
                <option key={m.id} value={m.id}>
                  {m.vendor} · {m.model} ({m.hint})
                </option>
              ))}
            </select>
            <p className="mt-2 text-muted-foreground leading-snug">
              Mock replies only — wire real providers in Slice 1+.
            </p>
          </div>
        ) : null}

        {primary.kind === 'chat' && tab === 'main' ? (
          <div className="space-y-2 flex flex-col min-h-[200px]">
            {(primary.personaIds?.length ?? 0) > 0 ? (
              <div className="text-[10px] text-muted-foreground">
                Active:{' '}
                {(primary.personaIds ?? [])
                  .map((id) => personaById(id)?.name ?? id)
                  .join(', ')}
              </div>
            ) : null}
            <div className="flex-1 min-h-[120px] max-h-52 overflow-auto space-y-2 rounded-md border bg-muted/15 p-2">
              {(primary.chatTurns?.length ? primary.chatTurns : []).map((t) => (
                <div
                  key={t.id}
                  className={
                    'rounded-md px-2 py-1.5 text-[11px] ' +
                    (t.role === 'user' ? 'bg-muted/50 ml-2' : 'bg-primary/10 mr-2')
                  }
                >
                  <div className="text-[9px] uppercase text-muted-foreground mb-0.5">{t.vendorLabel}</div>
                  <div className="whitespace-pre-wrap text-foreground">{t.text}</div>
                </div>
              ))}
            </div>
            <div className="flex gap-1">
              <textarea
                className="flex-1 min-h-[52px] rounded-md border border-input bg-background px-2 py-1 text-xs"
                placeholder="Message (mock)…"
                value={chatDraft}
                onChange={(e) => setChatDraft(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter' && (e.metaKey || e.ctrlKey)) {
                    e.preventDefault()
                    sendMockChat()
                  }
                }}
              />
              <Button type="button" size="sm" className="shrink-0 self-end text-xs" onClick={sendMockChat}>
                Send
              </Button>
            </div>
            <p className="text-[10px] text-muted-foreground">⌘Enter to send</p>
          </div>
        ) : null}

        {tab === 'links' ? (
          <div className="space-y-3">
            <div className="rounded-md border bg-muted/15 p-2 space-y-2">
              <div className="text-[11px] font-medium text-foreground">New link</div>
              <p className="text-[10px] text-muted-foreground leading-snug">
                One link per pair — connects both ways. If a link already exists, nothing is added again.
              </p>
              <select
                className="w-full rounded-md border border-input bg-background px-2 py-1.5 text-sm"
                value={linkTargetId}
                onChange={(e) => setLinkTargetId(e.target.value)}
              >
                <option value="">Select target…</option>
                {linkTargets.map((n) => (
                  <option key={n.id} value={n.id}>
                    {n.title} ({n.kind})
                  </option>
                ))}
              </select>
              <select
                className="w-full rounded-md border border-input bg-background px-2 py-1.5 text-sm"
                value={linkKind}
                onChange={(e) => setLinkKind(e.target.value as EdgeKind)}
              >
                {EDGE_KINDS.map((k) => (
                  <option key={k.id} value={k.id}>
                    {k.label}
                  </option>
                ))}
              </select>
              <Button
                type="button"
                size="sm"
                className="w-full text-xs"
                disabled={!linkTargetId}
                onClick={() => {
                  if (!linkTargetId) return
                  onAddLink(primary.id, linkTargetId, linkKind)
                  setLinkTargetId('')
                }}
              >
                Create link
              </Button>
            </div>
            {linksForNode.length === 0 ? (
              <p className="text-muted-foreground">No links yet.</p>
            ) : (
              <ul className="space-y-2">
                {linksForNode.map(({ link, other }) => {
                  const accent =
                    other.tags[0]?.color && /^#[0-9a-fA-F]{6}$/.test(other.tags[0].color)
                      ? other.tags[0].color
                      : undefined
                  return (
                  <li
                    key={link.id}
                    className="flex items-start justify-between gap-2 rounded-md border bg-muted/20 px-2 py-1.5"
                  >
                    <div className="min-w-0 flex gap-2">
                      <span
                        className="mt-1 size-2.5 shrink-0 rounded-full ring-1 ring-border"
                        style={{ backgroundColor: accent ?? 'hsl(var(--muted-foreground) / 0.35)' }}
                        title="Their tag color"
                      />
                      <div className="min-w-0">
                      <div className="truncate text-foreground">{other.title}</div>
                      <div className="text-[10px] text-muted-foreground">
                        {link.kind ?? 'ref'} · mutual · {other.kind}
                      </div>
                      </div>
                    </div>
                    <Button
                      type="button"
                      variant="ghost"
                      size="sm"
                      className="shrink-0 h-7 text-[10px] px-2"
                      onClick={() => onRemoveLink(link.id)}
                    >
                      Remove
                    </Button>
                  </li>
                  )
                })}
              </ul>
            )}
          </div>
        ) : null}

        <div className="pt-2 flex gap-2 border-t border-border/60">
          <Button type="button" variant="outline" size="sm" className="text-xs" onClick={() => onDelete(primary.id)}>
            Delete
          </Button>
        </div>
      </div>
    </div>
  )
}
