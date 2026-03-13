# VERITAS Build Chunks

## Purpose

This document converts the full VERITAS product roadmap into 10 execution chunks for AI-assisted implementation.

Each chunk includes:

- objective
- scope
- key deliverables
- definition of done
- implementation prompt for coding AIs

These chunks are sequential. They can overlap slightly, but they should generally be executed in order because later chunks depend on earlier system foundations.

The target is not a beta. The target is the finalized production OSINT platform.

---

# Chunk 1: Production Data Foundation

## Objective

Establish the production-grade ingestion and normalization backbone for VERITAS.

## Scope

- create a first-class `Source` model
- normalize and canonicalize source data
- add ingestion tracking
- prepare article lifecycle states
- add DB integrity improvements

## Deliverables

- `Source` model with production-usable metadata
- ingestion tracking models such as `FeedSnapshot` / `IngestionRun`
- canonical URL handling
- article pipeline status fields
- DB indexes for ingestion-heavy queries
- service objects for normalization

## Definition Of Done

- articles can be associated with canonical sources
- source metadata is reusable across the app
- ingestion runs are auditable
- duplicate URL handling is in place
- schema is forward-compatible with multi-source ingestion

## AI Prompt

```text
You are a principal Rails engineer working inside the VERITAS OSINT platform.

Implement Chunk 1: Production Data Foundation.

Context:
- This is a production intelligence platform, not a prototype.
- Maintain clean Rails 8 architecture.
- Prefer explicit domain models over generic JSON storage when the concept is first-class.
- Preserve existing features unless a safer refactor is needed.
- Do not delete unfinished roadmap features.

Your tasks:
1. Introduce a first-class `Source` model with fields suitable for OSINT source intelligence:
   - name
   - canonical_domain
   - country/region association where appropriate
   - source_type
   - ownership
   - political_leaning
   - state_affiliated
   - reliability_tier
   - language
   - active
   - notes
2. Introduce ingestion tracking models such as `FeedSnapshot` and/or `IngestionRun`.
3. Add URL canonicalization support for articles.
4. Add article lifecycle / ingestion status support.
5. Add appropriate indexes and validations for production usage.
6. Extract normalization logic into service objects where needed.
7. Add focused tests for models/services introduced in this chunk.

Constraints:
- Keep migrations clean and production-safe.
- Use `apply_patch` for edits.
- Avoid hacks and unnecessary abstraction.
- If existing schema choices are inconsistent, refactor toward clarity.

Definition of done:
- data model is coherent
- source metadata is queryable
- ingestion tracking exists
- tests pass for the new domain logic

At the end:
- summarize architectural decisions
- list migrations and key files changed
- mention any follow-up gaps that should be handled in Chunk 2
```

---

# Chunk 2: Ingestion Pipeline And Article Extraction

## Objective

Make article ingestion reliable, observable, and safe.

## Scope

- move fetch/parse logic out of controllers
- create ingestion services and jobs
- improve extraction quality
- handle blocked sources and fallbacks
- maintain SSRF-safe fetch behavior

## Deliverables

- `ArticleFetchService`
- `ArticleParseService`
- `ArticleCanonicalizationService`
- `ArticleSanitizationService`
- ingestion job orchestration
- timeout and retry handling
- visible parse/fetch failure tracking

## Definition Of Done

- article content is fetched and parsed outside controllers
- failures are tracked instead of silently buried
- parsing logic is testable
- dangerous fetch targets remain blocked
- the pipeline is production-oriented rather than controller-driven

## AI Prompt

```text
You are a principal Rails engineer working inside VERITAS.

Implement Chunk 2: Ingestion Pipeline And Article Extraction.

Context:
- Article fetch/parse logic must not live in controllers.
- Existing security hardening around SSRF and sanitization must be preserved or improved.
- This system will ingest live intelligence feeds and must be stable under failure.

Your tasks:
1. Extract article fetching, parsing, sanitization, and fallback handling from controllers into dedicated services.
2. Introduce clear service boundaries such as:
   - `ArticleFetchService`
   - `ArticleParseService`
   - `ArticleSanitizationService`
   - `ArticleIngestionOrchestrator` or similar
3. Add explicit timeout handling and robust error classification.
4. Preserve or improve SSRF protection.
5. Track fetch/parse failures in a structured way.
6. Update any controllers/jobs to use the new services.
7. Add focused tests for:
   - valid external fetch paths
   - blocked internal hosts
   - parse fallback behavior
   - sanitization guarantees

Constraints:
- Keep production-safe behavior.
- Do not reintroduce unsafe HTML execution.
- Do not remove current article-view behavior unless replacing it with a better version.
- Prefer composable services over giant orchestrator classes.

Definition of done:
- controller logic is thinner
- ingestion is observable
- services are test-covered
- extraction behavior is more reliable than before

At the end:
- summarize the new ingestion flow
- list key failure states now handled explicitly
```

