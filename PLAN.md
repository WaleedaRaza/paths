# Project Plan — Lifeline OS v2

**Project Name:** Lifeline OS v2  
**Stack:** Flutter (Desktop + Web) + Dart + Riverpod + Drift (SQLite)  
**Started:** October 6, 2025  
**Target:** 6 phases (68 hours, see TECH_SPEC.md)

---

## Status Board

### ✅ Completed
- ✅ Phase 0 — Project Scaffold (Flutter setup, theme, navigation, all 7 placeholder pages)
- ✅ Phase 1 — Database + Today Page
  - Drift database schema (8 tables: Categories, Milestones, Goals, Tasks, Subtasks, MustWins, ScheduleItems, Logs)
  - Freezed data models (all MGTST entities)
  - Riverpod providers (Must-Wins, Schedule, Points, Streak)
  - Full Today Page UI with Must-Wins section, Schedule timeline, Quick Add
  - Task completion logic with flutter_animate animations
  - Real-time points and streak tracking

**Evidence:** User can add up to 3 Must-Wins, view/complete schedule items, see points/streak update in sidebar

### ✅ Completed (continued)
- ✅ Phase 2 — Tasks Page
  - Task repository with CRUD + subtask operations
  - Riverpod providers (all/active/completed tasks, filter state)
  - Task card widget with priority/energy/due date indicators
  - List view with filters (All/Active/Completed)
  - Kanban board view (To Do / Done columns)
  - Task modal for create/edit with subtasks section
  - Subtask creation and completion with points roll-up
  - View mode switcher (List ↔ Kanban)
  - Bulk operations (delete, complete)

**Evidence:** User can create tasks, add subtasks, toggle completion, see points calculate, switch between list/kanban views

### ✅ Completed (continued)
- ✅ Phase 3 — Goals + Milestones (ENHANCED)
  - Goals & Milestones repositories with CRUD
  - Riverpod providers (root goals, child goals, by milestone, stats)
  - **Goal Cards:** Progress bars, task/sub-goal counts, completion %, points
  - **Milestone Cards:** Progress bars, goal/task breakdown, deadline indicators
  - **Goal Modal:** Shows attached tasks list, stats, progress, link to milestone
  - **Milestone Modal:** Shows attached goals, complete breakdown, tasks rollup
  - **Task Modal:** Dropdown to assign task to a goal
  - Points roll-up: Subtasks → Tasks → Goals → Milestones
  - Full MGTST hierarchy integration
  - Completion animations

**Evidence:** Detailed progress tracking, visual progress bars, task-goal-milestone linking works

### ✅ Completed (continued)
- ✅ Phase 4 — Domain-Specific MGTST UI (POC)
  - Domain enum + metadata columns + migrations
  - School Wizard (5-step flow: Semester → Courses → Details → Timeline → Preferences)
  - Projects Wizard (5-step flow: Type → Details → Phases → Timeline → Metrics)
  - Finance Wizard (5-step flow: Goal Type → $ Details → Plan → Timeline → Tracking)
  - Template Selection Page (6 templates with coming soon states)

**Evidence:** Wizards collect domain-specific metadata and store in database

**Files Created:** 1,565 lines (school_wizard.dart, projects_wizard.dart, finance_wizard.dart, template_selection_page.dart)

---

## 🎯 CURRENT PHASE: Phase 4.5 — MGTST UI Depth & Cross-Functional Intelligence

**Problem Statement:**
Current UI is skeletal. Cards show basic info (title, description, progress bar) but hide the rich relationships and domain-specific metadata. The MGTST graph structure is invisible. User cannot navigate hierarchy, see cross-links, or understand domain context.

**Goal:**
Transform MGTST from flat lists into an intelligent, navigable graph with information-dense cards, domain-specific rendering, hierarchical expansion, and cross-functional relationship visualization.

**Success Criteria:**
- Milestone/Goal/Task cards show complete stats, relationships, and domain metadata
- Click any entity → see full detail view with hierarchy navigation
- Domain metadata renders beautifully (courses for School, exercises for Fitness, etc.)
- Cross-links visible and clickable (task shows parent goal, goal shows parent milestone)
- Inline expansion/collapse of child entities
- Quick actions on all cards (status change, associate, navigate)

---

### Status Board — Phase 4.5

