# Feature: Settings Page (Configuration & Data Management)

## Purpose & User Outcome

**Goal:** Central control panel for AI configuration, category management, backups, theme customization, and keyboard shortcuts.

**Success Criteria:**
- ✅ Configure local LLM (model, context, temperature)
- ✅ CRUD categories with custom colors
- ✅ Manual backup + auto-backup toggle
- ✅ Restore from backup
- ✅ Theme customization (dark/light, orange/teal accents)
- ✅ Keyboard shortcuts configuration

---

## User Stories

1. **AI Config:** I open Settings → AI tab, change model from `llama3.2` to `llama3.3`, test connection, see "Connected ✓" status.
2. **Category Management:** I add new category "Side Projects" with purple color, all tasks/goals can now use this category.
3. **Backup:** I click "Backup Now", file saves to `/backups/2025-10-06-14-32.db`, I verify it exists.
4. **Restore:** I select backup from last week, click "Restore", app restores data, I see tasks from last week reappear.
5. **Theme:** I switch accent color from orange to blue, entire app updates to blue accents.

---

## Page Layout (Tabs)

```
┌─────────────────────────────────────────────────────────────┐
│ Settings                                            [✕ Close]│
├─────────────────────────────────────────────────────────────┤
│ [🤖 AI] [📊 Categories] [💾 Backups] [🎨 Appearance] [⌨️ Keys]│
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ 🤖 AI Configuration                                         │
│ ─────────────────────────────────────────────────────────── │
│ Model:                                                      │
│ [llama3.2 ▼]  Options: llama3.2, llama3.3, mixtral, etc.   │
│                                                             │
│ API Endpoint:                                               │
│ [http://localhost:11434___________________________]         │
│ Status: ✅ Connected  [Test Connection]                    │
│                                                             │
│ Context Window:                                             │
│ [4096] tokens  [2048] [4096] [8192] [16384]                │
│                                                             │
│ Temperature:                                                │
│ [0.7] ━━━━━━●━━━━━━━ (0.0 = deterministic, 1.0 = creative) │
│                                                             │
│ Max Response Tokens:                                        │
│ [1500] tokens                                               │
│                                                             │
│ Timeout:                                                    │
│ [20] seconds                                                │
│                                                             │
│ [Save Changes] [Test with Sample Prompt]                    │
└─────────────────────────────────────────────────────────────┘
```

---

## Categories Tab

```
┌─────────────────────────────────────────────────────────────┐
│ Settings                                            [✕ Close]│
├─────────────────────────────────────────────────────────────┤
│ [🤖 AI] [📊 Categories] [💾 Backups] [🎨 Appearance] [⌨️ Keys]│
├─────────────────────────────────────────────────────────────┤
│ 📊 Manage Categories                                        │
│ ─────────────────────────────────────────────────────────── │
│                                                             │
│ ┌─ School ─────────────────────────────────────────────────┐│
│ │ Name: [School____________]  Color: [🟠]  Kind: school   ││
│ │ Base Points: [5]  Bonus Multiplier: [1.0]               ││
│ │ [Edit] [Delete]                                          ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ ┌─ Projects ───────────────────────────────────────────────┐│
│ │ Name: [Projects_________]  Color: [🔵]  Kind: projects  ││
│ │ Base Points: [10]  Bonus Multiplier: [2.0]              ││
│ │ [Edit] [Delete]                                          ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ ┌─ Health ─────────────────────────────────────────────────┐│
│ │ Name: [Health___________]  Color: [🟢]  Kind: health    ││
│ │ Base Points: [3]  Bonus Multiplier: [1.0]               ││
│ │ [Edit] [Delete]                                          ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ [5 more categories...]                                      │
│                                                             │
│ ┌─ Add New Category ───────────────────────────────────────┐│
│ │ Name: [_______________]                                  ││
│ │ Color: [Color Picker]                                    ││
│ │ Kind: [Custom ▼]                                         ││
│ │ Base Points: [5]  Bonus: [1.0]                           ││
│ │ [Add Category]                                           ││
│ └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
```

