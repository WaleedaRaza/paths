import { createNodeId, type CanvasScene, type SceneNode } from '@/features/notes/scene/scene-schema'

/** Extra slack around each card’s bbox — cards within this gap are treated as “together”. */
const MERGE_EXPANSION_PX = 72

function isClusterableMember(n: SceneNode): boolean {
  return n.kind === 'note' || n.kind === 'chat' || n.kind === 'import' || n.kind === 'image'
}

function expandRect(n: SceneNode, pad: number) {
  return {
    x: n.x - pad,
    y: n.y - pad,
    w: n.width + pad * 2,
    h: n.height + pad * 2,
  }
}

function rectsOverlap(
  a: { x: number; y: number; w: number; h: number },
  b: { x: number; y: number; w: number; h: number },
): boolean {
  return a.x + a.w > b.x && b.x + b.w > a.x && a.y + a.h > b.y && b.y + b.h > a.y
}

/**
 * After moves: groups that overlap (with slack) become one cluster frame; lone cards lose `clusterId`.
 * Cluster nodes are created/updated/removed automatically — you don’t “add” a cluster to the canvas.
 */
export function reconcileClustersFromProximity(scene: CanvasScene): CanvasScene {
  const pad = MERGE_EXPANSION_PX
  const members = scene.nodes.filter(isClusterableMember)
  const clusterNodes = scene.nodes.filter((n) => n.kind === 'cluster')
  const clusterMeta = new Map(clusterNodes.map((c) => [c.id, c]))

  const m = members.length
  const parent = Array.from({ length: m }, (_, i) => i)

  function find(i: number): number {
    if (parent[i] !== i) parent[i] = find(parent[i])
    return parent[i]
  }

  function union(i: number, j: number) {
    const ri = find(i)
    const rj = find(j)
    if (ri !== rj) parent[ri] = rj
  }

  for (let i = 0; i < m; i++) {
    for (let j = i + 1; j < m; j++) {
      const a = expandRect(members[i], pad)
      const b = expandRect(members[j], pad)
      if (rectsOverlap(a, b)) union(i, j)
    }
  }

  const buckets = new Map<number, number[]>()
  for (let i = 0; i < m; i++) {
    const r = find(i)
    if (!buckets.has(r)) buckets.set(r, [])
    buckets.get(r)!.push(i)
  }

  /** member id → cluster frame id, or undefined if loose */
  const assignment = new Map<string, string | undefined>()
  const clustersToWrite = new Map<
    string,
    { title: string; tags: SceneNode['tags']; members: SceneNode[] }
  >()

  for (const indices of buckets.values()) {
    const group = indices.map((i) => members[i])
    if (group.length < 2) {
      for (const node of group) assignment.set(node.id, undefined)
      continue
    }

    const existingIds = [
      ...new Set(group.map((n) => n.clusterId).filter((id): id is string => Boolean(id))),
    ]
    const reusable =
      existingIds.length === 1 && clusterMeta.has(existingIds[0]) ? existingIds[0] : undefined

    const clusterId = reusable ?? createNodeId()
    const template = reusable ? clusterMeta.get(reusable)! : undefined

    clustersToWrite.set(clusterId, {
      title: template?.title ?? 'Cluster',
      tags: template?.tags?.length ? template.tags : [{ name: 'cluster', color: '#6366f1' }],
      members: group,
    })

    for (const n of group) assignment.set(n.id, clusterId)
  }

  const nextMembers: SceneNode[] = members.map((n) => {
    const cid = assignment.get(n.id)
    return cid ? { ...n, clusterId: cid } : { ...n, clusterId: undefined }
  })

  const nextClusters: SceneNode[] = [...clustersToWrite.keys()].map((id) => {
    const spec = clustersToWrite.get(id)!
    let minX = Infinity
    let minY = Infinity
    let maxX = -Infinity
    let maxY = -Infinity
    for (const n of spec.members) {
      minX = Math.min(minX, n.x)
      minY = Math.min(minY, n.y)
      maxX = Math.max(maxX, n.x + n.width)
      maxY = Math.max(maxY, n.y + n.height)
    }
    const framePad = 36
    const prev = clusterMeta.get(id)
    return {
      id,
      kind: 'cluster' as const,
      title: prev?.title ?? spec.title,
      x: minX - framePad,
      y: minY - framePad,
      width: Math.max(200, maxX - minX + framePad * 2),
      height: Math.max(140, maxY - minY + framePad * 2),
      tags: prev?.tags?.length ? prev.tags : spec.tags,
    }
  })

  const memberById = new Map(nextMembers.map((n) => [n.id, n]))
  const nextNodes: SceneNode[] = [...nextClusters]
  for (const n of scene.nodes) {
    if (n.kind === 'cluster') continue
    const u = memberById.get(n.id)
    if (u) nextNodes.push(u)
    else nextNodes.push(n)
  }

  const nodeIds = new Set(nextNodes.map((n) => n.id))
  const links = scene.links.filter((l) => nodeIds.has(l.fromId) && nodeIds.has(l.toId))

  return { ...scene, nodes: nextNodes, links }
}
