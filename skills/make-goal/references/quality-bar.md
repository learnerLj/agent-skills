# Quality Bar

Use this reference before finalizing high-risk goals or reviewing an existing goal.

## Accept Good Goals

- One real engineering scenario and one primary objective.
- Deterministic verification where possible.
- Protect tests, data, secrets, user-visible behavior, and production systems.
- Name real context instead of asking the agent to guess.
- Teach or reuse a pattern that is meaningfully different from existing examples.
- Include an incomplete state when local verification or access is impossible.

## Reject Weak Goals

- "optimize the app", "fix all bugs", "make it better", or similar.
- Asking the agent to weaken tests, swallow errors, invent contracts, or bypass auth.
- Requiring reading, printing, or hardcoding secrets.
- Automatic merge, force push, or production deployment without explicit human approval.
- Claiming completion without fresh verification.

## Safety Constraints By Risk

**Security / auth:**
- Do not bypass authentication, authorization, validation, or audit checks.
- Do not use unsafe HTML injection, `eval`, shell string concatenation, or string-built SQL.
- Validate URLs with allowlists (protocol allowlists) instead of blacklist-only checks.
- Do not print, copy, rotate, or exfiltrate real secrets.

**Data / migrations:**
- Require `dry-run` when supported; if unavailable, require disposable-environment rehearsal.
- Require rollback or forward-only recovery notes, row-count/checksum evidence.
- Do not hide database errors behind warnings or silent fallbacks.
- Stop if production credentials or destructive operations are required.

**Tests / CI:**
- Do not weaken lint, typecheck, coverage, or test rules to create a green result.
- Do not delete or weaken failing tests.
- Reproduce failures before changing production code.
- Final verification must come from the current run, not stale claims.

**Frontend / design:**
- Do not rewrite unrelated routes or replace the design system.
- Preserve accessibility and keyboard behavior unless the goal explicitly changes them.
- Use browser, screenshot, or Playwright evidence for user-visible changes.

**Investigation:**
- Separate observed evidence from hypotheses.
- Do not patch production code until the root cause is reproduced or strongly evidenced.
- If the goal is read-only, make the non-edit boundary explicit.

**Agent workflow:**
- Do not claim a goal is complete without auditing the current goal text and state.
- Pause if the goal text, branch state, permission context, or repository rules conflict.
- Preserve AGENTS.md / CLAUDE.md rules through long-running work.

## Deduplication

- Same goal + same verification = duplicate.
- Prefer a more specific goal over a broad goal.
- Prefer concrete verification over subjective judgment.
- Keep broad categories as references, not excuses for vague goals.
