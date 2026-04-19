# 🏗️ LIFELINE OS V2 - TECHNICAL SPECIFICATION
## Flutter Desktop + Web Implementation

**Date**: October 6, 2025  
**Target Platform**: Windows (Primary), Web (Secondary)  
**User Profile**: Student-founder with ADHD, needs intrinsic motivation mechanics  

---

## 📊 EXECUTIVE SUMMARY

**Recommendation: Use Flutter** ✅

**Why:**
- ✅ Single codebase → Desktop + Web + Mobile (future)
- ✅ Native Windows performance
- ✅ Beautiful, customizable UI (critical for ADHD engagement)
- ✅ Hot reload for rapid iteration
- ✅ Strong typing with Dart (similar to TypeScript)
- ✅ Excellent local-first support (SQLite via FFI)

**Trade-offs Accepted:**
- ⚠️ Learn Dart (not TypeScript)
- ⚠️ Ollama HTTP-only (no native bindings, but sufficient)
- ⚠️ Web version has limitations (no native file system)
- ⚠️ All V2 docs need minor adjustments (Dart syntax, not React)

---

## 🎯 CORE REQUIREMENTS RECAP

### Functional
1. **MGTST Hierarchy**: Milestone → Goal → Task → Subtask with point roll-ups
2. **Today Page**: Timeline, Must-Wins, Quick Add, Workout Log
3. **Tasks Page**: List/Kanban/Calendar views, AI breakdown, subtasks
4. **Goals Page**: Tree view, progress tracking, milestone management
5. **Milestones Page**: Card grid, velocity tracking
6. **Project Planner**: AI-powered planning with field editor
7. **Reflections Page**: 8 AI personas, chat, journaling, entity tagging
8. **Settings Page**: AI config, categories, backups, theme

### Non-Functional
1. **Local-First**: Offline-capable, fast, no cloud dependency
2. **Secure**: SQLCipher encryption for sensitive data
3. **ADHD-Optimized**: Friction removal, visual feedback, momentum mechanics
4. **Scalable**: Clean architecture, easy to add features
5. **Beautiful**: Sleek dark UI, orange/teal theme, polished components

---

## 🛠️ FLUTTER TECH STACK (FINAL)

### **Desktop (Windows Primary Target)**

```yaml
Framework: Flutter 3.16+ (Stable Channel)
Language: Dart 3.2+
Platform: Windows (win32 desktop)

# Core Dependencies
state_management: riverpod ^2.4.0          # Better than Provider, clean async
database: drift ^2.14.0                    # Type-safe SQLite ORM (like Drizzle)
encryption: drift/native + sqlcipher       # SQLCipher integration
local_storage: shared_preferences ^2.2.0  # For settings/UI state
path_provider: ^2.1.0                      # Cross-platform paths

# UI/UX
animations: flutter_animate ^4.5.0         # Micro-interactions for dopamine
charts: fl_chart ^0.66.0                   # Progress graphs
calendar: table_calendar ^3.0.0            # Calendar view
markdown: flutter_markdown ^0.6.0          # Rich text rendering
icons: lucide_icons_flutter ^1.0.0         # Lucide icon set (like old app)

# AI Integration
http: http ^1.1.0                          # Ollama HTTP client
dio: ^5.4.0                                # Advanced HTTP (retries, interceptors)

# Developer Experience
freezed: ^2.4.0                            # Immutable data classes
json_serializable: ^6.7.0                  # JSON parsing
build_runner: ^2.4.0                       # Code generation
```

### **Web (Future Target)**

```yaml
Platform: Flutter Web (WASM + JS)
Database: drift_web (uses IndexedDB)
AI: Remote API (OpenAI/Anthropic) via proxy
Limitations: No native file system, no SQLCipher
```

### **Why These Choices?**

| Concern | Solution | Rationale |
|---------|----------|-----------|
| State Management | Riverpod | Better DX than Provider, clean async, compile-time safety |
| Database | Drift + SQLCipher | Type-safe ORM, migrations, encryption, same feel as Drizzle |
| Ollama | HTTP via Dio | No native bindings needed, robust error handling |
| UI Consistency | Material 3 + Custom | Base on Material, override for brand (dark + orange/teal) |
| ADHD Needs | flutter_animate | Smooth micro-interactions, visual feedback |

---

## 🏛️ ARCHITECTURE

### **Folder Structure (Flutter Clean Architecture)**

