import { dedupeUndirectedLinks } from '@/features/notes/scene/link-utils'
import {
  createLinkId,
  createNodeId,
  createTurnId,
  type CanvasScene,
  type SceneNode,
} from '@/features/notes/scene/scene-schema'
import { defaultMockModelId, mockVendorLabel } from '@/features/notes/mock/mock-llm'

export function buildDemoScene(): CanvasScene {
  const clusterResearch: SceneNode = {
    id: createNodeId(),
    kind: 'cluster',
    title: 'Research · API shape',
    x: 1840,
    y: 1760,
    width: 920,
    height: 520,
    tags: [{ name: 'cluster', color: '#6366f1' }],
  }

  const clusterInbox: SceneNode = {
    id: createNodeId(),
    kind: 'cluster',
    title: 'Inbox · files',
    x: 2860,
    y: 1820,
    width: 420,
    height: 380,
    tags: [{ name: 'cluster', color: '#8b5cf6' }],
  }

  const noteA: SceneNode = {
    id: createNodeId(),
    kind: 'note',
    title: 'Wedge validation',
    x: 1920,
    y: 1880,
    width: 280,
    height: 160,
    tags: [{ name: 'strategy', color: '#7c3aed' }],
    clusterId: clusterResearch.id,
    previewMarkdown: '# Wedge\n\nRisk: coupling the orchestrator to transport.',
  }

  const noteB: SceneNode = {
    id: createNodeId(),
    kind: 'note',
    title: 'ADR-1 · SQLite',
    x: 2280,
    y: 1920,
    width: 280,
    height: 160,
    tags: [{ name: 'infra', color: '#0d9488' }],
    clusterId: clusterResearch.id,
    previewMarkdown: 'Local **SQLite** as derived index; markdown canonical.',
  }

  const mid = defaultMockModelId()
  const chat: SceneNode = {
    id: createNodeId(),
    kind: 'chat',
    title: 'Multi-model thread',
    x: 2000,
    y: 2120,
    width: 320,
    height: 220,
    tags: [{ name: 'design', color: '#ea580c' }],
    clusterId: clusterResearch.id,
    mockModelId: mid,
    personaIds: ['planner', 'architect'],
    chatTurns: [
      {
        id: createTurnId(),
        role: 'user',
        vendorLabel: 'You',
        text: 'Compare Ollama vs cloud for the first slice.',
      },
      {
        id: createTurnId(),
        role: 'assistant',
        vendorLabel: mockVendorLabel(mid),
        text: mockAssistantStatic(mid),
      },
    ],
    previewMarkdown: '',
  }

  const imported: SceneNode = {
    id: createNodeId(),
    kind: 'import',
    title: 'spec-api.md',
    x: 2940,
    y: 1940,
    width: 300,
    height: 200,
    tags: [{ name: 'import', color: '#64748b' }],
    clusterId: clusterInbox.id,
    sourceFileName: 'spec-api.md',
    previewMarkdown:
      '## Endpoints\n\n- `GET /health`\n- `POST /session`\n\n## Notes\n\nImported mock.',
  }

  const inboxNote: SceneNode = {
    id: createNodeId(),
    kind: 'note',
    title: 'Inbox scratch',
    x: 3000,
    y: 1960,
    width: 240,
    height: 120,
    tags: [{ name: 'inbox', color: '#a78bfa' }],
    clusterId: clusterInbox.id,
    previewMarkdown: 'Clusters form when cards overlap; this inbox keeps two cards in one frame.',
  }

  const floater: SceneNode = {
    id: createNodeId(),
    kind: 'note',
    title: 'Floating idea',
    x: 2480,
    y: 1680,
    width: 240,
    height: 120,
    tags: [{ name: 'idea', color: '#f59e0b' }],
    previewMarkdown: 'Not in a cluster — shows loose nodes still link.',
  }

  return {
    version: 1,
    nodes: [clusterResearch, clusterInbox, noteA, noteB, chat, imported, inboxNote, floater],
    links: dedupeUndirectedLinks([
      { id: createLinkId(), fromId: noteA.id, toId: noteB.id, kind: 'ref' },
      { id: createLinkId(), fromId: chat.id, toId: noteA.id, kind: 'cross_talk' },
      { id: createLinkId(), fromId: imported.id, toId: noteB.id, kind: 'ref' },
      { id: createLinkId(), fromId: floater.id, toId: clusterResearch.id, kind: 'continues' },
    ]),
  }
}

function mockAssistantStatic(modelId: string): string {
  const label = mockVendorLabel(modelId)
  return `[demo turn] ${label} — Start with local mocks; swap providers without moving nodes on the canvas.`
}
