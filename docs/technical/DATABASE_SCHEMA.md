# Database Schema (SQLite + SQLCipher)

## Overview

**Database:** SQLite 3.x with SQLCipher encryption  
**Location:** `~/Paths/app.db` (encrypted)  
**Key Storage:** OS Keychain (Tauri plugin)  
**Migrations:** Drizzle Kit (versioned SQL files)

---

## Core Tables (MGTST)

### categories
```sql
CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  color TEXT NOT NULL,  -- Hex color: #ff6b35
  kind TEXT NOT NULL CHECK (kind IN ('school', 'projects', 'health', 'finance', 'ds', 'career', 'agnostic')),
  base_points INTEGER NOT NULL DEFAULT 5,
  bonus_multiplier REAL NOT NULL DEFAULT 1.0,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX idx_categories_kind ON categories(kind);
```

### milestones
```sql
CREATE TABLE milestones (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  category_id TEXT NOT NULL,
  target_points INTEGER NOT NULL,
  progress_points INTEGER NOT NULL DEFAULT 0,  -- Cached, recomputed
  due TEXT,  -- ISO date: 2025-06-30
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed', 'archived')),
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  deleted_at TEXT,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
);

CREATE INDEX idx_milestones_category ON milestones(category_id, status);
CREATE INDEX idx_milestones_due ON milestones(due);
CREATE INDEX idx_milestones_status ON milestones(status);
```

### goals
```sql
CREATE TABLE goals (
  id TEXT PRIMARY KEY,
  milestone_id TEXT NOT NULL,
  title TEXT NOT NULL,
  order_index INTEGER NOT NULL DEFAULT 0,  -- Sort order within milestone
  points_target INTEGER,  -- Optional explicit target
  progress_points INTEGER NOT NULL DEFAULT 0,  -- Cached, recomputed
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed', 'archived')),
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  deleted_at TEXT,
  FOREIGN KEY (milestone_id) REFERENCES milestones(id) ON DELETE CASCADE
);

CREATE INDEX idx_goals_milestone ON goals(milestone_id, order_index);
CREATE INDEX idx_goals_status ON goals(status);
```

### tasks
```sql
CREATE TABLE tasks (
  id TEXT PRIMARY KEY,
  goal_id TEXT,  -- Optional link to goal
  title TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'todo' CHECK (status IN ('todo', 'doing', 'done', 'blocked', 'snoozed')),
  estimate_minutes INTEGER NOT NULL CHECK (estimate_minutes IN (5, 15, 25, 50, 90)),
  energy TEXT NOT NULL CHECK (energy IN ('low', 'med', 'high')),
  due TEXT,  -- ISO date
  points INTEGER NOT NULL DEFAULT 5,
  priority INTEGER CHECK (priority BETWEEN 1 AND 5),
  labels TEXT,  -- JSON array: ["authentication", "backend"]
  category_id TEXT NOT NULL,
  origin_planner_doc_id TEXT,  -- Link to planner doc (if generated)
  origin_card_id TEXT,  -- Link to feature card (if generated)
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  deleted_at TEXT,
  FOREIGN KEY (goal_id) REFERENCES goals(id) ON DELETE SET NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
);

CREATE INDEX idx_tasks_goal ON tasks(goal_id);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_due ON tasks(due);
CREATE INDEX idx_tasks_category ON tasks(category_id);
CREATE INDEX idx_tasks_energy ON tasks(energy);
CREATE FULLTEXT INDEX idx_tasks_title_fts ON tasks(title);  -- Full-text search
```

### goal_tasks (many-to-many junction)
```sql
CREATE TABLE goal_tasks (
  id TEXT PRIMARY KEY,
  goal_id TEXT NOT NULL,
  task_id TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (goal_id) REFERENCES goals(id) ON DELETE CASCADE,
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  UNIQUE (goal_id, task_id)
);

CREATE INDEX idx_goal_tasks_goal ON goal_tasks(goal_id);
CREATE INDEX idx_goal_tasks_task ON goal_tasks(task_id);
```

