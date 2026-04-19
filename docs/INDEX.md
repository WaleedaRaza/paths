# Paths / Lifeline OS v2 — Complete Documentation Index

**Project:** Paths (formerly Lifeline OS)  
**Version:** 2.0 (Clean Rebuild)  
**Stack:** Tauri + React + TypeScript + Zustand + SQLite (SQLCipher)  
**Theme:** Dark mode with Orange/Teal accents  
**Status:** Planning Complete → Ready to Build

---

## 📚 Documentation Structure

### 1. Foundation
- **`00_MGTST_MODEL.md`** — The core hierarchy: Milestone → Goal → Task → Subtask
  - Reward cascade (+1, +5, +25, +100 points)
  - 6 life categories (School, Projects, Health, Finance, DSA, Career, Agnostic)
  - Subtask kinds (7 types: code_planning, research, writing, etc.)
  - Roll-up logic (how points flow up)
  - Energy matching (high/med/low)
  - Success metrics & anti-patterns

### 2. Feature Specifications (Pages)

All features include:
- User stories
- Complete UI layouts (ASCII mockups)
- State management (Zustand slices)
- Database queries
- Logic functions
- Interactions & edge cases
- Acceptance tests
- File targets

#### Core Pages
- **`01_TODAY_PAGE.md`** — Daily cockpit
  - Must-Wins (3 enforced)
  - Hour-by-hour timeline with drag-drop
  - Task pool (energy/time filtered)
  - Quick add (+ AI auto-fill)
  - Workout log
  - Timer integration

- **`02_TASKS_PAGE.md`** — Deep task management
  - List/Kanban/Calendar views
  - Task modal (subtasks, split, points roll-up)
  - AI task splitting
  - Bulk operations
  - Search & filters

- **`03_GOALS_PAGE.md`** — Hierarchical goal management
  - Tree view (Milestone → Goals → Tasks)
  - Goal modal (attach tasks, progress tracking)
  - Goal templates (WGU Course, Project Launch, Fitness)
  - Reordering

- **`04_MILESTONES_PAGE.md`** — Big rock tracking
  - Card grid with progress bars
  - Velocity tracking (on pace / behind)
  - Completion celebration (confetti)
  - Monthly progress breakdown

- **`05_PROJECT_PLANNER.md`** — Spec doc generator
  - Core idea → AI-generated plan
  - Sections: Project Info, Research, Tech Architecture, Features
  - Field editor (Expand/Replace/Refine/Query)
  - Export Markdown + JSON
  - Feature Cards → Tasks bridge

- **`06_REFLECTIONS_PAGE.md`** — AI chat + journaling
  - 8 AI personas (Founder-Engineer, Therapist, Planner, etc.)
  - Chat history & context
  - Journal entries (taggable)
  - Notes (quick capture)
  - Entity tagging (link to tasks/goals/milestones)

- **`07_SETTINGS_PAGE.md`** — Configuration & data management
  - AI config (model, endpoint, temperature)
  - Category management (CRUD + colors)
  - Backups & restore
  - Theme customization
  - Keyboard shortcuts

### 3. Technical Architecture

- **`DATABASE_SCHEMA.md`** — Complete SQL schema
  - 20+ tables (MGTST, scheduling, planner, reflections, settings)
  - All foreign keys, indexes, constraints
  - Migration strategy (Drizzle Kit)
  - Sample queries
  - Backup/restore logic

- **`UI_DESIGN_SYSTEM.md`** — Sleek dark theme
  - Orange/Teal color palette
  - Typography (Inter font stack)
  - Component library (Button, Card, Input, Modal, etc.)
  - Animations (confetti, progress bars, toasts)
  - Layout patterns (app shell, grids)
  - Accessibility (WCAG AAA)

---

## 🎯 Key Principles

### ADHD Optimization
1. **Immediate feedback:** <500ms for all actions
2. **Max 3 choices:** Reduce decision fatigue
3. **Energy matching:** Show right tasks at right time
4. **Visual progress:** Points/bars/streaks everywhere
5. **Atomic tasks:** Force breakdown into <30min chunks

