/** Serializable canvas scene — storage key matches sprint doc. */

export const CANVAS_SCENE_STORAGE_KEY = 'paths:canvas:scene:v1' as const

export type SceneVersion = 1

export type NodeKind = 'note' | 'chat' | 'import' | 'image' | 'cluster'

export type EdgeKind = 'ref' | 'continues' | 'cluster_member' | 'cross_talk'

export interface Tag {
  name: string
  color: string
}

export interface ChatTurn {
  id: string
  role: 'user' | 'assistant'
  vendorLabel: string
  text: string
}

export interface SceneNode {
  id: string
  kind: NodeKind
  title: string
  x: number
  y: number
  width: number
  height: number
  tags: Tag[]
  clusterId?: string
  previewMarkdown?: string
  personaIds?: string[]
  /** Mock LLM preset id (e.g. ollama:llama3.2) — UI only. */
  mockModelId?: string
  /** Structured transcript; when present, chat UI prefers this over previewMarkdown. */
  chatTurns?: ChatTurn[]
  /** Import card: original filename. */
  sourceFileName?: string
}

/** Stored as `links` in JSON (sprint); optional `kind` for edge vocabulary (deep wire). */
export interface SceneLink {
  id: string
  fromId: string
  toId: string
  kind?: EdgeKind
}

export interface CanvasScene {
  version: SceneVersion
  nodes: SceneNode[]
  links: SceneLink[]
}

export function emptyScene(): CanvasScene {
  return { version: 1, nodes: [], links: [] }
}

export function createNodeId(): string {
  return `n-${crypto.randomUUID?.() ?? `${Date.now()}-${Math.random().toString(36).slice(2, 9)}`}`
}

export function createLinkId(): string {
  return `e-${crypto.randomUUID?.() ?? `${Date.now()}-${Math.random().toString(36).slice(2, 9)}`}`
}

export function createTurnId(): string {
  return `t-${crypto.randomUUID?.() ?? `${Date.now()}-${Math.random().toString(36).slice(2, 9)}`}`
}
