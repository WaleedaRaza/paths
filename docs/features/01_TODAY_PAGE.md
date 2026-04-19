# Feature: Today Page (Daily Cockpit)

## Purpose & User Outcome

**Goal:** Eliminate morning decision paralysis. User opens app, sees 3 must-wins, drags tasks into timeline, starts work within 30 seconds.

**Success Criteria:**
- ✅ Time to first task start: <30 seconds
- ✅ All scheduled tasks visible at a glance
- ✅ Quick add without leaving page
- ✅ Timer integration with automatic logging
- ✅ Must-Wins enforced (cannot skip)

---

## User Stories

1. **Morning Planning:** I open the app, see my 3 must-wins suggested, swap one, and drag tasks into my timeline for the day.
2. **Starting Work:** I click a scheduled task at 10am, timer starts, I work for 25 minutes, timer stops, log is created automatically.
3. **Quick Adding:** I realize I need to add "email professor" — I type it, set 15min/low energy, it appears in pool immediately.
4. **Workout Logging:** After my workout, I log "Bench Press, 3x185lbs" with one click, get +5 points.
5. **Schedule Persistence:** I close the app mid-day, reopen it, my schedule is intact.

---

## Page Layout (Desktop/Tauri Window)

```
┌─────────────────────────────────────────────────────────────────┐
│ ← Today • Oct 6, 2025                          [☀️ High Energy] │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  LEFT RAIL (40%)             │  RIGHT STACK (60%)                │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━  │  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                               │                                   │
│  🎯 Must-Wins (Pinned)        │  📋 Task Pool (Filtered)         │
│  ┌──────────────────────────┐ │  ┌─────────────────────────────┐│
│  │ ✅ D426 Quiz Prep        │ │  │ [🔋High] [⚡Med] [🔌Low]   ││
│  │ 🔄 Petform Auth Fix      │ │  │ [5m] [15m] [25m] [50m] [90m] ││
│  │ ⏳ Morning Workout       │ │  │ ──────────────────────────── ││
│  └──────────────────────────┘ │  │ D426 Quiz Prep              ││
│                               │  │ School • 25min • High        ││
│  📅 Timeline (Hour Slots)     │  │ [Drag to schedule]           ││
│  ┌──────────────────────────┐ │  │ ──────────────────────────── ││
│  │ 06:00 [Empty]            │ │  │ Petform Auth Fix            ││
│  │ 07:00 [Empty]            │ │  │ Projects • 30min • Med       ││
│  │ 08:00 [Empty]            │ │  │ [Drag to schedule]           ││
│  │ 09:00 [Empty]            │ │  └─────────────────────────────┘│
│  │ 10:00 [D426 Quiz ▶️]     │ │                                   │
│  │ 11:00 [Empty]            │ │  ➕ Quick Add                    │
│  │ 12:00 [🍽️ Lunch]        │ │  ┌─────────────────────────────┐│
│  │ 13:00 [Empty]            │ │  │ Title: [_______________]    ││
│  │ 14:00 [Petform Auth]     │ │  │ Time: [15] [25] [50] min    ││
│  │ 15:00 [          ]       │ │  │ Energy: [🔋] [⚡] [🔌]     ││
│  │ 16:00 [Empty]            │ │  │ Category: [School ▼]        ││
│  │ 17:00 [Empty]            │ │  │ Goal: [D426 Course ▼]       ││
│  │ 18:00 [Workout]          │ │  │ [Auto-fill] [Add Task]      ││
│  │ 19:00 [Empty]            │ │  └─────────────────────────────┘│
│  │ 20:00 [Empty]            │ │                                   │
│  │ 21:00 [Empty]            │ │  🏋️ Workout Log                 │
│  │ 22:00 [Wind Down]        │ │  ┌─────────────────────────────┐│
│  └──────────────────────────┘ │  │ Exercise: [Bench Press ▼]   ││
│                               │  │ Sets: [3] × Weight: [185] lbs││
│                               │  │ [Start Timer] [Log Set]      ││
│                               │  │ ─────────────────────────────││
│                               │  │ Previous: 3×185, 3×180       ││
│                               │  │ [Complete] (+5 points)       ││
│                               │  └─────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

---

## Component Breakdown

### 1. Must-Wins Section (Top, Pinned)

**UX Spec:**
- Always shows exactly 3 tasks (enforced)
- On first load of day, AI suggests 3 based on:
  - Tasks with due dates today
  - High-priority tasks
  - Tasks linked to active milestones
- User can swap any of the 3 via drag-drop from pool
- Visual: Large checkboxes, category color border, completion percentage

**Interactions:**
- Click checkbox → mark done → instant +5 points toast
- Drag task from pool → replaces current must-win
- Click task → opens Task Modal
- Hover → shows linked goal/milestone

**State:**
- `todaySlice.mustWins: string[]` (3 task IDs)
- `todaySlice.setMustWins(taskIds: [string, string, string])`

**Logic:**
- `logic/recommendMustWins.ts`:
  ```typescript
  function recommendMustWins(
    tasks: Task[],
    goals: Goal[],
    milestones: Milestone[],
    date: string
  ): [string, string, string] {
    // 1. Tasks due today (highest priority)
    // 2. Tasks linked to milestones with approaching deadlines
    // 3. High-energy tasks if morning, low-energy if evening
    // 4. Fall back to oldest unscheduled tasks
  }
  ```

---

### 2. Timeline (Left Rail, Hour Slots)

**UX Spec:**
- Hour slots from 6am to 11pm (configurable in settings)
- Each slot shows:
  - Time (24h or 12h format)
  - Scheduled task (if any) with:
    - Task title
    - Category color border
    - Time estimate badge
    - Play/Pause button (timer)
- Drag-and-drop zones (dropzone highlights on drag-over)
- Current time indicator (red line)
- Slots with fixed events (e.g., "Lunch") are non-droppable

**Interactions:**
- **Drag task from pool → slot:** Schedules task for that hour
- **Drag task slot → slot:** Reschedules task
- **Click task in slot:** Opens Task Modal + option to start timer
- **Click play button:** Starts timer for that task (countdown overlay)
- **Click pause button:** Pauses timer, prompts to log time
- **Right-click slot:** Context menu (remove task, mark blocked, snooze)

**State:**
- `todaySlice.schedule: Map<string, ScheduledTask>`
  ```typescript
  interface ScheduledTask {
    timeSlot: string;  // "2025-10-06T10:00:00Z"
    taskId: string;
    status: 'scheduled' | 'in_progress' | 'completed' | 'skipped';
  }
  ```

**Logic:**
- `logic/schedule.ts`:
  ```typescript
  function canPlaceTask(
    task: Task,
    slot: string,
    schedule: Map<string, ScheduledTask>
  ): boolean {
    // Check if slot is empty
    // Check if task estimate fits in remaining day
    // Check if slot is not a fixed event
  }
  
  function getAvailableSlots(
    date: string,
    schedule: Map<string, ScheduledTask>
  ): string[] {
    // Return all empty slots
  }
  ```

---

### 3. Task Pool (Right Stack, Top)

**UX Spec:**
- Shows unscheduled tasks for today (filtered)
- Filters (toggle buttons):
  - **Energy:** High / Med / Low (multi-select)
  - **Time:** 5m / 15m / 25m / 50m / 90m (multi-select)
  - **Category:** School / Projects / Health / etc (multi-select)
- Sort options:
  - Priority (default)
  - Due date
  - Energy level
  - Category
- Each task card shows:
  - Title
  - Category badge + color
  - Time estimate
  - Energy level icon
  - Drag handle
  - Quick action: "Start Now" button

**Interactions:**
- **Drag task → timeline:** Schedules task
- **Click task card:** Opens Task Modal
- **Click "Start Now":** Adds to next available slot + starts timer
- **Toggle filters:** Re-filters task list immediately

**State:**
- `todaySlice.poolFilters: PoolFilters`
  ```typescript
  interface PoolFilters {
    energy: EnergyLevel[];
    timeEstimate: number[];
    categories: string[];
    sortBy: 'priority' | 'due' | 'energy' | 'category';
  }
  ```

**Logic:**
- `logic/filterTasks.ts`:
  ```typescript
  function filterTaskPool(
    tasks: Task[],
    filters: PoolFilters,
    currentEnergy: EnergyLevel
  ): Task[] {
    // Filter by status (only todo/doing)
    // Filter by energy (auto-match current energy if no filter)
    // Filter by time estimate
    // Filter by category
    // Sort by selected option
    // Limit to top 20 results (performance)
  }
  ```

---

### 4. Quick Add (Right Stack, Middle)

**UX Spec:**
- Inline form, always visible
- Fields:
  - **Title:** Text input (required)
  - **Time:** Button group (5/15/25/50/90) (required)
  - **Energy:** Button group (High/Med/Low) (required)
  - **Category:** Dropdown (required)
  - **Goal:** Dropdown (optional, filtered by category)
- **"Auto-fill from prompt"** button:
  - Opens textarea modal
  - User types: "need to email professor about D426 quiz"
  - AI extracts: Title="Email professor about D426", Time=15, Energy=Low, Category=School, Goal=D426 Course
  - Fills form fields automatically
- **"Add Task"** button:
  - Validates required fields
  - Creates task
  - Adds to task pool immediately
  - Clears form

**Interactions:**
- **Type in title → blur:** Auto-suggest category/goal based on keywords
- **Select category:** Filters goal dropdown to that category
- **Click "Auto-fill":** Opens prompt modal
- **Click "Add Task":** Creates task, shows +5 points toast

**State:**
- `todaySlice.quickAddForm: QuickAddForm`
  ```typescript
  interface QuickAddForm {
    title: string;
    estimateMinutes: number;
    energy: EnergyLevel;
    categoryId: string;
    goalId?: string;
  }
  ```

**Logic:**
- `logic/autoFill.ts`:
  ```typescript
  async function autoFillTask(
    prompt: string,
    aiService: AIService
  ): Promise<QuickAddForm> {
    // Call AI with system prompt: "Extract task details from this prompt"
    // Parse AI response
    // Return filled form data
  }
  ```

---

### 5. Workout Log (Right Stack, Bottom)

**UX Spec:**
- Simplified workout tracking (minimal, not full fitness app)
- Fields:
  - **Exercise:** Dropdown (pre-populated: Bench Press, Squat, Deadlift, etc.)
  - **Sets:** Number input
  - **Weight:** Number input + unit (lbs/kg)
  - **Reps** (optional): Number input
- **"Start Timer"** button: Starts rest timer (default 90s)
- **"Log Set"** button: Records set
- **"Complete Workout"** button: Creates workout log, awards +5 points
- Shows previous workout data (last 3 sessions)

**Interactions:**
- **Select exercise:** Pre-fills weight/reps from last session
- **Click "Log Set":** Adds set to current workout session
- **Click "Complete":** Creates Log entry, awards points, clears form

**State:**
- `todaySlice.workoutSession: WorkoutSession`
  ```typescript
  interface WorkoutSession {
    exercise: string;
    sets: Array<{ weight: number; reps: number; }>;
    startedAt: string;
  }
  ```

**Logic:**
- `logic/workoutLog.ts`:
  ```typescript
  function createWorkoutLog(
    session: WorkoutSession,
    userId: string
  ): Log {
    // Create Log entry with type='workout'
    // Calculate volume (sets × reps × weight)
    // Award points based on category (Health)
  }
  ```

---

## Data Flow & State Management

### State Slice (Zustand)

```typescript
// state/slices/todaySlice.ts