### subtasks
```sql
CREATE TABLE subtasks (
  id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL,
  title TEXT NOT NULL,
  kind TEXT NOT NULL CHECK (kind IN ('code_planning', 'research', 'writing', 'snippet', 'testing', 'debugging', 'generic')),
  done BOOLEAN NOT NULL DEFAULT 0,
  points INTEGER NOT NULL DEFAULT 1,
  order_index INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE
);

CREATE INDEX idx_subtasks_task ON subtasks(task_id, order_index);
```

---

## Scheduling & Logging

### schedule
```sql
CREATE TABLE schedule (
  id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL,
  day_iso TEXT NOT NULL,  -- "2025-10-06"
  time_slot TEXT NOT NULL,  -- "2025-10-06T10:00:00Z"
  status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'in_progress', 'completed', 'skipped')),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  UNIQUE (day_iso, time_slot)  -- One task per time slot
);

CREATE INDEX idx_schedule_day ON schedule(day_iso);
CREATE INDEX idx_schedule_task ON schedule(task_id);
```

### must_wins
```sql
CREATE TABLE must_wins (
  id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL,
  day_iso TEXT NOT NULL,  -- "2025-10-06"
  order_index INTEGER NOT NULL CHECK (order_index BETWEEN 0 AND 2),  -- 0, 1, 2 (3 max)
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  UNIQUE (day_iso, order_index),  -- Enforce 3 must-wins per day
  UNIQUE (task_id, day_iso)  -- Task can't be must-win twice in same day
);

CREATE INDEX idx_must_wins_day ON must_wins(day_iso);
```

### logs
```sql
CREATE TABLE logs (
  id TEXT PRIMARY KEY,
  task_id TEXT,
  subtask_id TEXT,
  type TEXT NOT NULL CHECK (type IN ('work', 'workout', 'reflection')),
  started_at TEXT NOT NULL,
  ended_at TEXT,
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE SET NULL,
  FOREIGN KEY (subtask_id) REFERENCES subtasks(id) ON DELETE SET NULL
);

CREATE INDEX idx_logs_task ON logs(task_id, started_at);
CREATE INDEX idx_logs_type ON logs(type, started_at);
```

---

## Project Planner

### planner_docs
```sql
CREATE TABLE planner_docs (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  core_idea TEXT NOT NULL,
  markdown_content TEXT,  -- Exported markdown
  json_capsule TEXT NOT NULL,  -- Full structured data (JSON)
  sections_included TEXT NOT NULL,  -- JSON array: ["project_info", "research"]
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  deleted_at TEXT
);

CREATE INDEX idx_planner_docs_created ON planner_docs(created_at DESC);
```

### feature_cards
```sql
CREATE TABLE feature_cards (
  id TEXT PRIMARY KEY,
  planner_doc_id TEXT NOT NULL,
  title TEXT NOT NULL,
  estimate_minutes INTEGER NOT NULL,
  files TEXT NOT NULL,  -- JSON array: ["api/spotify.ts", ...]
  tasks_json TEXT NOT NULL,  -- JSON array: [{"title": "Research", "estimate": 15}, ...]
  acceptance TEXT NOT NULL,  -- JSON array: ["Can authenticate", ...]
  risks TEXT NOT NULL,  -- JSON array: ["API rate limits", ...]
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (planner_doc_id) REFERENCES planner_docs(id) ON DELETE CASCADE
);

CREATE INDEX idx_feature_cards_doc ON feature_cards(planner_doc_id);
```

---

## Reflections

### personas
```sql
CREATE TABLE personas (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  icon TEXT NOT NULL,  -- Emoji: "🚀"
  tone TEXT NOT NULL,
  use_case TEXT NOT NULL,
  system_prompt TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Pre-populate with 8 personas
INSERT INTO personas (id, name, icon, tone, use_case, system_prompt) VALUES
  ('mirror-guide', 'Mirror-Guide', '🪞', 'Reflective, philosophical', 'Life decisions, goal alignment', '...'),
  ('lock-in-coach', 'Lock-In Coach', '⚡', 'Direct, motivating', 'Accountability, momentum', '...'),
  ('planner', 'Planner', '📋', 'Structured, tactical', 'Project management', '...'),
  ('therapist', 'Therapist', '🧠', 'Empathetic, insightful', 'Processing emotions', '...'),
  ('philosopher', 'Philosopher', '🏛️', 'Wise, contemplative', 'Existential questions', '...'),
  ('psych-strategist', 'Psych Strategist', '🧩', 'Strategic, observant', 'Power dynamics', '...'),
  ('architect', 'Architect', '🏗️', 'Technical, precise', 'System design', '...'),
  ('founder-engineer', 'Founder-Engineer', '🚀', 'Pragmatic, ship-focused', 'MVPs, validation', '...');
```

