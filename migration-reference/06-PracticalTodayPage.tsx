import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  Target, TrendingUp, Plus, Calendar,
  CheckCircle2, Circle, Clock, Zap
} from 'lucide-react';
import { useAppStore } from '../store';
import { TaskModal } from '../components/TaskModal';
import { smartAggregationEngine, type SmartRecommendation } from '../services/smartAggregation';

// Import new practical components
import { DragDropDailyPlanner } from '../components/DragDropDailyPlanner';
import { PlanningAssistant } from '../components/PlanningAssistant';
import { SimpleWorkoutSelector } from '../components/SimpleWorkoutSelector';
import { InteractiveMustWins } from '../components/InteractiveMustWins';
import { InteractiveNextUp } from '../components/InteractiveNextUp';
import { ContextSwitchOptimizer, QuickWinsDetector } from '../components/CreativeProductivityFeatures';

// Simplified Must Wins without abstract metrics
const PracticalMustWins: React.FC<{
  recommendations: SmartRecommendation[];
  onRefresh: () => void;
  isLoading: boolean;
}> = ({ recommendations, onRefresh, isLoading }) => {
  const { ui, updateUI, completeTask } = useAppStore();
  const mustWinRecommendations = recommendations.filter(r => r.type === 'must_win');

  const handleTaskComplete = (taskId: string) => {
    completeTask(taskId);
    onRefresh(); // Refresh recommendations after completing a task
  };

  return (
    <div className="card-dark p-6">
      <div className="flex items-center justify-between mb-4">
        <div>
          <h2 className="text-lg font-semibold flex items-center gap-2">
            <Target className="w-5 h-5 text-blue-400" />
            Must Wins Today
            <span className="text-sm text-zinc-400">({mustWinRecommendations.length}/3)</span>
          </h2>
          <p className="text-sm text-zinc-400">Most important tasks for today</p>
        </div>
      </div>

      <div className="space-y-3">
        {mustWinRecommendations.map((rec, index) => (
          <motion.div
            key={rec.task.id}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
            className="bg-zinc-800/50 rounded-lg p-4 border border-zinc-700/50"
          >
            <div className="flex items-start gap-3">
              <button
                onClick={() => handleTaskComplete(rec.task.id)}
                className="mt-1 w-5 h-5 rounded border-2 border-blue-400 hover:bg-blue-400 transition-colors flex items-center justify-center"
                title="Mark as complete"
              >
                {rec.task.status === 'completed' && <CheckCircle2 className="w-4 h-4 text-white" />}
              </button>
              
              <div className="flex-1">
                <div className="flex items-center gap-2 mb-2">
                  <h3 className="font-medium text-zinc-200">{rec.task.title}</h3>
                  <span className="text-xs bg-blue-600 text-white px-2 py-1 rounded">
                    Priority #{index + 1}
                  </span>
                </div>
                
                <p className="text-sm text-zinc-400 mb-2">{rec.reasoning}</p>
                
                {rec.actionSuggestion && (
                  <div className="text-sm text-blue-300">
                    💡 {rec.actionSuggestion}
                  </div>
                )}
                
                {rec.task.due && (
                  <div className="text-xs text-orange-300 mt-2 flex items-center gap-1">
                    <Clock className="w-3 h-3" />
                    Due: {new Date(rec.task.due).toLocaleDateString()}
                  </div>
                )}
              </div>
            </div>
          </motion.div>
        ))}

        {mustWinRecommendations.length === 0 && !isLoading && (
          <div className="text-center py-8 text-zinc-500">
            <Target className="w-8 h-8 mx-auto mb-2 opacity-50" />
            <div>No priority tasks identified</div>
            <div className="text-xs mt-1">Add tasks to get AI-powered priorities</div>
          </div>
        )}
      </div>
    </div>
  );
};

// Simplified Next Up without abstract scoring
const PracticalNextUp: React.FC<{
  recommendations: SmartRecommendation[];
  onRefresh: () => void;
  isLoading: boolean;
}> = ({ recommendations, onRefresh, isLoading }) => {
  const { completeTask } = useAppStore();
  const nextUpRecommendations = recommendations.filter(r => r.type === 'next_up');

  const handleTaskComplete = (taskId: string) => {
    completeTask(taskId);
    onRefresh();
  };

  return (
    <div className="card-dark p-6">
      <div className="flex items-center justify-between mb-4">
        <div>
          <h2 className="text-lg font-semibold flex items-center gap-2">
            <TrendingUp className="w-5 h-5 text-green-400" />
            Next Up
          </h2>
          <p className="text-sm text-zinc-400">Ready-to-start tasks in priority order</p>
        </div>
      </div>

      <div className="space-y-2">
        {nextUpRecommendations.slice(0, 6).map((rec, index) => (
          <motion.div
            key={rec.task.id}
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: index * 0.1 }}
            className="flex items-center gap-3 p-3 bg-zinc-800/30 rounded-lg hover:bg-zinc-800/50 transition-colors"
          >
            <div className="text-xs text-zinc-400 w-6 text-center">#{index + 1}</div>
            
            <button
              onClick={() => handleTaskComplete(rec.task.id)}
              className="w-4 h-4 rounded border border-zinc-500 hover:bg-green-600 hover:border-green-600 transition-colors"
            />
            
            <div className="flex-1">
              <div className="font-medium text-zinc-200">{rec.task.title}</div>
              <div className="text-xs text-zinc-400">{rec.reasoning}</div>
            </div>
            
            <div className="flex items-center gap-2 text-xs text-zinc-400">
              {rec.task.estimatedDuration && (
                <span>{rec.task.estimatedDuration}m</span>
              )}
              {rec.task.area && (
                <span className="bg-zinc-700 px-2 py-1 rounded">{rec.task.area}</span>
              )}
            </div>
          </motion.div>
        ))}

        {nextUpRecommendations.length === 0 && !isLoading && (
          <div className="text-center py-6 text-zinc-500">
            <div>No next-up tasks available</div>
          </div>
        )}
      </div>
    </div>
  );
};

