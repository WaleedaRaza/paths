import type { Goal, Task } from '../store';

/**
 * ATOMIC FRAMEWORK: Mock Data
 * 
 * This file demonstrates the full atomic framework with:
 * - 1 goal of each type (School, Project, DSA, Fitness)
 * - Multiple tasks per goal showing relationships
 * - Task breakdown capability
 * - Loggable tasks for fitness/DSA
 * - Milestones with points
 * - Goal hierarchy
 */

export const mockGoals: Partial<Goal>[] = [
  // ============================================
  // 🎓 SCHOOL GOAL: WGU Course
  // ============================================
  {
    id: 'goal-d426-course',
    title: 'D426 Data Management Foundations',
    type: 'course',
    area: 'School',
    status: 'active',
    
    // Course metadata
    meta: {
      courseCode: 'D426',
      cuValue: 3,
      color: '#3b82f6'
    },
    
    // Time window
    timeWindow: {
      start: '2025-10-01',
      end: '2025-10-31'
    },
    
    // Progress tracking
    targets: {
      unit: 'CUs',
      amount: 3
    },
    currentProgress: 0,
    
    // Milestones with points
    milestones: [
      { id: 'm1', title: 'Read all modules', done: false, points: 50, order: 1 },
      { id: 'm2', title: 'Complete practice assessments', done: false, points: 30, order: 2 },
      { id: 'm3', title: 'Pass final exam', done: false, points: 100, order: 3 }
    ],
    
    // Linked tasks (will be filled with task IDs)
    taskIds: [],
    
    pointsEarned: 0,
    celebrationTrigger: 180, // Total points
    
    createdAt: new Date().toISOString()
  },
  
  // ============================================
  // 🚀 PROJECT GOAL: App Development
  // ============================================
  {
    id: 'goal-void-app',
    title: 'void - AI Notetaking App',
    type: 'project',
    area: 'Apps',
    status: 'active',
    
    // Project metadata
    meta: {
      projectMeta: {
        repo: 'github.com/waleed/void',
        stage: 'implementation',
        commitCount: 0
      },
      color: '#8b5cf6',
      notes: 'Context-aware AI notetaking with local LLM'
    },
    
    // Time window
    deadline: '2025-11-15',
    
    // Progress tracking
    targets: {
      unit: 'commits',
      amount: 50
    },
    currentProgress: 0,
    
    // Milestones (project stages)
    milestones: [
      { id: 'stage-research', title: 'Research & Planning', done: true, points: 50, order: 1 },
      { id: 'stage-sandbox', title: 'Sandboxing & Prototyping', done: false, points: 30, order: 2 },
      { id: 'stage-core', title: 'Core Features', done: false, points: 200, order: 3 },
      { id: 'stage-polish', title: 'Polish & Testing', done: false, points: 100, order: 4 },
      { id: 'stage-deploy', title: 'Deployment', done: false, points: 80, order: 5 }
    ],
    
    taskIds: [],
    pointsEarned: 50, // Research done
    celebrationTrigger: 460,
    
    createdAt: new Date().toISOString()
  },
  
  // ============================================
  // 💻 DSA GOAL: Pattern Mastery
  // ============================================
  {
    id: 'goal-dsa-arrays',
    title: 'Master Array Patterns',
    type: 'dsa-pattern',
    area: 'DSA',
    status: 'active',
    
    // DSA metadata
    meta: {
      dsaMeta: {
        patternType: 'arrays',
        difficultyFocus: 'medium'
      },
      color: '#10b981',
      notes: 'Focus on two-pointers, sliding window, prefix sums'
    },
    
    // Progress tracking
    targets: {
      unit: 'patterns',
      amount: 10 // 10 problems solved
    },
    currentProgress: 0,
    
    // Milestones
    milestones: [
      { id: 'dsa-m1', title: 'Solve 3 Easy problems', done: false, points: 30, order: 1 },
      { id: 'dsa-m2', title: 'Solve 5 Medium problems', done: false, points: 75, order: 2 },
      { id: 'dsa-m3', title: 'Solve 2 Hard problems', done: false, points: 100, order: 3 }
    ],
    
    taskIds: [],
    pointsEarned: 0,
    celebrationTrigger: 205,
    
    createdAt: new Date().toISOString()
  },
  
  // ============================================
  // 💪 FITNESS GOAL: Workout Consistency
  // ============================================
  {
    id: 'goal-fitness-4day',
    title: '4-Day Split Consistency',
    type: 'fitness',
    area: 'Fitness',
    status: 'active',
    
    // Fitness metadata
    meta: {
      fitnessMeta: {
        workoutType: 'upper',
        schedule: ['Monday', 'Wednesday', 'Friday', 'Saturday']
      },
      color: '#ef4444',
      notes: 'Upper/Lower split for strength building'
    },
    
    // Progress tracking
    targets: {
      unit: 'workouts',
      amount: 16 // 4 weeks x 4 days
    },
    currentProgress: 0,
    
    // Milestones
    milestones: [
      { id: 'fit-m1', title: 'Complete first week (4 workouts)', done: false, points: 40, order: 1 },
      { id: 'fit-m2', title: 'Complete 2 weeks consistently', done: false, points: 80, order: 2 },
      { id: 'fit-m3', title: 'Complete full month (16 workouts)', done: false, points: 160, order: 3 }
    ],
    
    taskIds: [],
    pointsEarned: 0,
    celebrationTrigger: 280,
    
    createdAt: new Date().toISOString()
  }
];

