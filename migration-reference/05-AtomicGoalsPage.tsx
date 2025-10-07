import React, { useState, useMemo } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  Target, TrendingUp, Award, ChevronRight, ChevronDown,
  GraduationCap, Briefcase, Code, Dumbbell, Calendar,
  Plus, Filter, Search, Zap, Clock, CheckCircle,
  Play, Pause, MoreHorizontal, ArrowRight, ArrowDown
} from 'lucide-react';
import { useAppStore } from '../store';
import type { Goal, Task } from '../store';
import { MilestoneTracker } from '../components/MilestoneTracker';
import { PointsDisplay } from '../components/PointsDisplay';
import { AtomicGoalModal } from '../components/AtomicGoalModal';

// Enhanced Goal Card with full atomic framework integration
function AtomicGoalCard({ 
  goal, 
  linkedTasks, 
  onBreakdown, 
  onAddTask, 
  onViewTasks,
  isExpanded,
  onToggleExpanded 
}: { 
  goal: Goal;
  linkedTasks: Task[];
  onBreakdown: (goalId: string) => void;
  onAddTask: (goalId: string) => void;
  onViewTasks: (goalId: string) => void;
  isExpanded: boolean;
  onToggleExpanded: () => void;
}) {
  const { updateGoalProgress } = useAppStore();
  
  // Calculate progress from linked tasks
  const totalTasks = linkedTasks.length;
  const completedTasks = linkedTasks.filter(t => t.status === 'completed').length;
  const progressPercentage = totalTasks > 0 ? Math.round((completedTasks / totalTasks) * 100) : 0;
  
  // Calculate points earned
  const pointsEarned = linkedTasks
    .filter(t => t.status === 'completed')
    .reduce((sum, t) => sum + (t.pointsEarned || t.points || 0), 0);
  
  // Get goal type icon and color
  const getTypeIcon = (type?: string) => {
    switch (type) {
      case 'course': return <GraduationCap className="w-4 h-4" />;
      case 'project': return <Briefcase className="w-4 h-4" />;
      case 'dsa-pattern': return <Code className="w-4 h-4" />;
      case 'fitness': return <Dumbbell className="w-4 h-4" />;
      case 'term': return <Calendar className="w-4 h-4" />;
      default: return <Target className="w-4 h-4" />;
    }
  };
  
  const getTypeColor = (type?: string) => {
    switch (type) {
      case 'course': return 'border-blue-500/30 bg-blue-500/5';
      case 'project': return 'border-emerald-500/30 bg-emerald-500/5';
      case 'dsa-pattern': return 'border-purple-500/30 bg-purple-500/5';
      case 'fitness': return 'border-orange-500/30 bg-orange-500/5';
      case 'term': return 'border-zinc-500/30 bg-zinc-500/5';
      default: return 'border-zinc-500/30 bg-zinc-500/5';
    }
  };

  // Get status color
  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active': return 'text-emerald-400 bg-emerald-500/10';
      case 'planned': return 'text-blue-400 bg-blue-500/10';
      case 'paused': return 'text-amber-400 bg-amber-500/10';
      case 'completed': return 'text-purple-400 bg-purple-500/10';
      default: return 'text-zinc-400 bg-zinc-500/10';
    }
  };

  return (
    <motion.div
      layout
      className={`rounded-xl border-2 ${getTypeColor(goal.type)} p-6 transition-all duration-200 hover:shadow-lg`}
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -20 }}
    >
      {/* Header */}
      <div className="flex items-start justify-between mb-4">
        <div className="flex items-center gap-3">
          <div className="p-2 rounded-lg bg-zinc-800/50">
            {getTypeIcon(goal.type)}
          </div>
          <div>
            <div className="flex items-center gap-2 mb-1">
              <h3 className="font-semibold text-lg">{goal.title}</h3>
              <span className={`text-xs px-2 py-1 rounded-full ${getStatusColor(goal.status)}`}>
                {goal.status}
              </span>
            </div>
            <div className="flex items-center gap-4 text-sm text-zinc-400">
              <span>{goal.area}</span>
              {goal.targets && (
                <span>{goal.targets.amount} {goal.targets.unit}</span>
              )}
              {goal.timeWindow && (
                <span>{new Date(goal.timeWindow.start).toLocaleDateString()} - {new Date(goal.timeWindow.end).toLocaleDateString()}</span>
              )}
            </div>
          </div>
        </div>
        
        <div className="flex items-center gap-2">
          <div className="text-right">
            <div className="text-2xl font-bold text-white">{pointsEarned}</div>
            <div className="text-xs text-zinc-400">points</div>
          </div>
          <button
            onClick={onToggleExpanded}
            className="p-2 hover:bg-zinc-800/50 rounded-lg transition-colors"
          >
            {isExpanded ? <ChevronDown className="w-4 h-4" /> : <ChevronRight className="w-4 h-4" />}
          </button>
        </div>
      </div>

      {/* Progress Section */}
      <div className="mb-4">
        <div className="flex items-center justify-between mb-2">
          <span className="text-sm font-medium">Progress</span>
          <span className="text-sm text-zinc-400">{completedTasks}/{totalTasks} tasks</span>
        </div>
        <div className="w-full bg-zinc-800/50 rounded-full h-2">
          <motion.div 
            className="h-2 bg-gradient-to-r from-blue-500 to-emerald-500 rounded-full"
            initial={{ width: 0 }}
            animate={{ width: `${progressPercentage}%` }}
            transition={{ duration: 0.8, ease: "easeOut" }}
          />
        </div>
        <div className="text-center text-sm text-zinc-400 mt-1">{progressPercentage}%</div>
      </div>

      {/* Milestones */}
      {goal.milestones && goal.milestones.length > 0 && (
        <div className="mb-4">
          <MilestoneTracker 
            milestones={goal.milestones}
            compact={true}
          />
        </div>
      )}

      {/* Quick Actions */}
      <div className="flex items-center gap-2 mb-4">
        <button
          onClick={() => onAddTask(goal.id)}
          className="flex-1 bg-blue-600/20 hover:bg-blue-600/30 text-blue-400 px-3 py-2 rounded-lg text-sm font-medium transition-colors flex items-center justify-center gap-2"
        >
          <Plus className="w-4 h-4" />
          Add Task
        </button>
        <button
          onClick={() => onBreakdown(goal.id)}
          className="flex-1 bg-purple-600/20 hover:bg-purple-600/30 text-purple-400 px-3 py-2 rounded-lg text-sm font-medium transition-colors flex items-center justify-center gap-2"
        >
          <Zap className="w-4 h-4" />
          Break Down
        </button>
        <button
          onClick={() => onViewTasks(goal.id)}
          className="flex-1 bg-emerald-600/20 hover:bg-emerald-600/30 text-emerald-400 px-3 py-2 rounded-lg text-sm font-medium transition-colors flex items-center justify-center gap-2"
        >
          <ArrowRight className="w-4 h-4" />
          View Tasks
        </button>
      </div>

      {/* Expanded Content */}
      <AnimatePresence>
        {isExpanded && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: "auto" }}
            exit={{ opacity: 0, height: 0 }}
            className="border-t border-zinc-700/50 pt-4"
          >
            {/* Linked Tasks Preview */}
            {linkedTasks.length > 0 ? (
              <div>
                <h4 className="text-sm font-medium mb-3 text-zinc-300">Linked Tasks ({linkedTasks.length})</h4>
                <div className="space-y-2">
                  {linkedTasks.slice(0, 5).map(task => (
                    <div key={task.id} className="flex items-center justify-between p-3 bg-zinc-800/30 rounded-lg">
                      <div className="flex items-center gap-3">
                        <div className={`w-2 h-2 rounded-full ${
                          task.status === 'completed' ? 'bg-emerald-400' :
                          task.status === 'in_progress' ? 'bg-blue-400' :
                          'bg-zinc-400'
                        }`} />
                        <div>
                          <div className="text-sm font-medium">{task.title}</div>
                          <div className="text-xs text-zinc-400">
                            {task.estimateMin}min • {task.energy} energy • {task.points || 0} pts
                          </div>
                        </div>
                      </div>
                      <div className="text-xs text-zinc-400">
                        {task.status === 'completed' ? '✅' : 
                         task.status === 'in_progress' ? '🔄' : '⏳'}
                      </div>
                    </div>
                  ))}
                  {linkedTasks.length > 5 && (
                    <div className="text-center text-xs text-zinc-400 py-2">
                      +{linkedTasks.length - 5} more tasks
                    </div>
                  )}
                </div>
              </div>
            ) : (
              <div className="text-center py-4 text-zinc-400">
                <Target className="w-8 h-8 mx-auto mb-2 opacity-50" />
                <p className="text-sm">No tasks linked yet</p>
                <p className="text-xs">Add tasks to start making progress</p>
              </div>
            )}
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
}