interface TodaySlice {
  // Must-Wins
  mustWins: [string, string, string];
  setMustWins: (taskIds: [string, string, string]) => void;
  
  // Schedule
  schedule: Map<string, ScheduledTask>;
  scheduleTask: (timeSlot: string, taskId: string) => void;
  rescheduleTask: (fromSlot: string, toSlot: string) => void;
  removeFromSchedule: (timeSlot: string) => void;
  
  // Timer
  activeTimer?: {
    taskId: string;
    startedAt: string;
    estimateMinutes: number;
    logId: string;  // Log entry ID for this session
  };
  startTimer: (taskId: string) => void;
  pauseTimer: () => void;
  stopTimer: () => void;
  
  // Task Pool
  poolFilters: PoolFilters;
  setPoolFilters: (filters: Partial<PoolFilters>) => void;
  currentEnergy: EnergyLevel;
  setCurrentEnergy: (energy: EnergyLevel) => void;
  
  // Quick Add
  quickAddForm: QuickAddForm;
  setQuickAddField: (field: keyof QuickAddForm, value: any) => void;
  submitQuickAdd: () => Promise<void>;
  
  // Workout
  workoutSession?: WorkoutSession;
  startWorkout: (exercise: string) => void;
  logSet: (weight: number, reps: number) => void;
  completeWorkout: () => Promise<void>;
}
```

### Database Queries

**On Page Load:**
```sql
-- Get today's must-wins
SELECT * FROM must_wins WHERE day_iso = '2025-10-06';

