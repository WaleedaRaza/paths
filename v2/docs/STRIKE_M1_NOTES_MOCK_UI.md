# Strike M1 — Full mocked Notes canvas (COMPLETE)

**Goal:** One working UI pass: **clusters**, **floating nodes**, **mock multi-vendor LLM chat**, **import .md**, **link tool**, **inspector**, **demo scene** — all **local-only** (no API keys, no network).

**Spec parent:** [`NOTES_UI_DEEP_WIRE_AND_AGENT_TASKS.md`](./NOTES_UI_DEEP_WIRE_AND_AGENT_TASKS.md)

---

## Shipped behavior

| Area | Behavior |
|------|----------|
| **Clusters** | `kind: 'cluster'` frames (dashed). Members use `clusterId`. Dragging a cluster **moves members** with the same delta. Inspector: **Autofit frame to members**. Deleting a cluster **orphans** members (`clusterId` cleared). |
| **Nodes** | `note`, `chat`, `import`, `cluster` on canvas with LOD (L3/L2/L1). Chat L1 uses **bubble transcript** when `chatTurns` is set. |
| **Mock LLMs** | `features/notes/mock/mock-llm.ts` — presets (Ollama, OpenAI, Anthropic, Google). Inspector **Model** tab + chat **Send** appends user + canned assistant reply by vendor. |
| **Import** | **Import .md** modal: filename, optional file read, paste body → `import` node with `sourceFileName`. |
| **Links** | **Link** tool: click source, click target → `ref` edge. Esc / background click cancels draft. Edges highlight while linking. Inspector **Links** tab lists neighbors + **Remove**. |
| **Demo** | **Full demo** loads two clusters, mixed nodes, imports, chat with seeded turns, cross-links + floater note. |

---

## Key files (Agent B: start here)

```
v2/app/src/features/notes/
  mock/mock-llm.ts              # MOCK_MODELS + mockAssistantReply
  scene/scene-schema.ts         # ChatTurn, mockModelId, chatTurns, sourceFileName
  scene/demo-scene.ts           # buildDemoScene()
  scene/use-selection.ts
  scene/use-canvas-scene.ts
  canvas/edge-layer.tsx         # linkHighlightFromId
  canvas/scene-node-view.tsx    # cluster + chat bubbles + import chrome
  canvas/notes-scene-layer.tsx  # cluster group drag, link tool, draw order
  canvas/canvas-viewport.tsx
  canvas/use-world-transform.ts
  inspector/inspector-panel.tsx # per-kind tabs, chat composer, links list
  shell/notes-mind-map.tsx      # orchestration, header actions
  shell/import-modal.tsx
  shell/command-palette.tsx
```

---

## HELP ME DO THIS — Agent B (next strikes)

Paste into a **new chat**:

```text
Repo: paths-main/v2/app. Read v2/docs/STRIKE_M1_NOTES_MOCK_UI.md (M1 done).

Pick ONE strike below; touch only related files; run npm run build.

Strike B1 — Link kinds: after second click, small popover (ref / continues / cross_talk / cluster_member). Persist kind on SceneLink.

Strike B2 — Cluster UX: “Wrap selection in new cluster” (bbox + member clusterIds). Resize handles on cluster frame.

Strike B3 — Command palette: real actions (go to node, filter tag, switch tool) wired to scene state.

Strike B4 — Performance: viewport culling for nodes/edges when count > 200 (UI-K1).

Strike B5 — Tauri: open import via dialog plugin; pass file path into import card (still mock content if read fails).

At end, output ### Handoff for Worker C with merge risks and next strike.
```

---

## Explicit non-goals (still)

- Real streaming LLM calls  
- Vault disk sync  
- MCP  

---

*M1 landed: floating interconnected mock workspace with clusters, chats, imports, and links.*
