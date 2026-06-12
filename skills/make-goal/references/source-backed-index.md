# Source-Backed Index

Compact pattern map. Adapt the shape to the user's real repository, files, commands, and constraints.

## Ten Rescue Patterns

| User situation | Pattern | Intent | Verification |
| --- | --- | --- | --- |
| Auth tests and lint are both red | Auth Tests And Lint Clean | Keep auth behavior while making tests and lint pass. | `npm test -- test/auth && npm run lint` |
| CI has mixed test, lint, typecheck failures | CI Pipeline Green | Repair CI failures until checks pass. | local CI rerun and remote CI |
| A migration needs proof | Dev Database Migration Proof | Write/apply a migration and prove schema match. | dev DB migration and schema comparison |
| A PR may have security bugs | Security PR Review | Review auth, injection, XSS, secrets, input validation. | severity/level PR review |
| Checkout crashes from a stack trace | Checkout Crash Regression Fix | Reproduce, root-cause, fix, add regression test. | crash reproduction + regression test |
| Users see an empty billing state | Billing Empty State Root Cause | Find cause without changing pricing/webhooks. | tests + root-cause evidence |
| A visual migration must not drift | Visual Migration With Playwright | Preserve screen output through migration. | `npx playwright test` |
| Agent runs need traceability | Agent Trace Observability | Add trace spans for one representative agent run. | trace dashboard shows spans |
| `npm audit` is red | NPM Audit Clean Remediation | Patch vulnerabilities without API breakage. | `npm audit && npm test` |
| A plan may have holes | Review Plan Until No Gaps | Loop review until a fresh review finds no gaps. | fresh plan review has no new gaps |

## Goal Workflow Patterns

- **Meta Goal Prompt Generator** — inspect session, repo, history, docs before writing the actual `/goal`.
- **AGENTS.md Goal Workflow** — combine repository agent rules with `/goal` so constraints survive long work.
- **Plan-Then-Goal Execution** — define work in plan mode, then execute a stable goal.
- **Measurable Goal Structure** — require a clear target, proof requirement, and explicit limits.
- **Long Task Until Verification** — continue long work until final verification passes.
- **Completion Audit Before Done** — audit done criteria before marking completion.
- **Goal Escape Hatch** — define an incomplete state for impossible or blocked subtasks.

## Patterns By Intent

**Testing / CI:** Auth Tests And Lint Clean, TypeScript ESLint Coverage Gate, Ruff Clean Source Tree, Tests And Lint Completion, CI Pipeline Green, Go Race Cleanup.

**Investigation / regression:** Checkout Crash Regression Fix, Billing Empty State Root Cause, Build Log Failure Diagnosis, Session Drift Report.

**Migration:** Visual Migration With Playwright, Feature Port With CI Green, Finish Migration Keep Tests Green, Module API Migration, Moment To Day.js Migration, React 19 Migration, Pydantic V1 To V2 Migration.

**Security:** Security PR Review, NPM Audit Clean Remediation, Tool Guardrails For AppSec.

**Frontend / design:** Button Console Error Fix, Fix Freezing Chart Tooltips, Visual Feedback With Test Guard, Theme Toggle Persistence, Reference Layout Match, HTML WCAG Instruction Audit.

**Data / backend:** Dev Database Migration Proof, Slow Query Optimization Report, API Integration Tests, User Preferences API, CSV Processing Report, Rate-Limited Web Scraper.

**AI / agent systems:** Agent Trace Observability, Trace-Graded Agent Regression, Eval-Driven Prompt Optimization, Router Prompt Eval Score, RAG Chat Flywheel.

**Docs / maintenance:** Contributor README Rewrite, Public API Docs Coverage, Weekly Changelog Coverage, Repo Maintenance Audit, Clean Worktree File Budget.

**Product / planning:** Design Doc Acceptance Complete, Feature Flag System, OKR Development From Vague Priorities.