export const mockTasks: Partial<Task>[] = [
  // ============================================
  // 🎓 SCHOOL TASKS (D426 Course)
  // ============================================
  
  // Parent task (can be broken down)
  {
    id: 'task-d426-main',
    title: 'D426 → Complete Course',
    area: 'School',
    status: 'todo',
    priority: 'high',
    
    canBreakdown: true, // ✅ Can split into subtasks
    estimateMin: 120, // Overestimate - will break down
    isAtomic: false,
    energy: 'high',
    
    definitionOfDone: 'All modules read, practice tests passed, final exam completed',
    
    goalLinks: [{ goalId: 'goal-d426-course', weight: 1.0 }],
    
    meta: {
      courseCode: 'D426',
      School: {
        courseCode: 'D426',
        cuValue: 3
      }
    },
    
    points: 0, // Will calculate from subtasks
    tags: ['course', 'wgu', 'can-breakdown'],
    
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  
  // Example subtasks (created after breakdown)
  {
    id: 'task-d426-modules',
    title: 'D426 → Read Modules 1-3',
    parentTaskId: 'task-d426-main',
    area: 'School',
    status: 'todo',
    
    estimateMin: 25,
    isAtomic: true,
    energy: 'medium',
    
    definitionOfDone: 'Notes taken, key terms highlighted, quiz questions noted',
    
    goalLinks: [{ goalId: 'goal-d426-course', weight: 1.0 }],
    
    meta: {
      courseCode: 'D426'
    },
    
    points: 25,
    tags: ['course', 'wgu', 'subtask', 'reading'],
    
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  
  {
    id: 'task-d426-practice',
    title: 'D426 → Take Practice Test 1',
    parentTaskId: 'task-d426-main',
    area: 'School',
    status: 'todo',
    
    estimateMin: 20,
    isAtomic: true,
    energy: 'high',
    
    definitionOfDone: 'Test completed, weak areas identified and noted',
    
    goalLinks: [{ goalId: 'goal-d426-course', weight: 1.0 }],
    
    meta: {
      courseCode: 'D426',
      School: {
        courseCode: 'D426',
        cuValue: 3
      }
    },
    
    points: 30,
    tags: ['course', 'wgu', 'subtask', 'assessment'],
    
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  
  // ============================================
  // 🚀 PROJECT TASKS (void app)
  // ============================================
  
  // Parent task (can break down into commits)
  {
    id: 'task-void-core',
    title: 'void → Build Core Features',
    area: 'Apps',
    status: 'todo',
    priority: 'high',
    
    canBreakdown: true,
    estimateMin: 90,
    isAtomic: false,
    energy: 'high',
    
    definitionOfDone: 'Auth, note editor, search, and AI integration working',
    
    goalLinks: [{ goalId: 'goal-void-app', weight: 1.0 }],
    
    meta: {
      projectMeta: {
        repo: 'github.com/waleed/void',
        stage: 'implementation'
      }
    },
    
    points: 0,
    tags: ['project', 'void', 'can-breakdown'],
    
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  
  // Commit-sized subtasks
  {
    id: 'task-void-auth',
    title: 'void → Setup auth flow',
    parentTaskId: 'task-void-core',
    area: 'Apps',
    status: 'todo',
    
    estimateMin: 30,
    isAtomic: true,
    energy: 'high',
    
    definitionOfDone: 'User can sign up, log in, and persist session',
    
    goalLinks: [{ goalId: 'goal-void-app', weight: 1.0 }],
    
    meta: {
      projectMeta: {
        repo: 'github.com/waleed/void',
        commitMessage: 'feat: add authentication flow',
        branch: 'feature/auth',
        stage: 'implementation'
      }
    },
    
    points: 45,
    tags: ['project', 'void', 'subtask', 'commit'],
    
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  
  {
    id: 'task-void-editor',
    title: 'void → Build note editor UI',
    parentTaskId: 'task-void-core',
    area: 'Apps',
    status: 'todo',
    
    estimateMin: 25,
    isAtomic: true,
    energy: 'medium',
    
    definitionOfDone: 'Rich text editor with markdown support working',
    
    goalLinks: [{ goalId: 'goal-void-app', weight: 1.0 }],
    
    meta: {
      projectMeta: {
        repo: 'github.com/waleed/void',
        commitMessage: 'feat: add rich text editor',
        branch: 'feature/editor',
        stage: 'implementation'
      }
    },
    
    points: 35,
    tags: ['project', 'void', 'subtask', 'commit', 'ui'],
    
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  
  // ============================================
  // 💻 DSA TASKS (Array Patterns)
  // ============================================
  
  // Loggable task for practice sessions
  {
    id: 'task-dsa-arrays-practice',
    title: 'Arrays → Solve 2 Medium Problems',
    area: 'DSA',
    status: 'todo',
    priority: 'medium',
    
    loggable: true, // ✅ Can log each problem attempt
    estimateMin: 30,
    isAtomic: true,
    energy: 'high',
    
    definitionOfDone: '2 medium array problems solved, pattern notes written',
    
    goalLinks: [{ goalId: 'goal-dsa-arrays', weight: 1.0 }],
    
    meta: {
      dsaMeta: {
        patternId: 'goal-dsa-arrays',
        difficulty: 'medium'
      }
    },
    
    points: 50,
    logEntries: [], // User will log each problem here
    tags: ['dsa', 'arrays', 'loggable', 'practice'],
    
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  
  {
    id: 'task-dsa-two-pointers',
    title: 'Arrays → Learn Two-Pointers Pattern',
    area: 'DSA',
    status: 'todo',
    
    estimateMin: 20,
    isAtomic: true,
    energy: 'medium',
    
    definitionOfDone: 'Pattern understood, 1 easy problem solved as example',
    
    goalLinks: [{ goalId: 'goal-dsa-arrays', weight: 1.0 }],
    
    meta: {
      dsaMeta: {
        patternId: 'goal-dsa-arrays',
        difficulty: 'easy'
      }
    },
    
    points: 25,
    tags: ['dsa', 'arrays', 'pattern-learning'],
    
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  
  // ============================================
  // 💪 FITNESS TASKS (4-Day Split)
  // ============================================
  
  // Loggable task for workout logging
  {
    id: 'task-fitness-upper-day',
    title: 'Upper Body Day',
    area: 'Fitness',
    status: 'todo',
    priority: 'medium',
    
    loggable: true, // ✅ Can log exercises, weight, reps
    estimateMin: 60,
    isAtomic: false, // Longer duration is OK for fitness
    energy: 'high',
    
    definitionOfDone: 'All exercises completed, weights and reps logged',
    
    goalLinks: [{ goalId: 'goal-fitness-4day', weight: 1.0 }],
    
    meta: {
      fitnessMeta: {
        workoutType: 'upper',
        exercises: [
          { name: 'Bench Press', sets: 3, reps: 8 },
          { name: 'Rows', sets: 3, reps: 10 },
          { name: 'Shoulder Press', sets: 3, reps: 8 },
          { name: 'Pull-ups', sets: 3, reps: 6 }
        ]
      }
    },
    
    points: 40,
    logEntries: [], // User logs weight/reps/calories here
    tags: ['fitness', 'upper-body', 'loggable'],
    
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  
  {
    id: 'task-fitness-lower-day',
    title: 'Lower Body Day',
    area: 'Fitness',
    status: 'todo',
    
    loggable: true,
    estimateMin: 60,
    isAtomic: false,
    energy: 'high',
    
    definitionOfDone: 'All exercises completed, weights and reps logged',
    
    goalLinks: [{ goalId: 'goal-fitness-4day', weight: 1.0 }],
    
    meta: {
      fitnessMeta: {
        workoutType: 'lower',
        exercises: [
          { name: 'Squats', sets: 4, reps: 8 },
          { name: 'Romanian Deadlifts', sets: 3, reps: 10 },
          { name: 'Leg Press', sets: 3, reps: 12 },
          { name: 'Calf Raises', sets: 4, reps: 15 }
        ]
      }
    },
    
    points: 40,
    logEntries: [],
    tags: ['fitness', 'lower-body', 'loggable'],
    
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  }
];

/**
 * Load mock data into the store
 * This is called from SettingsPage for testing
 */
export function loadMockData(addGoal: any, addTask: any) {
  console.log('🧪 Loading atomic framework mock data...');
  
  // Load goals first
  mockGoals.forEach((goal) => {
    addGoal(goal);
  });
  
  // Then load tasks
  mockTasks.forEach((task) => {
    addTask(task);
  });
  
  console.log(`✅ Loaded ${mockGoals.length} goals and ${mockTasks.length} tasks`);
  
  return {
    goalsCount: mockGoals.length,
    tasksCount: mockTasks.length,
    breakdown: {
      school: mockTasks.filter(t => t.area === 'School').length,
      projects: mockTasks.filter(t => t.area === 'Apps').length,
      dsa: mockTasks.filter(t => t.area === 'DSA').length,
      fitness: mockTasks.filter(t => t.area === 'Fitness').length
    }
  };
}

