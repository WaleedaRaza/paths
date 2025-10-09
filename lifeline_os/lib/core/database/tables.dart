import 'package:drift/drift.dart';

// Domain enum for categorizing milestones/goals/tasks
enum Domain {
  school,
  projects,
  finance,
  health,
  dsa,      // LeetCode/Interview prep
  career,   // Professional development
  gre,      // Test preparation
  personal,
}

// Categories Table
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get color => text().withLength(min: 7, max: 9)(); // Hex color
  TextColumn get icon => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Milestones Table
class Milestones extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get categoryId => text().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  IntColumn get domain => intEnum<Domain>().withDefault(const Constant(5))(); // Default to personal
  TextColumn get metadata => text().nullable()(); // JSON string for domain-specific data
  DateTimeColumn get deadline => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get totalPoints => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Goals Table
class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get milestoneId => text().nullable().references(Milestones, #id, onDelete: KeyAction.cascade)();
  TextColumn get parentGoalId => text().nullable().references(Goals, #id, onDelete: KeyAction.cascade)();
  TextColumn get metadata => text().nullable()(); // JSON string for domain-specific data
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get totalPoints => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Tasks Table
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get goalId => text().nullable().references(Goals, #id, onDelete: KeyAction.cascade)();
  TextColumn get categoryId => text().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  TextColumn get metadata => text().nullable()(); // JSON string for domain-specific data
  IntColumn get priority => integer().withDefault(const Constant(0))(); // 0=none, 1=low, 2=medium, 3=high
  IntColumn get energy => integer().withDefault(const Constant(0))(); // 0=none, 1=low, 2=medium, 3=high
  IntColumn get estimatedMinutes => integer().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get basePoints => integer().withDefault(const Constant(10))();
  IntColumn get totalPoints => integer().withDefault(const Constant(0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Subtasks Table
class Subtasks extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get points => integer().withDefault(const Constant(5))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Must-Wins Table (Daily 3 critical tasks)
class MustWins extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()(); // Date this Must-Win belongs to
  TextColumn get taskId => text().nullable().references(Tasks, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))(); // 0, 1, 2 (max 3 per day)
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Schedule Items Table (Time-blocked tasks)
class ScheduleItems extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get taskId => text().nullable().references(Tasks, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Logs Table (Workout, reading, etc.)
class Logs extends Table {
  TextColumn get id => text()();
  TextColumn get type => text().withLength(min: 1, max: 50)(); // 'workout', 'reading', 'meditation', etc.
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  IntColumn get durationMinutes => integer().nullable()();
  DateTimeColumn get logDate => dateTime()();
  IntColumn get points => integer().withDefault(const Constant(5))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Chat Sessions Table (Reflections page conversations)
class ChatSessions extends Table {
  TextColumn get id => text()();
  TextColumn get expertId => text().withLength(min: 1, max: 100)();
  TextColumn get title => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastMessageAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Chat Messages Table
@TableIndex(name: 'chat_messages_session', columns: {#sessionId})
class ChatMessages extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(ChatSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get expertId => text().withLength(min: 1, max: 100)();
  TextColumn get role => text().withLength(min: 1, max: 20)(); // 'user' | 'assistant'
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Journal Entries Table (Notes panel)
class JournalEntries extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text().withLength(min: 1, max: 20)(); // 'journal' | 'note' | 'idea'
  TextColumn get title => text().nullable()();
  TextColumn get content => text()();
  TextColumn get tags => text().nullable()(); // JSON array string
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Expert Prompts Table (Customizable system prompts)
class ExpertPrompts extends Table {
  TextColumn get expertId => text()();
  TextColumn get systemPrompt => text()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {expertId};
}

// Memories Table (Persistent context for LLM)
class Memories extends Table {
  TextColumn get id => text()();
  TextColumn get content => text()();
  TextColumn get source => text().withLength(min: 1, max: 50)(); // 'chat' | 'manual' | 'suggested'
  TextColumn get relatedExpertIds => text().nullable()(); // JSON array string
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// Project Plans Table (AI project documentation)
class ProjectPlans extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text()(); // Original user input paragraph
  TextColumn get status => text().withLength(min: 1, max: 20)(); // 'draft' | 'final' | 'archived'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Project Sections Table (Generated content per section)
class ProjectSections extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text().references(ProjectPlans, #id, onDelete: KeyAction.cascade)();
  TextColumn get sectionType => text().withLength(min: 1, max: 30)(); // 'info' | 'research' | 'architecture' | 'features' | 'labor'
  TextColumn get content => text()(); // Markdown content
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Generation Jobs Table (Track LLM generation progress)
class GenerationJobs extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text().references(ProjectPlans, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text().withLength(min: 1, max: 20)(); // 'pending' | 'running' | 'completed' | 'failed'
  TextColumn get currentStep => text().nullable()();
  IntColumn get progress => integer().withDefault(const Constant(0))(); // 0-100
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