```
lib/
├── main.dart                          # Entry point
├── app/
│   ├── theme.dart                     # Dark theme + orange/teal palette
│   ├── router.dart                    # Navigation (go_router)
│   └── constants.dart                 # App-wide constants
├── core/
│   ├── database/
│   │   ├── app_database.dart          # Drift database definition
│   │   ├── app_database.g.dart        # Generated
│   │   └── migrations/                # SQL migrations
│   ├── models/
│   │   ├── mgtst/
│   │   │   ├── milestone.dart         # Freezed data classes
│   │   │   ├── goal.dart
│   │   │   ├── task.dart
│   │   │   └── subtask.dart
│   │   ├── category.dart
│   │   ├── planner_doc.dart
│   │   └── note.dart
│   ├── services/
│   │   ├── ollama_service.dart        # AI HTTP client
│   │   ├── backup_service.dart        # Export/import
│   │   └── analytics_service.dart     # Points, streaks
│   └── utils/
│       ├── date_helpers.dart
│       └── validators.dart
├── features/
│   ├── today/
│   │   ├── data/                      # Repositories (DB access)
│   │   ├── domain/                    # Business logic (pure functions)
│   │   ├── presentation/              # UI + Riverpod providers
│   │   │   ├── providers/
│   │   │   ├── widgets/
│   │   │   └── today_page.dart
│   │   └── today_feature.dart         # Public API
│   ├── tasks/
│   ├── goals/
│   ├── milestones/
│   ├── planner/
│   ├── reflections/
│   └── settings/
└── shared/
    ├── widgets/                       # Reusable components
    │   ├── buttons/
    │   ├── cards/
    │   ├── forms/
    │   └── dialogs/
    └── extensions/
```

### **Data Flow (Unidirectional)**

```
UI Widget
  ↓ (user action)
Riverpod Provider/Notifier
  ↓ (dispatch action)
Repository (domain logic)
  ↓ (pure functions)
Drift Database / Ollama Service
  ↓ (data mutation)
Riverpod State Update
  ↓ (rebuild)
UI Widget (reflects new state)
```

**Key Principles:**
- **Features are isolated**: Each feature folder is self-contained
- **State is explicit**: All state lives in Riverpod providers
- **IO at edges**: Database/HTTP only in repositories
- **Pure logic**: Domain layer has no Flutter imports

---

## 💾 DATA PERSISTENCE STRATEGY

### **SQLite + SQLCipher (Drift ORM)**

#### **Why Drift?**
- ✅ Type-safe queries (compile-time checks)
- ✅ Automatic migrations (like Drizzle Kit)
- ✅ Reactive streams (watch queries, auto-update UI)
- ✅ SQLCipher support (encryption)
- ✅ Multi-platform (Windows, Android, iOS, Web via IndexedDB)

#### **Schema Definition (Drift Tables)**

```dart
// lib/core/database/tables.dart

@DataClassName('Milestone')
class Milestones extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get status => text()(); // active, completed, archived
  IntColumn get totalPoints => integer().withDefault(const Constant(0))();
  IntColumn get earnedPoints => integer().withDefault(const Constant(0))();
  DateTimeColumn get deadline => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

@DataClassName('Goal')
class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get milestoneId => text().references(Milestones, #id)();
  TextColumn get parentGoalId => text().nullable().references(Goals, #id)(); // Hierarchy
  IntColumn get orderIndex => integer()();
  IntColumn get targetPoints => integer()();
  IntColumn get earnedPoints => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('Task')
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 300)();
  TextColumn get description => text().nullable()();
  TextColumn get goalId => text().nullable().references(Goals, #id)();
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get status => text()(); // todo, in_progress, completed, blocked
  TextColumn get priority => text()(); // high, medium, low
  IntColumn get estimateMin => integer()();
  TextColumn get energy => text()(); // low, medium, high
  IntColumn get points => integer().withDefault(const Constant(0))();
  BoolColumn get isAtomic => boolean().withDefault(const Constant(true))();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get scheduledAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

@DataClassName('Subtask')
class Subtasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get title => text()();
  IntColumn get orderIndex => integer()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get estimateMin => integer()();
  TextColumn get kind => text()(); // checklist, sequential, parallel
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('Category')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  TextColumn get colorHex => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  Set<Column> get primaryKey => {id};
}

// + PlannerDocs, Notes, MustWins, Schedule, Logs (see docs/technical/DATABASE_SCHEMA.md)
```

#### **Encryption Setup**

