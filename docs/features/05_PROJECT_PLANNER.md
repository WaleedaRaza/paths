# Feature: Project Planner (Spec Doc Generator → Feature Cards → Tasks)

## Purpose & User Outcome

**Goal:** Turn messy project ideas into structured plans with AI. Generate planning docs, toggle sections, export to Markdown, and convert feature cards into atomic tasks.

**Success Criteria:**
- ✅ Paste core idea → AI generates complete planning doc
- ✅ Toggle sections/fields on/off (customizable output)
- ✅ Export Markdown + JSON for external use
- ✅ Generate ≤90min Feature Cards
- ✅ Convert cards to Tasks linked to Goals/Milestones

---

## User Stories

1. **Idea to Plan:** I paste "Build a better Last.fm using AI/ML for music discovery", click Generate, AI creates structured plan with Project Info, Research, Tech Stack, Features.
2. **Customize Sections:** I don't need "Marketing Plan", I toggle it off, export only includes relevant sections.
3. **Field Editing:** I click "Expand" on "Tech Stack", AI adds more detail about Tauri vs Electron trade-offs.
4. **Export Spec:** I click "Export", app writes `/docs/plans/2025-10-06-lastfm-ai.md` and `.json` files.
5. **Feature Cards → Tasks:** I click "Generate Feature Cards", AI creates 6 cards (each ≤90min), I convert them to Tasks under "Ship Last.fm" milestone.

---

## Page Layout

### Entry Screen

```
┌─────────────────────────────────────────────────────────────┐
│ Project Planner                          [Load] [Templates] │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ Project Name: [Last.fm 2025 AI/ML_____________________]    │
│                                                             │
│ Core Idea (describe your project):                         │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │                                                         │ │
│ │ "Build a better Last.fm using AI and ML. Music heads   │ │
│ │ want analytics and to prove they're fans, deeper than  │ │
│ │ AirPods which creeps people out. Opportunities to      │ │
│ │ leverage AI and ML for music discovery, privacy-first  │ │
│ │ data collection, and social proof features."           │ │
│ │                                                         │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ [🤖 Generate Initial Plan] [Load from Template]            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Generated Plan View

```
┌─────────────────────────────────────────────────────────────┐
│ Last.fm 2025 AI/ML                    [Export] [Edit] [New] │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ LEFT PANEL (60%)                     RIGHT PANEL (40%)      │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━  │
│                                                             │
│ ▼ 📋 Project Info [✓] [Edit]        LIVE PREVIEW          │
│   ├─ Name [✓]                        ┌──────────────────┐  │
│   │   Last.fm 2025 AI/ML              │ # Last.fm 2025   │  │
│   │   [Expand][Replace][Refine]       │                  │  │
│   ├─ One-Liner [✓]                    │ ## Project Info  │  │
│   │   Privacy-first music analytics   │ Name: Last.fm... │  │
│   │   [Expand][Replace][Refine]       │                  │  │
│   ├─ Target Users [✓]                 │ ## Research      │  │
│   │   Music enthusiasts, audiophiles  │ ...              │  │
│   │   [Expand][Replace][Refine]       └──────────────────┘  │
│   └─ MVP Features [✓]                                       │
│       • Listening analytics                                 │
│       • AI recommendations                                  │
│       • Social proof                                        │
│       [Expand][Add][Remove]                                 │
│                                                             │
│ ▼ 🔬 Research & Sandboxing [✓]                             │
│   ├─ Music APIs [✓]                                        │
│   │   Spotify, Last.fm, Apple Music APIs                   │
│   │   [Expand][Replace][Refine][Query]                     │
│   ├─ AI/ML Libraries [✓]                                   │
│   │   TensorFlow, PyTorch, scikit-learn                    │
│   │   [Expand][Replace][Refine][Query]                     │
│   └─ Competitor Analysis [✗] (excluded)                    │
│                                                             │
│ ▼ 🏗️ Technical Architecture [✓]                            │
│   ├─ Frontend [✓]                                          │
│   │   Tauri + React + TypeScript                           │
│   │   [Expand][Replace][Refine][Query]                     │
│   ├─ Backend [✓]                                           │
│   │   Node.js + Python (ML services)                       │
│   │   [Expand][Replace][Refine][Query]                     │
│   └─ Database [✓]                                          │
│       PostgreSQL + Redis cache                             │
│       [Expand][Replace][Refine][Query]                     │
│                                                             │
│ ▼ 📱 Feature Breakdown [✓]                                 │
│   ├─ Music Listening Analytics [✓]                         │
│   ├─ AI-Powered Recommendations [✓]                        │
│   ├─ Social Proof & Sharing [✓]                            │
│   └─ Privacy-First Data Collection [✓]                     │
│                                                             │
│ ▼ 🗂️ Division of Labor [✗] (excluded)                      │
│                                                             │
│ [+ Add Custom Section]                                      │
│ [🎯 Generate Feature Cards] [📄 Export Markdown+JSON]      │
└─────────────────────────────────────────────────────────────┘
```

---

## Field Editor Modal

**Trigger:** Click any field action button (Expand/Replace/Refine/Query)

```
┌─────────────────────────────────────────────────────────────┐
│ Edit Field: Music APIs                              [✕ Close]│
├─────────────────────────────────────────────────────────────┤
│ Current Content:                                            │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ Spotify, Last.fm, Apple Music APIs                      │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ Action: [Expand] [Replace] [Refine] [Query]  Selected: Expand│
│                                                             │
│ Prompt (optional for Expand/Refine/Query):                 │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ "Add details about API rate limits and cost"           │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ [🤖 Generate] [Cancel]                                      │
│                                                             │
│ ─────────────────────────────────────────────────────────── │
│ AI Output Preview:                                          │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ Spotify, Last.fm, Apple Music APIs                      │ │
│ │                                                         │ │
│ │ **Spotify Web API**                                     │ │
│ │ • Rate Limit: 30 req/sec                                │ │
│ │ • Cost: Free tier + commercial licensing                │ │
│ │ • Data: Listening history, recommendations              │ │
│ │                                                         │ │
│ │ **Last.fm API**                                         │ │
│ │ • Rate Limit: 5 req/sec                                 │ │
│ │ • Cost: Free (attribution required)                     │ │
│ │ • Data: Scrobbles, charts, artist info                  │ │
│ │                                                         │ │
│ │ **Apple Music API**                                     │ │
│ │ • Rate Limit: 20 req/sec                                │ │
│ │ • Cost: $99/year dev account                            │ │
│ │ • Data: Catalog access, user playlists                  │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ [Accept] [Regenerate] [Cancel]                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Feature Cards Generation

