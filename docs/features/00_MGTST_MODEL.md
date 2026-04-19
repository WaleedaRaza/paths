# MGTST Model — The Foundation

## Core Problem: Executive Dysfunction Architecture

**Goal:** Eliminate decision fatigue while maximizing momentum. The system must:
- Provide immediate feedback loops (dopamine hits)
- Show only relevant tasks (no information overload)
- Create cascading rewards (subtask → task → goal → milestone)
- Match tasks to energy levels and available time
- Never present more than 3 choices per decision point

---

## The Hierarchy That Works

```
MILESTONE (Big Rock - 6 months)
├── GOAL (Major Push - 1-2 months)
│   ├── TASK (Work Session - 15-90 minutes)
│   │   ├── SUBTASK (Code Planning - 5-15 min)
│   │   ├── SUBTASK (Research - 10-20 min)
│   │   ├── SUBTASK (Writing Snippet - 15-30 min)
│   │   └── SUBTASK (Testing - 10-20 min)
│   └── TASK (Another Work Session)
└── GOAL (Another Major Push)
```

**Real Example:**
```
MILESTONE: Graduate WGU (500 points, June 2025)
├── GOAL: Pass D426 (75 points, 3 weeks)
│   ├── TASK: D426 Quiz Prep (25min, +5 pts)
│   │   ├── SUBTASK: Review Chapter 3 (5min, +1pt)
│   │   ├── SUBTASK: Practice Quiz 1 (15min, +3pts)
│   │   └── SUBTASK: Review Mistakes (5min, +1pt)
│   ├── TASK: D426 Reading (60min, +10 pts)
│   └── TASK: D426 Final Project (120min, +25 pts)
└── GOAL: Pass D427 (75 points, 3 weeks)
```

---

## The Reward Cascade (Critical for ADHD)

| Action | Points | Feedback | Timing |
|--------|--------|----------|--------|
| **Subtask completed** | +1 point | ✓ Checkmark, subtle sound | <200ms |
| **Task completed** | +5 points | Progress bar fill, +5 toast | <500ms |
| **Goal completed** | +25 points | Goal card pulse, +25 celebration | <1s |
| **Milestone completed** | +100 points | Full-screen celebration, confetti | <2s |

**Key Principle:** Immediate feedback (<500ms) for every action. Delayed feedback = broken dopamine loop = lost momentum.

---

## The Six Categories (Life Domains)

| Category | Description | Base Points | Use Cases |
|----------|-------------|-------------|-----------|
| **School** | WGU courses, GRE prep | 5 base, +1 bonus | Course tasks, study sessions, exams |
| **Projects** | Petform, MMAmania, Poker, StockScouter | 10 base, +2 bonus | Feature builds, debugging, deployments |
| **Health** | Fitness, nutrition, sleep | 3 base, +1 bonus | Workouts, meal prep, sleep tracking |
| **Finance** | Investments, budgeting, income | 5 base, +1 bonus | Budget reviews, trades, side income |
| **DSA** | LeetCode, algorithms, patterns | 8 base, +2 bonus | Problem solving, pattern recognition |
| **Career** | Job apps, networking, skills | 7 base, +1 bonus | Applications, interviews, portfolio |
| **Agnostic** | General life admin, personal growth | 5 base, +1 bonus | Errands, habits, self-improvement |

**Category Properties:**
- `id`: UUID
- `name`: String (user-editable)
- `color`: Hex color (user-editable)
- `kind`: Enum (school|projects|health|finance|ds|career|agnostic)
- `basePoints`: Integer (task completion base reward)
- `bonusMultiplier`: Float (streak multiplier)

---

## Subtask Kinds (Required Field)

| Kind | Description | Typical Duration | Examples |
|------|-------------|------------------|----------|
| `code_planning` | Planning before coding | 5-15 min | Design patterns, architecture notes |
| `research` | Investigation & learning | 10-20 min | API docs, library comparison |
| `writing` | Content creation | 15-30 min | Code comments, documentation, specs |
| `snippet` | Small code chunks | 10-20 min | Helper functions, components |
| `testing` | Testing & verification | 10-20 min | Unit tests, manual QA |
| `debugging` | Bug investigation & fixes | 15-30 min | Stack traces, reproduction |
| `generic` | Catch-all for other work | 5-30 min | Meetings, admin, misc |

