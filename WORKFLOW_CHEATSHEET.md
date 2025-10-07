# Vibe Coding Workflow - Quick Reference

## The Loop

```
📋 PLANNER → Break down task → Ask questions → Verify requirements
              ↓
⚙️  EXECUTOR → Code ONE task → Test → Commit → Update PLAN.md
              ↓
📋 PLANNER → Check evidence → Mark ✅/❌ → Queue next task
              ↓
              (repeat)
```

---

## Mode Commands

**Start session:**
- "Be Planner. I want to build [feature]"

**Switch to code:**
- "Be Executor. Start with task 1."

**Check work:**
- "Be Planner. Review task 1."

**Debug:**
- "Check console" (let AI read exact error)
- "What are 3 possible causes?"

**Recovery:**
- "Revert to last clean commit"
- "Reduce scope and restart"

---

## Golden Rules

### ✅ DO
- **One task at a time** - never blend work
- **Commit when it works** - before moving to next task
- **Revert when stuck** - max 2 attempts, then reset
- **Check console** - exact errors, not descriptions
- **Update PLAN.md** - externalize all memory
- **Capture patterns** - write what you learned after each task

### ❌ DON'T
- Brainstorm mid-build (capture in "Stretch Ideas" instead)
- Patch endlessly (reset to clean commit after 2 failed attempts)
- Work on multiple features at once
- Let scope creep (new ideas go in PLAN.md, not code)
- Skip tests before moving on

---

## Debugging Protocol

1. **Hit error** → "Check console"
2. **Get causes** → "List 3 possible causes"
3. **Try fix 1** → Test
4. **If fails** → Try different approach
5. **If fails again** → **REVERT** to last clean commit
6. **Back to Planner** → Reduce scope or clarify

**Key:** Revert > Patch. Clean slate > tangled debugging.

---

## Session Checklist

**Before coding:**
- [ ] Open PLAN.md
- [ ] Define MVP features
- [ ] Break into small tasks (<30min each)
- [ ] Ask "What am I missing to feel confident?"

**While coding:**
- [ ] One task at a time
- [ ] Test after implementation
- [ ] Commit when working
- [ ] Update Status Board

**After task:**
- [ ] Switch to Planner mode
- [ ] Verify evidence (tests pass, console clean)
- [ ] Log pattern recognized
- [ ] Queue next task

**End of session:**
- [ ] Note last good commit
- [ ] Mark current state in PLAN.md
- [ ] Capture any blockers

---

## File Structure

```
project/
├── .cursorrules          ← AI instructions
├── PLAN.md               ← Status board + learning log
├── README.md
└── [your code]
```

---

## Quick Wins

**Starting fresh project:**
1. Copy `.cursorrules` and `PLAN.md` template
2. Fill out MVP features
3. "Be Planner. Break this into tasks."
4. Start coding with "Be Executor."

**Debugging death spiral:**
1. "Check console"
2. If 2 attempts fail → revert
3. "Be Planner. Simplify this task."

**Scope creep:**
1. "Add [idea] to Stretch Ideas in PLAN.md"
2. Continue current task

---

## Recovery Mantra

*"It's cheaper to start from clean code than to untangle a bug."*

When stuck → Revert → Rethink → Restart with simpler version.

Restarting ≠ failure. It's part of the process.

---

## Learning Integration

After each task:
```markdown
## Learning Log
- Pattern: [e.g., async state with loading/error/success]
- What worked: [specific approach]
- What to avoid: [pitfall]
```

Over time, you'll see recurring patterns. That's how vibe coding becomes structured learning.

---

## Emergency Commands

**Totally broken:**
```bash
git reset --hard [last-good-commit]
```

**Not sure what broke:**
```bash
git log --oneline -10  # find last working commit
git diff HEAD~3 HEAD   # see what changed
```

**Cleanup after chaos:**
1. "Be Planner. What works and what doesn't?"
2. Revert to last good commit
3. Re-plan with reduced scope
4. Start over

