---
name: make-goal
description: Create, tighten, or review runnable /goal contracts for coding agents. Turns vague engineering intent — issues, PRs, bug reports, plans, CI failures, backlog items — into one measurable task contract with hard constraints, auditable verification, and stop rules. Use when the user asks to write, generate, improve, critique, or productize a goal prompt, rescue contract, done-when contract, verification prompt, or stop-rule prompt.
---

# Make Goal

Turn engineering intent into a runnable task contract. The output is a `/goal` contract, a review of an existing goal, or a catalog draft. Do not implement the underlying code unless the user separately asks.

A good goal is not a wish. It is a contract with one measurable objective, real context to inspect, hard constraints, auditable completion, fresh verification, and stop rules.

## Operating Modes

- **create** — user gives a task, issue, failure, plan, or vague request; produce a new `/goal`.
- **tighten** — user gives an existing draft; make it safer or more executable.
- **review** — user asks whether a goal is good; lead with defects, missing evidence, and risk.
- **catalog** — user wants to add a goal pattern to a catalog; read `references/catalog-contribution.md`.

If the user asks for a goal and also asks you to execute it, produce the goal first. Execute only after confirmation.

## Read Context First

Before drafting, inspect available context instead of guessing:

1. Read the user's request and any pasted error, issue, plan, or draft.
2. In a repository: read `AGENTS.md` / `CLAUDE.md`, relevant issues, docs, logs, and the files or commands named by the user.
3. If the task touches CI, tests, browser behavior, screenshots, migrations, production, data, auth, or security — include the concrete evidence source in `CONTEXT`.
4. Separate confirmed facts from assumptions.

Ask at most three concise questions only when missing information changes the contract:

- What is the one finish line?
- What real files, issue, logs, screenshots, failing command, or baseline must be read first?
- What must not change, and what command/report/screenshot proves completion?

If the request is only "make this project better", "fix everything", or similarly broad — ask for the primary goal, context, and done-when condition instead of drafting a fake comprehensive goal.

## Choose The Shape

**Full** (default) — use when any of these are true:
- High-risk, multi-step, long-running, cross-module, migration, security, auth, data, deployment, production, or user-visible frontend work.
- Mentions plan mode, AGENTS/CLAUDE rules, screenshots, browser smoke tests, CI repair, database changes, or PR readiness.
- Constraints are unclear or the task could drift into unrelated cleanup.

**Compact** — use only for routine, low-risk work with clear context and one or two simple verification commands.

Read `references/contract-shape.md` for both templates.

## Pattern Selection

Use source-backed patterns first when a close match exists (trusted shapes backed by public examples). Use seed patterns only as raw reusable shapes when no source-backed pattern fits.

Read:
- `references/pattern-selection.md` — how to choose between source-backed and seed patterns.
- `references/source-backed-index.md` — common rescue contracts and goal-workflow patterns.
- `references/seed-patterns-index.md` — only when the source-backed index lacks a close shape.

## Lint

Run the bundled linter on generated output:

```bash
python3 scripts/lint_goal.py <goal.md>
```

Profiles: `--profile compact`, `--profile data-migration`, `--profile security-xss`, `--profile read-only`, `--profile launch-readiness`, `--profile clarify`. Combine with commas. Use `--json` for machine output.

Run the fixture evals after changing this skill:

```bash
python3 scripts/run_evals.py
```

## Required Sections

Every full goal must contain exactly these:

```text
/goal
GOAL:
<One measurable goal.>

CONTEXT:
- <Files, docs, issues, logs, screenshots, commands, baseline, conventions.>

CONSTRAINTS:
- <What must not change; what must be preserved; safety, data, security, test, scope boundaries.>

DONE WHEN:
- <Mechanically auditable completion condition.>

VERIFY:
- <Fresh command, report, screenshot, artifact, manual check, or explicit blocker.>

OUTPUT:
- <Changed files, key decisions, verification output, remaining risk, follow-up.>

STOP RULES:
- <When to pause instead of guessing.>
```

Compact form:

```text
/goal <single measurable goal>

Read first: <files/issues/logs>.
Constraints: <what must not change; what must be preserved>.
Done when: <mechanically checkable end state>.
Verify with: <commands/reports/screenshots/evidence>.
Stop if: <missing input, destructive operation, repeated failed fixes, production access, or unclear product decision>.
Final output: <changed files, verification, risks, next action>.
```

