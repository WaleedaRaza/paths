import React, { useState, useMemo } from 'react';
import { 
  Hammer, BarChart3, CheckCircle, Circle, Clock, Zap, 
  Calendar, Filter, Plus, Search, ChevronDown, ChevronRight,
  GraduationCap, Briefcase, Code, Dumbbell, Target
} from 'lucide-react';
import { useAppStore, Task } from '../store';
import { TaskBreakdownModal } from '../components/TaskBreakdownModal';
import { LogEntryModal } from '../components/LogEntryModal';
import { PointsDisplay } from '../components/PointsDisplay';

// Area Icons
const getAreaIcon = (area: string) => {
  switch (area) {
    case 'School': return <GraduationCap className="w-4 h-4" />;
    case 'Apps': return <Briefcase className="w-4 h-4" />;
    case 'DSA': 
    case 'Career': return <Code className="w-4 h-4" />;
    case 'Fitness': return <Dumbbell className="w-4 h-4" />;
    default: return <Target className="w-4 h-4" />;
  }
};

const getAreaColor = (area: string) => {
  switch (area) {
    case 'School': return 'from-blue-500 to-purple-600';
    case 'Apps': return 'from-purple-500 to-pink-600';
    case 'DSA':
    case 'Career': return 'from-green-500 to-emerald-600';
    case 'Fitness': return 'from-red-500 to-orange-600';
    default: return 'from-zinc-500 to-zinc-600';
  }
};

const getEnergyColor = (energy?: string) => {
  switch (energy) {
    case 'high': return 'text-red-400 bg-red-600/20';
    case 'medium': return 'text-yellow-400 bg-yellow-600/20';
    case 'low': return 'text-green-400 bg-green-600/20';
    default: return 'text-zinc-400 bg-zinc-600/20';
  }
};

const getEnergyLabel = (energy?: string) => {
  switch (energy) {
    case 'high': return '🔴 High';
    case 'medium': return '🟡 Medium';
    case 'low': return '🟢 Low';
    default: return '⚪ None';
  }
};

