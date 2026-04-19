/// Field-specific micro-prompts that enforce structure and format
/// These are appended to the base refinement prompt for certain fields
class FieldPrompts {
  /// Tech Stack field - List-only expander with comprehensive layer coverage
  static String getTechStackExpandAddendum() {
    return '''
TECH STACK SPECIFIC RULES:
Return ONLY list items, one tool per line, grouped by layer with prefix.
No justifications, 1-3 word inline tags allowed in parentheses.
Target 22-32 lines.

Layers to cover (in order):
Frontend, Mobile, State, Data-Fetching, UI Kit, Forms/Validation, API (REST/tRPC), 
Realtime, DB, ORM, Migrations, Caching/Queue, Search/Vector, ML/Embeddings, Auth, 
Storage, Infra/Deploy, CI, Telemetry, Testing (unit/e2e), Feature Flags, Docs/Design

Example line format:
- Frontend: Next.js 14 (App Router)
- State: Zustand
- Data-Fetching: TanStack Query
- API: tRPC
- DB: Postgres 16 (RLS)
- Auth: Auth0 (OIDC)

Prohibit generic phrases: ["vast ecosystem", "large community", "robust", "widely used", "popular choice"]
''';
  }

  /// Dependencies field - Dense catalog format
  static String getDependenciesAddendum() {
    return '''
DEPENDENCIES SPECIFIC RULES:
List only packages, grouped by area using "Area: pkg1, pkg2, pkg3" format per line.
Return 8-12 lines. No descriptions.
Areas: FE, Mobile, API, Data, ML, Testing, Telemetry, Infra, DX, Lint/Format

Example:
- FE: react, react-dom, next
- State: zustand, @tanstack/react-query
- API: trpc, express, zod
- Data: prisma, drizzle, @prisma/client
- ML: openai, langchain, @pinecone-database/pinecone
- Testing: vitest, playwright, testing-library
- Telemetry: sentry, posthog, opentelemetry
- Infra: vercel, terraform, docker
''';
  }

  /// Best Practices field - Rule-Why format
  static String getBestPracticesAddendum() {
    return '''
BEST PRACTICES SPECIFIC RULES:
Return 6-8 lines; each format: "Rule — Why (≤5 words)".

Examples:
- Freeze DTOs — stop drift
- RLS by default — prevent leaks
- Typed contracts — catch breaks early
- Idempotent handlers — safe retries
- Feature flags — rollback fast
- API versioning — backward compat
''';
  }

  /// Common Pitfalls field - Pitfall-Symptom format
  static String getCommonPitfallsAddendum() {
    return '''
COMMON PITFALLS SPECIFIC RULES:
Return 6-8 lines; each format: "Pitfall — Symptom".

Examples:
- Ad-hoc schemas — mismatched payloads
- No RLS — data leaks
- Eager loading — N+1 queries
- Missing indexes — slow queries
- No rate limits — API abuse
- Weak auth — unauthorized access
''';
  }

  /// Security field - Checklist format
  static String getSecurityAddendum() {
    return '''
SECURITY SPECIFIC RULES:
Return exactly 8 lines; each format: "Area: directive".

Examples:
- RLS: user_id = auth.uid()
- Secrets: env vars + Vault
- Rate limit: 100 req/min per user
- Audit: log all mutations
- Encryption: AES-256 at rest
- HTTPS: TLS 1.3 only
- CORS: whitelist origins
- Input: Zod validation + sanitize
''';
  }

  /// Get micro-prompt addendum for specific field/action combinations
  static String? getMicroPrompt(String sectionType, String fieldName, String action) {
    if (sectionType == 'research') {
      if (fieldName == 'Tech Stack' && action == 'expand') {
        return getTechStackExpandAddendum();
      }
      if (fieldName == 'Dependencies') {
        return getDependenciesAddendum();
      }
      if (fieldName == 'Best Practices') {
        return getBestPracticesAddendum();
      }
      if (fieldName == 'Common Pitfalls') {
        return getCommonPitfallsAddendum();
      }
      if (fieldName == 'Security') {
        return getSecurityAddendum();
      }
    }
    return null;
  }
}
