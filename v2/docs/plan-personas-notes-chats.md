# Plan — Personas, Ollama, Notes-with-Chats

**Reframing (load-bearing):** a **chat is a note.** There is no separate "chats" tenant. Any `.md` in the vault can be a chat — it's flagged in YAML frontmatter, and its body uses a documented turn structure. Notes, journals, ideas, imports from ChatGPT/Gemini/Claude — all land in the same vault under the same format. This collapses four problems (notes storage, chat storage, import, graph linking) into one.

---

## 1. Vault file formats

### Plain note
```markdown
---
id: note-20260419-1430
kind: note
created: 2026-04-19T14:30:00Z
tags: [startup, wedge]
---

# Validating the wedge

Some thoughts. Plain markdown. `[[links]]` anywhere make graph edges.
```

### Chat note
```markdown
---
id: note-20260419-1432
kind: chat
created: 2026-04-19T14:32:00Z
persona: founder-engineer
model: ollama:llama3.1:8b
tags: [startup]
context: [note-20260419-1430, task:T-42]
---

# Pressure-testing the wedge

## Turn 1 · user
How do I test demand before building?

## Turn 2 · founder-engineer
Stop building. Run a manual demo...

## Turn 3 · user
What's the cheapest possible form?
```

**Turn delimiter is `## Turn <N> · <role>`.**
- `N` is 1-indexed, monotonic.
- `<role>` is `user` or a persona slug.
- Parser is a single regex; turns can't be mistaken for H2 headings inside content because of the `Turn <N> · ` prefix.
- Rendered in Obsidian with turns as sidebar entries.

### Persona bundle (lives in vault at `_personas/<slug>/`)
```
_personas/founder-engineer/
  system.md          ← system prompt body
  context-hints.md   ← human notes on when/how to invoke this persona
  config.json        ← model, provider, temperature, top_p, max_tokens, tool allowlist
```

`config.json`:
```json
{
  "label": "Founder-Engineer",
  "emoji": "🚀",
  "provider": "ollama",
  "model": "llama3.1:8b",
  "temperature": 0.7,
  "top_p": 0.9,
  "max_tokens": 4096,
  "tools": []
}
```

Personas live in the vault on purpose — they sync with the user's stuff, can be edited in any markdown editor, and are portable across devices.

---

## 2. Backend modules (Rust)

All live under `src-tauri/src/`. Each exposes Tauri commands the React side invokes.

### `vault` module
- `vault_set_root(path)` — persist + watch
- `vault_list(path?)` — paginated directory listing
- `vault_read(path)` — parsed frontmatter + body
- `vault_write(path, frontmatter, body)` — atomic write
- `vault_create_note(kind, persona?)` — returns new file path
- `vault_append_turn(path, role, content)` — appends a turn, bumps turn counter
- `vault_watch()` — emits `vault:changed` events (file added/modified/removed)

### `persona` module
- `persona_list()` — lists bundles under `_personas/`
- `persona_read(slug)` — system prompt + config
- `persona_write(slug, system, config)`
- `persona_seed_defaults()` — writes the 8 v1 personas + Kobayashi Maru on first run from sources in `paths-main/lifeline_os/lib/core/constants/experts.dart` + `paths-main/ai/prompts/`

### `llm` module
- Provider trait: `Provider::chat_stream(messages, config) -> Stream<Event>`
- Implementations: `OllamaProvider`, `AnthropicProvider`, `OpenAIProvider`, `GoogleProvider`
- `llm_chat_stream(persona_slug, messages)` — resolves persona → provider → streams
- Streaming surfaces as Tauri events on channel `llm:<request_id>:{token,done,error}`

### `ollama` (inside `llm`)
- HTTP client for `http://localhost:11434`
- `ollama_health()` → ok/unreachable
- `ollama_list_models()` → parsed `/api/tags`
- `ollama_pull(model)` → streams pull progress as events
- `ollama_chat(messages)` → streams `/api/chat` NDJSON

### `config` module (already partially exists via `tauri-plugin-store`)
- Typed app config: vault path, default model, ollama URL, provider defaults

### `keys` module (blocks on task #7)
- Wraps `keyring` crate → OS keychain (Secret Service on Linux, Keychain on Mac, Keychain on iOS via Capacitor bridge later)
- `key_set(provider)`, `key_get(provider)`, `key_delete(provider)`

---

## 3. UI surfaces

