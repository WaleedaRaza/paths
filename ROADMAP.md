# Paths / Lifeline OS v2 — Build Roadmap

**Target:** Clean, scalable, ADHD-friendly productivity system with Planner integration.

**Timeline:** 7–10 focused days (assumes 4–6 hour focused blocks per day).

**Key Principle:** Ship working features daily. Evidence over claims.

---

## Phase 0: Setup & Skeleton (Day 1 — 4–6 hours)

**Goal:** Get the bones in place so Executor can work without friction.

### Cards (≤90 min each):

#### 0.1: Project Scaffold + DB Init (90m)
- Create folder structure (`features/`, `state/`, `ai/`, `shared/`, `infra/`)
- Install deps: Tauri, React, TS, Zustand, Drizzle ORM, SQLCipher, Zod
- Init Drizzle config + SQLite connection
- Create empty feature folders (`today/`, `tasks/`, `goals/`, `milestones/`, `planner/`, `reflections/`)
- **Evidence:** `npm run dev` compiles; Tauri window opens with "Hello World"

#### 0.2: Core Entities + Migrations (90m)
- Define Zod schemas in `shared/contracts/entities.ts`:
  - `Category`, `Milestone`, `Goal`, `Task`, `Subtask`, `Log`, `PlannerDoc`, `MustWin`
- Generate Drizzle migration
- Create seed script with 1 Category, 1 Milestone, 1 Goal, 2 Tasks
- **Evidence:** Seed runs; query returns 2 tasks; DB file encrypted

#### 0.3: Dev Panel + CRUD Smoke Test (60m)
- Add `/dev` route with simple CRUD UI for entities
- Test: Create Task → attach to Goal → attach to Milestone
- **Evidence:** Restart app; data persists; create/read/update/delete works

#### 0.4: Zustand Slices Foundation (90m)
- Create slices: `tasksSlice`, `goalsSlice`, `milestonesSlice`, `todaySlice`, `plannerSlice`
- Wire to DB via `infra/db/dao.ts` adapters
- Add selectors: `selectTasksByStatus`, `selectGoalsByMilestone`, `selectMustWins`
- **Evidence:** Dev panel uses slices; updates reflect immediately

**Phase 0 Done:** ~5 hours | Evidence: CRUD works, data persists, slices wired

---

## Phase 1: Today Page MVP (Day 2 — 6 hours)

**Goal:** Daily cockpit with timeline, task pool, quick add, timer.

### Cards:

#### 1.1: Timeline + Drag-Drop (90m)
- Build `features/today/ui/Timeline.tsx`: hourly slots (6am–12am)
- Drag tasks from pool → timeline slot
- Save schedule to `state/todaySlice`
- **Evidence:** Drag 2 tasks into slots; reload page; tasks remain scheduled

#### 1.2: Task Pool + Filters (90m)
- Build `features/today/ui/TaskPool.tsx`: list unscheduled tasks
- Filter by energy (low/med/high), estimate (<30m, 30–60m, >60m), status
- **Evidence:** Filter to "high energy" + "<30m"; see correct subset

#### 1.3: Quick Add (60m)
- Inline form: title, estimate, energy, goal link (optional), category
- Option: "auto-fill from prompt" (stub for now; no LLM yet)
- **Evidence:** Quick-add a task; appears in pool; links to goal

#### 1.4: Timer + Logs (90m)
- Start/stop timer on scheduled task
- On stop: create `Log` entry with `startedAt`, `endedAt`, `taskId`
- Show timer countdown in UI
- **Evidence:** Start 5-min timer; stop; see Log row in dev panel

#### 1.5: Must-Wins (3) (60m)
- Pinned section at top: "Today's Must-Wins"
- Drag 3 tasks into Must-Wins
- Persist as `MustWin` rows with `dayISO`
- **Evidence:** Set 3 Must-Wins; reload; Must-Wins persist

**Phase 1 Done:** ~6 hours | Evidence: Today page is functional; timer works; schedule persists

---

## Phase 2: Tasks Page + Subtasks (Day 3 — 6 hours)

**Goal:** Full task management with subtasks, modals, points.

### Cards:

#### 2.1: Tasks List View (90m)
- Build `features/tasks/ui/TasksList.tsx`: tile view with status badges
- Show: title, estimate, energy, due, points, goal link
- Click task → open modal
- **Evidence:** List shows 10 tasks; click → modal opens

#### 2.2: Task Modal + Subtasks CRUD (90m)
- Modal: editable fields (title, estimate, energy, due, goal, labels)
- Subtasks section: inline add/edit/delete/check
- **Evidence:** Edit task title; add 3 subtasks; mark 1 done; close/reopen modal; changes persist

