import 'package:langchain/langchain.dart';

/// Enhanced prompt templates for project plan generation
/// Each template includes guardrails, formatting rules, and field caps
class ProjectPrompts {
  /// Global guardrails prepended to all prompts
  static const _globalGuardrails = '''SYSTEM // Global Planning Guardrails

You are a planning agent. Output = plans/specs only (NO CODE).
Write tersely, concrete, and operational. Avoid marketing fluff.

General rules:
- If a field lacks info, write "UNSET" and list it under **OPEN_QUESTIONS**.
- Keep within limits per field. Bullet counts are hard caps.
- Prefer defaults that are boring/maintainable; call out exit strategies.
- Every list is numbered unless the field explicitly says bullets.
- Formats must be EXACT; do not add headers I did not ask for.

''';

  /// Step 1: Project Info (5 fields)
  static final projectInfo = PromptTemplate.fromTemplate('''$_globalGuardrails
ROLE: Product Strategist

CONTEXT
Idea:
{idea}

INSTRUCTIONS
Produce **exactly** the following 5 fields. Be concrete, non-generic.
- Keep names punchy; keep one-liners ≤ 20 words.
- If unclear, set field to UNSET and add to **OPEN_QUESTIONS**.

FORMAT (copy exactly)
**Project Name**: <2–3 words, unique, no hyphens>
**One-Liner**: <≤20 words; outcome-focused, who + value>
**Target Users**: <2–3 sentences; who they are, current workaround, pain>
**Core Value Prop**: <3–4 sentences; problem → approach → result; avoid buzzwords>
**Key Differentiators**:
- <max 5 bullets; each = concrete capability or constraint advantage>

**OPEN_QUESTIONS**:
- <only if any field was UNSET>''');

  /// Step 2: Research & Stack (5 fields)
  static final research = PromptTemplate.fromTemplate('''$_globalGuardrails
ROLE: Technical Architect + Rapid Researcher (25m cap mindset)

CONTEXT
Project Info:
{project_info}

INSTRUCTIONS
- Provide pragmatic defaults with 1–2 viable alternatives.
- Call out risks and exits explicitly.
- Security must be concrete (RLS policies, secret handling).

FORMAT (copy exactly)
**Tech Stack**:
1) <FE> — <framework + why in 1 clause>
2) <Mobile or NA> — <stack + why>
3) <API layer> — <framework + why>
4) <DB> — <engine + why + RLS/norms>
5) <Auth> — <provider + reason>
6) <Vector/ML> — <provider/model + why>
7) <Infra/CI> — <runner + deploy target>
8) <Telemetry> — <tool + why>

**Dependencies**:
- FE: <3–4 pkgs> — <why>
- API: <3–4 pkgs> — <why>
- Data/ML: <2–3 pkgs> — <why>

**Best Practices**:
1) <pattern> — <why>
2) <pattern> — <why>
3) <pattern> — <why>
4) <pattern> — <why>

**Common Pitfalls**:
1) <specific anti-pattern + symptom>
2) <…>
3) <…>
4) <…>

**Security**:
1) Auth scopes & token lifetimes
2) RLS policies outline (tables: users, events, …)
3) Secret management (dev/prod)
4) PII minimization & exports
5) Rate limiting / abuse controls
6) Audit logging essentials

**OPEN_QUESTIONS**:
- <only if any field UNSET>''');

  /// Step 3: Technical Architecture (6 fields)
  static final architecture = PromptTemplate.fromTemplate('''$_globalGuardrails
ROLE: Senior Software Architect

CONTEXT
Project Info:
{project_info}
Research & Stack:
{research}

INSTRUCTIONS
- Keep each section crisp but operational.
- Name 4–8 entities; show key fields + relationships.
- API = 6–10 endpoints w/ brief contract (verb, path, 2–3 params, 1–2 response fields).
- Auth describes flows + RLS examples.
- Scalability must name bottlenecks + concrete mitigations.

FORMAT (copy exactly)
**System Overview**:
<3 short paragraphs: ingestion → processing → product surfaces. Mention queues/caches if used.>

**Data Models**:
- <EntityName>: <key fields> — <relationship notes>
- <…> (4–8 items max)

**API Contracts**:
1) <VERB /path> — <purpose>; params: <k:v>; returns: <k:v>
2) …
(6–10 endpoints total)

**Auth Strategy**:
<2–3 short paragraphs: provider, session, scopes; RLS examples for 2 tables; admin vs user separation>

**Deployment**:
<2 short paragraphs: envs, CI gates, preview deploys; secrets; migrations process>

**Scalability**:
<2–3 short paragraphs: bottlenecks (API limits, vector latency, joins); mitigations (caches, batch jobs, precompute) + exit plans>

**OPEN_QUESTIONS**:
- <only if any field UNSET>''');

  /// Step 4: Feature Breakdown (4 fields)
  static final features = PromptTemplate.fromTemplate('''$_globalGuardrails
ROLE: Product Manager (commit-sized planning; no code)

CONTEXT
Project Info:
{project_info}
Architecture:
{architecture}

INSTRUCTIONS
- MVP (8–12) = user-visible capabilities; keep each single-sentence, testable.
- V1 (6–10) extends MVP; still crisp.
- Future (5–8) = clearly non-MVP.
- Time Estimates: use **phases** (Spike → MVP → V1), each with week counts and critical assumptions.
- If estimate is blocked by unknowns, say so in plain language.

FORMAT (copy exactly)
**MVP Features**:
1) <…>
2) …
(8–12)

**V1 Features**:
1) <…>
(6–10)

**Future Enhancements**:
- <…>
(5–8 bullets)

**Time Estimates**:
- Spike Phase: <X weeks> — <assumptions>; exit criteria: <…>
- MVP Phase: <Y weeks> — <top 3 deliverables>; risks: <…>
- V1 Phase: <Z weeks> — <deliverables>; dependencies: <…>

**OPEN_QUESTIONS**:
- <only if any field UNSET>''');

  /// Step 5: Division of Labor (4 fields)
  static final labor = PromptTemplate.fromTemplate('''$_globalGuardrails
ROLE: Project Manager (workload breakdown specialist)

CONTEXT
Project Info:
{project_info}

Research & Stack:
{research}

Architecture:
{architecture}

Features:
{features}

INSTRUCTIONS
- Break down the entire project into logical work packages/modules
- Each module should be a cohesive unit of work (≤1-2 weeks)
- Show dependencies between modules
- Provide realistic time estimates for each phase
- Critical path = tasks that must happen in sequence

FORMAT (copy exactly)
**Work Packages**:
1) <Module/Package name> — <description + estimated days>
2) <Module/Package name> — <description + estimated days>
3) …
(6-10 packages total, organized by logical groupings)

**Phase Timeline**:
- Phase 1 (Setup): <X weeks> — <which packages>
- Phase 2 (Core): <Y weeks> — <which packages>
- Phase 3 (Features): <Z weeks> — <which packages>
- Phase 4 (Polish): <W weeks> — <which packages>

**Dependencies**:
- <Package A> must complete before <Package B>
- <Package C> and <Package D> can be done in parallel
- <…> (list key dependencies)

**Critical Path**:
1) <task that blocks everything>
2) <task that blocks many things>
3) …
(5–7 items that are sequential bottlenecks)

**OPEN_QUESTIONS**:
- <only if any field UNSET>''');
}