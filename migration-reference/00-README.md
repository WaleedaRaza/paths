# 🗂️ MIGRATION REFERENCE FILES

This folder contains the **essential files** from the current Lifeline OS that demonstrate key patterns, architectures, and UI implementations needed for the V2 rebuild.

---

## 📋 FILE INDEX & PURPOSE

### **Core Architecture**

#### **01-store-index.ts** (Original: `src/store/index.ts`)
**Purpose**: Core Zustand store with all data models and actions
**Key Concepts**:
- Task, Goal, Milestone interfaces (atomic framework)
- State management patterns with Zustand
- Action implementations (breakdownTask, logTaskEntry, calculateTaskPoints)
- Normalization functions for data consistency
**Salvage**: Data model concepts, action patterns
**Rebuild**: Clean slices without legacy cruft

#### **02-expert-definitions.ts** (Original: `src/experts/definitions.ts`)
**Purpose**: 8 AI expert personality definitions
**Key Concepts**:
- Expert system prompts (Mirror-Guide, Founder-Engineer, etc.)
- Personality tuning and tone specifications
- Context needs per expert
**Salvage**: All 8 expert definitions (data only)
**Rebuild**: Use as pure data, rebuild service layer

#### **03-expert-types.ts** (Original: `src/experts/types.ts`)
**Purpose**: TypeScript interfaces for expert system
**Key Concepts**:
- Expert interface structure
- Context and response types
**Salvage**: Type definitions
**Rebuild**: Clean up and extend for V2

---

### **Page Components (UI Patterns)**

#### **04-AtomicTasksPage.tsx** (Original: `src/pages/AtomicTasksPage.tsx`)
**Purpose**: Main tasks view with atomic framework
**Key Concepts**:
- Task grouping by status (In Progress, Atomic Ready, Needs Breakdown)
- Filter and search patterns
- Task card UI with energy/time indicators
- Breakdown and logging action buttons
**Salvage**: UI layout concepts, filtering logic, card design
**Rebuild**: Cleaner component structure, better state management

#### **05-AtomicGoalsPage.tsx** (Original: `src/pages/AtomicGoalsPage.tsx`)
**Purpose**: Goal hierarchy view with milestones
**Key Concepts**:
- Tree structure for goal hierarchy
- Expandable goal cards
- Progress bars and points tracking
- Task-goal associations visualization
**Salvage**: Hierarchy UI patterns, progress visualization
**Rebuild**: Simplified hierarchy, better performance

#### **06-PracticalTodayPage.tsx** (Original: `src/pages/PracticalTodayPage.tsx`)
**Purpose**: Daily planning cockpit
**Key Concepts**:
- Must-wins section (3 priority tasks)
- Next-up recommendations
- Smart task suggestions with AI
- Daily focus management
**Salvage**: Daily planning concepts, must-wins pattern
**Rebuild**: Add timeline/schedule view, drag-drop

#### **07-ReflectionsPage.tsx** (Original: `src/pages/ReflectionsPage.tsx`)
**Purpose**: AI chat + journaling interface
**Key Concepts**:
- Expert personality switching
- Chat UI with history
- Journal/notes integration
- Content recommendations banner
**Salvage**: Chat UI layout, expert switching, journal patterns
**Rebuild**: Cleaner AI service integration, better UX

---

### **Modal Components (Interaction Patterns)**

#### **08-TaskBreakdownModal.tsx** (Original: `src/components/TaskBreakdownModal.tsx`)
**Purpose**: Split tasks into atomic subtasks
**Key Concepts**:
- Smart defaults by category
- Dynamic subtask creation
- Atomic constraint validation (≤30min)
- Time estimation and energy matching
**Salvage**: Breakdown UI pattern, validation logic
**Rebuild**: Add AI-powered breakdown suggestions

#### **09-AtomicTaskModal.tsx** (Original: `src/components/AtomicTaskModal.tsx`)
**Purpose**: Create/edit tasks with atomic constraints
**Key Concepts**:
- Atomic task enforcement (≤30min)
- Goal linking interface
- Energy/priority selection
- Definition of done auto-generation
**Salvage**: Task creation UX, atomic validation
**Rebuild**: Streamlined form, better goal picker

