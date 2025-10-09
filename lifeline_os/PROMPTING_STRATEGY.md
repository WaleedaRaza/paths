# Project Planner Prompting Strategy

## Overview
The Project Planner uses a **5-step sequential LLM chain** to generate comprehensive project documentation from a core idea. Each step produces content for multiple fields, with later steps using earlier outputs as context.

## Chaining Architecture

```
User Input (Core Idea)
    ↓
[Step 1] Project Info → 5 fields (name, one-liner, users, value, differentiators)
    ↓ (feeds context to Step 2)
[Step 2] Research & Stack → 5 fields (tech stack, dependencies, practices, pitfalls, security)
    ↓ (feeds context to Step 3)
[Step 3] Architecture → 6 fields (overview, models, APIs, auth, deployment, scalability)
    ↓ (feeds context to Step 4)
[Step 4] Features → 4 fields (MVP, V1, future, time estimates)
    ↓ (feeds context to Step 5)
[Step 5] Labor → 4 fields (solo timeline, team of 2, team of 3+, critical path)
```

**Total: 24 fields generated**

## Field-Level Format

Each step prompt instructs the LLM to output in markdown format:

```markdown
**Field Name**: Field content here...

**Another Field**: More content...
```

This format is parsed by the UI to extract individual fields for editing.

## Prompt Design Principles

1. **Specificity**: Each prompt asks for exact number of items/sentences
2. **Format Enforcement**: "Format EXACTLY like this" with clear examples
3. **Context Injection**: Later prompts include relevant earlier outputs
4. **Actionability**: Outputs should guide implementation, not just describe
5. **Realism**: Timelines and scope should be pragmatic, not aspirational

## Step-by-Step Breakdown

### Step 1: Project Info (Foundation)
**Purpose**: Define what, who, and why  
**Context**: Only user's core idea  
**Output**: 5 fields establishing project identity

**Key Instructions**:
- Keep answers practical, not marketing fluff
- Be specific about users and alternatives
- Differentiate from competitors concretely

### Step 2: Research & Stack (Technical Foundation)
**Purpose**: Choose technologies and identify risks  
**Context**: Project Info + core idea  
**Output**: 5 fields covering stack decisions

**Key Instructions**:
- Recommend mature, well-documented tools
- Explain WHY each tech choice fits
- Surface real technical gotchas, not generic advice

### Step 3: Architecture (System Design)
**Purpose**: Design how the system works  
**Context**: Project Info + Research + core idea  
**Output**: 6 fields detailing system structure

**Key Instructions**:
- Be detailed enough to guide implementation
- Think through edge cases and integration points
- Include text-based diagrams where helpful

### Step 4: Features (What to Build)
**Purpose**: Break down work into phases  
**Context**: Project Info + Architecture + core idea  
**Output**: 4 fields scoping development

**Key Instructions**:
- MVP should be shippable in weeks, not months
- Each feature should have acceptance criteria
- Time estimates should be realistic with caveats

### Step 5: Labor (Who Does What)
**Purpose**: Plan resource allocation  
**Context**: Features + core idea  
**Output**: 4 fields for different team sizes

**Key Instructions**:
- Focus on dependencies and integration points
- Identify critical path tasks
- Include buffer time and unknowns

## Field Regeneration

When a user clicks "Regenerate" on a field:
1. Use the original project idea
2. Add instruction: "Focus on: [Field Name]"
3. Use the appropriate step prompt
4. Extract only that field from response

## Field Expansion

When a user clicks "Expand" on a field:
1. Take current field content
2. Prompt: "Expand this with more detail and examples: [content]"
3. Maintain format and tone
4. Replace field content

## Field Simplification

When a user clicks "Simplify" on a field:
1. Take current field content
2. Prompt: "Condense this to key points only: [content]"
3. Keep essential information
4. Replace field content

## Model Configuration

- **Model**: `llama3.1:8b`
- **Temperature**: Default (balanced creativity/consistency)
- **System Prompt**: "Expert technical writer and software architect"
- **Max Tokens**: No limit (let responses complete naturally)

## Export Format

All fields are reassembled into markdown sections:

```markdown
# Project Info

**Project Name**: ...
**One-Liner**: ...
[etc]

# Research & Stack

**Tech Stack**: ...
[etc]
```

This creates a comprehensive project document ready for Cursor/IDE context.

## Future Improvements

1. **Parallel Generation**: Steps 1-2 could run concurrently with careful prompt design
2. **User Refinement Loop**: Allow editing idea between steps
3. **Template System**: Preset prompts for common project types (SaaS, CLI tool, etc)
4. **Memory Integration**: Pull from user's past projects for style consistency
5. **Interactive Q&A**: Ask clarifying questions before generation if idea is vague

