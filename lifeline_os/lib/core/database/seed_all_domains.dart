import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import 'database.dart';
import 'tables.dart';

const _uuid = Uuid();

// ============================================================================
// PROJECTS DOMAIN - App Development
// ============================================================================

/// Seeds Petform app data
Future<void> seedPetform(AppDatabase db) async {
  print('🐾 Seeding Petform data...');

  final milestoneId = _uuid.v4();
  await db.into(db.milestones).insert(
    MilestonesCompanion(
      id: drift.Value(milestoneId),
      title: const drift.Value('Ship Petform v1 (Re-submission)'),
      description: const drift.Value('Fix critical issues and resubmit to App Store'),
      domain: const drift.Value(Domain.projects),
      metadata: drift.Value(jsonEncode({
        'app': 'petform',
        'version': '1.0.0',
        'platform': 'Flutter',
        'releaseCriteria': [
          {'criterion': 'Security audit', 'done': false},
          {'criterion': 'Privacy strings complete', 'done': false},
          {'criterion': 'Crash rate <1%', 'done': false},
          {'criterion': 'App Store guidelines met', 'done': false},
        ],
      })),
      deadline: drift.Value(DateTime.now().add(const Duration(days: 14))),
      isCompleted: const drift.Value(false),
      totalPoints: const drift.Value(600),
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    ),
  );

  // Goal 1: Account Integrity & Auth Fixes
  final authGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Account Integrity & Auth Fixes',
    description: 'Fix duplicate email issue and ensure one user per email',
    domain: Domain.projects,
    metadata: {
      'pillar': 'auth',
      'kpis': [
        {'metric': 'Duplicate emails', 'target': 0, 'current': 5},
        {'metric': 'Auth success rate', 'target': 99.9, 'current': 94.0},
      ],
      'scope': ['Email deduplication', 'userId mapping', 'Admin merge tool'],
      'nonGoals': ['Social auth', 'MFA'],
    },
    points: 200,
  );

  await _createTask(
    db,
    goalId: authGoalId,
    title: 'Fix duplicate email → single user linkage',
    description: 'Ensure one user per email; new login maps to existing profile',
    priority: 3,
    energy: 2,
    estimatedMinutes: 90,
    metadata: {
      'app': 'petform',
      'pillar': 'auth',
      'risk': 'high',
      'dod': [
        'One user per email enforced',
        'New login maps to existing profile',
        'Migration script reports merges',
      ],
      'evidence': [],
      'rollback': 'git revert <sha>',
      'recipe': [
        {'step': 'Read/trace current auth flow', 'duration': 15, 'done': false},
        {'step': 'Implement email uniqueness check', 'duration': 25, 'done': false},
        {'step': 'Build migration script', 'duration': 35, 'done': false},
        {'step': 'Test & capture evidence', 'duration': 15, 'done': false},
      ],
      'fileCount': 4,
      'locChanged': 150,
    },
    points: 80,
  );

  await _createTask(
    db,
    goalId: authGoalId,
    title: 'Create deterministic userId mapping',
    description: 'Map table ensures one canonical userId; writes blocked if mismatch',
    priority: 2,
    energy: 2,
    estimatedMinutes: 75,
    metadata: {
      'app': 'petform',
      'pillar': 'auth',
      'risk': 'med',
      'dod': [
        'Map table created and seeded',
        'Write operations validate against map',
        'Error handling for mismatches',
      ],
      'recipe': [
        {'step': 'Design map table schema', 'duration': 10, 'done': false},
        {'step': 'Implement validation layer', 'duration': 30, 'done': false},
        {'step': 'Add error handling', 'duration': 20, 'done': false},
        {'step': 'Test edge cases', 'duration': 15, 'done': false},
      ],
    },
    points: 60,
  );

  await _createTask(
    db,
    goalId: authGoalId,
    title: 'Build "Email merge" admin tool',
    description: 'CLI or screen to merge duplicate users by email with audit log',
    priority: 1,
    energy: 1,
    estimatedMinutes: 60,
    metadata: {
      'app': 'petform',
      'pillar': 'auth',
      'risk': 'low',
      'dod': [
        'Admin UI/CLI functional',
        'Merge operation with confirmation',
        'Audit log of all merges',
      ],
    },
    points: 60,
  );

  // Goal 2: App Store Compliance
  final complianceGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'App Store Compliance & Resubmission',
    description: 'Complete privacy strings, entitlements, and submission package',
    domain: Domain.projects,
    metadata: {
      'pillar': 'infra',
      'kpis': [
        {'metric': 'Privacy strings complete', 'target': 100, 'current': 60},
        {'metric': 'Entitlements verified', 'target': 100, 'current': 80},
      ],
    },
    points: 200,
  );

  await _createTask(
    db,
    goalId: complianceGoalId,
    title: 'App Store privacy strings & entitlements audit',
    description: 'Complete Info.plist and Privacy manifest with all required entries',
    priority: 3,
    energy: 1,
    estimatedMinutes: 90,
    metadata: {
      'app': 'petform',
      'pillar': 'infra',
      'risk': 'high',
      'dod': [
        'Info.plist complete with privacy strings',
        'Privacy manifest validated',
        'Checklist attached as evidence',
      ],
    },
    points: 70,
  );

  await _createTask(
    db,
    goalId: complianceGoalId,
    title: 'Submission package prep',
    description: 'Screenshots, metadata, version bump, release notes, build ipa/aab',
    priority: 2,
    energy: 1,
    estimatedMinutes: 120,
    metadata: {
      'app': 'petform',
      'pillar': 'infra',
      'risk': 'low',
      'dod': [
        'Screenshots captured (all required sizes)',
        'Metadata and release notes written',
        'Version bumped to 1.0.0',
        'IPA/AAB built successfully',
      ],
    },
    points: 60,
  );

  await _createTask(
    db,
    goalId: complianceGoalId,
    title: 'Submit to App Store',
    description: 'Upload build and submit for review',
    priority: 3,
    energy: 0,
    estimatedMinutes: 30,
    metadata: {
      'app': 'petform',
      'pillar': 'infra',
      'risk': 'low',
      'dod': [
        'Build uploaded successfully',
        'Submission confirmation received',
        'Monitoring dashboard set up',
      ],
    },
    points: 70,
  );

  // Goal 3: UX Fixes
  final uxGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Crash/UX Painkillers (Top 5)',
    description: 'Fix top 5 crashes and UX issues reported by users',
    domain: Domain.projects,
    metadata: {
      'pillar': 'ui',
      'kpis': [
        {'metric': 'Crash-free sessions', 'target': 99.0, 'current': 95.2},
      ],
    },
    points: 200,
  );

  await _createTask(
    db,
    goalId: uxGoalId,
    title: 'Fix top 5 crash/UX issues',
    description: 'Prioritize and resolve the 5 most common crashes or UX complaints',
    priority: 2,
    energy: 2,
    estimatedMinutes: 180,
    metadata: {
      'app': 'petform',
      'pillar': 'ui',
      'risk': 'med',
      'dod': [
        'Each issue has before/after evidence',
        'Console diff shows errors eliminated',
        'User testing confirms resolution',
      ],
    },
    points: 200,
  );

  print('✅ Petform seeded: 1 milestone, 3 goals, 6 tasks');
}

