# Pathway

Personal AI productivity system built with Flutter for Windows.

## Features

- **MGTST Framework**: Milestones → Goals → Tasks → Subtasks hierarchy
- **Today Page**: Must-Wins, Timeline scheduling, Task pool
- **AI Reflections**: 8 expert personalities for coaching and strategy
- **Smart Points System**: Multi-dimensional task valuation
- **Local LLM Integration**: Ollama-powered AI with full context awareness

## Getting Started

### Prerequisites
- Flutter SDK (>=3.2.0)
- Ollama with llama3.1:8b model
- Windows 10/11

### Installation

```bash
cd lifeline_os
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d windows
```

### Start Ollama

```bash
ollama serve
```

## Architecture

- **State Management**: flutter_riverpod
- **Database**: Drift (SQLite)
- **LLM Client**: Ollama HTTP API
- **UI Framework**: Material Design with custom dark theme
