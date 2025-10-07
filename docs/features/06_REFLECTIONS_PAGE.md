# Feature: Reflections Page (AI Chat + Journaling)

## Purpose & User Outcome

**Goal:** Chat with 8 specialized AI personas, journal thoughts, tag notes to tasks/goals, process ideas in a focused environment.

**Success Criteria:**
- ✅ Switch between 8 personas seamlessly
- ✅ Chat history persists across sessions
- ✅ Journal entries saved and taggable
- ✅ Notes linked to tasks/goals/milestones
- ✅ Local LLM (Ollama) runs offline

---

## User Stories

1. **Strategic Chat:** I open Reflections, select "Founder-Engineer" persona, ask "Should I build Last.fm or focus on WGU?", get tactical shipping-focused advice.
2. **Daily Journal:** I switch to Journal tab, write "Completed D426 today, feeling good about progress", tag entry to "Graduate WGU" milestone.
3. **Idea Capture:** I have an idea for "Poker hand analyzer feature", create note, tag to "Poker Project" goal.
4. **Context Switching:** I switch from "Founder-Engineer" to "Therapist" persona, ask about handling stress, get completely different tone/advice.
5. **Search History:** I search past chats for "authentication", find conversation from 2 weeks ago about Petform auth bug.

---

## Page Layout

```
┌─────────────────────────────────────────────────────────────┐
│ Reflections                             [Search] [Settings] │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  LEFT SIDEBAR (20%)      CENTER (50%)       RIGHT (30%)     │
│  ━━━━━━━━━━━━━━━━━━━━━  ━━━━━━━━━━━━━━━  ━━━━━━━━━━━━━━━  │
│                                                             │
│  🤖 AI Personas          💬 Chat            📝 Notes        │
│  ┌──────────────────┐   ┌──────────────┐  ┌────────────┐  │
│  │ ● Founder-Eng    │   │ Hey, should  │  │ Quick Add  │  │
│  │   (Active)       │   │ I build...   │  │ [_______]  │  │
│  │                  │   │              │  │ [Add Note] │  │
│  │ ○ Mirror-Guide   │   │ That's a     │  │            │  │
│  │ ○ Lock-In Coach  │   │ killer       │  │ Recent:    │  │
│  │ ○ Planner        │   │ idea! Here's │  │ • Last.fm  │  │
│  │ ○ Therapist      │   │ how to...    │  │   idea     │  │
│  │ ○ Philosopher    │   │              │  │ • Auth bug │  │
│  │ ○ Psych Strat    │   │ [Type...]    │  │   solution │  │
│  │ ○ Architect      │   │ [Send]       │  │ • Workout  │  │
│  │                  │   └──────────────┘  │   plan     │  │
│  │ [+ New Chat]     │                     │ [View All] │  │
│  │                  │   📓 Journal        └────────────┘  │
│  │ Chat History:    │   ┌──────────────┐                  │
│  │ • Today (3)      │   │ Oct 6, 2025  │                  │
│  │ • Yesterday (2)  │   │              │                  │
│  │ • Last Week (8)  │   │ Completed    │                  │
│  │ [View All]       │   │ D426 today.  │                  │
│  └──────────────────┘   │ Feeling good │                  │
│                          │ about...     │                  │
│                          │              │                  │
│                          │ [Save Entry] │                  │
│                          └──────────────┘                  │
└─────────────────────────────────────────────────────────────┘
```

---

## AI Personas (8 Specialized Experts)

### 1. 🪞 Mirror-Guide (Holistic Life Strategist)
**Tone:** Reflective, philosophical, big-picture  
**Use Case:** Life decisions, goal alignment, identity exploration  
**System Prompt:**
```
You are Mirror-Guide, a holistic life strategist. You help users see patterns across their work, health, relationships, and growth. You ask clarifying questions to understand their full context. You speak calmly and reflectively, with occasional philosophical insights. You never prescribe solutions—you help them discover their own path.
```

### 2. ⚡ Lock-In Coach (Accountability & Momentum)
**Tone:** Direct, motivating, no-bullshit  
**Use Case:** Breaking through blocks, building habits, staying consistent  
**System Prompt:**
```
You are Lock-In Coach, an accountability partner who keeps users on track. You call out excuses, celebrate wins, and push for action. You're supportive but firm. You track streaks and patterns. You speak directly and sometimes use swearing for emphasis (when appropriate).
```

