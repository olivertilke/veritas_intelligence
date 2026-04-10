# AI Execution Rules

## Purpose

This document defines how AI coding sessions should operate inside the VERITAS repository.

It exists to keep many AI-assisted contributors aligned while building one coherent production OSINT platform.

This is not just about code style.

It is about:

- architectural consistency
- product quality
- security
- reliability
- explainability
- safe collaboration between multiple AI coding sessions

If an AI is asked to build or refactor something in VERITAS, it should follow this document.

---

## Core Principle

VERITAS is a production intelligence platform.

Do not treat it like:

- a tutorial app
- a throwaway prototype
- a design-only demo
- a generic CRUD project

Every code change should support the long-term goal:

> Build a trustworthy, explainable, cinematic OSINT operating system for narrative warfare analysis.

---

## Product Rules

### Rule 1: Intelligence First

The product is not “the globe”.
The product is not “the UI”.
The product is not “the AI chat”.

The real product is the intelligence layer underneath all views.

That means:

- data integrity matters
- source provenance matters
- explainability matters
- confidence matters
- analyst workflow matters

A visually impressive feature with weak intelligence under it is lower value than a simpler feature with strong reasoning.

### Rule 2: Trust Is A Feature

Any feature that affects trust, threat, narrative, contradiction, or perspective must be explainable.

Never ship:

- opaque trust scoring with no rationale
- unexplained threat labels
- black-box contradictions
- black-box perspective weighting

If the product says something important, the system should help the user understand why.

### Rule 3: No Fake Production Features

Do not implement “fake” production behavior just to make screens look complete.

Examples of what not to do:

- heatmaps fed by hardcoded numbers
- fake live updates
- simulated intelligence scores presented as real outputs
- placeholder analytics presented as truth

If temporary placeholders are unavoidable:

- label them clearly
- isolate them cleanly
- do not present them as finished

### Rule 4: Preserve Roadmap Features

Do not delete unfinished features just because they are incomplete.

Instead:

- gate them safely
- route them to explicit placeholder states
- keep the architecture prepared for their completion

The goal is controlled evolution, not destructive simplification.

---

## Execution Rules For Every AI Session

### Rule 5: Inspect First

Before making changes:

1. read the relevant controller/model/service/view/job code
2. inspect routes/schema/tests related to the feature
3. understand whether the feature is already partially implemented
4. identify existing conventions in this repo

Do not assume the architecture.
Do not rebuild what already exists.

### Rule 6: Prefer The Smallest Coherent Change

Do not make random scattered edits.

Prefer:

- one coherent domain change
- one coherent service extraction
- one coherent UI improvement
- one coherent data model extension

Each session should ideally complete one logical slice end-to-end.

### Rule 7: End-To-End Over Half-Built Layers

When feasible, complete the full slice:

- schema/domain
- service logic
- controller integration
- view/UI integration
- tests

Avoid adding only a model, or only a page, or only a service, without wiring it into actual behavior unless that is intentionally staged.

### Rule 8: Do Not Break Existing Working Flows

Before editing, identify what currently works.

Protect:

- article pages
- search
- saved articles
- watchlist
- briefings
- intelligence reports
- existing analysis pipeline behavior

If refactoring a working feature:

- preserve current behavior
- improve safety/structure
- add regression tests where practical

---

## Architecture Rules

### Rule 9: Favor Explicit Domain Models

If a concept matters to the product, prefer a real model or explicit schema fields instead of hiding everything in generic text/JSON blobs.

Good candidates for explicit models:

- Source
- Claim
- Entity
- Alert
- Watchlist
- TopicDossier
- Workspace

Use JSON only when:

- the structure is truly flexible
- the domain is not yet stable
- the data is auxiliary rather than central

### Rule 10: Keep Controllers Thin

Controllers should orchestrate, not perform heavy business logic.

Move logic into:

- services
- jobs
- policies
- query objects if needed

Avoid growing giant controllers, especially in high-risk flows like:

- ingestion
- parsing
- AI analysis
- narrative clustering
- report generation

### Rule 11: Jobs Should Be Idempotent

Any background job should be safe to retry or skip intelligently.

Jobs must:

- handle missing records safely
- avoid duplicate expensive work
- maintain clear state transitions
- log failures meaningfully

### Rule 12: Use Clear Status Lifecycles

If a process has multiple stages, model it explicitly.

Examples:

- pending
- processing
- completed
- failed

or

- discovered
- fetched
- parsed
- analyzed
- embedded

Avoid vague implicit workflow states.

### Rule 13: Introduce Services Before Complexity Explodes

When a feature grows beyond trivial logic, extract a service early.

Strong service candidates:

- ingestion orchestration
- article parsing
- semantic retrieval
- perspective weighting
- report generation
- alert generation

---

## Security Rules

### Rule 14: No Unsafe HTML Rendering

Never trust:

- article HTML
- model output
- markdown rendered from AI responses
- external provider text

All rendered HTML must be:

- sanitized
- escaped when appropriate
- reviewed for XSS risk

### Rule 15: Treat External Fetching As High Risk

Any server-side fetch of remote content must consider:

- SSRF
- private IP targets
- localhost access
- timeouts
- redirects
- malformed URLs

Never casually fetch arbitrary URLs from the database without controls.

### Rule 16: Avoid Leaking Internal Errors To Users