**Trigger:** Click "🎯 Generate Feature Cards"

```
┌─────────────────────────────────────────────────────────────┐
│ Generated Feature Cards                             [✕ Close]│
├─────────────────────────────────────────────────────────────┤
│ Based on your plan, here are 6 feature cards (≤90min each): │
│                                                             │
│ ┌─ Card 1: Music API Integration ─────────────────────────┐ │
│ │ Title: Integrate Spotify & Last.fm APIs                 │ │
│ │ Estimate: 90 minutes                                    │ │
│ │ Files: 7 (api/spotify.ts, api/lastfm.ts, ...)          │ │
│ │ ─────────────────────────────────────────────────────── │ │
│ │ Tasks:                                                  │ │
│ │ • Research API docs (15min)                             │ │
│ │ • Set up OAuth flow (20min)                             │ │
│ │ • Implement data fetching (30min)                       │ │
│ │ • Test with mock data (15min)                           │ │
│ │ • Write integration tests (10min)                       │ │
│ │ ─────────────────────────────────────────────────────── │ │
│ │ Acceptance:                                             │ │
│ │ • Can authenticate with Spotify                         │ │
│ │ • Can fetch user's top tracks                           │ │
│ │ • Tests pass                                            │ │
│ │ [Edit] [Remove]                                         │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ ┌─ Card 2: Analytics Dashboard UI ────────────────────────┐ │
│ │ Title: Build listening analytics dashboard              │ │
│ │ Estimate: 75 minutes                                    │ │
│ │ ...                                                     │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ [4 more cards...]                                           │
│                                                             │
│ ─────────────────────────────────────────────────────────── │
│ Convert to Tasks:                                           │
│ Link to Goal: [Ship Last.fm v2 ▼]                          │
│ [✓] Create tasks with origin link (for traceability)       │
│ [✓] Use AI estimates as task durations                     │
│                                                             │
│ [Convert All to Tasks] [Export Cards] [Cancel]             │
└─────────────────────────────────────────────────────────────┘
```

---

## Planning Doc Sections

### 1. Project Info
- **Name:** Project title
- **One-Liner:** Elevator pitch (<15 words)
- **Target Users:** Who is this for? (3-5 bullet points)
- **MVP Features:** Core features (5-7 max)
- **Non-Goals:** What we're explicitly NOT building
- **Platforms:** Desktop/Mobile/Web
- **Timeline:** Expected duration

### 2. Research & Sandboxing
- **Key Questions:** What do we need to figure out?
- **Constraints:** Technical, legal, resource limitations
- **Approaches:** 3-5 ranked approaches to solve the problem
- **Spikes:** Research tasks with success signals
- **Decision Deadline:** When do we commit?