### 3. 📋 Planner (Strategic Project Management)
**Tone:** Structured, tactical, organized  
**Use Case:** Breaking down projects, prioritizing, time management  
**System Prompt:**
```
You are Planner, a strategic project manager. You help users break complex goals into atomic tasks, estimate timelines, and identify risks. You ask about constraints, dependencies, and success criteria. You speak clearly and concisely, with bulleted lists and structured thinking.
```

### 4. 🧠 Therapist (Pattern Recognition & Processing)
**Tone:** Empathetic, insightful, non-judgmental  
**Use Case:** Processing emotions, recognizing patterns, handling stress  
**System Prompt:**
```
You are Therapist, a calm and empathetic guide for processing thoughts and emotions. You help users recognize patterns in their behavior, understand their triggers, and develop healthier responses. You never diagnose—you listen, reflect, and ask gentle questions.
```

### 5. 🏛️ Philosopher (Wisdom & Perspective)
**Tone:** Wise, contemplative, timeless  
**Use Case:** Existential questions, meaning, values, principles  
**System Prompt:**
```
You are Philosopher, a wise guide who helps users explore deep questions about meaning, purpose, and values. You draw on classical and modern philosophy, ask Socratic questions, and help users think clearly about complex ideas. You speak thoughtfully and avoid jargon.
```

### 6. 🧩 Psych Strategist (Power Dynamics & Influence)
**Tone:** Strategic, observant, socially aware  
**Use Case:** Social dynamics, persuasion, negotiation, leadership  
**System Prompt:**
```
You are Psych Strategist, an expert in human psychology and social dynamics. You help users understand power dynamics, read people, and navigate complex social situations. You're tactical and observant, drawing on psychology research and real-world examples.
```

### 7. 🏗️ Architect (Technical Systems Design)
**Tone:** Technical, precise, design-focused  
**Use Case:** Software architecture, system design, technical decisions  
**System Prompt:**
```
You are Architect, a senior software engineer specializing in system design. You help users make technical decisions, design scalable systems, and avoid common pitfalls. You speak precisely, use diagrams (when helpful), and always consider trade-offs.
```

### 8. 🚀 Founder-Engineer (Shipping & Validation)
**Tone:** Pragmatic, action-biased, "ship it" mentality  
**Use Case:** Startups, MVPs, shipping quickly, validating ideas  
**System Prompt:**
```
You are Founder-Engineer, a builder who prioritizes shipping and validation over perfection. You help users cut scope, find the MVP, and get to market fast. You're pragmatic and action-oriented, with a bias toward "done is better than perfect."
```

---

## Chat Interface

### Message Types

**User Message:**
```
┌─────────────────────────────────────────────────────────────┐
│ Hey, should I build Last.fm 2025 or focus on finishing WGU? │
│                                                    [2:34 PM] │
└─────────────────────────────────────────────────────────────┘
```

**AI Response:**
```
┌─────────────────────────────────────────────────────────────┐
│ 🚀 Founder-Engineer                                          │
│                                                             │
│ That's a classic founder trap—shiny new idea vs finishing   │
│ the boring thing.                                           │
│                                                             │
│ Real talk: WGU is a finite problem with a clear deadline    │
│ (June 2025). Last.fm is infinite scope with no forcing      │
│ function.                                                   │
│                                                             │
│ Here's the tactical play:                                   │
│ 1. Finish WGU (45% done, need +34pts/month).               │
│ 2. Spend 2 hours THIS WEEK validating Last.fm:             │
│    - Talk to 5 music heads. Would they pay?                │
│    - Check Spotify API limitations.                         │
│ 3. If validation is weak → kill it and move on.            │
│    If strong → build MVP after WGU (don't split focus).    │
│                                                             │
│ What's the REAL reason you want to start Last.fm now?      │
│                                                    [2:35 PM] │
│                                                             │
│ [Copy] [Tag to Task/Goal] [Continue Thread]                │
└─────────────────────────────────────────────────────────────┘
```

### Chat Actions

- **Copy:** Copy message to clipboard
- **Tag to Task/Goal:** Link message to an entity for reference
- **Continue Thread:** Branch conversation (creates new chat with same persona + context)
- **Share:** Export conversation as Markdown

---

## Journal Interface