/// Seeds MMAmania app data
Future<void> seedMMAmania(AppDatabase db) async {
  print('🥊 Seeding MMAmania data...');

  final milestoneId = _uuid.v4();
  await db.into(db.milestones).insert(
    MilestonesCompanion(
      id: drift.Value(milestoneId),
      title: const drift.Value('Ship Fight Night Beta'),
      description: const drift.Value('Live fight card with rooms, predictions, and analytics'),
      domain: const drift.Value(Domain.projects),
      metadata: drift.Value(jsonEncode({
        'app': 'mmamania',
        'version': '0.1.0-beta',
        'platform': 'Flutter + Supabase',
        'releaseCriteria': [
          {'criterion': '2 devices can join same room', 'done': false},
          {'criterion': 'Live fight card updates', 'done': false},
          {'criterion': 'ELO predictions visible', 'done': false},
        ],
      })),
      deadline: drift.Value(DateTime.now().add(const Duration(days: 21))),
      isCompleted: const drift.Value(false),
      totalPoints: const drift.Value(800),
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    ),
  );

  // Goal 1: Auth & Rooms
  final authGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Auth & Rooms',
    description: 'JWT auth with room create/join/leave and WebSocket presence',
    domain: Domain.projects,
    metadata: {
      'pillar': 'auth',
      'scope': ['JWT auth', 'Room CRUD', 'WS presence'],
      'nonGoals': ['Social auth', 'Private rooms'],
    },
    points: 200,
  );

  await _createTask(
    db,
    goalId: authGoalId,
    title: 'Supabase schema (events/fighters/fights/predictions)',
    description: 'Create SQL schema, migrate, seed 1 event',
    priority: 3,
    energy: 1,
    estimatedMinutes: 75,
    metadata: {
      'app': 'mmamania',
      'pillar': 'data',
      'risk': 'med',
      'dod': [
        'SQL file created',
        'Migration successful',
        'Seed data returns rows on SELECT',
      ],
    },
    points: 50,
  );

  await _createTask(
    db,
    goalId: authGoalId,
    title: 'Auth (JWT) + session guard',
    description: 'Protected room create/join; unauth users redirected',
    priority: 3,
    energy: 2,
    estimatedMinutes: 90,
    metadata: {
      'app': 'mmamania',
      'pillar': 'auth',
      'risk': 'high',
      'dod': [
        'JWT issued on login',
        'Protected routes require valid token',
        'Unauth users redirected to login',
      ],
    },
    points: 75,
  );

  await _createTask(
    db,
    goalId: authGoalId,
    title: 'Rooms: create/join/leave + presence (WS)',
    description: 'Two devices join same room; presence shows count',
    priority: 2,
    energy: 2,
    estimatedMinutes: 120,
    metadata: {
      'app': 'mmamania',
      'pillar': 'rooms',
      'risk': 'high',
      'dod': [
        'Two devices join same room',
        'Presence count updates in real-time',
        'Leave operation cleans up presence',
      ],
    },
    points: 75,
  );

  // Goal 2: Data Aggregation
  final dataGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Live Data Aggregation & Persistence',
    description: 'Scrape fight data, persist to DB, serve via API',
    domain: Domain.projects,
    metadata: {'pillar': 'data'},
    points: 200,
  );

  await _createTask(
    db,
    goalId: dataGoalId,
    title: 'Scrape fight card data',
    description: 'Scraper for upcoming UFC events and fighter records',
    priority: 2,
    energy: 2,
    estimatedMinutes: 90,
    metadata: {
      'app': 'mmamania',
      'pillar': 'data',
      'risk': 'med',
      'dod': [
        'Scraper fetches next 3 events',
        'Fighter records populated',
        'Data validated against schema',
      ],
    },
    points: 100,
  );

  await _createTask(
    db,
    goalId: dataGoalId,
    title: 'REST API for fight data',
    description: 'GET /events, /fights/:id endpoints',
    priority: 2,
    energy: 1,
    estimatedMinutes: 60,
    metadata: {
      'app': 'mmamania',
      'pillar': 'data',
      'risk': 'low',
      'dod': [
        'Endpoints return JSON',
        'Pagination supported',
        'Error handling for missing data',
      ],
    },
    points: 100,
  );

  // Goal 3: Analytics
  final analyticsGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Analytics v0 (ELO + Crowd)',
    description: 'Compute ELO ratings and combine with crowd predictions',
    domain: Domain.projects,
    metadata: {'pillar': 'analytics'},
    points: 200,
  );

  await _createTask(
    db,
    goalId: analyticsGoalId,
    title: 'ELO compute job (batch)',
    description: 'Script computes ELO for seeded fights; table populated',
    priority: 2,
    energy: 2,
    estimatedMinutes: 90,
    metadata: {
      'app': 'mmamania',
      'pillar': 'analytics',
      'risk': 'med',
      'dod': [
        'ELO algorithm implemented',
        'Batch job runs successfully',
        'ELO table populated for all fighters',
      ],
    },
    points: 100,
  );

  await _createTask(
    db,
    goalId: analyticsGoalId,
    title: 'Crowd odds stub',
    description: 'Combine ELO & manual crowd value to predictions.score',
    priority: 1,
    energy: 1,
    estimatedMinutes: 45,
    metadata: {
      'app': 'mmamania',
      'pillar': 'analytics',
      'risk': 'low',
      'dod': [
        'Formula: (ELO * 0.7) + (crowd * 0.3)',
        'Predictions table updated',
        'UI shows combined odds',
      ],
    },
    points: 100,
  );

  // Goal 4: Flutter UI
  final uiGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Flutter UI Wiring',
    description: 'Connect Flutter app to Supabase and WebSocket for live updates',
    domain: Domain.projects,
    metadata: {'pillar': 'ui'},
    points: 200,
  );

  await _createTask(
    db,
    goalId: uiGoalId,
    title: 'Flutter Fight Card page (connects to Supabase/WS)',
    description: 'Fight list displays, auto-updates on score change',
    priority: 2,
    energy: 2,
    estimatedMinutes: 120,
    metadata: {
      'app': 'mmamania',
      'pillar': 'ui',
      'risk': 'med',
      'dod': [
        'Fight card renders',
        'WS connection updates scores live',
        'No console errors on reconnect',
      ],
    },
    points: 200,
  );

  print('✅ MMAmania seeded: 1 milestone, 4 goals, 8 tasks');
}

