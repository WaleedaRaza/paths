import React, { useState, useEffect, useRef } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  Send, Plus, Clock, User, Bot,
  Lightbulb, Edit3, Trash2, ChevronDown,
  ChevronUp, FileText, ExternalLink, RefreshCw, Pin,
  PenTool, Sparkles, Zap, BookOpen,
  X, ChevronLeft,
  ChevronRight, GripVertical, Archive, History,
  Bookmark, BookmarkCheck, Star, Tags, Calendar, Target
} from 'lucide-react';
import { useAppStore } from '../store';
import { aiService } from '../services/ai';
import type { ChatMessage, ChatSession } from '../store';
import PersonalitySelector from '../components/PersonalitySelector';
import { getExpertById } from '../experts';
import { analyticsService } from '../services/analytics';
import type { RecommendationPanel } from '../services/analytics';
import RecommendationPopup from '../components/RecommendationPopup';
import RecommendationIndicator from '../components/RecommendationIndicator';
import RecommendationsBanner from '../components/RecommendationsBanner';
import { savedPostsService, type SavedPost } from '../services/savedPosts';

interface JournalEntry {
  id: string;
  date: string;
  timestamp: string;
  content: string;
  tags: string[];
  type: 'journal' | 'note' | 'idea' | 'reflection' | 'milestone' | 'lesson';
  mood?: 'great' | 'good' | 'neutral' | 'challenging' | 'difficult';
  growthArea?: 'personal' | 'professional' | 'health' | 'relationships' | 'skills' | 'mindset';
  linkedGoals?: string[];
  linkedTasks?: string[];
}




// Horizontal Recommendations Carousel (legacy - now using analytics-based system)
function _RecommendationsCarousel({ 
  panels, 
  onRefresh 
}: { 
  panels: any[]; 
  onRefresh: (id: string) => void; 
}) {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isAutoScrolling, setIsAutoScrolling] = useState(true);
  const intervalRef = useRef<number | null>(null);

  // Auto-scroll functionality
  useEffect(() => {
    if (isAutoScrolling && panels.length > 0) {
      intervalRef.current = window.setInterval(() => {
        setCurrentIndex(prev => (prev + 1) % panels.length);
      }, 4000); // Change every 4 seconds
    }
    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    };
  }, [isAutoScrolling, panels.length]);

  const nextPanel = () => {
    setIsAutoScrolling(false);
    setCurrentIndex(prev => (prev + 1) % panels.length);
  };

  const prevPanel = () => {
    setIsAutoScrolling(false);
    setCurrentIndex(prev => (prev - 1 + panels.length) % panels.length);
  };

  const visiblePanels = panels.filter(p => p.isVisible);
  if (visiblePanels.length === 0) return null;

  const currentPanel = visiblePanels[currentIndex % visiblePanels.length];
  const Icon = currentPanel?.icon;

  return (
    <div className="bg-zinc-900/50 rounded-lg border border-zinc-700/50 p-4 mb-4">
      <div className="flex items-center justify-between mb-3">
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-2">
            {Icon && <Icon className={`w-5 h-5 ${currentPanel.color}`} />}
            <h3 className="font-semibold">{currentPanel?.title}</h3>
          </div>
          <div className="flex items-center gap-1">
            <div className={`w-2 h-2 rounded-full ${isAutoScrolling ? 'bg-blue-400 animate-pulse' : 'bg-zinc-500'}`} />
            <span className="text-xs text-zinc-400">
              {currentIndex + 1} of {visiblePanels.length}
            </span>
          </div>
        </div>
        
        <div className="flex items-center gap-2">
          <button
            onClick={() => setIsAutoScrolling(!isAutoScrolling)}
            className={`p-1 rounded transition-colors ${
              isAutoScrolling ? 'text-blue-400' : 'text-zinc-400 hover:text-zinc-300'
            }`}
            title={isAutoScrolling ? 'Pause auto-scroll' : 'Resume auto-scroll'}
          >
            {isAutoScrolling ? <Zap className="w-4 h-4" /> : <Clock className="w-4 h-4" />}
          </button>
          <button
            onClick={() => onRefresh(currentPanel.id)}
            className="p-1 text-zinc-400 hover:text-zinc-300 rounded transition-colors"
            title="Refresh content"
          >
            <RefreshCw className="w-4 h-4" />
          </button>
          <button
            onClick={prevPanel}
            className="p-1 text-zinc-400 hover:text-zinc-300 rounded transition-colors"
          >
            <ChevronLeft className="w-4 h-4" />
          </button>
          <button
            onClick={nextPanel}
            className="p-1 text-zinc-400 hover:text-zinc-300 rounded transition-colors"
          >
            <ChevronRight className="w-4 h-4" />
          </button>
        </div>
      </div>

      {/* Current Panel Content */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3 max-h-32 overflow-y-auto">
        {currentPanel?.items.length === 0 ? (
          <div className="col-span-full text-center py-4">
            <Icon className={`w-8 h-8 ${currentPanel.color} mx-auto mb-2 opacity-50`} />
            <p className="text-xs text-zinc-500">No items yet</p>
            <button
              onClick={() => onRefresh(currentPanel.id)}
              className="text-xs text-blue-400 hover:text-blue-300 mt-1"
            >
              Load content
            </button>
          </div>
        ) : (
          currentPanel?.items.map((item: any) => (
            <motion.div
              key={item.id}
              layout
              className="p-2 bg-zinc-800/30 rounded border border-zinc-700/30 hover:border-zinc-600/50 transition-colors"
            >
              <div className="flex items-start justify-between mb-1">
                <h5 className="text-xs font-medium text-zinc-200 line-clamp-1">{item.title}</h5>
                {item.url && (
                  <button className="p-1 text-zinc-400 hover:text-zinc-300 rounded">
                    <ExternalLink className="w-3 h-3" />
                  </button>
                )}
              </div>
              <p className="text-xs text-zinc-400 line-clamp-2 mb-1">{item.content}</p>
              {item.aiInsight && (
                <div className="p-1 bg-blue-600/10 border border-blue-600/20 rounded text-xs text-blue-300 line-clamp-1">
                  <Sparkles className="w-3 h-3 inline mr-1" />
                  {item.aiInsight}
                </div>
              )}
            </motion.div>
          ))
        )}
      </div>
    </div>
  );
}