```dart
// lib/core/database/app_database.dart

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

@DriftDatabase(tables: [Milestones, Goals, Tasks, Subtasks, Categories, ...])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1; // Increment on schema changes

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Seed default categories
      await _seedDefaultCategories();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle migrations (like Drizzle Kit)
      // if (from < 2) { ... }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'lifeline.db'));
    
    // SQLCipher encryption
    return NativeDatabase(
      file,
      setup: (database) {
        final key = await _getOrCreateEncryptionKey(); // From secure storage
        database.execute("PRAGMA key = '$key'");
        database.execute('PRAGMA cipher_page_size = 4096');
        database.execute('PRAGMA kdf_iter = 256000');
      },
    );
  });
}

// Store encryption key in Windows Credential Manager via flutter_secure_storage
Future<String> _getOrCreateEncryptionKey() async {
  final storage = FlutterSecureStorage();
  String? key = await storage.read(key: 'db_encryption_key');
  if (key == null) {
    key = _generateRandomKey(32); // 256-bit key
    await storage.write(key: 'db_encryption_key', value: key);
  }
  return key;
}
```

#### **Reactive Queries (Auto-Update UI)**

```dart
// lib/features/today/data/today_repository.dart

class TodayRepository {
  final AppDatabase _db;
  TodayRepository(this._db);

  // Stream that auto-updates when data changes
  Stream<List<Task>> watchMustWinTasks() {
    return (_db.select(_db.tasks)
          ..where((t) => t.status.equals('todo'))
          ..orderBy([(t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc)])
          ..limit(3))
        .watch(); // ← Key: watch() not get()
  }

  Stream<List<Task>> watchTodaySchedule() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(Duration(days: 1));
    
    return (_db.select(_db.tasks)
          ..where((t) => t.scheduledAt.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([(t) => OrderingTerm(expression: t.scheduledAt)]))
        .watch();
  }

  Future<void> completeTask(int taskId) async {
    await _db.update(_db.tasks).replace(
      TasksCompanion(
        id: Value(taskId),
        status: Value('completed'),
        completedAt: Value(DateTime.now()),
      ),
    );
    // Automatically triggers UI rebuild via watch()
  }
}
```

#### **Backup & Export**

```dart
// lib/core/services/backup_service.dart

class BackupService {
  final AppDatabase _db;
  
  Future<File> exportToJson() async {
    final data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'milestones': await _db.select(_db.milestones).get(),
      'goals': await _db.select(_db.goals).get(),
      'tasks': await _db.select(_db.tasks).get(),
      'subtasks': await _db.select(_db.subtasks).get(),
      // ... all tables
    };
    
    final json = jsonEncode(data);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(json);
    return file;
  }

  Future<void> importFromJson(File backupFile) async {
    final json = await backupFile.readAsString();
    final data = jsonDecode(json);
    
    await _db.transaction(() async {
      // Clear existing data
      await _db.delete(_db.tasks).go();
      // ... clear all tables
      
      // Import new data
      for (var milestone in data['milestones']) {
        await _db.into(_db.milestones).insert(Milestone.fromJson(milestone));
      }
      // ... import all tables
    });
  }
}
```

---

## 🎨 UI/UX FOR ADHD (CRITICAL)

### **Understanding the User: ADHD Brain Patterns**

| ADHD Challenge | UI/UX Solution |
|----------------|----------------|
| **Initiation Cost** | One-tap actions, pre-filled forms, templates |
| **Context Switching** | Sticky headers, breadcrumbs, persistent navigation |
| **Working Memory** | Visual cues, progressive disclosure, inline help |
| **Hyperfocus Traps** | Timers, gentle notifications, break reminders |
| **Reward Delay** | Instant feedback, points, animations, streaks |
| **Decision Paralysis** | Smart defaults, AI suggestions, limited choices |
| **Boredom Sensitivity** | Varied UI, gamification, surprise & delight |

### **Design Principles (Self-Determination Theory)**

#### **1. Autonomy (User Control)**
```
✅ DO:
- Let user customize categories, colors, icons
- Provide multiple views (List, Kanban, Calendar)
- Allow reordering, drag-drop
- Quick add shortcuts (Ctrl+T, Ctrl+G)
- "Your way" messaging

❌ DON'T:
- Force specific workflows
- Hide advanced settings
- Lock UI layout
```

