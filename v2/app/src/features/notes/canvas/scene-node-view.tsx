import type { CSSProperties } from 'react'
import { FileText, ImageIcon, Layers, MessageSquare, StickyNote } from 'lucide-react'
import type { LodBand } from '@/features/notes/canvas/get-lod'
import { personaById } from '@/features/notes/data/personas'
import type { SceneNode, Tag } from '@/features/notes/scene/scene-schema'

const L2_BUBBLE_PX = 118
const L2_CLUSTER_BUBBLE_PX = 122
const L2_COLUMN_W = 268

/**
 * Keep bubble + tile **screen size** in a comfortable band: readable when zoomed out, not huge when zoomed in.
 * Parent applies `scale(zoom)` to the world.
 */
function billboardScale(viewZoom: number): number {
  if (viewZoom < 0.08) return 24
  if (viewZoom < 1) return Math.min(1 / viewZoom, 24)
  if (viewZoom > 1) return Math.max(0.42, Math.min(1, 1 / viewZoom))
  return 1
}

function Billboard({
  viewZoom,
  cx,
  cy,
  className,
  children,
}: {
  viewZoom: number
  cx: number
  cy: number
  className?: string
  children: React.ReactNode
}) {
  const s = billboardScale(viewZoom)
  const transform = s > 1.001 ? `translate(-50%, -50%) scale(${s})` : 'translate(-50%, -50%)'
  return (
    <div className={className} style={{ left: cx, top: cy, transform }}>
      {children}
    </div>
  )
}

function kindIcon(kind: SceneNode['kind']) {
  switch (kind) {
    case 'note':
      return StickyNote
    case 'chat':
      return MessageSquare
    case 'import':
      return FileText
    case 'image':
      return ImageIcon
    case 'cluster':
      return Layers
    default:
      return FileText
  }
}

function isHex(c: string): boolean {
  return /^#[0-9a-fA-F]{6}$/.test(c)
}

function primaryColor(node: SceneNode): string {
  const c = node.tags[0]?.color
  return c && isHex(c) ? c : 'hsl(var(--primary))'
}

function secondaryAccent(node: SceneNode, fallback: string): string {
  const t = node.tags[1]?.color
  return t && isHex(t) ? t : fallback
}

function bubbleStyles(color: string): CSSProperties {
  if (isHex(color)) {
    return {
      borderColor: `${color}dd`,
      background: `linear-gradient(155deg, ${color} 0%, ${color}99 45%, ${color}44 100%)`,
      boxShadow: `0 6px 20px ${color}40, inset 0 1px 0 rgba(255,255,255,0.25)`,
    }
  }
  return {
    borderColor: 'hsl(var(--primary) / 0.55)',
    background: 'linear-gradient(155deg, hsl(var(--primary) / 0.88), hsl(var(--primary) / 0.4))',
    boxShadow: '0 6px 20px hsl(var(--primary) / 0.28), inset 0 1px 0 rgba(255,255,255,0.2)',
  }
}

