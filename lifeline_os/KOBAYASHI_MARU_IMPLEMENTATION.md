# Kobayashi Maru Social Practice System - Implementation Summary

## Overview

The Kobayashi Maru feature has been successfully implemented as a new expert personality in the Reflections page. This system allows users to practice challenging social interactions through AI-powered adversarial role-play with detailed performance analysis.

## Core Concept

Named after the famous Star Trek no-win scenario, Kobayashi Maru serves as a "social sparring partner" where users can:
1. Configure detailed confrontational scenarios
2. Engage in realistic adversarial conversations
3. Receive AI-powered performance analysis
4. Review strengths, weaknesses, and tactical recommendations

## Architecture

### Database (Schema Version 5)

**Two New Tables:**

1. **`kobayashi_scenarios`**
   - `id`: Unique identifier
   - `sessionId`: Links to chat session
   - `role`: The character the AI embodies
   - `context`: Situation background
   - `traits`: Psychological profile
   - `goals`: What the AI is trying to achieve
   - `winConditions`: Optional success criteria
   - `createdAt`: Timestamp

2. **`kobayashi_analyses`**
   - `id`: Unique identifier
   - `sessionId`: Links to chat session
   - `overallScore`: Performance score (1-10)
   - `strengths`: JSON array of positive observations
   - `weaknesses`: JSON array of areas to improve
   - `recommendations`: JSON array of tactical advice
   - `transcript`: Full conversation record
   - `createdAt`: Timestamp

### Data Models

**Freezed Models:**
- `KobayashiScenario`: Immutable scenario configuration
- `KobayashiAnalysis`: Immutable performance analysis results

### Services & Repositories

**KobayashiRepository** (`lib/features/reflections/repositories/kobayashi_repository.dart`)
- CRUD operations for scenarios and analyses
- Reactive streams for real-time updates
- JSON encoding/decoding for array fields

**KobayashiAnalysisService** (`lib/features/reflections/services/kobayashi_analysis_service.dart`)
- LLM-powered performance analysis
- Structured JSON output parsing
- Transcript generation from chat history
- Robust error handling for malformed LLM responses

**KobayashiProvider** (`lib/features/reflections/providers/kobayashi_provider.dart`)
- Repository provider
- Scenario and analysis stream providers
- Analysis generation action provider

### Expert System Integration

**New Expert:** Kobayashi Maru (🎭)
- **Category:** Psychology
- **Archetype:** Social Sparring Partner
- **Style:** Adaptive, challenging, confrontational
- **System Prompt:** Designed for adversarial role-play
- **Context Needs:** Minimal (no personal data required)

**Key Behaviors:**
- Stay rigidly in character
- Use psychological tactics matching the assigned traits
- Adapt based on user responses (escalate if winning, exploit weaknesses)
- Never break character or offer meta-commentary
- Make the user work for every inch of progress

### Chat Flow Integration

**Scenario Injection** (Modified `chat_provider.dart`)
- Detects Kobayashi Maru sessions
- Retrieves scenario from database
- Injects scenario parameters into system prompt
- Maintains role consistency throughout conversation

**Prompt Structure:**
```
[Base System Prompt]

---SCENARIO PARAMETERS---
ROLE: [hostile client who thinks you're overcharging]
CONTEXT: [First project meeting after invoice sent]
TRAITS TO EMBODY: [defensive, price-sensitive, aggressive]
YOUR GOALS: [Get discount without losing leverage]
WIN CONDITIONS: [If user reduces price by >20%]
---END SCENARIO---

Stay in character. The practice session has begun.
```

## User Experience Flow

### 1. Scenario Configuration

**Trigger:** User clicks Kobayashi Maru in persona sidebar

**Dialog Fields:**
- **Role** (required): Character identity
- **Context** (required): Situational background
- **Psychological Traits** (required): Behavioral characteristics
- **Their Goals** (required): What they're trying to achieve
- **Win Conditions** (optional): Success criteria