/// Seeds Pokeher app data
Future<void> seedPokeher(AppDatabase db) async {
  print('♠️ Seeding Pokeher data...');

  final milestoneId = _uuid.v4();
  await db.into(db.milestones).insert(
    MilestonesCompanion(
      id: drift.Value(milestoneId),
      title: const drift.Value('Ship Multiplayer Demo'),
      description: const drift.Value('Poker engine with provably-fair shuffle roadmap'),
      domain: const drift.Value(Domain.projects),
      metadata: drift.Value(jsonEncode({
        'app': 'pokeher',
        'version': '0.1.0',
        'platform': 'Next.js + Node',
        'releaseCriteria': [
          {'criterion': 'Two players can join and play', 'done': false},
          {'criterion': 'Shuffle verification endpoint live', 'done': false},
        ],
      })),
      deadline: drift.Value(DateTime.now().add(const Duration(days: 18))),
      isCompleted: const drift.Value(false),
      totalPoints: const drift.Value(500),
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    ),
  );

  // Goal 1: Auth & Rooms
  final authGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Auth & Rooms',
    description: 'JWT auth with room create/join/leave',
    domain: Domain.projects,
    metadata: {'pillar': 'auth'},
    points: 125,
  );

  await _createTask(
    db,
    goalId: authGoalId,
    title: 'DB schema: users/rooms/room_memberships/player_state',
    description: 'SQL done, seed room; state saved after action',
    priority: 3,
    energy: 1,
    estimatedMinutes: 60,
    metadata: {
      'app': 'pokeher',
      'pillar': 'data',
      'dod': ['Schema created', 'Seed data inserted', 'State persists'],
    },
    points: 50,
  );

  await _createTask(
    db,
    goalId: authGoalId,
    title: 'REST: POST /rooms, /rooms/:id/join, /leave',
    description: 'Curl shows 200; room row exists; join adds membership row',
    priority: 2,
    energy: 1,
    estimatedMinutes: 60,
    metadata: {
      'app': 'pokeher',
      'pillar': 'rooms',
      'dod': ['Endpoints functional', 'Membership table updated', 'Error handling'],
    },
    points: 75,
  );

  // Goal 2: State Persistence
  final stateGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'State Persistence',
    description: 'Room and player state saved and broadcast',
    domain: Domain.projects,
    metadata: {'pillar': 'data'},
    points: 125,
  );

  await _createTask(
    db,
    goalId: stateGoalId,
    title: 'WS: broadcast STATE_UPDATE on actions',
    description: 'Two browsers see the same deal/bet state',
    priority: 3,
    energy: 2,
    estimatedMinutes: 90,
    metadata: {
      'app': 'pokeher',
      'pillar': 'rooms',
      'risk': 'high',
      'dod': ['WS connection stable', 'State syncs across clients', 'No race conditions'],
    },
    points: 125,
  );

  // Goal 3: Shuffle
  final shuffleGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Shuffle v0 + Verification',
    description: 'Shuffle spec doc and stub verification endpoint',
    domain: Domain.projects,
    metadata: {'pillar': 'shuffle'},
    points: 125,
  );

  await _createTask(
    db,
    goalId: shuffleGoalId,
    title: 'Shuffle spec doc (+ stub)',
    description: '/docs/shuffle-spec.md; /shuffle/verify returns stub OK with hash',
    priority: 1,
    energy: 1,
    estimatedMinutes: 60,
    metadata: {
      'app': 'pokeher',
      'pillar': 'shuffle',
      'dod': ['Spec doc complete', 'Endpoint returns 200', 'Hash format defined'],
    },
    points: 125,
  );

  // Goal 4: Next.js UI
  final uiGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Next.js Table UI',
    description: 'Poker table page with Zustand store and WS subscription',
    domain: Domain.projects,
    metadata: {'pillar': 'ui'},
    points: 125,
  );

  await _createTask(
    db,
    goalId: uiGoalId,
    title: 'Next.js page /table/[roomId] + Zustand store',
    description: 'Renders table & players; subscribes to WS',
    priority: 2,
    energy: 2,
    estimatedMinutes: 90,
    metadata: {
      'app': 'pokeher',
      'pillar': 'ui',
      'dod': ['Table renders', 'Players visible', 'WS updates UI'],
    },
    points: 125,
  );

  print('✅ Pokeher seeded: 1 milestone, 4 goals, 5 tasks');
}