### chat_sessions
```sql
CREATE TABLE chat_sessions (
  id TEXT PRIMARY KEY,
  persona_id TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  deleted_at TEXT,
  FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE CASCADE
);

CREATE INDEX idx_chat_sessions_persona ON chat_sessions(persona_id, created_at DESC);
```

### messages
```sql
CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  chat_session_id TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
  content TEXT NOT NULL,
  timestamp TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (chat_session_id) REFERENCES chat_sessions(id) ON DELETE CASCADE
);

CREATE INDEX idx_messages_chat ON messages(chat_session_id, timestamp ASC);
CREATE FULLTEXT INDEX idx_messages_content_fts ON messages(content);  -- Full-text search
```

### journal_entries
```sql
CREATE TABLE journal_entries (
  id TEXT PRIMARY KEY,
  title TEXT,
  body TEXT NOT NULL,
  mood TEXT CHECK (mood IN ('good', 'neutral', 'stressed', 'motivated')),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  deleted_at TEXT
);

CREATE INDEX idx_journal_entries_created ON journal_entries(created_at DESC);
CREATE FULLTEXT INDEX idx_journal_entries_body_fts ON journal_entries(body);
```

### notes
```sql
CREATE TABLE notes (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  deleted_at TEXT
);

CREATE INDEX idx_notes_created ON notes(created_at DESC);
CREATE FULLTEXT INDEX idx_notes_title_fts ON notes(title);
CREATE FULLTEXT INDEX idx_notes_body_fts ON notes(body);
```

### entity_tags
```sql
CREATE TABLE entity_tags (
  id TEXT PRIMARY KEY,
  note_id TEXT,
  journal_id TEXT,
  message_id TEXT,
  entity_type TEXT NOT NULL CHECK (entity_type IN ('category', 'milestone', 'goal', 'task')),
  entity_id TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
  FOREIGN KEY (journal_id) REFERENCES journal_entries(id) ON DELETE CASCADE,
  FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE,
  CHECK ((note_id IS NOT NULL) + (journal_id IS NOT NULL) + (message_id IS NOT NULL) = 1)  -- Exactly one source
);

CREATE INDEX idx_entity_tags_note ON entity_tags(note_id);
CREATE INDEX idx_entity_tags_journal ON entity_tags(journal_id);
CREATE INDEX idx_entity_tags_message ON entity_tags(message_id);
CREATE INDEX idx_entity_tags_entity ON entity_tags(entity_type, entity_id);
```

---

## Settings

### settings
```sql
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,  -- JSON-serialized value
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Pre-populate with defaults
INSERT INTO settings (key, value) VALUES
  ('ai.model', '"llama3.2"'),
  ('ai.endpoint', '"http://localhost:11434"'),
  ('ai.contextWindow', '4096'),
  ('ai.temperature', '0.7'),
  ('ai.maxTokens', '1500'),
  ('ai.timeout', '20'),
  ('backup.autoEnabled', 'true'),
  ('backup.frequency', '"daily"'),
  ('backup.time', '"03:00"'),
  ('theme', '"dark"'),
  ('accentColor', '"orange-teal"'),
  ('fontSize', '"medium"'),
  ('density', '"comfortable"'),
  ('animationsEnabled', 'true');
```

---

## Analytics & Streaks

### user_stats
```sql
CREATE TABLE user_stats (
  id TEXT PRIMARY KEY,
  day_iso TEXT NOT NULL UNIQUE,  -- "2025-10-06"
  tasks_completed INTEGER NOT NULL DEFAULT 0,
  points_earned INTEGER NOT NULL DEFAULT 0,
  streak_active BOOLEAN NOT NULL DEFAULT 0,  -- >=3 tasks = streak continues
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX idx_user_stats_day ON user_stats(day_iso DESC);
```

