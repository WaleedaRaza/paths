# Feature: Milestones Page (Big Rock Tracking)

## Purpose & User Outcome

**Goal:** Visual dashboard of all major life milestones. See progress at a glance, celebrate completions, track velocity.

**Success Criteria:**
- ✅ Card grid shows all milestones with progress bars
- ✅ Click milestone → deep view with goals breakdown
- ✅ Completion triggers celebration animation
- ✅ Velocity tracking shows if you're on pace
- ✅ Category-colored cards for quick scanning

---

## User Stories

1. **Milestone Dashboard:** I open Milestones page, see 5 active milestones across categories (School, Projects, Health), all with progress bars.
2. **Deep Milestone View:** I click "Graduate WGU", modal opens showing 8 goals, 3 completed, velocity tracking shows I'm on pace.
3. **Milestone Completion:** I complete the last goal in "Ship Petform v2", milestone auto-marks complete, confetti animation plays, +100 bonus points awarded.
4. **Velocity Insight:** I see "Graduate WGU" is at 45% with 8 months left (target: June 2025), velocity shows 28pts/month (need 34pts/month), warning badge appears.
5. **Category Filtering:** I filter to "School" milestones only, see Graduate WGU and GRE Prep.

---

## Page Layout (Card Grid)

```
┌─────────────────────────────────────────────────────────────┐
│ Milestones                        [+ New] [Filter: All ▼]   │
├─────────────────────────────────────────────────────────────┤
│ ┌──────────────────────────┐ ┌──────────────────────────┐  │
│ │ 🎓 Graduate WGU          │ │ 🚀 Ship Petform v2       │  │
│ │ School • Due: Jun 2025   │ │ Projects • Due: Mar 2025 │  │
│ │ ──────────────────────── │ │ ──────────────────────── │  │
│ │ [████████░░░░░░░░░░] 45% │ │ [███░░░░░░░░░░░░░░░] 20% │  │
│ │ 225/500 points           │ │ 20/100 points            │  │
│ │ ──────────────────────── │ │ ──────────────────────── │  │
│ │ 3/8 goals completed      │ │ 1/3 goals completed      │  │
│ │ 8 months left            │ │ 5 months left            │  │
│ │ ⚠️ Below target velocity │ │ ✅ On pace               │  │
│ │ [View Details]           │ │ [View Details]           │  │
│ └──────────────────────────┘ └──────────────────────────┘  │
│                                                             │
│ ┌──────────────────────────┐ ┌──────────────────────────┐  │
│ │ 💪 4-Day Split (5 weeks) │ │ 📊 GRE Prep              │  │
│ │ Health • Due: Nov 2025   │ │ School • Due: Dec 2025   │  │
│ │ ──────────────────────── │ │ ──────────────────────── │  │
│ │ [████████████████░░] 80% │ │ [██████░░░░░░░░░░░] 30% │  │
│ │ 80/100 points            │ │ 30/100 points            │  │
│ │ ──────────────────────── │ │ ──────────────────────── │  │
│ │ 4/5 weeks completed      │ │ 1/3 goals completed      │  │
│ │ 1 week left              │ │ 2 months left            │  │
│ │ ✅ On pace               │ │ ✅ Ahead of pace         │  │
│ │ [View Details]           │ │ [View Details]           │  │
│ └──────────────────────────┘ └──────────────────────────┘  │
│                                                             │
│ ┌──────────────────────────┐                               │
│ │ 🏆 Completed Milestones  │                               │
│ │ (4) [Show All ▼]         │                               │
│ │ ──────────────────────── │                               │
│ │ ✅ Pass D426 (100%)      │                               │
│ │ ✅ Pass D427 (100%)      │                               │
│ │ ✅ Launch MMAmania Beta  │                               │
│ │ ✅ Bench 225lbs 3×5      │                               │
│ └──────────────────────────┘                               │
└─────────────────────────────────────────────────────────────┘
```

---

## Milestone Modal (Deep View)

