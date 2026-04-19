# Lifeline OS

**A comprehensive productivity and life management system built with Flutter.**

Lifeline OS is a desktop-first productivity application that helps you manage goals, track progress, plan projects, and maintain momentum through AI-powered coaching and journaling.

## Features

### 📋 Task Management
- **Hierarchical Organization**: Milestones → Goals → Tasks → Subtasks
- **Smart Filtering**: Filter by status, priority, energy level, and domain
- **Inline Subtask Creation**: Add subtasks before or after creating tasks
- **Point System**: Automatic point roll-up from subtasks to milestones
- **Kanban & List Views**: Multiple visualization options

### 🎯 Goal Tracking
- **Progress Visualization**: Real-time progress tracking with charts
- **Domain-Specific Goals**: Specialized templates for School, Projects, Finance, Health, DSA, and Personal
- **Goal-Task Linking**: Connect tasks to goals for automatic progress calculation
- **Milestone Integration**: Group goals under milestones with deadline tracking

### 📅 Daily Planning (Today Page)
- **Must-Wins**: Focus on your 3 most important daily tasks
- **Hour-Slot Timeline**: Visual schedule from 6am-11pm with drag-and-drop
- **Task Pool**: Filter tasks by energy level and time estimate
- **Quick Add**: Rapidly capture tasks with smart defaults
- **Workout Logging**: Track fitness activities with sets, reps, and weight

### 🗂️ Project Planner
- **AI-Powered Planning**: Generate structured project plans from ideas
- **Live Markdown Preview**: See your plan as you build it
- **Collapsible Sections**: Organize plans with toggleable sections
- **Feature Cards**: Break projects into ≤90min executable cards
- **Export**: Save plans as Markdown or JSON for external use

### 💬 Reflections (AI Coaching)
- **8 Specialized AI Personas**:
  - 🚀 Founder-Engineer (Shipping & Validation)
  - 🪞 Mirror-Guide (Life Strategy)
  - ⚡ Lock-In Coach (Accountability)
  - 📋 Planner (Project Management)
  - 🧠 Therapist (Pattern Recognition)
  - 🏛️ Philosopher (Wisdom & Perspective)
  - 🧩 Psych Strategist (Social Dynamics)
  - 🏗️ Architect (Systems Design)
- **Persistent Chat History**: Conversations saved across sessions
- **Quick Notes**: Capture ideas with tags linking to tasks/goals
- **Context-Aware**: AI has access to your tasks, goals, and progress

### 📊 Analytics & Insights
- **Points System**: Gamified progress tracking
- **Streak Counter**: Daily completion streaks
- **Progress Charts**: Visual milestone and goal progress
- **Velocity Tracking**: Monitor task completion rates

## Tech Stack

- **Framework**: Flutter (Desktop - Windows, macOS, Linux)
- **Database**: Drift (SQLite) with encrypted local storage
- **State Management**: Riverpod
- **Architecture**: Clean architecture with feature-based modules
- **UI**: Custom Material Design 3 with dark mode support

## Project Structure

```
lifeline_os/
├── lib/
│   ├── app/                    # App initialization & theme
│   ├── core/                   # Shared utilities
│   │   ├── database/           # Drift database setup
│   │   ├── models/             # Freezed data models
│   │   └── providers/          # Global providers
│   ├── features/               # Feature modules
│   │   ├── today/              # Daily planning page
│   │   ├── tasks/              # Task management
│   │   ├── goals/              # Goal tracking
│   │   ├── milestones/         # Milestone management
│   │   ├── planner/            # Project planner
│   │   ├── reflections/        # AI chat & journaling
│   │   └── settings/           # App configuration
│   └── shared/                 # Reusable widgets
└── docs/                       # Documentation
    ├── features/               # Feature specifications
    └── technical/              # Technical documentation
```

## Getting Started

### Prerequisites
- Flutter SDK (≥3.0.0)
- Dart SDK (≥3.0.0)
- Desktop development setup for your platform

### Installation

1. Clone the repository:
```bash
git clone https://github.com/waleedaraza/paths.git
cd paths/lifeline_os
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (Freezed, Drift):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run -d windows  # or macos, linux
```

## Development

### Code Generation
When modifying models or database schema:
```bash
flutter pub run build_runner watch
```

### Database Migrations
Schema versions are managed in `lib/core/database/database.dart`. Migrations are handled automatically on app launch.

### Adding New Features
1. Create feature directory in `lib/features/`
2. Follow the structure: `presentation/`, `providers/`, `data/` (if needed)
3. Add routes in `lib/app/app.dart`
4. Update PLAN.md with progress

## Roadmap

- [ ] AI Integration (Ollama/local LLM)
- [ ] Cloud Sync & Backup
- [ ] Mobile Support (iOS/Android)
- [ ] Calendar Integration
- [ ] Team/Collaboration Features
- [ ] Advanced Analytics Dashboard
- [ ] Voice Commands
- [ ] Browser Extension

## Contributing

This is a personal project, but feedback and suggestions are welcome! Feel free to open issues for bugs or feature requests.

## License

This project is private and proprietary.

## Acknowledgments

Built with Flutter, Riverpod, and Drift. Inspired by productivity methodologies including GTD, Atomic Habits, and personal coaching practices.

---

**Version**: 2.0 (Complete Rebuild)  
**Status**: Active Development  
**Last Updated**: October 2025