// Atomic Task Card Component
function AtomicTaskCard({ task, onComplete, onBreakdown, onLog }: {
  task: Task;
  onComplete: () => void;
  onBreakdown: () => void;
  onLog: () => void;
}) {
  const { goals } = useAppStore();
  const [expanded, setExpanded] = useState(false);

  const linkedGoals = useMemo(() => {
    return goals.filter(g => 
      task.goalLinks?.some(gl => gl.goalId === g.id)
    );
  }, [goals, task.goalLinks]);

  const hasSubtasks = task.subtaskIds && task.subtaskIds.length > 0;

  return (
    <div className={`group relative p-4 rounded-xl border-2 transition-all ${
      task.status === 'completed'
        ? 'bg-green-600/10 border-green-600/30'
        : task.isAtomic
        ? 'bg-zinc-800/50 border-zinc-700 hover:border-zinc-600'
        : 'bg-orange-600/10 border-orange-600/30'
    }`}>
      {/* Header */}
      <div className="flex items-start gap-3">
        {/* Completion checkbox */}
        <button
          onClick={onComplete}
          className={`flex-shrink-0 w-6 h-6 rounded-full border-2 flex items-center justify-center transition-all ${
            task.status === 'completed'
              ? 'bg-green-600 border-green-500'
              : 'border-zinc-600 hover:border-blue-500'
          }`}
        >
          {task.status === 'completed' && <CheckCircle className="w-4 h-4 text-white" />}
        </button>

        {/* Content */}
        <div className="flex-1 min-w-0">
          {/* Title */}
          <div className="flex items-start justify-between gap-2">
            <h3 className={`font-semibold ${
              task.status === 'completed' ? 'text-green-300 line-through' : 'text-white'
            }`}>
              {task.title}
            </h3>

            {/* Area badge */}
            <div className={`flex-shrink-0 flex items-center gap-1 px-2 py-1 rounded-lg bg-gradient-to-r ${getAreaColor(task.area)}`}>
              {getAreaIcon(task.area)}
              <span className="text-xs font-medium text-white">{task.area}</span>
            </div>
          </div>

          {/* Metadata row */}
          <div className="flex items-center gap-3 mt-2 text-sm text-zinc-400">
            {/* Time estimate */}
            {task.estimateMin && (
              <div className="flex items-center gap-1">
                <Clock className="w-3 h-3" />
                <span>{task.estimateMin}min</span>
              </div>
            )}

            {/* Energy level */}
            {task.energy && (
              <span className={`text-xs px-2 py-0.5 rounded ${getEnergyColor(task.energy)}`}>
                {getEnergyLabel(task.energy)}
              </span>
            )}

            {/* Points */}
            {task.points && (
              <div className="flex items-center gap-1 text-amber-400">
                <Zap className="w-3 h-3" />
                <span className="font-semibold">{task.points}pts</span>
              </div>
            )}

            {/* Atomic badge */}
            {task.isAtomic && task.status !== 'completed' && (
              <span className="text-xs px-2 py-0.5 rounded bg-blue-600/20 text-blue-400 border border-blue-600/30">
                ⚛️ Atomic
              </span>
            )}
          </div>

          {/* Definition of Done */}
          {task.definitionOfDone && (
            <div className="mt-2 p-2 bg-zinc-900/50 rounded border border-zinc-700">
              <p className="text-xs text-zinc-400">
                <span className="font-semibold text-zinc-300">Done when:</span> {task.definitionOfDone}
              </p>
            </div>
          )}

          {/* Linked goals */}
          {linkedGoals.length > 0 && (
            <div className="mt-2 flex items-center gap-2 flex-wrap">
              <span className="text-xs text-zinc-500">→</span>
              {linkedGoals.map(goal => (
                <span 
                  key={goal.id} 
                  className="text-xs px-2 py-1 bg-purple-600/20 text-purple-300 rounded border border-purple-600/30"
                >
                  {goal.title}
                </span>
              ))}
            </div>
          )}

          {/* Action buttons */}
          {task.status !== 'completed' && (
            <div className="mt-3 flex items-center gap-2">
              {/* Breakdown button */}
              {task.canBreakdown && !hasSubtasks && (
                <button
                  onClick={onBreakdown}
                  className="flex items-center gap-1 px-3 py-1 bg-blue-600 hover:bg-blue-700 rounded-lg transition-colors text-white text-sm font-medium"
                >
                  <Hammer className="w-3 h-3" />
                  Break Down
                </button>
              )}

              {/* Log button */}
              {task.loggable && (
                <button
                  onClick={onLog}
                  className="flex items-center gap-1 px-3 py-1 bg-green-600 hover:bg-green-700 rounded-lg transition-colors text-white text-sm font-medium"
                >
                  <BarChart3 className="w-3 h-3" />
                  Log Entry
                </button>
              )}

              {/* Expand subtasks */}
              {hasSubtasks && (
                <button
                  onClick={() => setExpanded(!expanded)}
                  className="flex items-center gap-1 px-3 py-1 bg-zinc-700 hover:bg-zinc-600 rounded-lg transition-colors text-white text-sm"
                >
                  {expanded ? <ChevronDown className="w-3 h-3" /> : <ChevronRight className="w-3 h-3" />}
                  {task.subtaskIds.length} subtasks
                </button>
              )}
            </div>
          )}

          {/* Log entries preview */}
          {task.loggable && task.logEntries && task.logEntries.length > 0 && (
            <div className="mt-2 text-xs text-zinc-400">
              📊 {task.logEntries.length} {task.logEntries.length === 1 ? 'entry' : 'entries'} logged
            </div>
          )}
        </div>
      </div>

      {/* Warning for non-atomic tasks */}
      {!task.isAtomic && task.status !== 'completed' && !task.canBreakdown && (
        <div className="mt-3 p-2 bg-orange-600/20 border border-orange-600/30 rounded-lg">
          <p className="text-xs text-orange-300">
            ⚠️ This task is longer than 30min. Consider breaking it down for better focus.
          </p>
        </div>
      )}
    </div>
  );
}

