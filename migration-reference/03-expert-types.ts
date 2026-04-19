// 🎯 Expert System Types - Clean and Simple

export interface Expert {
  id: string;
  name: string;
  archetype: string;
  category: 'holistic' | 'productivity' | 'planning' | 'mental-health' | 'philosophy' | 'psychology' | 'technical' | 'finance';
  description: string;
  icon: string;
  color: string;
  
  voice: {
    tone: string;
    style: string;
    verbosity: 'terse' | 'moderate' | 'verbose';
  };
  
  contextNeeds: {
    coreIdentity: boolean;     // Always gets basic user profile
    currentState: boolean;     // Tasks, goals, current projects
    recentActivity: boolean;   // Last few actions/conversations
    domainData: string[];      // Specific data this expert needs
  };
  
  systemPrompt: string;        // WHO THEY ARE first, then how they help
}

export interface ExpertContext {
  coreIdentity?: string;       // Basic user facts
  currentState?: string;       // Current tasks/goals/projects
  recentActivity?: string;     // Recent actions
  domainSpecific?: string;     // Expert-specific context
}

export interface ExpertResponse {
  content: string;
  expertId: string;
  timestamp: string;
}