#### **2. Competence (Mastery Feedback)**
```
✅ DO:
- Point roll-ups (Task → Goal → Milestone)
- Streaks (days worked)
- Progress bars with animations
- Completion celebrations (confetti, sound)
- Level system (Bronze → Silver → Gold)
- "You completed 5 tasks this week!" insights

❌ DON'T:
- Punish missed tasks
- Shame language
- Complex scoring formulas
```

#### **3. Relatedness (Social Proof)**
```
✅ DO:
- Shareable progress cards (export PNG)
- "Join 1,000+ builders" messaging
- Expert AI personas (8 companions)
- Journal entries feel like conversations
- Export to show others

❌ DON'T:
- Forced social features
- Public leaderboards
- Comparison mechanics
```

### **Color System (Dark + Orange/Teal)**

```dart
// lib/app/theme.dart

class AppColors {
  // Base Dark Palette
  static const background = Color(0xFF0A0A0B);      // Almost black
  static const surface = Color(0xFF18181B);         // Zinc 900
  static const surfaceVariant = Color(0xFF27272A);  // Zinc 800
  static const border = Color(0xFF3F3F46);          // Zinc 700
  
  // Primary (Orange)
  static const primary = Color(0xFFF97316);         // Orange 500
  static const primaryLight = Color(0xFFFB923C);    // Orange 400
  static const primaryDark = Color(0xFFEA580C);     // Orange 600
  
  // Secondary (Teal)
  static const secondary = Color(0xFF14B8A6);       // Teal 500
  static const secondaryLight = Color(0xFF2DD4BF);  // Teal 400
  static const secondaryDark = Color(0xFF0D9488);   // Teal 600
  
  // Semantic
  static const success = Color(0xFF10B981);         // Green 500
  static const warning = Color(0xFFF59E0B);         // Amber 500
  static const error = Color(0xFFEF4444);           // Red 500
  static const info = Color(0xFF3B82F6);            // Blue 500
  
  // Text
  static const textPrimary = Color(0xFFFAFAFA);     // Zinc 50
  static const textSecondary = Color(0xFFA1A1AA);   // Zinc 400
  static const textTertiary = Color(0xFF71717A);    // Zinc 500
}

ThemeData buildAppTheme() {
  return ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.background,
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
    ),
    // ... full Material 3 theme override
  );
}
```

### **Micro-Interactions (Dopamine Hits)**

```dart
// Every action should have visual feedback

// ✅ Task Completion
onTap: () {
  _completeTask(task.id);
  _showCelebration(); // Confetti animation
  _playSound('complete.mp3'); // Optional haptic/sound
  _updatePoints(); // Animate +15 points
}

// ✅ Drag & Drop
Draggable(
  feedback: Transform.scale(
    scale: 1.1, // Slightly bigger while dragging
    child: Opacity(opacity: 0.8, child: TaskCard(task)),
  ),
  onDragEnd: (details) {
    _animateSnap(); // Snap into place
  },
);

// ✅ Loading States
if (isLoading) 
  Shimmer.fromColors( // Skeleton UI, never spinners
    baseColor: AppColors.surface,
    highlightColor: AppColors.surfaceVariant,
    child: TaskCardSkeleton(),
  )

// ✅ Empty States (Encouraging)
EmptyState(
  icon: LucideIcons.sparkles,
  title: "Ready to crush it?",
  subtitle: "Add your first task and start building momentum",
  action: ElevatedButton(
    onPressed: _showQuickAdd,
    child: Text("Quick Add Task"),
  ),
)
```

### **Component Library (Consistent UX)**

```
shared/widgets/
├── buttons/
│   ├── primary_button.dart        # Orange, elevated
│   ├── secondary_button.dart      # Teal, outline
│   ├── ghost_button.dart          # Transparent hover
│   └── icon_button.dart           # Round, hover bg
├── cards/
│   ├── task_card.dart             # Swipeable, drag handle
│   ├── goal_card.dart             # Expandable, progress ring
│   └── insight_card.dart          # AI suggestion banner
├── forms/
│   ├── text_field.dart            # Dark border, focus glow
│   ├── dropdown.dart              # Custom styled
│   ├── date_picker.dart           # Inline calendar
│   └── time_picker.dart           # Scroll wheel
├── dialogs/
│   ├── task_modal.dart            # Full-screen on mobile
│   ├── confirmation_dialog.dart   # Danger actions
│   └── bottom_sheet.dart          # Quick actions
└── feedback/
    ├── celebration_animation.dart # Lottie confetti
    ├── points_toast.dart          # +15 pts floating up
    └── streak_badge.dart          # Fire emoji + days
```