```
┌─────────────────────────────────────────────────────────────┐
│ 🎓 Graduate WGU                                     [✕ Close]│
├─────────────────────────────────────────────────────────────┤
│ School • 500 points • Due: June 30, 2025 • 45% Complete     │
│                                                             │
│ ┌─ Overview ───────────────────────────────────────────────┐│
│ │ Progress: 225/500 points (45%)                          ││
│ │ [████████████░░░░░░░░░░░░░░░░░] 45%                    ││
│ │ Time Remaining: 8 months (243 days)                     ││
│ │ Velocity: 28 points/month                               ││
│ │ Target: 34 points/month (need +6pts/mo to stay on pace)││
│ │ ⚠️ Status: Below target velocity                        ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ ┌─ Goals Breakdown (3/8 completed) ───────────────────────┐│
│ │ ✅ D426: Data Mgmt Foundations (75/75) [100%]           ││
│ │    3 tasks completed • +75 pts • Done 2 weeks ago       ││
│ │                                                         ││
│ │ ✅ D427: Data Mgmt Applications (75/75) [100%]          ││
│ │    3 tasks completed • +75 pts • Done 1 week ago        ││
│ │                                                         ││
│ │ 🔄 D315: Network & Security (45/75) [60%]               ││
│ │    2/5 tasks done • +45 pts • In progress               ││
│ │    [Resume] [View Tasks]                                ││
│ │                                                         ││
│ │ ⏳ D276: Web Dev Foundations (0/75) [0%]                ││
│ │    0 tasks started • +0 pts • Not started               ││
│ │    [Start] [Add Tasks]                                  ││
│ │                                                         ││
│ │ ⏳ D197: Version Control (0/75) [0%]                    ││
│ │ ⏳ D685: Prompt Engineering (0/75) [0%]                 ││
│ │ ⏳ D459: Systems Thinking (0/75) [0%]                   ││
│ │ ⏳ D268: Communication (0/75) [0%]                      ││
│ │ ─────────────────────────────────────────────────────── ││
│ │ [+ Add Goal] [Create from Template] [Reorder]           ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ ┌─ Velocity Tracking ──────────────────────────────────────┐│
│ │ Monthly Progress:                                       ││
│ │ Oct 2024: 75 pts ✅ (above target)                      ││
│ │ Sep 2024: 75 pts ✅ (above target)                      ││
│ │ Aug 2024: 45 pts ⚠️ (below target)                      ││
│ │ Jul 2024: 30 pts ⚠️ (below target)                      ││
│ │ ─────────────────────────────────────────────────────── ││
│ │ 3-Month Avg: 60 pts/month                               ││
│ │ Projected Completion: July 2025 (1 month late)          ││
│ │ Recommendation: Add +6 pts/month to finish on time      ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ ┌─ Notes ──────────────────────────────────────────────────┐│
│ │ [WGU graduation is critical for job applications...]    ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ [Mark Complete] [Edit] [Archive] [Export Report]           │
└─────────────────────────────────────────────────────────────┘
```

---

## Completion Celebration

**Trigger:** Milestone progress reaches 100% (progressPoints >= targetPoints)

**UI Flow:**
1. Milestone auto-marks as `status = 'completed'`
2. Full-screen modal appears:

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│                    🎉 MILESTONE COMPLETE! 🎉                │
│                                                             │
│                   🎓 Graduate WGU                           │
│                                                             │
│              You earned 500 points total!                   │
│                  +100 bonus completion points!              │
│                                                             │
│                 [See Details] [Continue]                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

3. Confetti animation plays (5 seconds)
4. Milestone card moves to "Completed Milestones" section
5. All goals under milestone lock (no further edits)
6. Streak counter increases
7. Analytics updated

---

## Velocity Calculation

**Formula:**
```
Current Velocity = Total Points Earned / Months Elapsed
Required Velocity = Remaining Points / Months Left
Status = Current Velocity >= Required Velocity ? "On Pace" : "Behind"
```

**Example:**
```
Milestone: Graduate WGU
Target: 500 points
Progress: 225 points (45%)
Time Elapsed: 4 months (Oct 2024 - Jan 2025)
Time Remaining: 8 months (Feb 2025 - Jun 2025)

Current Velocity: 225 / 4 = 56.25 pts/month
Remaining Points: 500 - 225 = 275 pts
Required Velocity: 275 / 8 = 34.375 pts/month

Status: ✅ On Pace (56.25 > 34.375)
```

**UI Badges:**
- ✅ **On Pace:** Current velocity >= required velocity
- ⚠️ **Below Target:** Current velocity < required velocity (but >50% of required)
- 🚨 **Critical:** Current velocity < 50% of required velocity
- 🚀 **Ahead of Pace:** Current velocity > 150% of required velocity

---

## State Management