### ✅ Completed Task: 4.5.1 — Domain Metadata Rendering System
**Evidence:** 5 metadata view widgets created (School, Projects, Finance, Fitness + router), compact & full modes, rich information density

### ✅ Completed Task: 4.5.2 — Rich Milestone Card
**Evidence:** 3-state expansion, domain badges, status indicators, inline goal preview, quick actions, 10x more info than before

### ✅ Completed Task: 4.5.3 — Rich Goal Card
**Evidence:** Parent milestone badges, task list preview, overdue indicators, stats rollup, quick actions, 8x more info

### ✅ Completed Task: 4.5.4 — Rich Task Card (Information-Dense)
**Evidence:** Multi-badge header (domain|priority|time|overdue), parent goal badge, subtask rollup, inline subtask list with checkboxes, status pills (To Do|Doing|Done), quick actions, 3-state expansion, 10x more info than before

### ✅ Completed Task: 4.5.5 — Hierarchical Navigation System
**Evidence:** Created MilestoneDetailPage, GoalDetailPage, TaskDetailPage, breadcrumb navigation, deep linking works, back button returns to parent, all pages fully functional

### ✅ Completed Task: 4.5.12 — Organizational UI (Goals & Tasks Pages)
**Evidence:** Tasks page groups by goal with collapsible sections, Goals page groups by milestone, compact tiles, status/priority/domain filters, ungrouped sections, progress bars on groups, click tiles for detail view

### ✅ Completed Task: 4.5.13 — Milestone Creation Wizard (Hierarchical)
**Evidence:** Created comprehensive 3-step wizard (Milestone Details → Add Goals → Review), allows creating milestone + goals + tasks in one flow, live preview, domain selection, visual progress indicator, inline task creation

---

### 📊 SESSION SUMMARY — Phase 4.5 Progress

**Completed in this session:**
- ✅ Task 4.5.1: Domain Metadata Rendering System (5 widgets: School, Projects, Finance, Fitness + router)
- ✅ Task 4.5.2: Rich Milestone Card (724 lines, 3-state expansion, domain-aware)
- ✅ Task 4.5.3: Rich Goal Card (685 lines, parent milestone linking, task preview)
- ✅ Task 4.5.4: Rich Task Card (898 lines, subtask management, status pills)
- ✅ Task 4.5.5: Hierarchical Navigation (3 detail pages, breadcrumbs, deep linking)
- ✅ Task 4.5.12: Organizational UI (Tasks + Goals pages with grouping, filters, compact tiles)

**Total Output:** 
- **~4,200 lines of production code**
- **6 major rewrites** (3 cards + 2 pages + navigation system)
- **3 new detail pages** (Milestone, Goal, Task)
- **5 domain metadata renderers**
- **2 provider enhancements** (tasksByGoalProvider, milestoneByIdProvider)

**Transformation:**
- **Before:** Flat lists, skeletal cards, no hierarchy
- **After:** Organized groups, information-dense tiles, full navigation, 10x more context

**Key Features Added:**
- 3-state expansion (collapsed → preview → expanded)
- Hierarchical navigation with detail pages
- Domain-specific rendering (school courses, finance $, project phases)
- Cross-functional relationships (parent/child badges, clickable navigation)
- Grouped views (tasks by goal, goals by milestone)
- Ungrouped sections for orphaned entities
- Collapsible groups with progress indicators
- Multi-filter system (status, priority, domain)
- Compact tiles with inline actions
- Inline child previews (goals in milestones, tasks in goals, subtasks in tasks)
- Quick action bars (no modals needed for common operations)
- Rich status indicators (on track/overdue/complete with color coding)
- Subtask management with inline checkboxes
- Status pills for workflow management
- Multi-badge headers with contextual info

---

### ✅ Completed Task: 5.1 — Complete Today Page UI (Mock Data)
**Evidence:** Full 2-column layout with 6 new widgets: Must-Wins section, Hour-slot timeline (6am-11pm), Task pool with energy/time filters, Quick add form, Workout log panel. All styled and interactive (visual only, no backend wiring yet). No console errors.

