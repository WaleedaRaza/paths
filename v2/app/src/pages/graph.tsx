import { PagePlaceholder } from '@/components/page-placeholder'

export function GraphPage() {
  return (
    <PagePlaceholder
      title="Graph"
      slice="Slice 1"
      blurb="One graph across every tenant. Nodes: Chat, ChatTurn, Note, Task, Goal, Milestone, Persona, Agent, Repo, API, Project, Log, PortfolioPiece, SocialThread. Edges: refs, parent, tag, mentions, authored-by, derived-from, runs-on."
      surface={[
        'Force-directed graph (cytoscape.js or d3)',
        'Filter by node type + edge type',
        'Click a node → open it in its tenant page',
      ]}
    />
  )
}
