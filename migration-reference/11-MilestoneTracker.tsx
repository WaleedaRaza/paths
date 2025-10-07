import React from 'react';
import { CheckCircle, Circle, Award } from 'lucide-react';
interface Milestone {
  id: string;
  title: string;
  done: boolean;
  points?: number;
  order?: number;
}

interface GoalLike {
  milestones?: Milestone[];
}

interface MilestoneTrackerProps {
  milestones?: Milestone[];
  goal?: GoalLike;
  onToggleMilestone?: (milestoneId: string) => void;
  compact?: boolean;
}

export function MilestoneTracker({ milestones: propMilestones, goal, onToggleMilestone, compact = false }: MilestoneTrackerProps) {
  const milestones = propMilestones || goal?.milestones || [];
  
  if (milestones.length === 0) {
    return null;
  }

  const completedCount = milestones.filter(m => m.done).length;
  const totalCount = milestones.length;
  const progressPercent = (completedCount / totalCount) * 100;
  const totalPoints = milestones.reduce((sum, m) => sum + (m.points || 0), 0);
  const earnedPoints = milestones.filter(m => m.done).reduce((sum, m) => sum + (m.points || 0), 0);

  // Sort by order if available
  const sortedMilestones = [...milestones].sort((a, b) => (a.order || 0) - (b.order || 0));

  if (compact) {
    return (
      <div className="space-y-2">
        {/* Progress bar */}
        <div className="flex items-center justify-between text-sm mb-1">
          <span className="text-zinc-400">Progress</span>
          <span className="text-white font-medium">
            {completedCount}/{totalCount} • {earnedPoints}/{totalPoints} pts
          </span>
        </div>
        <div className="h-2 bg-zinc-800 rounded-full overflow-hidden">
          <div
            className="h-full bg-gradient-to-r from-blue-500 to-purple-600 transition-all duration-500"
            style={{ width: `${progressPercent}%` }}
          />
        </div>

        {/* Milestone list (compact) */}
        <div className="space-y-1 mt-3">
          {sortedMilestones.map((milestone) => (
            <button
              key={milestone.id}
              onClick={() => onToggleMilestone?.(milestone.id)}
              className={`w-full flex items-center gap-2 px-3 py-2 rounded-lg transition-all ${
                milestone.done
                  ? 'bg-green-600/20 border border-green-600/30'
                  : 'bg-zinc-800/50 border border-zinc-700 hover:bg-zinc-800'
              }`}
            >
              {milestone.done ? (
                <CheckCircle className="w-4 h-4 text-green-400 flex-shrink-0" />
              ) : (
                <Circle className="w-4 h-4 text-zinc-500 flex-shrink-0" />
              )}
              <span className={`text-sm flex-1 text-left ${milestone.done ? 'text-green-300 line-through' : 'text-white'}`}>
                {milestone.title}
              </span>
              {milestone.points && (
                <span className={`text-xs font-medium px-2 py-1 rounded ${
                  milestone.done ? 'bg-green-600/30 text-green-300' : 'bg-zinc-700 text-zinc-400'
                }`}>
                  {milestone.points} pts
                </span>
              )}
            </button>
          ))}
        </div>
      </div>
    );
  }

  // Full version
  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 bg-gradient-to-br from-amber-500 to-orange-600 rounded-lg flex items-center justify-center">
            <Award className="w-5 h-5 text-white" />
          </div>
          <div>
            <h3 className="text-lg font-semibold text-white">Milestones</h3>
            <p className="text-sm text-zinc-400">
              {completedCount} of {totalCount} completed
            </p>
          </div>
        </div>
        
        <div className="text-right">
          <div className="text-2xl font-bold text-white">
            {earnedPoints}
            <span className="text-sm text-zinc-400 font-normal">/{totalPoints}</span>
          </div>
          <p className="text-xs text-zinc-400">points earned</p>
        </div>
      </div>

      {/* Progress bar */}
      <div>
        <div className="flex items-center justify-between text-sm mb-2">
          <span className="text-zinc-400">Overall Progress</span>
          <span className="text-white font-medium">{Math.round(progressPercent)}%</span>
        </div>
        <div className="h-3 bg-zinc-800 rounded-full overflow-hidden">
          <div
            className="h-full bg-gradient-to-r from-blue-500 via-purple-600 to-pink-600 transition-all duration-500"
            style={{ width: `${progressPercent}%` }}
          />
        </div>
      </div>

      {/* Milestone cards */}
      <div className="space-y-3">
        {sortedMilestones.map((milestone, index) => {
          const isLast = index === sortedMilestones.length - 1;
          return (
            <div key={milestone.id} className="relative">
              {/* Connector line */}
              {!isLast && (
                <div className="absolute left-6 top-12 w-0.5 h-full bg-zinc-700" />
              )}
              
              <button
                onClick={() => onToggleMilestone?.(milestone.id)}
                className={`relative w-full flex items-start gap-4 p-4 rounded-xl border-2 transition-all ${
                  milestone.done
                    ? 'bg-gradient-to-br from-green-600/20 to-emerald-600/20 border-green-600/50 shadow-lg shadow-green-600/20'
                    : 'bg-zinc-800/50 border-zinc-700 hover:border-zinc-600 hover:bg-zinc-800'
                }`}
              >
                {/* Icon */}
                <div className={`flex-shrink-0 w-12 h-12 rounded-full flex items-center justify-center border-2 transition-all ${
                  milestone.done
                    ? 'bg-green-600 border-green-400'
                    : 'bg-zinc-800 border-zinc-600'
                }`}>
                  {milestone.done ? (
                    <CheckCircle className="w-6 h-6 text-white" />
                  ) : (
                    <span className="text-lg font-bold text-zinc-400">{index + 1}</span>
                  )}
                </div>

                {/* Content */}
                <div className="flex-1 text-left">
                  <div className="flex items-start justify-between gap-4">
                    <h4 className={`font-semibold ${milestone.done ? 'text-green-300 line-through' : 'text-white'}`}>
                      {milestone.title}
                    </h4>
                    {milestone.points && (
                      <div className={`flex items-center gap-1 px-3 py-1 rounded-full text-sm font-bold ${
                        milestone.done
                          ? 'bg-green-600 text-white'
                          : 'bg-amber-600/20 text-amber-400 border border-amber-600/30'
                      }`}>
                        <Award className="w-4 h-4" />
                        {milestone.points} pts
                      </div>
                    )}
                  </div>
                  
                  {milestone.done && (
                    <p className="text-sm text-green-400 mt-1 flex items-center gap-2">
                      <CheckCircle className="w-4 h-4" />
                      Completed!
                    </p>
                  )}
                </div>
              </button>
            </div>
          );
        })}
      </div>

      {/* Celebration message */}
      {completedCount === totalCount && totalCount > 0 && (
        <div className="p-4 bg-gradient-to-r from-amber-600/20 to-orange-600/20 border-2 border-amber-600/50 rounded-xl">
          <div className="flex items-center gap-3">
            <div className="text-3xl">🎉</div>
            <div>
              <p className="font-semibold text-amber-300">All milestones completed!</p>
              <p className="text-sm text-amber-400/80">You earned {totalPoints} points total!</p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