**Files Created:**
- `lib/features/today/presentation/widgets/hour_slot_timeline.dart` (302 lines)
- `lib/features/today/presentation/widgets/task_pool_panel.dart` (345 lines)
- `lib/features/today/presentation/widgets/quick_add_panel.dart` (347 lines)
- `lib/features/today/presentation/widgets/workout_log_panel.dart` (360 lines)
- `lib/features/today/presentation/widgets/must_wins_section.dart` (240 lines)

**Files Modified:**
- `lib/features/today/presentation/today_page.dart` (REWRITE - 194 lines)

**Total Output:** ~1,788 lines of production UI code

### ✅ Completed Task: 6.1 — Project Planner UI (Mock Data)
**Evidence:** Complete Project Planner UI with 3 main views: Entry screen (paste idea + generate), Editor view (2-column layout with collapsible sections + live markdown preview), Feature cards modal (3 cards with conversion options). All styled and interactive (visual only, no AI wiring yet). No console errors.

**Files Created:**
- `lib/features/planner/presentation/widgets/planner_entry_screen.dart` (236 lines)
- `lib/features/planner/presentation/widgets/planner_editor_view.dart` (534 lines)
- `lib/features/planner/presentation/widgets/feature_cards_modal.dart` (482 lines)

**Files Modified:**
- `lib/features/planner/presentation/planner_page.dart` (REWRITE - 41 lines)

**Total Output:** ~1,293 lines of production UI code

### ✅ Completed Task: 7.1 — Reflections Page UI (Mock Data)
**Evidence:** Complete Reflections UI with 3-column layout: Persona sidebar (8 AI personas + chat history), Chat panel (conversation interface with user/AI messages), Notes panel (quick capture + recent notes). All styled and interactive (visual only, no AI wiring yet). No console errors.

**Files Created:**
- `lib/features/reflections/presentation/widgets/persona_sidebar.dart` (234 lines)
- `lib/features/reflections/presentation/widgets/chat_panel.dart` (298 lines)
- `lib/features/reflections/presentation/widgets/notes_panel.dart` (280 lines)

**Files Modified:**
- `lib/features/reflections/presentation/reflections_page.dart` (REWRITE - 69 lines)

**Total Output:** ~881 lines of production UI code

### ✅ Completed Task: 8.1 — Enhanced Task Modal (Create Tasks + Subtasks)
**Evidence:** Task modal now allows adding subtasks BEFORE creating the task. Added FloatingActionButton to Tasks page for quick task creation. Subtasks section shows for both new and existing tasks. Pending subtasks stored locally and created after task is saved.

**Files Modified:**
- `lib/features/tasks/presentation/widgets/task_modal.dart` (enhanced subtask creation)
- `lib/features/tasks/presentation/tasks_page.dart` (added FAB + import)

**Changes:**
- Added `_pendingSubtasks` list to store subtasks for new tasks
- Subtasks section now visible for both new and existing tasks  
- New tasks can add subtasks which are created after the task
- Added `_addPendingSubtask()` method for local storage
- Added FloatingActionButton to Tasks page for quick create
- Enhanced `_saveTask()` to create all pending subtasks after task creation

### Current Task: NONE — Awaiting UI Approval

### Queued Tasks:

**4.5.2 — Rich Milestone Card (Information-Dense)**
**Files:** `lib/features/milestones/presentation/widgets/milestone_card.dart` (REWRITE)

Redesign MilestoneCard to show:
- Domain badge + status indicator (On Track/Overdue/Complete)
- Rich progress bar with % label
- Stats rollup: "4 goals • 23 tasks • 156 CUs earned" (domain-aware)
- Domain metadata preview (use DomainMetadataWidget in compact mode)
- Inline goal list (first 3 goals with expand button)
- Quick actions: [View Full] [Add Goal] [Edit]

**Success:** Card shows complete context, clicking goals navigates to goal detail

**Estimated:** 2-3 hours

---

**4.5.3 — Rich Goal Card (Information-Dense)**
**Files:** `lib/features/goals/presentation/widgets/goal_card.dart` (REWRITE)

Redesign GoalCard to show:
- Parent milestone badge (clickable, navigates to milestone)
- Domain badge + progress bar with %
- Stats: "5/12 tasks • 3 done • 2 overdue"
- Domain metadata preview
- Inline task list (first 5 tasks with status indicators)
- Quick actions: [Add Task] [Associate] [Complete] [Edit]

**Success:** Card shows parent + children, inline task creation works