---

# Chunk 3: Deduplication And Signal Quality

## Objective

Reduce noisy duplicates and improve the quality of the intelligence corpus.

## Scope

- exact duplicate detection
- canonical article selection
- near-duplicate grouping
- semantic duplicate heuristics
- signal quality scoring

## Deliverables

- deduplication service(s)
- canonical article strategy
- duplicate-linking strategy
- quality scoring heuristics
- tests around dedupe and article normalization

## Definition Of Done

- the same article no longer floods the system via multiple URLs/sources
- duplicate logic is transparent and auditable
- downstream AI analysis quality improves because the corpus is cleaner

## AI Prompt

```text
You are a principal Rails engineer working inside VERITAS.

Implement Chunk 3: Deduplication And Signal Quality.

Context:
- VERITAS should not treat every fetched article as a unique signal.
- Duplicate and near-duplicate content degrades trust, clustering, and retrieval quality.

Your tasks:
1. Design and implement a deduplication layer for articles.
2. Support multiple dedupe methods:
   - exact canonical URL duplicate
   - normalized headline duplicate
   - content hash duplicate
   - semantic near-duplicate support where appropriate
3. Introduce a way to identify a canonical article versus duplicates/variants.
4. Preserve useful source diversity when multiple outlets publish the same narrative.
5. Add signal quality heuristics where useful.
6. Add tests for duplicate detection and canonical selection.

Constraints:
- Avoid overengineering.
- Prefer deterministic logic before expensive semantic logic when possible.
- Keep the model understandable for future AI coding sessions.

Definition of done:
- duplicate flooding is materially reduced
- canonical article behavior is clear
- tests protect the dedupe logic

At the end:
- explain how canonical versus duplicate articles are represented
- note tradeoffs or ambiguous cases that still exist
```

---

# Chunk 4: Explainability And Evidence Layer

## Objective

Make VERITAS outputs explainable and defensible.

## Scope

- evidence panels
- trust rationale
- anomaly rationale
- report evidence display
- agent disagreement transparency

## Deliverables

- article evidence panel
- report evidence panel
- clearer display of triad outputs
- confidence and rationale rendering
- tests for safe rendering and explainability structures

## Definition Of Done

- users can understand why the system said what it said
- reports are inspectable
- trust scoring is not a black box

## AI Prompt

```text
You are a principal Rails engineer working inside VERITAS.

Implement Chunk 4: Explainability And Evidence Layer.

Context:
- VERITAS must become a trustworthy OSINT system.
- LLM outputs are not enough by themselves; users need visible evidence and rationale.

Your tasks:
1. Build an evidence panel for article pages.
2. Build an evidence/rationale section for intelligence reports.
3. Expose the triad analysis flow more clearly:
   - Analyst output
   - Sentinel output
   - Arbiter resolution
4. Introduce or formalize confidence fields where necessary.
5. Improve the UI so evidence is readable without overwhelming the user.
6. Keep all rendering safe from XSS / unsafe HTML issues.
7. Add tests covering explainability rendering and any new domain logic.

Constraints:
- Keep the visual language consistent with VERITAS.
- Do not expose raw unsafe provider payloads to end users.
- Prefer high-signal evidence presentation over verbose dumps.

Definition of done:
- article and report pages explain their conclusions
- system confidence is visible
- evidence UI is safe and production-usable

At the end:
- summarize the explainability model
- list any future opportunities for deeper claim-level evidence in Chunk 5
```

---

# Chunk 5: Claims, Contradictions, And Narrative Intelligence

## Objective

Upgrade VERITAS from article summarization to structured intelligence reasoning.

## Scope

- claim extraction
- contradiction detection
- narrative cluster improvements
- origin and propagation logic
- outlier detection improvements

## Deliverables

- `Claim` model or structured claim persistence
- contradiction engine v2
- improved narrative convergence metadata
- cluster evidence improvements
- tests around claims and contradictions

## Definition Of Done

- the system can reason across claims, not just compare article sentiment
- contradictions are more meaningful
- narrative clustering becomes more intelligence-grade

## AI Prompt