#### **10-AtomicGoalModal.tsx** (Original: `src/components/AtomicGoalModal.tsx`)
**Purpose**: Create/edit goals with milestones
**Key Concepts**:
- Goal type selection
- Milestone management
- Target setting and progress tracking
- Task linking interface
**Salvage**: Goal creation UX, milestone UI
**Rebuild**: Better hierarchy support, simpler UX

---

### **Supporting Components (Feature Patterns)**

#### **11-MilestoneTracker.tsx** (Original: `src/components/MilestoneTracker.tsx`)
**Purpose**: Visual milestone progress tracking
**Key Concepts**:
- Compact and full display modes
- Interactive milestone toggle
- Progress bar with points breakdown
- Celebration on completion
**Salvage**: Progress visualization patterns
**Rebuild**: More visual, animated celebrations

#### **12-PointsDisplay.tsx** (Original: `src/components/PointsDisplay.tsx`)
**Purpose**: Gamification and rewards display
**Key Concepts**:
- Points accumulation display
- Level progression
- Streak tracking
- Weekly momentum calculation
**Salvage**: Gamification concepts, level system
**Rebuild**: More engaging animations, better feedback

#### **13-ProgressGraph.tsx** (Original: `src/components/ProgressGraph.tsx`)
**Purpose**: Progress visualization charts
**Key Concepts**:
- Multiple graph types (tasks, points, weight, problems)
- Trend indicators
- Time-based visualization
**Salvage**: Chart patterns, data visualization
**Rebuild**: Better charting library, more graph types

#### **14-LogEntryModal.tsx** (Original: `src/components/LogEntryModal.tsx`)
**Purpose**: Log fitness/DSA session data
**Key Concepts**:
- Dual mode (Fitness/DSA)
- Exercise tracking (sets, reps, weight)
- Problem tracking (difficulty, time, solved)
- Pre-filling from task metadata
**Salvage**: Logging UI patterns, dual-mode design
**Rebuild**: More workout types, better DSA integration

---

### **Infrastructure Components**

#### **15-AppShell.tsx** (Original: `src/components/AppShell.tsx`)
**Purpose**: Main app layout and navigation
**Key Concepts**:
- Sidebar navigation
- Page routing
- Global state access
- Theme and layout management
**Salvage**: Navigation structure, layout patterns
**Rebuild**: Cleaner routing, better mobile support

#### **16-App.tsx** (Original: `src/App.tsx`)
**Purpose**: Root app component
**Key Concepts**:
- App initialization
- Route configuration
- Global error handling
- Desktop integration
**Salvage**: Initialization patterns, routing setup
**Rebuild**: Simpler initialization, better error boundaries

---

### **Service Layer**

#### **17-storage-service.ts** (Original: `src/services/storage.ts`)
**Purpose**: Data persistence layer
**Key Concepts**:
- localStorage abstraction
- Tauri file system integration
- Backup/restore functionality
- Migration handling
**Salvage**: Persistence patterns, backup logic
**Rebuild**: Switch to SQLite, cleaner API

---

### **Data & Configuration**

#### **18-atomic-mock-data.ts** (Original: `src/data/atomicMockData.ts`)
**Purpose**: Test data demonstrating atomic framework
**Key Concepts**:
- School goal example (D426 Course)
- Project goal example (void App)
- DSA goal example (Array Patterns)
- Fitness goal example (4-Day Split)
**Salvage**: Data structure examples, test data patterns
**Rebuild**: Expand with more examples, better defaults

#### **19-package.json**
**Purpose**: Project dependencies and scripts
**Key Concepts**:
- React + TypeScript + Vite stack
- Zustand for state management
- Tauri for desktop
- Tailwind for styling
**Salvage**: Dependency choices, script patterns
**Rebuild**: Update versions, clean up unused deps

#### **20-tsconfig.json**
**Purpose**: TypeScript configuration
**Key Concepts**:
- Strict type checking
- Module resolution
- Path aliases
**Salvage**: TS settings
**Rebuild**: Stricter settings, better paths

#### **21-tailwind.config.js**
**Purpose**: Tailwind CSS configuration
**Key Concepts**:
- Custom theme colors
- Dark mode configuration
- Plugin setup
**Salvage**: Theme colors, dark mode setup
**Rebuild**: Better color system, more utilities

#### **22-tauri-config.json**
**Purpose**: Tauri desktop app configuration
**Key Concepts**:
- Window configuration
- System tray setup
- Security settings
**Salvage**: Desktop config patterns
**Rebuild**: Better window management, tray integration