---

## 🤖 OLLAMA INTEGRATION

### **HTTP Client (Dio)**

```dart
// lib/core/services/ollama_service.dart

class OllamaService {
  final Dio _dio;
  final String baseUrl;
  
  OllamaService({this.baseUrl = 'http://localhost:11434'})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 60),
        )) {
    _dio.interceptors.add(LogInterceptor()); // Debug logging
    _dio.interceptors.add(RetryInterceptor()); // Auto-retry on failure
  }

  // Check if Ollama is running
  Future<bool> isAvailable() async {
    try {
      final response = await _dio.get('/api/tags');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // List available models
  Future<List<String>> listModels() async {
    final response = await _dio.get('/api/tags');
    final data = response.data as Map<String, dynamic>;
    final models = (data['models'] as List)
        .map((m) => m['name'] as String)
        .toList();
    return models;
  }

  // Generate (streaming)
  Stream<String> generateStream({
    required String model,
    required String prompt,
    String? systemPrompt,
    Map<String, dynamic>? options,
  }) async* {
    final request = {
      'model': model,
      'prompt': prompt,
      'system': systemPrompt,
      'stream': true,
      'options': options ?? {
        'temperature': 0.7,
        'top_p': 0.9,
        'num_ctx': 8192,
      },
    };

    final response = await _dio.post(
      '/api/generate',
      data: request,
      options: Options(responseType: ResponseType.stream),
    );

    final stream = response.data.stream as Stream<List<int>>;
    await for (final chunk in stream) {
      final text = utf8.decode(chunk);
      final json = jsonDecode(text);
      yield json['response'] as String;
      
      if (json['done'] == true) break;
    }
  }

  // Generate (non-streaming, for simple cases)
  Future<String> generate({
    required String model,
    required String prompt,
    String? systemPrompt,
  }) async {
    final request = {
      'model': model,
      'prompt': prompt,
      'system': systemPrompt,
      'stream': false,
    };

    final response = await _dio.post('/api/generate', data: request);
    return response.data['response'] as String;
  }

  // Chat (multi-turn conversations)
  Future<String> chat({
    required String model,
    required List<Map<String, String>> messages,
  }) async {
    final request = {
      'model': model,
      'messages': messages,
      'stream': false,
    };

    final response = await _dio.post('/api/chat', data: request);
    return response.data['message']['content'] as String;
  }
}
```

### **Expert System (8 Personas)**

```dart
// lib/features/reflections/domain/expert_system.dart

@freezed
class Expert with _$Expert {
  const factory Expert({
    required String id,
    required String name,
    required String archetype,
    required String icon,
    required String description,
    required String systemPrompt,
    required Color color,
  }) = _Expert;
}

class ExpertService {
  static final List<Expert> experts = [
    Expert(
      id: 'mirror-guide',
      name: 'The Mirror-Guide',
      archetype: 'Jarvis Core',
      icon: '🪞',
      description: 'Holistic life strategist who sees the big picture',
      systemPrompt: '''[From migration-reference/02-expert-definitions.ts]''',
      color: AppColors.info,
    ),
    Expert(
      id: 'lock-in-coach',
      name: 'The Lock-In Coach',
      archetype: 'Accountability Force',
      icon: '⚡',
      description: 'No-bullshit accountability coach',
      systemPrompt: '''[From migration-reference/02-expert-definitions.ts]''',
      color: AppColors.error,
    ),
    // ... all 8 experts from migration reference
  ];

  final OllamaService _ollama;
  
  Future<String> askExpert({
    required String expertId,
    required String message,
    required Map<String, dynamic> context, // tasks, goals, etc.
  }) async {
    final expert = experts.firstWhere((e) => e.id == expertId);
    
    // Build context string
    final contextStr = _buildContextString(context);
    
    // Combine system prompt + context
    final systemPrompt = '''
${expert.systemPrompt}

## Current Context:
$contextStr
    ''';

    return await _ollama.generate(
      model: 'llama3.2', // Or user-selected model
      prompt: message,
      systemPrompt: systemPrompt,
    );
  }

  String _buildContextString(Map<String, dynamic> context) {
    // Serialize relevant context (tasks, goals, etc.)
    // Keep it concise to fit in context window
    return '''
**Active Tasks**: ${context['tasks']?.length ?? 0}
**Active Goals**: ${context['goals']?.length ?? 0}
**Today's Must-Wins**: [list top 3]
**Recent Activity**: [last 5 actions]
    ''';
  }
}
```