```
┌─────────────────────────────────────────────────────────────┐
│ 📓 Journal Entry                                    Oct 6   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ [Rich text editor]                                          │
│                                                             │
│ Completed D426 today. Feeling good about progress.         │
│ Quiz went well—normalization is finally clicking.           │
│                                                             │
│ Need to focus on D315 next week (network security).        │
│ Velocity is below target, but catching up.                  │
│                                                             │
│ Also had an idea for Last.fm 2025—privacy-first music      │
│ analytics. Need to validate before committing.             │
│                                                             │
│ ─────────────────────────────────────────────────────────── │
│                                                             │
│ Tags: [+ Add Tag]                                           │
│ • Graduate WGU (Milestone)                                  │
│ • Pass D426 (Goal)                                          │
│                                                             │
│ Mood: [😊 Good] [😐 Neutral] [😟 Stressed] [🔥 Motivated] │
│                                                             │
│ [Save Entry] [Discard]                                      │
└─────────────────────────────────────────────────────────────┘
```

---

## Notes Panel (Quick Capture)

```
┌─────────────────────────────────────────────────────────────┐
│ 📝 Quick Notes                                              │
├─────────────────────────────────────────────────────────────┤
│ [Title: Poker hand analyzer idea________________]          │
│ [Body: ____________________________________...]             │
│ [Add Note]                                                  │
│ ─────────────────────────────────────────────────────────── │
│ Recent Notes:                                               │
│ • Last.fm 2025 idea (tagged: Projects)                     │
│ • Auth bug solution (tagged: Petform v2)                   │
│ • Workout plan tweak (tagged: Health)                      │
│ • GRE vocab strategy (tagged: GRE Prep)                    │
│                                                             │
│ [View All Notes] [Search]                                   │
└─────────────────────────────────────────────────────────────┘
```

---

## State Management

```typescript
// state/slices/reflectionsSlice.ts

interface ReflectionsSlice {
  // Personas
  personas: Map<string, Persona>;
  activePersonaId: string;
  switchPersona: (personaId: string) => void;
  
  // Chats
  chats: Map<string, ChatSession>;
  activeChatId?: string;
  createChat: (personaId: string) => Promise<string>;
  deleteChat: (chatId: string) => Promise<void>;
  
  // Messages
  sendMessage: (chatId: string, message: string) => Promise<void>;
  getMessages: (chatId: string) => Message[];
  
  // Journal
  journalEntries: Map<string, JournalEntry>;
  createJournalEntry: (data: CreateJournalData) => Promise<string>;
  updateJournalEntry: (id: string, updates: Partial<JournalEntry>) => Promise<void>;
  deleteJournalEntry: (id: string) => Promise<void>;
  
  // Notes
  notes: Map<string, Note>;
  createNote: (data: CreateNoteData) => Promise<string>;
  updateNote: (id: string, updates: Partial<Note>) => Promise<void>;
  deleteNote: (id: string) => Promise<void>;
  
  // Tagging
  tagToEntity: (noteId: string, entityType: EntityType, entityId: string) => Promise<void>;
  untagFromEntity: (noteId: string, entityType: EntityType, entityId: string) => Promise<void>;
  
  // Search
  searchChats: (query: string) => ChatSession[];
  searchNotes: (query: string) => Note[];
}

interface Persona {
  id: string;
  name: string;
  icon: string;
  tone: string;
  useCase: string;
  systemPrompt: string;
}

interface ChatSession {
  id: string;
  personaId: string;
  messages: Message[];
  createdAt: string;
  updatedAt: string;
}

interface Message {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: string;
  tags?: EntityTag[];
}

interface JournalEntry {
  id: string;
  title?: string;
  body: string;
  mood?: 'good' | 'neutral' | 'stressed' | 'motivated';
  tags: EntityTag[];
  createdAt: string;
  updatedAt: string;
}

interface Note {
  id: string;
  title: string;
  body: string;
  tags: EntityTag[];
  createdAt: string;
  updatedAt: string;
}

interface EntityTag {
  entityType: 'category' | 'milestone' | 'goal' | 'task';
  entityId: string;
  entityTitle: string;
}

type EntityType = EntityTag['entityType'];
```

---

## Database Schema

