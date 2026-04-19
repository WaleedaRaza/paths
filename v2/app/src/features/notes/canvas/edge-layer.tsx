import type { CanvasScene, SceneNode } from '@/features/notes/scene/scene-schema'

function center(n: SceneNode) {
  return { x: n.x + n.width / 2, y: n.y + n.height / 2 }
}

interface Props {
  scene: CanvasScene
  /** While linking, emphasize edges touching this node. */
  linkHighlightFromId?: string | null
}

export function EdgeLayer({ scene, linkHighlightFromId }: Props) {
  const byId = new Map(scene.nodes.map((n) => [n.id, n]))
  return (
    <svg
      className="absolute inset-0 w-full h-full pointer-events-none text-muted-foreground"
      aria-hidden
    >
      {scene.links.map((link) => {
        const from = byId.get(link.fromId)
        const to = byId.get(link.toId)
        if (!from || !to) return null
        const a = center(from)
        const b = center(to)
        const dashed = link.kind === 'continues' || link.kind === 'cross_talk'
        const accent = link.kind === 'cross_talk'
        const hl =
          linkHighlightFromId &&
          (link.fromId === linkHighlightFromId || link.toId === linkHighlightFromId)
        return (
          <line
            key={link.id}
            x1={a.x}
            y1={a.y}
            x2={b.x}
            y2={b.y}
            stroke="currentColor"
            strokeWidth={hl ? 2.25 : 1.5}
            vectorEffect="non-scaling-stroke"
            strokeOpacity={accent ? 0.85 : hl ? 0.95 : 0.5}
            strokeDasharray={dashed ? '6 4' : undefined}
          />
        )
      })}
    </svg>
  )
}