/// Seeds StockSurveyor app data
Future<void> seedStockSurveyor(AppDatabase db) async {
  print('📈 Seeding StockSurveyor data...');

  final milestoneId = _uuid.v4();
  await db.into(db.milestones).insert(
    MilestonesCompanion(
      id: drift.Value(milestoneId),
      title: const drift.Value('Ship Watchlist Signals v0'),
      description: const drift.Value('Lock scope, read-only data pipe, signals compute'),
      domain: const drift.Value(Domain.projects),
      metadata: drift.Value(jsonEncode({
        'app': 'stocksurveyor',
        'version': '0.1.0',
        'platform': 'Python + React',
      })),
      deadline: drift.Value(DateTime.now().add(const Duration(days: 14))),
      isCompleted: const drift.Value(false),
      totalPoints: const drift.Value(500),
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    ),
  );

  // Goal 1: Scope Lock
  final scopeGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Scope Lock',
    description: 'Define what is and isn\'t in v1',
    domain: Domain.projects,
    metadata: {'pillar': 'planning'},
    points: 100,
  );

  await _createTask(
    db,
    goalId: scopeGoalId,
    title: 'Scope lock 1-pager',
    description: '/docs/scope-v1.md with explicit non-goals',
    priority: 2,
    energy: 0,
    estimatedMinutes: 45,
    metadata: {
      'app': 'stocksurveyor',
      'pillar': 'planning',
      'dod': ['Scope doc created', 'Non-goals listed', 'Team reviewed'],
    },
    points: 100,
  );

  // Goal 2: Data Pipe
  final dataGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Read-Only Data Pipe',
    description: 'Fetch OHLCV data from free API and cache',
    domain: Domain.projects,
    metadata: {'pillar': 'data'},
    points: 150,
  );

  await _createTask(
    db,
    goalId: dataGoalId,
    title: 'Adapter: fetch OHLCV for 5 tickers + cache',
    description: 'SQLite table filled; error handling',
    priority: 3,
    energy: 2,
    estimatedMinutes: 90,
    metadata: {
      'app': 'stocksurveyor',
      'pillar': 'data',
      'risk': 'med',
      'dod': ['API adapter functional', 'Cache in SQLite', 'Error handling for rate limits'],
    },
    points: 150,
  );

  // Goal 3: Signals
  final signalsGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Signals v0',
    description: 'Compute RSI, MACD, MA signals',
    domain: Domain.projects,
    metadata: {'pillar': 'analytics'},
    points: 150,
  );

  await _createTask(
    db,
    goalId: signalsGoalId,
    title: 'Signals compute job',
    description: 'RSI/MACD/MA columns appended',
    priority: 2,
    energy: 2,
    estimatedMinutes: 75,
    metadata: {
      'app': 'stocksurveyor',
      'pillar': 'analytics',
      'dod': ['RSI calculated', 'MACD calculated', 'MA calculated', 'Columns in DB'],
    },
    points: 150,
  );

  // Goal 4: UI
  final uiGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Watchlist UI',
    description: 'Add/remove symbols, view signals',
    domain: Domain.projects,
    metadata: {'pillar': 'ui'},
    points: 100,
  );

  await _createTask(
    db,
    goalId: uiGoalId,
    title: 'Watchlist page + add symbol modal',
    description: 'Add/remove; see signals',
    priority: 2,
    energy: 1,
    estimatedMinutes: 60,
    metadata: {
      'app': 'stocksurveyor',
      'pillar': 'ui',
      'dod': ['Page renders', 'Add/remove functional', 'Signals display'],
    },
    points: 50,
  );

  await _createTask(
    db,
    goalId: uiGoalId,
    title: 'Weekly insight md export',
    description: 'insight-YYYY-WW.md created with top 3 notes',
    priority: 1,
    energy: 0,
    estimatedMinutes: 30,
    metadata: {
      'app': 'stocksurveyor',
      'pillar': 'analytics',
      'dod': ['Export script runs', 'Markdown file created', 'Top 3 insights included'],
    },
    points: 50,
  );

  print('✅ StockSurveyor seeded: 1 milestone, 4 goals, 5 tasks');
}

