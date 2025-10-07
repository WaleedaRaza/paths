import { create } from 'zustand';
import { storageService } from '../services/storage';
import { aiService } from '../services/ai';

// Helper function to generate unique IDs
const generateId = () => `id-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;

// ATOMIC FRAMEWORK: Core Types
export interface Task {
  id: string;
  title: string;
  notes?: string;
  description?: string;
  area: 'School' | 'GRE' | 'Apps' | 'DSA' | 'Career' | 'Finance' | 'Wellness' | 'Fitness';
  status: 'todo' | 'in_progress' | 'completed' | 'blocked' | 'archived';
  priority?: 'high' | 'medium' | 'low';
  
  // ATOMIC FRAMEWORK: Energy & time management (with smart defaults)
  energy?: 'low' | 'medium' | 'high';          // Auto-inferred from estimateMin
  estimateMin?: number;                         // Defaults to estimatedDuration or 25
  timeboxMin?: number;                          // Defaults to estimateMin or 25
  definitionOfDone?: string;                    // Auto-generated from title
  isAtomic?: boolean;                           // Auto-calculated from estimateMin
  
  // ATOMIC FRAMEWORK: Task Breakdown & Hierarchy
  canBreakdown?: boolean;                       // True if task can split into subtasks
  parentTaskId?: string;                        // For split sub-tasks
  subtaskIds?: string[];                        // Child task IDs
  
  // ATOMIC FRAMEWORK: Logging (for fitness, DSA)
  loggable?: boolean;                           // True for workouts, DSA sessions
  logEntries?: Array<{
    id: string;
    timestamp: string;
    data: any;                                  // Fitness: { exercises, weight, reps, calories }
                                                // DSA: { problemName, difficulty, timeTaken, solved }
  }>;
  
  // ATOMIC FRAMEWORK: Points & Rewards
  points?: number;                              // Base points for completion
  bonusPoints?: number;                         // Extra for streaks, early completion
  pointsEarned?: number;                        // Total points earned (if completed)
  
  // LEGACY: Keep for backward compatibility
  estimatedDuration?: number;                   // Deprecated, use estimateMin
  due?: string;
  scheduled?: string;
  
  // ATOMIC FRAMEWORK: Goal connections
  goalLinks?: { goalId: string; weight: number }[];  // Auto-converted from goalId
  
  // LEGACY: Keep for backward compatibility
  goalId?: string;                              // Deprecated, use goalLinks
  goals?: string[];                             // Deprecated, use goalLinks
  
  // Hierarchy
  tags: string[];
  parentId?: string;
  
  // Timestamps
  createdAt: string;
  updatedAt: string;
  completedAt?: string;
  archivedAt?: string;
  
  // Metadata
  meta?: {
    // Course-specific
    School?: {
      courseCode: string;
      cuValue: number;
    };
    courseCode?: string;                        // Unified course code field
    
    // Project-specific
    projectMeta?: {
      repo?: string;
      commitMessage?: string;
      branch?: string;
      stage?: 'research' | 'planning' | 'sandbox' | 'implementation' | 'debugging' | 'production' | 'deployed';
    };
    
    // DSA-specific
    dsaMeta?: {
      patternId?: string;                       // Links to pattern goal
      problemUrl?: string;
      difficulty?: 'easy' | 'medium' | 'hard';
    };
    
    // Fitness-specific
    fitnessMeta?: {
      workoutType?: string;
      exercises?: Array<{ name: string; sets: number; reps: number; weight?: number }>;
      calories?: number;
      bodyWeight?: number;
    };
    
    // Scheduling
    scheduledTime?: boolean;
    scheduledHour?: number;
    scheduledMinute?: number;
    
    // Specialized
    workoutType?: string;
    patternId?: string;                         // For DSA/LeetCode patterns
    featureTrack?: string;                      // For project tasks (core/polish/release)
    
    // Rollover tracking
    rollCount?: number;
    rolledForward?: boolean;
    splitIntoSubtasks?: boolean;                // Flag for archived parent tasks
  };
}

export interface Goal {
  id: string;
  title: string;
  area: 'School' | 'GRE' | 'Apps' | 'DSA' | 'Career' | 'Finance' | 'Wellness' | 'Fitness' | 'Other';
  status: 'active' | 'planned' | 'paused' | 'completed' | 'archived';
  
  // ATOMIC FRAMEWORK: Type classification (with smart defaults)
  type?: 'term' | 'course' | 'project' | 'dsa-pattern' | 'career' | 'fitness' | 'finance' | 'milestone' | 'other';
  
  // ATOMIC FRAMEWORK: Hierarchy (goals can contain goals and tasks)
  parentGoalId?: string;    // e.g., D426 → Term 2
  childGoalIds?: string[];  // e.g., Term → Courses
  taskIds?: string[];       // Direct task links
  
  // ATOMIC FRAMEWORK: Time management (replaces task-level deadlines)
  timeWindow?: {
    start: string;  // ISO date YYYY-MM-DD
    end: string;    // ISO date YYYY-MM-DD
  };
  deadline?: string; // For hard deadlines (ISO date)
  
  // ATOMIC FRAMEWORK: Progress tracking
  targets?: {
    unit: 'CUs' | 'tasks' | 'commits' | 'features' | 'patterns' | 'workouts' | 'sessions' | 'applications';
    amount: number;
  };
  currentProgress?: number;  // Auto-calculated from completed tasks
  
  // ATOMIC FRAMEWORK: Milestones with points
  milestones?: Array<{
    id: string;
    title: string;
    done: boolean;
    points?: number;
    order?: number;
  }>;
  
  // ATOMIC FRAMEWORK: Points & Rewards
  pointsEarned?: number;                // Total points from completed tasks
  celebrationTrigger?: number;          // Points threshold for celebration
  
  // Metadata
  meta?: {
    // Course-specific
    courseCode?: string;
    cuValue?: number;
    
    // Project-specific
    projectMeta?: {
      repo?: string;
      stage?: 'research' | 'planning' | 'sandbox' | 'implementation' | 'debugging' | 'production' | 'deployed';
      commitCount?: number;
    };
    
    // DSA-specific
    dsaMeta?: {
      patternType?: 'arrays' | 'hashmaps' | 'sliding-window' | 'two-pointers' | 'trees' | 'graphs' | 'dp' | 'backtracking';
      difficultyFocus?: 'easy' | 'medium' | 'hard';
    };
    
    // Fitness-specific
    fitnessMeta?: {
      workoutType?: 'upper' | 'lower' | 'push' | 'pull' | 'legs' | 'cardio' | 'rest';
      schedule?: string[];              // Days of week
    };
    
    // General
    tracks?: string[];     // For projects: ['core', 'polish', 'release', 'marketing']
    color?: string;
    notes?: string;
  };
  
  // Timestamps
  createdAt: string;
  updatedAt?: string;
  completedAt?: string;
  
  // LEGACY: Keep for backward compatibility
  metric?: string;         // Deprecated, use targets.unit
  targetValue?: number;    // Deprecated, use targets.amount
  currentValue?: number;   // Deprecated, use currentProgress
  targetDate?: string;     // Deprecated, use timeWindow.end or deadline
  codes?: string[];        // Deprecated, use meta.courseCode
}

export interface FocusSession {
  id: string;
  taskId?: string;
  start: string;
  end?: string;
  duration?: number;
  notes?: string;
  type: 'pomodoro' | 'deep_work' | 'break';
  completed: boolean;
}

export interface Reflection {
  id: string;
  date: string;
  title: string;
  type: 'reflection' | 'note' | 'idea' | 'watchlist';
  content: string;
  tags?: string[];
  chatHistory?: ChatMessage[];
}

// ATOMIC FRAMEWORK: Daily Focus System
export interface DailyFocus {
  date: string; // YYYY-MM-DD
  
  slots: {
    wgu: {
      taskId: string | null;
      currentStep: string;
      timeEstimate: number;
    };
    dsa: {
      taskId: string | null;
      currentStep: string;
      timeEstimate: number;
    };
    apps: {
      taskId: string | null;
      currentStep: string;
      timeEstimate: number;
    };
  };
  
  hiddenTaskCount: number;
  completedWins: number;
  totalWins: number;
  energyLevel: 'low' | 'medium' | 'high';
  notes?: string;
}

export interface ChatMessage {
  id: string;
  role: 'user' | 'assistant' | 'system';
  content: string;
  timestamp: string;
  expertId?: string;
}

export interface ChatSession {
  id: string;
  title: string;
  messages: ChatMessage[];
  personalityId?: string;
  createdAt: string;
  updatedAt: string;
}

interface AppSettings {
  dailyMustWins: number;
  focusBlockMin: number;
  breakMin: number;
  greDailyVocab: number;
}

interface UIState {
  mustWinIds: string[];
  currentPage: 'today' | 'tasks' | 'goals' | 'calendar' | 'reflections' | 'saved' | 'settings';
  selectedTasks: string[];
}

interface AppStore {
  // State
  tasks: Task[];
  goals: Goal[];
  sessions: FocusSession[];
  reflections: Reflection[];
  chatHistory: ChatMessage[];
  chatSessions: ChatSession[];
  currentSessionId: string | null;
  settings: AppSettings;
  ui: UIState;
  
  // ATOMIC FRAMEWORK: Daily Focus State
  dailyFocus: DailyFocus | null;
  
  // Loading states
  isLoading: {
    tasks: boolean;
    goals: boolean;
    all: boolean;
  };
  loadingError: string | null;
  
  // AI state
  aiInsights: Array<{
    id: string;
    type: 'urgent' | 'warning' | 'info' | 'success';
    title: string;
    description: string;
    action?: string;
    createdAt: string;
  }>;
  isAiAvailable: boolean;
  
  // Actions
  addTask: (task: Omit<Task, 'id' | 'createdAt' | 'updatedAt'>) => Task | { error: string; task: any; message: string };
  updateTask: (id: string, updates: Partial<Task>) => void;
  deleteTask: (id: string) => void;
  archiveTask: (id: string) => void;
  
  addGoal: (goal: Omit<Goal, 'id' | 'createdAt'>) => void;
  updateGoal: (id: string, updates: Partial<Goal>) => void;
  deleteGoal: (id: string) => void;
  archiveGoal: (id: string) => void;
  
  addSession: (session: Omit<FocusSession, 'id'>) => void;
  
  addReflection: (reflection: Omit<Reflection, 'id'>) => void;
  updateReflection: (id: string, updates: Partial<Reflection>) => void;
  deleteReflection: (id: string) => void;
  
  // Chat actions
  addChatMessage: (message: ChatMessage) => void;
  clearChatHistory: () => void;
  getChatHistory: () => ChatMessage[];
  sendChatMessage: (reflectionId: string, message: string) => Promise<void>;
  sendHolisticMessage: (reflectionId: string, message: string, customSystemPrompt?: string) => Promise<void>;
  
  // Chat session actions
  createChatSession: (title?: string, personalityId?: string) => string;
  selectChatSession: (sessionId: string) => void;
  deleteChatSession: (sessionId: string) => void;
  getCurrentSession: () => ChatSession | null;
  addMessageToSession: (sessionId: string, message: { role: 'user' | 'assistant'; content: string }) => void;
  updateChatSession: (sessionId: string, updates: Partial<ChatSession>) => void;
  archiveChatSession: (sessionId: string) => void;
  
  // AI actions
  addInsight: (insight: Omit<AppStore['aiInsights'][0], 'id' | 'createdAt'>) => void;
  clearInsights: () => void;
  checkAiAvailability: () => Promise<void>;
  
  // Data loading actions
  loadGoalsFromAPI: () => Promise<void>;
  loadTasksFromAPI: () => Promise<void>;
  loadAllDataFromAPI: () => Promise<void>;
  syncDataWithAPI: () => Promise<void>;
  
  // ATOMIC FRAMEWORK: New Actions
  generateDailyFocus: () => void;
  rolloverTasks: () => void;
  logMicroWin: (taskId: string, note: string) => void;
  splitTask: (taskId: string, subtasks: Partial<Task>[]) => void;
  addMustWin: (taskId: string) => void;
  
  // ATOMIC FRAMEWORK: Task Breakdown & Logging
  breakdownTask: (taskId: string, subtasks: Array<Partial<Task>>) => void;
  logTaskEntry: (taskId: string, data: any) => void;
  calculateTaskPoints: (task: Task) => number;
  updateGoalProgress: (goalId: string) => void;
  
  // UI actions
  updateUI: (updates: Partial<UIState>) => void;
  
  // Computed values
  getMustWinTasks: () => Task[];
  getNextUpTasks: () => Task[];
  getCurrentStreak: () => number;
  getWeeklyMomentum: () => number;
}

// Auto-save debouncing
let saveTimeout: number | null = null;
const DEBOUNCE_DELAY = 2000; // 2 seconds

const debouncedSave = (state: any) => {
  if (saveTimeout) {
    clearTimeout(saveTimeout);
  }
  saveTimeout = setTimeout(async () => {
    try {
      await storageService.saveAppData({
        tasks: state.tasks,
        goals: state.goals,
        sessions: state.sessions,
        reflections: state.reflections,
        settings: state.settings,
        ui: state.ui,
        lastSync: new Date().toISOString()
      });
      console.log('✅ Auto-saved data successfully');
    } catch (error) {
      console.error('❌ Auto-save failed:', error);
    }
  }, DEBOUNCE_DELAY);
};

// ATOMIC FRAMEWORK: Task normalization with smart defaults
const normalizeTask = (taskData: Partial<Task>): Partial<Task> => {
  const normalized = { ...taskData };
  
  // 1. ESTIMATE TIME: Use estimateMin, fallback to estimatedDuration, default to 25
  if (!normalized.estimateMin && normalized.estimatedDuration) {
    normalized.estimateMin = normalized.estimatedDuration;
  }
  if (!normalized.estimateMin) {
    normalized.estimateMin = 25; // Default Pomodoro
  }
  
  // 2. ENFORCE ATOMIC: Max 30 minutes
  if (normalized.estimateMin && normalized.estimateMin > 30) {
    console.warn(`⚠️ Task "${taskData.title}" exceeds 30min (${normalized.estimateMin}min). Consider splitting.`);
    normalized.isAtomic = false;
  } else {
    normalized.isAtomic = true;
  }
  
  // 3. TIMEBOX: Default to estimateMin
  if (!normalized.timeboxMin) {
    normalized.timeboxMin = normalized.estimateMin;
  }
  
  // 4. ENERGY LEVEL: Infer from estimate
  if (!normalized.energy) {
    if (normalized.estimateMin <= 15) {
      normalized.energy = 'low';
    } else if (normalized.estimateMin <= 25) {
      normalized.energy = 'medium';
    } else {
      normalized.energy = 'high';
    }
  }
  
  // 5. DEFINITION OF DONE: Auto-generate if missing
  if (!normalized.definitionOfDone) {
    const title = taskData.title?.toLowerCase() || '';
    if (title.includes('read') || title.includes('review')) {
      normalized.definitionOfDone = `Read and understand ${taskData.title}`;
    } else if (title.includes('write') || title.includes('draft')) {
      normalized.definitionOfDone = `Complete draft of ${taskData.title}`;
    } else if (title.includes('practice') || title.includes('solve')) {
      normalized.definitionOfDone = `Successfully complete ${taskData.title}`;
    } else {
      normalized.definitionOfDone = `Complete: ${taskData.title}`;
    }
  }
  
  // 6. GOAL LINKS: Convert legacy goalId/goals to goalLinks
  if (!normalized.goalLinks) {
    normalized.goalLinks = [];
    
    if (normalized.goalId) {
      normalized.goalLinks.push({ goalId: normalized.goalId, weight: 1.0 });
    }
    
    if (normalized.goals && Array.isArray(normalized.goals)) {
      normalized.goals.forEach(gId => {
        if (!normalized.goalLinks?.find(gl => gl.goalId === gId)) {
          normalized.goalLinks?.push({ goalId: gId, weight: 0.5 });
        }
      });
    }
  }
  
  // 7. ENSURE TAGS ARRAY
  if (!normalized.tags) {
    normalized.tags = [];
  }
  
  return normalized;
};

// ATOMIC FRAMEWORK: Goal normalization with smart defaults
const normalizeGoal = (goalData: Partial<Goal>): Partial<Goal> => {
  const normalized = { ...goalData };
  
  // 1. INFER TYPE from area
  if (!normalized.type && normalized.area) {
    const typeMap: Record<string, Goal['type']> = {
      'School': 'course',
      'Apps': 'project',
      'GRE': 'other',
      'Finance': 'finance',
      'Wellness': 'other',
      'Fitness': 'fitness',
      'Other': 'other'
    };
    normalized.type = typeMap[normalized.area] || 'other';
  }
  
  // 2. CONVERT LEGACY FIELDS to new structure
  if (!normalized.targets && normalized.metric && normalized.targetValue !== undefined) {
    normalized.targets = {
      unit: normalized.metric as any,
      amount: normalized.targetValue
    };
  }
  
  // 3. CONVERT LEGACY targetDate to deadline or timeWindow
  if (!normalized.deadline && !normalized.timeWindow && normalized.targetDate) {
    normalized.deadline = normalized.targetDate;
  }
  
  // 4. ENSURE ARRAYS
  if (!normalized.childGoalIds) normalized.childGoalIds = [];
  if (!normalized.taskIds) normalized.taskIds = [];
  if (!normalized.milestones) normalized.milestones = [];
  
  // 5. INITIALIZE META
  if (!normalized.meta) normalized.meta = {};
  if (normalized.codes && normalized.codes.length > 0 && !normalized.meta.courseCode) {
    normalized.meta.courseCode = normalized.codes[0];
  }
  
  return normalized;
};

export const useAppStore = create<AppStore>()((set, get) => ({
      // COMPLETELY EMPTY INITIAL STATE - ALL DATA FROM API
      tasks: [],
      goals: [],
      sessions: [],
      reflections: [],
      chatHistory: [],
      chatSessions: [],
      currentSessionId: null,
  settings: {
    dailyMustWins: 3,
    focusBlockMin: 50,
    breakMin: 10,
    greDailyVocab: 5
  },
  ui: {
    mustWinIds: [],
    currentPage: 'today',
    selectedTasks: []
  },
  // ATOMIC FRAMEWORK: Daily Focus State
  dailyFocus: null,
  // Loading states
  isLoading: {
    tasks: false,
    goals: false,
    all: false
  },
  loadingError: null,
  aiInsights: [],
  isAiAvailable: false,

      // Task actions
      addTask: (taskData) => {
    // ATOMIC FRAMEWORK: Normalize task before adding
    const normalized = normalizeTask(taskData);
    
        const task: Task = {
      ...normalized as Task,
          id: generateId(),
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        };
    
    console.log(`✅ Added atomic task: "${task.title}" (${task.estimateMin}min, ${task.energy} energy)`);
    
    set((state) => {
      const newState = { tasks: [...state.tasks, task] };
      debouncedSave(newState);
      return newState;
    });
    
    return task;
      },

      updateTask: (id, updates) => {
    const state = get();
    const task = state.tasks.find((t) => t.id === id);
    
    // ATOMIC FRAMEWORK: Auto-calculate points on completion
    if (updates.status === 'completed' && task && task.status !== 'completed') {
      const points = get().calculateTaskPoints(task);
      updates.pointsEarned = points;
      updates.completedAt = new Date().toISOString();
      console.log(`🎉 Task completed! Earned ${points} points`);
      
      // Update goal progress for linked goals
      task.goalLinks?.forEach((gl) => {
        get().updateGoalProgress(gl.goalId);
      });
    }
    
    set((state) => {
      const newState = {
          tasks: state.tasks.map((task) =>
            task.id === id
              ? { ...task, ...updates, updatedAt: new Date().toISOString() }
              : task
          )
      };
      debouncedSave(newState);
      return newState;
    });
      },

      deleteTask: (id) => {
    set((state) => {
      const newState = {
          tasks: state.tasks.filter((task) => task.id !== id),
          ui: {
            ...state.ui,
            mustWinIds: state.ui.mustWinIds.filter((mwId) => mwId !== id),
            selectedTasks: state.ui.selectedTasks.filter((sId) => sId !== id)
          }
      };
      debouncedSave(newState);
      return newState;
    });
      },

      archiveTask: (id) => {
    set((state) => {
      const newState = {
          tasks: state.tasks.map((task) =>
            task.id === id
            ? { ...task, status: 'archived' as const, archivedAt: new Date().toISOString(), updatedAt: new Date().toISOString() }
              : task
          ),
          ui: {
            ...state.ui,
            mustWinIds: state.ui.mustWinIds.filter((mwId) => mwId !== id),
            selectedTasks: state.ui.selectedTasks.filter((sId) => sId !== id)
        }
      };
      debouncedSave(newState);
      return newState;
        });
      },

  // ATOMIC FRAMEWORK: New Actions (placeholder implementations)
  generateDailyFocus: () => {
    console.log('🎯 Daily focus generation - coming soon');
  },

  rolloverTasks: () => {
    console.log('🔄 Task rollover - coming soon');
  },

  logMicroWin: (taskId: string, note: string) => {
    console.log('🏆 Micro win logged:', { taskId, note });
  },

  splitTask: (taskId: string, subtasks: Partial<Task>[]) => {
    console.log('✂️ Task splitting - coming soon:', { taskId, subtasks });
  },

  addMustWin: (taskId: string) => {
    console.log('⭐ Adding must-win task:', taskId);
  },

  // UI actions
  updateUI: (updates) => {
        set((state) => ({
      ui: { ...state.ui, ...updates }
        }));
      },

      // Goal actions
      addGoal: (goalData) => {
    // ATOMIC FRAMEWORK: Normalize goal before adding
    const normalized = normalizeGoal(goalData);
    
        const goal: Goal = {
      ...normalized as Goal,
          id: generateId(),
      status: normalized.status || 'active',
          createdAt: new Date().toISOString()
        };
    
    console.log(`✅ Added goal: "${goal.title}" (${goal.type}, ${goal.area})`);
    
        set((state) => ({ goals: [...state.goals, goal] }));
      },

      updateGoal: (id, updates) => {
        set((state) => ({
          goals: state.goals.map((goal) =>
            goal.id === id ? { ...goal, ...updates } : goal
          )
        }));
      },

      deleteGoal: (id) => {
        set((state) => ({
          goals: state.goals.filter((goal) => goal.id !== id)
        }));
      },

      archiveGoal: (id) => {
        set((state) => ({
          goals: state.goals.map((goal) =>
        goal.id === id ? { ...goal, status: 'archived' as const } : goal
          )
        }));
      },

      // Session actions
      addSession: (sessionData) => {
        const session: FocusSession = {
          ...sessionData,
          id: generateId()
        };
        set((state) => ({ sessions: [...state.sessions, session] }));
      },

      // Reflection actions
      addReflection: (reflectionData) => {
        const reflection: Reflection = {
          ...reflectionData,
          id: generateId()
        };
        set((state) => ({ reflections: [...state.reflections, reflection] }));
      },

      updateReflection: (id, updates) => {
        set((state) => ({
          reflections: state.reflections.map((reflection) =>
            reflection.id === id ? { ...reflection, ...updates } : reflection
          )
        }));
      },

      deleteReflection: (id) => {
        set((state) => ({
          reflections: state.reflections.filter((reflection) => reflection.id !== id)
        }));
      },

  // Chat actions
  addChatMessage: (message) => {
        set((state) => ({
      chatHistory: [...state.chatHistory, message]
        }));
      },

  clearChatHistory: () => {
    set({ chatHistory: [] });
  },

  getChatHistory: () => {
    return get().chatHistory;
      },

      sendChatMessage: async (reflectionId, message) => {
    try {
      const response = await aiService.sendMessage(message, reflectionId);
      get().addChatMessage({
            id: generateId(),
            role: 'assistant',
        content: response,
            timestamp: new Date().toISOString()
      });
        } catch (error) {
      console.error('Failed to send chat message:', error);
    }
  },

  sendHolisticMessage: async (reflectionId, message, _customSystemPrompt) => {
    try {
      const response = await aiService.sendMessage(message, reflectionId);
      get().addChatMessage({
            id: generateId(),
            role: 'assistant',
            content: response,
            timestamp: new Date().toISOString()
      });
        } catch (error) {
      console.error('Failed to send holistic message:', error);
    }
  },

      // Chat session actions
  createChatSession: (title, personalityId) => {
        const sessionId = generateId();
        const newSession: ChatSession = {
          id: sessionId,
      title: title || `Session ${new Date().toLocaleDateString()}`,
      messages: [],
      personalityId,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };
    
        set((state) => ({
            chatSessions: [...state.chatSessions, newSession],
            currentSessionId: sessionId
    }));
        
        return sessionId;
      },

      selectChatSession: (sessionId) => {
        set({ currentSessionId: sessionId });
      },

      deleteChatSession: (sessionId) => {
          set((state) => ({
      chatSessions: state.chatSessions.filter((session) => session.id !== sessionId),
      currentSessionId: state.currentSessionId === sessionId ? null : state.currentSessionId
        }));
      },

      getCurrentSession: () => {
        const state = get();
        return state.chatSessions.find(session => session.id === state.currentSessionId) || null;
      },

      addMessageToSession: (sessionId, message) => {
        set((state) => ({
          chatSessions: state.chatSessions.map((session) =>
            session.id === sessionId
              ? {
                  ...session,
                  messages: [...session.messages, { ...message, id: generateId(), timestamp: new Date().toISOString() }],
                  lastActivity: new Date().toISOString()
                }
              : session
          )
        }));
      },

      updateChatSession: (sessionId, updates) => {
        set((state) => ({
          chatSessions: state.chatSessions.map((session) =>
            session.id === sessionId ? { ...session, ...updates } : session
          )
        }));
      },

      archiveChatSession: (sessionId) => {
        set((state) => ({
          chatSessions: state.chatSessions.map((session) =>
            session.id === sessionId ? { ...session, archived: true, archivedAt: new Date().toISOString() } : session
          )
        }));
      },

      // AI actions
  addInsight: (insightData) => {
    const insight = {
      ...insightData,
            id: generateId(),
            createdAt: new Date().toISOString()
    };
        set((state) => ({
      aiInsights: [...state.aiInsights, insight]
          }));
      },

      clearInsights: () => {
        set({ aiInsights: [] });
      },

  checkAiAvailability: async () => {
        try {
      const isAvailable = await aiService.checkAvailability();
      set({ isAiAvailable: isAvailable });
        } catch (error) {
      console.error('Failed to check AI availability:', error);
      set({ isAiAvailable: false });
    }
  },

  // Data loading actions (placeholder implementations)
  loadGoalsFromAPI: async () => {
    console.log('📊 Loading goals from API - coming soon');
  },

  loadTasksFromAPI: async () => {
    console.log('📋 Loading tasks from API - coming soon');
      },

      loadAllDataFromAPI: async () => {
    console.log('🔄 Loading all data from API - coming soon');
      },

      syncDataWithAPI: async () => {
    console.log('🔄 Syncing data with API - coming soon');
      },

  // ATOMIC FRAMEWORK: Task Breakdown
  breakdownTask: (taskId, subtasks) => {
    const parentTask = get().tasks.find((t) => t.id === taskId);
    if (!parentTask) {
      console.error('❌ Parent task not found:', taskId);
      return;
    }
    
    // Create subtasks with proper links
    const createdSubtasks: string[] = [];
    subtasks.forEach((subtaskData) => {
      const subtask: Task = {
        ...normalizeTask(subtaskData) as Task,
              id: generateId(),
        parentTaskId: taskId,
        goalLinks: parentTask.goalLinks || [],
        area: parentTask.area,
        tags: [...(parentTask.tags || []), 'subtask'],
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      };
      createdSubtasks.push(subtask.id);
        set((state) => ({
        tasks: [...state.tasks, subtask]
      }));
    });
    
    // Update parent task
          set((state) => ({
      tasks: state.tasks.map((t) =>
        t.id === taskId
          ? { ...t, subtaskIds: createdSubtasks, status: 'in_progress', updatedAt: new Date().toISOString() }
          : t
          )
        }));
    
    console.log(`✅ Broke down task "${parentTask.title}" into ${createdSubtasks.length} subtasks`);
  },
  
  // ATOMIC FRAMEWORK: Log Entry (for fitness/DSA)
  logTaskEntry: (taskId, data) => {
        set((state) => ({
      tasks: state.tasks.map((t) => {
        if (t.id === taskId) {
          const entry = {
            id: generateId(),
            timestamp: new Date().toISOString(),
            data
          };
          return {
            ...t,
            logEntries: [...(t.logEntries || []), entry],
            updatedAt: new Date().toISOString()
          };
        }
        return t;
      })
    }));
    console.log(`📊 Logged entry for task ${taskId}`);
  },
  
  // ATOMIC FRAMEWORK: Calculate Points
  calculateTaskPoints: (task) => {
    if (!task.estimateMin) return 10; // Default
    
    // Base points from time estimate
    let basePoints = Math.ceil(task.estimateMin / 5) * 5; // 5 points per 5 min
    
    // Multipliers
    if (task.energy === 'high') basePoints *= 1.5;
    if (task.priority === 'high') basePoints *= 1.3;
    if (task.meta?.dsaMeta?.difficulty === 'hard') basePoints *= 2;
    if (task.meta?.dsaMeta?.difficulty === 'medium') basePoints *= 1.5;
    
    return Math.round(basePoints);
  },
  
  // ATOMIC FRAMEWORK: Update Goal Progress
  updateGoalProgress: (goalId) => {
        const state = get();
    const goal = state.goals.find((g) => g.id === goalId);
    if (!goal) return;
    
    // Find all tasks linked to this goal
    const linkedTasks = state.tasks.filter((t) =>
      t.goalLinks?.some((gl) => gl.goalId === goalId)
    );
    
    const completedTasks = linkedTasks.filter((t) => t.status === 'completed').length;
    const totalTasks = linkedTasks.length;
    
    // Calculate progress percentage
    const progress = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;
    
    // Calculate earned points
    const pointsEarned = linkedTasks
      .filter((t) => t.status === 'completed')
      .reduce((sum, t) => sum + (t.pointsEarned || 0), 0);
    
    // Update goal
        set((state) => ({
      goals: state.goals.map((g) =>
        g.id === goalId
          ? {
              ...g,
              currentProgress: Math.round(progress),
              pointsEarned,
              updatedAt: new Date().toISOString()
            }
          : g
      )
    }));
    
    console.log(`📊 Updated goal progress: ${goal.title} → ${Math.round(progress)}%`);
      },

      // Computed values
      getMustWinTasks: () => {
    const state = get();
    return state.tasks.filter((task) => state.ui.mustWinIds.includes(task.id));
      },

      getNextUpTasks: () => {
    const state = get();
    return state.tasks
      .filter((task) => task.status === 'todo' && !state.ui.mustWinIds.includes(task.id))
          .sort((a, b) => {
        if (a.priority === 'high' && b.priority !== 'high') return -1;
        if (b.priority === 'high' && a.priority !== 'high') return 1;
        return new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime();
      })
      .slice(0, 5);
      },

      getCurrentStreak: () => {
    // Placeholder implementation
    return 0;
      },

      getWeeklyMomentum: () => {
    // Placeholder implementation
    return 0;
  }
}));