-- Get today's schedule
SELECT * FROM schedule WHERE day_iso = '2025-10-06';

-- Get unscheduled tasks (for pool)
SELECT t.* FROM tasks t
LEFT JOIN schedule s ON t.id = s.task_id AND s.day_iso = '2025-10-06'
WHERE s.id IS NULL
  AND t.status IN ('todo', 'doing')
  AND t.deleted_at IS NULL
ORDER BY t.priority DESC, t.due ASC
LIMIT 20;
```

**On Task Completion:**
```sql
-- Mark task done
UPDATE tasks SET status = 'done', updated_at = NOW() WHERE id = ?;

-- Recompute goal progress
SELECT SUM(points) FROM tasks 
WHERE goal_id = ? AND status = 'done' AND deleted_at IS NULL;

-- Update goal
UPDATE goals SET progress_points = ? WHERE id = ?;

-- Check milestone progress
SELECT SUM(progress_points) FROM goals WHERE milestone_id = ?;
```

---

## Interactions & Edge Cases

### Drag & Drop Validation

**Valid:**
- Drag unscheduled task → empty timeline slot ✅
- Drag scheduled task → empty timeline slot ✅
- Drag task from pool → must-win slot (replaces existing) ✅

**Invalid:**
- Drag task → occupied slot ❌ (show tooltip: "Slot occupied")
- Drag task → fixed event slot (e.g., Lunch) ❌ (show tooltip: "Fixed event")
- Drag task with 90min estimate → last slot of day ❌ (show tooltip: "Not enough time")

### Timer States & Transitions

```
Scheduled → [Start Timer] → In Progress
In Progress → [Pause Timer] → Paused
Paused → [Resume Timer] → In Progress
In Progress → [Stop Timer] → Completed (creates Log)
Completed → [Mark Done] → Task status = 'done'
```

**Timer UX:**
- Countdown shows in slot (e.g., "23:45 remaining")
- Browser notification at 5min, 1min, 0min
- Pause persists across app restarts
- Log entry created on stop (with actual duration, not just estimate)

### Energy Auto-Matching

**Morning (6am-12pm):**
- Pool defaults to High energy tasks first
- User can override with filters

**Afternoon (12pm-6pm):**
- Pool defaults to Med/High energy tasks

**Evening (6pm-11pm):**
- Pool defaults to Low/Med energy tasks
- High energy tasks hidden by default (but can be shown via filter)

### Must-Wins Enforcement

**Rules:**
- Cannot end day with <3 must-wins set
- If user tries to close app without setting must-wins, show modal:
  ```
  ⚠️ Set Your 3 Must-Wins
  
  You haven't set your 3 must-wins for today.
  These are the 3 tasks that matter most.
  
  [Suggested Must-Wins: ...]
  
  [Accept Suggestions] [Pick Manually] [Skip (not recommended)]
  ```

---

## Performance Considerations

### Virtualization
- If task pool >100 tasks, use `react-window` or similar
- Render only visible timeline slots

### Debouncing
- Filter changes: 300ms debounce
- Drag preview: 60fps target
- Timer updates: 1s interval (not per-frame)

### Caching
- Cache filtered task pool for 5 minutes
- Invalidate cache on:
  - New task created
  - Task status changed
  - Task scheduled/unscheduled

### Real-Time Updates
- If timer is active, block app sleep/idle
- Use Tauri's `prevent_app_sleep` API

---

## Acceptance Tests

### Happy Path
1. ✅ Open app → see suggested 3 must-wins → accept → must-wins pinned
2. ✅ Drag task from pool → timeline slot → task appears in slot
3. ✅ Click task in slot → start timer → countdown visible → stop timer → log created
4. ✅ Quick add task → fill fields → click Add → task appears in pool
5. ✅ Complete must-win → checkbox animates → +5 points toast → progress bar updates

### Edge Cases
1. ✅ Drag 90min task → last hour slot → error tooltip: "Not enough time"
2. ✅ Try to schedule 2 tasks in same slot → error tooltip: "Slot occupied"
3. ✅ Close app with timer running → reopen → timer resumes with correct time
4. ✅ Complete all 3 must-wins → celebration modal: "All must-wins completed! 🎉"
5. ✅ Auto-fill with vague prompt → AI makes best guess → user can edit

---

## File Targets

### UI Components
- `src/features/today/ui/TodayPage.tsx` — Main page layout
- `src/features/today/ui/MustWins.tsx` — Must-wins section
- `src/features/today/ui/Timeline.tsx` — Hour slot timeline
- `src/features/today/ui/TaskPool.tsx` — Filtered task pool
- `src/features/today/ui/QuickAdd.tsx` — Quick add form
- `src/features/today/ui/WorkoutLog.tsx` — Workout logging

### Logic (Pure Functions)
- `src/features/today/logic/schedule.ts` — Scheduling validation
- `src/features/today/logic/filterTasks.ts` — Task pool filtering
- `src/features/today/logic/recommendMustWins.ts` — Must-win suggestion
- `src/features/today/logic/autoFill.ts` — AI-powered task extraction
- `src/features/today/logic/workoutLog.ts` — Workout log creation

### State
- `src/state/slices/todaySlice.ts` — Today page state

### Database
- `src/infra/db/migrations/0002_today.sql` — schedule, must_wins, logs tables

---

## Out of Scope (v1)

- ❌ Week view
- ❌ Calendar sync (Google Calendar, etc.)
- ❌ Recurring tasks
- ❌ Task dependencies
- ❌ Team/shared schedules
- ❌ Advanced workout tracking (sets/reps history graphs)

**These can be added in v2 after core Today page is proven.**

