# Sprint — Canvas mind-map mocks (Phase A)

**Goal:** Ship interactive UI for Notes (infinite pan/zoom canvas, floating note/chat cards, clusters, tags, import stub) and Tasks (one-page parallax MGTST shell) with **no real LLM calls** and **no vault file I/O** yet. Scene state persists in `localStorage` only.

**Out of scope for this sprint**

- Real Ollama / Anthropic / OpenAI streaming
- Writing chat transcripts to markdown on disk
- MCP, agents, skills
- Separate **Graph** nav entry (hidden until canvas MVP ships; see [README](../README.md))

---

## Scene schema (`paths:canvas:scene:v1`)

Serializable JSON loaded/saved by the Notes canvas.

| Field | Type | Notes |
|-------|------|--------|
| `version` | `1` | Bump when schema changes |
| `nodes` | array | Cards + clusters |
| `links` | array | `{ fromId, toId }` mock edges for connector lines |

**Node kinds**

- `noteCard` — markdown preview, `kind: "note"`
- `chatCard` — chat chrome, `kind: "chat"`, optional `personaIds[]`
- `importCard` — raw `.md` preview from file picker
- `imageCard` — stub placeholder only
- `cluster` — bounding group; member cards reference `clusterId`

**Shared fields:** `id`, `title`, `x`, `y`, `width`, `height`, `tags[]` (`{ name, color }`), `clusterId?`, `previewMarkdown?`

---

## Acceptance

1. Notes: pan, zoom (wheel), drag cards, create note/chat, tag with color, group into cluster, import `.md` into import card, reset demo fixture; scene survives reload.
2. Cluster inspector: pick 2+ personas → **Round** runs mock round-robin assistant bubbles (no network).
3. Tasks: parallax-style stacked sections (Milestone → Goal → Task → MustWin) with mock counts; “Open on canvas” sets focus hint and switches to Notes (custom event).
4. Setup: API keys save/load via OS keychain when running under Tauri (not localStorage).
5. App: SQLite `sqlite:paths.db` preloaded with migration creating `app_meta` table.

---

## Future bridge (Phase C)

- Map `chatCard` + turns → single vault `.md` with `kind: chat` and `## Turn N · role` (see [plan-personas-notes-chats.md](./plan-personas-notes-chats.md)).
- Map `cluster` multi-persona session → same file with multiple persona slugs in turns, or split files (decide before wiring Rust).