---

## 🎯 HOW TO USE THESE FILES

### **For Understanding Current Architecture:**
1. Start with `01-store-index.ts` to understand data models
2. Review page components (04-07) to see UI patterns
3. Study modal components (08-10) for interaction patterns
4. Check expert system (02-03) for AI implementation

### **For Rebuilding V2:**
1. **Data Models**: Use `01-store-index.ts` as reference, but rebuild with clean slices
2. **AI System**: Keep expert definitions (02), rebuild service completely
3. **UI Patterns**: Port concepts from pages (04-07) and modals (08-10)
4. **Components**: Adapt supporting components (11-14) with cleaner code

### **What NOT to Copy:**
- Don't copy AI service implementations (they're messy)
- Don't copy legacy compatibility code
- Don't copy duplicate/conflicting implementations
- Don't copy complex normalization functions

### **What TO Copy:**
- Expert personality definitions (pure data)
- UI component layouts and interaction patterns
- Data structure concepts (Task, Goal, Milestone hierarchy)
- Gamification logic (points, streaks, levels)

---

## 🚨 KEY INSIGHTS FROM CURRENT IMPLEMENTATION

### **What Worked:**
✅ Atomic framework concept (5-30 min tasks)
✅ MGTST hierarchy (Milestone → Goal → Task → Subtask)
✅ Expert personality system (8 specialized AIs)
✅ Points and gamification
✅ Task breakdown functionality
✅ Progress visualization

### **What Failed:**
❌ Multiple conflicting AI implementations
❌ Legacy compatibility cruft in data models
❌ Duplicate components (old + atomic versions)
❌ Complex state management with too many actions
❌ Scattered feature implementations
❌ Information overload in UI

### **Lessons for V2:**
1. **Single AI Service**: One service, multiple experts (data)
2. **Clean Data Models**: No legacy fields, no optional spam
3. **Component Discipline**: One component per responsibility
4. **State Slicing**: Separate slices for tasks, goals, milestones
5. **UI Simplicity**: Show what matters now, hide the rest
6. **Performance First**: Optimize queries, lazy load, virtualize

---

## 📊 FILE SIZE & COMPLEXITY REFERENCE

| File | Lines | Complexity | Rebuild Priority |
|------|-------|------------|------------------|
| 01-store-index.ts | ~1000 | High | Critical - Rebuild with slices |
| 02-expert-definitions.ts | ~250 | Low | Keep as-is (data only) |
| 04-AtomicTasksPage.tsx | ~500 | Medium | High - Port concepts |
| 05-AtomicGoalsPage.tsx | ~540 | Medium | High - Port concepts |
| 07-ReflectionsPage.tsx | ~1840 | High | Medium - Rebuild cleaner |
| 08-TaskBreakdownModal.tsx | ~300 | Medium | High - Port + enhance |
| 09-AtomicTaskModal.tsx | ~400 | Medium | High - Simplify |
| 15-AppShell.tsx | ~300 | Low | Medium - Clean routing |

---

## 🔄 MIGRATION WORKFLOW

### **Phase 1: Study (1-2 days)**
- Read all files in order (01-22)
- Understand data flow and patterns
- Note what works and what doesn't

### **Phase 2: Design (1 day)**
- Design clean V2 architecture
- Plan state slicing strategy
- Design component hierarchy

### **Phase 3: Rebuild (1 week)**
- Implement clean store with slices (01)
- Port expert definitions (02)
- Rebuild pages with clean components (04-07)
- Create new modals with better UX (08-10)

### **Phase 4: Enhance (ongoing)**
- Add project planner feature
- Improve AI integration
- Polish UI/UX
- Add advanced features

---

## 📝 NOTES FOR CURSOR AI

When referencing these files in Cursor:
1. **Don't copy-paste directly** - Use as reference for concepts
2. **Focus on patterns** - UI layouts, state management, interactions
3. **Simplify everything** - Remove complexity, add clarity
4. **Modernize** - Use better React patterns, TypeScript, state management
5. **Test incrementally** - Build feature by feature, test each one

---

**Created**: October 6, 2025  
**Purpose**: Migration reference for Lifeline OS V2 rebuild  
**Status**: Complete - Ready for V2 development

