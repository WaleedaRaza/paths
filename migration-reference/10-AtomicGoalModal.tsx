import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  X, Save, Target, Calendar, TrendingUp, Award, BookOpen, Briefcase,
  Code, Dumbbell, DollarSign, Heart, GraduationCap, Plus, Minus,
  AlertTriangle, CheckCircle, Zap, Clock
} from 'lucide-react';
import { useAppStore } from '../store';
import type { Goal } from '../store';

interface AtomicGoalModalProps {
  goal?: Goal | null;
  onSave: (goalData: any) => void;
  onDelete?: () => void;
  onClose: () => void;
  defaultArea?: string;
  defaultType?: string;
}

interface Milestone {
  id: string;
  title: string;
  done: boolean;
  points?: number;
  order?: number;
}

export function AtomicGoalModal({ 
  goal, 
  onSave, 
  onDelete, 
  onClose, 
  defaultArea,
  defaultType 
}: AtomicGoalModalProps) {
  
  const [formData, setFormData] = useState({
    title: '',
    area: defaultArea || 'School',
    type: defaultType || 'course',
    status: 'active' as const,
    timeWindow: {
      start: '',
      end: ''
    },
    deadline: '',
    targets: {
      unit: 'tasks' as const,
      amount: 1
    },
    milestones: [] as Milestone[],
    meta: {
      notes: ''
    }
  });

  const [errors, setErrors] = useState<Record<string, string>>({});

  // Populate form when editing existing goal
  useEffect(() => {
    if (goal) {
      setFormData({
        title: goal.title || '',
        area: goal.area || 'School',
        type: goal.type || 'course',
        status: goal.status || 'active',
        timeWindow: goal.timeWindow || { start: '', end: '' },
        deadline: goal.deadline || '',
        targets: goal.targets || { unit: 'tasks', amount: 1 },
        milestones: goal.milestones || [],
        meta: goal.meta || { notes: '' }
      });
    }
  }, [goal]);

  const validateForm = () => {
    const newErrors: Record<string, string> = {};

    if (!formData.title.trim()) {
      newErrors.title = 'Title is required';
    }

    if (!formData.targets.unit) {
      newErrors.targetUnit = 'Target unit is required';
    }

    if (formData.targets.amount <= 0) {
      newErrors.targetAmount = 'Target amount must be greater than 0';
    }

    if (formData.timeWindow.start && formData.timeWindow.end) {
      if (new Date(formData.timeWindow.start) > new Date(formData.timeWindow.end)) {
        newErrors.timeWindow = 'Start date must be before end date';
      }
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSave = () => {
    if (!validateForm()) return;

    const goalData = {
      ...formData,
      currentProgress: 0,
      pointsEarned: 0
    };

    onSave(goalData);
  };

  const addMilestone = () => {
    const newMilestone: Milestone = {
      id: `milestone_${Date.now()}`,
      title: '',
      done: false,
      points: 10,
      order: formData.milestones.length
    };

    setFormData(prev => ({
      ...prev,
      milestones: [...prev.milestones, newMilestone]
    }));
  };

  const updateMilestone = (index: number, updates: Partial<Milestone>) => {
    setFormData(prev => ({
      ...prev,
      milestones: prev.milestones.map((milestone, i) => 
        i === index ? { ...milestone, ...updates } : milestone
      )
    }));
  };

  const removeMilestone = (index: number) => {
    setFormData(prev => ({
      ...prev,
      milestones: prev.milestones.filter((_, i) => i !== index)
    }));
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

  const getTypeIcon = (type: string) => {
    const icons = {
      term: <Calendar className="w-4 h-4" />,
      course: <BookOpen className="w-4 h-4" />,
      project: <Briefcase className="w-4 h-4" />,
      'dsa-pattern': <Code className="w-4 h-4" />,
      fitness: <Dumbbell className="w-4 h-4" />,
      finance: <DollarSign className="w-4 h-4" />,
      milestone: <Award className="w-4 h-4" />,
      other: <Target className="w-4 h-4" />
    };
    return icons[type as keyof typeof icons] || icons.other;
  };

  const getStatusColor = (status: string) => {
    const colors = {
      active: 'bg-emerald-500/20 text-emerald-400 border-emerald-500/30',
      planned: 'bg-blue-500/20 text-blue-400 border-blue-500/30',
      paused: 'bg-amber-500/20 text-amber-400 border-amber-500/30',
      completed: 'bg-purple-500/20 text-purple-400 border-purple-500/30',
      archived: 'bg-zinc-500/20 text-zinc-400 border-zinc-500/30'
    };
    return colors[status as keyof typeof colors] || colors.active;
  };

  const targetUnits = {
    School: ['CUs', 'courses', 'tasks', 'assignments'],
    Apps: ['features', 'commits', 'tasks', 'releases'],
    DSA: ['patterns', 'problems', 'sessions', 'algorithms'],
    Fitness: ['workouts', 'sessions', 'exercises', 'weeks'],
    Finance: ['investments', 'reviews', 'tasks', 'months'],
    Other: ['tasks', 'items', 'sessions', 'weeks']
  };

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
          className="bg-zinc-900 border border-zinc-700 rounded-xl w-full max-w-3xl max-h-[90vh] overflow-y-auto"
        >
          {/* Header */}
          <div className="flex items-center justify-between p-6 border-b border-zinc-700">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-emerald-600/20 rounded-lg">
                {getAreaIcon(formData.area)}
              </div>
              <div>
                <h2 className="text-xl font-bold">
                  {goal ? 'Edit Goal' : 'Create Goal'}
                </h2>
                <p className="text-sm text-zinc-400">
                  {goal ? 'Update your goal details' : 'Set up a new objective with milestones'}
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
                  Goal Title *
                </label>
                <input
                  type="text"
                  value={formData.title}
                  onChange={(e) => setFormData(prev => ({ ...prev, title: e.target.value }))}
                  placeholder="What do you want to achieve?"
                  className={`w-full p-3 bg-zinc-800 border rounded-lg transition-colors ${
                    errors.title ? 'border-red-500' : 'border-zinc-600 focus:border-emerald-500'
                  }`}
                />
                {errors.title && (
                  <p className="text-red-400 text-sm mt-1">{errors.title}</p>
                )}
              </div>

              {/* Area and Type */}
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-2">
                    Area
                  </label>
                  <div className="grid grid-cols-3 gap-2">
                    {['School', 'Apps', 'DSA', 'Fitness', 'Finance', 'Other'].map(area => (
                      <button
                        key={area}
                        onClick={() => setFormData(prev => ({ ...prev, area }))}
                        className={`p-2 rounded-lg border-2 transition-all flex items-center justify-center gap-1 ${
                          formData.area === area
                            ? 'border-emerald-500 bg-emerald-500/10 text-emerald-400'
                            : 'border-zinc-600 hover:border-zinc-500'
                        }`}
                      >
                        {getAreaIcon(area)}
                        <span className="text-xs">{area}</span>
                      </button>
                    ))}
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium mb-2">
                    Type
                  </label>
                  <div className="grid grid-cols-2 gap-2">
                    {['course', 'project', 'term', 'milestone', 'other'].map(type => (
                      <button
                        key={type}
                        onClick={() => setFormData(prev => ({ ...prev, type }))}
                        className={`p-2 rounded-lg border-2 transition-all flex items-center justify-center gap-1 ${
                          formData.type === type
                            ? 'border-emerald-500 bg-emerald-500/10 text-emerald-400'
                            : 'border-zinc-600 hover:border-zinc-500'
                        }`}
                      >
                        {getTypeIcon(type)}
                        <span className="text-xs capitalize">{type}</span>
                      </button>
                    ))}
                  </div>
                </div>
              </div>

              {/* Status */}
              <div>
                <label className="block text-sm font-medium mb-2">
                  Status
                </label>
                <div className="grid grid-cols-5 gap-2">
                  {(['active', 'planned', 'paused', 'completed', 'archived'] as const).map(status => (
                    <button
                      key={status}
                      onClick={() => setFormData(prev => ({ ...prev, status }))}
                      className={`p-2 rounded-lg border-2 transition-all text-sm capitalize ${
                        formData.status === status
                          ? getStatusColor(status)
                          : 'border-zinc-600 hover:border-zinc-500'
                      }`}
                    >
                      {status}
                    </button>
                  ))}
                </div>
              </div>
            </div>

            {/* Time Management */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold flex items-center gap-2">
                <Calendar className="w-5 h-5" />
                Time Management
              </h3>

              <div className="grid grid-cols-2 gap-4">
                {/* Time Window */}
                <div>
                  <label className="block text-sm font-medium mb-2">
                    Time Window (Optional)
                  </label>
                  <div className="space-y-2">
                    <input
                      type="date"
                      value={formData.timeWindow.start}
                      onChange={(e) => setFormData(prev => ({
                        ...prev,
                        timeWindow: { ...prev.timeWindow, start: e.target.value }
                      }))}
                      className="w-full p-3 bg-zinc-800 border border-zinc-600 rounded-lg focus:border-emerald-500 transition-colors"
                      placeholder="Start date"
                    />
                    <input
                      type="date"
                      value={formData.timeWindow.end}
                      onChange={(e) => setFormData(prev => ({
                        ...prev,
                        timeWindow: { ...prev.timeWindow, end: e.target.value }
                      }))}
                      className="w-full p-3 bg-zinc-800 border border-zinc-600 rounded-lg focus:border-emerald-500 transition-colors"
                      placeholder="End date"
                    />
                  </div>
                  {errors.timeWindow && (
                    <p className="text-red-400 text-sm mt-1">{errors.timeWindow}</p>
                  )}
                </div>

                {/* Deadline */}
                <div>
                  <label className="block text-sm font-medium mb-2">
                    Hard Deadline (Optional)
                  </label>
                  <input
                    type="date"
                    value={formData.deadline}
                    onChange={(e) => setFormData(prev => ({ ...prev, deadline: e.target.value }))}
                    className="w-full p-3 bg-zinc-800 border border-zinc-600 rounded-lg focus:border-emerald-500 transition-colors"
                  />
                </div>
              </div>
            </div>

            {/* Targets */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold flex items-center gap-2">
                <TrendingUp className="w-5 h-5" />
                Targets & Progress
              </h3>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium mb-2">
                    Target Unit *
                  </label>
                  <select
                    value={formData.targets.unit}
                    onChange={(e) => setFormData(prev => ({
                      ...prev,
                      targets: { ...prev.targets, unit: e.target.value as any }
                    }))}
                    className={`w-full p-3 bg-zinc-800 border rounded-lg transition-colors ${
                      errors.targetUnit ? 'border-red-500' : 'border-zinc-600 focus:border-emerald-500'
                    }`}
                  >
                    {targetUnits[formData.area as keyof typeof targetUnits]?.map(unit => (
                      <option key={unit} value={unit}>{unit}</option>
                    ))}
                  </select>
                  {errors.targetUnit && (
                    <p className="text-red-400 text-sm mt-1">{errors.targetUnit}</p>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium mb-2">
                    Target Amount *
                  </label>
                  <input
                    type="number"
                    min="1"
                    value={formData.targets.amount}
                    onChange={(e) => setFormData(prev => ({
                      ...prev,
                      targets: { ...prev.targets, amount: parseInt(e.target.value) || 1 }
                    }))}
                    className={`w-full p-3 bg-zinc-800 border rounded-lg transition-colors ${
                      errors.targetAmount ? 'border-red-500' : 'border-zinc-600 focus:border-emerald-500'
                    }`}
                  />
                  {errors.targetAmount && (
                    <p className="text-red-400 text-sm mt-1">{errors.targetAmount}</p>
                  )}
                </div>
              </div>
            </div>

            {/* Milestones */}
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <h3 className="text-lg font-semibold flex items-center gap-2">
                  <Award className="w-5 h-5" />
                  Milestones
                </h3>
                <button
                  onClick={addMilestone}
                  className="flex items-center gap-2 px-3 py-1 bg-emerald-600/20 hover:bg-emerald-600/30 text-emerald-400 rounded-lg transition-colors"
                >
                  <Plus className="w-4 h-4" />
                  Add Milestone
                </button>
              </div>

              {formData.milestones.length > 0 ? (
                <div className="space-y-3">
                  {formData.milestones.map((milestone, index) => (
                    <div key={milestone.id} className="p-4 bg-zinc-800/50 rounded-lg border border-zinc-700">
                      <div className="flex items-center justify-between mb-3">
                        <span className="text-sm font-medium text-zinc-400">
                          Milestone {index + 1}
                        </span>
                        <button
                          onClick={() => removeMilestone(index)}
                          className="p-1 hover:bg-zinc-700 rounded text-zinc-400 hover:text-red-400 transition-colors"
                        >
                          <Minus className="w-4 h-4" />
                        </button>
                      </div>
                      
                      <div className="grid grid-cols-2 gap-3">
                        <div>
                          <label className="block text-xs font-medium mb-1">
                            Title
                          </label>
                          <input
                            type="text"
                            value={milestone.title}
                            onChange={(e) => updateMilestone(index, { title: e.target.value })}
                            placeholder="Milestone description"
                            className="w-full p-2 bg-zinc-800 border border-zinc-600 rounded focus:border-emerald-500 transition-colors text-sm"
                          />
                        </div>
                        <div>
                          <label className="block text-xs font-medium mb-1">
                            Points
                          </label>
                          <input
                            type="number"
                            min="0"
                            value={milestone.points || 0}
                            onChange={(e) => updateMilestone(index, { points: parseInt(e.target.value) || 0 })}
                            className="w-full p-2 bg-zinc-800 border border-zinc-600 rounded focus:border-emerald-500 transition-colors text-sm"
                          />
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center py-8 text-zinc-400">
                  <Award className="w-8 h-8 mx-auto mb-2 opacity-50" />
                  <p className="text-sm">No milestones yet</p>
                  <p className="text-xs">Add milestones to break down your goal</p>
                </div>
              )}
            </div>

            {/* Notes */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold flex items-center gap-2">
                <BookOpen className="w-5 h-5" />
                Additional Notes
              </h3>

              <textarea
                value={formData.meta.notes}
                onChange={(e) => setFormData(prev => ({
                  ...prev,
                  meta: { ...prev.meta, notes: e.target.value }
                }))}
                placeholder="Additional context, resources, or notes about this goal..."
                rows={3}
                className="w-full p-3 bg-zinc-800 border border-zinc-600 rounded-lg focus:border-emerald-500 transition-colors resize-none"
              />
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
                  Delete Goal
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
                className="flex items-center gap-2 px-6 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg transition-colors"
              >
                <Save className="w-4 h-4" />
                {goal ? 'Update Goal' : 'Create Goal'}
              </button>
            </div>
          </div>
        </motion.div>
      </motion.div>
    </AnimatePresence>
  );
}

export default AtomicGoalModal;
