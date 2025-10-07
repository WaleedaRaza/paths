import React, { useMemo } from 'react';
import { TrendingUp, TrendingDown, Minus, Calendar } from 'lucide-react';
import { useAppStore, Task } from '../store';

interface ProgressGraphProps {
  type: 'fitness' | 'dsa' | 'tasks' | 'points';
  taskId?: string; // For specific task graphs
  days?: number; // Number of days to show
}

export function ProgressGraph({ type, taskId, days = 30 }: ProgressGraphProps) {
  const { tasks } = useAppStore();

  // Get data based on type
  const graphData = useMemo(() => {
    const endDate = new Date();
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    const dataPoints: { date: string; value: number; label: string }[] = [];

    if (type === 'tasks') {
      // Tasks completed per day
      for (let i = 0; i <= days; i++) {
        const date = new Date(startDate);
        date.setDate(date.getDate() + i);
        const dateStr = date.toISOString().split('T')[0];

        const completedCount = tasks.filter(t => {
          if (!t.completedAt) return false;
          const completedDate = new Date(t.completedAt).toISOString().split('T')[0];
          return completedDate === dateStr;
        }).length;

        dataPoints.push({
          date: dateStr,
          value: completedCount,
          label: `${completedCount} tasks`
        });
      }
    } else if (type === 'points') {
      // Points earned per day
      for (let i = 0; i <= days; i++) {
        const date = new Date(startDate);
        date.setDate(date.getDate() + i);
        const dateStr = date.toISOString().split('T')[0];

        const pointsEarned = tasks
          .filter(t => {
            if (!t.completedAt) return false;
            const completedDate = new Date(t.completedAt).toISOString().split('T')[0];
            return completedDate === dateStr;
          })
          .reduce((sum, t) => sum + (t.pointsEarned || 0), 0);

        dataPoints.push({
          date: dateStr,
          value: pointsEarned,
          label: `${pointsEarned} pts`
        });
      }
    } else if (type === 'fitness' && taskId) {
      // Fitness: Weight progression for specific exercise
      const task = tasks.find(t => t.id === taskId);
      if (task && task.logEntries) {
        task.logEntries.forEach(entry => {
          const entryDate = new Date(entry.timestamp).toISOString().split('T')[0];
          if (entry.data.exercises && entry.data.exercises.length > 0) {
            const maxWeight = Math.max(...entry.data.exercises.map((ex: any) => ex.weight || 0));
            dataPoints.push({
              date: entryDate,
              value: maxWeight,
              label: `${maxWeight} lbs`
            });
          }
        });
      }
    } else if (type === 'dsa' && taskId) {
      // DSA: Problems solved over time
      const task = tasks.find(t => t.id === taskId);
      if (task && task.logEntries) {
        let cumulativeSolved = 0;
        task.logEntries.forEach(entry => {
          if (entry.data.solved) {
            cumulativeSolved++;
          }
          const entryDate = new Date(entry.timestamp).toISOString().split('T')[0];
          dataPoints.push({
            date: entryDate,
            value: cumulativeSolved,
            label: `${cumulativeSolved} solved`
          });
        });
      }
    }

    return dataPoints;
  }, [tasks, type, taskId, days]);

  // Calculate stats
  const stats = useMemo(() => {
    if (graphData.length === 0) {
      return {
        current: 0,
        previous: 0,
        change: 0,
        trend: 'flat' as 'up' | 'down' | 'flat',
        max: 0,
        avg: 0
      };
    }

    const values = graphData.map(d => d.value);
    const current = values[values.length - 1] || 0;
    const previous = values[values.length - 2] || 0;
    const change = current - previous;
    const trend = change > 0 ? 'up' : change < 0 ? 'down' : 'flat';
    const max = Math.max(...values);
    const avg = values.reduce((sum, v) => sum + v, 0) / values.length;

    return { current, previous, change, trend, max, avg: Math.round(avg) };
  }, [graphData]);

  const maxValue = stats.max || 1;

  const getTypeLabel = () => {
    switch (type) {
      case 'tasks': return '📋 Tasks Completed';
      case 'points': return '🏆 Points Earned';
      case 'fitness': return '💪 Weight Progression';
      case 'dsa': return '💻 Problems Solved';
      default: return 'Progress';
    }
  };

  const getTypeColor = () => {
    switch (type) {
      case 'tasks': return 'from-blue-500 to-purple-600';
      case 'points': return 'from-amber-500 to-orange-600';
      case 'fitness': return 'from-red-500 to-orange-600';
      case 'dsa': return 'from-green-500 to-emerald-600';
      default: return 'from-zinc-500 to-zinc-600';
    }
  };

  if (graphData.length === 0) {
    return (
      <div className="p-6 bg-zinc-800/50 border border-zinc-700 rounded-xl">
        <h3 className="text-lg font-semibold text-white mb-2">{getTypeLabel()}</h3>
        <p className="text-sm text-zinc-400">No data yet. Complete tasks to see your progress!</p>
      </div>
    );
  }

  return (
    <div className="p-6 bg-zinc-800/50 border border-zinc-700 rounded-xl">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h3 className="text-lg font-semibold text-white mb-1">{getTypeLabel()}</h3>
          <p className="text-sm text-zinc-400">Last {days} days</p>
        </div>

        {/* Stats */}
        <div className="flex items-center gap-4">
          <div className="text-right">
            <div className="text-2xl font-bold text-white">{stats.current}</div>
            <div className="text-xs text-zinc-400">Current</div>
          </div>

          <div className={`flex items-center gap-1 px-3 py-1 rounded-full ${
            stats.trend === 'up' 
              ? 'bg-green-600/20 text-green-400' 
              : stats.trend === 'down'
              ? 'bg-red-600/20 text-red-400'
              : 'bg-zinc-600/20 text-zinc-400'
          }`}>
            {stats.trend === 'up' && <TrendingUp className="w-4 h-4" />}
            {stats.trend === 'down' && <TrendingDown className="w-4 h-4" />}
            {stats.trend === 'flat' && <Minus className="w-4 h-4" />}
            <span className="text-sm font-semibold">
              {stats.change > 0 ? '+' : ''}{stats.change}
            </span>
          </div>
        </div>
      </div>

      {/* Simple Bar Chart */}
      <div className="space-y-2">
        {/* Y-axis labels */}
        <div className="flex items-end gap-1 h-48">
          {graphData.slice(-14).map((point, index) => {
            const heightPercent = (point.value / maxValue) * 100;
            return (
              <div key={index} className="flex-1 flex flex-col items-center gap-1 group">
                {/* Bar */}
                <div className="relative w-full flex items-end" style={{ height: '100%' }}>
                  <div
                    className={`w-full bg-gradient-to-t ${getTypeColor()} rounded-t transition-all duration-300 group-hover:opacity-80 cursor-pointer`}
                    style={{ height: `${heightPercent}%` }}
                    title={`${point.date}: ${point.label}`}
                  />
                </div>

                {/* Date label */}
                <div className="text-[10px] text-zinc-500 rotate-45 origin-top-left whitespace-nowrap">
                  {new Date(point.date).toLocaleDateString(undefined, { month: 'short', day: 'numeric' })}
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Footer stats */}
      <div className="mt-6 pt-4 border-t border-zinc-700 flex items-center justify-between text-sm">
        <div className="flex items-center gap-2 text-zinc-400">
          <Calendar className="w-4 h-4" />
          <span>
            Showing {graphData.slice(-14).length} of {days} days
          </span>
        </div>

        <div className="flex items-center gap-4 text-zinc-400">
          <div>
            <span className="text-zinc-500">Avg:</span> 
            <span className="text-white font-semibold ml-1">{stats.avg}</span>
          </div>
          <div>
            <span className="text-zinc-500">Max:</span> 
            <span className="text-white font-semibold ml-1">{stats.max}</span>
          </div>
        </div>
      </div>
    </div>
  );
}

