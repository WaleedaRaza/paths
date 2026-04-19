import { PagePlaceholder } from '@/components/page-placeholder'

export function AgentRunnerPage() {
  return (
    <PagePlaceholder
      title="Agent Runner"
      slice="Slice 3 / 5"
      blurb="Configure and run Claude, Cursor, OpenCode plus your own agents (e.g. Spotify scheduler). Every agent is an MCP server. Swap the model behind a persona from cloud Claude to local Ollama with a config change."
      surface={[
        'Agents list: personas + external agents, each with enabled/disabled + model config',
        'Run panel: fire-and-forget or chat',
        'Logs + recent runs',
      ]}
    />
  )
}
