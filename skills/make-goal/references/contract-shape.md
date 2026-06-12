# Contract Shape

A `/goal` is a task contract, not a wish. It tells the agent what to reach, what to inspect, what must not change, how completion will be proven, and when to stop.

## Full Template

Use by default for high-risk, multi-step, cross-module, long-running, migration, security, data, production, CI, or user-visible frontend work.

```text
/goal
GOAL:
<One clear, measurable goal. Do not include unrelated backlog items.>

CONTEXT:
- Repository or product area:
- Files, docs, issues, logs, screenshots, or plans to read first:
- Current known failure, gap, or baseline:
- Important project conventions:

CONSTRAINTS:
- Do not change:
- Must preserve:
- Security/data/test constraints:
- Scope boundaries and non-goals:

DONE WHEN:
- <Concrete completion condition 1>
- <Concrete completion condition 2>
- <Concrete completion condition 3>

VERIFY:
- Run:
- Inspect:
- Capture:
- If verification cannot run, stop and explain the exact blocker.

OUTPUT:
- Changed files:
- Key decisions:
- Verification output:
- Remaining risk:
- Follow-up:

STOP RULES:
- Stop on missing secrets, production credentials, destructive data operations, or product decisions.
- Stop after three failed attempts on the same symptom and revisit the root-cause hypothesis.
- Do not mark complete until the current state has been checked against DONE WHEN.
```

## Compact Template

Use only for routine, scoped, low-risk work where context and verification command are already clear.

```text
/goal <single measurable goal>

Read first: <files/issues/logs>.
Constraints: <what must not change; what must be preserved>.
Done when: <mechanically checkable end state>.
Verify with: <commands/reports/screenshots/evidence>.
Stop if: <missing input, destructive operation, repeated failed fixes, production access, or unclear product decision>.
Final output: <changed files, verification, risks, next action>.
```

## Review Checklist

- [ ] One primary objective.
- [ ] Context names real files, issues, logs, docs, screenshots, or commands.
- [ ] Constraints say what must not change.
- [ ] `DONE WHEN` can be audited from repository state or artifacts.
- [ ] `VERIFY` uses fresh commands or evidence from this run.
- [ ] Stop rules cover secrets, production access, destructive operations, and repeated failed fixes.
- [ ] Final output asks for changed files, verification, decisions, risks, and next action.