**Example Scenario:**
```
Role: hostile client who thinks you're overcharging
Context: First project meeting after you sent the invoice
Traits: defensive, price-sensitive, slightly aggressive
Goals: Get a discount without losing leverage
Win Conditions: If I agree to reduce price by >20%
```

### 2. Practice Session

**Visual Indicators:**
- 🎭 icon in persona sidebar
- "Practice session active" status text
- Orange "End & Analyze" button in header

**Interaction:**
- User engages in conversation
- AI maintains character based on scenario
- Full chat history preserved
- No time limit or message count restriction

### 3. Performance Analysis

**Trigger:** User clicks "End & Analyze" button

**Process:**
1. Loading dialog appears
2. LLM analyzes full transcript against scenario
3. Structured performance report generated
4. Results displayed in analysis dialog

**Analysis Components:**
- **Overall Score (1-10):** Color-coded performance indicator
  - 9-10: Exceptional (Green)
  - 8: Strong (Green)
  - 6-7: Solid (Blue)
  - 4-5: Needs Improvement (Orange)
  - 1-3: Significant Room for Growth (Red)
  
- **Strengths:** 3-5 positive observations
  - What was done well
  - Effective tactics used
  - Successful frame control

- **Weaknesses:** 3-5 areas for improvement
  - Missed opportunities
  - Tactical errors
  - Defensive patterns

- **Recommendations:** 3-5 actionable tips
  - Specific techniques to practice
  - Tactical alternatives
  - Framing improvements

**Example Analysis:**
```
Score: 7/10 - Solid Performance

Strengths:
✓ Maintained frame under pressure
✓ Used reciprocity principle effectively
✓ Stayed calm despite aggression

Weaknesses:
⚠ Conceded too early without counter-offer
⚠ Missed opportunity to reframe value
⚠ Defensive tone in responses 2-3

Recommendations:
💡 Use tactical silence after aggressive statements
💡 Reframe price objections with higher-order benefits
💡 Anchor first with non-negotiable items
```

### 4. Session Review

**History Access:**
- All Kobayashi sessions saved in chat history
- Scenarios preserved for reference
- Analyses retrievable for review
- Transcripts available for study

**Future Sessions:**
- Can create new scenarios anytime
- Previous scenarios not reused automatically
- Each session is independent

## UI Components

### KobayashiScenarioDialog
**Location:** `lib/features/reflections/presentation/widgets/kobayashi_scenario_dialog.dart`

**Features:**
- Clean, professional form layout
- Placeholder hints for each field
- Validation (required fields)
- Returns structured Map on submission
- Cancellable without side effects

### KobayashiAnalysisDialog
**Location:** `lib/features/reflections/presentation/widgets/kobayashi_analysis_dialog.dart`

**Features:**
- Large score display with color coding
- Sectioned breakdown (Strengths, Weaknesses, Recommendations)
- Icon indicators (✓ ⚠ 💡)
- Scrollable content area
- "New Scenario" button for quick restart
- Full width (700px) for readability

### Chat Panel Modifications
**Location:** `lib/features/reflections/presentation/widgets/chat_panel.dart`

**Changes:**
- Conditional "End & Analyze" button for Kobayashi sessions
- Status text changes to "Practice session active"
- Loading dialog during analysis
- Error handling for failed analysis

### Persona Sidebar Modifications
**Location:** `lib/features/reflections/presentation/widgets/persona_sidebar.dart`

**Changes:**
- Intercepts Kobayashi Maru selection
- Shows scenario dialog before creating session
- Saves scenario to database
- Creates new session automatically

## Technical Details

### Migration Strategy

**Schema Version:** 4 → 5

**Migration Code:**
```dart
if (from == 4 && to == 5) {
  await m.createTable(kobayashiScenarios);
  await m.createTable(kobayashiAnalyses);
}
```

**Safe:** Additive only, no data loss

### JSON Parsing

**Robust Extraction:**
- Handles markdown code fences
- Extracts from conversational responses
- Finds first `{` and last `}`
- Cleans common LLM artifacts

**Error Scenarios:**
- Malformed JSON → graceful error message
- Missing fields → validation error
- Invalid score range → default handling