---

## 🎯 RIVERPOD STATE MANAGEMENT

### **Why Riverpod?**
- ✅ Compile-time safety (no runtime context errors)
- ✅ Testable (providers are pure functions)
- ✅ Async-first (FutureProvider, StreamProvider)
- ✅ Auto-dispose (no memory leaks)
- ✅ DevTools support

### **Provider Architecture**

```dart
// lib/features/today/presentation/providers/today_providers.dart

// Database provider (singleton)
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Repository provider
final todayRepositoryProvider = Provider<TodayRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TodayRepository(db);
});

// Must-Win tasks (stream, auto-updates)
final mustWinTasksProvider = StreamProvider<List<Task>>((ref) {
  final repo = ref.watch(todayRepositoryProvider);
  return repo.watchMustWinTasks();
});

// Today's schedule (stream)
final todayScheduleProvider = StreamProvider<List<Task>>((ref) {
  final repo = ref.watch(todayRepositoryProvider);
  return repo.watchTodaySchedule();
});

// Complete task action
final completeTaskProvider = Provider<CompleteTaskUseCase>((ref) {
  final repo = ref.watch(todayRepositoryProvider);
  return CompleteTaskUseCase(repo);
});

// UI in widget
class TodayPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mustWinsAsync = ref.watch(mustWinTasksProvider);
    
    return mustWinsAsync.when(
      data: (tasks) => MustWinsList(tasks: tasks),
      loading: () => ShimmerLoading(),
      error: (err, stack) => ErrorView(error: err),
    );
  }
}
```

---

## 🚀 BUILD PHASES (PRACTICAL)

### **Phase 0: Foundation (Day 1-2, ~8 hours)**

**Goal**: Set up project scaffold + database + basic navigation

**Tasks**:
1. ✅ Create Flutter project: `flutter create lifeline_os --platforms=windows,web`
2. ✅ Add dependencies to `pubspec.yaml`
3. ✅ Configure Drift database (tables, migrations)
4. ✅ Setup Riverpod providers
5. ✅ Create app theme (dark + orange/teal)
6. ✅ Setup go_router (navigation)
7. ✅ Create AppShell (sidebar navigation)
8. ✅ Seed default categories

**Acceptance**:
- App launches on Windows
- Navigation works (Today, Tasks, Goals, etc.)
- Database creates `lifeline.db` with encryption
- Dark theme applied, orange/teal accents visible

---

### **Phase 1: Today Page (Day 3-4, ~10 hours)**

**Goal**: MVP daily planning experience

**Tasks**:
1. ✅ Must-Wins section (top 3 tasks)
2. ✅ Quick Add form (task creation)
3. ✅ Today's schedule (timeline view)
4. ✅ Task completion (tap to complete)
5. ✅ Points calculation (roll-up logic)
6. ✅ Basic animations (celebration on complete)

**Acceptance**:
- Can add tasks
- Can complete tasks (points awarded)
- Must-Wins auto-populate from priority
- Schedule shows today's tasks in time order

---

### **Phase 2: Tasks Page (Day 5-6, ~10 hours)**

**Goal**: Full task management

**Tasks**:
1. ✅ List view (default)
2. ✅ Task modal (create/edit)
3. ✅ Subtask management
4. ✅ Filtering (category, status, energy)
5. ✅ Search
6. ✅ Task breakdown modal (AI later, manual first)

**Acceptance**:
- Can view all tasks
- Can create/edit/delete tasks
- Can add subtasks
- Filtering works
- Search works

---

### **Phase 3: Goals & Milestones (Day 7-9, ~12 hours)**

**Goal**: MGTST hierarchy

**Tasks**:
1. ✅ Goals page (tree view)
2. ✅ Goal modal (create/edit)
3. ✅ Milestones page (card grid)
4. ✅ Milestone modal
5. ✅ Progress tracking (roll-ups)
6. ✅ Goal-task linking

**Acceptance**:
- Can create milestones
- Can create goals under milestones
- Can link tasks to goals
- Points roll up correctly
- Progress bars reflect completion

---

### **Phase 4: AI Integration (Day 10-11, ~8 hours)**

**Goal**: Ollama + Expert System

