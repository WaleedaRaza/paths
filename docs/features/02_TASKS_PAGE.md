# Feature: Tasks Page (Deep Task Management)

## Purpose & User Outcome

**Goal:** Central hub for all task management. Switch between List/Kanban/Calendar views, deep-dive into tasks via modal, bulk operations, visualize progress.

**Success Criteria:**
- ✅ See all tasks across all views (List/Kanban/Calendar)
- ✅ Open task → see subtasks, split tasks, attach to goals
- ✅ Bulk select & update multiple tasks
- ✅ See real-time points roll-up when completing subtasks
- ✅ Fast search/filter (response <100ms)

---

## User Stories

1. **Task Overview:** I open Tasks page, see all my todo tasks in list view, filter to "School" category, see only WGU tasks.
2. **Deep Task Edit:** I click "D426 Quiz Prep", modal opens, I see 3 subtasks, I add a 4th subtask "Review mistakes", mark 2 done, see task points update from 5 → 7.
3. **AI Task Split:** I click "Fix Petform auth bug", click "Split into subtasks", AI generates 6 subtasks (research, plan, code, test, PR, deploy), I accept and edit.
4. **Kanban Workflow:** I switch to Kanban view, drag "LeetCode Array Problem" from Todo → Doing, status updates immediately.
5. **Bulk Update:** I select 5 tasks, click "Bulk Update", change all to "High priority", see changes reflected.

---

## Page Layout (Three Views)

### List View (Default)

```
┌─────────────────────────────────────────────────────────────┐
│ Tasks                                    [List][Kanban][Cal] │
├─────────────────────────────────────────────────────────────┤
│ Search: [_______________] [🔍]                              │
│ Filters: [Status: All ▼] [Energy: All ▼] [Time: All ▼]     │
│          [Category: All ▼] [Goal: All ▼]                    │
│ Sort: [Priority ▼] [Due Date] [Energy] [Category]          │
├─────────────────────────────────────────────────────────────┤
│ 🔥 Must-Wins Today (3)                   [✓ 2/3 completed] │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ ✅ D426 Quiz Prep                                       │ │
│ │ School • 25min • High • Due: Today • +5 pts • D426     │ │
│ │ [3/3 subtasks] [View] [Edit] [Delete]                  │ │
│ └─────────────────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ 🔄 Petform Auth Fix                                     │ │
│ │ Projects • 30min • Med • Due: Wed • +10 pts • Petform  │ │
│ │ [2/4 subtasks] [Resume Timer] [View]                   │ │
│ └─────────────────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ ⏳ Morning Workout                                      │ │
│ │ Health • 50min • Med • Due: Today • +5 pts             │ │
│ │ [0/1 subtasks] [Start Timer] [View]                    │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ 📋 In Progress (2)                                          │
│ [Similar task cards...]                                     │
│                                                             │
│ ⏳ Queued (8)                                               │
│ [Similar task cards...]                                     │
│                                                             │
│ [Bulk Select Mode] [+ New Task]                            │
└─────────────────────────────────────────────────────────────┘
```

### Kanban View

