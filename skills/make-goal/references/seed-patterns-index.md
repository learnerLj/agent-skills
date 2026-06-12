# Seed Patterns Index

Use seed patterns only as raw reusable shapes when no close source-backed pattern fits. Do not cite them as external evidence.

## Category Taxonomy

| Category | Scope |
| --- | --- |
| `backend-api` | routes, OpenAPI specs, handlers, middleware, API tests |
| `backend-data` | schema files, migrations, models, repositories, data tests |
| `devops-ci` | workflow files, build scripts, package manifests, CI logs |
| `devops-runtime` | Dockerfiles, deployment manifests, runtime config, health checks |
| `security-appsec` | auth, input handling, rendering, upload, boundary tests |
| `security-ops` | workflow permissions, cloud IAM, release artifacts, audit evidence |
| `data-eng` | ETL jobs, schemas, source contracts, transformations, data quality tests |
| `data-analytics` | metric SQL, event schemas, dashboards, validation queries |
| `ai-evals` | eval datasets, rubrics, model outputs, judge code, regression reports |
| `ai-ops` | prompts, retrieval, routing, tracing, cost logs |
| `frontend` | routes, components, state, stories, tests, screenshots |
| `design` | design tokens, component variants, layouts, visual states, screenshots |
| `mobile` | mobile routes, forms, gestures, device matrix, viewport tests |
| `docs` | README, docs, examples, runbooks, lint config |
| `product` | PRDs, analytics events, permission models, acceptance criteria |
| `qa` | test suites, fixtures, bug templates, release checklists |
| `accessibility` | interactive elements, semantics, focus management, a11y reports |
| `performance` | Lighthouse reports, bundles, traces, critical routes |
| `workflow` | goal text, progress logs, branch state, verification artifacts |
| `migration` | legacy code, target implementation, compatibility tests, snapshots |
| `prototype` | PLAN.md, milestones, app code, tests, browser checks |
| `prompt-optimization` | prompt files, eval cases, scoring reports, failures |
| `testing` | tests, lint config, CI logs, coverage reports, failing output |
| `investigation` | logs, traces, reproduction notes, source paths, final report |
| `cli` | CLI entrypoints, argument parsing, filesystem behavior, fixtures |
| `refactor` | target module, call sites, public API, tests, compatibility notes |

## High-Value Seed Shapes

**Backend API:** API Contract Drift Audit, Request Validation Boundary, Resource-Level Authorization, Idempotent Create Endpoint, API Error Taxonomy.

**Backend data:** Database Migration Safety, Transaction Boundary Audit, Cache Invalidation Map, Schema Drift Detector, Read Replica Lag Guard.

**Security:** SQL Injection Audit, Command Injection Audit, SSRF Defense Review, XSS Output Encoding, IDOR Audit.

**Frontend / design:** Form Validation UX, Empty State Behavior, Accessibility Color Contrast, Keyboard Navigation Repair, Component API Consistency.

**Testing / CI:** CI Flaky Test Triage, Dependency Update Gate, Monorepo Affected Tests, Coverage Gap Closure.

**AI / evals:** LLM Golden Set Build, LLM Regression Gate, Judge Calibration, Tool Use Eval, Hallucination Probe Suite.

**Docs / maintenance:** Docs Quickstart, Public API Docs Coverage, Repo Maintenance Audit, Release Notes From Diff.

Use a seed by copying its task shape into the full contract and binding it to the user's actual context and verification.
