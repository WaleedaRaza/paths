# Parallel task strikes — paths v2

**Deep UI wireframe + categorized subagent tasks (LOD, edges, filters, collab):** [`NOTES_UI_DEEP_WIRE_AND_AGENT_TASKS.md`](./NOTES_UI_DEEP_WIRE_AND_AGENT_TASKS.md)

**Strike M1 (full mock canvas — clusters, mock LLMs, import, links):** [`STRIKE_M1_NOTES_MOCK_UI.md`](./STRIKE_M1_NOTES_MOCK_UI.md)

**Purpose:** Small, independently ownable units with clear acceptance so two (or more) agents can work in parallel without stepping on each other. Finish one strike before claiming the next in that lane.

**Rules of engagement**

- One strike = one PR-sized chunk (ideally ≤90 min, ≤7 files, keep files readable).
- If a strike blocks another, it is marked **deps:** — do not start the dependent strike until deps are merged or stubbed.
- Do not edit the product plan file in `.cursor/plans/`; this doc is the operational queue.

---

## Lane A — Shell & routing (Agent A)

| ID | Strike | Acceptance |
|----|--------|------------|
| A1 | **Hide Graph nav** until canvas ships: remove `graph` from [`app/src/layouts/app-shell.tsx`](../app/src/layouts/app-shell.tsx); migrate stale `localStorage` key `paths:nav:active` if value was `graph` → `notes`. | Sidebar has no Graph; reload safe. |
| A2 | **Nav event for cross-tenant focus:** `window` event e.g. `paths:activate-notes` with `detail.focusId` optional; `AppShell` listens and switches tab + passes `focusId` into Notes only. | Tasks (or any page) can fire event; Notes receives focus id once. |
| A3 | **Optional:** add `react-router-dom` with `?focus=` on `/` *or* document that focus uses sessionStorage + event only (pick one in strike notes). | Document choice in README one line. |

**Deps:** none for A1; A2 before Tasks “link to canvas” UX.

---

## Lane B — Design tokens (Agent B)

| ID | Strike | Acceptance |
|----|--------|------------|
| B1 | **White/black minimal theme** in [`app/src/index.css`](../app/src/index.css): neutral background/foreground, subtle border, **no** purple sidebar primary in dark; single accent for focus rings only. | `npm run dev` + Tauri both look consistent. |
| B2 | **Tag chip palette** — export 6–8 hex presets as `TAG_PRESETS` in a tiny `lib/tag-presets.ts` for canvas use. | Importable from Notes without touching global theme. |

**Deps:** none.

---

## Lane C — Scene model & persistence (Agent C)

| ID | Strike | Acceptance |
|----|--------|------------|
| C1 | **`scene-schema.ts`:** types for `CanvasScene`, node kinds (`noteCard`, `chatCard`, `importCard`, `imageCard`, `cluster`), `links[]`, `tags[]`. | Pure TS, no React. |
| C2 | **`useCanvasScene` hook:** `localStorage` key `paths:canvas:scene:v1`, debounced save, `loadFixture()`, `resetDemo()`. | Reload restores scene; reset loads fixture. |
| C3 | **Fixture data** in `lib/canvas-fixture.ts` — 2–3 cards + one cluster for demos. | Used by reset. |

**Deps:** C1 → C2 → C3 (or C3 parallel once C1 stable).

---

## Lane D — Notes canvas UI (Agent D)

| ID | Strike | Acceptance |
|----|--------|------------|
| D1 | **Pan/zoom layer:** one `relative overflow-hidden` viewport; inner world `transform: translate + scale`; wheel zoom, middle-mouse or space+drag pan (pick one pattern, document in strike). | Smooth enough for demo. |
| D2 | **Draggable cards** bound to scene nodes; update `x,y` on drag end. | Positions persist via C2. |
| D3 | **Toolbar:** + Note, + Chat, Group selection → `cluster`, Import `.md` (file input + optional Tauri dialog later). | Creates correct node kinds in scene. |
| D4 | **Tag editor** on selected card + **filter strip** (hide non-matching). | Tags from B2 presets + custom hex optional. |
| D5 | **Cluster inspector panel:** list member cards; persona multi-select from static `PERSONAS` (Lane E). | No LLM. |
| D6 | **Mock “Round”** in inspector when ≥2 personas: fake user line + staggered fake assistant bubbles per persona (timeouts only). | Scrollable transcript area. |

**Deps:** C1–C2 before D2; B2 before D4; E1 before D5–D6 (or stub persona ids).

---

## Lane E — Personas static data (Agent E)

| ID | Strike | Acceptance |
|----|--------|------------|
| E1 | **`data/personas.ts`:** 9 entries from v1 [`lifeline_os/lib/core/constants/experts.dart`](../../lifeline_os/lib/core/constants/experts.dart) — `id`, `name`, `description`, `systemPrompt` (trim if huge for UI list), `peerIds` or `relatedNote` string for “know each other” copy. | Typed export `PERSONAS`. |
| E2 | **Agent Runner page:** read-only list + expand for prompt preview. | No backend. |

**Deps:** none (E2 can follow E1 same agent).

---

## Lane F — Tasks parallax shell (Agent F)

| ID | Strike | Acceptance |
|----|--------|------------|
| F1 | Replace [`app/src/pages/tasks.tsx`](../app/src/pages/tasks.tsx) placeholder with **one long page**: sticky section headers Milestone → Goal → Task → MustWin; mock arrays; subtle parallax or sticky stack (CSS only). | Reads as one continuous surface. |
| F2 | Each mock task row has **“Open on canvas”** → `sessionStorage` focus id + dispatch Lane A2 event (or router `?focus=` if A3 chose router). | Switches to Notes; Notes highlights or creates stub card if time allows (optional follow-up). |

**Deps:** A2 before F2.

---

## Lane G — Tauri / Slice 0 (Agent G)

| ID | Strike | Acceptance |
|----|--------|------------|
| G1 | **Keychain:** `keyring_set|get|delete` commands + `build.rs` `AppManifest::commands` + capabilities `allow-keyring-*` (hyphenated ids). | `cargo build` green; invoke from TS works in dev. |
| G2 | **Setup page:** wire Anthropic/OpenAI/Google inputs to invoke when `isTauri`; mask display; never store in plugin-store. | Keys only in OS store. |
| G3 | **SQLite:** `tauri-plugin-sql` preload `sqlite:paths.db` + migration `app_meta(key,value)`. | DB file created on first run; README line: path = app data dir. |

**Deps:** G1 before G2; G3 can parallel G1 after sql plugin already in tree.

---

## Suggested split for two agents

| Agent 1 | Agent 2 |
|---------|---------|
| A1, A2, D1–D4, C1–C2 | B1–B2, E1–E2, F1–F2 |
| Then D5–D6 after E1 | G1–G3 when frontend contract stable |

**Merge order:** A1 → C1 → C2 → D1… then F2 after A2. G-lane can merge anytime build is green.

---

## Doc hygiene (either agent, 5 min)

- Keep [`sprint-canvas-mocks.md`](./sprint-canvas-mocks.md) aligned: add one line under **Future bridge** when cluster→markdown decision is made.
- [`README.md`](../README.md): Graph hidden note + `sqlite:paths.db` location after G3.

---

## Explicit non-goals (all lanes)

- Real Ollama / cloud streaming
- Vault markdown writes
- MCP / agents / skills
- Restoring **Graph** in nav until canvas MVP is done
