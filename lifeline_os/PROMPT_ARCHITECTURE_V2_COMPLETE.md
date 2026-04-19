# Prompt Architecture V2 - COMPLETE ✅

## Summary
Complete overhaul of Project Planner prompting system with array-based outputs, style knobs, novelty enforcement, field-specific micro-prompts, and action differentiation.

---

## What Changed

### BEFORE (Old System)
- ❌ JSON escaping hell (multi-line markdown in strings)
- ❌ Same-y outputs (Expand/Regenerate/Simplify felt identical)
- ❌ Generic prompts (no field-specific intelligence)
- ❌ Poor context flow (Step 5 missing Steps 2-3)
- ❌ No novelty pressure (Regenerate just rephrased)
- ❌ No style control (can't toggle list-only mode)

### AFTER (New System)
- ✅ Array-based output (`proposedContentLines` instead of string)
- ✅ Distinct action behaviors (different temps, knobs, checks)
- ✅ Field-specific micro-prompts (Tech Stack gets 22-32 item list format)
- ✅ Fixed context flow (Step 5 sees all previous steps)
- ✅ Novelty enforcement (auto-retry if similarity >60%)
- ✅ Style knobs (list-only, add examples, target count, etc.)

---

## Complete Prompting Architecture

### PHASE 1: Initial Generation (5 Sequential Steps)

```
Step 1: Project Info
  Input: User's idea
  Output: 5 fields (Project Name, One-Liner, Target Users, Core Value Prop, Key Differentiators)
  
Step 2: Research & Stack
  Input: User's idea + Step 1 output
  Output: 5 fields (Tech Stack, Dependencies, Best Practices, Common Pitfalls, Security)
  
Step 3: Technical Architecture  
  Input: User's idea + Step 1 + Step 2
  Output: 6 fields (System Overview, Data Models, API Contracts, Auth Strategy, Deployment, Scalability)
  
Step 4: Feature Breakdown
  Input: User's idea + Step 1 + Step 2 + Step 3
  Output: 4 fields (MVP Features, V1 Features, Future Enhancements, Time Estimates)
  
Step 5: Division of Labor
  Input: User's idea + Step 1 + Step 2 + Step 3 + Step 4  ← FIXED!
  Output: 4 fields (Work Packages, Phase Timeline, Dependencies, Critical Path)
```

### PHASE 2: Field Refinement (Per-Field with Knobs)

```
User clicks button → Intent dialog → AI generation → Review modal → Chat iteration → Apply
```

---

## New Array-Based Output Format

### Old Format (Problematic)
```json
{
  "proposedContent": "Line 1\nLine 2\n- Bullet 1\n- Bullet 2"  // ← JSON escaping nightmare
}
```

### New Format (Clean)
```json
{
  "notes": "Brief explanation",
  "guidance": ["Tip 1", "Tip 2", "Tip 3"],  // ← Array
  "proposedContentLines": ["Line 1", "Line 2", "- Bullet 1", "- Bullet 2"],  // ← Array
  "reasoning": "AI thought process"
}
```

**Benefits:**
- No JSON escaping issues
- Each line is a discrete unit
- Easy to validate (max 160 chars per line)
- UI can display as list or text

---

## Style Knobs System

### RefinementKnobs Model
```dart
class RefinementKnobs {
  bool listOnly;           // Force bullet format, no justifications
  int targetCount;         // Target number of lines
  bool includeExamples;    // Add concrete examples
  List<String> forbidPhrases;  // Banned words (for novelty)
  List<String> mustInclude;    // Required terms
  double temperature;      // LLM sampling (0.0-1.0)
  double noveltyThreshold; // Min difference (0.0-1.0)
}
```

### Action Presets
**Expand:**
- temperature: 0.35 (controlled)
- targetCount: 12
- includeExamples: true
- noveltyThreshold: 0.3

**Regenerate:**
- temperature: 0.7 (diverse)
- targetCount: 8
- noveltyThreshold: 0.5
- forbidPhrases: [top 5 trigrams from current]

**Simplify:**
- temperature: 0.1 (deterministic)
- targetCount: 5
- listOnly: true
- noveltyThreshold: 0.2

### Field-Specific Overrides
**Tech Stack (Expand):**
- listOnly: true
- targetCount: 26
- forbidPhrases: ["vast ecosystem", "large community", "robust", "widely used"]

**Dependencies (Any):**
- listOnly: true
- targetCount: 10

**Security (Expand):**
- listOnly: true
- targetCount: 8
- includeExamples: true

---

## Field-Specific Micro-Prompts

### Tech Stack (Expand)
```
TECH STACK SPECIFIC RULES:
Return ONLY list items, one tool per line, grouped by layer with prefix.
Target 22-32 lines.

Layers: Frontend, Mobile, State, Data-Fetching, UI Kit, Forms/Validation, API, 
Realtime, DB, ORM, Migrations, Caching/Queue, Search/Vector, ML/Embeddings, Auth, 
Storage, Infra/Deploy, CI, Telemetry, Testing, Feature Flags, Docs/Design

Format: "- Layer: Tool (optional tag)"
Example: "- Frontend: Next.js 14 (App Router)"

Prohibit: ["vast ecosystem", "large community", "robust", "widely used"]
```

### Dependencies
```
List only packages, grouped: "Area: pkg1, pkg2, pkg3"
8-12 lines.
Areas: FE, Mobile, API, Data, ML, Testing, Telemetry, Infra, DX, Lint/Format
```

### Best Practices
```
6-8 lines; format: "Rule — Why (≤5 words)"
Example: "Freeze DTOs — stop drift"
```

### Common Pitfalls
```
6-8 lines; format: "Pitfall — Symptom"
Example: "No RLS — data leaks"
```

### Security
```
Exactly 8 lines; format: "Area: directive"
Example: "RLS: user_id = auth.uid()"
```

---

## Novelty Enforcement

### How It Works
1. After AI generates, compute Jaccard trigram similarity
2. If similarity > threshold (default 0.5 for regenerate):
   - Extract top 5 trigrams from current content
   - Add to `forbidPhrases`
   - Increase temperature by 0.15
   - Increase noveltyThreshold by 0.1
   - Retry generation once

### Jaccard Trigram Similarity
```
trigrams(text) = all 3-word sequences
similarity = |A ∩ B| / |A ∪ B|

Example:
A = "the quick brown fox"
trigrams_A = {"the quick brown", "quick brown fox"}

B = "the fast brown dog"
trigrams_B = {"the fast brown", "fast brown dog"}

intersection = {} (no matches)
union = {all 4}
similarity = 0/4 = 0.0 (completely different)
```

### Console Output
```
Novelty check: similarity = 0.72, threshold = 0.5
❌ Novelty check failed! Retrying with higher constraints...
[Retry with forbidden trigrams + higher temp]

Novelty check: similarity = 0.38, threshold = 0.6
✅ Novelty check passed!
```

---

## UI Features Added

### 1. Style Chips in Proposed Panel
- **Lists only** - Toggle bullet format
- **Add examples** - Include concrete examples
- Clicking regenerates with new knobs

### 2. Line Count Indicator
Shows "12 / 26 lines" to track against target

### 3. Retry (More Different) Button
- Extracts top 5 trigrams from current proposed content
- Adds to forbid list
- Bumps temperature and novelty threshold
- Regenerates with stricter novelty requirements

### 4. Diff View Toggle
Eye icon shows before/after comparison with color coding

---

## Files Summary

### Created (4 new files, ~600 lines)
1. `lib/features/planner/models/refinement_knobs.dart` - Style knobs model
2. `lib/features/planner/services/field_prompts.dart` - Field-specific micro-prompts
3. `lib/features/planner/services/novelty_checker.dart` - Jaccard similarity checker
4. `lib/features/planner/services/refinement_knobs_presets.dart` - Default knob configurations

### Modified (5 files, ~400 lines)
1. `lib/features/planner/models/refinement_suggestion.dart` - Changed to arrays
2. `lib/features/planner/services/refinement_service.dart` - Knobs + novelty + micro-prompts
3. `lib/features/planner/presentation/widgets/refinement_panel.dart` - Style chips + retry button
4. `lib/core/services/llm/project_chain_service.dart` - Fixed Step 5 context
5. `lib/core/services/llm/project_prompts.dart` - Added full context to Step 5

**Total:** ~1,000 lines added/changed

---

## Expected Behavior Changes

### Tech Stack (Expand)
**Before:** Paragraphs with justifications  
**After:** 22-32 line list with no fluff
```
- Frontend: Next.js 14 (App Router)
- Mobile: Flutter 3.24
- State: Zustand
- Data-Fetching: TanStack Query
[... 18 more lines]
```

### Best Practices (Expand)
**Before:** Long explanatory paragraphs  
**After:** Crisp rule-why format
```
- Freeze DTOs — stop drift
- RLS by default — prevent leaks
- Typed contracts — catch breaks early
```

### Any Field (Regenerate)
**Before:** Often just rephrased same content  
**After:** Auto-retries if similarity >60%, forces different vocabulary

---

## Testing Guide

### Test 1: Tech Stack List-Only Mode
1. Generate plan
2. Click **Expand** on "Tech Stack"
3. Enter intent: "Add examples"
4. Click Generate
5. **Expected:** 22-32 line list with layer prefixes, no justifications
6. Check console for line count

### Test 2: Novelty Enforcement
1. Click **Regenerate** on any field
2. Intent: "Different approach"
3. Check console for novelty score
4. If <0.5, should auto-retry
5. **Expected:** Distinctly different wording

### Test 3: Style Chips
1. Generate any refinement
2. Click "Lists only" chip
3. **Expected:** Regenerates in bullet format
4. Click "Add examples" chip
5. **Expected:** Includes concrete examples

### Test 4: Retry Button
1. Generate refinement
2. Click "Retry (More Different)"
3. Check console for forbidden trigrams
4. **Expected:** More novel output with higher temp

### Test 5: Context Flow
1. Generate full plan
2. Check "Division of Labor" section
3. **Expected:** References tech stack, architecture, and features appropriately

---

## Console Output Examples

### Successful Generation
```
=== RAW LLM OUTPUT ===
{
  "notes": "Expanded tech stack to include comprehensive tooling across all layers...",
  "guidance": ["Prioritize boring choices", "Include alternatives", "Call out exits"],
  "proposedContentLines": [
    "- Frontend: Next.js 14 (App Router)",
    "- State: Zustand",
    [... more lines ...]
  ],
  "reasoning": "Focused on modern, maintainable choices with clear escape hatches"
}
=== END RAW OUTPUT ===

=== EXTRACTED JSON ===
{ ... same as above ... }
=== END EXTRACTED ===

Novelty check: similarity = 0.28, threshold = 0.3
✅ Novelty check passed!
```

### Novelty Retry
```
Novelty check: similarity = 0.68, threshold = 0.5
❌ Novelty check failed! Retrying with higher constraints...
[Second attempt...]
Novelty check: similarity = 0.42, threshold = 0.6
✅ Novelty check passed!
```

---

## Known Limitations

1. **Max 5 iterations** - Prevents infinite retry loops
2. **Novelty only for regenerate** - Expand/Simplify don't check (intentional)
3. **No cross-field coordination** - Each field refined independently
4. **Token limits** - Very long sections may exceed context window

---

## Future Enhancements

- RAG integration (tool cheatsheet for richer suggestions)
- Cross-field batch refinement
- Preset management (custom user presets)
- Temperature slider in UI
- Export refinement history

---

**Completion Date:** October 8, 2025  
**Implementation Time:** ~4 hours  
**Total Lines:** ~1,000  
**Status:** ✅ READY FOR TESTING

**Next Step:** Hot reload app and test Tech Stack expansion!