```typescript
// state/slices/milestonesSlice.ts

interface MilestonesSlice {
  // Data
  milestones: Map<string, Milestone>;
  
  // Filters
  categoryFilter?: string;
  statusFilter: 'active' | 'completed' | 'all';
  setFilters: (filters: Partial<{ category?: string; status: MilestonesSlice['statusFilter'] }>) => void;
  
  // CRUD
  createMilestone: (data: CreateMilestoneData) => Promise<string>;
  updateMilestone: (id: string, updates: Partial<Milestone>) => Promise<void>;
  deleteMilestone: (id: string) => Promise<void>;
  
  // Goals
  addGoal: (milestoneId: string, goalId: string) => Promise<void>;
  removeGoal: (milestoneId: string, goalId: string) => Promise<void>;
  
  // Progress
  recomputeProgress: (milestoneId: string) => Promise<void>;
  calculateVelocity: (milestoneId: string) => Promise<VelocityData>;
  
  // Completion
  completeMilestone: (milestoneId: string) => Promise<void>;
  celebrateMilestone: (milestoneId: string) => void;
  
  // Modal
  activeMilestoneId?: string;
  openMilestoneModal: (milestoneId: string) => void;
  closeMilestoneModal: () => void;
}

interface VelocityData {
  currentVelocity: number;  // pts/month
  requiredVelocity: number; // pts/month
  status: 'on_pace' | 'below_target' | 'critical' | 'ahead';
  projectedCompletion: string; // ISO date
  monthlyBreakdown: Array<{ month: string; points: number; }>;
}
```

---

## Database Queries

### Dashboard Query
```sql
SELECT 
  m.*,
  c.name as category_name,
  c.color as category_color,
  COUNT(DISTINCT g.id) as goal_count,
  SUM(CASE WHEN g.status = 'completed' THEN 1 ELSE 0 END) as goals_completed,
  SUM(g.progress_points) as progress_points,
  m.target_points,
  CASE 
    WHEN m.due IS NOT NULL THEN 
      ROUND((julianday(m.due) - julianday('now')) / 30.0)
    ELSE NULL
  END as months_left
FROM milestones m
LEFT JOIN categories c ON m.category_id = c.id
LEFT JOIN goals g ON m.id = g.milestone_id AND g.deleted_at IS NULL
WHERE m.deleted_at IS NULL
  AND ($statusFilter = 'all' OR m.status = $statusFilter)
  AND ($categoryFilter IS NULL OR m.category_id = $categoryFilter)
GROUP BY m.id
ORDER BY m.status ASC, m.due ASC NULLS LAST;
```

### Velocity Query
```sql
-- Get monthly progress for last 6 months
SELECT 
  strftime('%Y-%m', t.updated_at) as month,
  SUM(t.points) as points
FROM tasks t
INNER JOIN goal_tasks gt ON t.id = gt.task_id
INNER JOIN goals g ON gt.goal_id = g.id
WHERE g.milestone_id = $milestoneId
  AND t.status = 'done'
  AND t.updated_at >= date('now', '-6 months')
GROUP BY month
ORDER BY month DESC;
```

---

## Progress Recomputation Logic

```typescript
// features/milestones/logic/progress.ts

export async function recomputeMilestoneProgress(
  milestoneId: string,
  db: Database
): Promise<{ points: number; percent: number }> {
  // 1. Get all goals under this milestone
  const goals = await db.query(`
    SELECT progress_points FROM goals
    WHERE milestone_id = ? AND deleted_at IS NULL
  `, [milestoneId]);
  
  // 2. Sum goal progress
  const progressPoints = goals.reduce((sum, g) => sum + (g.progress_points || 0), 0);
  
  // 3. Get milestone target
  const milestone = await db.query(`
    SELECT target_points, status FROM milestones WHERE id = ?
  `, [milestoneId]);
  
  const target = milestone[0].target_points || 100;
  const percent = Math.min(100, Math.round((progressPoints / target) * 100));
  
  // 4. Update milestone
  await db.query(`
    UPDATE milestones 
    SET progress_points = ?, updated_at = ?
    WHERE id = ?
  `, [progressPoints, new Date().toISOString(), milestoneId]);
  
  // 5. Check for completion
  if (progressPoints >= target && milestone[0].status !== 'completed') {
    await completeMilestone(milestoneId, db);
  }
  
  return { points: progressPoints, percent };
}

export async function completeMilestone(
  milestoneId: string,
  db: Database
): Promise<void> {
  // 1. Mark milestone complete
  await db.query(`
    UPDATE milestones 
    SET status = 'completed', updated_at = ?
    WHERE id = ?
  `, [new Date().toISOString(), milestoneId]);
  
  // 2. Lock all goals under milestone
  await db.query(`
    UPDATE goals
    SET status = 'completed', updated_at = ?
    WHERE milestone_id = ?
  `, [new Date().toISOString(), milestoneId]);
  
  // 3. Award bonus points (100pts)
  // (Analytics system will handle this)
  
  // 4. Trigger celebration event
  // (UI will handle via event listener)
}
```

