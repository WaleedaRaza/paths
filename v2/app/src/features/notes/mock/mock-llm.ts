/** UI-only mock “providers” — no network. */

export interface MockModelPreset {
  id: string
  vendor: string
  model: string
  hint: string
}

export const MOCK_MODELS: MockModelPreset[] = [
  { id: 'ollama:llama3.2', vendor: 'Ollama', model: 'Llama 3.2', hint: 'local' },
  { id: 'ollama:qwen2.5', vendor: 'Ollama', model: 'Qwen 2.5', hint: 'local' },
  { id: 'openai:gpt-4o', vendor: 'OpenAI', model: 'GPT-4o', hint: 'cloud' },
  { id: 'openai:gpt-4o-mini', vendor: 'OpenAI', model: 'GPT-4o mini', hint: 'cloud' },
  { id: 'anthropic:claude-3-5', vendor: 'Anthropic', model: 'Claude 3.5', hint: 'cloud' },
  { id: 'google:gemini-2', vendor: 'Google', model: 'Gemini 2', hint: 'cloud' },
]

export function defaultMockModelId(): string {
  return MOCK_MODELS[0]?.id ?? 'ollama:llama3.2'
}

export function mockVendorLabel(modelId: string): string {
  const m = MOCK_MODELS.find((x) => x.id === modelId)
  return m ? `${m.vendor} · ${m.model}` : modelId
}

export function mockAssistantReply(modelId: string, userText: string): string {
  const m = MOCK_MODELS.find((x) => x.id === modelId) ?? MOCK_MODELS[0]
  const clip = userText.trim().slice(0, 120) || '(empty message)'
  switch (m?.vendor) {
    case 'Ollama':
      return `[mock · offline] Treat “${clip}” as a slice: keep the graph on canvas, persist scene JSON until vault lands.`
    case 'OpenAI':
      return `[mock · GPT-style] Three beats: (1) restate goal, (2) propose smallest change, (3) risk. For: ${clip}`
    case 'Anthropic':
      return `[mock · Claude-style] Before coding: list assumptions, then answer conservatively about: ${clip}`
    case 'Google':
      return `[mock · Gemini-style] Outline + bullets for: ${clip} — verify against your sprint doc.`
    default:
      return `[mock] Echo: ${clip}`
  }
}