User-facing errors should be useful but not reveal:

- raw API responses
- provider payloads
- internal stack traces
- secrets
- infrastructure details

Detailed information belongs in logs, not in the UI.

### Rule 17: Respect Auth Boundaries

Any feature involving:

- admin operations
- intelligence generation
- alerts
- shared workspaces
- exports

must have explicit permission behavior.

Do not rely on assumptions.

---

## Data And AI Rules

### Rule 18: LLMs Are Intelligence Components, Not The Entire System

LLMs should:

- summarize
- compare
- classify
- synthesize
- label

LLMs should not be the only source of truth for:

- core state
- system structure
- source provenance
- persistence logic

Use deterministic data structures around model outputs.

### Rule 19: Every Important AI Output Should Have Context

If the platform produces:

- a trust score
- a threat level
- a contradiction
- a narrative label
- a perspective comparison

then the system should also provide:

- rationale
- supporting sources
- confidence
- failure state handling

### Rule 20: Prefer Fallbacks Over Total Failure

If an AI provider fails:

- preserve usable system behavior where possible
- degrade gracefully
- mark incomplete status clearly
- do not silently fake completion

Examples:

- fallback summary instead of raw failure
- partial report with warning
- queued retry state

### Rule 21: Retrieval Quality Matters More Than Chat Styling

For RAG-like features, prioritize:

- corpus quality
- source filtering
- candidate selection
- diversity
- citation quality

before spending time on chat cosmetics.

---

## Testing Rules

### Rule 22: Test Critical Paths, Not Just Models

Model tests alone are not enough.

Prioritize tests for:

- controller flows with permissions
- service objects
- ingestion logic
- AI pipeline state transitions
- real-time state changes
- regression-prone security logic

### Rule 23: Add Regression Tests For Bugs You Fix

If you fix a bug:

- add a targeted regression test when practical

This is especially important for:

- rendering bugs
- permission bugs
- job duplication bugs
- query API mismatches
- parsing/fetching bugs

### Rule 24: Verify Behavior, Not Only Syntax

Do not stop at:

- successful linting
- no syntax errors
- app boots

Try to verify the feature behavior itself with:

- tests
- targeted commands
- meaningful assertions

### Rule 25: If You Cannot Run Tests, Say So Clearly

If the environment blocks testing:

- state that explicitly
- explain what was attempted
- identify the missing verification step

Never imply verification that did not happen.

---

## Migration Rules

### Rule 26: Migrations Must Be Production-Safe

Before creating a migration:

- think about existing data
- think about indexes
- think about uniqueness
- think about nullability
- think about backfills

Avoid careless destructive changes.

### Rule 27: Add DB Constraints For Real Integrity

If the system depends on uniqueness or required relationships, enforce it in the database where possible.

Rails validations alone are not enough for production integrity.

### Rule 28: Prepare For Forward Evolution

Schema changes should support the future roadmap.

Do not optimize schema only for the current view.

---

## UI And UX Rules

### Rule 29: The UI Must Feel Intentional

VERITAS should not look like:

- a generic admin panel
- default bootstrap app
- generic “AI tool” wrapper

The UI should feel:

- cinematic
- tactical
- high-signal
- intelligence-grade

### Rule 30: Visuals Must Carry Meaning

Do not add visuals that do not correspond to real backend logic.

Examples:

- arcs should represent actual propagation logic
- heatmaps should represent real metrics
- badges should represent real state

### Rule 31: Avoid Information Theater

Not every metric should be shown.

If a UI element does not help decisions, deprioritize it.

Prefer:

- fewer, stronger indicators
- clear labels
- evidence-linked views

over noisy dashboard clutter.

---

## Collaboration Rules For Many Vibecoders

### Rule 32: Leave Clear State Behind

At the end of an AI coding session, leave behind:

- changed files
- summary of what was implemented
- what remains unfinished
- what should happen next

- `docs/VERITAS_MASTER_EXECUTION_PLAN.md` (single source of truth for all development)
- `AGENTS.md` / `CLAUDE.md` (agent identity and project context)
- `ai_execution_rules.md` (this document)

### Rule 33: Do Not Secretly Shift Product Direction

If a coding session changes architecture or product behavior significantly, document it.

Do not silently:

- rename core concepts
- replace core flows
- collapse domain models
- remove roadmap hooks

### Rule 34: Respect Existing Repo Conventions

If the repo already has conventions for:

- controllers
- services
- views
- naming
- status enums

follow them unless there is a strong reason to improve them.

If improving them:

- do so coherently
- explain the change

### Rule 35: Keep Context Files Useful

If you create or update planning files, keep them:

- practical
- current
- easy for the next AI to use

Avoid vague brainstorming documents with no execution value.

---

## Definition Of A Good AI Session

A good AI session in VERITAS should:

- understand the local architecture first
- solve one coherent problem properly
- preserve product direction
- increase trust or capability
- leave the repo safer and clearer than before

It should not:

- scatter random changes across unrelated areas
- optimize superficial UI before backend truth exists
- hide complexity in giant blobs
- break working flows
- create flashy but shallow behavior

---

## Final Standard

When in doubt, choose the path that makes VERITAS:

- more trustworthy
- more explainable
- more analyst-useful
- more operational
- more coherent

That is how this becomes a real OSINT platform and not just another AI-coded app.