### 3. Technical Architecture
- **Frontend:** Framework, language, tools
- **Backend:** Services, APIs, databases
- **Data & Auth:** How data flows, authentication
- **Deployment:** Hosting, CI/CD
- **Security:** Key security considerations

### 4. Feature Breakdown
- **Feature 1:** Description + subtasks
- **Feature 2:** Description + subtasks
- ...

### 5. Division of Labor (Optional)
- **UI/UX:** Screens, components, design system
- **Domain Logic:** Business rules, algorithms
- **Data & Contracts:** Models, schemas, migrations
- **Integration:** APIs, third-party services
- **Testing:** Unit, integration, E2E

---

## State Management

```typescript
// state/slices/plannerSlice.ts

interface PlannerSlice {
  // Documents
  docs: Map<string, PlannerDoc>;
  activeDocId?: string;
  
  // CRUD
  createDoc: (coreIdea: string) => Promise<string>;
  updateDoc: (id: string, updates: Partial<PlannerDoc>) => Promise<void>;
  deleteDoc: (id: string) => Promise<void>;
  
  // Generation
  generateFromCoreIdea: (text: string) => Promise<PlannerDoc>;
  generateCategory: (docId: string, category: PlannerCategory) => Promise<void>;
  
  // Field Editing
  editField: (
    docId: string,
    path: string,
    operation: 'expand' | 'replace' | 'refine' | 'query',
    prompt?: string
  ) => Promise<void>;
  
  // Toggle
  toggleSection: (docId: string, section: string, include: boolean) => void;
  toggleField: (docId: string, path: string, include: boolean) => void;
  
  // Export
  exportMarkdown: (docId: string) => Promise<string>;
  exportJSON: (docId: string) => Promise<string>;
  
  // Feature Cards
  generateFeatureCards: (docId: string) => Promise<FeatureCard[]>;
  convertCardsToTasks: (cards: FeatureCard[], goalId: string) => Promise<string[]>;
  
  // Modal
  activeFieldPath?: string;
  openFieldEditor: (path: string) => void;
  closeFieldEditor: () => void;
}

interface PlannerDoc {
  id: string;
  name: string;
  coreIdea: string;
  sections: Map<string, Section>;
  includedSections: Set<string>;
  createdAt: string;
  updatedAt: string;
}

interface Section {
  id: string;
  title: string;
  fields: Map<string, Field>;
  order: number;
}

interface Field {
  id: string;
  title: string;
  content: string;
  included: boolean;
  type: 'text' | 'list' | 'table';
}

interface FeatureCard {
  id: string;
  plannerDocId: string;
  title: string;
  estimate: number; // minutes
  files: string[]; // ≤7
  tasks: Array<{ title: string; estimate: number; }>;
  acceptance: string[];
  risks: string[];
}

type PlannerCategory = 
  | 'project_info'
  | 'research_sandboxing'
  | 'technical_architecture'
  | 'feature_breakdown'
  | 'division_of_labor';
```

---

## AI Prompts

### System Prompt (Global Planning)
```
You are a Planning Agent for software projects. Produce structured plans and Feature Spec Cards, NOT code.

Rules:
- Each Feature Card must be ≤90 minutes
- Each card touches ≤7 files, creates ≤3 new files
- Each card has: Title, Estimate, File list, Tasks, Acceptance checks, Risks
- Ask for missing information before generating
- Keep plans concise and actionable

Output format: Structured JSON with sections/fields.
```

### Category Prompts

**Project Info:**
```
Fill ONLY the Project Info section:
- Name (1-5 words)
- One-Liner (<15 words)
- Target Users (3-5 bullets, who is this for?)
- MVP Features (5-7 core features, no nice-to-haves)
- Non-Goals (what we're NOT building)
- Platforms (Desktop/Mobile/Web)
- Timeline (expected duration)

If input is missing critical info, list OPEN_QUESTIONS.
Do not invent features not mentioned in the core idea.
```

**Research & Sandboxing:**
```
Fill ONLY the Research & Sandboxing section:
- Key Questions (3-5 things we need to figure out)
- Constraints (technical, legal, resource)
- Approaches (3-5 ranked ways to solve the problem)
- Spikes (research tasks with success signals, ranked by priority)
- Decision Deadline (when do we commit?)

Focus on technical unknowns and risks.
```

**Field Editor (Expand):**
```
Expand the given field with more detail. Keep the same style and tone.
Add concrete examples, data, or constraints.
Do NOT change the core meaning.
```

**Field Editor (Replace):**
```
Replace the field entirely with new content based on the prompt.
Maintain the same structure (bullet points, table, paragraph).
```