```text
You are a principal Rails engineer working inside VERITAS.

Implement Chunk 5: Claims, Contradictions, And Narrative Intelligence.

Context:
- VERITAS should evolve from article-level analysis toward structured intelligence objects.
- Contradiction detection and narrative tracing must become more rigorous.

Your tasks:
1. Introduce structured claim extraction support.
2. Design a `Claim` model or equivalent persistence layer with clear fields.
3. Upgrade contradiction detection beyond simple sentiment/bias mismatch.
4. Improve narrative convergence output so clusters expose:
   - origin
   - spread
   - outliers
   - threat rationale
   - confidence rationale
5. Add tests covering claim extraction structures and contradiction logic.

Constraints:
- Keep the domain model explicit and understandable.
- Do not overpromise perfect truth detection; build auditable heuristics and structures.
- Reuse existing AI pipeline where helpful, but do not let LLM output remain opaque.

Definition of done:
- contradiction engine is stronger
- narrative intelligence is more structured
- claim-level groundwork exists for future entity/event work

At the end:
- explain how claim objects fit into the broader architecture
- list any unresolved ambiguity that should be handled later
```

---

# Chunk 6: Analyst Workflow Core

## Objective

Turn VERITAS into a daily-use analyst workspace.

## Scope

- watchlists v2
- saved searches
- topic dossiers
- notes and annotations
- analyst collections / cases

## Deliverables

- named watchlists
- saved semantic searches
- dossier pages
- annotations system
- analyst collections

## Definition Of Done

- analysts can work inside the platform, not only browse it
- topics can be tracked persistently
- workflow state survives across sessions

## AI Prompt

```text
You are a principal Rails engineer working inside VERITAS.

Implement Chunk 6: Analyst Workflow Core.

Context:
- VERITAS should become an intelligence operating system, not just a feed + search app.
- Users need workflows for tracking, annotating, and organizing intelligence.

Your tasks:
1. Upgrade the current save/watchlist system into richer watchlists where appropriate.
2. Add support for saved searches.
3. Introduce topic dossier pages with reusable intelligence summaries.
4. Introduce analyst notes/annotations on articles and reports.
5. Add analyst collections or case folders for organizing intelligence.
6. Keep the UX coherent and consistent with the VERITAS design language.
7. Add focused tests for the new workflow behaviors.

Constraints:
- Preserve current working features unless replacing them with better structures.
- Prefer explicit user-owned models over temporary session-only behavior.
- Keep workflows efficient and analyst-oriented.

Definition of done:
- users can track topics over time
- users can annotate intelligence
- users can organize intelligence into reusable collections

At the end:
- summarize the new analyst workflow model
- note what should be extended in Chunk 7 for alerts and real-time behavior
```

---

# Chunk 7: Alerts, Notifications, And Real-Time Operations

## Objective

Make VERITAS operationally live.

## Scope

- alert engine
- notification center
- Solid Cable real-time feed updates
- report status streaming
- operational health awareness

## Deliverables

- alert model and generation logic
- in-app notification center
- live feed websocket updates
- live report progress updates
- tests around alert generation and live-state transitions

## Definition Of Done

- important signal changes surface automatically
- users no longer depend only on manual refresh flows
- the system feels live and operational

## AI Prompt

```text
You are a principal Rails engineer working inside VERITAS.

Implement Chunk 7: Alerts, Notifications, And Real-Time Operations.

Context:
- VERITAS should feel like a living intelligence platform.
- Important changes must reach the user automatically.

Your tasks:
1. Introduce an alert engine with meaningful alert types.
2. Add an in-app notification center for alerts.
3. Implement Solid Cable or Action Cable updates for:
   - live intelligence feed updates
   - report progress
   - alert count changes
4. Ensure alert logic is not noisy or spammy by default.
5. Add test coverage around alert generation and state transitions.

Constraints:
- Build for operational usefulness, not gimmicks.
- Prefer a small number of high-signal alert types initially.
- Keep real-time behavior resilient and observable.

Definition of done:
- alerts are generated from meaningful conditions
- users can see and manage notifications
- feed/report state can update live

At the end:
- summarize the live architecture
- note what ops/admin visibility should be expanded in Chunk 10
```

---

# Chunk 8: Perspective System v2

## Objective

Make perspective a first-class intelligence lens across the entire product.

## Scope

- richer perspective model
- source weighting and suppression logic
- perspective compare mode
- perspective-aware reports
- perspective-aware retrieval refinement

## Deliverables

- expanded perspective data model
- compare-mode UX
- perspective-aware reporting paths
- better weighting logic in search/RAG
- tests around perspective behavior

## Definition Of Done

- perspective meaningfully changes outputs
- compare mode becomes a flagship feature
- perspective is no longer just a small retrieval tweak

## AI Prompt

```text
You are a principal Rails engineer working inside VERITAS.

Implement Chunk 8: Perspective System v2.

Context:
- Perspective is one of VERITAS's strongest differentiators.
- It must affect retrieval, ranking, reporting, and comparison behavior in a meaningful way.

Your tasks:
1. Redesign and expand the perspective model beyond simple source keyword matching.
2. Add richer weighting behavior:
   - source weighting
   - source suppression
   - geography weighting
   - narrative weighting where appropriate
3. Build a perspective compare mode.
4. Allow reports and/or chat outputs to run in:
   - neutral mode
   - single perspective mode
   - compare mode
5. Add tests covering perspective behavior and compare outputs.

Constraints:
- Keep the perspective system explainable.
- Do not hide why perspective changes results.
- Preserve existing functionality while deepening it.

Definition of done:
- perspectives visibly and materially change outputs
- compare mode is useful and credible
- perspective logic is test-covered

At the end:
- summarize the perspective model
- list what should later feed directly into the globe/visual system in Chunk 9
```