// Chat Session Selector
function ChatSessionSelector({
  sessions,
  currentSessionId,
  onSelectSession,
  onNewSession,
  onArchiveSession,
  onRenameSession
}: {
  sessions: ChatSession[];
  currentSessionId: string | null;
  onSelectSession: (sessionId: string) => void;
  onNewSession: () => void;
  onArchiveSession: (sessionId: string) => void;
  onRenameSession: (sessionId: string, newTitle: string) => void;
}) {
  const [isExpanded, setIsExpanded] = useState(false);
  const [editingSessionId, setEditingSessionId] = useState<string | null>(null);
  const [editTitle, setEditTitle] = useState('');

  return (
    <div className="mb-4">
      <div className="flex items-center justify-between mb-2">
        <button
          onClick={() => setIsExpanded(!isExpanded)}
          className="flex items-center gap-2 text-sm text-zinc-400 hover:text-zinc-300"
        >
          <History className="w-4 h-4" />
          <span>Chat History ({sessions.length})</span>
          {isExpanded ? <ChevronUp className="w-3 h-3" /> : <ChevronDown className="w-3 h-3" />}
        </button>
        <button
          onClick={onNewSession}
          className="p-1 text-zinc-400 hover:text-zinc-300 rounded transition-colors"
          title="New Chat"
        >
          <Plus className="w-4 h-4" />
        </button>
      </div>

      <AnimatePresence>
        {isExpanded && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            className="overflow-hidden"
          >
            <div className="space-y-1 max-h-32 overflow-y-auto">
              {sessions.map((session) => (
                <div
                  key={session.id}
                  className={`flex items-center justify-between p-2 rounded text-xs transition-colors ${
                    currentSessionId === session.id
                      ? 'bg-blue-600/20 border border-blue-600/30'
                      : 'bg-zinc-800/30 hover:bg-zinc-700/30'
                  }`}
                >
                  <button
                    onClick={() => onSelectSession(session.id)}
                    className="flex-1 text-left"
                  >
                    {editingSessionId === session.id ? (
                      <div className="flex items-center gap-1" onClick={(e) => e.stopPropagation()}>
                        <input
                          type="text"
                          value={editTitle}
                          onChange={(e) => setEditTitle(e.target.value)}
                          onKeyDown={(e) => {
                            if (e.key === 'Enter') {
                              onRenameSession(session.id, editTitle);
                              setEditingSessionId(null);
                            } else if (e.key === 'Escape') {
                              setEditingSessionId(null);
                            }
                          }}
                          onBlur={() => {
                            onRenameSession(session.id, editTitle);
                            setEditingSessionId(null);
                          }}
                          className="flex-1 bg-zinc-700 text-zinc-200 px-1 py-0.5 rounded text-xs"
                          autoFocus
                        />
                      </div>
                    ) : (
                      <>
                        <div className="font-medium text-zinc-200 line-clamp-1">{session.title}</div>
                        <div className="text-zinc-400">
                          {new Date(session.timestamp).toLocaleDateString()} • {session.messages.length} messages
                        </div>
                      </>
                    )}
                  </button>
                  <div className="flex items-center gap-1">
                    <button
                      onClick={() => {
                        setEditingSessionId(session.id);
                        setEditTitle(session.title);
                      }}
                      className="p-1 text-zinc-400 hover:text-blue-400 rounded"
                      title="Rename"
                    >
                      <Edit3 className="w-3 h-3" />
                    </button>
                    <button
                      onClick={() => onArchiveSession(session.id)}
                      className="p-1 text-zinc-400 hover:text-rose-400 rounded"
                      title="Archive"
                    >
                      <Archive className="w-3 h-3" />
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}

// Chat Mode Selector
// Legacy component - replaced by PersonalitySelector
function _ChatModeSelector({ 
  currentMode: _currentMode, 
  onModeChange: _onModeChange 
}: { 
  currentMode: string; 
  onModeChange: (mode: string) => void; 
}) {
  // This is now handled by PersonalitySelector
  return null;
}

// Always-On Chatbot Component
function AlwaysOnChatbot({ 
  messages, 
  sessions,
  currentSessionId,
  sessionPersonalityId,
  onSendMessage, 
  onSelectSession,
  onNewSession,
  onArchiveSession,
  onRenameSession,
  onUpdateSessionPersonality,
  isLoading 
}: { 
  messages: ChatMessage[]; 
  sessions: ChatSession[];
  currentSessionId: string | null;
  sessionPersonalityId: string;
  onSendMessage: (message: string, personalityId: string) => void; 
  onSelectSession: (sessionId: string) => void;
  onNewSession: () => void;
  onArchiveSession: (sessionId: string) => void;
  onRenameSession: (sessionId: string, newTitle: string) => void;
  onUpdateSessionPersonality: (sessionId: string, personalityId: string) => void;
  isLoading: boolean; 
}) {
  const [input, setInput] = useState('');
  const [currentPersonalityId, setCurrentPersonalityId] = useState('lock-in-coach');

  // Update personality when session changes
  useEffect(() => {
    setCurrentPersonalityId(sessionPersonalityId);
  }, [sessionPersonalityId]);

  // Update session personality when personality changes
  const handlePersonalityChange = (newPersonalityId: string) => {
    setCurrentPersonalityId(newPersonalityId);
    // Update the current session's personality if there is one
    if (currentSessionId) {
      onUpdateSessionPersonality(currentSessionId, newPersonalityId);
    }
  };
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const handleSend = () => {
    if (input.trim() && !isLoading) {
      console.log('AlwaysOnChatbot handleSend - currentPersonalityId:', currentPersonalityId, 'sessionPersonalityId:', sessionPersonalityId);
      onSendMessage(input.trim(), currentPersonalityId);
      setInput('');
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  return (
    <div className="h-full flex flex-col bg-zinc-900/50 rounded-lg border border-zinc-700/50">
      {/* Chat Header */}
      <div className="p-4 border-b border-zinc-700/50">
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <Bot className="w-5 h-5 text-blue-400" />
            <h3 className="font-semibold">AI Coach</h3>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-2 h-2 bg-emerald-400 rounded-full animate-pulse" />
            <span className="text-xs text-zinc-400">Always On</span>
          </div>
        </div>
        <PersonalitySelector 
          currentPersonalityId={currentPersonalityId} 
          onPersonalityChange={handlePersonalityChange}
          compact={true}
        />
        <ChatSessionSelector
          sessions={sessions}
          currentSessionId={currentSessionId}
          onSelectSession={onSelectSession}
          onNewSession={onNewSession}
          onArchiveSession={onArchiveSession}
          onRenameSession={onRenameSession}
        />
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {messages.length === 0 && (
          <div className="text-center py-8">
            <Bot className="w-12 h-12 text-zinc-600 mx-auto mb-4" />
            <h4 className="text-lg font-medium text-zinc-400 mb-2">Ready to chat</h4>
            <p className="text-zinc-500 text-sm">
              I have context of all your goals, tasks, and journal entries.
              <br />Switch modes above for different conversation styles.
            </p>
          </div>
        )}

        {messages.map((message) => (
          <motion.div
            key={message.id}
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            className={`flex gap-3 ${message.role === 'user' ? 'flex-row-reverse' : ''}`}
          >
            <div className={`w-8 h-8 rounded-full flex items-center justify-center ${
              message.role === 'user' 
                ? 'bg-blue-600' 
                : 'bg-zinc-700'
            }`}>
              {message.role === 'user' ? (
                <User className="w-4 h-4 text-white" />
              ) : (
                <Bot className="w-4 h-4 text-blue-400" />
              )}
            </div>
            <div className={`flex-1 max-w-[80%] ${message.role === 'user' ? 'text-right' : ''}`}>
              <div className={`p-3 rounded-lg ${
                message.role === 'user'
                  ? 'bg-blue-600 text-white ml-auto'
                  : 'bg-zinc-800 text-zinc-100'
              }`}>
                <p className="text-sm whitespace-pre-wrap">{message.content}</p>
              </div>
              <div className="flex items-center gap-2 mt-1 text-xs text-zinc-500">
                <span>{new Date(message.timestamp).toLocaleTimeString()}</span>
                {message.mode && (
                  <span className="px-1.5 py-0.5 bg-zinc-700/50 rounded text-xs">
                    {message.mode}
                  </span>
                )}
              </div>
            </div>
          </motion.div>
        ))}

        {isLoading && (
          <div className="flex gap-3">
            <div className="w-8 h-8 rounded-full bg-zinc-700 flex items-center justify-center">
              <Bot className="w-4 h-4 text-blue-400" />
            </div>
            <div className="bg-zinc-800 p-3 rounded-lg">
              <div className="flex items-center gap-1">
                <div className="w-2 h-2 bg-zinc-500 rounded-full animate-bounce" />
                <div className="w-2 h-2 bg-zinc-500 rounded-full animate-bounce" style={{ animationDelay: '0.1s' }} />
                <div className="w-2 h-2 bg-zinc-500 rounded-full animate-bounce" style={{ animationDelay: '0.2s' }} />
              </div>
            </div>
          </div>
        )}
        <div ref={messagesEndRef} />
      </div>

      {/* Input */}
      <div className="p-4 border-t border-zinc-700/50">
        <div className="flex gap-2">
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyPress={handleKeyPress}
            placeholder={`Ask ${getExpertById(currentPersonalityId)?.name || 'your AI expert'}...`}
            className="flex-1 bg-zinc-800 border border-zinc-700 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/50"
            disabled={isLoading}
          />
          <button
            onClick={handleSend}
            disabled={!input.trim() || isLoading}
            className="p-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
          >
            <Send className="w-4 h-4" />
          </button>
        </div>
      </div>
    </div>
  );
}

// Sticky Note Component for Notes and Ideas
function StickyNote({ entry, onUpdate, onDelete }: {
  entry: JournalEntry;
  onUpdate: (id: string, updates: Partial<JournalEntry>) => void;
  onDelete: (id: string) => void;
}) {
  const [isEditing, setIsEditing] = useState(false);
  const [editContent, setEditContent] = useState(entry.content);
  const [position, setPosition] = useState({ x: 0, y: 0 });
  const [isDragging, setIsDragging] = useState(false);
  const [showAIChat, setShowAIChat] = useState(false);

  const stickyColors = {
    note: 'bg-yellow-200/10 border-yellow-400/30 text-yellow-100',
    idea: 'bg-purple-200/10 border-purple-400/30 text-purple-100',
  };

  const handleSave = () => {
    onUpdate(entry.id, { content: editContent });
    setIsEditing(false);
  };

  const handleDragStart = (e: React.DragEvent) => {
    setIsDragging(true);
    const rect = (e.target as HTMLElement).getBoundingClientRect();
    const offsetX = e.clientX - rect.left;
    const offsetY = e.clientY - rect.top;
    e.dataTransfer.setData('text/plain', JSON.stringify({ offsetX, offsetY }));
  };

  const handleDragEnd = () => {
    setIsDragging(false);
  };

  return (
    <motion.div
      layout
      initial={{ opacity: 0, scale: 0.9 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 0.9 }}
      className={`relative p-4 rounded-lg border-2 cursor-move transform transition-transform hover:scale-105 ${
        stickyColors[entry.type as 'note' | 'idea']
      } ${isDragging ? 'rotate-2 shadow-xl' : 'hover:rotate-1'}`}
      draggable
      onDragStart={handleDragStart}
      onDragEnd={handleDragEnd}
      style={{ 
        transform: `translate(${position.x}px, ${position.y}px)`,
        minHeight: '150px'
      }}
    >
      {/* Header */}
      <div className="flex items-center justify-between mb-3">
        <div className="flex items-center gap-2">
          <span className={`text-xs px-2 py-1 rounded-full bg-white/10`}>
            {entry.type}
          </span>
          <span className="text-xs opacity-60">
            {new Date(entry.timestamp).toLocaleDateString()}
          </span>
        </div>
        <div className="flex items-center gap-1">
          <button
            onClick={() => setShowAIChat(!showAIChat)}
            className="p-1 text-current/60 hover:text-current rounded transition-colors"
            title="AI Chat"
          >
            <Bot className="w-3 h-3" />
          </button>
          <button
            onClick={() => setIsEditing(!isEditing)}
            className="p-1 text-current/60 hover:text-current rounded transition-colors"
            title="Edit"
          >
            <Edit3 className="w-3 h-3" />
          </button>
          <button
            onClick={() => onDelete(entry.id)}
            className="p-1 text-current/60 hover:text-rose-400 rounded transition-colors"
            title="Delete"
          >
            <Trash2 className="w-3 h-3" />
          </button>
        </div>
      </div>

      {/* Content */}
      {isEditing ? (
        <div className="space-y-2">
          <textarea
            value={editContent}
            onChange={(e) => setEditContent(e.target.value)}
            className="w-full bg-black/20 border border-white/20 rounded p-2 text-sm resize-none"
            rows={4}
            placeholder="Edit your note..."
          />
          <div className="flex gap-2">
            <button
              onClick={handleSave}
              className="px-3 py-1 bg-green-600 text-white rounded text-xs hover:bg-green-700 transition-colors"
            >
              Save
            </button>
            <button
              onClick={() => setIsEditing(false)}
              className="px-3 py-1 bg-zinc-600 text-white rounded text-xs hover:bg-zinc-700 transition-colors"
            >
              Cancel
            </button>
          </div>
        </div>
      ) : (
        <p className="text-sm leading-relaxed whitespace-pre-wrap">
          {entry.content}
        </p>
      )}

      {/* AI Chat Window */}
      <AnimatePresence>
        {showAIChat && (
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 10 }}
            className="absolute top-full left-0 right-0 mt-2 bg-zinc-900 border border-zinc-700 rounded-lg p-3 shadow-xl z-10"
          >
            <div className="flex items-center gap-2 mb-2">
              <Bot className="w-4 h-4 text-blue-400" />
              <span className="text-xs font-medium text-zinc-300">AI Assistant</span>
            </div>
            <textarea
              placeholder="Ask AI about this note..."
              className="w-full bg-zinc-800 border border-zinc-600 rounded p-2 text-xs resize-none"
              rows={2}
            />
            <button className="mt-2 px-3 py-1 bg-blue-600 text-white rounded text-xs hover:bg-blue-700 transition-colors">
              Send
            </button>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Tags */}
      {entry.tags && entry.tags.length > 0 && (
        <div className="flex flex-wrap gap-1 mt-3">
          {entry.tags.map((tag, index) => (
            <span key={index} className="text-xs bg-white/10 px-2 py-1 rounded">
              #{tag}
            </span>
          ))}
        </div>
      )}
    </motion.div>
  );
}

// Enhanced Journal & Notes Component with Saved Posts and Growth Tracking
function JournalNotesPanel({ 
  entries, 
  onAddEntry, 
  onUpdateEntry: _onUpdateEntry, 
  onDeleteEntry,
  tasks
}: { 
  entries: JournalEntry[]; 
  onAddEntry: (entry: Omit<JournalEntry, 'id' | 'timestamp'>) => void;
  onUpdateEntry: (id: string, updates: Partial<JournalEntry>) => void;
  onDeleteEntry: (id: string) => void;
  tasks: any[];
}) {
  const [activeTab, setActiveTab] = useState<'journal' | 'saved' | 'growth'>('journal');
  const [newEntry, setNewEntry] = useState('');
  const [entryType, setEntryType] = useState<'journal' | 'note' | 'idea' | 'reflection' | 'milestone' | 'lesson'>('journal');
  const [tags, setTags] = useState('');
  const [mood, setMood] = useState<'great' | 'good' | 'neutral' | 'challenging' | 'difficult' | ''>('');
  const [growthArea, setGrowthArea] = useState<'personal' | 'professional' | 'health' | 'relationships' | 'skills' | 'mindset' | ''>('');
  const [selectedTasks, setSelectedTasks] = useState<string[]>([]);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [savedPosts, setSavedPosts] = useState<SavedPost[]>([]);
  const [savedPostsFilter, setSavedPostsFilter] = useState<string>('');
  const [growthFilter, setGrowthFilter] = useState<string>('all');

  // Load saved posts
  useEffect(() => {
    const loadSavedPosts = () => {
      const posts = savedPostsService.getAllSavedPosts();
      setSavedPosts(posts);
    };

    loadSavedPosts();
    
    // Refresh every 5 seconds to catch new saves
    const interval = setInterval(loadSavedPosts, 5000);
    return () => clearInterval(interval);
  }, []);

  const handleAddEntry = () => {
    if (newEntry.trim()) {
      onAddEntry({
        date: new Date().toISOString().split('T')[0],
        content: newEntry.trim(),
        tags: tags.split(',').map(t => t.trim()).filter(Boolean),
        type: entryType,
        mood: mood || undefined,
        growthArea: growthArea || undefined,
        linkedTasks: selectedTasks.length > 0 ? selectedTasks : undefined
      });
      setNewEntry('');
      setTags('');
      setMood('');
      setGrowthArea('');
      setSelectedTasks([]);
    }
  };

  const handleToggleFavorite = (articleId: string) => {
    savedPostsService.toggleFavorite(articleId);
    setSavedPosts(savedPostsService.getAllSavedPosts());
  };

  const handleRemoveSavedPost = (articleId: string) => {
    savedPostsService.unsavePost(articleId);
    setSavedPosts(savedPostsService.getAllSavedPosts());
  };

  const entryTypes = [
    { value: 'journal', label: 'Journal', icon: BookOpen, color: 'text-blue-400' },
    { value: 'note', label: 'Note', icon: FileText, color: 'text-gray-400' },
    { value: 'idea', label: 'Idea', icon: Lightbulb, color: 'text-yellow-400' },
    { value: 'reflection', label: 'Reflection', icon: Sparkles, color: 'text-purple-400' },
    { value: 'milestone', label: 'Milestone', icon: Target, color: 'text-green-400' },
    { value: 'lesson', label: 'Lesson', icon: BookOpen, color: 'text-orange-400' }
  ];

  const moodOptions = [
    { value: 'great', label: '🌟 Great', color: 'text-green-400' },
    { value: 'good', label: '😊 Good', color: 'text-blue-400' },
    { value: 'neutral', label: '😐 Neutral', color: 'text-zinc-400' },
    { value: 'challenging', label: '😤 Challenging', color: 'text-amber-400' },
    { value: 'difficult', label: '😔 Difficult', color: 'text-red-400' }
  ];

  const growthAreas = [
    { value: 'personal', label: 'Personal', color: 'text-purple-400' },
    { value: 'professional', label: 'Professional', color: 'text-blue-400' },
    { value: 'health', label: 'Health', color: 'text-green-400' },
    { value: 'relationships', label: 'Relationships', color: 'text-pink-400' },
    { value: 'skills', label: 'Skills', color: 'text-orange-400' },
    { value: 'mindset', label: 'Mindset', color: 'text-indigo-400' }
  ];

  const tabs = [
    { id: 'journal', label: 'Journal & Notes', icon: PenTool, count: entries.length },
    { id: 'saved', label: 'Saved Posts', icon: Bookmark, count: savedPosts.length },
    { id: 'growth', label: 'Growth Tracking', icon: Target, count: entries.filter(e => e.type === 'reflection' || e.type === 'milestone' || e.type === 'lesson').length }
  ];

  const filteredSavedPosts = savedPosts.filter(post => 
    !savedPostsFilter || 
    post.article.title.toLowerCase().includes(savedPostsFilter.toLowerCase()) ||
    post.article.enhancedSummary.toLowerCase().includes(savedPostsFilter.toLowerCase()) ||
    post.tags.some(tag => tag.toLowerCase().includes(savedPostsFilter.toLowerCase()))
  );

  return (
    <div className="h-full flex flex-col bg-zinc-900/50 rounded-lg border border-zinc-700/50">
      {/* Header with Tabs */}
      <div className="p-4 border-b border-zinc-700/50">
        {/* Tab Navigation */}
        <div className="flex items-center gap-1 p-1 bg-zinc-800/50 rounded-lg mb-4">
          {tabs.map((tab) => {
            const Icon = tab.icon;
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id as any)}
                className={`flex items-center gap-2 px-3 py-2 rounded text-sm transition-colors ${
                  activeTab === tab.id 
                    ? 'bg-zinc-700 text-white' 
                    : 'text-zinc-400 hover:text-zinc-300'
                }`}
              >
                <Icon className="w-4 h-4" />
                <span>{tab.label}</span>
                <span className={`px-1.5 py-0.5 text-xs rounded-full ${
                  activeTab === tab.id ? 'bg-zinc-600' : 'bg-zinc-700'
                }`}>
                  {tab.count}
                </span>
              </button>
            );
          })}
        </div>

        {/* Journal Tab Content */}
        {activeTab === 'journal' && (
          <>
            {/* Entry Type Selector */}
            <div className="flex items-center gap-1 p-1 bg-zinc-800/50 rounded-lg mb-3">
              {entryTypes.map((type) => {
                const Icon = type.icon;
                return (
                  <button
                    key={type.value}
                    onClick={() => setEntryType(type.value as any)}
                    className={`flex items-center gap-1 px-2 py-1 rounded text-xs transition-colors ${
                      entryType === type.value 
                        ? 'bg-zinc-700 text-white' 
                        : 'text-zinc-400 hover:text-zinc-300'
                    }`}
                  >
                    <Icon className={`w-3 h-3 ${entryType === type.value ? type.color : ''}`} />
                    {type.label}
                  </button>
                );
              })}
            </div>

            {/* Quick Add */}
            <div className="space-y-3">
              <textarea
                value={newEntry}
                onChange={(e) => setNewEntry(e.target.value)}
                placeholder={`Write a ${entryType}...`}
                className="w-full bg-zinc-800 border border-zinc-700 rounded-lg px-3 py-2 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-blue-500/50"
                rows={3}
              />
              
              {/* Enhanced Fields for Growth Tracking */}
              {(entryType === 'reflection' || entryType === 'milestone' || entryType === 'lesson') && (
                <div className="grid grid-cols-2 gap-2">
                  <select
                    value={mood}
                    onChange={(e) => setMood(e.target.value as any)}
                    className="bg-zinc-800 border border-zinc-700 rounded px-2 py-1 text-xs focus:outline-none focus:ring-1 focus:ring-blue-500/50"
                  >
                    <option value="">Select mood...</option>
                    {moodOptions.map(option => (
                      <option key={option.value} value={option.value}>
                        {option.label}
                      </option>
                    ))}
                  </select>
                  
                  <select
                    value={growthArea}
                    onChange={(e) => setGrowthArea(e.target.value as any)}
                    className="bg-zinc-800 border border-zinc-700 rounded px-2 py-1 text-xs focus:outline-none focus:ring-1 focus:ring-blue-500/50"
                  >
                    <option value="">Growth area...</option>
                    {growthAreas.map(area => (
                      <option key={area.value} value={area.value}>
                        {area.label}
                      </option>
                    ))}
                  </select>
                </div>
              )}

              {/* Task Selection for Milestones */}
              {entryType === 'milestone' && (
                <div className="space-y-2">
                  <label className="text-xs text-zinc-400">Associated Tasks (optional)</label>
                  <div className="max-h-32 overflow-y-auto border border-zinc-700 rounded bg-zinc-800/50">
                    {tasks.length === 0 ? (
                      <p className="p-2 text-xs text-zinc-500">No tasks available</p>
                    ) : (
                      tasks.map((task) => (
                        <label key={task.id} className="flex items-center gap-2 p-2 hover:bg-zinc-700/50 cursor-pointer">
                          <input
                            type="checkbox"
                            checked={selectedTasks.includes(task.id)}
                            onChange={(e) => {
                              if (e.target.checked) {
                                setSelectedTasks(prev => [...prev, task.id]);
                              } else {
                                setSelectedTasks(prev => prev.filter(id => id !== task.id));
                              }
                            }}
                            className="rounded text-blue-600 focus:ring-blue-500"
                          />
                          <span className="text-xs text-zinc-300">{task.title}</span>
                          <span className={`text-xs px-1.5 py-0.5 rounded ${
                            task.status === 'completed' ? 'bg-green-600/20 text-green-400' :
                            task.status === 'in_progress' ? 'bg-blue-600/20 text-blue-400' :
                            'bg-zinc-600/20 text-zinc-400'
                          }`}>
                            {task.status}
                          </span>
                        </label>
                      ))
                    )}
                  </div>
                </div>
              )}
              
              <div className="flex gap-2">
                <input
                  type="text"
                  value={tags}
                  onChange={(e) => setTags(e.target.value)}
                  placeholder="Tags (comma-separated)"
                  className="flex-1 bg-zinc-800 border border-zinc-700 rounded px-2 py-1 text-xs focus:outline-none focus:ring-1 focus:ring-blue-500/50"
                />
                {/* AI Writing Assistant Button */}
                <button
                  onClick={() => {
                    const prompt = `Help me expand this ${entryType}: "${newEntry.trim()}"`;
                    // This would integrate with the AI service to expand the content
                    setNewEntry(prev => prev + "\n\n[AI expansion would appear here]");
                  }}
                  disabled={!newEntry.trim()}
                  className="px-3 py-1 bg-purple-600 text-white rounded text-xs hover:bg-purple-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center gap-1"
                  title="AI Writing Assistant"
                >
                  <Sparkles className="w-3 h-3" />
                  AI
                </button>
                <button
                  onClick={handleAddEntry}
                  disabled={!newEntry.trim()}
                  className="px-3 py-1 bg-blue-600 text-white rounded text-xs hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                >
                  Add
                </button>
              </div>
            </div>
          </>
        )}

        {/* Saved Posts Tab Content */}
        {activeTab === 'saved' && (
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <h4 className="text-sm font-medium text-zinc-300">Your Saved Posts</h4>
              <span className="text-xs text-zinc-400">{savedPosts.length} saved</span>
            </div>
            <input
              type="text"
              value={savedPostsFilter}
              onChange={(e) => setSavedPostsFilter(e.target.value)}
              placeholder="Search saved posts..."
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-3 py-2 text-sm focus:outline-none focus:ring-1 focus:ring-blue-500/50"
            />
          </div>
        )}

        {/* Growth Tracking Tab Content */}
        {activeTab === 'growth' && (
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <h4 className="text-sm font-medium text-zinc-300">Growth Insights</h4>
              <select
                value={growthFilter}
                onChange={(e) => setGrowthFilter(e.target.value)}
                className="text-xs bg-zinc-800 border border-zinc-600 rounded px-2 py-1"
              >
                <option value="all">All Areas</option>
                {growthAreas.map(area => (
                  <option key={area.value} value={area.value}>
                    {area.label}
                  </option>
                ))}
              </select>
            </div>
            
            {/* Growth Stats */}
            <div className="grid grid-cols-3 gap-2 mb-4">
              <div className="bg-zinc-800/50 p-3 rounded-lg text-center">
                <div className="text-lg font-bold text-green-400">
                  {entries.filter(e => e.type === 'milestone').length}
                </div>
                <div className="text-xs text-zinc-400">Milestones</div>
              </div>
              <div className="bg-zinc-800/50 p-3 rounded-lg text-center">
                <div className="text-lg font-bold text-purple-400">
                  {entries.filter(e => e.type === 'reflection').length}
                </div>
                <div className="text-xs text-zinc-400">Reflections</div>
              </div>
              <div className="bg-zinc-800/50 p-3 rounded-lg text-center">
                <div className="text-lg font-bold text-orange-400">
                  {entries.filter(e => e.type === 'lesson').length}
                </div>
                <div className="text-xs text-zinc-400">Lessons</div>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Content Area */}
      <div className="flex-1 overflow-y-auto p-4 space-y-3">
        {/* Journal Tab Content */}
        {activeTab === 'journal' && (
          <>
            {entries.length === 0 && (
              <div className="text-center py-8">
                <PenTool className="w-12 h-12 text-zinc-600 mx-auto mb-4" />
                <h4 className="text-lg font-medium text-zinc-400 mb-2">Start journaling</h4>
                <p className="text-zinc-500 text-sm">
                  Capture thoughts, ideas, and reflections.
                  <br />AI can help expand and organize your entries.
                </p>
              </div>
            )}

            {/* Sticky Notes Grid for Notes and Ideas */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-6">
              {entries.filter(entry => entry.type === 'note' || entry.type === 'idea').map((entry) => (
                <StickyNote 
                  key={entry.id} 
                  entry={entry} 
                  onUpdate={onUpdateEntry || (() => {})} 
                  onDelete={onDeleteEntry} 
                />
              ))}
            </div>

            {/* Regular Entries for Journal, Reflections, Milestones, Lessons */}
            {entries.filter(entry => !['note', 'idea'].includes(entry.type)).map((entry) => (
              <motion.div
                key={entry.id}
                layout
                className="p-3 bg-zinc-800/50 rounded-lg border border-zinc-700/30 hover:border-zinc-600/50 transition-colors"
              >
                <div className="flex items-start justify-between mb-2">
                  <div className="flex items-center gap-2">
                    {(() => {
                      const type = entryTypes.find(t => t.value === entry.type);
                      const Icon = type?.icon || FileText;
                      return <Icon className={`w-4 h-4 ${type?.color || 'text-gray-400'}`} />;
                    })()}
                    <span className="text-xs text-zinc-400">
                      {new Date(entry.timestamp).toLocaleString()}
                    </span>
                  </div>
                  <div className="flex items-center gap-1">
                    {entry.type === 'milestone' && (
                      <button
                        onClick={() => updateMilestoneWithAI && updateMilestoneWithAI(entry.id)}
                        className="p-1 text-zinc-400 hover:text-purple-400 rounded"
                        title="AI Progress Update"
                      >
                        <Sparkles className="w-3 h-3" />
                      </button>
                    )}
                    <button
                      onClick={() => setEditingId(editingId === entry.id ? null : entry.id)}
                      className="p-1 text-zinc-400 hover:text-zinc-300 rounded"
                    >
                      <Edit3 className="w-3 h-3" />
                    </button>
                    <button
                      onClick={() => onDeleteEntry(entry.id)}
                      className="p-1 text-zinc-400 hover:text-rose-400 rounded"
                    >
                      <Trash2 className="w-3 h-3" />
                    </button>
                  </div>
                </div>
                
                {/* Enhanced Display for Journal Entries */}
                {entry.type === 'journal' ? (
                  <div className="space-y-2">
                    <div className="text-sm text-zinc-200 leading-relaxed">
                      <div className="font-medium text-zinc-100 mb-1">
                        📝 {new Date(entry.timestamp).toLocaleDateString('en-US', { 
                          weekday: 'long', 
                          year: 'numeric', 
                          month: 'long', 
                          day: 'numeric' 
                        })}
                      </div>
                      <div className="pl-4 border-l-2 border-blue-500/30 whitespace-pre-wrap">
                        {entry.content}
                      </div>
                    </div>
                  </div>
                ) : (
                  <p className="text-sm text-zinc-200 mb-2 whitespace-pre-wrap">{entry.content}</p>
                )}
                
                {/* Growth Tracking Info */}
                {(entry.mood || entry.growthArea) && (
                  <div className="flex items-center gap-2 mb-2">
                    {entry.mood && (
                      <span className={`px-2 py-1 text-xs rounded-full bg-zinc-700/50 ${
                        moodOptions.find(m => m.value === entry.mood)?.color || 'text-zinc-400'
                      }`}>
                        {moodOptions.find(m => m.value === entry.mood)?.label || entry.mood}
                      </span>
                    )}
                    {entry.growthArea && (
                      <span className={`px-2 py-1 text-xs rounded-full bg-zinc-700/50 ${
                        growthAreas.find(g => g.value === entry.growthArea)?.color || 'text-zinc-400'
                      }`}>
                        {growthAreas.find(g => g.value === entry.growthArea)?.label || entry.growthArea}
                      </span>
                    )}
                  </div>
                )}
                
                {entry.tags.length > 0 && (
                  <div className="flex flex-wrap gap-1">
                    {entry.tags.map((tag, index) => (
                      <span
                        key={index}
                        className="px-1.5 py-0.5 bg-zinc-700/50 text-xs text-zinc-400 rounded"
                      >
                        #{tag}
                      </span>
                    ))}
                  </div>
                )}
              </motion.div>
            ))}
          </>
        )}

        {/* Growth Tracking Tab Content */}
        {activeTab === 'growth' && (
          <>
            {(() => {
              const growthEntries = entries.filter(e => 
                (e.type === 'reflection' || e.type === 'milestone' || e.type === 'lesson') &&
                (growthFilter === 'all' || e.growthArea === growthFilter)
              );
              
              if (growthEntries.length === 0) {
                return (
                  <div className="text-center py-8">
                    <Target className="w-12 h-12 text-zinc-600 mx-auto mb-4" />
                    <h4 className="text-lg font-medium text-zinc-400 mb-2">Start Your Growth Journey</h4>
                    <p className="text-zinc-500 text-sm mb-4">
                      Track your personal development with reflections, milestones, and lessons learned.
                    </p>
                    <button
                      onClick={() => {
                        setActiveTab('journal');
                        setEntryType('reflection');
                      }}
                      className="btn-primary"
                    >
                      Add First Reflection
                    </button>
                  </div>
                );
              }
              
              return (
                <div className="space-y-4">
                  {/* Growth Timeline */}
                  <div className="space-y-3">
                    {growthEntries
                      .sort((a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime())
                      .map((entry) => (
                        <motion.div
                          key={entry.id}
                          layout
                          className={`p-4 rounded-lg border transition-all ${
                            entry.type === 'milestone' ? 'bg-green-500/10 border-green-500/30' :
                            entry.type === 'reflection' ? 'bg-purple-500/10 border-purple-500/30' :
                            'bg-orange-500/10 border-orange-500/30'
                          }`}
                        >
                          <div className="flex items-start justify-between mb-2">
                            <div className="flex items-center gap-2">
                              {(() => {
                                const type = entryTypes.find(t => t.value === entry.type);
                                const Icon = type?.icon || Target;
                                return <Icon className={`w-4 h-4 ${type?.color || 'text-gray-400'}`} />;
                              })()}
                              <span className="text-xs text-zinc-400">
                                {new Date(entry.timestamp).toLocaleDateString()}
                              </span>
                              {entry.type === 'milestone' && <span className="text-xs bg-green-500/20 px-2 py-1 rounded text-green-400">🎯 Milestone</span>}
                            </div>
                            <div className="flex items-center gap-1">
                              <button
                                onClick={() => setEditingId(editingId === entry.id ? null : entry.id)}
                                className="p-1 text-zinc-400 hover:text-zinc-300 rounded"
                              >
                                <Edit3 className="w-3 h-3" />
                              </button>
                              <button
                                onClick={() => onDeleteEntry(entry.id)}
                                className="p-1 text-zinc-400 hover:text-rose-400 rounded"
                              >
                                <Trash2 className="w-3 h-3" />
                              </button>
                            </div>
                          </div>
                          
                          <p className="text-sm text-zinc-200 mb-3 whitespace-pre-wrap">{entry.content}</p>
                          
                          {/* Growth Metadata */}
                          <div className="flex items-center gap-2 mb-2">
                            {entry.mood && (
                              <span className={`px-2 py-1 text-xs rounded-full bg-zinc-700/50 ${
                                moodOptions.find(m => m.value === entry.mood)?.color || 'text-zinc-400'
                              }`}>
                                {moodOptions.find(m => m.value === entry.mood)?.label || entry.mood}
                              </span>
                            )}
                            {entry.growthArea && (
                              <span className={`px-2 py-1 text-xs rounded-full bg-zinc-700/50 ${
                                growthAreas.find(g => g.value === entry.growthArea)?.color || 'text-zinc-400'
                              }`}>
                                📈 {growthAreas.find(g => g.value === entry.growthArea)?.label || entry.growthArea}
                              </span>
                            )}
                          </div>
                          
                          {entry.tags.length > 0 && (
                            <div className="flex flex-wrap gap-1">
                              {entry.tags.map((tag, index) => (
                                <span
                                  key={index}
                                  className="px-1.5 py-0.5 bg-zinc-700/50 text-xs text-zinc-400 rounded"
                                >
                                  #{tag}
                                </span>
                              ))}
                            </div>
                          )}
                        </motion.div>
                      ))}
                  </div>
                </div>
              );
            })()}
          </>
        )}

        {/* Saved Posts Tab Content */}
        {activeTab === 'saved' && (
          <>
            {filteredSavedPosts.length === 0 && (
              <div className="text-center py-8">
                <Bookmark className="w-12 h-12 text-zinc-600 mx-auto mb-4" />
                <h4 className="text-lg font-medium text-zinc-400 mb-2">
                  {savedPosts.length === 0 ? 'No saved posts yet' : 'No posts match your search'}
                </h4>
                <p className="text-zinc-500 text-sm">
                  {savedPosts.length === 0 
                    ? 'Save interesting articles from the recommendations to access them here.'
                    : 'Try adjusting your search terms or clearing the filter.'}
                </p>
              </div>
            )}

            {filteredSavedPosts.map((savedPost) => (
              <motion.div
                key={savedPost.id}
                layout
                className="p-4 bg-zinc-800/50 rounded-lg border border-zinc-700/30 hover:border-zinc-600/50 transition-colors"
              >
                <div className="flex items-start justify-between mb-3">
                  <div className="flex items-center gap-2">
                    <div className={`px-2 py-1 rounded text-xs font-medium ${{
                      'news': 'bg-blue-600/20 text-blue-400',
                      'philosophy': 'bg-purple-600/20 text-purple-400',
                      'geopolitics': 'bg-emerald-600/20 text-emerald-400',
                      'finance': 'bg-amber-600/20 text-amber-400',
                      'facts': 'bg-cyan-600/20 text-cyan-400'
                    }[savedPost.category] || 'bg-zinc-600/20 text-zinc-400'}`}>
                      {savedPost.category}
                    </div>
                    <span className="text-xs text-zinc-400">
                      <Calendar className="w-3 h-3 inline mr-1" />
                      {new Date(savedPost.savedAt).toLocaleDateString()}
                    </span>
                  </div>
                  <div className="flex items-center gap-1">
                    <button
                      onClick={() => handleToggleFavorite(savedPost.article.id)}
                      className={`p-1 rounded transition-colors ${
                        savedPost.isFavorite ? 'text-amber-400' : 'text-zinc-400 hover:text-amber-400'
                      }`}
                      title={savedPost.isFavorite ? 'Remove from favorites' : 'Add to favorites'}
                    >
                      <Star className={`w-4 h-4 ${savedPost.isFavorite ? 'fill-current' : ''}`} />
                    </button>
                    <a
                      href={savedPost.article.url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="p-1 text-zinc-400 hover:text-zinc-300 rounded transition-colors"
                      title="Open original article"
                    >
                      <ExternalLink className="w-4 h-4" />
                    </a>
                    <button
                      onClick={() => handleRemoveSavedPost(savedPost.article.id)}
                      className="p-1 text-zinc-400 hover:text-rose-400 rounded transition-colors"
                      title="Remove from saved posts"
                    >
                      <X className="w-4 h-4" />
                    </button>
                  </div>
                </div>
                
                <h4 className="font-medium text-zinc-200 mb-2 line-clamp-2">
                  {savedPost.article.title}
                </h4>
                
                <p className="text-sm text-zinc-400 mb-3 line-clamp-3">
                  {savedPost.article.enhancedSummary}
                </p>

                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2 text-xs text-zinc-500">
                    <span>{savedPost.article.sourceDomain}</span>
                    <span>•</span>
                    <span>{new Date(savedPost.article.publishedAt).toLocaleDateString()}</span>
                  </div>
                  
                  {savedPost.tags.length > 0 && (
                    <div className="flex items-center gap-1">
                      <Tags className="w-3 h-3 text-zinc-500" />
                      <div className="flex flex-wrap gap-1">
                        {savedPost.tags.slice(0, 3).map((tag, index) => (
                          <span
                            key={index}
                            className="px-1.5 py-0.5 bg-zinc-700/50 text-xs text-zinc-400 rounded"
                          >
                            {tag}
                          </span>
                        ))}
                        {savedPost.tags.length > 3 && (
                          <span className="text-xs text-zinc-500">+{savedPost.tags.length - 3}</span>
                        )}
                      </div>
                    </div>
                  )}
                </div>

                {savedPost.notes && (
                  <div className="mt-3 pt-3 border-t border-zinc-700/50">
                    <p className="text-sm text-zinc-300 italic">{savedPost.notes}</p>
                  </div>
                )}
              </motion.div>
            ))}
          </>
        )}
      </div>
    </div>
  );
}

// Recommendation Panel Component
function _RecommendationPanelComponent({ 
  panel, 
  onToggleVisibility, 
  onTogglePin, 
  onRefresh 
}: { 
  panel: any; 
  onToggleVisibility: (id: string) => void;
  onTogglePin: (id: string) => void;
  onRefresh: (id: string) => void;
}) {
  const [isExpanded, setIsExpanded] = useState(true);
  const Icon = panel.icon;

  if (!panel.isVisible) return null;

  return (
    <motion.div
      layout
      className="bg-zinc-900/50 rounded-lg border border-zinc-700/50 overflow-hidden"
    >
      {/* Panel Header */}
      <div className="p-3 border-b border-zinc-700/50 bg-zinc-800/30">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Icon className={`w-4 h-4 ${panel.color}`} />
            <h4 className="font-medium text-sm">{panel.title}</h4>
            <span className="text-xs text-zinc-500">({panel.items.length})</span>
          </div>
          <div className="flex items-center gap-1">
            <button
              onClick={() => onTogglePin(panel.id)}
              className={`p-1 rounded transition-colors ${
                panel.isPinned ? 'text-blue-400' : 'text-zinc-400 hover:text-zinc-300'
              }`}
              title={panel.isPinned ? 'Unpin' : 'Pin'}
            >
              <Pin className="w-3 h-3" />
            </button>
            <button
              onClick={() => onRefresh(panel.id)}
              className="p-1 text-zinc-400 hover:text-zinc-300 rounded transition-colors"
              title="Refresh"
            >
              <RefreshCw className="w-3 h-3" />
            </button>
            <button
              onClick={() => setIsExpanded(!isExpanded)}
              className="p-1 text-zinc-400 hover:text-zinc-300 rounded transition-colors"
            >
              {isExpanded ? <ChevronUp className="w-3 h-3" /> : <ChevronDown className="w-3 h-3" />}
            </button>
            <button
              onClick={() => onToggleVisibility(panel.id)}
              className="p-1 text-zinc-400 hover:text-rose-400 rounded transition-colors"
              title="Hide"
            >
              <X className="w-3 h-3" />
            </button>
          </div>
        </div>
      </div>

      {/* Panel Content */}
      <AnimatePresence>
        {isExpanded && (
          <motion.div
            initial={{ height: 0 }}
            animate={{ height: 'auto' }}
            exit={{ height: 0 }}
            className="overflow-hidden"
          >
            <div className="p-3 space-y-2 max-h-64 overflow-y-auto">
              {panel.items.length === 0 ? (
                <div className="text-center py-4">
                  <Icon className={`w-8 h-8 ${panel.color} mx-auto mb-2 opacity-50`} />
                  <p className="text-xs text-zinc-500">No items yet</p>
                  <button
                    onClick={() => onRefresh(panel.id)}
                    className="text-xs text-blue-400 hover:text-blue-300 mt-1"
                  >
                    Load content
                  </button>
                </div>
              ) : (
                panel.items.map((item: any) => (
                  <div
                    key={item.id}
                    className="p-2 bg-zinc-800/30 rounded border border-zinc-700/30 hover:border-zinc-600/50 transition-colors"
                  >
                    <div className="flex items-start justify-between mb-1">
                      <h5 className="text-xs font-medium text-zinc-200 line-clamp-2">{item.title}</h5>
                      {item.url && (
                        <button className="p-1 text-zinc-400 hover:text-zinc-300 rounded">
                          <ExternalLink className="w-3 h-3" />
                        </button>
                      )}
                    </div>
                    <p className="text-xs text-zinc-400 line-clamp-2 mb-1">{item.content}</p>
                    {item.aiInsight && (
                      <div className="p-1.5 bg-blue-600/10 border border-blue-600/20 rounded text-xs text-blue-300">
                        <Sparkles className="w-3 h-3 inline mr-1" />
                        {item.aiInsight}
                      </div>
                    )}
                    <div className="flex items-center justify-between mt-1">
                      {item.source && (
                        <span className="text-xs text-zinc-500">{item.source}</span>
                      )}
                      <button className="text-xs text-blue-400 hover:text-blue-300">
                        Reflect on this
                      </button>
                    </div>
                  </div>
                ))
              )}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
}

// Resizable Pane Component
function ResizablePane({ 
  children, 
  defaultWidth = 50, 
  minWidth = 20, 
  maxWidth = 80 
}: { 
  children: React.ReactNode; 
  defaultWidth?: number; 
  minWidth?: number; 
  maxWidth?: number; 
}) {
  const [width, setWidth] = useState(defaultWidth);
  const [isResizing, setIsResizing] = useState(false);
  const paneRef = useRef<HTMLDivElement>(null);

  const handleMouseDown = (e: React.MouseEvent) => {
    setIsResizing(true);
    e.preventDefault();
  };

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      if (!isResizing || !paneRef.current) return;

      const containerRect = paneRef.current.parentElement?.getBoundingClientRect();
      if (!containerRect) return;

      const newWidth = ((e.clientX - containerRect.left) / containerRect.width) * 100;
      const clampedWidth = Math.min(Math.max(newWidth, minWidth), maxWidth);
      setWidth(clampedWidth);
    };

    const handleMouseUp = () => {
      setIsResizing(false);
    };

    if (isResizing) {
      document.addEventListener('mousemove', handleMouseMove);
      document.addEventListener('mouseup', handleMouseUp);
    }

    return () => {
      document.removeEventListener('mousemove', handleMouseMove);
      document.removeEventListener('mouseup', handleMouseUp);
    };
  }, [isResizing, minWidth, maxWidth]);

  return (
    <div 
      ref={paneRef}
      className="relative h-full"
      style={{ width: `${width}%` }}
    >
      {children}
      <div
        className={`absolute top-0 right-0 w-1 h-full cursor-col-resize hover:bg-blue-500/50 transition-colors ${
          isResizing ? 'bg-blue-500' : 'bg-transparent'
        }`}
        onMouseDown={handleMouseDown}
      >
        <div className="absolute top-1/2 right-0 transform translate-x-1/2 -translate-y-1/2">
          <GripVertical className="w-4 h-4 text-zinc-500" />
        </div>
      </div>
    </div>
  );
}

// Main ReflectionsPage Component
export default function ReflectionsPage() {
  const { 
    tasks, 
    goals, 
    reflections,
    addReflection,
    updateReflection,
    deleteReflection,
    updateMilestoneWithAI,
    chatSessions, 
    currentSessionId, 
    createChatSession, 
    selectChatSession, 
    addMessageToSession, 
    updateChatSession, 
    archiveChatSession, 
    getCurrentSession 
  } = useAppStore();
  
  // Chat State - use store's chat history
  const [isChatLoading, setIsChatLoading] = useState(false);

  // Recommendation System State
  const [recommendationPanels, setRecommendationPanels] = useState<RecommendationPanel[]>([]);
  const [selectedPanel, setSelectedPanel] = useState<RecommendationPanel | null>(null);
  const [showRecommendationPopup, setShowRecommendationPopup] = useState(false);

  // Initialize with a default session if none exist
  useEffect(() => {
    console.log('Chat sessions initialization - current sessions:', chatSessions.length, 'currentSessionId:', currentSessionId);
    if (chatSessions.length === 0) {
      console.log('Creating default session');
      const sessionId = createChatSession(`Welcome Chat ${new Date().toLocaleDateString()}`, 'general-holistic');
      console.log('Created session with ID:', sessionId);
    } else if (!currentSessionId && chatSessions.length > 0) {
      console.log('Sessions exist but no current session selected, selecting first session');
      selectChatSession(chatSessions[0].id);
    }
  }, [chatSessions.length, currentSessionId, createChatSession, selectChatSession]);

  // Debug: Log sessions when they change
  useEffect(() => {
    console.log('Chat sessions updated:', chatSessions.length, chatSessions);
  }, [chatSessions]);

  // Analytics and recommendations
  useEffect(() => {
    const generateRecommendations = async () => {
      const insights = analyticsService.aggregateUserData({
        tasks,
        goals,
        sessions: [], // We don't have focus sessions in current store, but analytics handles empty arrays
        reflections: [] // Similarly for reflections
      });
      
      const panels = await analyticsService.generateRecommendationPanels(insights);
      setRecommendationPanels(panels);
    };

    // Generate recommendations on data changes
    if (tasks.length > 0 || goals.length > 0) {
      generateRecommendations();
    }

    // Auto-refresh every 5 minutes
    const interval = setInterval(generateRecommendations, 5 * 60 * 1000);
    return () => clearInterval(interval);
  }, [tasks, goals]);
  
  // Convert store reflections to journal entries format
  const journalEntries: JournalEntry[] = reflections.map(reflection => ({
    id: reflection.id,
    date: reflection.date,
    timestamp: reflection.date,
    content: reflection.content || '',
    tags: reflection.tags || [],
    type: reflection.type as JournalEntry['type'],
    mood: undefined, // Add these fields to store Reflection interface later
    growthArea: undefined,
    linkedGoals: undefined,
    linkedTasks: undefined
  }));
  

  // Chat Session Functions
  const handleNewSession = () => {
    createChatSession(`Chat ${new Date().toLocaleDateString()} ${new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}`, 'lock-in-coach');
  };

  const handleSelectSession = (sessionId: string) => {
    console.log('Selecting session:', sessionId);
    selectChatSession(sessionId);
  };

  const handleRenameSession = (sessionId: string, newTitle: string) => {
    updateChatSession(sessionId, { title: newTitle });
  };

  const handleUpdateSessionPersonality = (sessionId: string, personalityId: string) => {
    updateChatSession(sessionId, { personalityId });
  };

  const handleArchiveSession = (sessionId: string) => {
    archiveChatSession(sessionId);
  };

  // Get current session messages
  const getCurrentSessionMessages = () => {
    const currentSession = getCurrentSession();
    console.log('getCurrentSessionMessages - currentSessionId:', currentSessionId, 'Found session:', !!currentSession, 'Messages:', currentSession?.messages?.length || 0);
    console.log('Available sessions:', chatSessions.map(s => ({ id: s.id, title: s.title, messageCount: s.messages.length })));
    return currentSession?.messages || [];
  };

  // Get current session personality
  const getCurrentSessionPersonality = () => {
    const currentSession = getCurrentSession();
    return currentSession?.personalityId || 'lock-in-coach';
  };

  // Chat Functions
  const handleSendMessage = async (message: string, personalityId: string) => {
    console.log('handleSendMessage called with:', { message, personalityId });
    const userMessage: ChatMessage = {
      id: Date.now().toString(),
      role: 'user',
      content: message,
      timestamp: new Date().toISOString(),
      mode: 'coaching' // Keep for backward compatibility
    };

    // Add user message to current session
    if (currentSessionId) {
      addMessageToSession(currentSessionId, userMessage);
    }
    setIsChatLoading(true);

    try {
      // Build context from current data
      const context = {
        tasks: tasks || [],
        goals: goals || [],
        sessions: [], // We don't have sessions in this context yet
        reflections: [], // We don't have reflections in this context yet
        settings: {},
        personalityId: personalityId,
        // Legacy context for backward compatibility
        todaysTasks: tasks.filter(t => t.due === new Date().toISOString().split('T')[0]),
        activeGoals: goals.filter(g => g.status === 'active'),
        recentJournalEntries: journalEntries.slice(-3)
      };

      const response = await aiService.sendMessage(message, context);
      
      const assistantMessage: ChatMessage = {
        id: (Date.now() + 1).toString(),
        role: 'assistant',
        content: response,
        timestamp: new Date().toISOString(),
        mode: 'coaching' // Keep for backward compatibility
      };

      // Add assistant message to current session
      if (currentSessionId) {
        addMessageToSession(currentSessionId, assistantMessage);
      }
    } catch (error) {
      console.error('Chat error:', error);
      const errorMessage: ChatMessage = {
        id: (Date.now() + 1).toString(),
        role: 'assistant',
        content: 'Sorry, I encountered an error. Make sure Ollama is running on localhost:11434.',
        timestamp: new Date().toISOString()
      };
      if (currentSessionId) {
        addMessageToSession(currentSessionId, errorMessage);
      }
    } finally {
      setIsChatLoading(false);
    }
  };

  // Journal Functions - now using store
  const handleAddJournalEntry = (entry: Omit<JournalEntry, 'id' | 'timestamp'>) => {
    addReflection({
      date: new Date().toISOString(),
      title: entry.content.slice(0, 50) + (entry.content.length > 50 ? '...' : ''),
      type: entry.type,
      content: entry.content,
      tags: entry.tags
    });
  };

  const handleUpdateJournalEntry = (id: string, updates: Partial<JournalEntry>) => {
    updateReflection(id, {
      content: updates.content,
      tags: updates.tags,
      type: updates.type
    });
  };

  const handleDeleteJournalEntry = (id: string) => {
    deleteReflection(id);
  };


  // Analytics recommendation handlers
  const handlePanelClick = (panel: RecommendationPanel) => {
    setSelectedPanel(panel);
    setShowRecommendationPopup(true);
  };

  const handleCloseRecommendationPopup = () => {
    setShowRecommendationPopup(false);
    setSelectedPanel(null);
  };

  const handleActionTaken = (insightId: string, action: string) => {
    console.log('Action taken:', { insightId, action });
    // Here you could implement action logging or triggering specific behaviors
    
    // For now, we'll just log it
    // In the future, you could:
    // - Create tasks based on suggested actions
    // - Update goals based on insights
    // - Trigger other workflows
  };

  // Refresh handler for banner panels
  const handleRefreshPanel = (id: string) => {
    console.log(`Refreshing panel: ${id}`);
    // Analytics panels will be refreshed automatically
    // Scraped content will be refreshed by the banner component
  };

  return (
    <div className="h-screen flex flex-col overflow-hidden bg-zinc-950">
      {/* Top - Fixed Height Recommendations Banner */}
      <div className="h-48 flex-shrink-0 p-4 border-b border-zinc-800 overflow-hidden">
        <div className="h-full">
          <RecommendationsBanner
            panels={recommendationPanels}
            onRefresh={handleRefreshPanel}
          />
        </div>
      </div>

      {/* Bottom - Fixed Height Chat and Journal Panes */}
      <div className="flex-1 flex overflow-hidden min-h-0">
        {/* Left Pane - Always-On Chatbot (Resizable) */}
        <ResizablePane defaultWidth={50} minWidth={30} maxWidth={70}>
          <div className="h-full p-4 pr-2">
            <AlwaysOnChatbot
              messages={getCurrentSessionMessages()}
              sessions={chatSessions}
              currentSessionId={currentSessionId}
              sessionPersonalityId={getCurrentSessionPersonality()}
              onSendMessage={handleSendMessage}
              onSelectSession={handleSelectSession}
              onNewSession={handleNewSession}
              onArchiveSession={handleArchiveSession}
              onRenameSession={handleRenameSession}
              onUpdateSessionPersonality={handleUpdateSessionPersonality}
              isLoading={isChatLoading}
            />
          </div>
        </ResizablePane>

        {/* Right Pane - Journal & Notes */}
        <div className="flex-1 h-full p-4 pl-2 min-w-0">
          <JournalNotesPanel
            entries={journalEntries}
            onAddEntry={handleAddJournalEntry}
            onUpdateEntry={handleUpdateJournalEntry}
            onDeleteEntry={handleDeleteJournalEntry}
            tasks={tasks}
          />
        </div>
      </div>

      {/* Recommendation System */}
      <RecommendationIndicator 
        panels={recommendationPanels}
        onPanelClick={handlePanelClick}
      />
      
      {selectedPanel && (
        <RecommendationPopup
          panel={selectedPanel}
          isVisible={showRecommendationPopup}
          onClose={handleCloseRecommendationPopup}
          onActionTaken={handleActionTaken}
        />
      )}
    </div>
  );
}