```
┌─────────────────────────────────────────────────────────────┐
│ Tasks                                    [List][Kanban][Cal] │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ⏳ Todo (8)         🔄 Doing (2)        ✅ Done (5)        │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐   │
│  │ D426 Quiz    │   │ Petform Auth │   │ Morning      │   │
│  │ School • 25m │   │ Projects•30m │   │ Workout      │   │
│  │ [Drag]       │   │ [2/4 subs]   │   │ ✓ Done       │   │
│  └──────────────┘   └──────────────┘   └──────────────┘   │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐   │
│  │ GRE Vocab    │   │ LeetCode     │   │ Email Prof   │   │
│  │ School • 15m │   │ DSA • 45m    │   │ ✓ Done       │   │
│  └──────────────┘   └──────────────┘   └──────────────┘   │
│  [8 more...]        [Empty]           [3 more...]        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Calendar View

```
┌─────────────────────────────────────────────────────────────┐
│ Tasks                                    [List][Kanban][Cal] │
├─────────────────────────────────────────────────────────────┤
│               October 2025                  [< Today >]     │
│ ┌───────────────────────────────────────────────────────────┐│
│ │ Mon  Tue  Wed  Thu  Fri  Sat  Sun                        ││
│ ├───────────────────────────────────────────────────────────┤│
│ │  1    2    3    4    5    6    7                         ││
│ │       (2)  (1)  (3)  (1)  (0)  (0)                       ││
│ │  8    9   10   11   12   13   14                         ││
│ │ (1)  (2)  (4)  (2)  (1)  (0)  (0)                        ││
│ │ 15   16   17   18   19   20   21                         ││
│ │ (0)  (1)  (2)  (1)  (3)  (0)  (0)                        ││
│ └───────────────────────────────────────────────────────────┘│
│                                                             │
│ Today (Oct 6): 4 tasks                                      │
│ • D426 Quiz Prep (25min, High, School)                     │
│ • Petform Auth Fix (30min, Med, Projects)                  │
│ • Morning Workout (50min, Med, Health)                     │
│ • GRE Vocab (15min, Low, School)                           │
└─────────────────────────────────────────────────────────────┘
```

---

## Task Modal (Deep Interaction)

```
┌─────────────────────────────────────────────────────────────┐
│ D426 Quiz Prep                                      [✕ Close]│
├─────────────────────────────────────────────────────────────┤
│ School • 25min • High Energy • Due: Today (10/6)            │
│ Goal: D426 Course → Milestone: Graduate WGU                 │
│                                                             │
│ ┌─ Details ────────────────────────────────────────────────┐│
│ │ Title: [D426 Quiz Prep_________________________]        ││
│ │ Time: [5m] [15m] [25m] [50m] [90m]  Selected: 25m      ││
│ │ Energy: [🔋High] [⚡Med] [🔌Low]  Selected: High       ││
│ │ Category: [School ▼]                                    ││
│ │ Goal: [D426 Course ▼]                                   ││
│ │ Priority: [1] [2] [3] [4] [5]  Selected: 1             ││
│ │ Due: [Today ▼] [Tomorrow] [This Week] [Custom]         ││
│ │ Labels: [authentication] [backend] [+Add]               ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ ┌─ Subtasks (3/3 completed) ──────────────────────────────┐│
│ │ ✅ Review Chapter 3 (research, 5min, +1pt)              ││
│ │ ✅ Practice Quiz 1 (testing, 15min, +3pts)              ││
│ │ ✅ Review Mistakes (generic, 5min, +1pt)                ││
│ │ ─────────────────────────────────────────────────────── ││
│ │ [+ Add Subtask]  [🤖 Split into Subtasks (AI)]         ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ ┌─ Points & Progress ──────────────────────────────────────┐│
│ │ Base Points: +5                                         ││
│ │ Subtask Bonus: +5 (3 subtasks × +1-3 each)             ││
│ │ Total: +10 points earned                                ││
│ │ ─────────────────────────────────────────────────────── ││
│ │ Goal Progress: D426 Course [██████████░░] 60% (45/75)  ││
│ │ Milestone: Graduate WGU [████░░░░░░░░] 45% (225/500)   ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ ┌─ Notes ──────────────────────────────────────────────────┐│
│ │ [Focus on database normalization, that's the weak spot] ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ ┌─ Activity Log ───────────────────────────────────────────┐│
│ │ • Completed subtask "Review Mistakes" (2min ago)        ││
│ │ • Completed subtask "Practice Quiz 1" (18min ago)       ││
│ │ • Started timer (45min ago)                             ││
│ │ • Created task (2 hours ago)                            ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ [Start Timer] [Mark Complete] [Duplicate] [Archive] [Delete]│
└─────────────────────────────────────────────────────────────┘
```

---

## AI Task Splitting

**Trigger:** Click "🤖 Split into Subtasks (AI)" in Task Modal

**UI Flow:**
1. Modal opens with loading state
2. AI analyzes task title, category, estimate
3. Generates 3-6 subtasks with:
   - Title
   - Kind (code_planning, research, etc.)
   - Estimate (auto-distributed from total)
   - Points (based on complexity)
4. User can:
   - Accept all
   - Edit individual subtasks
   - Remove subtasks
   - Regenerate

**Example:**

Input:
```
Task: "Fix Petform authentication bug"
Category: Projects
Estimate: 90min
```

AI Output:
```
Subtasks:
1. Research auth libraries (research, 10min, +2pts)
2. Identify the bug (debugging, 15min, +2pts)
3. Write test case (testing, 15min, +3pts)
4. Implement fix (snippet, 30min, +5pts)
5. Test fix (testing, 10min, +2pts)
6. Create PR (generic, 10min, +1pt)
```

---

## Bulk Operations

**Trigger:** Click "Bulk Select Mode" button

**UI Changes:**
- Checkboxes appear on all task cards
- Floating action bar appears at bottom
- Can select multiple tasks (shift-click for range)

**Available Bulk Actions:**
- **Change Status:** todo/doing/done/blocked/snoozed
- **Change Energy:** low/med/high
- **Change Priority:** 1-5
- **Add Label:** Add same label to all
- **Change Category:** Move to different category
- **Change Goal:** Link to different goal
- **Archive:** Soft delete all selected
- **Delete:** Hard delete all selected (confirmation required)

**Bulk Action Bar:**
```
┌─────────────────────────────────────────────────────────────┐
│ 5 tasks selected                                            │
│ [Change Status ▼] [Change Energy ▼] [Add Label ▼]          │
│ [Change Goal ▼] [Archive] [Delete] [Cancel]                │
└─────────────────────────────────────────────────────────────┘
```

---

## State Management

```typescript
// state/slices/tasksSlice.ts

interface TasksSlice {
  // Data
  tasks: Map<string, Task>;
  
  // Views
  currentView: 'list' | 'kanban' | 'calendar';
  setView: (view: 'list' | 'kanban' | 'calendar') => void;
  
  // Filters
  filters: TaskFilters;
  setFilters: (filters: Partial<TaskFilters>) => void;
  
  // Sort
  sortBy: 'priority' | 'due' | 'energy' | 'category';
  setSortBy: (sortBy: TasksSlice['sortBy']) => void;
  
  // CRUD
  createTask: (data: CreateTaskData) => Promise<string>;
  updateTask: (id: string, updates: Partial<Task>) => Promise<void>;
  deleteTask: (id: string, soft?: boolean) => Promise<void>;
  duplicateTask: (id: string) => Promise<string>;
  
  // Subtasks
  addSubtask: (taskId: string, data: CreateSubtaskData) => Promise<string>;
  updateSubtask: (id: string, updates: Partial<Subtask>) => Promise<void>;
  deleteSubtask: (id: string) => Promise<void>;
  toggleSubtask: (id: string) => Promise<void>;
  reorderSubtasks: (taskId: string, subtaskIds: string[]) => Promise<void>;
  
  // AI
  splitTask: (taskId: string) => Promise<Subtask[]>;
  
  // Bulk
  bulkUpdate: (taskIds: string[], updates: Partial<Task>) => Promise<void>;
  
  // Selection
  selectedTaskIds: Set<string>;
  toggleSelection: (taskId: string) => void;
  selectRange: (startId: string, endId: string) => void;
  clearSelection: () => void;
  
  // Modal
  activeTaskId?: string;
  openTaskModal: (taskId: string) => void;
  closeTaskModal: () => void;
}

interface TaskFilters {
  status: TaskStatus[];
  energy: EnergyLevel[];
  timeEstimate: number[];
  categories: string[];
  goals: string[];
  labels: string[];
  dueDateRange?: { start: string; end: string; };
}
```

---

## Database Queries

### List View Query
```sql
SELECT 
  t.*,
  c.name as category_name,
  c.color as category_color,
  g.title as goal_title,
  COUNT(s.id) as subtask_count,
  SUM(CASE WHEN s.done = 1 THEN 1 ELSE 0 END) as subtasks_completed
FROM tasks t
LEFT JOIN categories c ON t.category_id = c.id
LEFT JOIN goals g ON t.goal_id = g.id
LEFT JOIN subtasks s ON t.id = s.task_id
WHERE t.deleted_at IS NULL
  AND t.status IN ('todo', 'doing', 'blocked')
  AND ($status IS NULL OR t.status = $status)
  AND ($energy IS NULL OR t.energy = $energy)
  AND ($category IS NULL OR t.category_id = $category)
GROUP BY t.id
ORDER BY 
  CASE WHEN $sortBy = 'priority' THEN t.priority END ASC,
  CASE WHEN $sortBy = 'due' THEN t.due END ASC,
  CASE WHEN $sortBy = 'energy' THEN t.energy END ASC,
  CASE WHEN $sortBy = 'category' THEN c.name END ASC
LIMIT 100;
```

### Kanban View Query
```sql
-- Get counts per status column
SELECT status, COUNT(*) as count
FROM tasks
WHERE deleted_at IS NULL
GROUP BY status;

-- Get tasks for a specific column (lazy load)
SELECT t.*, c.color, g.title as goal_title
FROM tasks t
LEFT JOIN categories c ON t.category_id = c.id
LEFT JOIN goals g ON t.goal_id = g.id
WHERE t.status = $status
  AND t.deleted_at IS NULL
ORDER BY t.priority ASC, t.due ASC;
```

### Task Modal Query
```sql
-- Get full task with relations
SELECT 
  t.*,
  c.name as category_name,
  c.color as category_color,
  g.title as goal_title,
  g.progress_points as goal_progress,
  g.points_target as goal_target,
  m.title as milestone_title,
  m.progress_points as milestone_progress,
  m.target_points as milestone_target
FROM tasks t
LEFT JOIN categories c ON t.category_id = c.id
LEFT JOIN goals g ON t.goal_id = g.id
LEFT JOIN milestones m ON g.milestone_id = m.id
WHERE t.id = $taskId;

-- Get subtasks
SELECT * FROM subtasks
WHERE task_id = $taskId
ORDER BY order ASC;

-- Get activity log
SELECT * FROM logs
WHERE task_id = $taskId
ORDER BY created_at DESC
LIMIT 10;
```

---

## Performance Considerations

### Virtualization
- List view: Use `react-window` if >100 tasks
- Kanban: Lazy load columns (fetch when visible)
- Calendar: Load only visible month

### Search
- Debounce search input: 300ms
- Use full-text search index on `tasks.title`
- Cache search results for 1 minute

### Real-Time Updates
- When subtask toggled → recompute task points immediately
- When task status changed → invalidate kanban counts
- Use optimistic UI updates (update locally, sync to DB in background)

---

## Acceptance Tests

### Happy Path
1. ✅ Create task → appears in list
2. ✅ Open modal → add 3 subtasks → complete 2 → see +7 points
3. ✅ AI split task → generates 5 subtasks → accept → subtasks created
4. ✅ Switch to Kanban → drag task todo→doing → status updates
5. ✅ Bulk select 5 tasks → change priority → all updated

### Edge Cases
1. ✅ Delete task with subtasks → subtasks also deleted
2. ✅ Complete last subtask → task auto-marks as done
3. ✅ Duplicate task → copies subtasks + settings
4. ✅ Filter to 0 results → show empty state with "Create Task" CTA
5. ✅ AI split fails → show error, allow manual subtask creation

---

## File Targets

- `src/features/tasks/ui/TasksPage.tsx`
- `src/features/tasks/ui/TaskModal.tsx`
- `src/features/tasks/ui/ListView.tsx`
- `src/features/tasks/ui/KanbanView.tsx`
- `src/features/tasks/ui/CalendarView.tsx`
- `src/features/tasks/ui/BulkActionBar.tsx`
- `src/features/tasks/logic/rollup.ts`
- `src/features/tasks/logic/split.ts`
- `src/state/slices/tasksSlice.ts`
- `src/infra/db/migrations/0003_tasks_subtasks.sql`