**Field Editor (Refine):**
```
Tighten the field: remove fluff, fix grammar, improve clarity.
Preserve all meaning and details.
```

**Field Editor (Query):**
```
Apply the user's specific instruction to the field.
Instruction: {prompt}
```

---

## Database Schema

```sql
CREATE TABLE planner_docs (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  core_idea TEXT NOT NULL,
  markdown_content TEXT,
  json_capsule TEXT NOT NULL,  -- Full structured data
  sections_included TEXT NOT NULL,  -- JSON array of included section IDs
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  deleted_at TEXT
);

CREATE TABLE feature_cards (
  id TEXT PRIMARY KEY,
  planner_doc_id TEXT NOT NULL,
  title TEXT NOT NULL,
  estimate_minutes INTEGER NOT NULL,
  files TEXT NOT NULL,  -- JSON array
  tasks TEXT NOT NULL,  -- JSON array of {title, estimate}
  acceptance TEXT NOT NULL,  -- JSON array
  risks TEXT NOT NULL,  -- JSON array
  created_at TEXT NOT NULL,
  FOREIGN KEY (planner_doc_id) REFERENCES planner_docs(id)
);

-- Tasks can reference feature cards via origin field
ALTER TABLE tasks ADD COLUMN origin_planner_doc_id TEXT;
ALTER TABLE tasks ADD COLUMN origin_card_id TEXT;
```

---

## Export Format

### Markdown Export
```markdown
# Last.fm 2025 AI/ML

Generated: 2025-10-06 14:32:15

## Project Info

**Name:** Last.fm 2025 AI/ML

**One-Liner:** Privacy-first music analytics with AI-powered discovery

**Target Users:**
- Music enthusiasts who want deeper analytics
- Audiophiles who track listening habits
- Privacy-conscious users avoiding big tech tracking

**MVP Features:**
- Music listening analytics dashboard
- AI-powered recommendations
- Social proof & sharing features
- Privacy-first data collection

**Non-Goals:**
- Social network features (no feeds)
- Music streaming (use existing services)
- Mobile apps (desktop-first)

**Platforms:** Desktop (Tauri)

**Timeline:** 6 months

## Research & Sandboxing

**Key Questions:**
- Which music API provides best data access?
- How to train ML models without violating privacy?
- What's the legal landscape for music data?

...

## Technical Architecture

**Frontend:** Tauri + React + TypeScript

**Backend:** Node.js + Python (ML services)

**Database:** PostgreSQL + Redis cache

...
```

### JSON Export
```json
{
  "id": "doc-12345",
  "name": "Last.fm 2025 AI/ML",
  "coreIdea": "Build a better Last.fm...",
  "sections": {
    "project_info": {
      "name": "Last.fm 2025 AI/ML",
      "oneLiner": "Privacy-first music analytics...",
      "targetUsers": [...],
      "mvpFeatures": [...],
      ...
    },
    "research_sandboxing": {...},
    "technical_architecture": {...},
    "feature_breakdown": {...}
  },
  "includedSections": ["project_info", "research_sandboxing", "technical_architecture"],
  "createdAt": "2025-10-06T14:32:15Z",
  "updatedAt": "2025-10-06T14:45:22Z"
}
```

---

## Acceptance Tests

### Happy Path
1. ✅ Paste core idea → AI generates complete plan with all sections
2. ✅ Click "Expand" on field → AI adds detail → accept → field updates
3. ✅ Toggle section off → section excluded from export
4. ✅ Export Markdown → file created in `/docs/plans/`
5. ✅ Generate Feature Cards → 6 cards appear → convert to tasks → tasks created under goal

### Edge Cases
1. ✅ Vague core idea → AI asks clarifying questions
2. ✅ Field edit fails → show error → allow retry
3. ✅ Export with no included sections → error: "Must include at least one section"
4. ✅ Generate cards from empty plan → error: "Add features first"
5. ✅ Convert cards with no goal selected → error: "Select a goal"

---

## File Targets

- `src/features/planner/ui/PlannerPage.tsx`
- `src/features/planner/ui/SectionEditor.tsx`
- `src/features/planner/ui/FieldEditorModal.tsx`
- `src/features/planner/ui/FeatureCardsModal.tsx`
- `src/features/planner/logic/generate.ts`
- `src/features/planner/logic/export.ts`
- `src/features/planner/logic/cardsToTasks.ts`
- `src/state/slices/plannerSlice.ts`
- `src/ai/prompts/planner-global.md`
- `src/ai/prompts/planner-category-*.md`
- `src/ai/prompts/field-editor.md`
- `src/infra/db/migrations/0006_planner.sql`