---

## Backups Tab

```
┌─────────────────────────────────────────────────────────────┐
│ Settings                                            [✕ Close]│
├─────────────────────────────────────────────────────────────┤
│ [🤖 AI] [📊 Categories] [💾 Backups] [🎨 Appearance] [⌨️ Keys]│
├─────────────────────────────────────────────────────────────┤
│ 💾 Backups & Data                                           │
│ ─────────────────────────────────────────────────────────── │
│                                                             │
│ Auto-Backup:                                                │
│ [✓] Enable automatic backups                                │
│ Frequency: [Daily ▼]  Options: Daily, Weekly, Never        │
│ Time: [03:00 AM]                                            │
│                                                             │
│ Backup Location:                                            │
│ [C:\Users\Waleed\Paths\backups\___] [Browse]               │
│                                                             │
│ Last Backup: 2 hours ago (2025-10-06 12:30:15)             │
│ [Backup Now]                                                │
│                                                             │
│ ─────────────────────────────────────────────────────────── │
│ Recent Backups:                                             │
│ ┌─────────────────────────────────────────────────────────┐│
│ │ 2025-10-06-12-30.db  •  2.4 MB  •  [Restore] [Delete]  ││
│ │ 2025-10-05-03-00.db  •  2.3 MB  •  [Restore] [Delete]  ││
│ │ 2025-10-04-03-00.db  •  2.2 MB  •  [Restore] [Delete]  ││
│ │ 2025-10-03-03-00.db  •  2.1 MB  •  [Restore] [Delete]  ││
│ │ 2025-10-02-03-00.db  •  2.0 MB  •  [Restore] [Delete]  ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ [Clean Up Old Backups (>30 days)]                          │
│                                                             │
│ ─────────────────────────────────────────────────────────── │
│ Import/Export:                                              │
│ [Export All Data (JSON)] [Import from JSON]                │
│ Warning: Import will merge data, not replace.              │
└─────────────────────────────────────────────────────────────┘
```

---

## Appearance Tab

```
┌─────────────────────────────────────────────────────────────┐
│ Settings                                            [✕ Close]│
├─────────────────────────────────────────────────────────────┤
│ [🤖 AI] [📊 Categories] [💾 Backups] [🎨 Appearance] [⌨️ Keys]│
├─────────────────────────────────────────────────────────────┤
│ 🎨 Appearance                                               │
│ ─────────────────────────────────────────────────────────── │
│                                                             │
│ Theme:                                                      │
│ [● Dark]  [○ Light]  [○ Auto (sync with system)]           │
│                                                             │
│ Accent Color:                                               │
│ [● Orange/Teal]  [○ Blue/Cyan]  [○ Purple/Pink]            │
│ [○ Green/Lime]  [○ Custom]                                  │
│                                                             │
│ Preview:                                                    │
│ ┌─────────────────────────────────────────────────────────┐│
│ │ ▼ School (3 goals, 45% complete)                        ││
│ │   [████████░░░░░░░░░░] 45%  Primary: Orange            ││
│ │                                                         ││
│ │ Must-Win:  Complete D426 Quiz      Secondary: Teal     ││
│ │ [Start Timer]                                           ││
│ └─────────────────────────────────────────────────────────┘│
│                                                             │
│ Font Size:                                                  │
│ [○ Small]  [● Medium]  [○ Large]                           │
│                                                             │
│ Density:                                                    │
│ [○ Compact]  [● Comfortable]  [○ Spacious]                 │
│                                                             │
│ Animations:                                                 │
│ [✓] Enable smooth transitions                              │
│ [✓] Enable celebration animations                          │
│ [✓] Enable progress bar animations                         │
│                                                             │
│ [Apply Changes] [Reset to Defaults]                        │
└─────────────────────────────────────────────────────────────┘
```