### Anti-Slop Rules
1. **Revert > Patch:** 2 failed attempts → revert to clean commit
2. **Hard caps:** ≤7 files, ≤3 new, ≤300 LOC/file per PR
3. **Evidence required:** Screenshot/log/test output for every PR
4. **One task at a time:** Never blend features
5. **Roll-up instantly:** Points update <500ms

### Data Architecture
1. **Encapsulation:** Each feature = contracts/logic/ui folder
2. **No cross-imports:** Features only import `shared/*`, `state/*`, `ai/*`, `infra/*`
3. **IO adapters:** Only state slices talk to DB/LLM/IPC
4. **Pure logic:** All business logic is testable pure functions
5. **Cached progress:** `progress_points` cached in Goals/Milestones

---

## 🚀 Build Order (Recommended)

### Phase 1: Foundation (Day 1)
1. Database schema + migrations
2. Zustand slices (empty shells)
3. UI theme + design system
4. App shell + routing

### Phase 2: Core MGTST (Days 2-3)
1. Categories CRUD
2. Tasks page (List view + modal + subtasks)
3. Goals page (tree + modal + attach tasks)
4. Milestones page (cards + progress)
5. **Verify roll-ups work**

### Phase 3: Today Page (Day 4)
1. Timeline with drag-drop
2. Task pool with filters
3. Must-Wins enforcement
4. Timer integration
5. Quick add

### Phase 4: Advanced Features (Days 5-6)
1. Project Planner (AI-generated docs)
2. Reflections (8 personas + chat)
3. Settings (backups, theme, categories)

### Phase 5: Polish (Day 7)
1. Animations (confetti, progress bars)
2. Keyboard shortcuts
3. Error handling
4. Acceptance tests

---

## 📊 Success Criteria

### MVP (Phase 3 Complete)
- ✅ Create milestone → goal → task → subtasks
- ✅ Complete subtask → see +1 point → goal progress increases
- ✅ Schedule 3 must-wins → drag to timeline → start timer → complete
- ✅ All data persists across restarts
- ✅ Points roll up correctly (ST → T → G → M)

### Production-Ready (Phase 5 Complete)
- ✅ All 7 pages functional
- ✅ Planner generates docs → exports → creates tasks
- ✅ 8 AI personas respond (local Ollama)
- ✅ Backups create/restore successfully
- ✅ Theme applies orange/teal consistently
- ✅ No console errors
- ✅ Velocity tracking shows "on pace" status

---

## 🎨 Visual Design

