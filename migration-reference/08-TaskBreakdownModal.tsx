import React, { useState } from 'react';
import { X, Plus, Trash2, CheckCircle } from 'lucide-react';
import { Task } from '../store';

interface TaskBreakdownModalProps {
  task: Task;
  onClose: () => void;
  onBreakdown: (subtasks: Array<Partial<Task>>) => void;
}

interface SubtaskInput {
  id: string;
  title: string;
  estimateMin: number;
  definitionOfDone: string;
  energy: 'low' | 'medium' | 'high';
}

export function TaskBreakdownModal({ task, onClose, onBreakdown }: TaskBreakdownModalProps) {
  // Pre-populate with smart defaults based on task type
  const getDefaultSubtasks = (): SubtaskInput[] => {
    if (task.area === 'School' && task.meta?.courseCode) {
      // Course breakdown
      return [
        { id: '1', title: `${task.meta.courseCode} → Read all modules`, estimateMin: 25, definitionOfDone: 'Notes taken, key terms highlighted', energy: 'medium' },
        { id: '2', title: `${task.meta.courseCode} → Complete module quizzes`, estimateMin: 15, definitionOfDone: 'All quizzes passed', energy: 'low' },
        { id: '3', title: `${task.meta.courseCode} → Take practice test`, estimateMin: 20, definitionOfDone: 'Test completed, weak areas identified', energy: 'high' },
        { id: '4', title: `${task.meta.courseCode} → Review weak areas`, estimateMin: 20, definitionOfDone: 'Notes reviewed, concepts clarified', energy: 'medium' },
        { id: '5', title: `${task.meta.courseCode} → Take final exam`, estimateMin: 30, definitionOfDone: 'Exam passed with 70%+', energy: 'high' }
      ];
    } else if (task.area === 'Apps' || task.area === 'DSA') {
      // Project/coding breakdown
      return [
        { id: '1', title: 'Setup & scaffolding', estimateMin: 15, definitionOfDone: 'Files created, imports ready', energy: 'low' },
        { id: '2', title: 'Core logic implementation', estimateMin: 30, definitionOfDone: 'Main functionality working', energy: 'high' },
        { id: '3', title: 'Testing & debugging', estimateMin: 20, definitionOfDone: 'Tests pass, no errors', energy: 'medium' },
        { id: '4', title: 'Polish & cleanup', estimateMin: 15, definitionOfDone: 'Code cleaned, comments added', energy: 'low' }
      ];
    } else {
      // Generic breakdown
      return [
        { id: '1', title: 'Step 1', estimateMin: 20, definitionOfDone: 'First part completed', energy: 'medium' },
        { id: '2', title: 'Step 2', estimateMin: 20, definitionOfDone: 'Second part completed', energy: 'medium' },
        { id: '3', title: 'Step 3', estimateMin: 20, definitionOfDone: 'Final part completed', energy: 'medium' }
      ];
    }
  };

  const [subtasks, setSubtasks] = useState<SubtaskInput[]>(getDefaultSubtasks());

  const addSubtask = () => {
    setSubtasks([
      ...subtasks,
      { id: Date.now().toString(), title: '', estimateMin: 20, definitionOfDone: '', energy: 'medium' }
    ]);
  };

  const removeSubtask = (id: string) => {
    setSubtasks(subtasks.filter((st) => st.id !== id));
  };

  const updateSubtask = (id: string, updates: Partial<SubtaskInput>) => {
    setSubtasks(subtasks.map((st) => (st.id === id ? { ...st, ...updates } : st)));
  };

  const handleBreakdown = () => {
    const validSubtasks = subtasks.filter((st) => st.title.trim() !== '');
    
    if (validSubtasks.length === 0) {
      alert('❌ Please add at least one subtask');
      return;
    }

    const formattedSubtasks: Array<Partial<Task>> = validSubtasks.map((st) => ({
      title: st.title,
      estimateMin: st.estimateMin,
      energy: st.energy,
      definitionOfDone: st.definitionOfDone,
      isAtomic: st.estimateMin <= 30,
      status: 'todo',
      tags: ['subtask']
    }));

    onBreakdown(formattedSubtasks);
  };

  const totalTime = subtasks.reduce((sum, st) => sum + st.estimateMin, 0);
  const atomicCount = subtasks.filter((st) => st.estimateMin <= 30).length;

  return (
    <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4">
      <div className="bg-zinc-900 rounded-xl border border-zinc-800 w-full max-w-3xl max-h-[90vh] overflow-y-auto shadow-2xl">
        {/* Header */}
        <div className="sticky top-0 bg-zinc-900 border-b border-zinc-800 p-6 flex items-start justify-between">
          <div className="flex-1">
            <div className="flex items-center gap-3 mb-2">
              <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center">
                <span className="text-xl">🔨</span>
              </div>
              <div>
                <h2 className="text-2xl font-bold text-white">Break Down Task</h2>
                <p className="text-sm text-zinc-400">Split into atomic 5-30 minute steps</p>
              </div>
            </div>
            
            {/* Parent task info */}
            <div className="mt-4 p-4 bg-zinc-800/50 rounded-lg border border-zinc-700">
              <p className="text-sm text-zinc-400 mb-1">Parent Task:</p>
              <p className="text-white font-medium">{task.title}</p>
              <div className="flex items-center gap-4 mt-2 text-sm text-zinc-400">
                <span>⏱️ {task.estimateMin || 'N/A'} min</span>
                <span>📍 {task.area}</span>
                {task.meta?.courseCode && <span>📚 {task.meta.courseCode}</span>}
              </div>
            </div>
          </div>
          
          <button
            onClick={onClose}
            className="p-2 hover:bg-zinc-800 rounded-lg transition-colors"
          >
            <X className="w-5 h-5 text-zinc-400" />
          </button>
        </div>

        {/* Subtasks list */}
        <div className="p-6 space-y-4">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="text-lg font-semibold text-white">Subtasks</h3>
              <p className="text-sm text-zinc-400">
                Total: {totalTime}min • {atomicCount}/{subtasks.length} atomic (≤30min)
              </p>
            </div>
            <button
              onClick={addSubtask}
              className="flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 rounded-lg transition-colors text-white font-medium text-sm"
            >
              <Plus className="w-4 h-4" />
              Add Subtask
            </button>
          </div>

          {subtasks.map((subtask, index) => (
            <div
              key={subtask.id}
              className="p-4 bg-zinc-800/50 rounded-lg border border-zinc-700 space-y-3"
            >
              {/* Subtask number & delete */}
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm font-semibold text-zinc-400">Step {index + 1}</span>
                <button
                  onClick={() => removeSubtask(subtask.id)}
                  className="p-1 hover:bg-red-600/20 rounded transition-colors"
                >
                  <Trash2 className="w-4 h-4 text-red-400" />
                </button>
              </div>

              {/* Title */}
              <input
                type="text"
                value={subtask.title}
                onChange={(e) => updateSubtask(subtask.id, { title: e.target.value })}
                placeholder="What needs to be done?"
                className="w-full px-4 py-2 bg-zinc-900 border border-zinc-600 rounded-lg text-white placeholder-zinc-500 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />

              {/* Time estimate & energy */}
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs text-zinc-400 mb-1 block">Time (minutes)</label>
                  <input
                    type="number"
                    value={subtask.estimateMin}
                    onChange={(e) => updateSubtask(subtask.id, { estimateMin: parseInt(e.target.value) || 0 })}
                    className="w-full px-3 py-2 bg-zinc-900 border border-zinc-600 rounded-lg text-white text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                    min="5"
                    max="60"
                  />
                  {subtask.estimateMin > 30 && (
                    <p className="text-xs text-orange-400 mt-1">⚠️ Consider breaking this down further</p>
                  )}
                </div>

                <div>
                  <label className="text-xs text-zinc-400 mb-1 block">Energy Level</label>
                  <select
                    value={subtask.energy}
                    onChange={(e) => updateSubtask(subtask.id, { energy: e.target.value as 'low' | 'medium' | 'high' })}
                    className="w-full px-3 py-2 bg-zinc-900 border border-zinc-600 rounded-lg text-white text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="low">🟢 Low</option>
                    <option value="medium">🟡 Medium</option>
                    <option value="high">🔴 High</option>
                  </select>
                </div>
              </div>

              {/* Definition of done */}
              <div>
                <label className="text-xs text-zinc-400 mb-1 block">Definition of Done</label>
                <input
                  type="text"
                  value={subtask.definitionOfDone}
                  onChange={(e) => updateSubtask(subtask.id, { definitionOfDone: e.target.value })}
                  placeholder="How do you know it's done?"
                  className="w-full px-3 py-2 bg-zinc-900 border border-zinc-600 rounded-lg text-white text-sm placeholder-zinc-500 focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
            </div>
          ))}
        </div>

        {/* Footer actions */}
        <div className="sticky bottom-0 bg-zinc-900 border-t border-zinc-800 p-6 flex items-center justify-between">
          <div className="text-sm text-zinc-400">
            <p>💡 Tip: Keep each step under 30 minutes for maximum focus</p>
          </div>
          <div className="flex items-center gap-3">
            <button
              onClick={onClose}
              className="px-6 py-2 bg-zinc-800 hover:bg-zinc-700 rounded-lg transition-colors text-white font-medium"
            >
              Cancel
            </button>
            <button
              onClick={handleBreakdown}
              className="flex items-center gap-2 px-6 py-2 bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 rounded-lg transition-colors text-white font-medium"
            >
              <CheckCircle className="w-5 h-5" />
              Create {subtasks.length} Subtasks
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