---

## Keyboard Shortcuts Tab

```
┌─────────────────────────────────────────────────────────────┐
│ Settings                                            [✕ Close]│
├─────────────────────────────────────────────────────────────┤
│ [🤖 AI] [📊 Categories] [💾 Backups] [🎨 Appearance] [⌨️ Keys]│
├─────────────────────────────────────────────────────────────┤
│ ⌨️ Keyboard Shortcuts                                       │
│ ─────────────────────────────────────────────────────────── │
│                                                             │
│ Navigation:                                                 │
│ Today Page         [Cmd+1]  [Change]                        │
│ Tasks Page         [Cmd+2]  [Change]                        │
│ Goals Page         [Cmd+3]  [Change]                        │
│ Milestones Page    [Cmd+4]  [Change]                        │
│ Planner Page       [Cmd+5]  [Change]                        │
│ Reflections Page   [Cmd+6]  [Change]                        │
│ Settings           [Cmd+,]  [Change]                        │
│                                                             │
│ Actions:                                                    │
│ Quick Add Task     [Cmd+N]  [Change]                        │
│ Start Timer        [Cmd+T]  [Change]                        │
│ Complete Task      [Cmd+Enter]  [Change]                    │
│ Search             [Cmd+K]  [Change]                        │
│                                                             │
│ Modals:                                                     │
│ Close Modal        [Esc]  [Change]                          │
│ Submit Form        [Cmd+S]  [Change]                        │
│                                                             │
│ [Reset to Defaults] [Import Shortcuts] [Export Shortcuts]   │
└─────────────────────────────────────────────────────────────┘
```

---

## State Management

```typescript
// state/slices/settingsSlice.ts

interface SettingsSlice {
  // AI Config
  aiConfig: AIConfig;
  updateAIConfig: (updates: Partial<AIConfig>) => Promise<void>;
  testAIConnection: () => Promise<boolean>;
  
  // Categories
  categories: Map<string, Category>;
  createCategory: (data: CreateCategoryData) => Promise<string>;
  updateCategory: (id: string, updates: Partial<Category>) => Promise<void>;
  deleteCategory: (id: string) => Promise<void>;
  
  // Backups
  backups: BackupInfo[];
  autoBackupEnabled: boolean;
  backupFrequency: 'daily' | 'weekly' | 'never';
  backupTime: string; // "03:00"
  lastBackupTime?: string;
  setAutoBackup: (enabled: boolean, frequency: SettingsSlice['backupFrequency']) => void;
  createBackup: () => Promise<string>;
  restoreBackup: (filename: string) => Promise<void>;
  deleteBackup: (filename: string) => Promise<void>;
  
  // Appearance
  theme: 'dark' | 'light' | 'auto';
  accentColor: 'orange-teal' | 'blue-cyan' | 'purple-pink' | 'green-lime' | 'custom';
  fontSize: 'small' | 'medium' | 'large';
  density: 'compact' | 'comfortable' | 'spacious';
  animationsEnabled: boolean;
  setTheme: (theme: SettingsSlice['theme']) => void;
  setAccentColor: (color: SettingsSlice['accentColor']) => void;
  
  // Keyboard Shortcuts
  shortcuts: Map<string, KeyboardShortcut>;
  updateShortcut: (action: string, keys: string) => void;
  resetShortcuts: () => void;
}

interface AIConfig {
  model: string;
  endpoint: string;
  contextWindow: number;
  temperature: number;
  maxTokens: number;
  timeout: number; // seconds
}

interface BackupInfo {
  filename: string;
  size: number; // bytes
  timestamp: string;
}

interface KeyboardShortcut {
  action: string;
  keys: string;
  description: string;
}
```

---

## Backup & Restore Logic

### Create Backup