**App Feel:** Sleek, dark, modern (think Linear/Superhuman)  
**Primary Accent:** Orange (#ff6b35) — Action, energy, warmth  
**Secondary Accent:** Teal (#00bfa5) — Progress, calm, focus  
**Typography:** Inter (clean, readable, professional)  
**Animations:** Smooth, subtle, purposeful (no jank)

**Key Screens:**
- **Today Page:** Left timeline + right task pool (60/40 split)
- **Tasks Page:** 3-column layout (filters, list, details)
- **Goals Page:** Tree structure with collapsible milestones
- **Milestones Page:** Card grid with progress bars
- **Planner Page:** Split view (editor left, preview right)
- **Reflections Page:** 3-column (personas, chat, notes)

---

## 🔐 Security & Performance

### Security
- SQLCipher encryption (256-bit AES)
- Key in OS Keychain (Tauri plugin)
- IPC allowlist only (no eval, no remote scripts)
- CSP: `default-src 'self'`
- Daily backups (auto at 3am)

### Performance
- Cold start: <2s
- Route change: <300ms
- Roll-up recompute: <100ms
- AI response: <5s (local Ollama)
- Memory: <200MB baseline
- Virtualize lists >200 items

---

## 🗂️ File Structure Overview

```
pathway/
├── docs/
│   ├── INDEX.md (this file)
│   ├── features/
│   │   ├── 00_MGTST_MODEL.md
│   │   ├── 01_TODAY_PAGE.md
│   │   ├── 02_TASKS_PAGE.md
│   │   ├── 03_GOALS_PAGE.md
│   │   ├── 04_MILESTONES_PAGE.md
│   │   ├── 05_PROJECT_PLANNER.md
│   │   ├── 06_REFLECTIONS_PAGE.md
│   │   └── 07_SETTINGS_PAGE.md
│   └── technical/
│       ├── DATABASE_SCHEMA.md
│       └── UI_DESIGN_SYSTEM.md
├── src/
│   ├── app/                 # Routes, shells
│   ├── features/            # Self-contained feature modules
│   │   ├── today/
│   │   ├── tasks/
│   │   ├── goals/
│   │   ├── milestones/
│   │   ├── planner/
│   │   ├── reflections/
│   │   └── settings/
│   ├── state/               # Zustand slices
│   ├── ai/                  # LLM service + personas
│   ├── shared/              # UI components, utils
│   │   ├── ui/
│   │   ├── lib/
│   │   └── contracts/
│   ├── infra/               # DB, IPC, env
│   │   └── db/
│   │       └── migrations/
│   └── main.tsx
├── src-tauri/               # Tauri (Rust backend)
├── BUILD_RULES.md           # Anti-slop guardrails
├── PLAN.md                  # Status board
├── ROADMAP.md               # 8 phases, 44 hours
├── WORKFLOW_CHEATSHEET.md   # One-page reference
├── START_HERE.md            # Launch pad
└── README.md                # Overview
```

---

## 🎯 How to Use This Documentation

### For Planning
1. Read `00_MGTST_MODEL.md` first — understand the foundation
2. Read feature docs in order (01-07) — see complete picture
3. Reference `DATABASE_SCHEMA.md` — understand data relationships

### For Building
1. Start with `BUILD_RULES.md` — anti-slop guardrails
2. Follow `ROADMAP.md` — build in phases
3. Use feature docs as specs — paste into Cursor with `EXECUTOR_RUN_HEADER.md`
4. Reference `UI_DESIGN_SYSTEM.md` — style consistently

### For Debugging
1. Check `DATABASE_SCHEMA.md` — verify queries
2. Check feature doc "Edge Cases" — known issues
3. Follow "Debugging Protocol" in `BUILD_RULES.md` — revert > patch

---

## 🚨 Critical Reminders

### Never Do This
❌ Work on multiple features at once  
❌ Guess data structures (always check schema)  
❌ Skip acceptance tests  
❌ Patch endlessly (max 2 attempts)  
❌ Create duplicate components (check `shared/ui/` first)

### Always Do This
✅ Read feature doc completely before coding  
✅ Verify roll-ups after any MGTST change  
✅ Test with realistic data (10+ tasks, 3+ goals)  
✅ Update `PLAN.md` after each card  
✅ Commit when working ("feat: X works")

---

## 📞 Quick Reference

| Need | Doc |
|------|-----|
| Understand MGTST hierarchy | `00_MGTST_MODEL.md` |
| Build Today page | `01_TODAY_PAGE.md` |
| Build Tasks page | `02_TASKS_PAGE.md` |
| SQL queries | `DATABASE_SCHEMA.md` |
| Component styles | `UI_DESIGN_SYSTEM.md` |
| State management | Feature docs → "State Management" section |
| Anti-slop rules | `BUILD_RULES.md` |
| Build order | `ROADMAP.md` |

---

## 🎉 Ready to Build

You have:
- ✅ **8 feature docs** (complete specs with UX/logic/data)
- ✅ **Complete database schema** (SQL + indexes + migrations)
- ✅ **UI design system** (colors, components, animations)
- ✅ **Anti-slop guardrails** (BUILD_RULES, ROADMAP, WORKFLOW_CHEATSHEET)
- ✅ **Clear build order** (7 days, 44 hours)

**Next step:** Review all docs → give artifact code (if you have old code to salvage) → start building with Phase 1 (Foundation).

**Let's ship this.**