/// Seeds Music app data
Future<void> seedMusicApp(AppDatabase db) async {
  print('🎵 Seeding Music App data...');

  final milestoneId = _uuid.v4();
  await db.into(db.milestones).insert(
    MilestonesCompanion(
      id: drift.Value(milestoneId),
      title: const drift.Value('Validated Concept'),
      description: const drift.Value('Last.fm-style app - concept validation and planning'),
      domain: const drift.Value(Domain.projects),
      metadata: drift.Value(jsonEncode({
        'app': 'music',
        'version': '0.0.1',
        'platform': 'TBD',
      })),
      deadline: drift.Value(DateTime.now().add(const Duration(days: 7))),
      isCompleted: const drift.Value(false),
      totalPoints: const drift.Value(300),
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    ),
  );

  // Goal 1: Core Idea
  final ideaGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Core Idea → Planner Doc',
    description: 'Generate first-pass planning document',
    domain: Domain.projects,
    metadata: {'pillar': 'planning'},
    points: 100,
  );

  await _createTask(
    db,
    goalId: ideaGoalId,
    title: 'Planner: generate first-pass doc',
    description: 'Markdown + JSON capsule exported',
    priority: 2,
    energy: 0,
    estimatedMinutes: 60,
    metadata: {
      'app': 'music',
      'pillar': 'planning',
      'dod': ['Planning doc created', 'JSON exported', 'Core features defined'],
    },
    points: 100,
  );

  // Goal 2: Data Options
  final dataGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Data Options Scan',
    description: 'Research Spotify/Apple/Local scrobble options',
    domain: Domain.projects,
    metadata: {'pillar': 'data'},
    points: 100,
  );

  await _createTask(
    db,
    goalId: dataGoalId,
    title: 'Data feasibility 1-pager',
    description: 'List SDKs/limits; choose one path',
    priority: 2,
    energy: 1,
    estimatedMinutes: 45,
    metadata: {
      'app': 'music',
      'pillar': 'data',
      'dod': ['SDK options listed', 'Rate limits documented', 'Recommendation made'],
    },
    points: 100,
  );

  // Goal 3: Wireframes
  final wireframeGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'MVP Screen Sketch',
    description: 'Wireframe Now Playing + Insights screens',
    domain: Domain.projects,
    metadata: {'pillar': 'ui'},
    points: 100,
  );

  await _createTask(
    db,
    goalId: wireframeGoalId,
    title: 'Wireframe Now Playing + Insights',
    description: '2 screens, static data',
    priority: 1,
    energy: 1,
    estimatedMinutes: 60,
    metadata: {
      'app': 'music',
      'pillar': 'ui',
      'dod': ['2 wireframes complete', 'Static data mocked', 'Flow validated'],
    },
    points: 100,
  );

  print('✅ Music App seeded: 1 milestone, 3 goals, 3 tasks');
}

// ============================================================================
// HEALTH/FITNESS DOMAIN
// ============================================================================

