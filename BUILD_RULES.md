# BUILD_RULES.md — Paths / Lifeline OS v2

**Purpose:** Eliminate "AI slop," enforce clean, scalable architecture, and keep development fast, local-first, and ADHD-friendly.

**Audience:** You + Cursor (Executor). Treat this as the constitution. No work happens outside these rules.

---

## 0) Non-Negotiables (read before every run)

1. **No code without a spec.** Every change traces to a Feature Spec Card (≤90 min scope).
2. **Hard caps:** ≤ 7 files changed, ≤ 3 new files, ≤ 300 LOC per file. If exceeded → STOP and split.
3. **Architecture edges:** `ui → state (slices) → logic (pure) → contracts (DTO/Zod)`; only state talks to IO (DB/IPC/LLM).
4. **Revert > wrestle.** Two failed attempts → revert to last green commit and halve the scope.
5. **Evidence or it didn't happen.** Each PR includes "What runs?", screenshots/logs, and a 1-line learning.

---

## 1) Target Platform & Stack (extendable, not brittle)

**Primary:** Desktop (Tauri) + React/TypeScript + Zustand + SQLite (SQLCipher)  
**Alt (future):** Web/PWA + IndexedDB/OPFS (same folder + contracts; adapters hide differences)

### Exit strategies baked in:
- **DB:** SQLite → server DB later via DAO adapters (no SQL in UI/logic)
- **Migrations:** Drizzle Kit (preferred) or Prisma Migrate — **pick one now, never hand-edit .sql**
- **LLM:** local Ollama → remote models via `ai/service.ts` strategy switch
- **State:** Zustand → alternative store later (UI reads via hooks that select slices)
- **Styling:** Tailwind now → design-system tokens later

---

## 2) Folder Layout (canonical)

```
src/
  app/            # shells + routes (thin)
  features/
    today/        # ui/ logic/ contracts/
    tasks/
    goals/
    milestones/
    planner/
    reflections/
    analytics/
  state/          # Zustand store + slices (no IO here)
    store.ts
    slices/
  ai/
    experts/      # persona data only
    prompts/      # .md prompt files (system/category/field/debugger)
    service.ts    # single orchestrator (all LLM calls)
  shared/
    ui/           # generic components (cards, modals, buttons)
    lib/          # utils (date, id, logger, guards)
    telemetry/    # error/perf wrappers (local by default)
  infra/
    db/           # sqlite init, migrations, backup/restore
    env.ts        # config loader/validator
```

**Forbidden:** Cross-feature imports. Only `shared/*`, `state/*`, `ai/service.ts`, `infra/*` are global.

**Enforcement:** ESLint with `eslint-plugin-import` or `@nx/enforce-module-boundaries`:
```js
// .eslintrc - import rules
"import/no-restricted-paths": ["error", {
  "zones": [
    { "target": "./src/features/*", "from": "./src/features/*", "except": ["./shared", "./state", "./ai/service.ts", "./infra"] }
  ]
}]
```

---

## 3) Data & Contracts (design once, evolve safely)

### Entities (DTO + Zod in `contracts/`; DB schema mirrors DTO):

**Core:**
- `Category` {id, name, color, kind: "school"|"projects"|"health"|"finance"|"ds"|"career"|"agnostic"}
- `Milestone` {id, title, categoryId, targetPoints, progressPoints, due?, status, notes?}
- `Goal` {id, milestoneId, title, order, pointsTarget?, status, notes?}
- `Task` {id, goalId?, title, status, estimateMins, energy, due?, points, priority?, labels[], createdAt, updatedAt, deletedAt?}
- `Subtask` {id, taskId, kind: "code_planning"|"research"|"writing"|"snippet"|"testing"|"debugging"|"generic", title, done, points?}
- `Log` {id, taskId?, subtaskId?, type: "work"|"workout"|"reflection", startedAt, endedAt, notes}
- `PlannerDoc` {id, name, markdown, jsonCapsule, sectionsIncluded[], createdAt, updatedAt}
- `MustWin` {id, taskId, dayISO}

