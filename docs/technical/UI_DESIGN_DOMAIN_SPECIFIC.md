# COMPLETE UI DESIGN - DOMAIN-SPECIFIC MGTST SYSTEM

## Table of Contents
1. [Projects Domain](#projects-domain)
2. [Finance Domain](#finance-domain)

---

## PROJECTS DOMAIN

### Example MGTST Hierarchy
```
Milestone: "Launch PWA MVP"
├── Goal: "Complete frontend"
│   ├── Task: "Design UI mockups"
│   │   └── Subtask: "Create wireframes"
│   │   └── Subtask: "Choose color palette"
│   ├── Task: "Implement auth system"
│       └── Subtask: "Build login component"
├── Goal: "Complete backend"
├── Goal: "Deploy to production"
    ├── Task: "Set up CI/CD pipeline"
```

---

### 1. TEMPLATE WIZARD - Projects

#### Step 1: Project Type Selection
```
╔═══════════════════════════════════════════════════════════════╗
║  🚀 Create Project Milestone                                  ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  What type of project are you building?                      ║
║                                                               ║
║  ┌─────────────────────┐  ┌─────────────────────┐          ║
║  │  💻 Web App         │  │  📱 Mobile App      │          ║
║  │                     │  │                     │          ║
║  │  PWA, SPA, or      │  │  iOS, Android, or   │          ║
║  │  full-stack web    │  │  cross-platform     │          ║
║  └─────────────────────┘  └─────────────────────┘          ║
║                                                               ║
║  ┌─────────────────────┐  ┌─────────────────────┐          ║
║  │  🖥️ Desktop App     │  │  🔧 CLI Tool        │          ║
║  │                     │  │                     │          ║
║  │  Cross-platform or │  │  Command-line       │          ║
║  │  native desktop    │  │  utility or script  │          ║
║  └─────────────────────┘  └─────────────────────┘          ║
║                                                               ║
║  ┌─────────────────────┐  ┌─────────────────────┐          ║
║  │  🌐 API/Backend     │  │  📦 Library/Package │          ║
║  │                     │  │                     │          ║
║  │  REST, GraphQL, or │  │  NPM, PyPI, or      │          ║
║  │  microservices     │  │  reusable module    │          ║
║  └─────────────────────┘  └─────────────────────┘          ║
║                                                               ║
║  ┌─────────────────────┐  ┌─────────────────────┐          ║
║  │  🎨 Design System   │  │  🔬 Research/POC    │          ║
║  │                     │  │                     │          ║
║  │  Component library │  │  Proof of concept   │          ║
║  │  or style guide    │  │  or experiment      │          ║
║  └─────────────────────┘  └─────────────────────┘          ║
║                                                               ║
║                         [Continue →]                          ║
╚═══════════════════════════════════════════════════════════════╝
```

**Selected: "Web App"**

---

#### Step 2: Project Details
```
╔═══════════════════════════════════════════════════════════════╗
║  🚀 Create Project Milestone (2/5)                            ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  Project Name*                                               ║
║  ┌───────────────────────────────────────────────────────┐  ║
║  │ Task Master PWA                                        │  ║
║  └───────────────────────────────────────────────────────┘  ║
║                                                               ║
║  Brief Description                                           ║
║  ┌───────────────────────────────────────────────────────┐  ║
║  │ A beautiful PWA for managing tasks with offline       │  ║
║  │ support, real-time sync, and AI-powered insights.     │  ║
║  │                                                        │  ║
║  └───────────────────────────────────────────────────────┘  ║
║                                                               ║
║  Tech Stack (select all that apply)                         ║
║  ☑ React         ☑ TypeScript    ☐ Vue                     ║
║  ☑ Node.js       ☐ Python        ☐ Go                      ║
║  ☑ PostgreSQL    ☐ MongoDB       ☐ Redis                   ║
║  ☑ Docker        ☐ Kubernetes    ☐ AWS                     ║
║                                                               ║
║  Repository URL (optional)                                   ║
║  ┌───────────────────────────────────────────────────────┐  ║
║  │ https://github.com/username/task-master               │  ║
║  └───────────────────────────────────────────────────────┘  ║
║                                                               ║
║  [← Back]                              [Continue →]          ║
╚═══════════════════════════════════════════════════════════════╝
```

---

#### Step 3: Project Phases (Auto-Generated Goals)
```
╔═══════════════════════════════════════════════════════════════╗
║  🚀 Create Project Milestone (3/5)                            ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  Define your project phases (these become Goals)             ║
║                                                               ║
║  ✨ Recommended phases for Web App:                          ║
║                                                               ║
║  1. ☑ Planning & Design                                     ║
║     └─ Research, wireframes, user flows, mockups            ║
║                                                               ║
║  2. ☑ Frontend Development                                  ║
║     └─ UI components, pages, routing, state management      ║
║                                                               ║
║  3. ☑ Backend Development                                   ║
║     └─ API, database, auth, business logic                  ║
║                                                               ║
║  4. ☑ Integration & Testing                                 ║
║     └─ Connect frontend/backend, write tests, fix bugs      ║
║                                                               ║
║  5. ☑ Deployment & Launch                                   ║
║     └─ CI/CD, hosting, domain, monitoring                   ║
║                                                               ║
║  6. ☐ Post-Launch Iteration                                 ║
║     └─ User feedback, analytics, feature improvements       ║
║                                                               ║
║  ┌─────────────────────────────────────────────────────┐    ║
║  │ ➕ Add Custom Phase                                  │    ║
║  └─────────────────────────────────────────────────────┘    ║
║                                                               ║
║  [← Back]                              [Continue →]          ║
╚═══════════════════════════════════════════════════════════════╝
```

---

#### Step 4: Timeline & Deadlines
```
╔═══════════════════════════════════════════════════════════════╗
║  🚀 Create Project Milestone (4/5)                            ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  Set project timeline                                        ║
║                                                               ║
║  Target Launch Date*                                         ║
║  ┌───────────────────────────────────────────────────────┐  ║
║  │ 📅 June 15, 2025                            [Calendar] │  ║
║  └───────────────────────────────────────────────────────┘  ║
║                                                               ║
║  Estimated Duration                                          ║
║  ┌──────────┐  ┌──────────┐                                 ║
║  │    12    │  │  Weeks   │  (~3 months)                    ║
║  └──────────┘  └──────────┘                                 ║
║                                                               ║
║  Phase Deadlines (auto-calculated)                           ║
║  ┌───────────────────────────────────────────────────────┐  ║
║  │ 1. Planning & Design         → Mar 15, 2025          │  ║
║  │ 2. Frontend Development      → Apr 15, 2025          │  ║
║  │ 3. Backend Development       → May 1, 2025           │  ║
║  │ 4. Integration & Testing     → May 20, 2025          │  ║
║  │ 5. Deployment & Launch       → Jun 15, 2025          │  ║
║  └───────────────────────────────────────────────────────┘  ║
║                                                               ║
║  ☑ Send me reminders as deadlines approach                  ║
║  ☑ Create weekly check-in Must-Wins for this project       ║
║                                                               ║
║  [← Back]                              [Continue →]          ║
╚═══════════════════════════════════════════════════════════════╝
```

---

#### Step 5: Success Metrics
```
╔═══════════════════════════════════════════════════════════════╗
║  🚀 Create Project Milestone (5/5)                            ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  How will you measure success?                               ║
║                                                               ║
║  Completion Criteria (what "done" looks like)                ║
║  ┌───────────────────────────────────────────────────────┐  ║
║  │ ☑ All core features implemented and tested            │  ║
║  │ ☑ Deployed to production with <2s load time           │  ║
║  │ ☑ 100+ users signed up in first week                  │  ║
║  │ ☐ _________________________________                   │  ║
║  └───────────────────────────────────────────────────────┘  ║
║                                                               ║
║  Key Performance Indicators (optional)                       ║
║  ┌───────────────────────────────────────────────────────┐  ║
║  │ Metric              Target        Current              │  ║
║  │ ──────────────────────────────────────────────────    │  ║
║  │ Lighthouse Score    95+           —                   │  ║
║  │ Test Coverage       80%           —                   │  ║
║  │ Page Load Time      <2s           —                   │  ║
║  │ Daily Active Users  100+          —                   │  ║
║  └───────────────────────────────────────────────────────┘  ║
║                                                               ║
║  Celebration Plan (when you hit your milestone) 🎉           ║
║  ┌───────────────────────────────────────────────────────┐  ║
║  │ Share on Twitter, treat myself to a nice dinner,      │  ║
║  │ write a blog post about the journey                   │  ║
║  └───────────────────────────────────────────────────────┘  ║
║                                                               ║
║  [← Back]                              [Create Milestone]    ║
╚═══════════════════════════════════════════════════════════════╝
```

---

### 2. MILESTONE CARD - Projects

#### Collapsed State
```
┌─────────────────────────────────────────────────────────────┐
│ 🚀 Launch Task Master PWA                        [⋮] [❤️]   │
│                                                              │
│ Web App • React, TypeScript, Node.js, PostgreSQL            │
│                                                              │
│ ████████████████████████░░░░░░░░░░ 65% complete             │
│                                                              │
│ 📊  3 of 5 phases complete      ⏰  Due: Jun 15, 2025       │
│ 📝  12 tasks done (8 remaining)  🔥  On track                │
│                                                              │
│ Next Phase: Integration & Testing (starts May 1)            │
│                                                              │
│ [View Details] [Add Task] [Weekly Check-in]                 │
└─────────────────────────────────────────────────────────────┘
```

**Animations:**
- On hover: Subtle lift shadow + border pulse (orange)
- On progress update: Progress bar fills with smooth animation + confetti burst if phase completes
- Status indicator: Pulsing dot (🔥 = orange, ⚠️ = yellow, ✅ = green)

---

#### Expanded State
```
╔═══════════════════════════════════════════════════════════════╗
║ 🚀 Launch Task Master PWA                           [⋮] [❤️]  ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║ A beautiful PWA for managing tasks with offline support,     ║
║ real-time sync, and AI-powered insights.                     ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ Tech Stack:                                             │ ║
║ │ React • TypeScript • Node.js • PostgreSQL • Docker      │ ║
║ │                                                         │ ║
║ │ Repository:                                             │ ║
║ │ 🔗 github.com/username/task-master         [Open →]    │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ PROGRESS OVERVIEW                                       │ ║
║ │                                                         │ ║
║ │ ████████████████████████░░░░░░░░░░ 65% complete        │ ║
║ │                                                         │ ║
║ │ ✅ Planning & Design (100%)        Due: Mar 15, 2025   │ ║
║ │    └─ 5 tasks • Research, wireframes, mockups done     │ ║
║ │                                                         │ ║
║ │ ✅ Frontend Development (100%)     Due: Apr 15, 2025   │ ║
║ │    └─ 8 tasks • All components & pages built           │ ║
║ │                                                         │ ║
║ │ ✅ Backend Development (100%)      Due: May 1, 2025    │ ║
║ │    └─ 6 tasks • API & database complete                │ ║
║ │                                                         │ ║
║ │ 🔄 Integration & Testing (40%)     Due: May 20, 2025   │ ║
║ │    └─ 4 of 10 tasks • Currently in progress            │ ║
║ │    └─ [View Tasks →]                                   │ ║
║ │                                                         │ ║
║ │ ⏳ Deployment & Launch (0%)        Due: Jun 15, 2025   │ ║
║ │    └─ 0 of 5 tasks • Starts after testing              │ ║
║ │    └─ [Plan Deployment →]                              │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ SUCCESS METRICS                                         │ ║
║ │                                                         │ ║
║ │ Completion Criteria:                                    │ ║
║ │ ☑ All core features implemented (19/20 tasks)          │ ║
║ │ ☐ Deployed with <2s load time                          │ ║
║ │ ☐ 100+ users in first week                             │ ║
║ │                                                         │ ║
║ │ KPIs:                                                   │ ║
║ │ Lighthouse Score:    — / 95+                           │ ║
║ │ Test Coverage:       68% / 80%                         │ ║
║ │ Page Load Time:      — / <2s                           │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ RECENT ACTIVITY                                         │ ║
║ │                                                         │ ║
║ │ 2 hours ago  ✅ Completed "Write integration tests"    │ ║
║ │ 1 day ago    ✅ Completed "Connect auth endpoints"     │ ║
║ │ 3 days ago   📝 Added "Set up error monitoring"        │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ [Edit Milestone] [Add Phase/Goal] [Weekly Standup] [Delete] ║
╚═══════════════════════════════════════════════════════════════╝
```

**Interactions:**
- Click phase name → Expand to show all tasks in that phase
- Click "View Tasks" → Navigate to Tasks page filtered by that goal
- Progress bars animate on load
- Activity feed auto-updates in real-time
- KPIs update when linked tasks complete

---

### 3. GOAL CARD (Phase) - Projects

#### Collapsed State
```
┌─────────────────────────────────────────────────────────────┐
│ 🎨 Frontend Development                          [⋮] [↗️]   │
│                                                              │
│ Part of: Launch Task Master PWA                             │
│                                                              │
│ ████████████████████████████████ 100% complete              │
│                                                              │
│ ✅  8 of 8 tasks done       ⏱️  Completed: Apr 12, 2025     │
│ 🎯  100 points earned       🔥  2 days ahead of schedule    │
│                                                              │
│ Key Deliverables: UI components, routing, state management  │
│                                                              │
│ [View Tasks] [Insights]                                      │
└─────────────────────────────────────────────────────────────┘
```

**Animations:**
- On completion: Checkmark bounce + confetti + +100 points counter
- Status: Green glow border when 100%, orange pulse when in progress
- Hover: Lift + subtle rotation

---

#### Expanded State
```
╔═══════════════════════════════════════════════════════════════╗
║ 🎨 Frontend Development                             [⋮] [↗️]  ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║ Part of: 🚀 Launch Task Master PWA                            ║
║ Phase 2 of 5 • Timeline: Mar 16 - Apr 15, 2025               ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ PHASE OVERVIEW                                          │ ║
║ │                                                         │ ║
║ │ Build all UI components, pages, routing system, and    │ ║
║ │ state management for the Task Master PWA.              │ ║
║ │                                                         │ ║
║ │ Tech: React 18, TypeScript, Tailwind CSS, Zustand      │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ PROGRESS                                                │ ║
║ │                                                         │ ║
║ │ ████████████████████████████████ 100% complete         │ ║
║ │                                                         │ ║
║ │ ✅  8 of 8 tasks complete                              │ ║
║ │ 🎯  100 points earned (+25 streak bonus)               │ ║
║ │ ⏱️  Completed Apr 12 (3 days ahead of schedule)        │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ TASKS IN THIS PHASE                                     │ ║
║ │                                                         │ ║
║ │ ✅ Design component library (20 pts) • Apr 3           │ ║
║ │    └─ Subtasks: Button, Input, Card, Modal (4/4)      │ ║
║ │                                                         │ ║
║ │ ✅ Build auth pages (15 pts) • Apr 5                   │ ║
║ │    └─ Subtasks: Login, Signup, Password reset (3/3)   │ ║
║ │                                                         │ ║
║ │ ✅ Implement routing (10 pts) • Apr 6                  │ ║
║ │    └─ Subtasks: Setup React Router, Protected routes  │ ║
║ │                                                         │ ║
║ │ ✅ Build task management UI (20 pts) • Apr 9           │ ║
║ │    └─ Subtasks: Task list, Task form, Filters (3/3)   │ ║
║ │                                                         │ ║
║ │ ✅ Set up state management (15 pts) • Apr 10           │ ║
║ │    └─ Subtasks: Zustand store, Auth state, Tasks      │ ║
║ │                                                         │ ║
║ │ ✅ Build dashboard page (10 pts) • Apr 11              │ ║
║ │ ✅ Responsive design (5 pts) • Apr 12                  │ ║
║ │ ✅ Dark mode toggle (5 pts) • Apr 12                   │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ INSIGHTS & LEARNINGS                                    │ ║
║ │                                                         │ ║
║ │ 🧠 Pattern: Component composition with TypeScript      │ ║
║ │    generics made the code highly reusable              │ ║
║ │                                                         │ ║
║ │ ⚡ Win: Finished 3 days early by timeboxing tasks      │ ║
║ │                                                         │ ║
║ │ 📝 Note: Consider adding Storybook next project        │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ [Edit Goal] [Add Task] [View in Milestone] [Delete]         ║
╚═══════════════════════════════════════════════════════════════╝
```

**Interactions:**
- Click task → Expand to show subtasks
- Insights auto-generated from completion patterns
- Points roll up to milestone total
- Timeline shows actual vs. planned completion

---

### 4. TASK CARD - Projects

#### Collapsed State (Kanban)
```
┌──────────────────────────────────────────┐
│ ⚡ Build auth pages             [⋮] [❤️] │
│                                          │
│ 🎨 Frontend Development                 │
│                                          │
│ ████████░░░░░░░░░ 3/3 subtasks          │
│                                          │
│ 🏷️ React, TypeScript, Auth              │
│ 📅 Due: Apr 5    🎯 15 points            │
│                                          │
│ 👤 Assigned to me                        │
└──────────────────────────────────────────┘
```

**Interactions:**
- Drag & drop between columns
- Hover: Lift + shadow
- Click: Expand modal

---

#### Expanded Modal
```
╔═══════════════════════════════════════════════════════════════╗
║ ⚡ Build auth pages                                  [X]      ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║ Part of: 🎨 Frontend Development → 🚀 Launch Task Master PWA  ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ DESCRIPTION                                             │ ║
║ │                                                         │ ║
║ │ Build login, signup, and password reset pages with     │ ║
║ │ form validation, error handling, and loading states.   │ ║
║ │                                                         │ ║
║ │ Tech: React Hook Form, Zod validation, React Router    │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ SUBTASKS (3/3)                                          │ ║
║ │                                                         │ ║
║ │ ✅ Build login page with form validation               │ ║
║ │    └─ Added email/password fields, error messages      │ ║
║ │    └─ Completed: Apr 3, 2025                           │ ║
║ │                                                         │ ║
║ │ ✅ Build signup page with confirmation                 │ ║
║ │    └─ Email verification flow implemented              │ ║
║ │    └─ Completed: Apr 4, 2025                           │ ║
║ │                                                         │ ║
║ │ ✅ Build password reset flow                           │ ║
║ │    └─ Email link + token validation working            │ ║
║ │    └─ Completed: Apr 5, 2025                           │ ║
║ │                                                         │ ║
║ │ [+ Add Subtask]                                        │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ METADATA                                                │ ║
║ │                                                         │ ║
║ │ Status:        ✅ Completed                            │ ║
║ │ Priority:      🔥 High                                 │ ║
║ │ Due Date:      📅 Apr 5, 2025                          │ ║
║ │ Points:        🎯 15 (earned Apr 5)                    │ ║
║ │ Tags:          🏷️ React, TypeScript, Auth, Forms      │ ║
║ │ Assigned to:   👤 Me                                   │ ║
║ │                                                         │ ║
║ │ Time Tracked:  ⏱️ 4.5 hours                            │ ║
║ │ Est. Time:     🕐 4 hours (1.125x)                     │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ LINKS & RESOURCES                                       │ ║
║ │                                                         │ ║
║ │ 🔗 Figma Mockup: figma.com/auth-pages                  │ ║
║ │ 🔗 PR #23: github.com/username/task-master/pull/23     │ ║
║ │ 🔗 Docs: react-hook-form.com                           │ ║
║ │                                                         │ ║
║ │ [+ Add Link]                                           │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ BLOCKERS & NOTES                                        │ ║
║ │                                                         │ ║
║ │ 📝 Apr 4: Need to clarify token expiry time with       │ ║
║ │           backend team                                  │ ║
║ │           ✅ Resolved: Set to 1 hour                    │ ║
║ │                                                         │ ║
║ │ 📝 Apr 5: Consider adding Google OAuth later           │ ║
║ │           (added to backlog)                            │ ║
║ │                                                         │ ║
║ │ [+ Add Note]                                           │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ [Edit Task] [Duplicate] [Move to Goal] [Delete] [Archive]   ║
╚═══════════════════════════════════════════════════════════════╝
```

**Project-Specific Fields:**
- **Tech Stack Tags**: Auto-complete tags (React, TypeScript, etc.)
- **Time Tracking**: Estimated vs. actual time
- **Links & Resources**: Figma, GitHub, docs, etc.
- **Blockers & Notes**: Timeline of blockers with resolution status
- **PR/Commit Links**: Auto-fetch from GitHub (future enhancement)

---

## FINANCE DOMAIN

### Example MGTST Hierarchy
```
Milestone: "Achieve financial security"
├── Goal: "Save $10k emergency fund"
│   ├── Task: "Set up automatic savings"
│   │   └── Subtask: "Research high-yield savings accounts"
│   │   └── Subtask: "Link bank account"
│   │   └── Subtask: "Set up recurring transfer"
│   ├── Task: "Create budget spreadsheet"
├── Goal: "Pay off credit card debt"
├── Goal: "Start investing"
    ├── Task: "Open brokerage account"
```

---

### 1. TEMPLATE WIZARD - Finance

#### Step 1: Financial Goal Type
```
╔═══════════════════════════════════════════════════════════════╗
║  💰 Create Financial Milestone                                ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  What financial goal are you working toward?                 ║
║                                                               ║
║  ┌─────────────────────┐  ┌─────────────────────┐          ║
║  │  🏦 Emergency Fund  │  │  💳 Pay Off Debt    │          ║
║  │                     │  │                     │          ║
║  │  Build 3-6 months   │  │  Credit cards, loans│          ║
║  │  of expenses saved  │  │  or other debts     │          ║
║  └─────────────────────┘  └─────────────────────┘          ║
║                                                               ║
║  ┌─────────────────────┐  ┌─────────────────────┐          ║
║  │  📈 Start Investing │  │  🏠 Save for Purchase│         ║
║  │                     │  │                     │          ║
║  │  Retirement, index  │  │  House, car, or     │          ║
║  │  funds, or stocks   │  │  major purchase     │          ║
║  └─────────────────────┘  └─────────────────────┘          ║
║                                                               ║
║  ┌─────────────────────┐  ┌─────────────────────┐          ║
║  │  💡 Increase Income │  │  📊 Budget & Track  │          ║
║  │                     │  │                     │          ║
║  │  Side hustle, raise,│  │  Create spending    │          ║
║  │  or passive income  │  │  plan & track it    │          ║
║  └─────────────────────┘  └─────────────────────┘          ║
║                                                               ║
║  ┌─────────────────────┐  ┌─────────────────────┐          ║
║  │  🎓 Save for Education│ │  🌴 Vacation Fund  │          ║
║  │                     │  │                     │          ║
║  │  Tuition, courses,  │  │  Travel savings     │          ║
║  │  or student loans   │  │  for dream trip     │          ║
║  └─────────────────────┘  └─────────────────────┘          ║
║                                                               ║
║                         [Continue →]                          ║
╚═══════════════════════════════════════════════════════════════╝
```

**Selected: "Emergency Fund"**

---

#### Step 2: Financial Details
```
╔═══════════════════════════════════════════════════════════════╗
║  💰 Create Financial Milestone (2/5)                          ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  Milestone Name*                                             ║
║  ┌───────────────────────────────────────────────────────┐  ║
║  │ Build $10,000 emergency fund                          │  ║
║  └───────────────────────────────────────────────────────┘  ║
║                                                               ║
║  Target Amount*                                              ║
║  ┌─────┬──────────────────────────────────────────────────┐ ║
║  │  $  │  10,000.00                                       │ ║
║  └─────┴──────────────────────────────────────────────────┘ ║
║                                                               ║
║  Current Amount Saved                                        ║
║  ┌─────┬──────────────────────────────────────────────────┐ ║
║  │  $  │  2,500.00                                        │ ║
║  └─────┴──────────────────────────────────────────────────┘ ║
║                                                               ║
║  ℹ️  You're 25% of the way there! $7,500 to go.              ║
║                                                               ║
║  Monthly Expenses (for reference)                            ║
║  ┌─────┬──────────────────────────────────────────────────┐ ║
║  │  $  │  3,500.00                                        │ ║
║  └─────┴──────────────────────────────────────────────────┘ ║
║                                                               ║
║  💡 Recommended: 3 months = $10,500 | 6 months = $21,000     ║
║                                                               ║
║  Account Type                                                ║
║  ○ High-Yield Savings (recommended)                          ║
║  ● Regular Savings                                           ║
║  ○ Money Market                                              ║
║  ○ Other: _______________                                    ║
║                                                               ║
║  [← Back]                              [Continue →]          ║
╚═══════════════════════════════════════════════════════════════╝
```

---

#### Step 3: Savings Plan (Auto-Generated Goals)
```
╔═══════════════════════════════════════════════════════════════╗
║  💰 Create Financial Milestone (3/5)                          ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  How will you save $7,500 more?                              ║
║                                                               ║
║  Monthly Savings Goal                                        ║
║  ┌─────┬──────────────────────────────────────────────────┐ ║
║  │  $  │  500.00                                          │ ║
║  └─────┴──────────────────────────────────────────────────┘ ║
║                                                               ║
║  ℹ️  At $500/month, you'll reach your goal in 15 months      ║
║      (by July 2026)                                          ║
║                                                               ║
║  ✨ Recommended sub-goals:                                    ║
║                                                               ║
║  1. ☑ Optimize current expenses                             ║
║     └─ Review subscriptions, reduce dining out, etc.        ║
║     └─ Target: Save $200/month                              ║
║                                                               ║
║  2. ☑ Set up automatic transfers                            ║
║     └─ Link bank account, schedule transfers                ║
║     └─ Target: $500/month on autopilot                      ║
║                                                               ║
║  3. ☑ Find additional income                                ║
║     └─ Side gig, sell items, freelance work                 ║
║     └─ Target: Extra $300/month                             ║
║                                                               ║
║  4. ☑ Build the habit                                       ║
║     └─ Track progress weekly, celebrate milestones          ║
║     └─ Target: 3 months of consistent saving                ║
║                                                               ║
║  5. ☐ Protect the fund                                      ║
║     └─ Keep it separate, resist withdrawals                 ║
║     └─ Target: 0 withdrawals for non-emergencies            ║
║                                                               ║
║  ┌─────────────────────────────────────────────────────┐    ║
║  │ ➕ Add Custom Goal                                  │    ║
║  └─────────────────────────────────────────────────────┘    ║
║                                                               ║
║  [← Back]                              [Continue →]          ║
╚═══════════════════════════════════════════════════════════════╝
```

---

#### Step 4: Timeline & Milestones
```
╔═══════════════════════════════════════════════════════════════╗
║  💰 Create Financial Milestone (4/5)                          ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  Set your savings timeline                                   ║
║                                                               ║
║  Target Completion Date*                                     ║
║  ┌───────────────────────────────────────────────────────┐  ║
║  │ 📅 July 1, 2026                             [Calendar] │  ║
║  └───────────────────────────────────────────────────────┘  ║
║                                                               ║
║  Duration: 15 months (based on $500/month savings)           ║
║                                                               ║
║  Interim Milestones (auto-calculated)                        ║
║  ┌───────────────────────────────────────────────────────┐  ║
║  │ ✅ $2,500 saved (current)           ▓▓▓░░░░░░░░ 25%   │  ║
║  │                                                        │  ║
║  │ ⏳ $5,000 saved (halfway)           ░░░░░░░░░░ 0%     │  ║
║  │    Target: Oct 1, 2025                                │  ║
║  │                                                        │  ║
║  │ ⏳ $7,500 saved (75%)                ░░░░░░░░░░ 0%     │  ║
║  │    Target: Feb 1, 2026                                │  ║
║  │                                                        │  ║
║  │ ⏳ $10,000 saved (DONE!)             ░░░░░░░░░░ 0%     │  ║
║  │    Target: Jul 1, 2026                                │  ║
║  └───────────────────────────────────────────────────────┘  ║
║                                                               ║
║  Reminder Settings                                           ║
║  ☑ Weekly check-in (Sundays at 6 PM)                        ║
║  ☑ Monthly progress report                                   ║
║  ☑ Alert me if I'm off track                                ║
║  ☑ Celebrate when I hit interim milestones                  ║
║                                                               ║
║  [← Back]                              [Continue →]          ║
╚═══════════════════════════════════════════════════════════════╝
```

---

#### Step 5: Tracking & Motivation
```
╔═══════════════════════════════════════════════════════════════╗
║  💰 Create Financial Milestone (5/5)                          ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  How will you track progress?                                ║
║                                                               ║
║  Update Frequency                                            ║
║  ○ Daily (manual entry)                                      ║
║  ● Weekly (recommended)                                      ║
║  ○ Monthly                                                   ║
║  ○ Automatic sync (coming soon: Plaid integration)          ║
║                                                               ║
║  Visualization Preference                                    ║
║  ☑ Progress bar                                              ║
║  ☑ Line chart (savings over time)                           ║
║  ☑ Countdown to target                                       ║
║  ☐ Thermometer visual                                        ║
║                                                               ║
║  Motivation Boosters                                         ║
║  ┌───────────────────────────────────────────────────────┐  ║
║  │ Why are you building this emergency fund?             │  ║
║  │                                                        │  ║
║  │ I want to feel financially secure and prepared for   │  ║
║  │ any unexpected expenses without going into debt.     │  ║
║  │ This will give me peace of mind and freedom.         │  ║
║  └───────────────────────────────────────────────────────┘  ║
║                                                               ║
║  Reward Yourself (optional)                                  ║
║  ┌───────────────────────────────────────────────────────┐  ║
║  │ When I hit $5,000: Treat myself to a nice dinner     │  ║
║  │ When I hit $10,000: Take a weekend trip to celebrate │  ║
║  └───────────────────────────────────────────────────────┘  ║
║                                                               ║
║  Point System                                                ║
║  ☑ Earn points for every $100 saved                         ║
║  ☑ Bonus points for hitting interim milestones              ║
║  ☑ Streak bonus for consecutive weeks of saving             ║
║                                                               ║
║  [← Back]                         [Create Financial Goal]    ║
╚═══════════════════════════════════════════════════════════════╝
```

---

### 2. MILESTONE CARD - Finance

#### Collapsed State
```
┌─────────────────────────────────────────────────────────────┐
│ 💰 Build $10,000 emergency fund                  [⋮] [❤️]   │
│                                                              │
│ Emergency Fund • High-Yield Savings                         │
│                                                              │
│ ██████░░░░░░░░░░░░░░░░ $2,500 / $10,000                     │
│                                                              │
│ 📊  25% complete            ⏰  Target: Jul 1, 2026          │
│ 💵  $500/month savings      🔥  On track (+$200 this week)  │
│                                                              │
│ Next Milestone: $5,000 (halfway) by Oct 1, 2025             │
│                                                              │
│ [Log Savings] [View Progress] [Adjust Plan]                 │
└─────────────────────────────────────────────────────────────┘
```

**Animations:**
- Progress bar fills when new savings logged (with $ amount floating up)
- Milestone hit = coin rain animation + achievement badge
- On track = green pulsing indicator, behind = orange, off track = red

---

#### Expanded State
```
╔═══════════════════════════════════════════════════════════════╗
║ 💰 Build $10,000 emergency fund                     [⋮] [❤️]  ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║ I want to feel financially secure and prepared for any       ║
║ unexpected expenses without going into debt. This will give  ║
║ me peace of mind and freedom.                                ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ Account Details:                                        │ ║
║ │ High-Yield Savings • Monthly Expenses: $3,500           │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ PROGRESS OVERVIEW                                       │ ║
║ │                                                         │ ║
║ │ ██████░░░░░░░░░░░░░░░░ 25% complete                    │ ║
║ │                                                         │ ║
║ │ Current: $2,500 | Target: $10,000 | Remaining: $7,500 │ ║
║ │                                                         │ ║
║ │ ✅ $2,500 saved (25%)              Achieved: Mar 2025  │ ║
║ │    └─ 🎉 Starting point milestone                      │ ║
║ │                                                         │ ║
║ │ ⏳ $5,000 saved (50% - Halfway!)   Target: Oct 1, 2025 │ ║
║ │    └─ Need $2,500 more in 6 months                     │ ║
║ │    └─ Status: 🔥 On track ($417/month needed)          │ ║
║ │                                                         │ ║
║ │ ⏳ $7,500 saved (75%)               Target: Feb 1, 2026│ ║
║ │    └─ Need $5,000 more in 10 months                    │ ║
║ │                                                         │ ║
║ │ ⏳ $10,000 saved (DONE!)            Target: Jul 1, 2026│ ║
║ │    └─ Need $7,500 more in 15 months                    │ ║
║ │    └─ 🎊 Celebration: Weekend trip!                    │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ SAVINGS PLAN                                            │ ║
║ │                                                         │ ║
║ │ Target: $500/month • Duration: 15 months               │ ║
║ │                                                         │ ║
║ │ ✅ Optimize expenses (100%)        Goal: Save $200/mo  │ ║
║ │    └─ 4 tasks • Cut subscriptions, meal prep, etc.     │ ║
║ │                                                         │ ║
║ │ 🔄 Set up automatic transfers (60%) Goal: $500/mo auto │ ║
║ │    └─ 3 of 5 tasks • Bank linked, transfer scheduled   │ ║
║ │    └─ [View Tasks →]                                   │ ║
║ │                                                         │ ║
║ │ ⏳ Find additional income (0%)     Goal: +$300/mo      │ ║
║ │    └─ 0 of 3 tasks • Not started yet                   │ ║
║ │    └─ [Start Planning →]                               │ ║
║ │                                                         │ ║
║ │ ⏳ Build the habit (20%)            Goal: 3mo streak   │ ║
║ │    └─ 2 of 10 tasks • Weekly tracking started          │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ THIS MONTH (April 2025)                                 │ ║
║ │                                                         │ ║
║ │ Saved so far: $200 / $500 (40%)                        │ ║
║ │ ████░░░░░░                                              │ ║
║ │                                                         │ ║
║ │ Recent deposits:                                        │ ║
║ │ Apr 1:  +$100 (Automatic transfer)                     │ ║
║ │ Apr 7:  +$50  (Sold old textbooks)                     │ ║
║ │ Apr 14: +$50  (Tax refund)                             │ ║
║ │                                                         │ ║
║ │ Days left: 16 • Need: $300 more ($18.75/day)           │ ║
║ │                                                         │ ║
║ │ [+ Log Deposit]                                        │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ INSIGHTS & STATS                                        │ ║
║ │                                                         │ ║
║ │ 📈 Avg. monthly savings: $500 (exactly on target!)     │ ║
║ │ 🔥 Current streak: 3 months of $500+ saved             │ ║
║ │ 🎯 Total points earned: 250 (25 points per $100)       │ ║
║ │ ⚡ Best month: March 2025 ($650 saved)                 │ ║
║ │ 📊 Projected completion: Jul 1, 2026 (on time!)        │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ CHART: Savings Over Time                                │ ║
║ │                                                         │ ║
║ │  $10k ┤                                        ⭐       │ ║
║ │       │                                                 │ ║
║ │  $7.5k┤                               ⋯⋯⋯⋯⋯          │ ║
║ │       │                       ⋯⋯⋯⋯⋯                   │ ║
║ │  $5k  ┤              ⋯⋯⋯⋯⋯                            │ ║
║ │       │      ⋯⋯⋯⋯⋯                                    │ ║
║ │  $2.5k┤━━━━━━●                                         │ ║
║ │       │      ↑                                         │ ║
║ │    $0 ┼──────┴────────────────────────────────────────│ ║
║ │       Jan  Apr   Jul   Oct  Jan  Apr   Jul            │ ║
║ │       2025      2025   2025 2026 2026  2026           │ ║
║ │                                                         │ ║
║ │ ● Current  ⋯ Projected  ⭐ Goal                         │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ [Edit Milestone] [Log Deposit] [Adjust Plan] [Delete]       ║
╚═══════════════════════════════════════════════════════════════╝
```

**Interactions:**
- Click "Log Deposit" → Quick modal to add $ amount + source
- Progress chart animates on load
- Auto-calculates "days left" and "needed per day"
- Streak counter increments with confetti when milestone hit
- Points roll up with each deposit

---

### 3. GOAL CARD - Finance

#### Collapsed State
```
┌─────────────────────────────────────────────────────────────┐
│ 🔁 Set up automatic transfers                    [⋮] [↗️]   │
│                                                              │
│ Part of: Build $10,000 emergency fund                       │
│                                                              │
│ ████████████░░░░░░░░ 3 of 5 tasks done                      │
│                                                              │
│ 💰  $500/month autopilot    ⏱️  Due: Apr 30, 2025          │
│ 🎯  50 points (30 earned)   🔥  In progress                 │
│                                                              │
│ Next: Test first automatic transfer                         │
│                                                              │
│ [View Tasks] [Log Progress]                                  │
└─────────────────────────────────────────────────────────────┘
```

**Animations:**
- On task completion: Money icon flies to progress bar
- Goal complete: "Autopilot enabled" badge + trophy animation

---

#### Expanded State
```
╔═══════════════════════════════════════════════════════════════╗
║ 🔁 Set up automatic transfers                       [⋮] [↗️]  ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║ Part of: 💰 Build $10,000 emergency fund                      ║
║ Goal 2 of 5 • Timeline: Apr 1 - Apr 30, 2025                 ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ GOAL OVERVIEW                                           │ ║
║ │                                                         │ ║
║ │ Set up automatic recurring transfers of $500/month from │ ║
║ │ checking to high-yield savings account, so saving       │ ║
║ │ happens on autopilot without manual intervention.      │ ║
║ │                                                         │ ║
║ │ Target Amount: $500/month on autopilot                 │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ PROGRESS                                                │ ║
║ │                                                         │ ║
║ │ ████████████░░░░░░░░ 60% complete                      │ ║
║ │                                                         │ ║
║ │ ✅  3 of 5 tasks complete                              │ ║
║ │ 🎯  30 of 50 points earned                             │ ║
║ │ ⏱️  Due: Apr 30, 2025 (16 days left)                   │ ║
║ │ 🔥  Status: On track                                   │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ TASKS                                                   │ ║
║ │                                                         │ ║
║ │ ✅ Research high-yield savings accounts (10 pts) • Apr 2│ ║
║ │    └─ Subtasks: Compare rates, read reviews (2/2)     │ ║
║ │    └─ Result: Chose Ally Bank (1.5% APY)              │ ║
║ │                                                         │ ║
║ │ ✅ Open savings account (10 pts) • Apr 5               │ ║
║ │    └─ Subtasks: Fill application, verify identity     │ ║
║ │    └─ Account #: ****1234                              │ ║
║ │                                                         │ ║
║ │ ✅ Link checking to savings (10 pts) • Apr 7           │ ║
║ │    └─ Subtasks: Add external account, verify micro-   │ ║
║ │                 deposits                               │ ║
║ │                                                         │ ║
║ │ 🔄 Set up recurring transfer (15 pts) • In progress    │ ║
║ │    └─ Subtasks (1/2):                                  │ ║
║ │       ✅ Schedule $500 monthly transfer (1st of month) │ ║
║ │       ⏳ Test first transfer and confirm              │ ║
║ │                                                         │ ║
║ │ ⏳ Monitor and adjust (5 pts) • Not started            │ ║
║ │    └─ Check first 3 months, ensure no issues          │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ SAVINGS IMPACT                                          │ ║
║ │                                                         │ ║
║ │ Once complete, you'll save $500/month automatically:   │ ║
║ │ • Year 1: $6,000 saved                                 │ ║
║ │ • Year 2: $12,000 total (emergency fund COMPLETE!)     │ ║
║ │ • 5 Years: $30,000+ (with compound interest)           │ ║
║ │                                                         │ ║
║ │ Interest earned (projected): $225/year at 1.5% APY     │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ NOTES & TIPS                                            │ ║
║ │                                                         │ ║
║ │ 💡 Set transfer date right after payday so you "pay    │ ║
║ │    yourself first" before spending                     │ ║
║ │                                                         │ ║
║ │ 📝 First transfer scheduled for May 1, 2025            │ ║
║ │                                                         │ ║
║ │ ⚠️  Remember to keep $1k buffer in checking to avoid   │ ║
║ │    overdrafts                                           │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ [Edit Goal] [Add Task] [View Milestone] [Delete]            ║
╚═══════════════════════════════════════════════════════════════╝
```

**Finance-Specific Features:**
- **$ Impact Calculator**: Shows long-term impact (Year 1, 5, 10)
- **Interest Projection**: APY calculations
- **Account Linking**: Store account numbers (masked)
- **Transfer Scheduling**: Date, amount, frequency tracking

---

### 4. TASK CARD - Finance

#### Collapsed State (List View)
```
┌──────────────────────────────────────────┐
│ ✅ Research high-yield savings accounts  │
│                                          │
│ 🔁 Set up automatic transfers            │
│                                          │
│ ████████████████████ 2/2 subtasks       │
│                                          │
│ 🏷️ Savings, Research, Banking            │
│ 📅 Completed: Apr 2  🎯 10 points        │
│                                          │
│ Result: Chose Ally Bank (1.5% APY)      │
└──────────────────────────────────────────┘
```

---

#### Expanded Modal
```
╔═══════════════════════════════════════════════════════════════╗
║ ✅ Research high-yield savings accounts                 [X]   ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║ Part of: 🔁 Set up automatic transfers →                      ║
║          💰 Build $10,000 emergency fund                      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ DESCRIPTION                                             │ ║
║ │                                                         │ ║
║ │ Research and compare high-yield savings accounts to    │ ║
║ │ find the best APY rate, no fees, and easy access for   │ ║
║ │ emergency fund. Prioritize FDIC-insured accounts.      │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ SUBTASKS (2/2)                                          │ ║
║ │                                                         │ ║
║ │ ✅ Compare top 5 banks by APY rate                     │ ║
║ │    └─ Researched: Ally (1.5%), Marcus (1.4%),         │ ║
║ │                    Capital One 360 (1.3%)              │ ║
║ │    └─ Completed: Apr 2, 2025                           │ ║
║ │                                                         │ ║
║ │ ✅ Read reviews and check fees                         │ ║
║ │    └─ Ally has no monthly fees, good mobile app        │ ║
║ │    └─ Completed: Apr 2, 2025                           │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ DECISION & OUTCOME                                      │ ║
║ │                                                         │ ║
║ │ ✅ Selected: Ally Bank High-Yield Savings              │ ║
║ │                                                         │ ║
║ │ Reasons:                                                │ ║
║ │ • 1.5% APY (highest among top picks)                   │ ║
║ │ • No monthly fees or minimum balance                   │ ║
║ │ • Excellent mobile app for easy access                 │ ║
║ │ • FDIC insured up to $250k                             │ ║
║ │                                                         │ ║
║ │ Projected interest: $150/year on $10k balance          │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ COMPARISON TABLE                                        │ ║
║ │                                                         │ ║
║ │ Bank            APY    Fees   Min. Balance  Rating     │ ║
║ │ ────────────────────────────────────────────────────   │ ║
║ │ Ally Bank      1.5%    $0       $0          4.8/5 ✅  │ ║
║ │ Marcus         1.4%    $0       $0          4.7/5     │ ║
║ │ Capital One    1.3%    $0       $0          4.5/5     │ ║
║ │ Discover       1.3%    $0       $0          4.6/5     │ ║
║ │ CIT Bank       1.5%    $0       $100        4.3/5     │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ METADATA                                                │ ║
║ │                                                         │ ║
║ │ Status:        ✅ Completed                            │ ║
║ │ Priority:      🔥 High                                 │ ║
║ │ Due Date:      📅 Apr 2, 2025                          │ ║
║ │ Points:        🎯 10 (earned Apr 2)                    │ ║
║ │ Tags:          🏷️ Savings, Research, Banking, APY     │ ║
║ │ Time Spent:    ⏱️ 1.5 hours                            │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ LINKS & RESOURCES                                       │ ║
║ │                                                         │ ║
║ │ 🔗 Ally Bank: ally.com/bank/online-savings-account     │ ║
║ │ 🔗 NerdWallet Review: nerdwallet.com/reviews/banking   │ ║
║ │ 🔗 Reddit r/personalfinance thread                     │ ║
║ │                                                         │ ║
║ │ [+ Add Link]                                           │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────────┐ ║
║ │ NOTES                                                   │ ║
║ │                                                         │ ║
║ │ 📝 Also considered Marcus, but Ally had better mobile  │ ║
║ │    app reviews. CIT Bank requires $100 min, not ideal. │ ║
║ │                                                         │ ║
║ │ 💡 Future: Look into CD ladders once emergency fund    │ ║
║ │    is fully built (higher rates for locked funds)      │ ║
║ └─────────────────────────────────────────────────────────┘ ║
║                                                               ║
║ [Edit Task] [Duplicate] [Move to Goal] [Delete] [Archive]   ║
╚═══════════════════════════════════════════════════════════════╝
```

**Finance-Specific Fields:**
- **Decision & Outcome**: What was chosen and why
- **Comparison Table**: Side-by-side financial product comparison
- **APY/Interest Calculations**: Auto-calculate projected earnings
- **Account Details**: Store masked account numbers, routing info
- **$ Amount Tracking**: For deposits, transfers, payments
- **Financial Links**: Bank websites, account dashboards, calculators

---

## CROSS-DOMAIN FEATURES

### Shared UI Patterns Across All Domains

1. **Template Selection**
   - Iconography specific to domain
   - Clear descriptions with use cases
   - "Custom" option always available

2. **Wizard Flow**
   - 3-5 steps max
   - Progress indicator
   - Back/Continue navigation
   - Auto-save on each step
   - Smart defaults with customization

3. **Cards (All Levels)**
   - Collapsed: Key metrics, next action, CTA
   - Expanded: Full context, subtasks, insights, activity feed
   - Hover: Lift + shadow
   - Animations: Progress fills, confetti on completion, point counters

4. **Progress Visualization**
   - Progress bars with percentage
   - Task counters (X of Y)
   - Timeline/deadline proximity
   - Status indicators (✅ 🔄 ⏳ ⚠️)

5. **Points & Gamification**
   - Points displayed on all cards
   - Earned vs. potential
   - Roll-up from Task → Goal → Milestone
   - Streak tracking
   - Celebration animations

6. **Metadata Consistency**
   - Status, Priority, Due Date, Tags
   - Points, Time tracking
   - Assigned to (for collaborative domains)

7. **Activity Feeds**
   - Recent completions
   - Blockers/resolutions
   - Timeline of changes

8. **Insights & Learning**
   - Auto-generated from patterns
   - "What worked" / "What to avoid"
   - Domain-specific tips

---

## IMPLEMENTATION NOTES

### Database Schema Enhancements

Each domain requires custom fields stored as JSON in `metadata` column:

**Projects:**
```json
{
  "projectType": "Web App",
  "techStack": ["React", "TypeScript", "Node.js"],
  "repoUrl": "github.com/...",
  "links": [{"type": "figma", "url": "..."}, ...],
  "kpis": [{"metric": "Lighthouse Score", "target": "95+", "current": "—"}]
}
```

**Finance:**
```json
{
  "goalType": "Emergency Fund",
  "targetAmount": 10000,
  "currentAmount": 2500,
  "monthlyTarget": 500,
  "accountType": "High-Yield Savings",
  "accountNumber": "****1234",
  "apy": 1.5,
  "interestEarned": 0
}
```

### UI Components to Build

1. **ProjectTemplateWizard** (5 steps)
2. **FinanceTemplateWizard** (5 steps)
3. **ProjectMilestoneCard** (collapsed + expanded)
4. **FinanceMilestoneCard** (collapsed + expanded with chart)
5. **ProjectGoalCard** (phase tracking)
6. **FinanceGoalCard** (savings plan tracking)
7. **ProjectTaskCard** (tech stack, links, time tracking)
8. **FinanceTaskCard** (decision matrix, $ impact)
9. **FinanceSavingsChart** (line chart for progress over time)
10. **DecisionMatrix** (comparison table widget)
11. **KPITracker** (for projects)
12. **DepositLogger** (quick modal for finance)

### Animations Library

- **MoneyRain**: Coin animation when financial milestone hit
- **ProgressFill**: Smooth bar fill with $ amount floating
- **TrophyPop**: Achievement unlock
- **ChartGrow**: Line chart animates from left to right
- **PointCounter**: Number increments with sound effect
- **ConfettiBurst**: On major milestone completion

---

## DESIGN SYSTEM ALIGNMENT

All domain-specific UIs follow the core design system:

**Colors:**
- Orange (#FF6B35) - Primary actions, progress, fire icons
- Teal (#4ECDC4) - Secondary, accents, completion states
- Dark background (#1A1A2E)
- Cards: #16213E with subtle borders
- Text: #EAEAEA primary, #A0A0A0 secondary

**Typography:**
- Headings: Inter Bold
- Body: Inter Regular
- Monospace: JetBrains Mono (for numbers, $ amounts, percentages)

**Spacing:**
- Card padding: 24px
- Section gaps: 16px
- Button gaps: 12px

**Animations:**
- Duration: 200-400ms
- Easing: cubic-bezier(0.4, 0.0, 0.2, 1)
- Stagger children: 50ms delay

---
# 🎨 **COMPLETE UI DESIGN - DOMAINS 2-5** (Continued)

---

## **4. DOMAIN: FITNESS** 💪

### **4.1 Template Wizard - Fitness**

**Step 1: Fitness Goal Setup**

```
┌───────────────────────────────────────────────────────────────────────┐
│  💪 New Fitness Goal                                 Step 1 of 3  [×] │
├───────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  GOAL TYPE                                                            │
│                                                                       │
│  ○ Strength Training (Lift heavier weight)                           │
│  ● Weight Loss/Gain (Change body weight)                             │
│  ○ Endurance (Run farther/faster)                                    │
│  ○ Body Composition (Build muscle, lose fat)                         │
│  ○ Skill (Learn handstand, muscle-up, etc.)                          │
│                                                                       │
│  GOAL DETAILS                                                         │
│                                                                       │
│  Goal Name *                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ Bench Press 225 lbs                                             │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  Current Status                        Target                         │
│  ┌──────────────────────┐  ┌──────────────────────────────────────┐ │
│  │ Current Max: [185] lbs│  │ Target Weight: [225] lbs           │ │
│  └──────────────────────┘  └──────────────────────────────────────┘ │
│                                                                       │
│  Timeline                                                             │
│  ┌──────────────────────┐  ┌──────────────────────────────────────┐ │
│  │ Start: [10/01/2024]  │  │ Target Date: [01/01/2025]          │ │
│  └──────────────────────┘  └──────────────────────────────────────┘ │
│                             (13 weeks / ~3 months)                   │
│                                                                       │
│  Body Stats (optional)                                                │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐                │
│  │ Weight: [175]│ │ Height: [6'0]│ │ Age: [25___]│                │
│  └──────────────┘ └──────────────┘ └──────────────┘                │
│                                                                       │
│                                           [Cancel]  [Next: Program →] │
└───────────────────────────────────────────────────────────────────────┘
```

**Step 2: Training Program**

```
┌───────────────────────────────────────────────────────────────────────┐
│  💪 New Fitness Goal                                 Step 2 of 3  [×] │
├───────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  TRAINING PROGRAM                                                     │
│                                                                       │
│  Progression Type                                                     │
│  ● Linear Progression (Add weight weekly)                            │
│  ○ Wave Loading (Vary intensity)                                     │
│  ○ Percentage-Based (% of 1RM)                                       │
│  ○ Custom Program                                                     │
│                                                                       │
│  Weekly Structure                                                     │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ Training Days per Week: [4] days                                │ │
│  │                                                                 │ │
│  │ Suggested Split: Push / Pull / Legs / Upper                    │ │
│  │                                                                 │ │
│  │ Day 1: Monday    - Push (Chest, Shoulders, Triceps)            │ │
│  │ Day 2: Tuesday   - Pull (Back, Biceps)                         │ │
│  │ Day 3: Thursday  - Legs (Quads, Hamstrings, Glutes)            │ │
│  │ Day 4: Saturday  - Upper (Full upper body)                     │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  Progression Plan                                                     │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ Starting Weight: 185 lbs                                        │ │
│  │ Weekly Increase: +5 lbs every week                              │ │
│  │ Sets x Reps: 5 x 5 (increasing to 3 x 3 at heavier weights)    │ │
│  │                                                                 │ │
│  │ Estimated Timeline:                                             │ │
│  │ Week 1-4:  185-200 lbs (5x5)                                    │ │
│  │ Week 5-8:  205-215 lbs (4x4)                                    │ │
│  │ Week 9-12: 220-230 lbs (3x3)                                    │ │
│  │ Week 13:   Test 1RM (225 lbs goal!)                             │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  Nutrition (optional)                                                 │
│  ┌──────────────────────┐  ┌──────────────────────────────────────┐ │
│  │ Daily Calories:      │  │ Protein Target:                      │ │
│  │ [3200] kcal          │  │ [180] g/day                          │ │
│  └──────────────────────┘  └──────────────────────────────────────┘ │
│                                                                       │
│  ☑ Track nutrition daily                                             │
│  ☑ Track body weight weekly                                          │
│  ☑ Schedule deload week every 4 weeks                                │
│                                                                       │
│                                              [← Back]  [Next: Review →] │
└───────────────────────────────────────────────────────────────────────┘
```

**Step 3: Review & Create**

```
┌───────────────────────────────────────────────────────────────────────┐
│  💪 New Fitness Goal                                 Step 3 of 3  [×] │
├───────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  REVIEW YOUR FITNESS PLAN                                             │
│                                                                       │
│  🎯 Goal Summary                                                      │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ Bench Press 225 lbs                                             │ │
│  │ Current: 185 lbs → Target: 225 lbs (+40 lbs gain)               │ │
│  │ Oct 1, 2024 - Jan 1, 2025 (13 weeks)                            │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  💪 Training Structure                                               │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ • 4 days/week: Push / Pull / Legs / Upper split                │ │
│  │ • Linear progression: +5 lbs/week                               │ │
│  │ • Starting: 5x5 @ 185 lbs                                       │ │
│  │ • Peak: 3x3 @ 225+ lbs                                          │ │
│  │ • Deload weeks: Week 4, 8, 12                                   │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  🍎 Nutrition Plan                                                   │
│  • 3200 calories/day • 180g protein/day                              │
│                                                                       │
│  📊 This will create:                                                │
│  • 1 Milestone: "Bench Press 225 lbs"                                │
│  • 13 Goals: Weekly progression blocks                               │
│  • 52 Tasks: Individual workouts (4/week × 13 weeks)                 │
│  • 200+ Subtasks: Sets, reps, nutrition tracking                     │
│                                                                       │
│  💡 Auto-tracked metrics:                                            │
│  • Weight lifted per workout                                         │
│  • Body weight weekly                                                │
│  • Progress photos (optional reminder)                               │
│  • Personal Records (PRs)                                            │
│                                                                       │
│                                     [← Back]  [Create Program! 💪]   │
└───────────────────────────────────────────────────────────────────────┘
```

### **4.2 Fitness Milestone Card - EXPANDED**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  💪 Bench Press 225 lbs                                              [73%] │
│  Oct 1, 2024 - Jan 1, 2025 • 13 weeks • Strength Goal                     │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                                                             │
│  🎯 PROGRESS TRACKER                                                       │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Current Max: 215 lbs                          Target: 225 lbs         │ │
│  │ Starting: 185 lbs                             Gain: +30 lbs           │ │
│  │                                                                       │ │
│  │ Progress: 30/40 lbs gained (75%)              10 lbs to go!           │ │
│  │ ██████████████████████████████████████░░░░░░░░                       │ │
│  │                                                                       │ │
│  │ 📅 Week 9 of 13 (73% complete)                                        │ │
│  │ ⏰ 4 weeks remaining                                                  │ │
│  │ 📊 On track to hit goal! 🔥                                           │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📈 STRENGTH PROGRESSION CHART                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Bench Press Weight (lbs)                                              │ │
│  │                                                                       │ │
│  │ 225├─────────────────────────────────────────── Goal Line             │ │
│  │    │                                       ●                           │ │
│  │ 215├───────────────────────────────────●───── Current (Week 9)        │ │
│  │    │                               ●                                   │ │
│  │ 205├───────────────────────────●───────────────                       │ │
│  │    │                       ●                                           │ │
│  │ 195├───────────────────●───────────────────────                       │ │
│  │    │               ●                                                   │ │
│  │ 185├───────────●───────────────────────────────                       │ │
│  │    │       ●                                                           │ │
│  │ 175├───●───────────────────────────────────────                       │ │
│  │    └───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬──                       │ │
│  │        W1  W2  W3  W4  W5  W6  W7  W8  W9  W13                        │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📊 STATS & METRICS                                                        │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Total Workouts: 36/52 (73%)                                           │ │
│  │ Consistency: 4/4 days this week ✅                                    │ │
│  │ Volume Lifted: 24,500 lbs this week                                   │ │
│  │ Body Weight: 178 lbs (↑3 lbs from start)                              │ │
│  │ Rest Days: 3/week                                                     │ │
│  │ Deload Weeks Completed: 2/3                                           │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  🏆 PERSONAL RECORDS                                                       │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ 🥇 Current 1RM: 215 lbs (Week 9)                                      │ │
│  │ 🥈 Previous PR: 205 lbs (Week 7)                                      │ │
│  │ 🥉 Starting 1RM: 185 lbs (Week 1)                                     │ │
│  │                                                                       │ │
│  │ Volume PRs:                                                           │ │
│  │ • Best 5x5: 195 lbs (Week 6)                                          │ │
│  │ • Best 3x3: 215 lbs (Week 9) ⭐ NEW!                                  │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  🍎 NUTRITION TRACKING                                                     │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ This Week Average:                                                    │ │
│  │ Calories: 3180/3200 (99%) ✅                                          │ │
│  │ Protein: 175/180g (97%) ✅                                            │ │
│  │ Days Tracked: 7/7 ✅                                                  │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📅 WEEKLY BREAKDOWN                                                       │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ ✓ Week 1-4: Foundation Block (185-200 lbs, 5x5)                      │ │
│  │ ✓ Week 5-8: Building Block (205-215 lbs, 4x4)                        │ │
│  │ ▶ Week 9-12: Peak Block (220-230 lbs, 3x3) - CURRENT                 │ │
│  │ ○ Week 13: Test Week (1RM attempt 225+)                              │ │
│  │                                                                       │ │
│  │ [View All Weeks]                                                      │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📎 RESOURCES                                                              │
│  🔗 Training Program PDF                                                   │
│  🔗 Form Check Videos                                                      │
│  🔗 Nutrition Spreadsheet                                                  │
│  📸 Progress Photos (Week 1, 5, 9)                                         │
│                                                                             │
│  📝 NOTES                                                                  │
│  "Feeling strong! Form is solid. Sleep has been good. Ready for 220 next!" │
│                                                                             │
│  [Collapse ↑]  [View Workouts]  [Edit Goal]  [Log Workout]  [×]          │
└─────────────────────────────────────────────────────────────────────────────┘
```

### **4.3 Fitness Task Card (Workout) - EXPANDED**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  💪 Week 9: Push Day (Chest Focus)                                   [100%] │
│  Monday, Nov 25, 2024 • Bench Press 225 Program                           │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                                                             │
│  🎯 WORKOUT SUMMARY                                                        │
│  Duration: 1h 25min • Volume: 12,450 lbs lifted • Completed: Nov 25, 6:30 AM│
│  ✅ All sets completed • 🔥 New PR: 215 lbs x 3 reps!                     │
│                                                                             │
│  🏋️ EXERCISES                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ 1. BARBELL BENCH PRESS (Main Lift) 🎯                                │ │
│  │    Target: 3 sets × 3 reps @ 215 lbs                                 │ │
│  │                                                                       │ │
│  │    ✓ Set 1: 215 lbs × 3 reps ✅                                      │ │
│  │    ✓ Set 2: 215 lbs × 3 reps ✅                                      │ │
│  │    ✓ Set 3: 215 lbs × 3 reps ✅ 🔥 NEW PR!                           │ │
│  │    Rest: 3-4 min between sets                                        │ │
│  │                                                                       │ │
│  │    💬 "Form felt perfect. Bar speed was fast. Ready for 220 next!"   │ │
│  │                                                                       │ │
│  │ 2. INCLINE DUMBBELL PRESS (Accessory)                                │ │
│  │    ✓ Set 1: 70 lbs × 8 reps                                          │ │
│  │    ✓ Set 2: 70 lbs × 8 reps                                          │ │
│  │    ✓ Set 3: 70 lbs × 7 reps                                          │ │
│  │    Rest: 2 min                                                        │ │
│  │                                                                       │ │
│  │ 3. CABLE FLIES (Isolation)                                           │ │
│  │    ✓ Set 1: 40 lbs × 12 reps                                         │ │
│  │    ✓ Set 2: 40 lbs × 12 reps                                         │ │
│  │    ✓ Set 3: 40 lbs × 10 reps                                         │ │
│  │                                                                       │ │
│  │ 4. OVERHEAD PRESS (Shoulders)                                        │ │
│  │    ✓ Set 1: 95 lbs × 8 reps                                          │ │
│  │    ✓ Set 2: 95 lbs × 7 reps                                          │ │
│  │    ✓ Set 3: 95 lbs × 6 reps                                          │ │
│  │                                                                       │ │
│  │ 5. TRICEP PUSHDOWNS (Arms)                                           │ │
│  │    ✓ Set 1: 60 lbs × 12 reps                                         │ │
│  │    ✓ Set 2: 60 lbs × 12 reps                                         │ │
│  │    ✓ Set 3: 60 lbs × 10 reps                                         │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📊 WORKOUT STATS                                                          │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Total Volume: 12,450 lbs                                              │ │
│  │ Total Sets: 15                                                        │ │
│  │ Total Reps: 135                                                       │ │
│  │ Average Rest: 2.5 min                                                 │ │
│  │ Heart Rate Avg: 128 bpm                                               │ │
│  │ Calories Burned: ~420 kcal                                            │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  🍎 NUTRITION (Day Total)                                                  │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Calories: 3250/3200 ✅                                                │ │
│  │ Protein: 185/180g ✅                                                  │ │
│  │ Carbs: 420g • Fat: 95g • Water: 3.5L                                 │ │
│  │                                                                       │ │
│  │ Pre-Workout: Oats + Banana + Coffee (6:00 AM)                        │ │
│  │ Post-Workout: Protein shake + Rice (8:00 AM)                         │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  😊 FEEL & RECOVERY                                                        │
│  Energy: ⭐⭐⭐⭐⭐ (5/5)                                                    │
│  Sleep: 8.5 hours (excellent)                                              │
│  Soreness: Minimal                                                         │
│  Mood: Pumped! 💪                                                          │
│                                                                             │
│  📝 NOTES                                                                  │
│  "Best bench session yet! Bar moved fast on all sets. No grind. Form was    │
│   perfect - elbows tucked, leg drive strong. Ready to jump to 220 next     │
│   week. Feeling confident about hitting 225 in Week 13!"                  │
│                                                                             │
│  [Collapse ↑]  [Edit Workout]  [Copy to Next Week]  [View History]  [×]  │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## **5. DOMAIN: DSA/CODING** 💻

### **5.1 Template Wizard - DSA**

**Step 1: Problem-Solving Goal**

```
┌───────────────────────────────────────────────────────────────────────┐
│  💻 New DSA Goal                                     Step 1 of 3  [×] │
├───────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  GOAL TYPE                                                            │
│                                                                       │
│  ● Problem Count (Solve X problems)                                  │
│  ○ Pattern Mastery (Master specific patterns)                        │
│  ○ Contest Prep (Codeforces, LeetCode contests)                      │
│  ○ Interview Prep (Company-specific)                                 │
│                                                                       │
│  GOAL DETAILS                                                         │
│                                                                       │
│  Goal Name *                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ Master Graph Algorithms - 100 Problems                          │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  Problem Distribution                                                 │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐                │
│  │ Easy: [30__]│ │ Medium: [50_]│ │ Hard: [20__]│                │
│  └──────────────┘ └──────────────┘ └──────────────┘                │
│              Total: 100 problems                                     │
│                                                                       │
│  Patterns/Topics (select multiple)                                   │
│  ☑ DFS (Depth-First Search)                                          │
│  ☑ BFS (Breadth-First Search)                                        │
│  ☑ Dijkstra's Algorithm                                              │
│  ☑ Topological Sort                                                  │
│  ☑ Union Find                                                        │
│  ☑ Minimum Spanning Tree                                             │
│  ☐ Max Flow                                                          │
│  ☐ Strongly Connected Components                                     │
│                                                                       │
│  Timeline                                                             │
│  ┌──────────────────────┐  ┌──────────────────────────────────────┐ │
│  │ Start: [11/01/2024]  │  │ Target: [01/31/2025]               │ │
│  └──────────────────────┘  └──────────────────────────────────────┘ │
│                             (13 weeks, ~8 problems/week)             │
│                                                                       │
│  Platform Preference                                                  │
│  ● LeetCode                                                           │
│  ○ HackerRank                                                         │
│  ○ Codeforces                                                         │
│  ○ Mixed                                                              │
│                                                                       │
│                                           [Cancel]  [Next: Structure →] │
└───────────────────────────────────────────────────────────────────────┘
```

**Step 2: Learning Structure**

```
┌───────────────────────────────────────────────────────────────────────┐
│  💻 New DSA Goal                                     Step 2 of 3  [×] │
├───────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  LEARNING STRUCTURE                                                   │
│                                                                       │
│  Weekly Schedule                                                      │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ Problems per week: [8] problems                                 │ │
│  │ Study sessions per week: [5] sessions                           │ │
│  │ Review sessions: [2] per week (redo old problems)               │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  Problem-Solving Workflow (per problem)                               │
│  ☑ 1. Read & understand (5-10 min)                                   │
│  ☑ 2. Attempt blind (30 min timeout)                                 │
│  ☑ 3. Study solution if stuck                                        │
│  ☑ 4. Code optimal solution                                          │
│  ☑ 5. Analyze time/space complexity                                  │
│  ☑ 6. Add to review queue (1 week, 1 month)                          │
│                                                                       │
│  Pattern-Based Breakdown                                              │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ DFS (Depth-First Search)                                        │ │
│  │ • 15 Easy + 20 Medium + 5 Hard = 40 problems                    │ │
│  │ • Week 1-4                                                      │ │
│  │                                                                 │ │
│  │ BFS (Breadth-First Search)                                      │ │
│  │ • 10 Easy + 15 Medium + 5 Hard = 30 problems                    │ │
│  │ • Week 5-7                                                      │ │
│  │                                                                 │ │
│  │ Shortest Path (Dijkstra, Bellman-Ford)                         │ │
│  │ • 5 Easy + 10 Medium + 5 Hard = 20 problems                     │ │
│  │ • Week 8-10                                                     │ │
│  │                                                                 │ │
│  │ Advanced (Topo Sort, MST, Union Find)                           │ │
│  │ • 0 Easy + 5 Medium + 5 Hard = 10 problems                      │ │
│  │ • Week 11-13                                                    │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  Tracking Metrics                                                     │
│  ☑ Success rate (solved without hints)                               │
│  ☑ Average solve time                                                │
│  ☑ Patterns mastered                                                 │
│  ☑ Review success (can redo after 1 week?)                           │
│                                                                       │
│                                              [← Back]  [Next: Review →] │
└───────────────────────────────────────────────────────────────────────┘
```

**Step 3: Review & Create**

```
┌───────────────────────────────────────────────────────────────────────┐
│  💻 New DSA Goal                                     Step 3 of 3  [×] │
├───────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  REVIEW YOUR DSA PLAN                                                 │
│                                                                       │
│  🎯 Goal Summary                                                      │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ Master Graph Algorithms - 100 Problems                          │ │
│  │ Nov 1, 2024 - Jan 31, 2025 (13 weeks)                           │ │
│  │ Platform: LeetCode                                              │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  📊 Problem Breakdown                                                │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ Easy:   30 problems (30%)                                       │ │
│  │ Medium: 50 problems (50%)                                       │ │
│  │ Hard:   20 problems (20%)                                       │ │
│  │ Total:  100 problems                                            │ │
│  │ Rate:   ~8 problems/week                                        │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  🎯 Patterns to Master (6)                                           │
│  • DFS (40 problems, Weeks 1-4)                                      │
│  • BFS (30 problems, Weeks 5-7)                                      │
│  • Shortest Path (20 problems, Weeks 8-10)                           │
│  • Topological Sort, MST, Union Find (10 problems, Weeks 11-13)      │
│                                                                       │
│  📅 This will create:                                                │
│  • 1 Milestone: "Master Graph Algorithms"                            │
│  • 6 Goals: One per pattern (DFS, BFS, etc.)                         │
│  • 100 Tasks: Individual problems                                    │
│  • 600+ Subtasks: Study, Attempt, Review steps                       │
│                                                                       │
│  📈 Auto-tracked metrics:                                            │
│  • Success rate by difficulty                                        │
│  • Average solve time                                                │
│  • Patterns mastered                                                 │
│  • Review success rate                                               │
│  • Streak (consecutive days solved)                                  │
│                                                                       │
│                                     [← Back]  [Create DSA Plan! 💻]  │
└───────────────────────────────────────────────────────────────────────┘
```

### **5.2 DSA Milestone Card - EXPANDED**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  💻 Master Graph Algorithms - 100 Problems                           [58%] │
│  Nov 1, 2024 - Jan 31, 2025 • 13 weeks • LeetCode                         │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                                                             │
│  📊 OVERALL PROGRESS                                                       │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Problems Solved: 58/100 (58%)                                         │ │
│  │ ██████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░             │ │
│  │                                                                       │ │
│  │ ✓ Easy: 22/30 (73%)    ⚠️ 8 remaining                                │ │
│  │ ✓ Medium: 28/50 (56%)  ⚠️ 22 remaining                               │ │
│  │ ✓ Hard: 8/20 (40%)     ⚠️ 12 remaining                               │ │
│  │                                                                       │ │
│  │ Week 7 of 13 • 42 problems remaining • On pace! 🔥                   │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  🎯 PATTERN MASTERY                                                        │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ ✓ DFS (Depth-First Search).................. 40/40 ✅ MASTERED       │ │
│  │   └─ Success rate: 85% • Avg time: 18 min                            │ │
│  │                                                                       │ │
│  │ ▶ BFS (Breadth-First Search)................ 18/30 (60%) IN PROGRESS │ │
│  │   └─ Success rate: 78% • Avg time: 22 min                            │ │
│  │                                                                       │ │
│  │ ○ Shortest Path (Dijkstra, Bellman-Ford)... 0/20                     │ │
│  │   └─ Starts Week 8                                                   │ │
│  │                                                                       │ │
│  │ ○ Advanced (Topo Sort, MST, Union Find).... 0/10                     │ │
│  │   └─ Starts Week 11                                                  │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📈 PERFORMANCE STATS                                                      │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ This Week: 9/8 problems ✅ (ahead!)                                   │ │
│  │ Overall Success Rate: 82% (solved without editorial)                 │ │
│  │ Average Solve Time: 24 minutes                                       │ │
│  │ Current Streak: 12 days 🔥                                            │ │
│  │ Longest Streak: 18 days                                              │ │
│  │ Review Success: 91% (can redo after 1 week)                          │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📊 DIFFICULTY BREAKDOWN CHART                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │                                                                       │ │
│  │ Easy   ████████████████████░░░░  22/30 (73%)                         │ │
│  │ Medium ████████████░░░░░░░░░░░░  28/50 (56%)                         │ │
│  │ Hard   ████░░░░░░░░░░░░░░░░░░░░   8/20 (40%)                         │ │
│  │                                                                       │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  🏆 TOP ACHIEVEMENTS                                                       │
│  🥇 DFS Pattern Mastered (40/40 problems)                                 │
│  🥈 12-day problem-solving streak                                         │
│  🥉 First Hard problem solved independently!                              │
│                                                                             │
│  📅 THIS WEEK'S PROBLEMS                                                   │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ ✓ #200 - Number of Islands (BFS, Medium) - 18 min ✅                 │ │
│  │ ✓ #207 - Course Schedule (Topo, Medium) - 32 min ✅                  │ │
│  │ ✓ #133 - Clone Graph (BFS, Medium) - 25 min ✅                       │ │
│  │ ▶ #127 - Word Ladder (BFS, Hard) - In progress...                    │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📎 RESOURCES                                                              │
│  🔗 NeetCode 150 Roadmap                                                   │
│  🔗 LeetCode Graph Pattern List                                            │
│  🔗 My Solution Notes (Notion)                                             │
│  🔗 Blind 75 Checklist                                                     │
│                                                                             │
│  [Collapse ↑]  [View All Problems]  [Add Problem]  [Stats Dashboard]  [×] │
└─────────────────────────────────────────────────────────────────────────────┘
```

### **5.3 DSA Task Card (Problem) - EXPANDED**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  💻 #200 - Number of Islands                                        [100%] │
│  LeetCode • BFS/DFS • Medium • Graph Pattern                              │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                                                             │
│  🎯 PROBLEM SUMMARY                                                        │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Status: ✅ Solved independently (no editorial)                        │ │
│  │ Solve Time: 18 minutes (Target: <25 min for Medium)                  │ │
│  │ Attempts: 1 (Solved on first try!)                                   │ │
│  │ Date Solved: Nov 22, 2024, 7:30 PM                                   │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📝 PROBLEM DESCRIPTION                                                    │
│  Given an m x n 2D binary grid which represents a map of '1's (land) and   │
│  '0's (water), return the number of islands.                               │
│                                                                             │
│  An island is surrounded by water and is formed by connecting adjacent     │
│  lands horizontally or vertically.                                         │
│                                                                             │
│  🔗 https://leetcode.com/problems/number-of-islands/                       │
│                                                                             │
│  💡 MY APPROACH                                                            │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Algorithm: Depth-First Search (DFS) with grid modification           │ │
│  │                                                                       │ │
│  │ Key Insights:                                                         │ │
│  │ 1. Iterate through entire grid                                       │ │
│  │ 2. When we find a '1', increment island count                        │ │
│  │ 3. DFS from that cell to mark entire island as visited (set to '0')  │ │
│  │ 4. Continue until grid is fully traversed                            │ │
│  │                                                                       │ │
│  │ Edge Cases Considered:                                                │ │
│  │ • Empty grid → return 0                                              │ │
│  │ • Single cell → return 1 if land, 0 if water                         │ │
│  │ • All land → return 1                                                │ │
│  │ • All water → return 0                                               │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  ⚡ COMPLEXITY ANALYSIS                                                    │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Time Complexity:  O(m × n)                                            │ │
│  │ • Visit each cell once in worst case                                 │ │
│  │                                                                       │ │
│  │ Space Complexity: O(m × n)                                            │ │
│  │ • DFS recursion stack in worst case (all land)                       │ │
│  │ • Could optimize to O(min(m,n)) with BFS queue                       │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  💻 MY SOLUTION (Python)                                                   │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ def numIslands(self, grid: List[List[str]]) -> int:                  │ │
│  │     if not grid or not grid[0]:                                      │ │
│  │         return 0                                                     │ │
│  │                                                                       │ │
│  │     m, n = len(grid), len(grid[0])                                   │ │
│  │     islands = 0                                                      │ │
│  │                                                                       │ │
│  │     def dfs(i, j):                                                   │ │
│  │         if i < 0 or i >= m or j < 0 or j >= n or grid[i][j] == '0': │ │
│  │             return                                                   │ │
│  │         grid[i][j] = '0'  # Mark as visited                          │ │
│  │         dfs(i+1, j)                                                  │ │
│  │         dfs(i-1, j)                                                  │ │
│  │         dfs(i, j+1)                                                  │ │
│  │         dfs(i, j-1)                                                  │ │
│  │                                                                       │ │
│  │     for i in range(m):                                               │ │
│  │         for j in range(n):                                           │ │
│  │             if grid[i][j] == '1':                                    │ │
│  │                 islands += 1                                         │ │
│  │                 dfs(i, j)                                            │ │
│  │                                                                       │ │
│  │     return islands                                                   │ │
│  │                                                                       │ │
│  │ [View on LeetCode] [Copy Code] [Run Tests]                          │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  ✅ LEARNING OUTCOMES                                                      │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ ✓ Grid DFS traversal pattern                                         │ │
│  │ ✓ In-place modification to avoid extra space                         │ │
│  │ ✓ Recognizing "flood fill" variant                                   │ │
│  │ ✓ Handling 2D boundary conditions                                    │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  🏷️ TAGS                                                                  │
│  #graph #dfs #bfs #matrix #flood-fill #medium #blind75                    │
│                                                                             │
│  🔗 RELATED PROBLEMS                                                       │
│  Similar: #695 Max Area of Island, #130 Surrounded Regions                │
│                                                                             │
│  📅 REVIEW SCHEDULE                                                        │
│  ✓ Next Review: Nov 29 (1 week) - PASSED ✅                               │
│  ○ Final Review: Dec 22 (1 month)                                         │
│                                                                             │
│  📝 NOTES                                                                  │
│  "Classic graph problem! Recognized DFS pattern immediately. Could also     │
│   solve with BFS using a queue. Important to mark cells as visited to     │
│   avoid infinite loops. This pattern shows up everywhere!"                │
│                                                                             │
│  [Collapse ↑]  [Re-attempt]  [Mark for Review]  [Add to Favorites]  [×]  │
└─────────────────────────────────────────────────────────────────────────────┘
```
# 🎨 **COMPLETE UI DESIGN - DOMAIN-SPECIFIC MGTST SYSTEM**

I'm going ALL IN. Let me design the complete UI system with maximum depth and breadth. This will be transformative.

[2 tools called]

Perfect! Let me create the **COMPLETE UI DESIGN SYSTEM** with maximum depth. I'll document everything visually and comprehensively.

[1 tool called]

Now let me create the **COMPLETE UI DESIGN** for the enhanced domain system. I'll create multiple comprehensive documents:

[1 tool called]

Perfect! Let me give you the **COMPLETE UI DESIGN SPECIFICATION** right here. This will be exhaustive and transformative. I'll design EVERYTHING with maximum depth and breadth.

---

# 🎨 **COMPLETE UI DESIGN - DOMAIN-SPECIFIC MGTST SYSTEM**

## **TABLE OF CONTENTS**
1. [System Architecture](#1-system-architecture)
2. [Template Selection Flow](#2-template-selection-flow)
3. [Domain: School](#3-domain-school)
4. [Domain: Fitness](#4-domain-fitness)
5. [Domain: DSA/Coding](#5-domain-dsacoding)
6. [Domain: Projects](#6-domain-projects)
7. [Domain: Finance](#7-domain-finance)
8. [Component Library](#8-component-library)
9. [Interaction Patterns](#9-interaction-patterns)
10. [Animations & Transitions](#10-animations--transitions)

---

## **1. SYSTEM ARCHITECTURE**

### **1.1 Navigation Enhancement**

**Current Sidebar + New Template System Integration:**

```
┌─────────────────────────────────────────────────────────┐
│  Lifeline OS                    1,250 pts  🔥 7 days    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  📅  TODAY                                              │
│  📋  TASKS                                              │
│  🎯  GOALS                                              │
│  🏁  MILESTONES                                         │
│  📝  PLANNER                                            │
│  💭  REFLECTIONS                                        │
│                                                         │
│  ─────────────────────────────                         │
│  SYSTEM                                                 │
│  ⚙️  SETTINGS                                           │
│                                                         │
│  ─────────────────────────────                         │
│  QUICK ACTIONS                                          │
│  ✨ [New from Template...]                             │ ← NEW
│  ➕ [Quick Add Task]                                    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### **1.2 Data Structure Visualization**

```
DATABASE ENHANCEMENT:

milestones                     goals                      tasks                      subtasks
├─ id                         ├─ id                     ├─ id                      ├─ id
├─ title                      ├─ title                  ├─ title                   ├─ title
├─ description                ├─ description            ├─ description             ├─ taskId
├─ category ←─────────────────┼─ category ←──────────────┼─ category ←──────────────┤
├─ customFields (JSON) ←──────┼─ customFields (JSON) ←───┼─ customFields (JSON) ←───┤
├─ tags (JSON array) ←────────┼─ tags (JSON array) ←─────┼─ tags (JSON array) ←─────┤
├─ notes (TEXT) ←─────────────┼─ notes (TEXT) ←──────────┼─ notes (TEXT) ←──────────┤
└─ attachments (JSON) ←───────┴─ attachments (JSON) ←────┴─ attachments (JSON) ←────┘

CATEGORIES TABLE (NEW):
├─ id
├─ name ('school', 'fitness', 'dsa', 'projects', 'finance')
├─ icon
├─ color
├─ template (JSON - defines structure and fields)
└─ isActive
```

---

## **2. TEMPLATE SELECTION FLOW**

### **2.1 Entry Points**

**THREE ways to access templates:**

1. **Sidebar Button:** "✨ New from Template..."
2. **Empty State:** "+ Add from Template" button in Goals/Milestones pages
3. **Create Modal:** Radio button "Use Template" vs "Create Blank"

### **2.2 Template Selection Screen**

```
┌───────────────────────────────────────────────────────────────────────┐
│  ✨ Create from Template                                     [×]      │
├───────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Choose a category to get started with smart defaults:               │
│                                                                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │
│  │              │  │              │  │              │               │
│  │      📚      │  │      💪      │  │      💻      │               │
│  │              │  │              │  │              │               │
│  │   SCHOOL     │  │   FITNESS    │  │     DSA      │               │
│  │              │  │              │  │              │               │
│  │  Semesters,  │  │  Workouts,   │  │  Problems,   │               │
│  │   Classes,   │  │  Nutrition,  │  │  Patterns,   │               │
│  │   Modules    │  │   Progress   │  │  LeetCode    │               │
│  │              │  │              │  │              │               │
│  │  [Select →]  │  │  [Select →]  │  │  [Select →]  │               │
│  └──────────────┘  └──────────────┘  └──────────────┘               │
│                                                                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │
│  │              │  │              │  │              │               │
│  │      🚀      │  │      💰      │  │      ⚪      │               │
│  │              │  │              │  │              │               │
│  │   PROJECTS   │  │   FINANCE    │  │    BLANK     │               │
│  │              │  │              │  │              │               │
│  │   Features,  │  │  Portfolio,  │  │  Start from  │               │
│  │   Sprints,   │  │  Stocks,     │  │   scratch    │               │
│  │     PRs      │  │     ROI      │  │   (generic)  │               │
│  │              │  │              │  │              │               │
│  │  [Select →]  │  │  [Select →]  │  │  [Select →]  │               │
│  └──────────────┘  └──────────────┘  └──────────────┘               │
│                                                                       │
│  💡 Templates provide smart defaults and custom fields for           │
│     your specific use case. You can still customize everything!      │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

---

## **3. DOMAIN: SCHOOL** 📚

### **3.1 Template Wizard - School**

**Step 1: Semester Setup**

```
┌───────────────────────────────────────────────────────────────────────┐
│  📚 New School Semester                              Step 1 of 3  [×] │
├───────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  SEMESTER INFORMATION                                                 │
│                                                                       │
│  Semester Name *                                                      │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ Fall 2024                                                       │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  Duration                                                             │
│  ┌──────────────────────────┐  ┌──────────────────────────┐         │
│  │ Start: [09/01/2024____] │  │ End: [12/15/2024______] │         │
│  └──────────────────────────┘  └──────────────────────────┘         │
│                                                                       │
│  Academic Goals                                                       │
│  ┌──────────────────────────┐  ┌──────────────────────────┐         │
│  │ GPA Target: [3.8_______] │  │ Total Credits: [15_____] │         │
│  └──────────────────────────┘  └──────────────────────────┘         │
│                                                                       │
│  Structure                                                            │
│  ☑ Auto-generate 15-week schedule                                   │
│  ☑ Include midterm week (Week 8)                                    │
│  ☑ Include finals week (Week 16)                                    │
│  ☑ Add reading weeks before exams                                   │
│                                                                       │
│                                           [Cancel]  [Next: Classes →] │
└───────────────────────────────────────────────────────────────────────┘
```

**Step 2: Add Classes**

```
┌───────────────────────────────────────────────────────────────────────┐
│  📚 New School Semester                              Step 2 of 3  [×] │
├───────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ADD CLASSES (You can add more later)                                │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ Class 1                                                         │ │
│  │ ┌───────────────────────────────────────────┐ ┌──────────────┐ │ │
│  │ │ Course Code: CS 301_____________________ │ │ Credits: [3] │ │ │
│  │ └───────────────────────────────────────────┘ └──────────────┘ │ │
│  │ ┌─────────────────────────────────────────────────────────────┐ │ │
│  │ │ Course Name: Data Structures & Algorithms                  │ │ │
│  │ └─────────────────────────────────────────────────────────────┘ │ │
│  │ ┌──────────────────────┐ ┌──────────────────────────────────┐  │ │
│  │ │ Professor: Dr. Smith │ │ Grade Target: [A_____________]  │  │ │
│  │ └──────────────────────┘ └──────────────────────────────────┘  │ │
│  │ ┌─────────────────────────────────────────────────────────────┐ │ │
│  │ │ Schedule: MW 2:00-3:30 PM, Lab F 10:00-12:00______________ │ │ │
│  │ └─────────────────────────────────────────────────────────────┘ │ │
│  │ ☑ Auto-create 12 weekly modules                              │ │
│  │ ☐ Has lab component                                          │ │
│  │ ☑ Midterm exam                                               │ │
│  │ ☑ Final exam                                                 │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  [+ Add Another Class]                                                │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ Class 2                                                         │ │
│  │ ┌───────────────────────────────────────────┐ ┌──────────────┐ │ │
│  │ │ Course Code: MATH 205___________________ │ │ Credits: [4] │ │ │
│  │ └───────────────────────────────────────────┘ └──────────────┘ │ │
│  │ ...                                                             │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│                                              [← Back]  [Next: Review →] │
└───────────────────────────────────────────────────────────────────────┘
```

**Step 3: Review & Create**

```
┌───────────────────────────────────────────────────────────────────────┐
│  📚 New School Semester                              Step 3 of 3  [×] │
├───────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  REVIEW YOUR SEMESTER STRUCTURE                                       │
│                                                                       │
│  📊 Summary                                                           │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ Fall 2024 Semester                                              │ │
│  │ Sep 1, 2024 - Dec 15, 2024 (15 weeks)                          │ │
│  │ GPA Target: 3.8 | Total Credits: 15                            │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  📚 Classes (3)                                                       │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │ 1. CS 301 - Data Structures (3 credits, Dr. Smith, Target: A)  │ │
│  │    → 12 modules + midterm + final                               │ │
│  │                                                                 │ │
│  │ 2. MATH 205 - Calculus III (4 credits, Dr. Johnson, Target: A) │ │
│  │    → 12 modules + midterm + final                               │ │
│  │                                                                 │ │
│  │ 3. ENG 102 - Composition II (3 credits, Prof. Lee, Target: B)  │ │
│  │    → 10 essays + final                                          │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  🎯 This will create:                                                │
│  • 1 Milestone: "Fall 2024 Semester"                                │
│  • 3 Goals: One for each class                                      │
│  • 36+ Tasks: Modules, exams, assignments                           │
│  • 100+ Subtasks: Lectures, quizzes, homework                       │
│                                                                       │
│  💡 You can edit any of these after creation!                        │
│                                                                       │
│                                     [← Back]  [Create Semester! ✨]  │
└───────────────────────────────────────────────────────────────────────┘
```

### **3.2 School Milestone Card - Collapsed**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ 📚 Fall 2024 Semester                                         [67%] │   │
│  │ Sep 1 - Dec 15, 2024 • 3 classes • GPA Target: 3.8                 │   │
│  │ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │   │
│  │                                                                     │   │
│  │ 📊 2/3 classes completed • 450 points earned                       │   │
│  │                                                                     │   │
│  │ 🎯 Current GPA: 3.9 (on track!)                                    │   │
│  │                                                                     │   │
│  │ [Expand Details ↓]                                                 │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

### **3.3 School Milestone Card - EXPANDED**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  📚 Fall 2024 Semester                                               [67%] │
│  Sep 1 - Dec 15, 2024 • 3 classes • 15 credits • GPA Target: 3.8          │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                                                             │
│  📊 SEMESTER PROGRESS                                                      │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Overall: 67% complete                                                 │ │
│  │ ██████████████████████████████░░░░░░░░░░░░░░░░                       │ │
│  │                                                                       │ │
│  │ Classes Completed: 2/3                                                │ │
│  │ Modules Completed: 24/36                                              │ │
│  │ Total Points Earned: 450                                              │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  🎯 GPA TRACKER                                                            │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Current GPA: 3.9 (Target: 3.8) ✅ ON TRACK                           │ │
│  │                                                                       │ │
│  │ CS 301................ A  (95%)  [✓ Complete]                        │ │
│  │ MATH 205.............. A- (92%)  [✓ Complete]                        │ │
│  │ ENG 102............... B+ (87%)  [▶ In Progress - 8/10 essays done] │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📅 UPCOMING DEADLINES                                                     │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ ⚠️  Essay #9 - Due in 3 days (Oct 12)                                │ │
│  │ 📝 Final Essay - Due in 10 days (Oct 19)                             │ │
│  │ 🎓 Semester ends in 45 days (Dec 15)                                 │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📚 CLASSES                                                                │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ ✓ CS 301 - Data Structures & Algorithms                              │ │
│  │   Dr. Smith • 3 credits • MW 2:00-3:30 PM                            │ │
│  │   Grade: A (95%) • 12/12 modules • 150 pts                           │ │
│  │   [View Modules →]                                                    │ │
│  │                                                                       │ │
│  │ ✓ MATH 205 - Calculus III                                            │ │
│  │   Dr. Johnson • 4 credits • TuTh 10:00-11:30 AM                      │ │
│  │   Grade: A- (92%) • 12/12 modules • 150 pts                          │ │
│  │   [View Modules →]                                                    │ │
│  │                                                                       │ │
│  │ ▶ ENG 102 - Composition II (IN PROGRESS)                             │ │
│  │   Prof. Lee • 3 credits • MWF 9:00-9:50 AM                           │ │
│  │   Grade: B+ (87%) • 8/10 essays • 150 pts                            │ │
│  │   Next: Essay #9 due Oct 12 (3 days!)                                │ │
│  │   [View Essays →]                                                     │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📎 ATTACHMENTS                                                            │
│  🔗 Academic Calendar PDF                                                  │
│  🔗 Registration Confirmation                                              │
│  🔗 Syllabus Folder (Google Drive)                                         │
│                                                                             │
│  📝 NOTES                                                                  │
│  Last updated: Oct 9, 2024                                                 │
│  "Doing really well this semester! Need to focus on final essay quality..." │
│                                                                             │
│  [Collapse ↑]  [Edit Semester]  [Add Class]  [Export Report]  [×]        │
└─────────────────────────────────────────────────────────────────────────────┘
```

### **3.4 School Goal Card (Class) - EXPANDED**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  📘 CS 301 - Data Structures & Algorithms                            [100%] │
│  Fall 2024 • 3 credits • Dr. Smith • Target Grade: A                       │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                                                             │
│  🎯 GRADE BREAKDOWN                                                        │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Current Grade: A (95%)                                ✅ TARGET MET   │ │
│  │ ██████████████████████████████████████████████████                   │ │
│  │                                                                       │ │
│  │ Modules & Quizzes (40%)..... 94%  (11/12 complete)                   │ │
│  │ Midterm Exam (25%)........... 96%  ✓                                 │ │
│  │ Final Exam (25%)............. 98%  ✓                                 │ │
│  │ Lab Assignments (10%)........ 90%  (10/12 complete)                  │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📅 SCHEDULE                                                               │
│  Monday/Wednesday: 2:00 - 3:30 PM (Lecture, Room 204)                     │
│  Friday: 10:00 AM - 12:00 PM (Lab, Room CS-101)                           │
│                                                                             │
│  📊 COURSE STRUCTURE (12/12 modules complete)                             │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ ✓ Module 1: Arrays & LinkedLists (Week 1) ............ 95% • 12 pts  │ │
│  │ ✓ Module 2: Stacks & Queues (Week 2) ................. 92% • 12 pts  │ │
│  │ ✓ Module 3: Trees & BST (Week 3) ..................... 98% • 12 pts  │ │
│  │ ✓ Module 4: Heaps & Priority Queues (Week 4) ......... 90% • 12 pts  │ │
│  │ ✓ Module 5: Hash Tables (Week 5) ..................... 96% • 12 pts  │ │
│  │ ✓ Module 6: Graphs - Representation (Week 6) ......... 94% • 12 pts  │ │
│  │ ✓ Module 7: Graph Traversal - DFS/BFS (Week 7) ....... 97% • 12 pts  │ │
│  │ ✓ Module 8: MIDTERM REVIEW & EXAM (Week 8) ........... 96% • 25 pts  │ │
│  │ ✓ Module 9: Shortest Paths - Dijkstra (Week 9) ....... 93% • 12 pts  │ │
│  │ ✓ Module 10: MST - Kruskal & Prim (Week 10) .......... 95% • 12 pts  │ │
│  │ ✓ Module 11: Dynamic Programming (Week 11) ........... 98% • 12 pts  │ │
│  │ ✓ Module 12: FINAL REVIEW & EXAM (Week 12) ........... 98% • 25 pts  │ │
│  │                                                                       │ │
│  │ Total Points: 150                                                     │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📎 COURSE RESOURCES                                                       │
│  🔗 Syllabus (PDF)                                                         │
│  🔗 Lecture Slides (Google Drive)                                          │
│  🔗 Lab Manual (PDF)                                                       │
│  🔗 Office Hours: Tu/Th 3-5 PM, Room 310                                  │
│                                                                             │
│  📝 PROFESSOR NOTES                                                        │
│  Dr. Smith - Email: smith@university.edu                                   │
│  "Excellent professor! Very clear explanations. Office hours super helpful."│
│                                                                             │
│  [Collapse ↑]  [View All Tasks]  [Edit Class]  [Add Module]  [×]         │
└─────────────────────────────────────────────────────────────────────────────┘
```

### **3.5 School Task Card (Module) - EXPANDED**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  📘 Module 3: Trees & Binary Search Trees                            [100%] │
│  Week 3 • CS 301 - Data Structures                                         │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                                                             │
│  📊 MODULE PROGRESS                                                        │
│  Grade: 98% (A+) ✅ • 12 points earned                                    │
│  ██████████████████████████████████████████████████████                   │
│                                                                             │
│  📅 TIMELINE                                                               │
│  Week 3: Sep 15-21, 2024                                                   │
│  Status: ✓ Complete                                                        │
│                                                                             │
│  📚 MODULE COMPONENTS                                                      │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ ✓ Pre-Test: Tree Basics .................. 90% • Sep 15 • 1 pt       │ │
│  │ ✓ Lecture 1: Tree Terminology ............ ✓ • Sep 16 • watched      │ │
│  │ ✓ Lecture 2: Binary Trees ................ ✓ • Sep 16 • watched      │ │
│  │ ✓ Lecture 3: BST Properties .............. ✓ • Sep 18 • watched      │ │
│  │ ✓ Practice Problems: BST Insert/Search ... 100% • Sep 19 • 2 pts     │ │
│  │ ✓ Lab 3: Implement BST class ............. 95% • Sep 20 • 3 pts      │ │
│  │ ✓ Quiz 3: Trees & BST .................... 98% • Sep 21 • 5 pts      │ │
│  │ ✓ Homework 3: Tree Traversals ............ 100% • Sep 21 • 1 pt      │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  📎 RESOURCES                                                              │
│  🔗 Lecture Slides (Week 3)                                                │
│  🔗 Lab Code Template                                                      │
│  🔗 Visualgo - BST Visualization                                           │
│  🔗 My Notes (Notion)                                                      │
│                                                                             │
│  📝 NOTES                                                                  │
│  "This week was great! BST insert/delete finally clicked. Lab was fun."    │
│  "Remember: in-order traversal of BST gives sorted order!"                 │
│                                                                             │
│  [Collapse ↑]  [View Subtasks]  [Edit Module]  [Add Note]  [×]           │
└─────────────────────────────────────────────────────────────────────────────┘
```

---