/// Seeds Fitness data (8-week cycle)
Future<void> seedFitness(AppDatabase db) async {
  print('💪 Seeding Fitness data...');

  final milestoneId = _uuid.v4();
  await db.into(db.milestones).insert(
    MilestonesCompanion(
      id: drift.Value(milestoneId),
      title: const drift.Value('8-Week Cycle Adherence'),
      description: const drift.Value('Complete 4 weekly workout rotations for 8 weeks'),
      domain: const drift.Value(Domain.health),
      metadata: drift.Value(jsonEncode({
        'cycleWeeks': 8,
        'targetSessions': 32,
        'split': ['Upper/Back/Shoulders', 'Chest/Tris', 'Bis/Lats', 'Wildcard/Rest'],
      })),
      deadline: drift.Value(DateTime.now().add(const Duration(days: 56))),
      isCompleted: const drift.Value(false),
      totalPoints: const drift.Value(800),
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    ),
  );

  // Goal 1: UBS Sessions
  final ubsGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Upper/Back/Shoulders',
    description: '8 sessions over 8 weeks with RPE logging',
    domain: Domain.health,
    metadata: {
      'workoutType': 'UBS',
      'kpis': [
        {'metric': 'Sessions completed', 'target': 8, 'current': 0},
        {'metric': 'Avg RPE', 'target': 7.5, 'current': 0},
      ],
    },
    points: 200,
  );

  await _createTask(
    db,
    goalId: ubsGoalId,
    title: 'UBS Session (RPE log + volume)',
    description: 'Complete Upper/Back/Shoulders workout with proper form',
    priority: 2,
    energy: 2,
    estimatedMinutes: 60,
    metadata: {
      'context': 'fitness',
      'pillar': 'strength',
      'dod': [
        'Warm-up completed (10m)',
        'Main work logged (35m)',
        'Cooldown and log entry (10m)',
      ],
      'evidence': [
        {'type': 'log', 'desc': 'Photo of log or entry in app'},
      ],
    },
    points: 25,
  );

  // Goal 2: CT Sessions
  final ctGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Chest/Tris',
    description: '8 sessions over 8 weeks with RPE logging',
    domain: Domain.health,
    metadata: {
      'workoutType': 'CT',
      'kpis': [
        {'metric': 'Sessions completed', 'target': 8, 'current': 0},
      ],
    },
    points: 200,
  );

  await _createTask(
    db,
    goalId: ctGoalId,
    title: 'CT Session (RPE log + volume)',
    description: 'Complete Chest/Tris workout with proper form',
    priority: 2,
    energy: 2,
    estimatedMinutes: 60,
    metadata: {
      'context': 'fitness',
      'pillar': 'strength',
      'dod': [
        'Warm-up completed',
        'Main work logged',
        'Cooldown and log entry',
      ],
    },
    points: 25,
  );

  // Goal 3: BL Sessions
  final blGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Bis/Lats',
    description: '8 sessions over 8 weeks with RPE logging',
    domain: Domain.health,
    metadata: {
      'workoutType': 'BL',
      'kpis': [
        {'metric': 'Sessions completed', 'target': 8, 'current': 0},
      ],
    },
    points: 200,
  );

  await _createTask(
    db,
    goalId: blGoalId,
    title: 'BL Session (RPE log + volume)',
    description: 'Complete Bis/Lats workout with proper form',
    priority: 2,
    energy: 2,
    estimatedMinutes: 60,
    metadata: {
      'context': 'fitness',
      'pillar': 'strength',
      'dod': [
        'Warm-up completed',
        'Main work logged',
        'Cooldown and log entry',
      ],
    },
    points: 25,
  );

  // Goal 4: Recovery
  final recoveryGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Wildcard/Rest',
    description: 'Active recovery or rest days',
    domain: Domain.health,
    metadata: {
      'workoutType': 'Recovery',
      'kpis': [
        {'metric': 'Recovery sessions', 'target': 8, 'current': 0},
      ],
    },
    points: 200,
  );

  await _createTask(
    db,
    goalId: recoveryGoalId,
    title: 'Wildcard recovery/mobility',
    description: 'Light mobility work or complete rest',
    priority: 1,
    energy: 0,
    estimatedMinutes: 30,
    metadata: {
      'context': 'fitness',
      'pillar': 'recovery',
      'dod': [
        'Mobility routine or rest taken',
        'Log entry created',
      ],
    },
    points: 25,
  );

  print('✅ Fitness seeded: 1 milestone, 4 goals, 4 recurring tasks');
}

// ============================================================================
// FINANCE DOMAIN
// ============================================================================