export function AtomicTasksPage() {
  const { tasks, breakdownTask, logTaskEntry, updateTask, goals } = useAppStore();

  const [searchQuery, setSearchQuery] = useState('');
  const [selectedArea, setSelectedArea] = useState<string>('all');
  const [selectedEnergy, setSelectedEnergy] = useState<string>('all');
  const [showCompleted, setShowCompleted] = useState(false);
  
  const [breakdownModalTask, setBreakdownModalTask] = useState<Task | null>(null);
  const [logModalTask, setLogModalTask] = useState<Task | null>(null);

  // Filter tasks
  const filteredTasks = useMemo(() => {
    return tasks.filter(task => {
      // Search
      if (searchQuery && !task.title.toLowerCase().includes(searchQuery.toLowerCase())) {
        return false;
      }

      // Area filter
      if (selectedArea !== 'all' && task.area !== selectedArea) {
        return false;
      }

      // Energy filter
      if (selectedEnergy !== 'all' && task.energy !== selectedEnergy) {
        return false;
      }

      // Completed filter
      if (!showCompleted && task.status === 'completed') {
        return false;
      }

      // Hide subtasks (show them under parent)
      if (task.parentTaskId) {
        return false;
      }

      return true;
    });
  }, [tasks, searchQuery, selectedArea, selectedEnergy, showCompleted]);

  // Group tasks
  const groupedTasks = useMemo(() => {
    const atomicTodo = filteredTasks.filter(t => t.status === 'todo' && t.isAtomic);
    const nonAtomicTodo = filteredTasks.filter(t => t.status === 'todo' && !t.isAtomic);
    const inProgress = filteredTasks.filter(t => t.status === 'in_progress');
    const completed = filteredTasks.filter(t => t.status === 'completed');

    return {
      atomicTodo,
      nonAtomicTodo,
      inProgress,
      completed
    };
  }, [filteredTasks]);

  const handleComplete = (task: Task) => {
    updateTask(task.id, { 
      status: task.status === 'completed' ? 'todo' : 'completed' 
    });
  };

  const handleBreakdown = (task: Task, subtasks: Array<Partial<Task>>) => {
    breakdownTask(task.id, subtasks);
    setBreakdownModalTask(null);
  };

  const handleLog = (task: Task, data: any) => {
    logTaskEntry(task.id, data);
    setLogModalTask(null);
  };

  const stats = {
    total: tasks.filter(t => t.status !== 'completed' && !t.parentTaskId).length,
    atomic: tasks.filter(t => t.isAtomic && t.status !== 'completed').length,
    needBreakdown: tasks.filter(t => !t.isAtomic && t.canBreakdown && t.status !== 'completed').length,
    loggable: tasks.filter(t => t.loggable && t.status !== 'completed').length
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-zinc-950 via-zinc-900 to-zinc-950">
      <div className="max-w-7xl mx-auto px-4 py-8 space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-4xl font-bold text-white mb-2">⚛️ Atomic Tasks</h1>
            <p className="text-zinc-400">5-30 minute focused work blocks</p>
          </div>

          {/* Points Display */}
          <PointsDisplay />
        </div>

        {/* Stats Bar */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="p-4 bg-zinc-800/50 border border-zinc-700 rounded-xl">
            <div className="text-2xl font-bold text-white">{stats.total}</div>
            <div className="text-sm text-zinc-400">Active Tasks</div>
          </div>
          <div className="p-4 bg-blue-600/10 border border-blue-600/30 rounded-xl">
            <div className="text-2xl font-bold text-blue-400">{stats.atomic}</div>
            <div className="text-sm text-zinc-400">Atomic (≤30min)</div>
          </div>
          <div className="p-4 bg-orange-600/10 border border-orange-600/30 rounded-xl">
            <div className="text-2xl font-bold text-orange-400">{stats.needBreakdown}</div>
            <div className="text-sm text-zinc-400">Need Breakdown</div>
          </div>
          <div className="p-4 bg-green-600/10 border border-green-600/30 rounded-xl">
            <div className="text-2xl font-bold text-green-400">{stats.loggable}</div>
            <div className="text-sm text-zinc-400">Loggable</div>
          </div>
        </div>

        {/* Filters */}
        <div className="flex flex-wrap items-center gap-4 p-4 bg-zinc-800/50 border border-zinc-700 rounded-xl">
          {/* Search */}
          <div className="flex-1 min-w-[200px]">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-400" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search tasks..."
                className="w-full pl-10 pr-4 py-2 bg-zinc-900 border border-zinc-700 rounded-lg text-white placeholder-zinc-500 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
          </div>

          {/* Area filter */}
          <select
            value={selectedArea}
            onChange={(e) => setSelectedArea(e.target.value)}
            className="px-4 py-2 bg-zinc-900 border border-zinc-700 rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="all">All Areas</option>
            <option value="School">🎓 School</option>
            <option value="Apps">🚀 Apps</option>
            <option value="DSA">💻 DSA</option>
            <option value="Career">💼 Career</option>
            <option value="Fitness">💪 Fitness</option>
          </select>

          {/* Energy filter */}
          <select
            value={selectedEnergy}
            onChange={(e) => setSelectedEnergy(e.target.value)}
            className="px-4 py-2 bg-zinc-900 border border-zinc-700 rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="all">All Energy</option>
            <option value="low">🟢 Low</option>
            <option value="medium">🟡 Medium</option>
            <option value="high">🔴 High</option>
          </select>

          {/* Show completed */}
          <label className="flex items-center gap-2 text-white cursor-pointer">
            <input
              type="checkbox"
              checked={showCompleted}
              onChange={(e) => setShowCompleted(e.target.checked)}
              className="w-4 h-4 rounded bg-zinc-900 border-zinc-700"
            />
            <span className="text-sm">Show completed</span>
          </label>
        </div>

        {/* In Progress Section */}
        {groupedTasks.inProgress.length > 0 && (
          <div className="space-y-4">
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-blue-500 animate-pulse" />
              <h2 className="text-xl font-bold text-white">In Progress</h2>
              <span className="text-sm text-zinc-400">({groupedTasks.inProgress.length})</span>
            </div>
            <div className="space-y-3">
              {groupedTasks.inProgress.map(task => (
                <AtomicTaskCard
                  key={task.id}
                  task={task}
                  onComplete={() => handleComplete(task)}
                  onBreakdown={() => setBreakdownModalTask(task)}
                  onLog={() => setLogModalTask(task)}
                />
              ))}
            </div>
          </div>
        )}

        {/* Atomic Todo Section */}
        {groupedTasks.atomicTodo.length > 0 && (
          <div className="space-y-4">
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-green-500" />
              <h2 className="text-xl font-bold text-white">⚛️ Atomic Tasks Ready</h2>
              <span className="text-sm text-zinc-400">({groupedTasks.atomicTodo.length})</span>
            </div>
            <div className="space-y-3">
              {groupedTasks.atomicTodo.map(task => (
                <AtomicTaskCard
                  key={task.id}
                  task={task}
                  onComplete={() => handleComplete(task)}
                  onBreakdown={() => setBreakdownModalTask(task)}
                  onLog={() => setLogModalTask(task)}
                />
              ))}
            </div>
          </div>
        )}

        {/* Non-Atomic Section */}
        {groupedTasks.nonAtomicTodo.length > 0 && (
          <div className="space-y-4">
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-orange-500" />
              <h2 className="text-xl font-bold text-white">🔨 Needs Breakdown</h2>
              <span className="text-sm text-zinc-400">({groupedTasks.nonAtomicTodo.length})</span>
              <span className="text-xs text-orange-400">(Break these down for better focus)</span>
            </div>
            <div className="space-y-3">
              {groupedTasks.nonAtomicTodo.map(task => (
                <AtomicTaskCard
                  key={task.id}
                  task={task}
                  onComplete={() => handleComplete(task)}
                  onBreakdown={() => setBreakdownModalTask(task)}
                  onLog={() => setLogModalTask(task)}
                />
              ))}
            </div>
          </div>
        )}

        {/* Completed Section */}
        {showCompleted && groupedTasks.completed.length > 0 && (
          <div className="space-y-4">
            <div className="flex items-center gap-2">
              <CheckCircle className="w-5 h-5 text-green-500" />
              <h2 className="text-xl font-bold text-white">Completed</h2>
              <span className="text-sm text-zinc-400">({groupedTasks.completed.length})</span>
            </div>
            <div className="space-y-3">
              {groupedTasks.completed.map(task => (
                <AtomicTaskCard
                  key={task.id}
                  task={task}
                  onComplete={() => handleComplete(task)}
                  onBreakdown={() => setBreakdownModalTask(task)}
                  onLog={() => setLogModalTask(task)}
                />
              ))}
            </div>
          </div>
        )}

        {/* Empty state */}
        {filteredTasks.length === 0 && (
          <div className="text-center py-12">
            <div className="text-6xl mb-4">✨</div>
            <h3 className="text-xl font-semibold text-white mb-2">No tasks found</h3>
            <p className="text-zinc-400">Try adjusting your filters or load some mock data from Settings</p>
          </div>
        )}
      </div>

      {/* Modals */}
      {breakdownModalTask && (
        <TaskBreakdownModal
          task={breakdownModalTask}
          onClose={() => setBreakdownModalTask(null)}
          onBreakdown={(subtasks) => handleBreakdown(breakdownModalTask, subtasks)}
        />
      )}

      {logModalTask && (
        <LogEntryModal
          task={logModalTask}
          onClose={() => setLogModalTask(null)}
          onLog={(data) => handleLog(logModalTask, data)}
        />
      )}
    </div>
  );
}

