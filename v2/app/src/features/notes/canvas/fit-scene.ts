import type { SceneNode } from '@/features/notes/scene/scene-schema'

/** Axis-aligned bounds of all node rectangles in world space. */
export function bboxOfNodes(nodes: SceneNode[]): { x: number; y: number; w: number; h: number } | null {
  if (nodes.length === 0) return null
  let minX = Infinity
  let minY = Infinity
  let maxX = -Infinity
  let maxY = -Infinity
  for (const n of nodes) {
    minX = Math.min(minX, n.x)
    minY = Math.min(minY, n.y)
    maxX = Math.max(maxX, n.x + n.width)
    maxY = Math.max(maxY, n.y + n.height)
  }
  return { x: minX, y: minY, w: Math.max(1, maxX - minX), h: Math.max(1, maxY - minY) }
}
