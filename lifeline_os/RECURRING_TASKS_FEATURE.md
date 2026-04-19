# 🔄 Recurring Tasks & Timeline Context Menu

## ✅ Implementation Complete

Added task cloning and context menu for easy task management on the timeline!

---

## 🎯 Features Implemented

### **1. Timeline Context Menu** ✅
- **Right-click** (desktop) or **Long-press** (touch) any timeline tile
- Quick actions menu appears
- Options available:
  - ✏️ Edit Task (opens task modal)
  - 📋 Clone Task (create duplicate)
  - ✅ Mark Complete/Incomplete
  - 🗑️ Delete

### **2. Task Cloning** ✅
- Clone any task with one click
- Preserves:
  - Title
  - Description
  - Priority
  - Energy
  - Estimated minutes
  - Goal linkage
- Resets completion status
- Perfect for recurring workouts, habits, routines

### **3. Recurring Pattern Foundation** ✅
- Created data model for recurring patterns
- Supports types:
  - Daily
  - Weekly
  - Weekdays (Mon-Fri)
  - Custom days (e.g., Mon/Wed/Fri)
  - Custom intervals (every N days)
- Ready for future auto-generation

---

## 🏋️ **Gym Workflow (Your Use Case)**

### **How to Use for 4-Day Split**

**First Time Setup:**
1. Click "🏋️ Gym" button in Quick Add
2. Select "🥩 DAY 1 – Chest + Triceps"
3. (Optional) Log weights
4. Create task
5. Drag to timeline

**Every Future Workout:**
1. **Right-click** the DAY 1 task on timeline
2. Select "📋 Clone Task"
3. New task appears in pool with same exercises
4. Open cloned task to update weights
5. Drag to today's timeline

**Result:** 
- No re-entering exercises
- Just update weights each session
- Full workout history preserved

---

## 🖱️ Context Menu Actions

### **Edit Task** ✏️
- Opens task modal for the linked task
- Edit title, description, priority, energy
- Add/remove subtasks
- Change goal linkage

### **Clone Task** 📋
- Creates exact duplicate
- Appears in task pool (not on timeline)
- Completion status reset
- Ready to schedule

**Use Cases:**
- Gym workouts (same exercises, new weights)
- Weekly reports
- Daily check-ins
- Recurring meetings

### **Mark Complete/Incomplete** ✅
- Toggle completion status
- Updates points
- Visual feedback (green color)

### **Delete** 🗑️
- Confirmation dialog appears
- Removes from timeline
- Linked task remains in pool

---

## 💪 **Gym-Specific Benefits**

### **Problem Before:**
- Had to manually create each workout task
- Re-type all exercises every session
- Hard to track progress over time

### **Solution Now:**

**Week 1:**
```
Monday: Create DAY 1 task → Log weights → Schedule
Tuesday: Clone DAY 1 → Update weights → Schedule
Wednesday: Create DAY 2 task → Log weights → Schedule
Thursday: Clone DAY 2 → Update weights → Schedule
```

**Week 2+:**
```
Just clone from previous week's tasks!
Update weights (progressive overload)
Schedule on timeline
```

**Progressive Overload Tracking:**
- Each cloned task preserves previous workout as template
- Update description with new weights
- Easy to see: "Last time: 185 lbs → This time: 190 lbs"

---

## 📐 Technical Implementation

### **Files Created:**

1. **`lib/features/tasks/models/recurring_pattern.dart`**
   - Data model for recurring task patterns
   - JSON serialization
   - Display helpers
   - ~90 lines

2. **`lib/features/tasks/services/task_cloner.dart`**
   - Task cloning service
   - Recurring logic (for future auto-generation)
   - ~70 lines

3. **`lib/features/today/presentation/widgets/canvas_timeline.dart`** (MODIFIED)
   - Added `onSecondaryTapDown` (right-click)
   - Added `onLongPress` (touch)
   - Added `_showTimelineItemMenu()` method
   - Added `_handleMenuAction()` method
   - Added `_cloneTask()` method
   - Added `_confirmDelete()` method
   - ~200 lines added

---

## 🎨 UI/UX Design

### **Desktop (Right-Click Menu)**
```
┌─────────────────────┐
│ ✏️ Edit Task         │
│ 📋 Clone Task        │
│ ──────────────────── │
│ ✅ Mark Complete     │
│ ──────────────────── │
│ 🗑️ Delete            │
└─────────────────────┘
```

### **Mobile (Bottom Sheet)**
```
╔═══════════════════════╗
║ ━━━                   ║
║ 🥩 DAY 1 – Chest +... ║
║                       ║
║ ✏️ Edit Task          ║
║ 📋 Clone Task         ║
║    Create a copy...   ║
║ ─────────────────────║
║ ✅ Mark Complete      ║
║ ─────────────────────║
║ 🗑️ Delete             ║
╚═══════════════════════╝
```

---

## 🔮 Future Enhancements (Not Implemented Yet)

### **Auto-Recurring Tasks**
- Set task as "Daily" or "Weekly"
- System auto-creates new instance when completed
- Shows in "Suggested Tasks" section

### **Recurring Schedule Items**
- Schedule a task to repeat (e.g., "Gym every Mon/Wed/Fri at 6 AM")
- Auto-populates timeline for future dates
- One-time edit updates all future instances

### **Weight Progression Tracking**
- Store workout logs in database
- Show previous weights when creating new gym task
- Suggest +5 lbs progression
- Chart progress over time

### **Workout Templates Library**
- Save custom workout splits
- Share templates between goals
- Import/export workouts

---

## 🧪 Testing

### **Desktop (Windows)**
1. Schedule a task on timeline
2. **Right-click** the task tile
3. See context menu appear at cursor
4. Click "Clone Task"
5. Check task pool - cloned task appears
6. Right-click again
7. Click "Edit Task"
8. Task modal opens
9. Make changes, save
10. Verify changes reflected on timeline

### **Touch/Mobile** (if testing)
1. Schedule a task on timeline
2. **Long-press** (hold) the task tile
3. Bottom sheet slides up
4. Tap "Clone Task"
5. Verify clone created

### **Gym Workflow**
1. Create "🥩 DAY 1 – Chest + Triceps" via Gym button
2. Drag to timeline (e.g., Monday 6 AM)
3. Complete workout
4. Next Monday: Right-click → Clone
5. Edit cloned task → Update weights
6. Drag to timeline
7. Repeat weekly!

---

## 🎯 Real-World Usage

### **Scenario: 4-Week Gym Program**

**Week 1:**
- Create 4 workout tasks (DAY 1-4)
- Schedule on timeline
- Complete with logged weights

**Week 2-4:**
- Right-click each previous workout
- Clone for new week
- Update weights (+5 lbs progression)
- Schedule and complete

**Result:**
- 16 completed workouts
- Full weight progression history
- Minimal data entry effort

---

## ⚡ Benefits

1. **Zero Re-Typing** - Clone instead of recreate
2. **Fast Workflow** - Right-click → Clone → Done
3. **Progress Tracking** - History preserved in cloned descriptions
4. **ADHD-Friendly** - Quick, visual, no cognitive load
5. **Flexible** - Works for any recurring task (not just gym)

---

## 🚀 Next Steps

**After build_runner:**
1. Test right-click menu on timeline
2. Clone a gym workout task
3. Verify it appears in pool
4. Edit the clone to update weights
5. Schedule for next workout day

**Workflow optimization:**
- Create all 4 gym days once
- Clone them weekly
- Update weights each time
- Never re-create from scratch!

---

**Your timeline now has professional task management!** 🎯

Right-click any task to edit, clone, complete, or delete - just like Google Calendar or Notion!

