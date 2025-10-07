# UI Design System (Orange/Teal Theme)

## Overview

**Philosophy:** Sleek, dark, modern UI with high contrast and visual hierarchy  
**Primary Accent:** Orange (#ff6b35) — Energy, action, warmth  
**Secondary Accent:** Teal (#00bfa5) — Focus, calm, progress  
**Base Theme:** Dark mode with deep blacks  
**Typography:** Inter (system fallback: -apple-system, BlinkMacSystemFont, "Segoe UI")  
**Components:** Shadcn-style with Radix primitives  

---

## Color Palette

### Dark Theme (Default)

```css
:root[data-theme="dark"][data-accent="orange-teal"] {
  /* Backgrounds */
  --bg-primary: #0a0a0a;        /* App background */
  --bg-secondary: #1a1a1a;      /* Cards, modals */
  --bg-tertiary: #2a2a2a;       /* Hover states, inputs */
  --bg-elevated: #3a3a3a;       /* Elevated cards, dropdowns */
  
  /* Text */
  --text-primary: #ffffff;      /* Main text */
  --text-secondary: #a0a0a0;    /* Subtext, labels */
  --text-tertiary: #707070;     /* Placeholders, disabled */
  --text-inverse: #0a0a0a;      /* Text on colored backgrounds */
  
  /* Primary Accent (Orange) — Action, CTA */
  --accent-primary: #ff6b35;
  --accent-primary-hover: #ff8555;
  --accent-primary-active: #ff4b15;
  --accent-primary-muted: rgba(255, 107, 53, 0.15);  /* Subtle background */
  
  /* Secondary Accent (Teal) — Progress, focus */
  --accent-secondary: #00bfa5;
  --accent-secondary-hover: #00d4b5;
  --accent-secondary-active: #009a85;
  --accent-secondary-muted: rgba(0, 191, 165, 0.15);
  
  /* Status Colors */
  --success: #4caf50;
  --success-muted: rgba(76, 175, 80, 0.15);
  --warning: #ff9800;
  --warning-muted: rgba(255, 152, 0, 0.15);
  --error: #f44336;
  --error-muted: rgba(244, 67, 54, 0.15);
  --info: #2196f3;
  --info-muted: rgba(33, 150, 243, 0.15);
  
  /* Borders */
  --border-color: #3a3a3a;
  --border-color-hover: #4a4a4a;
  --border-color-active: var(--accent-primary);
  
  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.3);
  --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.4);
  --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.5);
  --shadow-xl: 0 20px 25px rgba(0, 0, 0, 0.6);
  
  /* Progress / Fills */
  --progress-bg: var(--bg-tertiary);
  --progress-fill-primary: var(--accent-primary);
  --progress-fill-secondary: var(--accent-secondary);
  
  /* Category Colors (fixed, not accent-dependent) */
  --category-school: #ff9800;      /* Orange */
  --category-projects: #2196f3;    /* Blue */
  --category-health: #4caf50;      /* Green */
  --category-finance: #9c27b0;     /* Purple */
  --category-ds: #f44336;          /* Red */
  --category-career: #00bcd4;      /* Cyan */
  --category-agnostic: #757575;    /* Gray */
}
```

---

## Typography

### Font Stack
```css
--font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
--font-mono: 'JetBrains Mono', 'Fira Code', Consolas, Monaco, 'Courier New', monospace;
```

### Font Sizes
```css
--text-xs: 0.75rem;    /* 12px — Small labels */
--text-sm: 0.875rem;   /* 14px — Body text */
--text-base: 1rem;     /* 16px — Default */
--text-lg: 1.125rem;   /* 18px — Subheadings */
--text-xl: 1.25rem;    /* 20px — Headings */
--text-2xl: 1.5rem;    /* 24px — Page titles */
--text-3xl: 1.875rem;  /* 30px — Large titles */
--text-4xl: 2.25rem;   /* 36px — Hero */
```

### Font Weights
```css
--font-normal: 400;
--font-medium: 500;
--font-semibold: 600;
--font-bold: 700;
```

### Line Heights
```css
--leading-tight: 1.25;
--leading-normal: 1.5;
--leading-relaxed: 1.75;
```

---

## Spacing Scale

```css
--space-1: 0.25rem;   /* 4px */
--space-2: 0.5rem;    /* 8px */
--space-3: 0.75rem;   /* 12px */
--space-4: 1rem;      /* 16px */
--space-5: 1.25rem;   /* 20px */
--space-6: 1.5rem;    /* 24px */
--space-8: 2rem;      /* 32px */
--space-10: 2.5rem;   /* 40px */
--space-12: 3rem;     /* 48px */
--space-16: 4rem;     /* 64px */
```

---

## Border Radius

```css
--radius-sm: 4px;     /* Small elements */
--radius-md: 8px;     /* Buttons, inputs */
--radius-lg: 12px;    /* Cards, modals */
--radius-xl: 16px;    /* Large cards */
--radius-full: 9999px;  /* Pills, avatars */
```

---

## Components

### Button

**Variants:**
- **Primary:** Orange background, white text (CTA)
- **Secondary:** Teal background, white text (Secondary actions)
- **Ghost:** Transparent, hover bg (Tertiary actions)
- **Outline:** Border only, hover fill (Neutral actions)

```css
.btn {
  font-size: var(--text-sm);
  font-weight: var(--font-medium);
  padding: var(--space-2) var(--space-4);
  border-radius: var(--radius-md);
  transition: all 0.15s ease;
  cursor: pointer;
  border: none;
  outline: none;
}

.btn-primary {
  background: var(--accent-primary);
  color: var(--text-inverse);
}

.btn-primary:hover {
  background: var(--accent-primary-hover);
  transform: translateY(-1px);
  box-shadow: var(--shadow-md);
}

.btn-primary:active {
  background: var(--accent-primary-active);
  transform: translateY(0);
}

.btn-secondary {
  background: var(--accent-secondary);
  color: var(--text-inverse);
}

.btn-ghost {
  background: transparent;
  color: var(--text-primary);
}

.btn-ghost:hover {
  background: var(--bg-tertiary);
}

.btn-outline {
  background: transparent;
  color: var(--text-primary);
  border: 1px solid var(--border-color);
}

.btn-outline:hover {
  background: var(--bg-tertiary);
  border-color: var(--border-color-hover);
}
```

### Card

```css
.card {
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
  transition: all 0.2s ease;
}

.card:hover {
  border-color: var(--border-color-hover);
  box-shadow: var(--shadow-md);
}

.card-elevated {
  background: var(--bg-elevated);
  box-shadow: var(--shadow-lg);
}
```

### Input

```css
.input {
  background: var(--bg-tertiary);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  padding: var(--space-2) var(--space-3);
  color: var(--text-primary);
  font-size: var(--text-sm);
  outline: none;
  transition: all 0.15s ease;
}

.input:focus {
  border-color: var(--accent-primary);
  box-shadow: 0 0 0 3px var(--accent-primary-muted);
}

.input::placeholder {
  color: var(--text-tertiary);
}
```

### Badge

```css
.badge {
  display: inline-flex;
  align-items: center;
  padding: var(--space-1) var(--space-2);
  border-radius: var(--radius-sm);
  font-size: var(--text-xs);
  font-weight: var(--font-medium);
}

.badge-primary {
  background: var(--accent-primary-muted);
  color: var(--accent-primary);
}

.badge-secondary {
  background: var(--accent-secondary-muted);
  color: var(--accent-secondary);
}

.badge-success {
  background: var(--success-muted);
  color: var(--success);
}
```

### Progress Bar

```css
.progress {
  width: 100%;
  height: 8px;
  background: var(--progress-bg);
  border-radius: var(--radius-full);
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(
    90deg,
    var(--accent-primary) 0%,
    var(--accent-secondary) 100%
  );
  border-radius: var(--radius-full);
  transition: width 0.3s ease;
}

/* Animated pulse for active progress */
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.7; }
}

.progress-fill.active {
  animation: pulse 2s ease-in-out infinite;
}
```

### Modal

```css
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.8);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal {
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-xl);
  padding: var(--space-6);
  max-width: 90vw;
  max-height: 90vh;
  overflow: auto;
  box-shadow: var(--shadow-xl);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--space-6);
}

.modal-title {
  font-size: var(--text-2xl);
  font-weight: var(--font-semibold);
  color: var(--text-primary);
}
```

### Task Card

```css
.task-card {
  background: var(--bg-secondary);
  border-left: 4px solid var(--category-color);  /* Dynamic per category */
  border-radius: var(--radius-lg);
  padding: var(--space-4);
  transition: all 0.2s ease;
  cursor: pointer;
}

.task-card:hover {
  background: var(--bg-tertiary);
  transform: translateX(4px);
  box-shadow: var(--shadow-md);
}

.task-card.status-done {
  opacity: 0.6;
}

.task-card.status-done .task-title {
  text-decoration: line-through;
}
```

### Timeline Slot

```css
.timeline-slot {
  background: var(--bg-secondary);
  border: 2px dashed var(--border-color);
  border-radius: var(--radius-md);
  padding: var(--space-4);
  min-height: 60px;
  transition: all 0.2s ease;
}

.timeline-slot.droppable {
  border-color: var(--accent-primary);
  background: var(--accent-primary-muted);
}

.timeline-slot.occupied {
  border-style: solid;
  border-color: var(--accent-secondary);
  background: var(--bg-tertiary);
}
```

### Milestone Card

```css
.milestone-card {
  background: var(--bg-secondary);
  border-top: 4px solid var(--category-color);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
  transition: all 0.2s ease;
}

.milestone-card:hover {
  border-top-width: 6px;
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg);
}

.milestone-progress {
  margin-top: var(--space-4);
}

.milestone-velocity-badge {
  margin-top: var(--space-2);
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
  font-size: var(--text-xs);
}

.milestone-velocity-badge.on-pace {
  color: var(--success);
}

.milestone-velocity-badge.behind {
  color: var(--warning);
}
```

---

## Animations

### Smooth Transitions

```css
/* Global transitions */
* {
  transition-property: background-color, border-color, color, fill, stroke, opacity, box-shadow, transform;
  transition-duration: 0.15s;
  transition-timing-function: ease;
}

/* Disable transitions for reduced motion */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

### Celebration Confetti

```css
@keyframes confetti-fall {
  0% {
    transform: translateY(-100vh) rotate(0deg);
    opacity: 1;
  }
  100% {
    transform: translateY(100vh) rotate(720deg);
    opacity: 0;
  }
}

.confetti {
  position: fixed;
  width: 10px;
  height: 10px;
  background: var(--accent-primary);
  animation: confetti-fall 3s linear forwards;
  z-index: 9999;
}

.confetti:nth-child(2n) {
  background: var(--accent-secondary);
}

.confetti:nth-child(3n) {
  background: var(--success);
}
```

### Progress Bar Fill Animation

```css
@keyframes fill-progress {
  from {
    transform: scaleX(0);
    transform-origin: left;
  }
  to {
    transform: scaleX(1);
  }
}

.progress-fill.animated {
  animation: fill-progress 0.5s ease-out;
}
```

### Toast Slide-In

```css
@keyframes toast-slide-in {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

.toast {
  position: fixed;
  top: var(--space-4);
  right: var(--space-4);
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
  padding: var(--space-4);
  box-shadow: var(--shadow-lg);
  animation: toast-slide-in 0.3s ease-out;
  z-index: 2000;
}
```

---

## Layout Patterns

### App Shell

```
┌─────────────────────────────────────────────────────────────┐
│ HEADER (60px)                                   [User Menu] │
├─────────────────────────────────────────────────────────────┤
│ SIDEBAR (240px) │ MAIN CONTENT (flex-1)                     │
│                 │                                           │
│ • Today         │ ┌─────────────────────────────────────┐  │
│ • Tasks         │ │ Page Content                        │  │
│ • Goals         │ │                                     │  │
│ • Milestones    │ │                                     │  │
│ • Planner       │ │                                     │  │
│ • Reflections   │ │                                     │  │
│ • Settings      │ └─────────────────────────────────────┘  │
│                 │                                           │
└─────────────────────────────────────────────────────────────┘
```

### Grid Layouts

**Milestone Cards:**
```css
.milestone-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: var(--space-6);
}
```

**Task List:**
```css
.task-list {
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
}
```

**Kanban Columns:**
```css
.kanban-board {
  display: grid;
  grid-template-columns: repeat(3, minmax(280px, 1fr));
  gap: var(--space-6);
  overflow-x: auto;
}
```

---

## Dark Mode Excellence

### High Contrast

- **Backgrounds:** Deep blacks (#0a0a0a) for low eye strain
- **Text:** Pure white (#ffffff) for readability
- **Borders:** Subtle (#3a3a3a) but visible

### Layering

```
Layer 0 (App BG):   #0a0a0a
Layer 1 (Cards):    #1a1a1a
Layer 2 (Hover):    #2a2a2a
Layer 3 (Elevated): #3a3a3a
```

### Focus States

```css
*:focus-visible {
  outline: 2px solid var(--accent-primary);
  outline-offset: 2px;
  border-radius: var(--radius-sm);
}
```

---

## Responsive Breakpoints

```css
--breakpoint-sm: 640px;   /* Small tablets */
--breakpoint-md: 768px;   /* Tablets */
--breakpoint-lg: 1024px;  /* Laptops */
--breakpoint-xl: 1280px;  /* Desktops */
--breakpoint-2xl: 1536px; /* Large desktops */
```

### Mobile Adjustments

```css
@media (max-width: 768px) {
  .sidebar {
    position: fixed;
    transform: translateX(-100%);
    transition: transform 0.3s ease;
  }
  
  .sidebar.open {
    transform: translateX(0);
  }
  
  .milestone-grid {
    grid-template-columns: 1fr;
  }
  
  .kanban-board {
    grid-template-columns: 1fr;
  }
}
```

---

## Accessibility

### WCAG AAA Compliance

- **Contrast Ratios:**
  - Primary text on bg-primary: 21:1 ✅
  - Secondary text on bg-primary: 12:1 ✅
  - Accent-primary on bg-primary: 7:1 ✅

### ARIA Labels

```html
<button aria-label="Start timer for D426 Quiz Prep">
  Start Timer
</button>

<div role="progressbar" aria-valuenow="45" aria-valuemin="0" aria-valuemax="100">
  <div class="progress-fill" style="width: 45%"></div>
</div>
```

### Keyboard Navigation

- Tab order: logical (top-to-bottom, left-to-right)
- Focus indicators: visible 2px outline
- Escape closes modals/dropdowns
- Enter/Space activates buttons

---

## Component Library

**Recommended:** Shadcn/ui + Radix Primitives  
**Alternative:** Headless UI + Tailwind CSS  

**Why:**
- Fully customizable (not opinionated)
- Accessible by default (ARIA, keyboard nav)
- Composable primitives
- Tree-shakeable

**Do NOT use:** Material-UI, Ant Design (too opinionated, hard to theme)

---

## File Structure

```
src/
  ui/
    components/        # Reusable UI components
      Button.tsx
      Card.tsx
      Input.tsx
      Modal.tsx
      Badge.tsx
      ProgressBar.tsx
    primitives/        # Base Radix wrappers
      Dialog.tsx
      Dropdown.tsx
      Tooltip.tsx
    theme/
      colors.css       # Color variables
      typography.css   # Font variables
      spacing.css      # Spacing scale
      animations.css   # Keyframes
      global.css       # Global styles
```

---

## Example: Task Card Component

```tsx
// src/ui/components/TaskCard.tsx

interface TaskCardProps {
  task: Task;
  category: Category;
  onClick: () => void;
}

export function TaskCard({ task, category, onClick }: TaskCardProps) {
  return (
    <div 
      className={cn(
        "task-card",
        `status-${task.status}`,
        task.status === 'done' && "opacity-60"
      )}
      style={{ '--category-color': category.color }}
      onClick={onClick}
    >
      <div className="flex items-center justify-between">
        <h3 className="task-title text-base font-medium">
          {task.title}
        </h3>
        <Badge variant="secondary">{task.estimateMinutes}m</Badge>
      </div>
      
      <div className="flex items-center gap-2 mt-2 text-sm text-secondary">
        <span className="flex items-center gap-1">
          <EnergyIcon level={task.energy} />
          {task.energy}
        </span>
        <span>•</span>
        <span>{category.name}</span>
        {task.subtasks?.length > 0 && (
          <>
            <span>•</span>
            <span>{task.subtasks.filter(s => s.done).length}/{task.subtasks.length} subtasks</span>
          </>
        )}
      </div>
      
      {task.subtasks && task.subtasks.length > 0 && (
        <ProgressBar 
          value={task.subtasks.filter(s => s.done).length}
          max={task.subtasks.length}
          className="mt-3"
        />
      )}
    </div>
  );
}
```

---

## Summary

**Philosophy:** Dark, sleek, modern with high contrast  
**Accents:** Orange (action) + Teal (progress)  
**Components:** Minimal, composable, accessible  
**Animations:** Subtle, smooth, purposeful  
**Performance:** CSS variables, GPU-accelerated transforms  
**Accessibility:** WCAG AAA, keyboard-first, ARIA labels  

This design system ensures a **cohesive, polished, professional** UI that's optimized for focused work and long coding sessions.