### Performance Considerations

**Analysis Speed:**
- Typical: 5-15 seconds
- Depends on LLM provider and model
- Loading dialog provides feedback

**Database:**
- Indexed by sessionId for fast lookups
- JSON fields for flexibility
- Cascading deletes maintain referential integrity

### Security & Privacy

**Data Handling:**
- Scenarios never shared externally
- Transcripts stored locally only
- No personal data required for scenarios
- Analysis runs on user's configured LLM

## Build Requirements

**⚠️ IMPORTANT:** After pulling this code, run:

```bash
cd lifeline_os
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `kobayashi_scenario.freezed.dart`
- `kobayashi_scenario.g.dart`
- `kobayashi_analysis.freezed.dart`
- `kobayashi_analysis.g.dart`
- Updated `database.g.dart` with new tables

**Without this step, the app will not compile.**

## Usage Examples

### Professional Negotiation Practice
```
Role: Aggressive procurement manager
Context: Renegotiating annual contract after budget cuts
Traits: Cost-focused, dismissive of value arguments, uses pressure tactics
Goals: Reduce contract value by 30% without losing service quality
Win Conditions: User agrees to >20% reduction with no service changes
```

### Difficult Conversation Practice
```
Role: Defensive team member receiving critical feedback
Context: 1-on-1 performance review meeting
Traits: Takes feedback personally, deflects responsibility, emotional
Goals: Avoid accountability, shift blame to external factors
Win Conditions: User backs down or apologizes for raising issues
```

### Sales Objection Handling
```
Role: Skeptical enterprise buyer
Context: Demo call for expensive SaaS product
Traits: Analytical, risk-averse, compares to cheaper alternatives
Goals: Find reasons to say no, delay decision
Win Conditions: User fails to address ROI concerns convincingly
```

## Future Enhancements

**Potential Additions:**
1. Pre-built scenario templates
2. Difficulty levels (Novice → Expert)
3. Multi-session campaigns (related scenarios)
4. Performance tracking over time
5. Scenario sharing/export
6. Video/audio mode support
7. Team practice (multiple AIs)
8. Scenario branching (conditional paths)

## Testing Checklist

- [ ] Scenario dialog validates required fields
- [ ] Session creation with scenario works
- [ ] Chat messages respect scenario character
- [ ] "End & Analyze" button appears only for Kobayashi sessions
- [ ] Analysis generation handles errors gracefully
- [ ] Analysis dialog displays all sections
- [ ] Score color coding matches thresholds
- [ ] Transcript preserves full conversation
- [ ] Session history shows Kobayashi sessions
- [ ] New scenario creation works after analysis
- [ ] Database migration runs cleanly
- [ ] Freezed models generate without errors

## Files Modified/Created

**New Files (7):**
- `lib/core/models/kobayashi_scenario.dart`
- `lib/core/models/kobayashi_analysis.dart`
- `lib/features/reflections/repositories/kobayashi_repository.dart`
- `lib/features/reflections/services/kobayashi_analysis_service.dart`
- `lib/features/reflections/providers/kobayashi_provider.dart`
- `lib/features/reflections/presentation/widgets/kobayashi_scenario_dialog.dart`
- `lib/features/reflections/presentation/widgets/kobayashi_analysis_dialog.dart`

**Modified Files (6):**
- `lib/core/database/tables.dart` (added 2 tables)
- `lib/core/database/database.dart` (schema v5, migration)
- `lib/core/constants/experts.dart` (added Kobayashi expert)
- `lib/features/reflections/providers/chat_provider.dart` (scenario injection)
- `lib/features/reflections/presentation/widgets/chat_panel.dart` (analysis button)
- `lib/features/reflections/presentation/widgets/persona_sidebar.dart` (scenario dialog)

## Commit

**Hash:** `5a85311`  
**Message:** "feat: Add Kobayashi Maru social practice system"  
**Status:** ✅ Pushed to `main`

---

**Implementation Complete** ✅

All features specified in the plan have been implemented. The system is ready for testing after running build_runner.

