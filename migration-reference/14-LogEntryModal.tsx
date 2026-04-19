import React, { useState } from 'react';
import { X, Plus, Trash2, CheckCircle, TrendingUp } from 'lucide-react';
import { Task } from '../store';

interface LogEntryModalProps {
  task: Task;
  onClose: () => void;
  onLog: (data: any) => void;
}

export function LogEntryModal({ task, onClose, onLog }: LogEntryModalProps) {
  const isFitness = task.area === 'Fitness';
  const isDSA = task.area === 'DSA' || task.area === 'Career';

  // Fitness logging state
  const [exercises, setExercises] = useState<Array<{ name: string; sets: number; reps: number; weight: number }>>(
    task.meta?.fitnessMeta?.exercises?.map(ex => ({ ...ex, weight: 0 })) || [
      { name: '', sets: 3, reps: 10, weight: 0 }
    ]
  );
  const [calories, setCalories] = useState(0);
  const [bodyWeight, setBodyWeight] = useState(0);
  const [notes, setNotes] = useState('');

  // DSA logging state
  const [problemName, setProblemName] = useState('');
  const [problemUrl, setProblemUrl] = useState('');
  const [difficulty, setDifficulty] = useState<'easy' | 'medium' | 'hard'>('medium');
  const [timeTaken, setTimeTaken] = useState(30);
  const [solved, setSolved] = useState(false);
  const [dsaNotes, setDsaNotes] = useState('');

  const handleFitnessLog = () => {
    const validExercises = exercises.filter(ex => ex.name.trim() !== '');
    
    if (validExercises.length === 0) {
      alert('❌ Please log at least one exercise');
      return;
    }

    onLog({
      type: 'fitness',
      exercises: validExercises,
      calories,
      bodyWeight,
      notes
    });
  };

  const handleDSALog = () => {
    if (!problemName.trim()) {
      alert('❌ Please enter the problem name');
      return;
    }

    onLog({
      type: 'dsa',
      problemName,
      problemUrl,
      difficulty,
      timeTaken,
      solved,
      notes: dsaNotes
    });
  };

  const addExercise = () => {
    setExercises([...exercises, { name: '', sets: 3, reps: 10, weight: 0 }]);
  };

  const removeExercise = (index: number) => {
    setExercises(exercises.filter((_, i) => i !== index));
  };

  const updateExercise = (index: number, updates: Partial<typeof exercises[0]>) => {
    setExercises(exercises.map((ex, i) => (i === index ? { ...ex, ...updates } : ex)));
  };

  return (
    <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4">
      <div className="bg-zinc-900 rounded-xl border border-zinc-800 w-full max-w-2xl max-h-[90vh] overflow-y-auto shadow-2xl">
        {/* Header */}
        <div className="sticky top-0 bg-zinc-900 border-b border-zinc-800 p-6 flex items-start justify-between">
          <div className="flex-1">
            <div className="flex items-center gap-3 mb-2">
              <div className={`w-10 h-10 rounded-lg flex items-center justify-center ${
                isFitness ? 'bg-gradient-to-br from-red-500 to-orange-600' : 'bg-gradient-to-br from-green-500 to-emerald-600'
              }`}>
                <span className="text-xl">{isFitness ? '💪' : '💻'}</span>
              </div>
              <div>
                <h2 className="text-2xl font-bold text-white">
                  {isFitness ? 'Log Workout' : 'Log Practice Session'}
                </h2>
                <p className="text-sm text-zinc-400">
                  {isFitness ? 'Track your lifts and progress' : 'Record problem-solving session'}
                </p>
              </div>
            </div>
            
            {/* Task info */}
            <div className="mt-4 p-4 bg-zinc-800/50 rounded-lg border border-zinc-700">
              <p className="text-white font-medium">{task.title}</p>
              {task.logEntries && task.logEntries.length > 0 && (
                <p className="text-sm text-zinc-400 mt-1">
                  📊 {task.logEntries.length} previous {task.logEntries.length === 1 ? 'entry' : 'entries'}
                </p>
              )}
            </div>
          </div>
          
          <button
            onClick={onClose}
            className="p-2 hover:bg-zinc-800 rounded-lg transition-colors"
          >
            <X className="w-5 h-5 text-zinc-400" />
          </button>
        </div>

        {/* Content */}
        <div className="p-6 space-y-6">
          {isFitness ? (
            <>
              {/* Exercises */}
              <div>
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-lg font-semibold text-white">Exercises</h3>
                  <button
                    onClick={addExercise}
                    className="flex items-center gap-2 px-3 py-1 bg-red-600 hover:bg-red-700 rounded-lg transition-colors text-white text-sm"
                  >
                    <Plus className="w-4 h-4" />
                    Add Exercise
                  </button>
                </div>

                <div className="space-y-3">
                  {exercises.map((exercise, index) => (
                    <div key={index} className="p-4 bg-zinc-800/50 rounded-lg border border-zinc-700">
                      <div className="flex items-center justify-between mb-3">
                        <input
                          type="text"
                          value={exercise.name}
                          onChange={(e) => updateExercise(index, { name: e.target.value })}
                          placeholder="Exercise name (e.g., Bench Press)"
                          className="flex-1 px-3 py-2 bg-zinc-900 border border-zinc-600 rounded-lg text-white placeholder-zinc-500 focus:outline-none focus:ring-2 focus:ring-red-500"
                        />
                        <button
                          onClick={() => removeExercise(index)}
                          className="ml-2 p-2 hover:bg-red-600/20 rounded transition-colors"
                        >
                          <Trash2 className="w-4 h-4 text-red-400" />
                        </button>
                      </div>

                      <div className="grid grid-cols-3 gap-3">
                        <div>
                          <label className="text-xs text-zinc-400 mb-1 block">Sets</label>
                          <input
                            type="number"
                            value={exercise.sets}
                            onChange={(e) => updateExercise(index, { sets: parseInt(e.target.value) || 0 })}
                            className="w-full px-3 py-2 bg-zinc-900 border border-zinc-600 rounded-lg text-white text-sm focus:outline-none focus:ring-2 focus:ring-red-500"
                            min="1"
                          />
                        </div>
                        <div>
                          <label className="text-xs text-zinc-400 mb-1 block">Reps</label>
                          <input
                            type="number"
                            value={exercise.reps}
                            onChange={(e) => updateExercise(index, { reps: parseInt(e.target.value) || 0 })}
                            className="w-full px-3 py-2 bg-zinc-900 border border-zinc-600 rounded-lg text-white text-sm focus:outline-none focus:ring-2 focus:ring-red-500"
                            min="1"
                          />
                        </div>
                        <div>
                          <label className="text-xs text-zinc-400 mb-1 block">Weight (lbs)</label>
                          <input
                            type="number"
                            value={exercise.weight}
                            onChange={(e) => updateExercise(index, { weight: parseInt(e.target.value) || 0 })}
                            className="w-full px-3 py-2 bg-zinc-900 border border-zinc-600 rounded-lg text-white text-sm focus:outline-none focus:ring-2 focus:ring-red-500"
                            min="0"
                          />
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Additional metrics */}
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="text-sm text-zinc-400 mb-2 block">Calories Burned (optional)</label>
                  <input
                    type="number"
                    value={calories}
                    onChange={(e) => setCalories(parseInt(e.target.value) || 0)}
                    placeholder="e.g., 350"
                    className="w-full px-4 py-2 bg-zinc-800 border border-zinc-600 rounded-lg text-white placeholder-zinc-500 focus:outline-none focus:ring-2 focus:ring-red-500"
                    min="0"
                  />
                </div>
                <div>
                  <label className="text-sm text-zinc-400 mb-2 block">Body Weight (optional)</label>
                  <input
                    type="number"
                    value={bodyWeight}
                    onChange={(e) => setBodyWeight(parseInt(e.target.value) || 0)}
                    placeholder="e.g., 175"
                    className="w-full px-4 py-2 bg-zinc-800 border border-zinc-600 rounded-lg text-white placeholder-zinc-500 focus:outline-none focus:ring-2 focus:ring-red-500"
                    min="0"
                  />
                </div>
              </div>

              {/* Notes */}
              <div>
                <label className="text-sm text-zinc-400 mb-2 block">Notes (optional)</label>
                <textarea
                  value={notes}
                  onChange={(e) => setNotes(e.target.value)}
                  placeholder="How did it feel? Any PRs?"
                  className="w-full px-4 py-3 bg-zinc-800 border border-zinc-600 rounded-lg text-white placeholder-zinc-500 focus:outline-none focus:ring-2 focus:ring-red-500 resize-none"
                  rows={3}
                />
              </div>
            </>
          ) : (
            <>
              {/* Problem name */}
              <div>
                <label className="text-sm text-zinc-400 mb-2 block">Problem Name *</label>
                <input
                  type="text"
                  value={problemName}
                  onChange={(e) => setProblemName(e.target.value)}
                  placeholder="e.g., Two Sum, Valid Parentheses"
                  className="w-full px-4 py-2 bg-zinc-800 border border-zinc-600 rounded-lg text-white placeholder-zinc-500 focus:outline-none focus:ring-2 focus:ring-green-500"
                />
              </div>

              {/* Problem URL */}
              <div>
                <label className="text-sm text-zinc-400 mb-2 block">Problem URL (optional)</label>
                <input
                  type="url"
                  value={problemUrl}
                  onChange={(e) => setProblemUrl(e.target.value)}
                  placeholder="https://leetcode.com/problems/..."
                  className="w-full px-4 py-2 bg-zinc-800 border border-zinc-600 rounded-lg text-white placeholder-zinc-500 focus:outline-none focus:ring-2 focus:ring-green-500"
                />
              </div>

              {/* Difficulty & Time */}
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="text-sm text-zinc-400 mb-2 block">Difficulty</label>
                  <select
                    value={difficulty}
                    onChange={(e) => setDifficulty(e.target.value as 'easy' | 'medium' | 'hard')}
                    className="w-full px-4 py-2 bg-zinc-800 border border-zinc-600 rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-green-500"
                  >
                    <option value="easy">🟢 Easy</option>
                    <option value="medium">🟡 Medium</option>
                    <option value="hard">🔴 Hard</option>
                  </select>
                </div>
                <div>
                  <label className="text-sm text-zinc-400 mb-2 block">Time Taken (minutes)</label>
                  <input
                    type="number"
                    value={timeTaken}
                    onChange={(e) => setTimeTaken(parseInt(e.target.value) || 0)}
                    className="w-full px-4 py-2 bg-zinc-800 border border-zinc-600 rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-green-500"
                    min="1"
                  />
                </div>
              </div>

              {/* Solved checkbox */}
              <div className="flex items-center gap-3 p-4 bg-zinc-800/50 rounded-lg border border-zinc-700">
                <input
                  type="checkbox"
                  checked={solved}
                  onChange={(e) => setSolved(e.target.checked)}
                  className="w-5 h-5 bg-zinc-900 border-zinc-600 rounded focus:ring-2 focus:ring-green-500"
                />
                <label className="text-white font-medium">
                  {solved ? '✅ Problem Solved!' : '❌ Attempted but not solved'}
                </label>
              </div>

              {/* Notes */}
              <div>
                <label className="text-sm text-zinc-400 mb-2 block">Notes (optional)</label>
                <textarea
                  value={dsaNotes}
                  onChange={(e) => setDsaNotes(e.target.value)}
                  placeholder="What pattern did you use? What did you learn?"
                  className="w-full px-4 py-3 bg-zinc-800 border border-zinc-600 rounded-lg text-white placeholder-zinc-500 focus:outline-none focus:ring-2 focus:ring-green-500 resize-none"
                  rows={3}
                />
              </div>
            </>
          )}
        </div>

        {/* Footer */}
        <div className="sticky bottom-0 bg-zinc-900 border-t border-zinc-800 p-6 flex items-center justify-between">
          <div className="flex items-center gap-2 text-sm text-zinc-400">
            <TrendingUp className="w-4 h-4" />
            <span>Progress tracked automatically</span>
          </div>
          <div className="flex items-center gap-3">
            <button
              onClick={onClose}
              className="px-6 py-2 bg-zinc-800 hover:bg-zinc-700 rounded-lg transition-colors text-white font-medium"
            >
              Cancel
            </button>
            <button
              onClick={isFitness ? handleFitnessLog : handleDSALog}
              className={`flex items-center gap-2 px-6 py-2 rounded-lg transition-colors text-white font-medium ${
                isFitness
                  ? 'bg-gradient-to-r from-red-600 to-orange-600 hover:from-red-700 hover:to-orange-700'
                  : 'bg-gradient-to-r from-green-600 to-emerald-600 hover:from-green-700 hover:to-emerald-700'
              }`}
            >
              <CheckCircle className="w-5 h-5" />
              Log {isFitness ? 'Workout' : 'Session'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