**Tasks**:
1. ✅ Ollama service setup
2. ✅ Expert definitions (8 personas)
3. ✅ Reflections page (chat UI)
4. ✅ Context injection (tasks/goals)
5. ✅ Streaming responses
6. ✅ Error handling (Ollama not running)

**Acceptance**:
- Can chat with experts
- Responses stream in real-time
- Context includes current tasks/goals
- Graceful error if Ollama offline

---

### **Phase 5: Project Planner (Day 12-13, ~10 hours)**

**Goal**: AI-powered project planning

**Tasks**:
1. ✅ Planner doc creation
2. ✅ AI generation (breakdown prompt)
3. ✅ Field editor (Expand/Replace/Refine/Query)
4. ✅ Export to Markdown
5. ✅ Feature Cards → Tasks bridge

**Acceptance**:
- Can create project plan via AI
- Can edit sections with AI
- Can export to MD
- Can convert feature cards to tasks

---

### **Phase 6: Settings & Polish (Day 14-15, ~10 hours)**

**Goal**: Settings, backups, final polish

**Tasks**:
1. ✅ Settings page (categories, AI config)
2. ✅ Backup/restore (JSON export/import)
3. ✅ Theme customization (optional)
4. ✅ Keyboard shortcuts
5. ✅ Onboarding flow
6. ✅ Error boundaries
7. ✅ Performance optimization

**Acceptance**:
- Can export/import data
- Can customize categories
- Shortcuts work (Ctrl+T, etc.)
- No crashes, smooth animations

---

### **Total Estimate: 68 hours (~9 days at 8 hours/day)**

With buffer for debugging: **10-12 days**

---

## 🔒 SECURITY CONSIDERATIONS

### **Data Encryption**
- ✅ SQLCipher for database
- ✅ Encryption key in Windows Credential Manager (`flutter_secure_storage`)
- ✅ No plaintext storage

### **AI Privacy**
- ✅ Ollama runs locally (no data sent to cloud)
- ✅ Context sanitization (no PII in prompts if user configures)
- ✅ Opt-in for cloud AI (web version)

### **Input Validation**
- ✅ Drift schema constraints (min/max lengths)
- ✅ Form validators (email, URLs, etc.)
- ✅ SQL injection prevented (Drift uses prepared statements)

---

## 📊 PERFORMANCE BUDGETS

| Metric | Target | How to Achieve |
|--------|--------|----------------|
| **Cold Start** | <2s | Lazy-load database, split bundles |
| **UI Render** | 60 FPS | Avoid rebuilds, use `const`, RepaintBoundary |
| **Database Query** | <50ms | Indices on foreign keys, EXPLAIN QUERY PLAN |
| **AI Response (first token)** | <1s | Local Ollama (no network) |
| **App Size** | <50 MB | AOT compile, tree-shake unused code |

---

## 🧪 TESTING STRATEGY

```dart
// Unit Tests (pure logic)
test_tasks_repository_test.dart
test_points_calculator_test.dart

// Widget Tests (UI components)
task_card_test.dart
must_wins_section_test.dart

// Integration Tests (full flows)
complete_task_flow_test.dart
create_goal_flow_test.dart

// Target: 80% coverage for domain layer
```

---

## 📦 DEPLOYMENT

### **Windows Desktop**
```bash
flutter build windows --release
# Output: build/windows/runner/Release/lifeline_os.exe
# Package with Inno Setup or MSIX
```

### **Web (Future)**
```bash
flutter build web --release --web-renderer canvaskit
# Output: build/web/
# Deploy to Vercel/Netlify
# Note: Use IndexedDB (not SQLCipher), remote AI
```

---

## 🎓 MIGRATION INSIGHTS (FROM OLD CODEBASE)

### **What Worked (Keep)**
1. ✅ **MGTST Hierarchy**: Milestone → Goal → Task → Subtask is solid
2. ✅ **Expert System**: 8 AI personas are well-designed, keep definitions verbatim
3. ✅ **Atomic Tasks**: 5-30min constraint works, enforce in UI
4. ✅ **Points & Streaks**: Gamification increases engagement
5. ✅ **Task Breakdown Modal**: Smart defaults by category (School, Apps, DSA)
6. ✅ **Normalization Logic**: Auto-fill energy from time estimate