/// Seeds Finance data
Future<void> seedFinance(AppDatabase db) async {
  print('💰 Seeding Finance data...');

  final milestoneId = _uuid.v4();
  await db.into(db.milestones).insert(
    MilestonesCompanion(
      id: drift.Value(milestoneId),
      title: const drift.Value('Account to \$10k Responsibly'),
      description: const drift.Value('Grow trading account from \$2.5k to \$10k with disciplined execution'),
      domain: const drift.Value(Domain.finance),
      metadata: drift.Value(jsonEncode({
        'startBalance': 2500,
        'targetBalance': 10000,
        'maxDrawdown': 0.15,
        'riskPerTrade': 0.02,
      })),
      deadline: drift.Value(DateTime.now().add(const Duration(days: 180))),
      isCompleted: const drift.Value(false),
      totalPoints: const drift.Value(750),
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    ),
  );

  // Goal 1: Research Cadence
  final researchGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Research Cadence',
    description: 'Systematic research process for trade ideas',
    domain: Domain.finance,
    metadata: {
      'kpis': [
        {'metric': 'Weekly deep-dives', 'target': 2, 'current': 0},
        {'metric': 'Research docs created', 'target': 24, 'current': 0},
      ],
    },
    points: 250,
  );

  await _createTask(
    db,
    goalId: researchGoalId,
    title: 'Deep-dive template + 2 tickers/week',
    description: 'Research 2 tickers per week using standardized template',
    priority: 2,
    energy: 2,
    estimatedMinutes: 90,
    metadata: {
      'context': 'finance',
      'pillar': 'research',
      'dod': [
        'Template applied to 2 tickers',
        'research-YYYY-WW.md created',
        'Trade thesis documented',
      ],
    },
    points: 83,
  );

  // Goal 2: Execution Rules
  final executionGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Execution Rules',
    description: 'Define and follow position sizing and risk management rules',
    domain: Domain.finance,
    metadata: {
      'kpis': [
        {'metric': 'Rule adherence rate', 'target': 95, 'current': 0},
      ],
    },
    points: 250,
  );

  await _createTask(
    db,
    goalId: executionGoalId,
    title: 'Execution card (position sizing, max loss, earnings holds)',
    description: 'Create and follow execution rules card',
    priority: 3,
    energy: 1,
    estimatedMinutes: 60,
    metadata: {
      'context': 'finance',
      'pillar': 'execution',
      'risk': 'high',
      'dod': [
        'Rules card created',
        'Position sizing formula defined',
        'Max loss per trade set',
        'Earnings hold policy documented',
      ],
      'evidence': [
        {'type': 'log', 'desc': 'All trades conform to card'},
      ],
    },
    points: 83,
  );

  await _createTask(
    db,
    goalId: executionGoalId,
    title: 'Weekly trade review',
    description: 'Review all trades against execution rules',
    priority: 1,
    energy: 1,
    estimatedMinutes: 45,
    metadata: {
      'context': 'finance',
      'pillar': 'execution',
      'dod': [
        'All trades reviewed',
        'Rule violations identified',
        'Adjustments documented',
      ],
    },
    points: 84,
  );

  // Goal 3: Watchlist Hygiene
  final watchlistGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Watchlist Hygiene',
    description: 'Maintain focused watchlist with core and sandbox tickers',
    domain: Domain.finance,
    metadata: {
      'kpis': [
        {'metric': 'Watchlist size', 'target': 20, 'current': 50},
      ],
    },
    points: 250,
  );

  await _createTask(
    db,
    goalId: watchlistGoalId,
    title: 'Watchlist prune to ≤20 (tag core/sandbox)',
    description: 'Reduce watchlist to 20 tickers with clear tagging',
    priority: 2,
    energy: 1,
    estimatedMinutes: 30,
    metadata: {
      'context': 'finance',
      'pillar': 'research',
      'dod': [
        'Watchlist reduced to ≤20',
        'Core tickers tagged (10)',
        'Sandbox tickers tagged (10)',
      ],
    },
    points: 83,
  );

  await _createTask(
    db,
    goalId: watchlistGoalId,
    title: 'Monthly watchlist review',
    description: 'Review and refresh watchlist monthly',
    priority: 1,
    energy: 1,
    estimatedMinutes: 45,
    metadata: {
      'context': 'finance',
      'pillar': 'research',
      'dod': [
        'Underperforming tickers removed',
        'New opportunities added',
        'Tags updated',
      ],
    },
    points: 84,
  );

  print('✅ Finance seeded: 1 milestone, 3 goals, 5 tasks');
}

// ============================================================================
// PERSONAL/DSA DOMAIN - GRE
// ============================================================================