---

# Chunk 9: Globe, Timeline, And Visual War Room

## Objective

Build the operational visual intelligence layer on top of the real backend.

## Scope

- 3D globe integration
- narrative arcs
- time travel slider
- heatmap overlays
- perspective-aware visual transforms

## Deliverables

- production-integrated globe
- interactive time slider
- live narrative arcs
- region heatmap layers
- click-through into dossiers/articles/reports

## Definition Of Done

- globe is connected to real intelligence data
- users can inspect narrative spread over time
- the visual layer improves understanding instead of only looking cool

## AI Prompt

```text
You are a principal frontend/full-stack engineer working inside VERITAS.

Implement Chunk 9: Globe, Timeline, And Visual War Room.

Context:
- The backend intelligence layer should already be meaningful by this point.
- The globe must visualize real intelligence state, not placeholder data.
- This is a flagship feature and must feel intentional, bold, and analyst-grade.

Your tasks:
1. Integrate the production globe layer using the existing app architecture.
2. Render real article geolocations and narrative arcs.
3. Add the time travel slider for replaying narrative evolution.
4. Add heatmap layers for useful metrics such as:
   - signal density
   - sentiment
   - anomaly density
   - threat activity
5. Make perspective selection affect visual output where appropriate.
6. Ensure interactions lead into real article/report/dossier surfaces.
7. Keep performance acceptable on desktop and usable on mobile.

Constraints:
- Do not fake backend state.
- Preserve the VERITAS visual identity.
- Avoid generic dashboard aesthetics.
- The globe must remain useful under real data conditions.

Definition of done:
- globe is interactive and data-bound
- timeline replay works
- arcs and heatmaps reflect actual backend intelligence

At the end:
- summarize the frontend architecture used
- list any performance tradeoffs or deferred optimizations
```

---

# Chunk 10: Team Intelligence, Ops, And Final Productionization

## Objective

Finish VERITAS as a real production OSINT platform.

## Scope

- shared workspaces
- RBAC polish
- exportable dossiers
- audit logs
- monitoring and ops console
- reliability and failover improvements

## Deliverables

- shared team workspaces
- role-aware permissions
- dossier export
- admin ops/system health console
- audit logging
- provider/queue/system monitoring

## Definition Of Done

- VERITAS is team-usable
- platform health is visible
- operational failures are manageable
- system is ready for serious production presentation and use

## AI Prompt

```text
You are a principal Rails engineer and production systems architect working inside VERITAS.

Implement Chunk 10: Team Intelligence, Ops, And Final Productionization.

Context:
- This chunk finishes VERITAS as a serious OSINT platform.
- The platform should support teams, auditability, exports, and operational observability.

Your tasks:
1. Add shared workspaces / team collaboration structures where appropriate.
2. Review and tighten role-based access behavior across the app.
3. Implement report/dossier export flows.
4. Add audit logging for important user/admin actions.
5. Build an admin/system health console for:
   - ingestion status
   - queue health
   - failed jobs
   - provider status
   - stale pipelines
6. Improve reliability and fallback behavior where needed.
7. Add tests for critical admin/workspace/ops behaviors.

Constraints:
- Do not compromise existing security hardening.
- Build for production maintainability.
- Prefer explicit operational visibility over hidden magic.

Definition of done:
- teams can use the product collaboratively
- system health is visible
- exports exist
- auditability exists
- the app feels production-ready, not prototype-grade

At the end:
- summarize what remains, if anything, before calling VERITAS production-complete
- identify the top residual technical risks
```

---

# Final Guidance For AI Sessions

## Session Pattern

For each chunk, the coding AI should:

1. inspect existing code first
2. identify the minimum coherent architecture change
3. implement end-to-end
4. add tests
5. verify behavior
6. summarize what changed and what remains

## Non-Negotiables

- no unsafe HTML execution
- no fake intelligence data for production features
- no feature without explainability if it affects trust
- no giant controller logic
- no hidden breaking of current working flows
- no deleting roadmap features just because they are unfinished

## Quality Bar

The finished VERITAS platform should feel like:

- an intelligence operating system
- a war room for narrative warfare
- a Palantir-for-the-people style OSINT product

Not:

- a generic AI news wrapper
- a flashy but shallow 3D site
- a demo-only hackathon prototype
