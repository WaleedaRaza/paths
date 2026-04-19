/**
 * Personas mirrored from v1 `lifeline_os/lib/core/constants/experts.dart`.
 * UI-only until backend wiring; ids must stay stable for scene `personaIds`.
 */
export interface Persona {
  id: string
  name: string
  icon: string
  /** Accent for chips / canvas */
  accentHex: string
  shortDescription: string
}

export const PERSONAS: Persona[] = [
  {
    id: 'mirror-guide',
    name: 'The Mirror-Guide',
    icon: '🪞',
    accentHex: '#3b82f6',
    shortDescription: 'Holistic strategist — big picture and connections',
  },
  {
    id: 'lock-in-coach',
    name: 'The Lock-In Coach',
    icon: '⚡',
    accentHex: '#dc2626',
    shortDescription: 'Accountability — cut procrastination, ship now',
  },
  {
    id: 'planner',
    name: 'The Planner',
    icon: '📋',
    accentHex: '#16a34a',
    shortDescription: 'Structures chaos into systems and next steps',
  },
  {
    id: 'therapist',
    name: 'The Therapist',
    icon: '🧠',
    accentHex: '#9333ea',
    shortDescription: 'Patterns, emotions, compassionate reframes',
  },
  {
    id: 'philosopher',
    name: 'The Philosopher',
    icon: '🏛️',
    accentHex: '#d97706',
    shortDescription: 'Meaning, values, perspective under pressure',
  },
  {
    id: 'psych-strategist',
    name: 'The Psych Strategist',
    icon: '🧩',
    accentHex: '#db2777',
    shortDescription: 'Influence, framing, social systems',
  },
  {
    id: 'architect',
    name: 'The Architect',
    icon: '🏗️',
    accentHex: '#0891b2',
    shortDescription: 'Systems design, boundaries, scalability',
  },
  {
    id: 'founder-engineer',
    name: 'The Founder-Engineer',
    icon: '🚀',
    accentHex: '#ea580c',
    shortDescription: 'Wedge, experiments, shipping mindset',
  },
  {
    id: 'kobayashi-maru',
    name: 'Kobayashi Maru',
    icon: '🎭',
    accentHex: '#b91c1c',
    shortDescription: 'Adversarial sparring / debate practice',
  },
]

export function personaById(id: string): Persona | undefined {
  return PERSONAS.find((p) => p.id === id)
}
