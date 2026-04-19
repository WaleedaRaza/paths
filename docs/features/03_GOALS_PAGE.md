# Feature: Goals Page (Hierarchical Goal Management)

## Purpose & User Outcome

**Goal:** See the complete hierarchy (Milestone → Goals → Tasks) at a glance. Attach tasks to goals, track progress, reorder priorities.

**Success Criteria:**
- ✅ Tree view shows full hierarchy with progress bars
- ✅ Click goal → see all linked tasks
- ✅ Attach/detach tasks easily
- ✅ Real-time progress updates when tasks complete
- ✅ Reorder goals within milestones

---

## User Stories

1. **Goal Overview:** I open Goals page, see "Graduate WGU" milestone expanded with 8 goals, 3 completed, 5 in progress.
2. **Deep Goal View:** I click "Pass D426" goal, modal opens showing 5 tasks (3 done, 2 todo), progress bar at 60%.
3. **Attach Task:** I click "Attach Task" in goal modal, search for "D426 Quiz Prep", attach it, see progress update.
4. **Reorder Goals:** I drag "Pass D315" above "Pass D427" to prioritize it, order persists.
5. **Goal Templates:** I click "Add Goal from Template", select "WGU Course Template", it creates a goal with pre-filled tasks.

---

## Page Layout (Tree Structure)

```
┌─────────────────────────────────────────────────────────────┐
│ Goals                                    [+ New Goal] [Sort] │
├─────────────────────────────────────────────────────────────┤
│ Search: [_______________] [🔍]                              │
│ Filters: [Category: All ▼] [Status: Active ▼]              │
├─────────────────────────────────────────────────────────────┤
│ 🎓 School (3 goals, 45% complete)       [Expand ▼] [Edit]  │
│ ├─ Graduate WGU                          [500pts, 45%]      │
│ │  ├─ ✅ Pass D426 (75/75pts) [100%]    [3 tasks done]     │
│ │  ├─ ✅ Pass D427 (75/75pts) [100%]    [3 tasks done]     │
│ │  ├─ 🔄 Pass D315 (45/75pts) [60%]     [2/5 tasks]        │
│ │  ├─ ⏳ Pass D276 (0/75pts) [0%]       [0 tasks]          │
│ │  ├─ ⏳ Pass D197 (0/75pts) [0%]       [0 tasks]          │
│ │  └─ [3 more goals...]                                     │
│ ├─ GRE Prep (30/100pts) [30%]           [1 goal]           │
│ │  └─ 🔄 GRE Verbal (30/50pts) [60%]    [2/3 tasks]        │
│ └─ [+ Add Goal]                                             │
│                                                             │
│ 🚀 Projects (2 goals, 20% complete)     [Expand ▼]         │
│ ├─ Ship Petform v2 (20/100pts) [20%]    [1 milestone]      │
│ │  ├─ 🔄 Auth System (20/40pts) [50%]   [2/4 tasks]        │
│ │  ├─ ⏳ Payment Integration (0/40pts)  [0 tasks]          │
│ │  └─ ⏳ Admin Dashboard (0/20pts)      [0 tasks]          │
│ └─ Launch MMAmania v1 (0/150pts) [0%]   [0 goals]          │
│                                                             │
│ 💪 Health (1 goal, 80% complete)        [Expand ▼]         │
│ └─ 4-Day Split Consistency (80/100pts)  [4/5 weeks]        │
│    ├─ ✅ Week 1 Complete (+20pts)                          │
│    ├─ ✅ Week 2 Complete (+20pts)                          │
│    ├─ ✅ Week 3 Complete (+20pts)                          │
│    ├─ ✅ Week 4 Complete (+20pts)                          │
│    └─ 🔄 Week 5 (Day 2/4)                                  │
└─────────────────────────────────────────────────────────────┘
```

---

## Goal Modal (Deep Interaction)

