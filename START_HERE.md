# Start Here — Paths / Lifeline OS v2

**Status:** Planning complete. Ready to build.

---

## What You Have Now

✅ **BUILD_RULES.md** — The constitution. Pin this in Cursor. No work happens without it.

✅ **ROADMAP.md** — 8 phases, 44 hours, ~7–10 days. Every card is scoped ≤90m with acceptance criteria.

✅ **PLAN.md** — Live Status Board. Update this as you complete cards.

✅ **System Prompts** (in `ai/prompts/`):
- `planner.system.md` — Planner Agent (breaks down intent → Feature Spec Cards)
- `executor.system.md` — Executor Agent (implements one card at a time)
- `field-editor.system.md` — Field Editor (Planner feature: Expand/Replace/Refine/Query)
- `debugger.system.md` — Debugger (diagnose, don't patch; revert > wrestle)

✅ **Vibe Coding Framework** (`.cursorrules`) — Planner ↔ Executor loop enforced.

✅ **Workflow Cheatsheet** (`WORKFLOW_CHEATSHEET.md`) — One-page reference while coding.

---

## What This Solves

### Old Problem:
- Brainstorm features mid-build → scope creep
- Debug for days → tangled patches
- Fix one thing → break everything else
- Never learn patterns → repeat mistakes

### New System:
- **Planner mode** breaks down intent → cards (≤90m, ≤7 files, ≤300 LOC/file)
- **Executor mode** implements one card → tests → evidence → stop
- **Max 2 attempts** → revert to clean commit → halve scope
- **Learning Log** after each card → capture patterns

---

## How to Start (Next 5 Minutes)

### 1. Pin BUILD_RULES.md in Cursor
- Open Cursor
- Go to Settings → Workspace Rules (or `.cursorrules`)
- Ensure `.cursorrules` contains the Planner/Executor framework
- Keep `BUILD_RULES.md` open in a pinned tab

### 2. Open PLAN.md
- This is your Status Board
- Current card: **0.1 — Project Scaffold + DB Init (≤90m)**
- You'll update this as you work

### 3. Start in Executor Mode
Tell Cursor:

```
Be Executor. Implement Card 0.1 from PLAN.md.

Feature Spec Card (≤90m):

Title: Project Scaffold + DB Init

Goal: Get the bones in place so Executor can work without friction.

User flow:
1. Run `npm run dev`
2. See Tauri window open with "Hello World"
3. Restart app; window reopens

Contracts touched/created:
- None yet (setup only)

Files to touch (≤7):
1. `package.json` — Add Tauri, React, TS, Zustand, Drizzle, SQLCipher, Zod
2. `src-tauri/tauri.conf.json` — Configure Tauri
3. `drizzle.config.ts` — Configure Drizzle
4. `src/main.tsx` — React entry point
5. Create folder structure per BUILD_RULES.md §2

New files (≤3):
1. `src/App.tsx` — Main app component ("Hello World")
2. `src-tauri/src/main.rs` — Tauri entry point
3. Folder structure (counts as 1 "new file" for budget)

Acceptance checks:
- [ ] `npm run dev` compiles
- [ ] Tauri window opens with "Hello World"
- [ ] Restart app; window reopens

Risks & unknowns:
- Tauri setup might require platform-specific deps (Rust, WebView2)
- SQLCipher might need compilation flags

Rollback plan:
- If Tauri fails, revert to plain Vite + React (defer Tauri to Card 0.2)

Evidence to collect:
- Screenshot of Tauri window with "Hello World"
```

### 4. Let Cursor Work
- Cursor will implement Card 0.1
- It will end with: files changed, rationale, evidence
- You verify the evidence (run `npm run dev`, see window)

### 5. Switch to Planner Mode
Tell Cursor:

```
Be Planner. Review Card 0.1.
```

Cursor will:
- Check that evidence matches acceptance criteria
- Mark ✅ or ❌ in PLAN.md
- Queue Card 0.2

### 6. Repeat the Loop
```
Planner → Executor → Planner → Executor → ...
```

---

## Daily Rhythm

### Morning (30 min — Planner mode):
1. Review PLAN.md Status Board
2. Pick 1–2 cards for the day
3. Ask Cursor: "What am I missing to be 100% confident?"

### Work Block 1 (90 min — Executor mode):
1. "Be Executor. Implement Card X."
2. Verify evidence
3. Update PLAN.md

### Work Block 2 (90 min — Executor mode):
1. "Be Executor. Implement Card Y."
2. Verify evidence
3. Update PLAN.md

### End of Day (15 min — Planner mode):
1. "Be Planner. Review today's cards."
2. Note any patterns in Learning Log
3. Queue tomorrow's cards

---

## Key Guardrails

### Hard Caps (enforced):
- ≤ **7 files changed** per card
- ≤ **3 new files** per card
- ≤ **300 LOC per file**
- If exceeded → **STOP**, split card

### Architecture Rules:
- `ui → state → logic → contracts`
- **No cross-feature imports** (only `shared/*`, `state/*`, `ai/service.ts`, `infra/*`)
- **No business logic in components** (components are dumb)

### Debugging Protocol:
1. Hit error → copy exact error
2. Attempt 1 → try fix
3. Attempt 2 → try different approach
4. **If still broken → REVERT** to last green commit
5. Halve scope and re-run

### Recovery Mantra:
> **"Revert > Patch. Clean slate > tangled debugging."**

---

## What Success Looks Like

### By Phase 4 (MVP — Day 5):
- [ ] Today page: drag tasks, run timer, log created
- [ ] Tasks: CRUD + subtasks + points roll up
- [ ] Goals/Milestones: hierarchy works; progress tracks
- [ ] Planner: generate doc → export → spawn tasks

### By Phase 8 (Production-ready — Day 10):
- [ ] All features work end-to-end
- [ ] Security hardened (IPC, CSP, encryption)
- [ ] Tests pass (unit + integration + CI gates)
- [ ] Backups/restore validated
- [ ] Docs complete (USER_GUIDE + ADRs)
- [ ] No console errors; cold start <1.5s

---

## Files You'll Reference Constantly

| File | When to Use |
|---|---|
| `BUILD_RULES.md` | Before every Cursor run (pin in tab) |
| `PLAN.md` | Track current card, update Status Board |
| `ROADMAP.md` | See full timeline, understand phases |
| `WORKFLOW_CHEATSHEET.md` | Quick commands, debugging protocol |
| `ai/prompts/executor.system.md` | Reference when Executor drifts |
| `ai/prompts/planner.system.md` | Reference when Planner is vague |

---

## Common Pitfalls (and How to Avoid Them)

### Pitfall 1: Brainstorming mid-build
**Symptom:** "Oh, I should also add X feature while I'm here..."  
**Fix:** Capture idea in PLAN.md "Stretch Ideas" section. Stay on current card.

### Pitfall 2: Debugging for hours
**Symptom:** Stuck on same error for >30 min; patching endlessly  
**Fix:** Max 2 attempts. Revert to last green commit. Halve scope.

### Pitfall 3: Vague evidence
**Symptom:** "It should work" or "Looks good"  
**Fix:** Evidence = screenshot, log snippet, test output. No claims without proof.

### Pitfall 4: Exceeding caps
**Symptom:** Card touches 10 files or adds 500 LOC  
**Fix:** STOP. Split card into 2 smaller cards. Update file lists.

### Pitfall 5: Skipping Planner review
**Symptom:** Finish card, immediately start next one  
**Fix:** Always switch to Planner mode to verify evidence before queuing next card.

---

## Emergency Commands

### Totally broken:
```bash
git log --oneline -10  # find last good commit
git reset --hard <hash>
```

### Not sure what broke:
```bash
git diff HEAD~3 HEAD  # see what changed
```

### Cleanup after chaos:
```
Be Planner. What works and what doesn't?
```

Then revert, reduce scope, restart.

---

## Quick Reference: The Loop

```
📋 PLANNER MODE
   ↓ Break into cards (≤90m)
   ↓ Ask clarifying questions
   ↓ Define success criteria
   
⚙️  EXECUTOR MODE
   ↓ Code ONE card
   ↓ Test + commit
   ↓ Update PLAN.md
   
📋 PLANNER MODE
   ↓ Check evidence
   ↓ Mark ✅/❌
   ↓ Queue next card
   
(repeat)
```

---

## What to Do Right Now

1. **Read BUILD_RULES.md** (skim once, 5 min)
2. **Open PLAN.md** in Cursor
3. **Tell Cursor:** "Be Executor. Implement Card 0.1 from PLAN.md." (paste Feature Spec Card from above)
4. **Verify evidence** when Cursor finishes
5. **Tell Cursor:** "Be Planner. Review Card 0.1."
6. **Repeat**

---

## Final Notes

- **Don't paste the entire brief into Cursor** — use Feature Spec Cards (≤90m each)
- **Always start with Planner mode** to break down intent
- **Always verify evidence** before moving to next card
- **Revert early, revert often** — clean slate beats tangled debugging
- **Update Learning Log** after each card — this is how you improve
- **One card at a time** — never blend work

---

## Questions?

If you're stuck or unsure:
1. Check `WORKFLOW_CHEATSHEET.md`
2. Ask Cursor: "What am I missing to be 100% confident?"
3. Switch to Planner mode and ask for a simpler version

**You've got this. Let's build.**

