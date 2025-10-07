import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  X, Save, Clock, Zap, Target, BookOpen, Briefcase, 
  Code, Dumbbell, DollarSign, Heart, GraduationCap,
  Plus, Minus, AlertTriangle, CheckCircle, Lightbulb
} from 'lucide-react';
import { useAppStore } from '../store';
import type { Task, Goal } from '../store';

interface AtomicTaskModalProps {
  task?: Task | null;
  onSave: (taskData: any) => void;
  onDelete?: () => void;
  onClose: () => void;
  defaultArea?: string;
  linkedGoalId?: string;
}

export function AtomicTaskModal({ 
  task, 
  onSave, 
  onDelete, 
  onClose, 
  defaultArea,
  linkedGoalId 
}: AtomicTaskModalProps) {
  const { goals, calculateTaskPoints } = useAppStore();
  
  const [formData, setFormData] = useState({
    title: '',
    notes: '',
    area: defaultArea || 'School',
    status: 'todo' as const,
    priority: 'medium' as const,
    energy: 'medium' as const,
    estimateMin: 25,
    timeboxMin: 25,
    definitionOfDone: '',
    isAtomic: true,
    canBreakdown: false,
    loggable: false,
    goalLinks: [] as { goalId: string; weight: number }[],
    tags: [] as string[],
    projectMeta: undefined as any,
    courseMeta: undefined as any,
    dsaMeta: undefined as any,
    fitnessMeta: undefined as any
  });

  const [errors, setErrors] = useState<Record<string, string>>({});
  const [isGeneratingDoD, setIsGeneratingDoD] = useState(false);

  // Populate form when editing existing task
  useEffect(() => {
    if (task) {
      setFormData({
        title: task.title || '',
        notes: task.notes || '',
        area: task.area || 'School',
        status: task.status || 'todo',
        priority: task.priority || 'medium',
        energy: task.energy || 'medium',
        estimateMin: task.estimateMin || 25,
        timeboxMin: task.timeboxMin || 25,
        definitionOfDone: task.definitionOfDone || '',
        isAtomic: task.isAtomic ?? true,
        canBreakdown: task.canBreakdown ?? false,
        loggable: task.loggable ?? false,
        goalLinks: task.goalLinks || [],
        tags: task.tags || [],
        projectMeta: task.projectMeta,
        courseMeta: task.courseMeta,
        dsaMeta: task.dsaMeta,
        fitnessMeta: task.fitnessMeta
      });
    } else if (linkedGoalId) {
      // Auto-link to the specified goal
      setFormData(prev => ({
        ...prev,
        goalLinks: [{ goalId: linkedGoalId, weight: 1 }]
      }));
    }
  }, [task, linkedGoalId]);

  // Auto-generate definition of done based on title and area
  useEffect(() => {
    if (formData.title && !formData.definitionOfDone && !task) {
      generateDefinitionOfDone();
    }
  }, [formData.title, formData.area]);

  // Auto-calculate timebox from estimate
  useEffect(() => {
    if (formData.estimateMin && !task) {
      setFormData(prev => ({
        ...prev,
        timeboxMin: Math.min(formData.estimateMin + 5, 30)
      }));
    }
  }, [formData.estimateMin]);

  const generateDefinitionOfDone = async () => {
    setIsGeneratingDoD(true);
    // Simulate AI generation - in real app, this would call AI service
    await new Promise(resolve => setTimeout(resolve, 500));
    
    const areaTemplates = {
      School: `Complete all requirements and submit`,
      Apps: `Feature working, tested, and documented`,
      DSA: `Solution implemented, tested, and explained`,
      Fitness: `All sets completed with proper form logged`,
      Finance: `Research completed and decision documented`,
      Other: `All criteria met and verified`
    };

    const template = areaTemplates[formData.area as keyof typeof areaTemplates] || areaTemplates.Other;
    setFormData(prev => ({
      ...prev,
      definitionOfDone: template
    }));
    setIsGeneratingDoD(false);
  };

  const validateForm = () => {
    const newErrors: Record<string, string> = {};

    if (!formData.title.trim()) {
      newErrors.title = 'Title is required';
    }

    if (formData.estimateMin > 30) {
      newErrors.estimateMin = 'Tasks must be ≤30 minutes (use breakdown for larger tasks)';
    }

    if (formData.timeboxMin > 30) {
      newErrors.timeboxMin = 'Timebox must be ≤30 minutes';
    }

    if (!formData.definitionOfDone.trim()) {
      newErrors.definitionOfDone = 'Definition of done is required';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSave = () => {
    if (!validateForm()) return;

    const taskData = {
      ...formData,
      points: calculateTaskPoints(formData),
      isAtomic: formData.estimateMin <= 30,
      canBreakdown: formData.estimateMin > 15,
      tags: [...formData.tags, 'atomic']
    };

    onSave(taskData);
  };

  const getAreaIcon = (area: string) => {
    const icons = {
      School: <GraduationCap className="w-4 h-4" />,
      Apps: <Briefcase className="w-4 h-4" />,
      DSA: <Code className="w-4 h-4" />,
      Fitness: <Dumbbell className="w-4 h-4" />,
      Finance: <DollarSign className="w-4 h-4" />,
      Other: <Target className="w-4 h-4" />
    };
    return icons[area as keyof typeof icons] || icons.Other;
  };

  const getEnergyColor = (energy: string) => {
    const colors = {
      low: 'bg-blue-500/20 text-blue-400 border-blue-500/30',
      medium: 'bg-amber-500/20 text-amber-400 border-amber-500/30',
      high: 'bg-red-500/20 text-red-400 border-red-500/30'
    };
    return colors[energy as keyof typeof colors] || colors.medium;
  };

  const getPriorityColor = (priority: string) => {
    const colors = {
      low: 'bg-green-500/20 text-green-400 border-green-500/30',
      medium: 'bg-amber-500/20 text-amber-400 border-amber-500/30',
      high: 'bg-red-500/20 text-red-400 border-red-500/30'
    };
    return colors[priority as keyof typeof colors] || colors.medium;
  };

  const availableGoals = goals.filter(g => g.area === formData.area || g.area === 'Other');

  return (
    <AnimatePresence>
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
        onClick={(e) => e.target === e.currentTarget && onClose()}
      >
        <motion.div
          initial={{ scale: 0.9, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          exit={{ scale: 0.9, opacity: 0 }}
          className="bg-zinc-900 border border-zinc-700 rounded-xl w-full max-w-2xl max-h-[90vh] overflow-y-auto"
        >
          {/* Header */}
          <div className="flex items-center justify-between p-6 border-b border-zinc-700">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-blue-600/20 rounded-lg">
                {getAreaIcon(formData.area)}
              </div>
              <div>
                <h2 className="text-xl font-bold">
                  {task ? 'Edit Task' : 'Create Atomic Task'}
                </h2>
                <p className="text-sm text-zinc-400">
                  {task ? 'Update your task details' : 'Break down work into manageable chunks'}
                </p>
              </div>
            </div>
            <button
              onClick={onClose}
              className="p-2 hover:bg-zinc-800 rounded-lg transition-colors"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Content */}
          <div className="p-6 space-y-6">
            {/* Basic Information */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold flex items-center gap-2">
                <Target className="w-5 h-5" />
                Basic Information
              </h3>

              {/* Title */}
              <div>
                <label className="block text-sm font-medium mb-2">
                  Task Title *
                </label>
                <input
                  type="text"
                  value={formData.title}
                  onChange={(e) => setFormData(prev => ({ ...prev, title: e.target.value }))}
                  placeholder="What needs to be done?"
                  className={`w-full p-3 bg-zinc-800 border rounded-lg transition-colors ${
                    errors.title ? 'border-red-500' : 'border-zinc-600 focus:border-blue-500'
                  }`}
                />
                {errors.title && (
                  <p className="text-red-400 text-sm mt-1">{errors.title}</p>
                )}
              </div>

              {/* Area Selection */}
              <div>
                <label className="block text-sm font-medium mb-2">
                  Area
                </label>
                <div className="grid grid-cols-3 gap-2">
                  {['School', 'Apps', 'DSA', 'Fitness', 'Finance', 'Other'].map(area => (
                    <button
                      key={area}
                      onClick={() => setFormData(prev => ({ ...prev, area }))}
                      className={`p-3 rounded-lg border-2 transition-all flex items-center justify-center gap-2 ${
                        formData.area === area
                          ? 'border-blue-500 bg-blue-500/10 text-blue-400'
                          : 'border-zinc-600 hover:border-zinc-500'
                      }`}
                    >
                      {getAreaIcon(area)}
                      <span className="text-sm">{area}</span>
                    </button>
                  ))}
                </div>
              </div>

              {/* Notes */}
              <div>
                <label className="block text-sm font-medium mb-2">
                  Notes (Optional)
                </label>
                <textarea
                  value={formData.notes}
                  onChange={(e) => setFormData(prev => ({ ...prev, notes: e.target.value }))}
                  placeholder="Additional context or details..."
                  rows={3}
                  className="w-full p-3 bg-zinc-800 border border-zinc-600 rounded-lg focus:border-blue-500 transition-colors resize-none"
                />
              </div>
            </div>

            {/* Atomic Framework Settings */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold flex items-center gap-2">
                <Zap className="w-5 h-5" />
                Atomic Framework
              </h3>

              <div className="grid grid-cols-2 gap-4">
                {/* Time Estimate */}
                <div>
                  <label className="block text-sm font-medium mb-2">
                    Estimate (minutes) *
                  </label>
                  <div className="flex items-center gap-2">
                    <input
                      type="number"
                      min="5"
                      max="30"
                      value={formData.estimateMin}
                      onChange={(e) => setFormData(prev => ({ 
                        ...prev, 
                        estimateMin: Math.min(30, Math.max(5, parseInt(e.target.value) || 5))
                      }))}
                      className={`flex-1 p-3 bg-zinc-800 border rounded-lg transition-colors ${
                        errors.estimateMin ? 'border-red-500' : 'border-zinc-600 focus:border-blue-500'
                      }`}
                    />
                    <Clock className="w-4 h-4 text-zinc-400" />
                  </div>
                  {errors.estimateMin && (
                    <p className="text-red-400 text-sm mt-1">{errors.estimateMin}</p>
                  )}
                  {formData.estimateMin > 30 && (
                    <p className="text-amber-400 text-sm mt-1">
                      ⚠️ Consider breaking this into smaller tasks
                    </p>
                  )}
                </div>

                {/* Timebox */}
                <div>
                  <label className="block text-sm font-medium mb-2">
                    Timebox (minutes)
                  </label>
                  <div className="flex items-center gap-2">
                    <input
                      type="number"
                      min="5"
                      max="30"
                      value={formData.timeboxMin}
                      onChange={(e) => setFormData(prev => ({ 
                        ...prev, 
                        timeboxMin: Math.min(30, Math.max(5, parseInt(e.target.value) || 5))
                      }))}
                      className={`flex-1 p-3 bg-zinc-800 border rounded-lg transition-colors ${
                        errors.timeboxMin ? 'border-red-500' : 'border-zinc-600 focus:border-blue-500'
                      }`}
                    />
                    <Clock className="w-4 h-4 text-zinc-400" />
                  </div>
                  {errors.timeboxMin && (
                    <p className="text-red-400 text-sm mt-1">{errors.timeboxMin}</p>
                  )}
                </div>
              </div>

              {/* Energy & Priority */}
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-2">
                    Energy Level
                  </label>
                  <div className="grid grid-cols-3 gap-2">
                    {(['low', 'medium', 'high'] as const).map(energy => (
                      <button
                        key={energy}
                        onClick={() => setFormData(prev => ({ ...prev, energy }))}
                        className={`p-2 rounded-lg border-2 transition-all text-sm capitalize ${
                          formData.energy === energy
                            ? getEnergyColor(energy)
                            : 'border-zinc-600 hover:border-zinc-500'
                        }`}
                      >
                        {energy}
                      </button>
                    ))}
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium mb-2">
                    Priority
                  </label>
                  <div className="grid grid-cols-3 gap-2">
                    {(['low', 'medium', 'high'] as const).map(priority => (
                      <button
                        key={priority}
                        onClick={() => setFormData(prev => ({ ...prev, priority }))}
                        className={`p-2 rounded-lg border-2 transition-all text-sm capitalize ${
                          formData.priority === priority
                            ? getPriorityColor(priority)
                            : 'border-zinc-600 hover:border-zinc-500'
                        }`}
                      >
                        {priority}
                      </button>
                    ))}
                  </div>
                </div>
              </div>
            </div>

            {/* Definition of Done */}
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <h3 className="text-lg font-semibold flex items-center gap-2">
                  <CheckCircle className="w-5 h-5" />
                  Definition of Done
                </h3>
                <button
                  onClick={generateDefinitionOfDone}
                  disabled={isGeneratingDoD || !formData.title}
                  className="flex items-center gap-2 px-3 py-1 bg-blue-600/20 hover:bg-blue-600/30 text-blue-400 rounded-lg transition-colors disabled:opacity-50"
                >
                  <Lightbulb className="w-4 h-4" />
                  {isGeneratingDoD ? 'Generating...' : 'Auto-generate'}
                </button>
              </div>

              <textarea
                value={formData.definitionOfDone}
                onChange={(e) => setFormData(prev => ({ ...prev, definitionOfDone: e.target.value }))}
                placeholder="What does 'done' look like for this task?"
                rows={2}
                className={`w-full p-3 bg-zinc-800 border rounded-lg transition-colors resize-none ${
                  errors.definitionOfDone ? 'border-red-500' : 'border-zinc-600 focus:border-blue-500'
                }`}
              />
              {errors.definitionOfDone && (
                <p className="text-red-400 text-sm mt-1">{errors.definitionOfDone}</p>
              )}
            </div>

            {/* Goal Links */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold flex items-center gap-2">
                <Target className="w-5 h-5" />
                Link to Goals
              </h3>

              {availableGoals.length > 0 ? (
                <div className="space-y-2">
                  {availableGoals.map(goal => {
                    const isLinked = formData.goalLinks.some(link => link.goalId === goal.id);
                    return (
                      <button
                        key={goal.id}
                        onClick={() => {
                          if (isLinked) {
                            setFormData(prev => ({
                              ...prev,
                              goalLinks: prev.goalLinks.filter(link => link.goalId !== goal.id)
                            }));
                          } else {
                            setFormData(prev => ({
                              ...prev,
                              goalLinks: [...prev.goalLinks, { goalId: goal.id, weight: 1 }]
                            }));
                          }
                        }}
                        className={`w-full p-3 rounded-lg border-2 transition-all text-left ${
                          isLinked
                            ? 'border-blue-500 bg-blue-500/10 text-blue-400'
                            : 'border-zinc-600 hover:border-zinc-500'
                        }`}
                      >
                        <div className="flex items-center justify-between">
                          <span className="font-medium">{goal.title}</span>
                          {isLinked && <CheckCircle className="w-4 h-4" />}
                        </div>
                      </button>
                    );
                  })}
                </div>
              ) : (
                <p className="text-zinc-400 text-sm">
                  No goals available for this area. Create a goal first to link tasks.
                </p>
              )}
            </div>

            {/* Advanced Options */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold flex items-center gap-2">
                <Zap className="w-5 h-5" />
                Advanced Options
              </h3>

              <div className="grid grid-cols-2 gap-4">
                <label className="flex items-center gap-3 p-3 bg-zinc-800/50 rounded-lg cursor-pointer">
                  <input
                    type="checkbox"
                    checked={formData.canBreakdown}
                    onChange={(e) => setFormData(prev => ({ ...prev, canBreakdown: e.target.checked }))}
                    className="w-4 h-4 text-blue-600 bg-zinc-700 border-zinc-600 rounded focus:ring-blue-500"
                  />
                  <div>
                    <div className="font-medium">Can Break Down</div>
                    <div className="text-sm text-zinc-400">Allow splitting into subtasks</div>
                  </div>
                </label>

                <label className="flex items-center gap-3 p-3 bg-zinc-800/50 rounded-lg cursor-pointer">
                  <input
                    type="checkbox"
                    checked={formData.loggable}
                    onChange={(e) => setFormData(prev => ({ ...prev, loggable: e.target.checked }))}
                    className="w-4 h-4 text-blue-600 bg-zinc-700 border-zinc-600 rounded focus:ring-blue-500"
                  />
                  <div>
                    <div className="font-medium">Loggable</div>
                    <div className="text-sm text-zinc-400">Track detailed progress (Fitness/DSA)</div>
                  </div>
                </label>
              </div>
            </div>
          </div>

          {/* Footer */}
          <div className="flex items-center justify-between p-6 border-t border-zinc-700">
            <div className="flex items-center gap-4">
              {onDelete && (
                <button
                  onClick={onDelete}
                  className="flex items-center gap-2 px-4 py-2 text-red-400 hover:text-red-300 transition-colors"
                >
                  Delete Task
                </button>
              )}
            </div>
            
            <div className="flex items-center gap-3">
              <button
                onClick={onClose}
                className="px-4 py-2 text-zinc-400 hover:text-zinc-300 transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={handleSave}
                className="flex items-center gap-2 px-6 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors"
              >
                <Save className="w-4 h-4" />
                {task ? 'Update Task' : 'Create Task'}
              </button>
            </div>
          </div>
        </motion.div>
      </motion.div>
    </AnimatePresence>
  );
}

export default AtomicTaskModal;