## Six Moves

1. **Singular goal.** One goal can be large, but it needs one finish line.
2. **Real context.** Point at issues, files, logs, failing commands, design docs, screenshots, or branch state.
3. **Hard constraints.** API compatibility, forbidden files, data safety, security rules, test integrity, non-goals.
4. **Mechanical completion.** Define `DONE WHEN` so it can be audited from repo state or artifacts.
5. **Fresh verification.** Require commands, reports, screenshots, logs, artifacts, or an explicit blocker from this run.
6. **Escape hatch.** Give the agent a way to stop for secrets, production access, destructive data work, unclear decisions, and repeated failed fixes.

## Safety Defaults

Include these constraints unless they conflict with a more specific requirement:

- Keep scope limited to this goal; no unrelated cleanup.
- Include `Verification integrity: do not weaken or bypass tests, assertions, lint, typecheck, validation, generated-output checks, screenshots, or external blockers to make the goal pass; fix the root cause or report the blocker.` when edits, validation, generated outputs, tests, lint, typecheck, screenshots, or external checks are involved.
- Respect repository instructions and existing patterns.
- Stop on secrets, production access, destructive data operations, missing credentials, or product decisions.
- Stop after three failed attempts on the same symptom and revisit the root-cause hypothesis.
- Do not mark complete until checked against `DONE WHEN`.

### Category-Specific Constraints

**Security / auth:** preserve auth/authz, validate inputs, avoid unsafe HTML sinks, string-built SQL, shell string execution, and secret exposure.

**Data / migrations:** write the literal term `dry-run` into the goal. Require `dry-run` when supported; if unavailable, require a disposable-environment rehearsal. Require rollback or forward-only recovery notes, row-count/checksum integrity evidence, and no silent data loss.

**Frontend:** preserve accessibility, keyboard behavior, existing design system. Include browser or screenshot evidence for user-visible changes.

**CI / testing:** reproduce or locate the current failure, fix production or fixture causes before changing assertions, require fresh command output.

**Investigation:** keep changes read-only unless the goal explicitly asks for a fix; separate evidence from hypotheses.

**Launch / readiness / release-prep:** add a scope fuse. If work expands into multiple independent PR-sized changes, keep the current goal to the smallest launch-readiness pass and list follow-up PRs. Treat external outcomes (trending, ranking, traffic, approval) as targets, not guarantees. Record owner-access work as manual steps or exact blockers.

**Growth / launch plans:** treat stars, traffic, virality, Trending placement, rankings, external review approval, and awesome-list acceptance as external outcome targets. Keep the deliverable to a source-backed report, first PR scope, launch sequence, and measurement plan unless the user explicitly asks for execution.

## Output Rules

1. Output the final contract in one fenced `text` block.
2. After the block, add a short note only if needed: assumptions made, missing context, or why full/compact was chosen.
3. Do not start executing the goal in the same response. Wait for explicit confirmation.
4. Do not include lengthy internal analysis or catalog trivia.

When **reviewing** a goal:
1. Lead with findings ordered by severity.
2. Cite missing sections, vague done conditions, unverifiable `VERIFY`, unsafe constraints, or weak stop rules.
3. Provide a revised contract if asked.

When writing a **catalog entry**:
1. Read `references/catalog-contribution.md`.
2. Distinguish `source-backed` from `seed`.
3. Do not invent source metadata.

## Self-Check

Before responding, verify:

- [ ] One primary goal, not a backlog.
- [ ] `CONTEXT` names real files, issues, logs, docs, commands, screenshots, or baselines.
- [ ] `CONSTRAINTS` say what must not change.
- [ ] `DONE WHEN` is mechanically checkable or evidence-based.
- [ ] `VERIFY` requires fresh evidence from the actual run, not a generic "run tests".
- [ ] `STOP RULES` cover secrets, production access, destructive operations, and repeated failed fixes.
- [ ] Launch/release-prep goals include a scope fuse and manual platform blocker language.
- [ ] Seed patterns are not presented as source-backed evidence.

## Avoid

Replace vague language with measurable proof:

- "make no mistakes" → name the specific invariant
- "fix everything" → name the one primary fix
- "do whatever it takes" → name the constraint boundary
- "improve the codebase" → name the metric or artifact
- "keep going until perfect" → name the done condition
- "use your best judgment" without constraints → name what must not change
