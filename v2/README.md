# paths v2

Personal hub: notes + chats + tasks + portfolio + agents, all linked through an underlying graph schema, running on Mac / Linux / iOS.

**Plan of record:** `~/.claude/plans/1-my-own-gfraph-purring-pearl.md`

## Layout

```
v2/
  app/           # Vite + React + TS UI (one codebase for all targets)
  services/      # Rust daemons (added in Slice 3 — MCP host, indexer, agent runner, sync)
  vault/         # (not in repo) markdown + SQLite, configured at runtime
```

v1 (Flutter "Lifeline OS") lives at `paths-main/` alongside this — reference museum, not imported.

## Stack

- **UI:** React + TypeScript + Tailwind + shadcn/ui
- **Desktop (Mac, Linux):** Tauri (Rust-native shell — no Node in runtime)
- **iOS:** Capacitor (same React bundle in WebKit)
- **Core services (Slice 3+):** Rust daemons, local HTTP/gRPC
- **Storage:** Markdown canonical + SQLite derived + FTS5 / vector index rebuildable from disk

## Running

```
cd v2/app
npm run dev            # vite only, plain browser → localStorage fallback
npm run tauri:dev      # Tauri desktop window, real store + fs + dialog
```

iOS (Capacitor) config is in place at `v2/app/capacitor.config.ts`. `npx cap add ios` must run on **macOS + Xcode** — Linux can't build the iOS project. When you're on a Mac: `npm run build && npx cap add ios && npx cap sync ios && npx cap open ios`.

## Slices

- **0 — Bones.** Scaffold, Tauri + Capacitor boot, Setup/Config page, SQLite migrations. *← in progress — Tauri ✓, Capacitor config ✓, Setup page partial (vault + model persist; API-key keychain + SQLite still pending).*
- **1 — Notes + Chats + Graph bones.** Markdown vault CRUD, local Ollama + cloud chat, graph view from `[[links]]`.
- **2 — Tasks + Goals.** MGTST ported from v1, canvas timeline, MustWin.
- **3 — MCP backbone + first agent.** Hub exposes MCP. One persona wired with swappable model.
- **4 — Chat imports.** ChatGPT / Gemini / Claude exports → markdown vault.
- **5+ — Portfolio editor, GitHub/code-agent orchestrator, code sandbox, agent runner, socials/web-research.**
- **D — Design polish** once external design context is imported.

## Discipline (from v1 BUILD_RULES)

- Feature Spec Cards ≤90 min; ≤7 files changed; ≤300 LOC per file.
- Revert > wrestle. Two failed attempts → revert, halve scope.
- No code without a spec.
- Learning log after each card.

## Flavor carried from v1 (content, not Flutter code)

- 8 personas + Kobayashi Maru → prompt bundles (`paths-main/lifeline_os/lib/core/constants/experts.dart`, `paths-main/ai/prompts/`).
- MGTST data model — Milestone → Goal → Task → Subtask + MustWin + Energy enum + point roll-up (`paths-main/lifeline_os/lib/core/models/`).
- Canvas timeline (`paths-main/lifeline_os/CANVAS_TIMELINE_IMPLEMENTATION.md`).
- 3-column live markdown editor (`paths-main/lifeline_os/PROJECT_PLANNER_COMPLETE.md`).
- Notes / Journal / Ideas split for capture.