// Goal Hierarchy View
function GoalHierarchy({ goals, tasks, onAction }: {
  goals: Goal[];
  tasks: Task[];
  onAction: (action: string, goalId: string) => void;
}) {
  const [expandedGoals, setExpandedGoals] = useState<Set<string>>(new Set());
  
  // Organize goals by hierarchy
  const hierarchy = useMemo(() => {
    const termGoals = goals.filter(g => g.type === 'term');
    const courseGoals = goals.filter(g => g.type === 'course');
    const projectGoals = goals.filter(g => g.type === 'project');
    const otherGoals = goals.filter(g => !['term', 'course', 'project'].includes(g.type || ''));
    
    return { termGoals, courseGoals, projectGoals, otherGoals };
  }, [goals]);

  const toggleExpanded = (goalId: string) => {
    const newExpanded = new Set(expandedGoals);
    if (newExpanded.has(goalId)) {
      newExpanded.delete(goalId);
    } else {
      newExpanded.add(goalId);
    }
    setExpandedGoals(newExpanded);
  };

  const getLinkedTasks = (goal: Goal) => {
    return tasks.filter(task => 
      task.goalLinks?.some(link => link.goalId === goal.id)
    );
  };

  return (
    <div className="space-y-6">
      {/* Term Goals */}
      {hierarchy.termGoals.length > 0 && (
        <section>
          <div className="flex items-center gap-3 mb-4">
            <Calendar className="w-5 h-5 text-blue-400" />
            <h2 className="text-xl font-bold">Term Goals</h2>
            <span className="bg-blue-500/20 text-blue-400 text-xs px-2 py-1 rounded">
              {hierarchy.termGoals.length}
            </span>
          </div>
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
            {hierarchy.termGoals.map(goal => (
              <AtomicGoalCard
                key={goal.id}
                goal={goal}
                linkedTasks={getLinkedTasks(goal)}
                onBreakdown={(goalId) => onAction('breakdown', goalId)}
                onAddTask={(goalId) => onAction('addTask', goalId)}
                onViewTasks={(goalId) => onAction('viewTasks', goalId)}
                isExpanded={expandedGoals.has(goal.id)}
                onToggleExpanded={() => toggleExpanded(goal.id)}
              />
            ))}
          </div>
        </section>
      )}

      {/* Course Goals */}
      {hierarchy.courseGoals.length > 0 && (
        <section>
          <div className="flex items-center gap-3 mb-4">
            <GraduationCap className="w-5 h-5 text-emerald-400" />
            <h2 className="text-xl font-bold">Course Goals</h2>
            <span className="bg-emerald-500/20 text-emerald-400 text-xs px-2 py-1 rounded">
              {hierarchy.courseGoals.length}
            </span>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {hierarchy.courseGoals.map(goal => (
              <AtomicGoalCard
                key={goal.id}
                goal={goal}
                linkedTasks={getLinkedTasks(goal)}
                onBreakdown={(goalId) => onAction('breakdown', goalId)}
                onAddTask={(goalId) => onAction('addTask', goalId)}
                onViewTasks={(goalId) => onAction('viewTasks', goalId)}
                isExpanded={expandedGoals.has(goal.id)}
                onToggleExpanded={() => toggleExpanded(goal.id)}
              />
            ))}
          </div>
        </section>
      )}

      {/* Project Goals */}
      {hierarchy.projectGoals.length > 0 && (
        <section>
          <div className="flex items-center gap-3 mb-4">
            <Briefcase className="w-5 h-5 text-purple-400" />
            <h2 className="text-xl font-bold">Project Goals</h2>
            <span className="bg-purple-500/20 text-purple-400 text-xs px-2 py-1 rounded">
              {hierarchy.projectGoals.length}
            </span>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {hierarchy.projectGoals.map(goal => (
              <AtomicGoalCard
                key={goal.id}
                goal={goal}
                linkedTasks={getLinkedTasks(goal)}
                onBreakdown={(goalId) => onAction('breakdown', goalId)}
                onAddTask={(goalId) => onAction('addTask', goalId)}
                onViewTasks={(goalId) => onAction('viewTasks', goalId)}
                isExpanded={expandedGoals.has(goal.id)}
                onToggleExpanded={() => toggleExpanded(goal.id)}
              />
            ))}
          </div>
        </section>
      )}

      {/* Other Goals */}
      {hierarchy.otherGoals.length > 0 && (
        <section>
          <div className="flex items-center gap-3 mb-4">
            <Target className="w-5 h-5 text-amber-400" />
            <h2 className="text-xl font-bold">Other Goals</h2>
            <span className="bg-amber-500/20 text-amber-400 text-xs px-2 py-1 rounded">
              {hierarchy.otherGoals.length}
            </span>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {hierarchy.otherGoals.map(goal => (
              <AtomicGoalCard
                key={goal.id}
                goal={goal}
                linkedTasks={getLinkedTasks(goal)}
                onBreakdown={(goalId) => onAction('breakdown', goalId)}
                onAddTask={(goalId) => onAction('addTask', goalId)}
                onViewTasks={(goalId) => onAction('viewTasks', goalId)}
                isExpanded={expandedGoals.has(goal.id)}
                onToggleExpanded={() => toggleExpanded(goal.id)}
              />
            ))}
          </div>
        </section>
      )}
    </div>
  );
}

