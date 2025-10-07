import React from 'react';
import { Award, TrendingUp, Zap } from 'lucide-react';
import { useAppStore } from '../store';

export function PointsDisplay() {
  const { tasks, goals } = useAppStore();

  // Calculate total points earned from completed tasks
  const totalTaskPoints = tasks
    .filter(t => t.status === 'completed')
    .reduce((sum, t) => sum + (t.pointsEarned || 0), 0);

  // Calculate total points from goal milestones
  const totalMilestonePoints = goals.reduce((sum, g) => {
    const milestonePoints = (g.milestones || [])
      .filter(m => m.done)
      .reduce((mSum, m) => mSum + (m.points || 0), 0);
    return sum + milestonePoints;
  }, 0);

  const totalPoints = totalTaskPoints + totalMilestonePoints;

  // Calculate level (every 500 points = 1 level)
  const level = Math.floor(totalPoints / 500) + 1;
  const pointsToNextLevel = 500 - (totalPoints % 500);
  const levelProgress = ((totalPoints % 500) / 500) * 100;

  // Calculate streak (consecutive days with completed tasks)
  const getStreak = () => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    const completedTasks = tasks
      .filter(t => t.status === 'completed' && t.completedAt)
      .sort((a, b) => new Date(b.completedAt!).getTime() - new Date(a.completedAt!).getTime());

    if (completedTasks.length === 0) return 0;

    let streak = 0;
    let currentDate = new Date(today);

    for (const task of completedTasks) {
      const completedDate = new Date(task.completedAt!);
      completedDate.setHours(0, 0, 0, 0);

      if (completedDate.getTime() === currentDate.getTime()) {
        streak++;
        currentDate.setDate(currentDate.getDate() - 1);
      } else if (completedDate.getTime() < currentDate.getTime()) {
        break;
      }
    }

    return streak > 0 ? Math.ceil(streak / 3) : 0; // Group by days (approx)
  };

  const streak = getStreak();

  // Calculate momentum (tasks completed this week)
  const weekAgo = new Date();
  weekAgo.setDate(weekAgo.getDate() - 7);
  
  const weeklyCompleted = tasks.filter(t => 
    t.status === 'completed' && 
    t.completedAt && 
    new Date(t.completedAt) >= weekAgo
  ).length;

  return (
    <div className="flex items-center gap-4 px-4 py-2 bg-gradient-to-r from-zinc-800/50 to-zinc-900/50 border border-zinc-700 rounded-xl">
      {/* Total Points & Level */}
      <div className="flex items-center gap-2 px-3 py-2 bg-gradient-to-br from-amber-600/20 to-orange-600/20 border border-amber-600/30 rounded-lg">
        <Award className="w-5 h-5 text-amber-400" />
        <div>
          <div className="flex items-baseline gap-1">
            <span className="text-lg font-bold text-white">{totalPoints.toLocaleString()}</span>
            <span className="text-xs text-amber-400">pts</span>
          </div>
          <div className="text-xs text-zinc-400">Level {level}</div>
        </div>
      </div>

      {/* Level Progress Bar */}
      <div className="hidden md:flex flex-col gap-1 min-w-[120px]">
        <div className="flex items-center justify-between text-xs">
          <span className="text-zinc-400">Next Level</span>
          <span className="text-amber-400 font-medium">{pointsToNextLevel} pts</span>
        </div>
        <div className="h-2 bg-zinc-800 rounded-full overflow-hidden">
          <div
            className="h-full bg-gradient-to-r from-amber-500 to-orange-600 transition-all duration-500"
            style={{ width: `${levelProgress}%` }}
          />
        </div>
      </div>

      {/* Streak */}
      {streak > 0 && (
        <div className="flex items-center gap-2 px-3 py-2 bg-gradient-to-br from-orange-600/20 to-red-600/20 border border-orange-600/30 rounded-lg">
          <Zap className="w-5 h-5 text-orange-400" />
          <div>
            <div className="text-lg font-bold text-white">{streak}</div>
            <div className="text-xs text-zinc-400">day streak</div>
          </div>
        </div>
      )}

      {/* Weekly Momentum */}
      <div className="hidden lg:flex items-center gap-2 px-3 py-2 bg-gradient-to-br from-blue-600/20 to-purple-600/20 border border-blue-600/30 rounded-lg">
        <TrendingUp className="w-5 h-5 text-blue-400" />
        <div>
          <div className="text-lg font-bold text-white">{weeklyCompleted}</div>
          <div className="text-xs text-zinc-400">this week</div>
        </div>
      </div>
    </div>
  );
}