### Notes & Chats — 3-column
```
┌─────────────────────────────────────────────────────────────────────────┐
│ paths                                                                     │
├──────────────┬──────────────────────────────────┬────────────────────────┤
│ Notes & Chats │ ┌──────────────────────────────┐│ ▣ Persona              │
│               │ │ # Validating the wedge        ││ [Founder-Engineer ▼]  │
│ 🔍 [search  ] │ └──────────────────────────────┘│                        │
│               │                                  │ ▣ Model                │
│ 📁 vault      │ ## Turn 1 · user                ││ [ollama:llama3.1 ▼]   │
│  📁 chats     │ How do I test demand before     ││ T: [0.7]  max: [4096] │
│  📁 journal   │ building?                       ││                        │
│  📁 ideas     │                                  │ ▣ Context              │
│  📁 imports/  │ ## Turn 2 · founder-engineer    ││ ☑ Linked notes (3)    │
│               │ Stop building. Run a manual     ││ ☑ Linked tasks (1)    │
│ 📄 wedge-val..│ demo...                         ││ ☐ Web search           │
│ 📄 today-jour.│                                  │ ☐ Full vault           │
│ 📄 morning-id │ ## Turn 3 · user                ││                        │
│               │ What's the cheapest possible    ││ ▣ Actions              │
│ [+ note]      │ form?                           ││ [Summarize chat]       │
│ [+ chat]      │                                  │ [→ Extract task]       │
│               │ ┌────────────────────────────┐  │ [→ New note from this]│
│               │ │ message…         [⏎ Send]   │  │ [Convert note → chat]│
│               │ └────────────────────────────┘  │                        │
└──────────────┴──────────────────────────────────┴────────────────────────┘
```

Left rail:
- Search at top (FTS5 once wired; plain string match as MVP)
- Vault tree below — folder expand/collapse
- "New note" / "New chat" at the bottom of the panel

Center:
- Markdown view of the file. For chats: turns rendered as speech bubbles (brutalist — just indented cards with a role pill).
- Inline editor at bottom for chat; full-page editor for non-chat notes.
- `[[link]]` is a live autocomplete against vault node titles.

Right rail (context-aware):
- If chat: Persona picker (dropdown of `_personas/*`), model override, temperature, **Context** checkboxes that determine what gets injected into the system prompt, and **Actions** that operate on the chat.
- If plain note: skip persona/model, show AI actions (Summarize / Expand / Rewrite / Extract task).

### Personas editor (sub-route of Agent Runner tenant)
```
┌────────────────────────────────────────────────────────────────────┐
│ paths · Agents · Personas                                            │
├──────────────────┬──────────────────────────────────────────────────┤
│ ✓ Mirror-Guide   │ Label      [Mirror-Guide           ]              │
│ ✓ Lock-In Coach  │ Emoji      [🪞  ]                                  │
│ ✓ Planner        │                                                   │
│ ✓ Therapist      │ System prompt ───────────────────────────────    │
│ ✓ Philosopher    │ ┌──────────────────────────────────────────────┐│
│ ✓ Psych Strat.   │ │ You are the Mirror-Guide...                   ││
│ ✓ Architect      │ │                                                ││
│ ✓ Founder-Eng.   │ │                                                ││
│ ✓ Kobayashi Maru │ └──────────────────────────────────────────────┘│
│                  │                                                   │
│ [+ New persona]  │ Model                                             │
│                  │  Provider [Ollama          ▼]                     │
│                  │  Model    [llama3.1:8b     ▼]                     │
│                  │  T 0.7    top_p 0.9   max_tokens 4096              │
│                  │                                                   │
│                  │ Context hints ──────────────────────────────     │
│                  │ ┌──────────────────────────────────────────────┐│
│                  │ │ When to invoke, what context matters, etc.    ││
│                  │ └──────────────────────────────────────────────┘│
│                  │                                                   │
│                  │ [▶ Test chat]  [Save]  [Duplicate]  [Delete]     │
└──────────────────┴──────────────────────────────────────────────────┘
```