**Why Required:** Forces atomic thinking. No vague "work on X" — must specify what kind of work.

---

## Task Properties (Complete Spec)

```typescript
interface Task {
  id: string;                          // UUID
  goalId?: string;                     // Optional link to Goal
  title: string;                       // "D426 Quiz Prep"
  status: TaskStatus;                  // todo|doing|done|blocked|snoozed
  estimateMinutes: number;             // 5|15|25|50|90 (preset options)
  energy: EnergyLevel;                 // low|med|high
  due?: string;                        // ISO date
  points: number;                      // Default 5, customizable
  priority?: number;                   // 1-5 (1 = urgent)
  labels: string[];                    // ["authentication", "backend"]
  categoryId: string;                  // Required link to Category
  subtasks: Subtask[];                 // Embedded subtasks
  createdAt: string;                   // ISO timestamp
  updatedAt: string;                   // ISO timestamp
  deletedAt?: string;                  // Soft delete
  origin?: {                           // Optional Planner link
    plannerDocId: string;
    cardId: string;
  };
}

type TaskStatus = 'todo' | 'doing' | 'done' | 'blocked' | 'snoozed';
type EnergyLevel = 'low' | 'med' | 'high';
```

---

## Goal Properties

```typescript
interface Goal {
  id: string;                          // UUID
  milestoneId: string;                 // Required link to Milestone
  title: string;                       // "Pass D426"
  order: number;                       // Sort order within milestone
  pointsTarget?: number;               // Optional explicit target
  progressPoints: number;              // Computed from tasks (cached)
  status: GoalStatus;                  // active|completed|archived
  notes?: string;                      // Rich text notes
  createdAt: string;
  updatedAt: string;
  deletedAt?: string;
}

type GoalStatus = 'active' | 'completed' | 'archived';
```

---

## Milestone Properties

```typescript
interface Milestone {
  id: string;                          // UUID
  title: string;                       // "Graduate WGU"
  categoryId: string;                  // Required link to Category
  targetPoints: number;                // 500
  progressPoints: number;              // Computed from goals (cached)
  due?: string;                        // ISO date
  status: MilestoneStatus;             // active|completed|archived
  notes?: string;
  createdAt: string;
  updatedAt: string;
  deletedAt?: string;
}

type MilestoneStatus = 'active' | 'completed' | 'archived';
```

---

## Subtask Properties

```typescript
interface Subtask {
  id: string;                          // UUID
  taskId: string;                      // Required link to Task
  title: string;                       // "Review Chapter 3"
  kind: SubtaskKind;                   // Required classification
  done: boolean;                       // Completion state
  points: number;                      // Default 1
  order: number;                       // Sort order within task
  createdAt: string;
}

type SubtaskKind = 
  | 'code_planning'
  | 'research'
  | 'writing'
  | 'snippet'
  | 'testing'
  | 'debugging'
  | 'generic';
```

---

## Roll-Up Logic (Critical for Motivation)

### How Points Flow Up

1. **Subtask Completed:**
   - `subtask.done = true` → `+1 point` (instant)
   - Recompute `task.points` = base (5) + sum(subtask.points where done = true)
   - Update UI immediately (<200ms)

2. **Task Completed:**
   - `task.status = 'done'` → task points finalized
   - Recompute `goal.progressPoints` = sum(task.points where goalId = goal.id AND status = 'done')
   - Update goal progress bar immediately

3. **Goal Completed:**
   - `goal.status = 'completed'` when `goal.progressPoints >= goal.pointsTarget`
   - Recompute `milestone.progressPoints` = sum(goal.progressPoints where milestoneId = milestone.id)
   - Update milestone card immediately
   - Trigger goal celebration animation

4. **Milestone Completed:**
   - `milestone.status = 'completed'` when `milestone.progressPoints >= milestone.targetPoints`
   - Trigger full-screen celebration (confetti, streak update)
   - Lock milestone (no further edits without admin override)

### Recompute Triggers

Roll-ups must recompute on:
- `subtask.done` toggle (any direction)
- `task.status` change
- `task.goalId` change (attach/detach)
- `goal.milestoneId` change (attach/detach)
- Task deletion (soft delete: `deletedAt` set)

**Performance Note:** Cache progress in `goal.progressPoints` and `milestone.progressPoints` to avoid N+1 queries. Invalidate cache on any of the above triggers.