```sql
CREATE TABLE personas (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  icon TEXT NOT NULL,
  tone TEXT NOT NULL,
  use_case TEXT NOT NULL,
  system_prompt TEXT NOT NULL
);

CREATE TABLE chat_sessions (
  id TEXT PRIMARY KEY,
  persona_id TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  deleted_at TEXT,
  FOREIGN KEY (persona_id) REFERENCES personas(id)
);

CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  chat_session_id TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
  content TEXT NOT NULL,
  timestamp TEXT NOT NULL,
  FOREIGN KEY (chat_session_id) REFERENCES chat_sessions(id)
);

CREATE TABLE journal_entries (
  id TEXT PRIMARY KEY,
  title TEXT,
  body TEXT NOT NULL,
  mood TEXT CHECK (mood IN ('good', 'neutral', 'stressed', 'motivated')),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  deleted_at TEXT
);

CREATE TABLE notes (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  deleted_at TEXT
);

CREATE TABLE entity_tags (
  id TEXT PRIMARY KEY,
  note_id TEXT,
  journal_id TEXT,
  message_id TEXT,
  entity_type TEXT NOT NULL CHECK (entity_type IN ('category', 'milestone', 'goal', 'task')),
  entity_id TEXT NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY (note_id) REFERENCES notes(id),
  FOREIGN KEY (journal_id) REFERENCES journal_entries(id),
  FOREIGN KEY (message_id) REFERENCES messages(id)
);

CREATE INDEX idx_messages_chat ON messages(chat_session_id, timestamp);
CREATE INDEX idx_entity_tags_note ON entity_tags(note_id);
CREATE INDEX idx_entity_tags_entity ON entity_tags(entity_type, entity_id);
```

---

## AI Integration

### Context Building

When user sends a message, build context:

```typescript
async function buildChatContext(
  personaId: string,
  message: string,
  userId: string
): Promise<string> {
  const persona = await getPersona(personaId);
  const recentTasks = await getRecentTasks(userId, 5);
  const recentGoals = await getRecentGoals(userId, 3);
  const chatHistory = await getRecentMessages(personaId, 10);
  
  return `
${persona.systemPrompt}

User Context:
- Recent Tasks: ${recentTasks.map(t => t.title).join(', ')}
- Active Goals: ${recentGoals.map(g => g.title).join(', ')}
- Current Streak: ${getUserStreak(userId)} days

Chat History:
${chatHistory.map(m => `${m.role}: ${m.content}`).join('\n')}

User: ${message}
Assistant:
  `.trim();
}
```

### Ollama Integration

```typescript
// ai/service.ts

export async function chat(
  personaId: string,
  message: string,
  userId: string
): Promise<string> {
  const context = await buildChatContext(personaId, message, userId);
  
  const response = await fetch('http://localhost:11434/api/generate', {
    method: 'POST',
    body: JSON.stringify({
      model: 'llama3.2',
      prompt: context,
      stream: false,
      options: {
        temperature: 0.7,
        max_tokens: 1500,
      }
    }),
    signal: AbortSignal.timeout(20000), // 20s timeout
  });
  
  if (!response.ok) {
    throw new Error(`Ollama error: ${response.statusText}`);
  }
  
  const data = await response.json();
  return data.response;
}
```

---

## Acceptance Tests

### Happy Path
1. ✅ Switch persona → chat history clears → new conversation starts
2. ✅ Send message → AI responds within 5s → message persists
3. ✅ Create journal entry → tag to milestone → entry saved
4. ✅ Create note → tag to task → note appears in task modal
5. ✅ Search chats for "authentication" → find relevant conversations

### Edge Cases
1. ✅ Ollama offline → show error: "AI service unavailable"
2. ✅ Very long message → truncate or show warning
3. ✅ Switch persona mid-conversation → confirm dialog
4. ✅ Delete chat → confirm dialog → chat removed
5. ✅ Tag note to deleted task → untag automatically

---

## File Targets

- `src/features/reflections/ui/ReflectionsPage.tsx`
- `src/features/reflections/ui/ChatPanel.tsx`
- `src/features/reflections/ui/JournalPanel.tsx`
- `src/features/reflections/ui/NotesPanel.tsx`
- `src/features/reflections/ui/PersonaSwitcher.tsx`
- `src/features/reflections/logic/contextBuilder.ts`
- `src/state/slices/reflectionsSlice.ts`
- `src/ai/service.ts`
- `src/ai/experts/` (persona definitions)
- `src/infra/db/migrations/0007_reflections.sql`