```
┌─────────────────────────────────────────────────────────────┐
│ Pass D426 Course                                    [✕ Close]│
├─────────────────────────────────────────────────────────────┤
│ School • 3 CUs • Due: Dec 15 • 60% Complete                 │
│ Milestone: Graduate WGU → Term 2 Progress                   │
│                                                             │
│ ┌─ Details ────────────────────────────────────────────────┐│
│ │ Title: [Pass D426 Course_______________________]        ││
│ │ Category: [School ▼]                                    ││
│ │ Milestone: [Graduate WGU ▼]                             ││
│ │ Target Points: [75]  (auto-calculated from tasks)       ││
│ │ Due Date: [Dec 15, 2025]                                ││
│ │ Status: [Active ▼] [Completed] [Archived]              ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ ┌─ Progress (45/75 points, 60%) ──────────────────────────┐│
│ │ [████████████░░░░░░░░] 60%                              ││
│ │ ─────────────────────────────────────────────────────── ││
│ │ Points Breakdown:                                       ││
│ │ • D426 Quiz Prep: +5 (done)                             ││
│ │ • D426 Reading: +10 (done)                              ││
│ │ • D426 Practice: +5 (done)                              ││
│ │ • D426 Project: +25 (doing, 10/25 from subtasks)        ││
│ │ • D426 Exam: +30 (todo)                                 ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ ┌─ Linked Tasks (5) ───────────────────────────────────────┐│
│ │ ✅ D426 Quiz Prep (25min, +5pts) [Done 2 days ago]      ││
│ │ ✅ D426 Reading (60min, +10pts) [Done 1 week ago]       ││
│ │ ✅ D426 Practice (30min, +5pts) [Done 3 days ago]       ││
│ │ 🔄 D426 Final Project (120min, +25pts) [10/25 pts]      ││
│ │    [2/5 subtasks] [Resume] [View]                       ││
│ │ ⏳ D426 Exam (90min, +30pts) [Not started]              ││
│ │ ─────────────────────────────────────────────────────── ││
│ │ [+ Attach Task] [Create New Task] [Reorder]             ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ ┌─ Milestone Impact ───────────────────────────────────────┐│
│ │ This goal contributes 75/500 pts (15%) to:              ││
│ │ Graduate WGU [████░░░░░░░░░░░░░░░░] 45% (225/500 pts)  ││
│ │ Current: +45 pts earned                                 ││
│ │ Remaining: +30 pts to unlock                            ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ ┌─ Notes ──────────────────────────────────────────────────┐│
│ │ [Focus on database normalization. Weak spot for exam.]  ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ [Mark Complete] [Archive] [Delete] [Export]                │
└─────────────────────────────────────────────────────────────┘
```

---

## Attach Task Modal

**Trigger:** Click "[+ Attach Task]" in Goal Modal

```
┌─────────────────────────────────────────────────────────────┐
│ Attach Task to Goal: Pass D426 Course              [✕ Close]│
├─────────────────────────────────────────────────────────────┤
│ Search: [_______________] [🔍]                              │
│ Filter: [Category: School ▼] [Status: Todo ▼]              │
│ ─────────────────────────────────────────────────────────── │
│ Available Tasks (12):                                       │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ ☐ D426 Review Chapter 4 (15min, +3pts)                 │ │
│ │   School • Low Energy • Due: Tomorrow                   │ │
│ └─────────────────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ ☐ D426 Practice Problems (30min, +5pts)                │ │
│ │   School • Med Energy • Due: This Week                  │ │
│ └─────────────────────────────────────────────────────────┘ │
│ [10 more tasks...]                                          │
│ ─────────────────────────────────────────────────────────── │
│ Selected: 2 tasks                                           │
│ [Attach Selected] [Cancel]                                  │
└─────────────────────────────────────────────────────────────┘
```

---

## Goal Templates

**Trigger:** Click "[+ Add Goal]" → "From Template"

