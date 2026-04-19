import type { SceneLink } from '@/features/notes/scene/scene-schema'

/** Canonical order so the same pair is always stored once (mutual / undirected links). */
export function normalizeLinkEndpoints(fromId: string, toId: string): [string, string] {
  return fromId < toId ? [fromId, toId] : [toId, fromId]
}

export function linkConnectsPair(link: Pick<SceneLink, 'fromId' | 'toId'>, a: string, b: string): boolean {
  if (a === b) return false
  return (link.fromId === a && link.toId === b) || (link.fromId === b && link.toId === a)
}

/** One link per unordered pair; endpoints stored with stable sort. */
export function dedupeUndirectedLinks(links: SceneLink[]): SceneLink[] {
  const seen = new Set<string>()
  const out: SceneLink[] = []
  for (const l of links) {
    const [a, b] = normalizeLinkEndpoints(l.fromId, l.toId)
    const key = `${a}\0${b}`
    if (seen.has(key)) continue
    seen.add(key)
    out.push({ ...l, fromId: a, toId: b })
  }
  return out
}