---

## Migration Strategy

### migrations table
```sql
CREATE TABLE migrations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  applied_at TEXT NOT NULL DEFAULT (datetime('now'))
);
```

### Migration Files (Drizzle Kit)

```
src/infra/db/migrations/
├── 0001_initial_schema.sql          -- Categories, Milestones, Goals, Tasks, Subtasks
├── 0002_today_schedule.sql          -- Schedule, Must-Wins, Logs
├── 0003_planner.sql                 -- Planner Docs, Feature Cards
├── 0004_reflections.sql             -- Personas, Chats, Messages, Journal, Notes, Tags
├── 0005_settings.sql                -- Settings table
├── 0006_analytics.sql               -- User Stats, Streaks
├── 0007_indexes_performance.sql     -- Additional indexes
└── 0008_fulltext_search.sql         -- FTS indexes
```

---

## Backup Strategy

**Frequency:** Daily at 3am (configurable)  
**Location:** User-chosen folder (default: `~/Paths/backups/`)  
**Format:** `YYYY-MM-DD-HH-MM.db` (encrypted SQLite file)  
**Retention:** Keep last 30 backups, auto-delete older  
**Verification:** PRAGMA integrity_check on every backup

---

## Security

**Encryption:** SQLCipher with 256-bit AES  
**Key:** Stored in OS Keychain (Tauri plugin)  
**Rotation:** Not implemented (v1), can be added later  
**Access:** Only app process can decrypt (no shared access)

---

## Performance

**Indexes:** All foreign keys, frequently queried columns, full-text search  
**Caching:** `progress_points` cached in Goals/Milestones (invalidate on write)  
**Transactions:** Batch writes (e.g., bulk task updates)  
**Vacuum:** Run monthly to reclaim space  
**PRAGMA optimizations:**
```sql
PRAGMA journal_mode = WAL;  -- Write-Ahead Logging (faster writes)
PRAGMA synchronous = NORMAL;  -- Balance between safety and speed
PRAGMA foreign_keys = ON;  -- Enforce foreign key constraints
PRAGMA temp_store = MEMORY;  -- Store temp tables in RAM
```

---

## Sample Queries

### Get Today's Must-Wins with Task Details
```sql
SELECT 
  t.id,
  t.title,
  t.estimate_minutes,
  t.energy,
  t.status,
  c.name as category_name,
  c.color as category_color,
  COUNT(s.id) as subtask_count,
  SUM(CASE WHEN s.done = 1 THEN 1 ELSE 0 END) as subtasks_done
FROM must_wins mw
INNER JOIN tasks t ON mw.task_id = t.id
LEFT JOIN categories c ON t.category_id = c.id
LEFT JOIN subtasks s ON t.id = s.task_id
WHERE mw.day_iso = '2025-10-06'
  AND t.deleted_at IS NULL
GROUP BY t.id
ORDER BY mw.order_index ASC;
```

### Recompute Goal Progress
```sql
WITH task_points AS (
  SELECT 
    gt.goal_id,
    SUM(CASE 
      WHEN t.status = 'done' THEN t.points + COALESCE(s.subtask_points, 0)
      ELSE COALESCE(s.subtask_points, 0)
    END) as total_points
  FROM goal_tasks gt
  INNER JOIN tasks t ON gt.task_id = t.id AND t.deleted_at IS NULL
  LEFT JOIN (
    SELECT task_id, SUM(points) as subtask_points
    FROM subtasks
    WHERE done = 1
    GROUP BY task_id
  ) s ON t.id = s.task_id
  WHERE gt.goal_id = ?
  GROUP BY gt.goal_id
)
UPDATE goals
SET progress_points = (SELECT total_points FROM task_points WHERE goal_id = goals.id),
    updated_at = datetime('now')
WHERE id = ?;
```

### Get Streak Data
```sql
SELECT 
  COUNT(*) as current_streak
FROM user_stats
WHERE streak_active = 1
  AND day_iso >= (
    SELECT MIN(day_iso)
    FROM user_stats
    WHERE streak_active = 1
      AND day_iso >= date('now', '-30 days')
  );
```