function previewSnippet(node: SceneNode, max = 110): string {
  if (node.kind === 'chat' && node.chatTurns?.length) {
    const tail = node.chatTurns.slice(-2)
    const text = tail.map((t) => t.text).join(' · ')
    return text.replace(/\s+/g, ' ').trim().slice(0, max) || 'Conversation'
  }
  const md = (node.previewMarkdown ?? '').trim()
  if (md) return md.replace(/^#+\s*/gm, '').replace(/\s+/g, ' ').slice(0, max)
  if (node.kind === 'import' && node.sourceFileName) return node.sourceFileName.slice(0, max)
  return ''
}

function TagDots({ tags, max = 4 }: { tags: Tag[]; max?: number }) {
  if (!tags.length) return null
  return (
    <div className="flex flex-wrap gap-0.5 justify-center w-full px-0.5">
      {tags.slice(0, max).map((t) => (
        <span
          key={t.name}
          className="max-w-[5rem] truncate rounded-full px-2 py-0.5 text-[10px] font-medium text-white shadow-sm"
          style={{ backgroundColor: isHex(t.color) ? t.color : 'hsl(var(--muted-foreground))' }}
          title={t.name}
        >
          {t.name}
        </span>
      ))}
      {tags.length > max ? (
        <span className="text-[10px] font-medium text-white/90">+{tags.length - max}</span>
      ) : null}
    </div>
  )
}

function TitleUnder({ children, className = '' }: { children: React.ReactNode; className?: string }) {
  return (
    <div
      className={
        'text-center text-[13px] font-semibold text-foreground leading-snug line-clamp-2 max-w-[22ch] ' +
        'drop-shadow-[0_1px_2px_hsl(var(--background))] ' +
        className
      }
    >
      {children}
    </div>
  )
}

interface Props {
  node: SceneNode
  lod: LodBand
  viewZoom: number
  selected: boolean
  filteredOut: boolean
  clusterMemberCount?: number
  interactionDisabled?: boolean
  onNodePointerDown: (e: React.PointerEvent, node: SceneNode) => void
}

export function SceneNodeView({
  node,
  lod,
  viewZoom,
  selected,
  filteredOut,
  clusterMemberCount = 0,
  interactionDisabled,
  onNodePointerDown,
}: Props) {
  const Icon = kindIcon(node.kind)
  const color = primaryColor(node)
  const color2 = secondaryAccent(node, color)
  const ring = selected ? 'ring-2 ring-primary ring-offset-2 ring-offset-background' : 'ring-1 ring-border/80'
  const ghost = filteredOut ? 'opacity-[0.12] pointer-events-none' : 'opacity-100'
  const noHit = interactionDisabled ? 'pointer-events-none' : ''
  const shell = `${ghost} ${noHit}`
  const cx = node.x + node.width / 2
  const cy = node.y + node.height / 2
  const snippet = previewSnippet(node)

  if (node.kind === 'cluster') {
    if (lod === 'L3') {
      return (
        <Billboard viewZoom={viewZoom} cx={cx} cy={cy} className={`absolute ${shell}`}>
          <div className="flex flex-col items-center gap-1.5 w-[140px]">
            <button
              type="button"
              title={node.title}
              className={`rounded-full border-2 border-dashed border-primary/70 cursor-grab active:cursor-grabbing flex items-center justify-center ${ring}`}
              style={{
                width: 36,
                height: 36,
                background: `linear-gradient(145deg, ${isHex(color) ? color + '55' : 'hsl(var(--primary) / 0.35)'}, transparent)`,
              }}
              onPointerDown={(e) => onNodePointerDown(e, node)}
            >
              <Layers className="size-4 text-primary" strokeWidth={1.75} />
            </button>
            <TitleUnder>
              <span className="text-primary">{node.title}</span>
            </TitleUnder>
          </div>
        </Billboard>
      )
    }
    if (lod === 'L2') {
      return (
        <Billboard viewZoom={viewZoom} cx={cx} cy={cy} className={`absolute ${shell}`}>
          <div className="flex flex-col items-center gap-1.5" style={{ width: L2_COLUMN_W }}>
            <button
              type="button"
              title={node.title}
              className={
                `rounded-full border-2 border-dashed border-primary/55 flex flex-col items-center justify-center gap-1 cursor-grab active:cursor-grabbing ` +
                `${ring}`
              }
              style={{
                width: L2_CLUSTER_BUBBLE_PX,
                height: L2_CLUSTER_BUBBLE_PX,
                background: `linear-gradient(165deg, hsl(var(--primary) / 0.2), hsl(var(--primary) / 0.06))`,
                boxShadow: `0 6px 18px hsl(var(--primary) / 0.15)`,
              }}
              onPointerDown={(e) => onNodePointerDown(e, node)}
            >
              <Layers className="size-5 text-primary" strokeWidth={1.75} />
              <span className="text-[11px] font-bold text-primary tabular-nums">{clusterMemberCount}</span>
              <TagDots tags={node.tags} max={3} />
            </button>
            <TitleUnder>
              <span className="text-primary">{node.title}</span>
            </TitleUnder>
            <span className="text-[11px] text-muted-foreground text-center">{clusterMemberCount} cards</span>
          </div>
        </Billboard>
      )
    }
    return (
      <Billboard viewZoom={viewZoom} cx={cx} cy={cy} className={`absolute ${shell}`}>
        <div
          className={`rounded-[28px] border-2 border-dashed border-primary/50 bg-gradient-to-br from-primary/[0.08] to-primary/[0.02] cursor-grab active:cursor-grabbing ${ring}`}
          style={{
            width: node.width,
            height: node.height,
            boxShadow: `inset 0 0 0 1px hsl(var(--primary) / 0.12), 0 8px 28px hsl(var(--primary) / 0.12)`,
          }}
          onPointerDown={(e) => onNodePointerDown(e, node)}
          role="button"
          tabIndex={0}
        >
          <div className="absolute -top-3 left-4 flex items-center gap-2 rounded-full border border-primary/30 bg-background/95 py-1 pl-1 pr-2.5 text-[11px] font-medium text-primary shadow-md">
            <span
              className="flex size-8 items-center justify-center rounded-full text-white shadow-inner"
              style={bubbleStyles(color)}
            >
              <Layers className="size-4" strokeWidth={1.75} />
            </span>
            <span className="truncate max-w-[220px]">{node.title}</span>
          </div>
          <div className="absolute bottom-3 right-3 rounded-full bg-background/90 px-2.5 py-1 text-[10px] text-muted-foreground border border-border/80 shadow-sm">
            {clusterMemberCount} inside
          </div>
        </div>
      </Billboard>
    )
  }

  if (lod === 'L3') {
    return (
      <Billboard viewZoom={viewZoom} cx={cx} cy={cy} className={`absolute ${shell}`}>
        <div className="flex flex-col items-center gap-1.5" style={{ width: L2_COLUMN_W }}>
          <button
            type="button"
            title={node.title}
            className={`rounded-full border-2 border-background cursor-grab active:cursor-grabbing flex items-center justify-center ${ring}`}
            style={{
              width: 46,
              height: 46,
              ...bubbleStyles(color),
            }}
            onPointerDown={(e) => onNodePointerDown(e, node)}
          >
            <Icon className="size-[22px] text-white drop-shadow-md" strokeWidth={1.75} />
          </button>
          <TitleUnder>{node.title}</TitleUnder>
          {node.tags[0] ? (
            <div className="flex gap-0.5 justify-center">
              <TagDots tags={node.tags} max={3} />
            </div>
          ) : null}
        </div>
      </Billboard>
    )
  }

  if (lod === 'L2') {
    const leadPersona = node.kind === 'chat' && node.personaIds?.[0] ? personaById(node.personaIds[0]) : null
    return (
      <Billboard viewZoom={viewZoom} cx={cx} cy={cy} className={`absolute ${shell}`}>
        <div className="flex flex-col items-center gap-1.5" style={{ width: L2_COLUMN_W }}>
          <button
            type="button"
            title={node.title}
            className={
              `rounded-full flex flex-col items-center justify-between py-2 cursor-grab active:cursor-grabbing ` + `${ring}`
            }
            style={{ width: L2_BUBBLE_PX, height: L2_BUBBLE_PX, ...bubbleStyles(color) }}
            onPointerDown={(e) => onNodePointerDown(e, node)}
          >
            <Icon className="size-[22px] text-white drop-shadow-md shrink-0 mt-0.5" strokeWidth={1.75} />
            <p className="text-[12px] text-white/95 leading-snug line-clamp-3 text-center px-2 drop-shadow min-h-[44px]">
              {snippet || '·'}
            </p>
            {leadPersona ? (
              <span className="text-[11px] text-white/90 truncate max-w-[100px]">{leadPersona.icon}</span>
            ) : null}
            <TagDots tags={node.tags} max={4} />
          </button>
          <TitleUnder>{node.title}</TitleUnder>
          {leadPersona ? (
            <span className="text-[12px] text-muted-foreground text-center line-clamp-1 max-w-[24ch]">
              {leadPersona.icon} {leadPersona.name}
            </span>
          ) : null}
        </div>
      </Billboard>
    )
  }

  /* L1 — card with circular header accent */
  const orbStyle: CSSProperties =
    isHex(color) && isHex(color2) && color !== color2
      ? {
          borderColor: `${color}dd`,
          background: `linear-gradient(145deg, ${color}, ${color2})`,
          boxShadow: `0 6px 16px ${color}44`,
        }
      : bubbleStyles(color)

  const headerOrb = (
    <span className="flex size-12 shrink-0 items-center justify-center rounded-full text-white shadow-md" style={orbStyle}>
      <Icon className="size-6 drop-shadow" strokeWidth={1.75} />
    </span>
  )

  if (node.kind === 'chat' && node.chatTurns && node.chatTurns.length > 0) {
    const personas = (node.personaIds ?? []).map((id) => personaById(id)).filter(Boolean)
    return (
      <Billboard viewZoom={viewZoom} cx={cx} cy={cy} className={`absolute ${shell}`}>
        <div
          className={`flex flex-col rounded-2xl border bg-card text-base shadow-lg overflow-hidden cursor-grab active:cursor-grabbing ${ring}`}
          style={{
            width: node.width,
            height: node.height,
            borderColor: isHex(color) ? `${color}44` : undefined,
            boxShadow: isHex(color) ? `0 12px 40px ${color}22` : undefined,
          }}
          onPointerDown={(e) => onNodePointerDown(e, node)}
          role="button"
          tabIndex={0}
        >
          <div
            className="shrink-0 flex items-start gap-3 px-3 py-3 border-b bg-muted/25"
            style={{ borderBottomColor: isHex(color) ? `${color}33` : undefined }}
          >
            {headerOrb}
            <div className="min-w-0 flex-1 pt-0.5">
              <div className="flex items-center gap-2">
                <span className="truncate font-semibold text-foreground text-[15px]">{node.title}</span>
                <span className="text-xs text-muted-foreground uppercase shrink-0">chat</span>
              </div>
              <div className="mt-1.5 flex flex-wrap gap-1">
                <TagDots tags={node.tags} max={6} />
              </div>
              {personas.length > 0 ? (
                <div className="mt-1 text-xs text-muted-foreground truncate">
                  {personas.map((p) => `${p!.icon} ${p!.name}`).join(' · ')}
                </div>
              ) : null}
            </div>
          </div>
          <div className="flex-1 min-h-0 overflow-auto px-3 py-2.5 space-y-2.5">
            {node.chatTurns.map((t) => (
              <div
                key={t.id}
                className={
                  'rounded-lg px-2.5 py-2 text-[13px] leading-snug ' +
                  (t.role === 'user' ? 'bg-muted/60 text-foreground ml-3' : 'text-foreground mr-3')
                }
                style={
                  t.role === 'assistant' && isHex(color)
                    ? { backgroundColor: `${color}18`, borderLeft: `3px solid ${color}` }
                    : undefined
                }
              >
                <div className="text-[11px] uppercase tracking-wide text-muted-foreground mb-0.5">{t.vendorLabel}</div>
                <div className="whitespace-pre-wrap">{t.text}</div>
              </div>
            ))}
          </div>
        </div>
      </Billboard>
    )
  }

  return (
    <Billboard viewZoom={viewZoom} cx={cx} cy={cy} className={`absolute ${shell}`}>
      <div
        className={`flex flex-col rounded-2xl border bg-card text-base shadow-lg overflow-hidden cursor-grab active:cursor-grabbing ${ring}`}
        style={{
          width: node.width,
          height: node.height,
          borderColor: isHex(color) ? `${color}44` : undefined,
          boxShadow: isHex(color) ? `0 12px 40px ${color}22` : undefined,
        }}
        onPointerDown={(e) => onNodePointerDown(e, node)}
        role="button"
        tabIndex={0}
      >
        <div
          className="shrink-0 flex items-start gap-3 px-3 py-3 border-b bg-muted/25"
          style={{ borderBottomColor: isHex(color) ? `${color}33` : undefined }}
        >
          {headerOrb}
          <div className="min-w-0 flex-1 pt-0.5">
            <div className="flex items-center gap-2">
              <span className="truncate font-semibold text-foreground text-[15px]">{node.title}</span>
              <span className="text-xs text-muted-foreground uppercase shrink-0">{node.kind}</span>
            </div>
            <div className="mt-1.5 flex flex-wrap gap-1">
              <TagDots tags={node.tags} max={8} />
            </div>
            {node.kind === 'import' && node.sourceFileName ? (
              <div className="mt-1 text-xs text-muted-foreground font-mono truncate">{node.sourceFileName}</div>
            ) : null}
          </div>
        </div>
        <div className="flex-1 min-h-0 overflow-auto px-3 py-2.5 text-sm text-muted-foreground whitespace-pre-wrap leading-relaxed">
          {node.previewMarkdown?.trim() ? node.previewMarkdown : '— empty —'}
        </div>
      </div>
    </Billboard>
  )
}
