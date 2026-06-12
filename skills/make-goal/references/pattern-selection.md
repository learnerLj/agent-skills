# Pattern Selection

The catalog separates source-backed examples from seed patterns. Preserve that boundary.

## Source-Backed

Use when a close match exists and credibility matters.

- Tied to a public URL and a concrete task, example, or usage rule.
- Has source metadata: `source_name`, `source_url`, `source_type`, `evidence`.
- The goal contract is rewritten as a reusable task contract, not copied verbatim.

Common source types: `official-goal`, `official-workflow`, `official-agent-task`, `third-party-tutorial`, `third-party-review`, `third-party-project`, `x-post`, `public-forum`, `github-issue`, `github-pr`, `github-discussion`, `tool-readme`, `video-summary`.

## Seed

Use when no source-backed pattern fits but a reusable shape is useful.

- A reusable catalog pattern.
- Not presented as collected from X, GitHub, docs, a tutorial, or a named author.
- Can later be promoted to source-backed by adding real source metadata.

## Selection Procedure

1. Identify the user's task type and risk: fix, build, review, read-only investigation, migration, CI, security, data, frontend, docs, or plan.
2. Check `source-backed-index.md` for a close source-backed shape.
3. If none, check `seed-patterns-index.md`.
4. Adapt the shape to the user's real repository files, commands, constraints, and evidence.
5. Do not leave catalog placeholders (e.g. generic `npm test`) if the user provided a better local command.
6. If no pattern fits, use the base contract shape and make assumptions explicit.

## Do Not

- Copy a catalog prompt unchanged when the user's repository has different files or commands.
- Treat recipe filters as prompt templates.
- Invent a source URL, source type, category, or evidence phrase.
- Let pattern matching override the user's explicit constraints.
- Use a broad seed when a more specific source-backed pattern matches.