```typescript
// infra/db/backup.ts

export async function createBackup(
  dbPath: string,
  backupDir: string
): Promise<string> {
  const timestamp = new Date().toISOString().replace(/:/g, '-').split('.')[0];
  const filename = `${timestamp}.db`;
  const backupPath = path.join(backupDir, filename);
  
  // Copy database file
  await fs.promises.copyFile(dbPath, backupPath);
  
  // Verify backup
  const stats = await fs.promises.stat(backupPath);
  if (stats.size === 0) {
    throw new Error('Backup file is empty');
  }
  
  return filename;
}
```

### Restore Backup

```typescript
// infra/db/restore.ts

export async function restoreBackup(
  backupPath: string,
  dbPath: string
): Promise<void> {
  // 1. Create a safety backup of current DB
  const safetyBackup = `${dbPath}.safety-${Date.now()}`;
  await fs.promises.copyFile(dbPath, safetyBackup);
  
  try {
    // 2. Close all DB connections
    await closeDatabase();
    
    // 3. Replace current DB with backup
    await fs.promises.copyFile(backupPath, dbPath);
    
    // 4. Reopen connections
    await openDatabase();
    
    // 5. Verify integrity
    const db = await getDatabase();
    const result = await db.query('PRAGMA integrity_check;');
    if (result[0].integrity_check !== 'ok') {
      throw new Error('Restored database failed integrity check');
    }
    
    // 6. Delete safety backup if successful
    await fs.promises.unlink(safetyBackup);
    
  } catch (error) {
    // Restore from safety backup
    await fs.promises.copyFile(safetyBackup, dbPath);
    await openDatabase();
    throw error;
  }
}
```

---

## Theme System

### CSS Variables (Orange/Teal Default)

```css
:root[data-theme="dark"][data-accent="orange-teal"] {
  /* Backgrounds */
  --bg-primary: #0a0a0a;
  --bg-secondary: #1a1a1a;
  --bg-tertiary: #2a2a2a;
  
  /* Text */
  --text-primary: #ffffff;
  --text-secondary: #a0a0a0;
  --text-tertiary: #707070;
  
  /* Primary Accent (Orange) */
  --accent-primary: #ff6b35;
  --accent-primary-hover: #ff8555;
  --accent-primary-active: #ff4b15;
  
  /* Secondary Accent (Teal) */
  --accent-secondary: #00bfa5;
  --accent-secondary-hover: #00d4b5;
  --accent-secondary-active: #009a85;
  
  /* Status Colors */
  --success: #4caf50;
  --warning: #ff9800;
  --error: #f44336;
  --info: #2196f3;
  
  /* Borders */
  --border-color: #3a3a3a;
  --border-color-hover: #4a4a4a;
}
```

---

## Acceptance Tests

### Happy Path
1. ✅ Change AI model → save → test connection → shows "Connected ✓"
2. ✅ Add new category → appears in task dropdowns immediately
3. ✅ Click "Backup Now" → file created in backup folder
4. ✅ Select backup → click "Restore" → confirm → data restored
5. ✅ Change accent color → entire app updates colors immediately

### Edge Cases
1. ✅ Delete category with existing tasks → warn: "X tasks use this category"
2. ✅ Restore backup while timers running → pause timers first
3. ✅ AI endpoint unreachable → show error with diagnostics
4. ✅ Backup folder not writable → show error + suggest new location
5. ✅ Restore corrupted backup → revert to safety backup

---

## File Targets

- `src/features/settings/ui/SettingsPage.tsx`
- `src/features/settings/ui/AIConfigTab.tsx`
- `src/features/settings/ui/CategoriesTab.tsx`
- `src/features/settings/ui/BackupsTab.tsx`
- `src/features/settings/ui/AppearanceTab.tsx`
- `src/features/settings/ui/ShortcutsTab.tsx`
- `src/state/slices/settingsSlice.ts`
- `src/infra/db/backup.ts`
- `src/infra/db/restore.ts`
- `src/infra/db/migrations/0008_settings.sql`