```
┌─────────────────────────────────────────────────────────────┐
│ Create Goal from Template                           [✕ Close]│
├─────────────────────────────────────────────────────────────┤
│ 📚 WGU Course Template                                      │
│ • Creates goal with target: 75 points                       │
│ • Auto-generates 5 tasks:                                   │
│   - Quiz Prep (25min, +5pts)                                │
│   - Reading (60min, +10pts)                                 │
│   - Practice (30min, +5pts)                                 │
│   - Final Project (120min, +25pts)                          │
│   - Exam (90min, +30pts)                                    │
│ [Use This Template]                                         │
│ ─────────────────────────────────────────────────────────── │
│ 🚀 Project Launch Template                                  │
│ • Target: 100 points                                        │
│ • Tasks: MVP Definition, Design, Build, Test, Deploy       │
│ [Use This Template]                                         │
│ ─────────────────────────────────────────────────────────── │
│ 💪 Fitness Goal Template                                    │
│ • Target: 100 points (20pts/week × 5 weeks)                │
│ • Tasks: Weekly workout tracking                            │
│ [Use This Template]                                         │
│ ─────────────────────────────────────────────────────────── │
│ [Custom (Blank Goal)]                                       │
└─────────────────────────────────────────────────────────────┘
```

---

## State Management

```typescript
// state/slices/goalsSlice.ts

interface GoalsSlice {
  // Data
  goals: Map<string, Goal>;
  
  // Tree View
  expandedMilestones: Set<string>;
  toggleMilestone: (milestoneId: string) => void;
  
  // CRUD
  createGoal: (data: CreateGoalData) => Promise<string>;
  updateGoal: (id: string, updates: Partial<Goal>) => Promise<void>;
  deleteGoal: (id: string) => Promise<void>;
  duplicateGoal: (id: string) => Promise<string>;
  
  // Templates
  createFromTemplate: (templateId: string, milestoneId: string) => Promise<string>;
  
  // Task Linking
  attachTask: (goalId: string, taskId: string) => Promise<void>;
  detachTask: (goalId: string, taskId: string) => Promise<void>;
  attachMultipleTasks: (goalId: string, taskIds: string[]) => Promise<void>;
  
  // Ordering
  reorderGoals: (milestoneId: string, goalIds: string[]) => Promise<void>;
  
  // Progress
  recomputeProgress: (goalId: string) => Promise<void>;
  
  // Modal
  activeGoalId?: string;
  openGoalModal: (goalId: string) => void;
  closeGoalModal: () => void;
}
```

---

## Database Queries

### Tree View Query
```sql
-- Get all milestones with goal counts
SELECT 
  m.*,
  c.name as category_name,
  c.color as category_color,
  COUNT(DISTINCT g.id) as goal_count,
  SUM(g.progress_points) as total_progress,
  SUM(g.points_target) as total_target
FROM milestones m
LEFT JOIN categories c ON m.category_id = c.id
LEFT JOIN goals g ON m.id = g.milestone_id AND g.deleted_at IS NULL
WHERE m.deleted_at IS NULL
GROUP BY m.id
ORDER BY m.due ASC NULLS LAST;

-- Get goals for expanded milestone
SELECT 
  g.*,
  COUNT(DISTINCT gt.task_id) as task_count,
  SUM(CASE WHEN t.status = 'done' THEN 1 ELSE 0 END) as tasks_completed
FROM goals g
LEFT JOIN goal_tasks gt ON g.id = gt.goal_id
LEFT JOIN tasks t ON gt.task_id = t.id AND t.deleted_at IS NULL
WHERE g.milestone_id = $milestoneId
  AND g.deleted_at IS NULL
GROUP BY g.id
ORDER BY g.order ASC;
```

### Goal Modal Query
```sql
-- Get full goal with relations
SELECT 
  g.*,
  m.title as milestone_title,
  m.target_points as milestone_target,
  m.progress_points as milestone_progress
FROM goals g
LEFT JOIN milestones m ON g.milestone_id = m.id
WHERE g.id = $goalId;

-- Get linked tasks with progress
SELECT 
  t.*,
  c.color as category_color,
  COUNT(s.id) as subtask_count,
  SUM(CASE WHEN s.done = 1 THEN s.points ELSE 0 END) as subtask_points
FROM tasks t
INNER JOIN goal_tasks gt ON t.id = gt.task_id
LEFT JOIN categories c ON t.category_id = c.id
LEFT JOIN subtasks s ON t.id = s.task_id
WHERE gt.goal_id = $goalId
  AND t.deleted_at IS NULL
GROUP BY t.id
ORDER BY t.status ASC, t.priority ASC;
```