---

## Velocity Calculation Logic

```typescript
// features/milestones/logic/velocity.ts

export async function calculateVelocity(
  milestoneId: string,
  db: Database
): Promise<VelocityData> {
  // 1. Get milestone data
  const milestone = await db.query(`
    SELECT 
      target_points,
      progress_points,
      created_at,
      due
    FROM milestones
    WHERE id = ?
  `, [milestoneId]);
  
  const { target_points, progress_points, created_at, due } = milestone[0];
  
  // 2. Calculate time elapsed (in months)
  const start = new Date(created_at);
  const now = new Date();
  const monthsElapsed = (now.getTime() - start.getTime()) / (1000 * 60 * 60 * 24 * 30);
  
  // 3. Calculate current velocity
  const currentVelocity = monthsElapsed > 0 
    ? progress_points / monthsElapsed 
    : 0;
  
  // 4. Calculate required velocity
  let requiredVelocity = 0;
  let monthsLeft = 0;
  if (due) {
    const dueDate = new Date(due);
    monthsLeft = (dueDate.getTime() - now.getTime()) / (1000 * 60 * 60 * 24 * 30);
    const remainingPoints = target_points - progress_points;
    requiredVelocity = monthsLeft > 0 ? remainingPoints / monthsLeft : Infinity;
  }
  
  // 5. Determine status
  let status: VelocityData['status'];
  if (currentVelocity >= requiredVelocity * 1.5) {
    status = 'ahead';
  } else if (currentVelocity >= requiredVelocity) {
    status = 'on_pace';
  } else if (currentVelocity >= requiredVelocity * 0.5) {
    status = 'below_target';
  } else {
    status = 'critical';
  }
  
  // 6. Project completion date
  const pointsRemaining = target_points - progress_points;
  const monthsToComplete = currentVelocity > 0 
    ? pointsRemaining / currentVelocity 
    : Infinity;
  const projectedCompletion = new Date(now.getTime() + monthsToComplete * 30 * 24 * 60 * 60 * 1000).toISOString();
  
  // 7. Get monthly breakdown
  const monthlyBreakdown = await db.query(`
    SELECT 
      strftime('%Y-%m', t.updated_at) as month,
      SUM(t.points) as points
    FROM tasks t
    INNER JOIN goal_tasks gt ON t.id = gt.task_id
    INNER JOIN goals g ON gt.goal_id = g.id
    WHERE g.milestone_id = ?
      AND t.status = 'done'
      AND t.updated_at >= date('now', '-6 months')
    GROUP BY month
    ORDER BY month DESC
    LIMIT 6
  `, [milestoneId]);
  
  return {
    currentVelocity: Math.round(currentVelocity * 10) / 10,
    requiredVelocity: Math.round(requiredVelocity * 10) / 10,
    status,
    projectedCompletion,
    monthlyBreakdown
  };
}
```

---

## Acceptance Tests

### Happy Path
1. ✅ View dashboard → see all milestones with progress bars
2. ✅ Click milestone → modal shows goals breakdown + velocity
3. ✅ Complete last goal → milestone auto-completes → celebration plays
4. ✅ Filter by category → see only School milestones
5. ✅ Milestone below pace → see warning badge + recommendation

### Edge Cases
1. ✅ Milestone with no due date → velocity shows "N/A"
2. ✅ Delete milestone → confirm dialog → goals unlinked (not deleted)
3. ✅ Milestone completion → all goals lock (cannot edit)
4. ✅ Add goal to completed milestone → error: "Milestone locked"
5. ✅ Velocity critical (>50% behind) → show red badge + alert

---

## File Targets

- `src/features/milestones/ui/MilestonesPage.tsx`
- `src/features/milestones/ui/MilestoneCard.tsx`
- `src/features/milestones/ui/MilestoneModal.tsx`
- `src/features/milestones/ui/CelebrationModal.tsx`
- `src/features/milestones/logic/progress.ts`
- `src/features/milestones/logic/velocity.ts`
- `src/state/slices/milestonesSlice.ts`
- `src/infra/db/migrations/0005_milestones.sql`