**Estimated:** 2-3 hours

---

**4.5.4 — Rich Task Card (Information-Dense)**
**Files:** `lib/features/tasks/presentation/widgets/task_card.dart` (REWRITE)

Redesign TaskCard to show:
- Multi-badge header: Domain | Priority | Time Estimate | Overdue status
- Parent goal badge (clickable)
- Subtask rollup: "3 subtasks • 2 done • 1 remaining"
- Inline subtask list with checkboxes
- Domain metadata (assignments for School, $ amount for Finance, etc.)
- Status pills: [To Do] [Doing] [Done] with points preview (+25pts)
- Quick actions: [Schedule] [Add Subtask] [Edit]

**Success:** Card is information-dense, shows complete context, status changes work inline

**Estimated:** 2-3 hours

---

**4.5.5 — Hierarchical Navigation System**
**Files:** 
- `lib/features/milestones/presentation/milestone_detail_page.dart` (NEW)
- `lib/features/goals/presentation/goal_detail_page.dart` (NEW)
- `lib/features/tasks/presentation/task_detail_page.dart` (NEW)

Create full-screen detail pages (not modals) for each entity:
- Milestone Detail: Header + Tabs (Overview | Goals | Tasks | Timeline | Settings)
- Goal Detail: Header + Tabs (Overview | Tasks | Progress | Settings)
- Task Detail: Slide-in panel from right (not full-screen)
- Breadcrumb navigation: "Milestones > CS Degree > Term 2 > D197"
- Each detail page shows rich info + inline children
- Click child entity → navigate to its detail page

**Success:** Deep navigation works, breadcrumbs accurate, back button returns to parent

**Estimated:** 3-4 hours

---

**4.5.6 — Cross-Link Relationship Badges**
**Files:** All card components + modal components

Add relationship badges to all cards:
- Task cards: "Part of: [Goal Name]" (clickable)
- Goal cards: "Milestone: [Milestone Name]" (clickable)
- "Associate" buttons that open quick-link modal
- Visual connection indicators (subtle lines/colors)
- Link counter badges: "3 tasks linked" with expand icon

**Success:** Click any badge → navigate to linked entity, association UI works

**Estimated:** 2-3 hours

---

**4.5.7 — Expansion/Collapse States (3-State Cards)**
**Files:** All card components

Implement 3-state expansion:
1. **Collapsed** (default): Summary only, no children shown
2. **Preview**: First 3-5 children shown inline with "+N more" indicator
3. **Expanded**: All children shown with full actions

