import { createNodeId, type CanvasScene, type SceneNode } from '@/features/notes/scene/scene-schema'

export function isClusterableMember(n: SceneNode): boolean {
  return n.kind === 'note' || n.kind === 'chat' || n.kind === 'import' || n.kind === 'image'
}

/** Ray-cast; `vertices` closed or open (last !== first ok). */
export function pointInPolygon(px: number, py: number, vertices: { x: number; y: number }[]): boolean {
  if (vertices.length < 3) return false
  let inside = false
  for (let i = 0, j = vertices.length - 1; i < vertices.length; j = i++) {
    const xi = vertices[i].x
    const yi = vertices[i].y
    const xj = vertices[j].x
    const yj = vertices[j].y
    const intersect = yi > py !== yj > py && px < ((xj - xi) * (py - yi)) / (yj - yi + 1e-12) + xi
    if (intersect) inside = !inside
  }
  return inside
}

function nodeCenter(n: SceneNode): { x: number; y: number } {
  return { x: n.x + n.width / 2, y: n.y + n.height / 2 }
}

/** Node is inside lasso if center is in polygon or any bbox corner is. */
export function nodeHitByLasso(n: SceneNode, polygon: { x: number; y: number }[]): boolean {
  if (polygon.length < 3) return false
  const c = nodeCenter(n)
  if (pointInPolygon(c.x, c.y, polygon)) return true
  const pts = [
    { x: n.x, y: n.y },
    { x: n.x + n.width, y: n.y },
    { x: n.x + n.width, y: n.y + n.height },
    { x: n.x, y: n.y + n.height },
  ]
  return pts.some((p) => pointInPolygon(p.x, p.y, polygon))
}

function collectMemberIds(scene: CanvasScene, polygon: { x: number; y: number }[]): string[] {
  const ids: string[] = []
  for (const n of scene.nodes) {
    if (!isClusterableMember(n)) continue
    if (nodeHitByLasso(n, polygon)) ids.push(n.id)
  }
  return ids
}

function countMembersByCluster(nodes: SceneNode[]): Map<string, number> {
  const m = new Map<string, number>()
  for (const n of nodes) {
    if (n.kind === 'cluster' || !n.clusterId) continue
    m.set(n.clusterId, (m.get(n.clusterId) ?? 0) + 1)
  }
  return m
}

/** Draw a lasso around 2+ notes/chats/imports → one new cluster frame. */
export function createClusterFromLassoPolygon(scene: CanvasScene, polygon: { x: number; y: number }[]): CanvasScene {
  const memberIds = new Set(collectMemberIds(scene, polygon))
  if (memberIds.size < 2) return scene

  const newClusterId = createNodeId()
  const members = scene.nodes.filter((n) => memberIds.has(n.id))

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
  const pad = 40
  const clusterFrame: SceneNode = {
    id: newClusterId,
    kind: 'cluster',
    title: 'Cluster',
    x: minX - pad,
    y: minY - pad,
    width: Math.max(220, maxX - minX + pad * 2),
    height: Math.max(160, maxY - minY + pad * 2),
    tags: [{ name: 'cluster', color: '#6366f1' }],
  }

  let nodes: SceneNode[] = scene.nodes.map((n) =>
    memberIds.has(n.id) ? { ...n, clusterId: newClusterId } : n,
  )
  nodes = [clusterFrame, ...nodes]

  const counts = countMembersByCluster(nodes)
  nodes = nodes.filter((n) => n.kind !== 'cluster' || (counts.get(n.id) ?? 0) > 0)
  const alive = new Set(nodes.filter((n) => n.kind === 'cluster').map((n) => n.id))
  nodes = nodes.map((n) => {
    if (n.kind === 'cluster') return n
    if (n.clusterId && !alive.has(n.clusterId)) return { ...n, clusterId: undefined }
    return n
  })

  const nodeIds = new Set(nodes.map((n) => n.id))
  const links = scene.links.filter((l) => nodeIds.has(l.fromId) && nodeIds.has(l.toId))

  return { ...scene, nodes, links }
}

/** Remove frame; members become loose cards. */
export function dissolveCluster(scene: CanvasScene, clusterId: string): CanvasScene {
  const nodes = scene.nodes
    .filter((n) => n.id !== clusterId)
    .map((n) => (n.clusterId === clusterId ? { ...n, clusterId: undefined } : n))
  const alive = new Set(nodes.map((n) => n.id))
  const links = scene.links.filter((l) => alive.has(l.fromId) && alive.has(l.toId))
  return { ...scene, nodes, links }
}
