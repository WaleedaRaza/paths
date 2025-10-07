# 🚀 BUILD INSTRUCTIONS - LIFELINE OS V2

## ✅ Prerequisites

Before you begin, ensure:
1. ✅ Flutter is installed (`flutter doctor`)
2. ✅ Visual Studio 2022 (C++ Build Tools) is installed
3. ✅ Ollama is installed and running (`ollama serve`)
4. ✅ You're in the project root: `C:\Users\Waleed\Desktop\pathway`

**If Flutter is NOT installed**, see `SETUP_FLUTTER.md` first.

---

## 🏗️ Phase 0: Foundation Setup (RIGHT NOW)

### Step 1: Install Dependencies

```powershell
cd lifeline_os
flutter pub get
```

**Expected output:**
```
Running "flutter pub get" in lifeline_os...
Resolving dependencies... (2.1s)
Got dependencies!
```

### Step 2: Run Code Generation (for Drift/Freezed/Riverpod)

```powershell
dart run build_runner build --delete-conflicting-outputs
```

This will generate:
- Database code (Drift)
- Data classes (Freezed)
- Riverpod providers
- JSON serialization

**Note:** We haven't created database tables yet, so this might show warnings. That's OK for now.

### Step 3: Verify Setup

```powershell
flutter doctor -v
```

**Check for:**
- ✅ Flutter (Channel stable)
- ✅ Windows Version
- ✅ Visual Studio
- ✅ Connected device (Windows)

### Step 4: Run the App! 🔥

```powershell
flutter run -d windows
```

**Expected:** App window opens with dark theme, orange/teal accents, sidebar navigation, and "Today" page.

---

## 🎯 What We've Built So Far

### ✅ COMPLETED

**Infrastructure:**
- ✅ Flutter project structure
- ✅ Complete theme system (dark + orange/teal)
- ✅ App shell with sidebar navigation
- ✅ Go router with 7 routes
- ✅ Riverpod state management setup
- ✅ All feature page scaffolds

**Pages (Placeholders):**
- ✅ Today Page (with basic UI)
- ✅ Tasks Page
- ✅ Goals Page
- ✅ Milestones Page
- ✅ Project Planner Page
- ✅ Reflections Page
- ✅ Settings Page

**Configuration:**
- ✅ `pubspec.yaml` (all dependencies)
- ✅ `analysis_options.yaml` (strict linting)
- ✅ Window configuration (1400x900, custom title bar)

### 🚧 NEXT: Phase 1 - Database + Today Page

Once the app runs successfully, we'll build:

1. **Database Schema** (Drift ORM)
   - Tables: Milestones, Goals, Tasks, Subtasks, Categories
   - SQLCipher encryption
   - Migrations

2. **Today Page (Full Implementation)**
   - Must-Wins section (top 3 priority tasks)
   - Quick Add form
   - Today's schedule (timeline)
   - Task completion with points
   - Animations

---

## 🐛 Troubleshooting

### "flutter: command not found"
```powershell
# Add Flutter to PATH (if not done)
$env:Path += ";C:\src\flutter\bin"

# Or install via Winget
winget install --id=Google.Flutter -e
```

### "Visual Studio not found"
- Install Visual Studio 2022 Community
- Include "Desktop development with C++" workload

### "No devices found"
```powershell
flutter config --enable-windows-desktop
flutter doctor
```

### "Package not found" errors
```powershell
flutter clean
flutter pub get
```

### Build errors
```powershell
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

---

## 📁 Project Structure (Current)

```
lifeline_os/
├── lib/
│   ├── main.dart                      # ✅ Entry point
│   ├── app/
│   │   ├── app.dart                   # ✅ Main app widget
│   │   ├── theme.dart                 # ✅ Complete theme (dark + colors)
│   │   └── router.dart                # ✅ Navigation (7 routes)
│   ├── features/
│   │   ├── today/
│   │   │   └── presentation/
│   │   │       └── today_page.dart    # ✅ Today page (placeholder)
│   │   ├── tasks/
│   │   │   └── presentation/
│   │   │       └── tasks_page.dart    # ✅ Tasks page (placeholder)
│   │   ├── goals/
│   │   │   └── presentation/
│   │   │       └── goals_page.dart    # ✅ Goals page (placeholder)
│   │   ├── milestones/
│   │   │   └── presentation/
│   │   │       └── milestones_page.dart # ✅ Milestones page (placeholder)
│   │   ├── planner/
│   │   │   └── presentation/
│   │   │       └── planner_page.dart  # ✅ Planner page (placeholder)
│   │   ├── reflections/
│   │   │   └── presentation/
│   │   │       └── reflections_page.dart # ✅ Reflections page (placeholder)
│   │   └── settings/
│   │       └── presentation/
│   │           └── settings_page.dart # ✅ Settings page (placeholder)
│   └── shared/
│       └── widgets/
│           └── app_shell.dart         # ✅ Sidebar navigation
├── pubspec.yaml                       # ✅ Dependencies
├── analysis_options.yaml              # ✅ Linting rules
└── windows/                           # ✅ Windows platform code

NEXT TO BUILD:
├── lib/
│   ├── core/
│   │   ├── database/
│   │   │   ├── app_database.dart      # 🚧 Drift schema
│   │   │   └── migrations/            # 🚧 SQL migrations
│   │   ├── models/                    # 🚧 Data classes (Freezed)
│   │   └── services/                  # 🚧 Ollama, backup, analytics
```

---

## 🎯 Success Criteria (Phase 0)

Before moving to Phase 1, verify:
- ✅ App launches without errors
- ✅ Dark theme with orange/teal accents is visible
- ✅ Sidebar navigation works (can switch between pages)
- ✅ "Today" page shows placeholder content
- ✅ Window size is 1400x900
- ✅ No linting errors (`flutter analyze`)

---

## 🚀 Ready to Continue?

Once the app runs successfully, return here and say:

**"Phase 0 complete, start Phase 1"**

I'll build the database schema, implement the full Today page, and get data persistence working.

---

## 📊 Build Timeline

- **Phase 0**: Foundation ✅ (DONE - 2 hours)
- **Phase 1**: Today Page (Day 1-2, ~10 hours)
- **Phase 2**: Tasks Page (Day 3-4, ~10 hours)
- **Phase 3**: Goals & Milestones (Day 5-7, ~12 hours)
- **Phase 4**: AI Integration (Day 8-9, ~8 hours)
- **Phase 5**: Project Planner (Day 10-11, ~10 hours)
- **Phase 6**: Settings & Polish (Day 12-13, ~10 hours)

**Total**: ~62 hours (8-10 days)

---

**LET'S BUILD! 🔥**