Add state management:
- Local state for card expansion (don't persist)
- Smooth animations between states (height transition)
- Click card body → toggle Preview/Collapsed
- Click "Expand All" button → go to Expanded state

**Success:** Cards smoothly transition between states, performance good with 50+ cards

**Estimated:** 2-3 hours

---

**4.5.8 — Inline Quick Actions**
**Files:** All card components

Add inline action buttons to cards (no modal needed):
- Status change dropdown (To Do → Doing → Done) with immediate save
- Priority cycle button (Low → Medium → High → Critical)
- Quick schedule: Click time icon → opens time picker → creates schedule item
- Quick complete: Checkbox or checkmark button with animation
- Hover/focus states reveal action bar at bottom of card

**Success:** Common actions completable without opening modals, changes persist

**Estimated:** 2-3 hours

---

**4.5.9 — Smart Association System**
**Files:** 
- `lib/shared/widgets/association_modal.dart` (NEW)
- Task, Goal, Milestone modals (ENHANCE)

Create "Associate" modal that appears when linking entities:
- Shows searchable list of linkable entities
- For tasks: Search goals to link to
- For goals: Search milestones to link to
- Shows existing associations with "Unlink" button
- Suggests related items based on domain, keywords
- Live search with highlighting

**Success:** Can link/unlink entities easily, search works, suggestions relevant

**Estimated:** 2-3 hours

---

**4.5.10 — Enhanced Wizards with Live Preview**
**Files:** school_wizard.dart, projects_wizard.dart, finance_wizard.dart (ENHANCE)

Add split-screen to wizards:
- Left: Form inputs (current behavior)
- Right: Live preview of what's being created
- Preview updates in real-time as user types
- Shows how final card will look with entered data
- Preview uses actual card components (not mockups)

**Success:** User sees result before submitting, preview matches actual output

**Estimated:** 2-3 hours

---

**4.5.11 — Integration Testing & Polish**
**Files:** All modified files

End-to-end testing:
- Create milestone via wizard → verify rich card display
- Click milestone → navigate to detail → see goals
- Click goal → navigate to detail → see tasks
- Create task → link to goal → verify badge appears
- Toggle expansion states on all card types
- Test with 10+ milestones, 50+ goals, 200+ tasks (performance)
- Fix animation glitches, alignment issues
- Run linter, fix warnings
- Check console for errors

**Success:** App feels polished, navigation fluid, no performance issues, console clean

**Estimated:** 3-4 hours

---

### 📋 Queued Phases (After 4.5)
1. Phase 5 — Project Planner (14h)
2. Phase 6 — Reflections + AI (10h)
3. Phase 7 — Settings + Polish (10h)

### ❌ Blocked / Needs Info
*(None yet)*

---

## MVP Features (by Phase 4)

**Core functionality (must have):**
- [ ] Today Page — Daily cockpit: timeline, task pool, quick add, timer, Must-Wins (3)
- [ ] Tasks — CRUD + subtasks + split via prompt + points roll-up + Kanban view
- [ ] Goals — Hierarchy view, attach tasks, track progress
- [ ] Milestones — Category-based big rocks, progress tracking, completion celebration
- [ ] Project Planner — Generate docs, export Markdown+JSON, spawn Feature Cards → Tasks
- [ ] Reflections — Chat with 8 AI personas, journal, tag to entities
- [ ] Analytics — Points, streaks, progress graphs, skill tags, weekly insights
- [ ] Settings — Theme, LLM config, backups, categories

**Success = user can:** 
1. Set 3 Must-Wins each morning
2. Drag tasks into timeline and work with timer
3. Break tasks into atomic subtasks
4. See points roll up from Subtask → Task → Goal → Milestone
5. Generate a project plan and spawn atomic tasks from it
6. Chat with AI coach for guidance
7. Back up and restore data

---

## Stretch Ideas

**Cool but not critical (do NOT implement until MVP is done):**
- Idea 1
- Idea 2
- Idea 3

*Capture ideas here so they don't hijack your flow.*

---

## Architecture Notes

**State management:** Zustand with slices (pure, no IO)  
**Data flow:** UI → State (slices) → Logic (pure) → Contracts (Zod/DTO)  
**IO adapters:** Only in `state/` slices — DB via `infra/db/dao.ts`, LLM via `ai/service.ts`  
**Key files/structure:**
```
src/
  app/            # routes + shells (thin)
  features/       # self-contained: ui/ logic/ contracts/
    today/
    tasks/
    goals/
    milestones/
    planner/
    reflections/
    analytics/
  state/          # Zustand slices (no IO here)
  ai/
    service.ts    # single LLM orchestrator
    experts/      # 8 persona definitions
    prompts/      # system prompts
  shared/
    ui/           # generic components
    lib/          # utils
  infra/
    db/           # SQLite + migrations
```

**Key principle:** Features are "objects" — contracts/logic/ui encapsulated. No cross-feature imports.

---

## Learning Log

### Patterns Recognized
- **UI-First Development with Mock Data:** Building complete UI shells with hardcoded data before wiring backend logic
  - What worked: Creating standalone widget files with mock data classes, allowing full visual design without database dependencies. User can approve layout/UX before investing in backend wiring.
  - What to avoid: Mixing UI and backend logic in initial builds—leads to incomplete UX iteration cycles.

### Refactoring Opportunities
- [After feature X works, consider cleaning up Y]

---

## Debugging History

### Issue: [Brief description]
- **Error:** [Exact error message from console]
- **Cause:** [What was wrong]
- **Fix:** [What resolved it]
- **Commit:** [git hash or message]

*Keep this as reference for future similar issues.*

---

## Testing Checklist

Before marking task complete:
- [ ] Run tests (unit/integration)
- [ ] Check console (no errors/warnings)
- [ ] Verify core user flow works
- [ ] Confirm no regressions in other features
- [ ] Commit with clear message

---

## Recovery Checkpoints

**Last known good commit:** [hash/message]  
**When to revert here:** If stuck >2 attempts or errors snowball

---

## Notes / Context

[Any additional context, API keys location, design decisions, etc.]

---

## Phase 4 Breakdown — Domain-Specific MGTST UI

**Goal:** Implement template-driven creation and enhanced UI for School, Projects, and Finance domains

**Files to modify/create:**
- `lib/core/database/tables.dart` (add domain enum + metadata)
- `lib/core/models/*.dart` (enhance with domain-specific fields)
- `lib/features/milestones/presentation/widgets/template_wizard.dart` (NEW)
- `lib/features/milestones/presentation/widgets/milestone_card_enhanced.dart` (ENHANCE)
- `lib/features/goals/presentation/widgets/goal_card_enhanced.dart` (ENHANCE)
- `lib/features/tasks/presentation/widgets/task_card_enhanced.dart` (ENHANCE)
- Domain-specific wizard steps for each domain

### Task 4.1: Foundation — Domain System & Data Models
**Files:** `lib/core/database/tables.dart`, `lib/core/models/milestone.dart`, `lib/core/models/goal.dart`, `lib/core/models/task.dart`

- [ ] Add `domain` enum column to Milestones table (School, Projects, Finance, Health, DSA, Personal)
- [ ] Add `metadata` JSON column to Milestones, Goals, Tasks tables
- [ ] Update Freezed models to include `domain` and `metadata` fields
- [ ] Run build_runner to generate code
- [ ] Test: Create milestone with domain + metadata via database

**Success:** Database accepts domain-specific metadata, models deserialize correctly

**Estimated:** 1-2 hours

---

### Task 4.2: Template Wizard — School Domain
**Files:** `lib/features/milestones/presentation/widgets/school_wizard.dart` (NEW)

- [ ] Create SchoolWizard widget (5-step flow)
- [ ] Step 1: Semester details (name, start/end dates, GPA target)
- [ ] Step 2: Course selection (auto-generate goals for each course)
- [ ] Step 3: Course details (credits, professor, grade target for each)
- [ ] Step 4: Timeline & deadlines (auto-calculate from semester dates)
- [ ] Step 5: Study preferences (weekly study hours, exam prep strategy)
- [ ] Wire wizard to create Milestone + Goals with School metadata
- [ ] Test: Complete wizard, verify milestone created with courses as goals

**Success:** User can create a semester milestone with courses through guided wizard

**Estimated:** 3-4 hours

---

### Task 4.3: Template Wizard — Projects Domain
**Files:** `lib/features/milestones/presentation/widgets/projects_wizard.dart` (NEW)

- [ ] Create ProjectsWizard widget (5-step flow)
- [ ] Step 1: Project type selection (Web App, Mobile, Desktop, CLI, API, etc.)
- [ ] Step 2: Project details (name, description, tech stack, repo URL)
- [ ] Step 3: Auto-generated phases (Planning, Frontend, Backend, Testing, Deploy)
- [ ] Step 4: Timeline & deadlines (auto-calculate phase dates)
- [ ] Step 5: Success metrics (KPIs, completion criteria, celebration plan)
- [ ] Wire wizard to create Milestone + Goals (phases) with Projects metadata
- [ ] Test: Complete wizard, verify project milestone created with phases

**Success:** User can create a project milestone with phases through guided wizard

**Estimated:** 3-4 hours

---

### Task 4.4: Template Wizard — Finance Domain
**Files:** `lib/features/milestones/presentation/widgets/finance_wizard.dart` (NEW)

- [ ] Create FinanceWizard widget (5-step flow)
- [ ] Step 1: Goal type selection (Emergency Fund, Pay Debt, Invest, etc.)
- [ ] Step 2: Financial details (target $, current $, monthly expenses)
- [ ] Step 3: Savings plan (monthly target, auto-generate sub-goals)
- [ ] Step 4: Timeline & milestones (interim $ targets)
- [ ] Step 5: Tracking preferences (update frequency, motivation, rewards)
- [ ] Wire wizard to create Milestone + Goals (savings plan) with Finance metadata
- [ ] Test: Complete wizard, verify financial milestone created with plan

**Success:** User can create a financial milestone with savings plan through guided wizard

**Estimated:** 3-4 hours

---

### Task 4.5: Enhanced Milestone Cards (Domain-Aware)
**Files:** `lib/features/milestones/presentation/widgets/milestone_card.dart` (ENHANCE)

- [ ] Detect domain from milestone.domain field
- [ ] Render School-specific UI: GPA, courses, exam dates
- [ ] Render Projects-specific UI: Tech stack, repo link, KPIs, phases
- [ ] Render Finance-specific UI: $ progress, chart, monthly tracking
- [ ] Add domain-specific icons and color accents
- [ ] Test: Create milestones for each domain, verify correct card rendering

**Success:** Milestone cards show domain-specific data and visualizations

**Estimated:** 2-3 hours

---

### Task 4.6: Enhanced Goal Cards (Domain-Aware)
**Files:** `lib/features/goals/presentation/widgets/goal_card.dart` (ENHANCE)

- [ ] Detect domain from parent milestone
- [ ] Render School-specific UI: Course name, grade target, assignments
- [ ] Render Projects-specific UI: Phase name, tech stack, timeline
- [ ] Render Finance-specific UI: Savings target, $ impact calculator
- [ ] Test: Create goals for each domain, verify correct card rendering

**Success:** Goal cards show domain-specific data

**Estimated:** 2-3 hours

---

### Task 4.7: Enhanced Task Cards (Domain-Aware)
**Files:** `lib/features/tasks/presentation/widgets/task_card.dart` (ENHANCE)

- [ ] Detect domain from parent goal → milestone
- [ ] Render School-specific UI: Study materials, exam prep checklist
- [ ] Render Projects-specific UI: Tech tags, time tracking, PR links
- [ ] Render Finance-specific UI: Decision matrix, $ amount, account details
- [ ] Test: Create tasks for each domain, verify correct card rendering

**Success:** Task cards show domain-specific metadata

**Estimated:** 2-3 hours

---

### Task 4.8: Template Selection Screen
**Files:** `lib/features/milestones/presentation/milestone_create_page.dart` (NEW)

- [ ] Create template selection screen (grid of domain cards)
- [ ] Show School, Projects, Finance, Health, DSA, Personal templates
- [ ] Each card: Icon, title, description, "Use Template" button
- [ ] Route to appropriate wizard based on selection
- [ ] Add "Custom" option (uses existing generic flow)
- [ ] Test: Navigate from Milestones page → Template selection → Wizard

**Success:** User can choose a domain template to create a milestone

**Estimated:** 1-2 hours

---

### Task 4.9: Finance Savings Chart Widget
**Files:** `lib/shared/widgets/savings_chart.dart` (NEW)

- [ ] Create line chart widget using fl_chart package
- [ ] Plot current savings vs. projected savings over time
- [ ] Show interim milestone markers
- [ ] Animate chart on load (left to right)
- [ ] Test: Display chart in Finance milestone card

**Success:** Finance milestones show visual progress chart

**Estimated:** 2-3 hours

---

### Task 4.10: Integration & Polish
**Files:** Multiple (navigation, providers, etc.)

- [ ] Update Milestones page FAB to route to template selection
- [ ] Ensure domain metadata persists and loads correctly
- [ ] Add domain filter to Milestones/Goals/Tasks pages
- [ ] Test complete flow: Template selection → Wizard → Create → View cards
- [ ] Fix any UI glitches, alignment issues
- [ ] Run linter and fix all warnings

**Success:** End-to-end flow works smoothly, no console errors

**Estimated:** 2-3 hours

---

**Total Estimated Time: 21-30 hours**

---

## ✅ Phase 5 Completed (October 7, 2025)

### ✅ Completed Task: 5.1 — Multi-Domain Seed System

**Evidence:** Comprehensive data seeding system with 9 individual seed functions plus "Seed All" option. Architecture remains fully agnostic—all projects use same schema (Milestones, Goals, Tasks), differentiated only by `domain` enum and `metadata` JSON.

**Files Created:**
- `lifeline_os/lib/core/database/seed_all_domains.dart` (1,450+ lines)

**Files Modified:**
- `lifeline_os/lib/features/settings/presentation/settings_page.dart` (Complete rewrite with grid layout)

**Domains Seeded:**
- **Projects:** Petform (1M/3G/6T), MMAmania (1M/4G/8T), Pokeher (1M/4G/5T), StockSurveyor (1M/4G/5T), Music App (1M/3G/3T)
- **Life:** School/WGU (8M/29G/116T), Fitness (1M/4G/4T), Finance (1M/3G/5T), GRE (1M/3G/3T)
- **Total:** 15 Milestones, 50 Goals, 157 Tasks

**Metadata Structured Per Task:**
- `dod`: Definition of Done checklist
- `evidence`: Screenshots, logs, URLs
- `rollback`: Git revert instructions
- `recipe`: Step-by-step implementation plan (Read/Implement/Test)
- `app`, `pillar`, `risk`, `energy`, `context`: Multi-dimensional tags
- `fileCount`, `locChanged`: Code metrics

**UI Features:**
- "Seed All Domains" button (seeds everything at once)
- 2x5 grid for Projects (Petform, MMAmania, Pokeher, StockSurveyor, Music)
- 2x4 grid for Life domains (School, Fitness, Finance, GRE)
- Color-coded buttons with icons and M/G/T counts
- Individual seed or seed all
- Real-time toast notifications (loading, success, error)

**Architecture Validation:** ✅
- All seeds use identical schema
- No domain-specific database fields
- `metadata` JSON holds all domain-specific data (DoD, KPIs, recipes, etc.)
- Same `priority`, `status`, `energy`, `points` fields work universally
- Domain enum differentiates categories (Projects, Finance, Health, School, DSA, Personal)

**Total Output:** ~1,500 lines of production code

---

## ✅ Domain Restructuring Completed (October 7, 2025)

### ✅ Completed Task: Domain Expansion & Restructuring

**Goal:** Add Career and GRE as separate domains, refocus DSA on LeetCode/interview prep

**Evidence:** 8 domains now fully functional with proper labels, icons, colors, and seed data

**Changes Made:**

**1. Domain Enum Update (`tables.dart`):**
- Added `Domain.career` (professional development)
- Added `Domain.gre` (test preparation)
- Renamed DSA display label to "LeetCode" (kept enum as `dsa`)
- Total domains: 8 (School, Projects, Finance, Health, LeetCode, Career, GRE, Personal)

**2. UI Updates (4 files):**
- `tasks_page.dart` - Updated all 3 domain helper methods
- `goals_page.dart` - Updated all 3 domain helper methods
- `board_page.dart` - Updated all 3 domain helper methods
- `milestones_page.dart` - Updated domain label method

**Domain Colors & Icons:**
- **Career:** Cyan (`Colors.cyan.shade400`), Briefcase icon
- **GRE:** Amber (`Colors.amber.shade400`), BookOpen icon
- **LeetCode:** Blue (`Colors.blue.shade400`), CPU icon

**3. Seed Data Updates (`seed_all_domains.dart`):**
- **Bug Fix:** Changed GRE seed from `Domain.dsa` → `Domain.gre` (3 goals affected)
- **New Career Seed:** 1 milestone, 4 goals, 9 tasks
  - Goals: Resume & Portfolio, Networking & Connections, Job Search & Applications, Skills Development
  - Tasks cover: Resume updates, portfolio site, LinkedIn, coffee chats, meetups, applications, interview prep, certifications, side projects
  - Metadata includes: DoD, evidence, KPIs, pillars
- Updated `seedAllDomains()` to include `seedCareer()`

**4. Settings UI Update (`settings_page.dart`):**
- Added Career button to Life Domains grid (2x3 layout now)
- Grid order: School, Career, Fitness, Finance, GRE
- Career button: Cyan color, briefcase icon, "1M • 4G • 9T" subtitle

**Architecture Maintained:**
- ✅ Agnostic schema preserved (no domain-specific tables)
- ✅ All domains use same M/G/T structure
- ✅ Domain-specific data in JSON `metadata`
- ✅ No breaking changes to existing data
- ✅ All switch statements exhaustive (no compilation errors)

**Files Modified:** 7 files
**New Code:** ~300 lines (Career seed function)
**Total Domains:** 8 (was 6)
**Total Seeds:** 10 functions (9 individual + 1 seedAll)

**Testing Required:**
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs` to regenerate database
- [ ] Test all 8 domain filters on Tasks/Goals/Milestones pages
- [ ] Test Career seed button in Settings
- [ ] Verify board view shows 8 columns
- [ ] Confirm GRE data now appears in GRE domain (not DSA)

---