### Attach Task Query
```sql
-- Get available tasks (unattached or in same category)
SELECT 
  t.*,
  c.name as category_name,
  c.color as category_color
FROM tasks t
LEFT JOIN categories c ON t.category_id = c.id
LEFT JOIN goal_tasks gt ON t.id = gt.task_id AND gt.goal_id = $goalId
WHERE gt.id IS NULL  -- Not already attached
  AND t.deleted_at IS NULL
  AND ($categoryId IS NULL OR t.category_id = $categoryId)
  AND t.status IN ('todo', 'doing')
ORDER BY t.due ASC NULLS LAST, t.priority ASC
LIMIT 50;
```

---

## Progress Recomputation Logic

```typescript
// features/goals/logic/progress.ts

export async function recomputeGoalProgress(
  goalId: string,
  db: Database
): Promise<{ points: number; percent: number }> {
  // 1. Get all tasks linked to this goal
  const tasks = await db.query(`
    SELECT t.*, gt.goal_id
    FROM tasks t
    INNER JOIN goal_tasks gt ON t.id = gt.task_id
    WHERE gt.goal_id = ? AND t.deleted_at IS NULL
  `, [goalId]);
  
  // 2. Sum points from completed tasks
  let progressPoints = 0;
  for (const task of tasks) {
    if (task.status === 'done') {
      // Base task points
      progressPoints += task.points;
      
      // Add subtask points
      const subtasks = await db.query(`
        SELECT SUM(points) as total
        FROM subtasks
        WHERE task_id = ? AND done = 1
      `, [task.id]);
      
      progressPoints += subtasks[0]?.total || 0;
    } else {
      // For in-progress tasks, count completed subtasks only
      const subtasks = await db.query(`
        SELECT SUM(points) as total
        FROM subtasks
        WHERE task_id = ? AND done = 1
      `, [task.id]);
      
      progressPoints += subtasks[0]?.total || 0;
    }
  }
  
  // 3. Get goal target
  const goal = await db.query(`
    SELECT points_target FROM goals WHERE id = ?
  `, [goalId]);
  
  const target = goal[0].points_target || 100;
  const percent = Math.min(100, Math.round((progressPoints / target) * 100));
  
  // 4. Update goal
  await db.query(`
    UPDATE goals 
    SET progress_points = ?, updated_at = ?
    WHERE id = ?
  `, [progressPoints, new Date().toISOString(), goalId]);
  
  // 5. Trigger milestone recomputation
  const milestoneId = goal[0].milestone_id;
  if (milestoneId) {
    await recomputeMilestoneProgress(milestoneId, db);
  }
  
  return { points: progressPoints, percent };
}
```

---

## Acceptance Tests

### Happy Path
1. ✅ Expand milestone → see all goals with progress bars
2. ✅ Click goal → modal opens with linked tasks
3. ✅ Attach task → task appears in goal, progress updates
4. ✅ Complete task in goal → goal progress increases
5. ✅ Create from template → goal + tasks created

### Edge Cases
1. ✅ Delete goal with tasks → tasks unlinked (not deleted)
2. ✅ Attach already-attached task → error: "Task already linked"
3. ✅ Detach last task → goal remains but shows 0% progress
4. ✅ Goal reaches target → auto-mark as completed
5. ✅ Drag goal to different milestone → milestone progress updates

---

## File Targets

- `src/features/goals/ui/GoalsPage.tsx`
- `src/features/goals/ui/GoalTree.tsx`
- `src/features/goals/ui/GoalModal.tsx`
- `src/features/goals/ui/AttachTaskModal.tsx`
- `src/features/goals/ui/GoalTemplates.tsx`
- `src/features/goals/logic/progress.ts`
- `src/features/goals/logic/templates.ts`
- `src/state/slices/goalsSlice.ts`
- `src/infra/db/migrations/0004_goals.sql`

