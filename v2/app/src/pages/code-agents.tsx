import { PagePlaceholder } from '@/components/page-placeholder'

export function CodeAgentsPage() {
  return (
    <PagePlaceholder
      title="GitHub & Code Agents"
      slice="Slice 5"
      blurb="Orchestrate Claude Code / Cursor / OpenCode over your repos. Uses v1's Planner → Executor → Field-Editor → Debugger prompt framework as the vibe-coding backbone. Repos and agents are graph nodes."
      surface={[
        'Left: repo list (watched)',
        'Center: agent conversation + diffs',
        'Right: Planner/Executor/Debugger mode switcher',
      ]}
    />
  )
}