// Urgent Tasks Alert
const UrgentTasksAlert: React.FC<{ 
  recommendations: SmartRecommendation[] 
}> = ({ recommendations }) => {
  const urgentRecommendations = recommendations.filter(r => r.type === 'urgent');
  
  if (urgentRecommendations.length === 0) return null;

  return (
    <motion.div
      initial={{ opacity: 0, y: -20 }}
      animate={{ opacity: 1, y: 0 }}
      className="card-dark p-4 border-l-4 border-red-500 mb-6"
    >
      <h3 className="font-semibold text-red-400 mb-2 flex items-center gap-2">
        <Zap className="w-4 h-4" />
        Urgent Attention Required
      </h3>
      <div className="space-y-2">
        {urgentRecommendations.map(rec => (
          <div key={rec.task.id} className="flex items-center gap-3 text-sm">
            <Circle className="w-4 h-4 text-red-400" />
            <span className="text-zinc-200 flex-1">{rec.task.title}</span>
            <span className="text-red-300">• {rec.reasoning}</span>
          </div>
        ))}
      </div>
    </motion.div>
  );
};

// Main Practical Today Page
export default function PracticalTodayPage() {
  const { tasks, goals, sessions, addTask } = useAppStore();
  const [showTaskModal, setShowTaskModal] = useState(false);
  const [selectedTask, setSelectedTask] = useState<any>(null);
  const [smartRecommendations, setSmartRecommendations] = useState<{
    mustWins: SmartRecommendation[];
    nextUp: SmartRecommendation[];
    urgent: SmartRecommendation[];
  }>({ mustWins: [], nextUp: [], urgent: [] });
  const [isGeneratingRecommendations, setIsGeneratingRecommendations] = useState(false);

  const generateSmartRecommendations = async () => {
    setIsGeneratingRecommendations(true);
    try {
      console.log('🧠 Generating practical recommendations...');
      const recommendations = await smartAggregationEngine.generateSmartRecommendations({
        tasks: tasks.filter(t => t.status !== 'completed' && t.status !== 'archived'), // Only incomplete tasks
        goals,
        sessions,
        currentHour: new Date().getHours()
      });
      
      setSmartRecommendations({
        mustWins: recommendations.mustWins,
        nextUp: recommendations.nextUp,
        urgent: recommendations.urgent
      });
      console.log('✨ Practical recommendations generated');
    } catch (error) {
      console.error('Failed to generate recommendations:', error);
    } finally {
      setIsGeneratingRecommendations(false);
    }
  };

  useEffect(() => {
    generateSmartRecommendations();
  }, [tasks.length]); // Regenerate when tasks change

  const handleSaveTask = (taskData: any) => {
    if (selectedTask) {
      // Handle task update if needed
    } else {
      addTask(taskData);
    }
    setShowTaskModal(false);
    setSelectedTask(null);
    
    // Regenerate recommendations after adding new task
    setTimeout(() => generateSmartRecommendations(), 500);
  };

  const allRecommendations = [
    ...smartRecommendations.mustWins,
    ...smartRecommendations.nextUp,
    ...smartRecommendations.urgent
  ];

  return (
    <>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold">Today</h1>
            <p className="text-zinc-400">Your daily planning command center</p>
          </div>
          <button
            onClick={() => setShowTaskModal(true)}
            className="btn-primary flex items-center gap-2"
          >
            <Plus className="w-4 h-4" />
            Add Task
          </button>
        </div>

        {/* Urgent Tasks Alert */}
        <UrgentTasksAlert recommendations={allRecommendations} />

        {/* Main Layout - Full Width Organized */}
        <div className="space-y-6">
          {/* Top Priority Row - Must Wins & Next Up */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <InteractiveMustWins />
            <InteractiveNextUp />
          </div>

          {/* Daily Schedule - Full Width */}
          <div className="bg-zinc-800/30 rounded-lg border border-zinc-700/50">
            <div className="p-6 border-b border-zinc-700/50">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <Calendar className="w-5 h-5 text-green-400" />
                  <h2 className="text-xl font-semibold text-green-400">Today's Schedule</h2>
                </div>
                <div className="text-sm text-zinc-400">
                  {new Date().toLocaleDateString('en-US', { 
                    weekday: 'long', 
                    year: 'numeric', 
                    month: 'long', 
                    day: 'numeric' 
                  })}
                </div>
              </div>
            </div>
            <div className="p-6">
              <DragDropDailyPlanner />
            </div>
          </div>

          {/* Bottom Row - Fitness & AI Assistant */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <SimpleWorkoutSelector />
            <PlanningAssistant />
          </div>
        </div>
      </div>

      {/* Task Modal */}
      {showTaskModal && (
        <TaskModal 
          task={selectedTask}
          onSave={handleSaveTask}
          onDelete={selectedTask ? () => {} : undefined}
          onClose={() => setShowTaskModal(false)}
        />
      )}
    </>
  );
}