### Rules:
1. **Foreign keys one level deep:** `Subtask→Task`, `Task→Goal`, `Goal→Milestone`
2. **Roll-ups are computed** (cache in Zustand derived selectors; don't store in DB):
   - **Invalidate on:** `subtask.done` toggle, `task.status` change, task deleted
   - **Recompute:** `Subtask points → Task points`, `Task points → Goal points`, `Goal points → Milestone points`
3. **Soft delete:** `deletedAt` on all major tables (Task, Goal, Milestone, PlannerDoc)
4. **Audit:** `createdAt`, `updatedAt`, `source` ("manual", "planner", "import")
5. **Versioning:** Add `version` to DTOs; write mappers when changing shapes
6. **Zod everywhere:** Parse/validate on IO boundaries (IPC/DB/LLM results)

### Migrations:
- **Tool:** Drizzle Kit (`drizzle-kit generate` → inspect → `drizzle-kit migrate`)
- **One migration per PR max**
- **Always backup before/after**; restore tested

---

## 4) Security Baseline (Desktop)

1. **IPC allowlist only.** Expose a tiny set of typed commands; reject unknowns.
2. **CSP locked:** `default-src 'self'` (no remote scripts/fonts).
3. **No file:// drag-drop** into the webview; disable unnecessary browser APIs.
4. **Encrypted at rest:** SQLCipher or encrypted OS directory. Key via OS Keychain (Tauri plugin).
5. **Secrets:** Model paths/keys stored in Keychain; **never in source or .env checked into repo**.
6. **Backups:** 
   - **Auto-backup:** Daily at 3am (configurable); manual via Settings; **pre-migration always**.
   - Timestamped DB snapshots to a user-chosen folder; one-click restore.
7. **Threat micro-model per feature:** Entry points, trust levels, mitigations (2–3 bullets in PR).

---

## 5) Telemetry & Logging (local-first, useful)

- **Logger:** `shared/lib/logger.ts` with levels; **no `console.*` in production builds**.
- **Events (minimal):** `task_completed`, `subtask_completed`, `mustwin_set`, `milestone_completed`, `planner_exported`.
- **Perf marks:** Page load start/end, heavy list renders, LLM round trips.
- **Default sink:** Local console/file; cloud sinks **off by default**.

---

## 6) Performance Budgets

- **Cold start:** < 1.5s
- **Route change:** < 300ms (median local)
- **Lists > 200 items:** Must be virtualized (e.g., `react-window`, `react-virtual`)
- **LLM calls:** 
  - Timeout default: 20s
  - Show user-level **Cancel button** after 2s
  - Wrapped in `AbortController`

---

## 7) Accessibility & Interaction

- **Keyboard first:**
  - Create Task: `N`
  - Add Subtask: `S`
  - Complete: `Cmd/Ctrl+Enter`
  - Quick Add: `Q`
- **Focus traps** in modals; `ESC` closes; `Return` submits
- **High-contrast theme** option; system theme sync

---

## 8) Coding Standards

- **TypeScript strict** (`noImplicitAny`, `exactOptionalPropertyTypes`, etc.)
- **File naming:** `PascalCase.tsx` (components), `kebab-case.ts` (utils)
- **No business logic in components** (components are dumb: props in, callbacks out)
- **Pure functions in `logic/`**; unit test them
- **Avoid class OO**; favor composition + small modules (your "objects" = feature folders + contracts)

---

## 9) Feature Spec Card (the only way work starts)

Paste this before any code request; Cursor must echo it back first.

```markdown
### Feature Spec Card (≤90 min)

**Title:**

**Goal (1 sentence):**

**User flow (happy path):** [step-by-step in 3–6 lines]

**Contracts touched/created:** [DTO/Zod names + brief change]

**Files to touch (≤7):** 
1. `path/file1.ts` - [intent]
2. `path/file2.tsx` - [intent]
...

**New files (≤3):**
1. `path/newFile.ts` - [purpose]
...

**Acceptance checks:** [observable outcomes: tests or manual steps]

**Risks & unknowns:** [2–3 bullets]

**Rollback plan:** [how to revert cleanly]

**Evidence to collect:** [screenshot/log/CLI output]
```

**Refuse to proceed if any field is missing.**

---

## 10) Cursor Run Protocol (anti-slop)

### A) Global Executor Header (prepend to every run)

```
You must follow BUILD_RULES.md. Implement only the provided Feature Spec Card. 
Respect caps: ≤ 7 files, ≤ 3 new, ≤ 300 LOC/file. 
Work only inside the target feature folder(s). 
List the files you will modify BEFORE editing. 
If info is missing or caps will be exceeded, STOP and propose a smaller split. 
All code must flow: ui → state → logic → contracts; IO only in state adapters. 
End with: (1) files changed, (2) why each change exists, (3) evidence of the acceptance checks.
```

### B) Drift Enforcement (you paste if it goes off rails)

```
You changed files outside the declared list or exceeded caps. 
Revert to last green. Propose a split card with a new file list.
```

---

## 11) Branching, Commits, PRs

- **Branches:** `feat/<name>`, `fix/<name>`, `chore/<name>`
- **Commits:** `type(scope): summary` (feat/fix/chore/docs/refactor/test)
- **One Feature Spec Card per PR.** No drive-by edits.
- **PR template auto-includes:** Spec Card, changed files list, evidence, 1-line learning

### CI gates (hard):
- [ ] Typecheck
- [ ] Unit tests (logic)
- [ ] Contract tests (Zod/IPC)
- [ ] 1 happy-path integration test
- [ ] File budget check
- [ ] Lint + import-boundaries

---

## 12) Planner → Tasks Bridge (how ideas become work)

1. Planner exports a Markdown + JSON doc
2. "Create Feature Cards" produces ≤90 min cards
3. Cards convert to **Tasks** (1–3 each) under a selected Goal/Milestone
4. Tasks carry origin: `{ plannerDocId, cardId }` for traceability

---

## 13) Today / Motivation Mechanics (baked into rules)

- **Must-Wins (3)** required each day; recommender is advisory, user override wins (**Autonomy**)
- **Energy + estimate filters** drive Task Pool (**Competence**: right task, right time)
- **Point roll-ups visible:** Subtask → Task → Goal → Milestone; small celebratory UI on completion
- **Weekly insight card** auto-generated (local) with "next best action"

---

## 14) Sandbox Protocol (safe experiments)

- **Branch:** `sandbox/<topic>` or folder `sandboxes/<topic>/` (no app imports)
- **Spike ticket contains:** Question, Hypothesis, Success signal, Artifact (gif/log/benchmark)
- **Adopt/Discard in 48h**; if not adopted → delete sandbox branch/folder

---

## 15) Salvage Protocol (reuse without dragging sludge)

- **"Salvage scan" task** lists candidate files (name + why safe to port)
- **Port only if:** Single responsibility, ≤300 LOC, no hidden globals, tests possible
- **If ported:** Wrap behind a contract and add a unit test immediately
- **Archive everything else**; do not "temporarily" keep duplicates

---

## 16) Adding a New Screen/Feature (the recipe)

1. Write the **contracts first** (Zod + DTO)
2. Write **unit tests** for pure logic functions
3. Add a **slice** with IO adapters (DB/IPC/LLM as needed)
4. Build **UI** that only calls slice methods/selectors
5. Add **one happy-path integration test**
6. Wire **events + perf marks** minimally

---

## 17) LLM Usage Rules (`ai/service.ts`)

- **One orchestrator** (`ai/service.ts`) with strategy for local Ollama or remote
- **Personas** live in `ai/experts` as data (no prompt logic elsewhere)
- **Timeouts & retries** with circuit breaker; show cancel to user
- **No LLM calls from UI components**; only via `state → service`
- **Planner/Editor prompts** live in `ai/prompts/*.md`; version them

---

## 18) Acceptance Evidence (PRs must include)

- [ ] Screenshot or short gif of the user flow(s)
- [ ] Console/log snippet showing events/roll-ups/DB rows
- [ ] Test output (spec names) for unit/contract/integration
- [ ] If security-relevant: IPC list diff, CSP confirmation, backup/restore log

---

## 19) Recovery Protocol (when things go red)

1. **Two red runs** on the same card → revert branch to last green commit
2. **Cut scope to half**; update file list; rerun
3. **If still red:** Create a Debug Card (rank 3 causes; one 5-min diagnostic each; revert plan)

---

## 20) Documentation & ADRs (lightweight, consistent)

- **Evidence:** `/docs/evidence/<date>-<feature>.md` per merged PR (auto-linked in PR)
- **ADRs:** `/docs/adr/ADR-YYYYMMDD-<topic>.md` for nontrivial choices (LLM switch, DB change)
  - 1 page max: Context → Decision → Consequences → Rollback

---

## 21) Release & Backups

- **Version bump** only when DB schema or public contracts change
- **Pre-release checklist:**
  - [ ] Run migrations on a copy
  - [ ] E2E happy path
  - [ ] Backup created
- **Maintain last 5 backups**; verify restore quarterly (scripted)

---

## 22) "Go/No-Go" Checklist (pre-merge)

- [ ] Spec Card complete and respected
- [ ] Caps respected (files/new/LOC)
- [ ] Typecheck + tests + CI gates pass
- [ ] Evidence attached
- [ ] Security & perf notes (if applicable)
- [ ] No cross-feature imports
- [ ] Migration/backups (if applicable) validated

---

## 23) Quick Prompts (ready to paste in Cursor)

### A) Global Executor

```
Follow BUILD_RULES.md. Implement only the provided Feature Spec Card. 
Caps: ≤7 files, ≤3 new, ≤300 LOC/file. 
Work only inside the declared feature folders. 
List target files before editing; if info is missing or caps will be exceeded, STOP and propose a smaller split. 
Route code via ui → state → logic → contracts; IO only in state adapters. 
End with changed files, rationale, and evidence of acceptance checks.
```

### B) Salvage Scan

```
Scan the repo and list specific files safe to port (name, path, why safe, suggested destination). 
Exclude duplicates/legacy. Do not modify anything yet.
```

### C) Sandbox Spike

```
Create a sandbox plan for <topic>. 
Provide question, hypothesis, success signal, artifact, and 48h adopt/discard rule. 
No app imports.
```

### D) Debug Card

```
Read logs/diff. Rank top 3 root causes. 
Provide one 5-minute diagnostic each and a revert plan. 
No refactors.
```

---

## 24) What This Buys Us

✅ **Composable "objects":** Each feature is self-contained (contracts/logic/ui)  
✅ **Scalability:** Add screens, wire LLM, change DB without ripples  
✅ **Security:** Tight IPC, encrypted DB, backups, CSP  
✅ **Momentum:** Small cards, hard caps, instant evidence  
✅ **No reboots:** Extensible bones so we don't "start over" later  

---

## 25) Final Reminder

If anything here feels ambiguous, **write a 1-page ADR and move on.** Otherwise, this is ground truth.

**Pin this in Cursor.** Do not proceed without it.