### Setup · Models (extending the existing Setup page)
```
┌ Models ───────────────────────────────────────────────────────────┐
│ Local (Ollama)                                                     │
│   Endpoint [http://localhost:11434] [Test ✓ reachable]             │
│   Installed models:                                                │
│     • llama3.1:8b    4.7 GB   [Set default] [Remove]              │
│     • qwen2.5:7b     4.4 GB   [Set default] [Remove]              │
│   [+ Pull model…]                                                  │
│                                                                     │
│ Cloud                                                               │
│   ◻ Anthropic   [sk-ant-••••••••]   default: claude-opus-4-7       │
│   ◻ OpenAI      [sk-••••••••]        default: gpt-5                │
│   ◻ Google      [••••••••]           default: gemini-1.5-pro       │
│                                                                     │
│ Routing                                                             │
│   Default for new chats:   [ollama:llama3.1:8b ▼]                   │
│   Fallback when offline:   [ollama:llama3.1:8b ▼]                   │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 4. Build order (each is a ≤90-min card)

Each card below has a title, files touched, acceptance.

### Card 1 — Seed persona bundles
- **Files:** `src-tauri/src/persona.rs` (new), `src-tauri/src/lib.rs` (register commands), `src-tauri/migrations/personas/*.md` + `*.json` (bundled at compile time via `include_str!`)
- **Accept:** `persona_seed_defaults` copies 9 bundles into `<vault>/_personas/` on first run. `persona_list` returns them.

### Card 2 — Ollama client + health + model list
- **Files:** `src-tauri/src/llm/mod.rs`, `src-tauri/src/llm/ollama.rs`, add `reqwest` to Cargo
- **Accept:** `ollama_health()` returns status. `ollama_list_models()` returns parsed `/api/tags`. Wired to a "Test" button in Setup > Models.

### Card 3 — Ollama streaming chat
- **Files:** `src-tauri/src/llm/ollama.rs` (extend), `src-tauri/src/llm/stream.rs` (Tauri event helper)
- **Accept:** A hardcoded test button in Setup sends "hello" to the default model and renders streamed tokens in an alert area.

### Card 4 — Vault file I/O (notes)
- **Files:** `src-tauri/src/vault/mod.rs`, `src-tauri/src/vault/frontmatter.rs` (serde_yaml), `src-tauri/src/vault/turn_parser.rs`
- **Accept:** `vault_list` + `vault_read` + `vault_create_note` + `vault_append_turn` all work from React. Creating a chat note produces the frontmatter template above.

### Card 5 — Notes page — read-only viewer
- **Files:** `src/pages/notes.tsx` (rewrite), `src/components/vault-tree.tsx`, `src/components/note-view.tsx`, `src/lib/vault.ts`
- **Accept:** Sidebar shows vault tree. Clicking a note shows it rendered. Frontmatter renders as a muted pill row; body renders as markdown.

### Card 6 — Notes page — chat pane
- **Files:** `src/components/chat-pane.tsx`, `src/components/turn-view.tsx`, extends `note-view.tsx`
- **Accept:** Opening a `kind: chat` note shows turns. Input at bottom sends → stream tokens append as `Turn N+1 · <persona>`. File on disk is live-updated.

### Card 7 — Right rail: persona + model picker + context toggles
- **Files:** `src/components/chat-context-rail.tsx`, `src/lib/persona.ts`
- **Accept:** Picker changes per-chat persona (writes to frontmatter). Temperature / max_tokens overrides persist per chat. Context toggles set which linked nodes get appended to the system prompt.

### Card 8 — Personas editor page
- **Files:** `src/pages/personas.tsx` (new), linked as sub-route of Agent Runner
- **Accept:** Edit system prompt, model config, context hints of any persona. "Test chat" opens a transient chat against the persona without saving.

### Card 9 — Provider keychain + cloud clients
- **Files:** `src-tauri/src/keys.rs`, `src-tauri/src/llm/anthropic.rs`, `src-tauri/src/llm/openai.rs`, `src-tauri/src/llm/google.rs`
- **Accept:** Paste key into Setup > Providers → stored in OS keychain. Provider dropdown in Personas editor shows cloud options; streaming works for each.

### Card 10 — Context injection pipeline
- **Files:** `src-tauri/src/context/mod.rs`, `src-tauri/src/context/linked_nodes.rs`
- **Accept:** When sending a turn, linked notes/tasks mentioned in frontmatter `context:` get appended to the system prompt as fenced sections.

### Card 11 — `[[link]]` autocomplete + graph edge parser
- **Files:** `src-tauri/src/graph/parser.rs`, `src/components/wikilink-input.tsx`
- **Accept:** Typing `[[` in any note brings up a picker over vault titles + task IDs. On save, `[[links]]` are extracted to a lightweight SQLite `edges` table.

### Card 12 — Graph page — minimum viable force-directed view
- **Files:** `src/pages/graph.tsx` (rewrite), add `cytoscape` (JS-only, no Rust)
- **Accept:** Nodes from vault + tasks, edges from the parser table. Click a node → opens in its tenant. Filter by node type.

Cards 13+ pick up SQLite migrations for Tasks (task #8), canvas timeline, import pipelines, and so on — separate plan doc when we get there.

---

## 5. Decisions made (flag if wrong)

- **Chat storage = markdown files with YAML frontmatter + H2 turn delimiters.** Alternative was SQLite rows for chat turns; rejected because it splits the storage model and breaks vault-as-source-of-truth.
- **Personas live in the vault under `_personas/`**, not in app config. Makes them portable, syncable, user-editable in any editor.
- **Turn delimiter: `## Turn <N> · <role>`.** Alternative was HTML comments or YAML lists; rejected because those lose human readability.
- **Tauri events for streaming** (not SSE, not a local websocket). Standard Tauri pattern, no extra server.
- **Ollama first, cloud providers behind the keychain card (#9).** Matches your priority order and avoids a provider-key wall before you can try anything.
- **`_personas/` prefix so it sorts above other folders** and signals "config, not content."

## 6. Open questions (call before I start)

- **Personas seed path.** Do I ingest the 8 personas from v1's `experts.dart` verbatim, or do you want to review/edit them before they get committed to `_personas/`? Default: I'll commit them verbatim with an `editable-by-you` note at the top of each `system.md`.
- **Default model.** With Ollama installed, what model should paths default to? `llama3.1:8b` is safe-and-common; `qwen2.5:7b` or `gpt-oss-20b` if your machine handles them. (Doesn't block work — default is a one-line config change.)
- **Vault path default.** Suggest `~/paths-vault/` on first run, let you change it in Setup. Or do you already have a dir in mind?