### **What Failed (Avoid)**
1. ❌ **Multiple AI Services**: Old app had conflicting implementations → Use single OllamaService
2. ❌ **Legacy Fields**: Task model had optional spam (estimatedDuration vs estimateMin) → Clean schema
3. ❌ **Duplicate Components**: Old + atomic versions → Single source of truth
4. ❌ **Complex State**: Too many actions in store → Slim Riverpod providers
5. ❌ **localStorage**: Not scalable → Use SQLite from Day 1
6. ❌ **Vibe Coding**: No structure → Use Planner/Executor (from `.cursorrules`)

### **Patterns to Port**
```
✅ Task Card Design (migration-reference/04-AtomicTasksPage.tsx:72-223)
   - Completion checkbox, energy badge, time estimate
   - Goal links, definition of done
   - Action buttons (Breakdown, Log)

✅ Goal Progress Visualization (migration-reference/05-AtomicGoalsPage.tsx:126-141)
   - Progress bar with animation
   - Points earned display
   - Milestone tracker

✅ Must-Wins Section (migration-reference/06-PracticalTodayPage.tsx:20-101)
   - Top 3 priority tasks
   - Reasoning display
   - Action suggestions

✅ Expert Personality Switching (migration-reference/07-ReflectionsPage.tsx:389-393)
   - Compact selector
   - Icon + name display

✅ Task Breakdown Defaults (migration-reference/08-TaskBreakdownModal.tsx:21-47)
   - School: Read → Quizzes → Practice → Review → Exam
   - Apps: Setup → Core → Testing → Polish
   - Generic: Step 1-3

✅ Milestone Tracker (migration-reference/11-MilestoneTracker.tsx:22-208)
   - Compact/full modes
   - Interactive toggle
   - Progress bar with points breakdown
```

---

## 🎨 UI MOCKUP PRIORITIES (ADHD-Optimized)

### **Today Page (Most Important)**
```
┌─────────────────────────────────────────────┐
│ 📅 Today - Monday, October 6                │
│ ───────────────────────────────────────────  │
│ 🎯 MUST WINS (3)                            │
│ ☐ D426 → Complete Module 3 Quiz    [15pts] │
│ ☐ void App → Fix auth bug           [20pts] │
│ ☐ DSA → Solve 2 Medium problems     [30pts] │
│                                              │
│ 🗓️ TODAY'S SCHEDULE                         │
│ ┌──────────────────────────────────────┐    │
│ │ 9:00 AM  [████░░░░░░] 45 min        │    │
│ │ 10:00 AM  [Free Block]              │    │
│ │ 11:00 AM  [██████░░░░] 60 min       │    │
│ └──────────────────────────────────────┘    │
│                                              │
│ ➕ Quick Add Task                           │
└─────────────────────────────────────────────┘
```

### **Key UI Elements**
- **Large touch targets** (min 48x48dp) - ADHD motor control
- **High contrast** (WCAG AAA) - Reduce eye strain
- **Animations** - Dopamine hits on completion
- **Progress indicators** - Visualize momentum
- **Empty states** - Encouraging, not blank

---

## ✅ GO/NO-GO CHECKLIST (Before Phase 0)

- ✅ Flutter installed (`flutter doctor`)
- ✅ Windows development enabled
- ✅ Ollama installed + running (`ollama list`)
- ✅ Migration reference reviewed (patterns understood)
- ✅ BUILD_RULES.md reviewed (anti-slop protocols)
- ✅ All V2 feature docs read (00-07)
- ✅ User confirms tech stack (Flutter + Dart)
- ✅ User confirms UI priorities (dark + orange/teal)

---

## 🚦 FINAL DECISION

**PROCEED WITH FLUTTER** ✅

**Rationale:**
1. ✅ Meets all functional requirements (MGTST, AI, ADHD UX)
2. ✅ Single codebase (Desktop + Web + Mobile future)
3. ✅ Strong local-first support (Drift + SQLCipher)
4. ✅ Beautiful, customizable UI (critical for ADHD engagement)
5. ✅ Ollama works (HTTP is sufficient, no need for native bindings)
6. ✅ Riverpod state management is clean and testable
7. ✅ Migration path exists (all patterns can be ported)

**Trade-offs Accepted:**
- ⚠️ Dart instead of TypeScript (but similar syntax, quick to learn)
- ⚠️ Web version has limitations (IndexedDB, no SQLCipher, remote AI)
- ⚠️ All existing docs need Dart syntax updates (minor)

**Next Steps:**
1. User says "YES" to confirm Flutter
2. Run `flutter doctor` to verify setup
3. Start ollama (`ollama serve`)
4. Begin Phase 0 (Project Scaffold)

---

**Ready to build?** 🚀