/// Seeds GRE prep data
Future<void> seedGRE(AppDatabase db) async {
  print('📚 Seeding GRE data...');

  final milestoneId = _uuid.v4();
  await db.into(db.milestones).insert(
    MilestonesCompanion(
      id: drift.Value(milestoneId),
      title: const drift.Value('GRE Score Band ↑'),
      description: const drift.Value('Improve GRE scores through systematic practice'),
      domain: const drift.Value(Domain.dsa),
      metadata: drift.Value(jsonEncode({
        'targetDate': DateTime.now().add(const Duration(days: 90)).toIso8601String(),
        'currentQuant': 160,
        'targetQuant': 168,
        'currentVerbal': 155,
        'targetVerbal': 162,
      })),
      deadline: drift.Value(DateTime.now().add(const Duration(days: 90))),
      isCompleted: const drift.Value(false),
      totalPoints: const drift.Value(600),
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    ),
  );

  // Goal 1: Quant
  final quantGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Quant Reps',
    description: 'Daily quant practice with timed sets',
    domain: Domain.dsa,
    metadata: {
      'kpis': [
        {'metric': 'Timed sets completed', 'target': 60, 'current': 0},
        {'metric': 'Accuracy', 'target': 90, 'current': 75},
      ],
    },
    points: 200,
  );

  await _createTask(
    db,
    goalId: quantGoalId,
    title: 'Quant: 30-min timed set',
    description: 'Complete 20 quant problems in 30 minutes',
    priority: 2,
    energy: 2,
    estimatedMinutes: 30,
    metadata: {
      'context': 'gre',
      'pillar': 'quant',
      'dod': [
        '20 problems completed',
        'Score logged',
        'Error log updated',
      ],
      'evidence': [
        {'type': 'log', 'desc': 'Score and error patterns'},
      ],
    },
    points: 67,
  );

  // Goal 2: Verbal
  final verbalGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'Verbal Vocab',
    description: 'Vocabulary building and comprehension practice',
    domain: Domain.dsa,
    metadata: {
      'kpis': [
        {'metric': 'Vocab words mastered', 'target': 500, 'current': 0},
        {'metric': 'Cloze accuracy', 'target': 85, 'current': 65},
      ],
    },
    points: 200,
  );

  await _createTask(
    db,
    goalId: verbalGoalId,
    title: 'Verbal: 25 vocab (spaced) + 3 cloze',
    description: 'Spaced repetition for 25 words + 3 cloze passages',
    priority: 2,
    energy: 1,
    estimatedMinutes: 45,
    metadata: {
      'context': 'gre',
      'pillar': 'verbal',
      'dod': [
        '25 vocab cards reviewed',
        '3 cloze passages completed',
        'Accuracy logged',
      ],
    },
    points: 67,
  );

  // Goal 3: AWA
  final awaGoalId = await _createGoal(
    db,
    milestoneId: milestoneId,
    title: 'AWA Structure',
    description: 'Analytical Writing practice with structured outlines',
    domain: Domain.dsa,
    metadata: {
      'kpis': [
        {'metric': 'Essays written', 'target': 20, 'current': 0},
        {'metric': 'Target score', 'target': 5.0, 'current': 3.5},
      ],
    },
    points: 200,
  );

  await _createTask(
    db,
    goalId: awaGoalId,
    title: 'AWA: outline + 1 paragraph',
    description: 'Create essay outline and write first paragraph',
    priority: 1,
    energy: 2,
    estimatedMinutes: 30,
    metadata: {
      'context': 'gre',
      'pillar': 'awa',
      'dod': [
        'Outline complete with 3 main points',
        'Introduction paragraph written',
        'Thesis statement clear',
      ],
    },
    points: 67,
  );

  print('✅ GRE seeded: 1 milestone, 3 goals, 3 tasks');
}

// ============================================================================
// Helper Functions
// ============================================================================

Future<String> _createGoal(
  AppDatabase db, {
  required String milestoneId,
  required String title,
  required String description,
  required Domain domain,
  required Map<String, dynamic> metadata,
  required int points,
}) async {
  final goalId = _uuid.v4();
  await db.into(db.goals).insert(
    GoalsCompanion(
      id: drift.Value(goalId),
      title: drift.Value(title),
      description: drift.Value(description),
      milestoneId: drift.Value(milestoneId),
      metadata: drift.Value(jsonEncode(metadata)),
      isCompleted: const drift.Value(false),
      totalPoints: drift.Value(points),
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    ),
  );
  return goalId;
}

Future<String> _createTask(
  AppDatabase db, {
  required String goalId,
  required String title,
  required String description,
  required int priority,
  required int energy,
  required int estimatedMinutes,
  required Map<String, dynamic> metadata,
  required int points,
}) async {
  final taskId = _uuid.v4();
  await db.into(db.tasks).insert(
    TasksCompanion(
      id: drift.Value(taskId),
      title: drift.Value(title),
      description: drift.Value(description),
      goalId: drift.Value(goalId),
      priority: drift.Value(priority),
      energy: drift.Value(energy),
      estimatedMinutes: drift.Value(estimatedMinutes),
      metadata: drift.Value(jsonEncode(metadata)),
      isCompleted: const drift.Value(false),
      basePoints: drift.Value(points),
      totalPoints: drift.Value(points),
      sortOrder: const drift.Value(0),
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    ),
  );
  return taskId;
}

/// Seed all domains at once
Future<void> seedAllDomains(AppDatabase db) async {
  print('🌟 Seeding all domains...');
  await seedPetform(db);
  await seedMMAmania(db);
  await seedPokeher(db);
  await seedStockSurveyor(db);
  await seedMusicApp(db);
  await seedFitness(db);
  await seedFinance(db);
  await seedGRE(db);
  print('✅✅✅ All domains seeded successfully!');
}