---

## Energy Matching (Critical for Today Page)

**Principle:** Show tasks that match current energy level. Don't show high-energy tasks at 9pm.

| Time of Day | Default Energy | Task Filtering |
|-------------|----------------|----------------|
| 6am - 10am | High | Show high-energy tasks first |
| 10am - 2pm | High/Med | Show high & med energy tasks |
| 2pm - 6pm | Med | Show med & low energy tasks |
| 6pm - 10pm | Low | Show only low energy tasks |

**User Override:** User can manually set their current energy level to override defaults.

---

## Time Estimate Presets (Forced Choices)

**Available Options:**
- 5 minutes (quick wins, single subtask)
- 15 minutes (pomodoro half)
- 25 minutes (single pomodoro)
- 50 minutes (double pomodoro)
- 90 minutes (deep work session)

**No Custom Estimates:** Reduces decision fatigue. If task doesn't fit, break it into smaller tasks.

---

## Success Metrics (What "Good" Looks Like)

### ADHD Optimization
- **Time to First Action:** <30 seconds from app open to task start
- **Context Switching Cost:** <5 seconds between related tasks
- **Reward Feedback Loop:** Points/celebration within 2 seconds of completion
- **Decision Fatigue:** Max 3 choices per screen

### Engagement
- **Daily Active Usage:** >30 minutes
- **Task Completion Rate:** >70% of scheduled tasks
- **Milestone Achievement:** >80% on-time
- **Streak Consistency:** >5 days average

### Technical Performance
- **App Launch:** <2 seconds
- **Database Queries:** <100ms average
- **AI Response:** <5 seconds
- **Memory Usage:** <200MB baseline

---

## Anti-Patterns (What to Avoid)

### From Old App
❌ **Information Overload:** Showing all tasks at once  
✅ **Solution:** Show only relevant tasks (filtered by energy, time, priority)

❌ **Context Switching:** Multiple AI services, scattered logic  
✅ **Solution:** Single AI service with expert switching

❌ **Decision Paralysis:** Too many options  
✅ **Solution:** Guided choices with smart defaults (3 must-wins, preset time estimates)

❌ **Broken Feedback Loops:** Delayed rewards  
✅ **Solution:** Immediate points/celebration (<500ms)

❌ **Feature Creep:** Too many half-built features  
✅ **Solution:** Core MGTST features done well first

### New Anti-Patterns to Avoid
❌ **Over-Engineering:** Complex abstractions  
✅ **Solution:** Simple, direct implementations

❌ **Premature Optimization:** Micro-optimizations  
✅ **Solution:** Focus on user experience first

❌ **Scope Creep:** Adding features mid-build  
✅ **Solution:** Stick to core MGTST system, defer nice-to-haves

❌ **AI Dependency:** Everything through AI  
✅ **Solution:** AI enhances, doesn't replace human thinking

---

## File Targets (Where MGTST Lives)

### Contracts
- `src/shared/contracts/entities.ts` — Zod schemas for all MGTST entities
- `src/shared/contracts/enums.ts` — TaskStatus, EnergyLevel, SubtaskKind, etc.

### Logic (Pure Functions)
- `src/features/tasks/logic/rollup.ts` — Point roll-up calculations
- `src/features/goals/logic/progress.ts` — Goal progress computation
- `src/features/milestones/logic/progress.ts` — Milestone progress computation

### State (Zustand Slices)
- `src/state/slices/tasksSlice.ts` — Task CRUD + roll-up triggers
- `src/state/slices/goalsSlice.ts` — Goal CRUD + progress caching
- `src/state/slices/milestonesSlice.ts` — Milestone CRUD + completion

### Database
- `src/infra/db/migrations/0001_mgtst.sql` — Core tables
- `src/infra/db/migrations/0002_indexes.sql` — Performance indexes

---

## Next Steps

With this MGTST foundation understood, implement features in this order:
1. **Database schema** (MGTST tables)
2. **State slices** (CRUD operations)
3. **Roll-up logic** (pure functions, tested)
4. **Today Page** (first consumer of MGTST data)
5. **Tasks Page** (deep task management)
6. **Goals/Milestones Pages** (hierarchy views)
7. **Planner integration** (cards → tasks)

**Golden Rule:** Roll-ups must be instant (<500ms). Cache aggressively, invalidate precisely.