export function AtomicGoalsPage() {
  const { goals, tasks, addGoal, breakdownTask } = useAppStore();
  const [selectedGoal, setSelectedGoal] = useState<Goal | null>(null);
  const [showGoalModal, setShowGoalModal] = useState(false);
  const [showTaskModal, setShowTaskModal] = useState(false);
  const [showBreakdownModal, setShowBreakdownModal] = useState(false);

  // Calculate overall stats
  const stats = useMemo(() => {
    const totalGoals = goals.length;
    const activeGoals = goals.filter(g => g.status === 'active').length;
    const completedGoals = goals.filter(g => g.status === 'completed').length;
    
    const totalTasks = tasks.length;
    const linkedTasks = tasks.filter(t => t.goalLinks && t.goalLinks.length > 0).length;
    const completedTasks = tasks.filter(t => t.status === 'completed').length;
    
    const totalPoints = tasks
      .filter(t => t.status === 'completed')
      .reduce((sum, t) => sum + (t.pointsEarned || t.points || 0), 0);

    return {
      totalGoals,
      activeGoals,
      completedGoals,
      totalTasks,
      linkedTasks,
      completedTasks,
      totalPoints
    };
  }, [goals, tasks]);

  const handleGoalAction = (action: string, goalId: string) => {
    const goal = goals.find(g => g.id === goalId);
    if (!goal) return;

    setSelectedGoal(goal);

    switch (action) {
      case 'breakdown':
        setShowBreakdownModal(true);
        break;
      case 'addTask':
        setShowTaskModal(true);
        break;
      case 'viewTasks':
        // Navigate to tasks page filtered by this goal
        window.location.hash = `#/tasks?goal=${goalId}`;
        break;
    }
  };

  return (
    <div className="p-6 max-w-7xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-3xl font-bold mb-2">Goals Dashboard</h1>
          <p className="text-zinc-400">Track progress and manage goal-task associations</p>
        </div>
        <div className="flex items-center gap-3">
          <PointsDisplay />
          <button
            onClick={() => {
              setSelectedGoal(null);
              setShowGoalModal(true);
            }}
            className="btn-primary flex items-center gap-2"
          >
            <Plus className="w-4 h-4" />
            New Goal
          </button>
        </div>
      </div>

      {/* Stats Overview */}
      <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-7 gap-4 mb-8">
        <div className="bg-zinc-800/50 p-4 rounded-lg border border-zinc-700/50">
          <div className="text-2xl font-bold text-blue-400">{stats.totalGoals}</div>
          <div className="text-sm text-zinc-400">Total Goals</div>
        </div>
        <div className="bg-zinc-800/50 p-4 rounded-lg border border-zinc-700/50">
          <div className="text-2xl font-bold text-emerald-400">{stats.activeGoals}</div>
          <div className="text-sm text-zinc-400">Active</div>
        </div>
        <div className="bg-zinc-800/50 p-4 rounded-lg border border-zinc-700/50">
          <div className="text-2xl font-bold text-purple-400">{stats.completedGoals}</div>
          <div className="text-sm text-zinc-400">Completed</div>
        </div>
        <div className="bg-zinc-800/50 p-4 rounded-lg border border-zinc-700/50">
          <div className="text-2xl font-bold text-amber-400">{stats.totalTasks}</div>
          <div className="text-sm text-zinc-400">Total Tasks</div>
        </div>
        <div className="bg-zinc-800/50 p-4 rounded-lg border border-zinc-700/50">
          <div className="text-2xl font-bold text-orange-400">{stats.linkedTasks}</div>
          <div className="text-sm text-zinc-400">Linked</div>
        </div>
        <div className="bg-zinc-800/50 p-4 rounded-lg border border-zinc-700/50">
          <div className="text-2xl font-bold text-green-400">{stats.completedTasks}</div>
          <div className="text-sm text-zinc-400">Done</div>
        </div>
        <div className="bg-zinc-800/50 p-4 rounded-lg border border-zinc-700/50">
          <div className="text-2xl font-bold text-yellow-400">{stats.totalPoints}</div>
          <div className="text-sm text-zinc-400">Points</div>
        </div>
      </div>

      {/* Goals Content */}
      {goals.length > 0 ? (
        <GoalHierarchy
          goals={goals}
          tasks={tasks}
          onAction={handleGoalAction}
        />
      ) : (
        <div className="text-center py-12">
          <Target className="w-16 h-16 text-zinc-600 mx-auto mb-4" />
          <h3 className="text-xl font-medium text-zinc-400 mb-2">No goals yet</h3>
          <p className="text-zinc-500 mb-6">Create your first goal to start tracking progress</p>
          <button
            onClick={() => {
              setSelectedGoal(null);
              setShowGoalModal(true);
            }}
            className="btn-primary"
          >
            Create First Goal
          </button>
        </div>
      )}

      {/* Goal Modal */}
      {showGoalModal && (
        <AtomicGoalModal
          goal={selectedGoal}
          onSave={(goalData) => {
            if (selectedGoal) {
              // Update existing goal
              console.log('Update goal:', selectedGoal.id, goalData);
            } else {
              // Create new goal
              addGoal(goalData);
            }
            setShowGoalModal(false);
            setSelectedGoal(null);
          }}
          onDelete={selectedGoal ? () => {
            console.log('Delete goal:', selectedGoal.id);
            setShowGoalModal(false);
            setSelectedGoal(null);
          } : undefined}
          onClose={() => {
            setShowGoalModal(false);
            setSelectedGoal(null);
          }}
        />
      )}
    </div>
  );
}

export default AtomicGoalsPage;