#### 2.3: Split Task into Subtasks (Prompt) (90m)
- "Split" button in modal
- Prompt: "Break this task into subtasks" (stub response for now: 3 generic subtasks)
- Insert generated subtasks
- **Evidence:** Click "Split"; see 3 new subtasks appear; edit them

#### 2.4: Points Roll-Up (90m)
- Logic in `features/tasks/logic/roll-up.ts`:
  - Subtask done = +1 point
  - Task done = +5 points (+ subtask points)
  - Task points → Goal progress
  - Goal progress → Milestone progress
- Recompute on: subtask toggle, task status change
- **Evidence:** Complete 3 subtasks (3 pts); complete task (+5 = 8 total); Goal shows +8; Milestone shows +8

#### 2.5: Kanban View (60m)
- Add view toggle: List | Kanban
- Kanban columns: Todo | Doing | Done | Blocked
- Drag tasks between columns → updates status
- **Evidence:** Drag task from "Todo" to "Doing"; status updates; persists

**Phase 2 Done:** ~6 hours | Evidence: Tasks CRUD works; subtasks work; points roll up; Kanban functional

---

## Phase 3: Goals + Milestones (Day 4 — 5 hours)

**Goal:** Hierarchy view with progress tracking.

### Cards:

#### 3.1: Goals Tree View (90m)
- Build `features/goals/ui/GoalsTree.tsx`: collapsible tree
- Structure: Milestone → Goals → task count + progress bar
- Click goal → open modal
- **Evidence:** Expand Milestone; see 3 Goals; progress bars show correct %

#### 3.2: Goal Modal + Task Linking (90m)
- Modal: edit goal title, target points, attach existing tasks
- Dropdown: select tasks to attach/detach
- Reorder tasks via drag
- **Evidence:** Attach 2 tasks to Goal; detach 1; reorder; progress updates

#### 3.3: Milestones Page + Cards (90m)
- Build `features/milestones/ui/MilestonesPage.tsx`: card grid
- Card: title, category color, target vs progress, due, % complete
- Click → modal with goals breakdown
- **Evidence:** Create Milestone; add Goal; attach Task; complete Task; Milestone shows progress

#### 3.4: Milestone Completion + Celebration (60m)
- When `progressPoints >= targetPoints`, lock milestone
- Show celebration modal (confetti, streak update)
- **Evidence:** Complete enough tasks to hit target; see celebration; milestone locked

**Phase 3 Done:** ~5 hours | Evidence: Full MGTST hierarchy works; progress rolls up; completion celebrated

---

## Phase 4: Project Planner MVP (Day 5 — 6 hours)

**Goal:** Generate planning docs, export Markdown, spawn Feature Cards.

### Cards:

#### 4.1: Planner UI Shell (90m)
- Build `features/planner/ui/PlannerPage.tsx`:
  - Top: "Core Idea" textarea
  - "Generate First-Pass Plan" button
  - Sections: Project Info, Research, Division of Labor (collapsible)
- **Evidence:** Type in Core Idea; click Generate; see mock sections appear

#### 4.2: Generate First-Pass Plan (Stub) (90m)
- On "Generate" → create stub `PlannerDoc` with mock sections:
  - Project Info: Name, Stack, Timeline
  - Research: Tech Stack, Risks
  - Division of Labor: Phase 1, Phase 2
- Display in collapsible sections
- **Evidence:** Generate plan; see 3 sections with mock content; persists

#### 4.3: Field Editor (Expand/Replace/Refine/Query) (90m)
- Each field has 4 buttons: Expand | Replace | Refine | Query
- On click → open modal with prompt input
- For now: stub edits (just append " [edited]")
- **Evidence:** Click "Expand" on field; enter prompt; field updates

#### 4.4: Export Markdown + JSON (60m)
- "Export" button → write 2 files:
  - `docs/plans/<date>-<name>.md` (Markdown)
  - `docs/plans/<date>-<name>.json` (JSON capsule)
- **Evidence:** Export plan; files appear in folder; Markdown is readable

#### 4.5: Create Feature Cards → Tasks (90m)
- "Create Feature Cards" button
- Generate 2 stub cards (title, goal, file list, acceptance)
- Convert cards to Tasks under selected Goal
- Tasks carry `{ origin: { plannerDocId, cardId } }`
- **Evidence:** Generate cards; select Goal; create Tasks; see 2 new Tasks with origin metadata

**Phase 4 Done:** ~6 hours | Evidence: Planner generates docs, exports files, spawns Tasks

---

## Phase 5: Reflections + LLM Integration (Day 6 — 5 hours)

**Goal:** Chat with AI personas; save notes; tag to entities.

### Cards:

#### 5.1: LLM Service (Ollama) (90m)
- Build `ai/service.ts`: single function `generate(personaId, message, context?)`
- Integrate Ollama (local): POST to `http://localhost:11434/api/generate`
- Timeout: 20s; cancel via `AbortController`
- **Evidence:** Call `generate("mirror-guide", "Help me plan my day")`; get response in <5s

#### 5.2: Personas Definitions (60m)
- Port 8 personas to `ai/experts/definitions.ts`:
  - Mirror-Guide, Founder-Engineer, Meta-Learner, Fitness-Coach, DSA-Tutor, Calm-Therapist, Social-Strategist, Content-Generator
- Each: `{ id, name, systemPrompt, tone, specialization }`
- **Evidence:** Load persona dropdown; switch; see system prompt change

#### 5.3: Reflections Chat UI (90m)
- Build `features/reflections/ui/ChatPanel.tsx`: message list + input
- Persona switcher at top
- Send message → call `ai/service.ts` → append reply
- **Evidence:** Switch to "Founder-Engineer"; ask question; get reply; chat persists

#### 5.4: Notes + Journaling (60m)
- Add "Journal" tab: simple rich-text editor (or plain textarea)
- Save entries with timestamp
- **Evidence:** Write journal entry; reload; entry persists

#### 5.5: Tag to Entities (60m)
- In chat/journal: "Link to..." dropdown → select Task/Goal/Milestone
- Create `EntityLink` table: `{ noteId, entityType, entityId }`
- **Evidence:** Tag a journal entry to a Task; view Task modal; see linked note

**Phase 5 Done:** ~5 hours | Evidence: Chat works with 8 personas; notes save; tags link to entities

---

## Phase 6: Analytics + Settings (Day 7 — 4 hours)

**Goal:** Progress dashboard, backups, settings.

### Cards:

#### 6.1: Points & Streaks (90m)
- Build `features/analytics/ui/ProgressDashboard.tsx`:
  - Total points, level (points ÷ 100), current streak
  - Graph: points over last 30 days
- Streak logic: done ≥3 tasks/day → +1 streak
- **Evidence:** Complete 3 tasks; streak increments; graph shows spike

#### 6.2: Skill Tags + Insights (60m)
- Add `skillTags` array to Task (e.g., "DSA", "Writing", "Shipping")
- Weekly insight: "You completed 12 DSA tasks this week. Next: X."
- **Evidence:** Tag 5 tasks with "DSA"; view Insights; see recommendation

#### 6.3: Settings Page (60m)
- Tabs: General, LLM, Backups, Categories
- General: theme, keyboard shortcuts
- LLM: model name, context cap, temperature
- Backups: auto-backup toggle, manual backup button, restore
- Categories: add/edit/delete categories + colors
- **Evidence:** Change theme; toggle auto-backup; add new category; changes persist

#### 6.4: Backup + Restore (90m)
- Manual backup: copy DB to `backups/<timestamp>.db`
- Auto-backup: daily at 3am (configurable time)
- Restore: select backup file → overwrite current DB
- **Evidence:** Create backup; delete a task; restore; task is back

**Phase 6 Done:** ~4 hours | Evidence: Analytics dashboard works; backups/restore functional; settings persist

---

## Phase 7: Polish + Hardening (Day 8 — 4 hours)

**Goal:** Security, tests, CI gates, final UX polish.

### Cards:

#### 7.1: Security Hardening (90m)
- Lock IPC allowlist (only commands we use)
- Set CSP: `default-src 'self'`
- Enable SQLCipher encryption
- Store LLM paths in OS Keychain
- **Evidence:** IPC test suite passes; CSP violation logs empty; DB file encrypted

#### 7.2: Happy-Path Integration Tests (90m)
- Write 3 tests:
  - Today flow: drag task → start timer → complete → log created
  - Tasks flow: create task → add subtasks → mark done → points roll up
  - Planner flow: generate doc → export files → create tasks
- **Evidence:** `npm test` runs 3 tests; all pass

#### 7.3: File Budget + Import Boundaries (60m)
- Add ESLint rule: no cross-feature imports
- Add CI check: fail if any file >300 LOC or PR changes >7 files
- **Evidence:** Intentionally violate rule; CI fails

#### 7.4: UX Polish (60m)
- Add keyboard shortcuts (N, S, Q, Cmd+Enter)
- Add loading states for LLM calls (spinner + Cancel button)
- Add error toasts (network fail, DB fail)
- **Evidence:** Press N → Quick Add opens; start LLM call → see spinner + cancel

**Phase 7 Done:** ~4 hours | Evidence: Security locked; tests pass; CI gates enforced; UX polished

---

## Phase 8: Docs + Final Prep (Day 9–10 — 2–4 hours)

**Goal:** User-facing docs, ADRs, release prep.

### Cards:

#### 8.1: User Guide (60m)
- Write `docs/USER_GUIDE.md`:
  - Getting Started (install, first run)
  - Today Page walkthrough
  - Tasks + Subtasks + Points
  - Goals + Milestones
  - Planner (generate → export → spawn tasks)
  - Reflections (chat, journal, tag)
  - Settings (backups, categories)
- **Evidence:** Follow guide as new user; can complete all flows

#### 8.2: ADRs (60m)
- Write 3 ADRs:
  - `ADR-001-Tauri-vs-Electron.md` (why Tauri)
  - `ADR-002-SQLite-vs-IndexedDB.md` (why SQLite)
  - `ADR-003-Zustand-vs-Redux.md` (why Zustand)
- **Evidence:** ADRs in `/docs/adr/`; 1 page each

#### 8.3: Release Checklist (30m)
- Create `RELEASE_CHECKLIST.md`:
  - [ ] Run migrations on copy DB
  - [ ] E2E happy path (Today → Tasks → Goals → Planner → Reflections)
  - [ ] Backup created
  - [ ] Version bumped
  - [ ] Build Tauri app (test install)
- **Evidence:** Follow checklist; app builds; installer works

#### 8.4: Final Smoke Test (60m)
- Fresh install on clean machine
- Seed with realistic data (10 tasks, 3 goals, 2 milestones)
- Run through full day: set Must-Wins, work tasks, log time, reflect, generate plan
- **Evidence:** Everything works; no console errors; data persists across restarts

**Phase 8 Done:** ~3 hours | Evidence: Docs complete; ADRs written; release ready

---

## Timeline Summary

| Phase | Focus | Time | Cumulative |
|---|---|---|---|
| 0 | Setup + Skeleton | 5h | 5h |
| 1 | Today Page MVP | 6h | 11h |
| 2 | Tasks + Subtasks | 6h | 17h |
| 3 | Goals + Milestones | 5h | 22h |
| 4 | Planner MVP | 6h | 28h |
| 5 | Reflections + LLM | 5h | 33h |
| 6 | Analytics + Settings | 4h | 37h |
| 7 | Polish + Hardening | 4h | 41h |
| 8 | Docs + Prep | 3h | 44h |

**Total:** ~44 hours focused work

**Realistic calendar time:**
- **Fast:** 7 days (6 hours/day focused)
- **Normal:** 10 days (4 hours/day focused)
- **Safe:** 14 days (3 hours/day + buffer for unknowns)

---

## Daily Rhythm (Planner ↔ Executor Loop)

### Morning (30 min — Planner mode):
1. Review PLAN.md Status Board
2. Pick 1–2 cards for the day (≤90m each)
3. Verify Feature Spec Cards are complete
4. Ask: "What am I missing to be 100% confident?"

### Work Block 1 (90 min — Executor mode):
1. Implement Card 1
2. Run tests, collect evidence
3. Update PLAN.md with ✅ or ❌

### Work Block 2 (90 min — Executor mode):
1. Implement Card 2
2. Run tests, collect evidence
3. Update PLAN.md

### End of Day (15 min — Planner mode):
1. Review evidence
2. Note any patterns/learnings
3. Queue tomorrow's cards

---

## Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| LLM integration breaks | Medium | High | Stub responses first; wire real LLM in Phase 5 |
| Roll-up logic bugs | Medium | High | Write unit tests in Phase 2; verify with real data |
| Scope creep | High | High | Hard caps enforced; Planner mode guards scope |
| Performance (lists) | Low | Medium | Virtualize lists >200 items in Phase 7 |
| Security gaps | Low | Critical | Hardening in Phase 7; IPC allowlist + CSP locked |
| Backup/restore fails | Low | Critical | Test restore in Phase 6; pre-migration backup |

---

## Success Criteria (what "done" looks like)

### By Phase 4 (MVP):
- [ ] Today page: drag tasks, run timer, log created
- [ ] Tasks: CRUD + subtasks + points roll up
- [ ] Goals/Milestones: hierarchy works; progress tracks
- [ ] Planner: generate doc → export → spawn tasks

### By Phase 8 (Production-ready):
- [ ] All features work end-to-end
- [ ] Security hardened (IPC, CSP, encryption)
- [ ] Tests pass (unit + integration + CI gates)
- [ ] Backups/restore validated
- [ ] Docs complete (USER_GUIDE + ADRs)
- [ ] No console errors; cold start <1.5s
- [ ] Fresh install works; realistic data tested

---

## Next Steps (Right Now)

1. **Pin BUILD_RULES.md** in Cursor workspace
2. **Create PLAN.md** from template (I'll generate this next)
3. **Start Phase 0, Card 0.1** (Project Scaffold)
4. **Switch to Executor mode:** "Be Executor. Implement Card 0.1."

Ready to proceed?

