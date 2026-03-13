# VERITAS Product Roadmap

## Mission

VERITAS is not a news reader and not a dashboard toy.

It is a production OSINT platform for narrative warfare analysis:

- detect how narratives are shaped
- trace how they spread
- compare how they mutate across perspectives
- surface contradictions and anomalies
- help analysts understand what is true, what is coordinated, and what is being amplified

This roadmap is written for AI-assisted implementation teams. It is intentionally concrete and execution-oriented.

---

## Product Standard

The target is not “good enough for demo”.

The target is:

- trustworthy outputs
- explainable intelligence
- robust ingestion
- usable analyst workflows
- real-time operational behavior
- cinematic but meaningful visualization

Every feature should be judged against 5 production criteria:

1. Is it accurate enough to trust?
2. Is it explainable enough to defend?
3. Is it stable enough to operate?
4. Is it fast enough to use live?
5. Does it improve analyst decisions?

If a feature is only visually impressive but not operationally useful, it is secondary.

---

## Core Product Pillars

### 1. Source Ingestion

The platform must reliably acquire, normalize, deduplicate, enrich, and store intelligence signals.

### 2. Intelligence Engine

The platform must analyze content, score trust, detect anomalies, cluster narratives, and generate explainable briefings.

### 3. Analyst Workflow

The platform must support daily OSINT work:

- search
- compare
- track
- annotate
- alert
- dossier creation

### 4. Real-Time Operations

The platform must behave like a live system:

- fresh signals
- changing threat states
- streaming updates
- monitored jobs

### 5. Visual Intelligence Layer

The globe, heatmaps, timelines, arcs, and lensing system should make intelligence patterns visible, not decorative.

---

## High-Level Build Sequence

The best build order is:

1. Data + ingestion reliability
2. Trust + explainability
3. Analyst workflows
4. Alerts + live operations
5. Perspective system deepening
6. Globe + visual war room integration
7. Team collaboration + exports + ops polish

Do not reverse this order.

---

## Phase 1: Production Data Foundation

### Objective

Make VERITAS capable of ingesting and managing intelligence-grade article data reliably.

### Outcome

At the end of this phase, the system should be able to:

- ingest from one or more feeds repeatedly
- normalize and enrich articles
- avoid duplicates
- track ingestion status
- recover from failures
- provide high-quality content to downstream analysis jobs

### Must-Build Features

#### 1.1 Source Registry

Add a first-class `Source` model.

Recommended fields:

- `name`
- `canonical_domain`
- `country_id`
- `region_id`
- `source_type`
  - mainstream
  - state
  - state_affiliated
  - independent
  - think_tank
  - blog
  - unknown
- `ownership`
- `political_leaning`
- `state_affiliated`
- `reliability_tier`
  - very_high
  - high
  - mixed
  - low
  - unknown
- `language`
- `active`
- `notes`

Purpose:

- source trust profiles
- perspective weighting
- filtering
- analytics

#### 1.2 Feed Snapshot / Ingestion Tracking

Introduce ingestion tracking tables.

Suggested models:

- `FeedSnapshot`
- `IngestionRun`
- `IngestionFailure`

Track:

- source
- query/topic
- fetch timestamp
- item count
- API/raw status
- parse success/failure
- duplicate count
- created article count
- failed article count
- duration

Purpose:

- observability
- debugging
- quality monitoring

#### 1.3 URL Canonicalization

Normalize URLs before persistence.

Needed behaviors:

- strip tracking params like `utm_*`
- normalize host casing
- normalize trailing slash behavior
- collapse duplicate canonical URLs
- detect same article across variant URLs

#### 1.4 Duplicate Detection

Implement multi-layer deduplication:

- exact URL duplicate
- near-exact headline duplicate
- content hash duplicate
- semantic duplicate via embedding similarity

Recommended output:

- keep one canonical article
- store links to duplicate/related variants
- preserve source diversity for same narrative

#### 1.5 Article Extraction Service

Move article scraping/parsing out of controller code into dedicated services.

Suggested services:

- `ArticleFetchService`
- `ArticleParseService`
- `ArticleSanitizationService`
- `ArticleCanonicalizationService`

Requirements:

- explicit timeouts
- SSRF protection
- safe HTML sanitization
- image extraction
- fallback to feed summary if fetch blocked
- parse status tracking

#### 1.6 Ingestion Status Lifecycle

Every article should have a pipeline state.

Recommended statuses:

- `discovered`
- `fetched`
- `parsed`
- `enriched`
- `analyzed`
- `embedded`
- `clustered`
- `failed`

Purpose:

- job orchestration
- retry handling
- admin visibility

### Phase 1 Engineering Tasks

- add `Source` model and migrations
- add ingestion tracking models
- extract fetch/parse code from controllers
- add DB indexes for URLs, sources, timestamps
- add dedupe rules
- add ingestion jobs and retries
- add tests for parser safety and canonicalization

### Phase 1 Success Criteria

- new articles enter system reliably
- duplicates are reduced dramatically
- failed parsing is visible and recoverable
- article content quality is materially better
- source metadata becomes usable across the product

---

## Phase 2: Trust, Explainability, and Analysis Credibility

### Objective

Make VERITAS outputs defendable, inspectable, and genuinely useful for serious analysis.

### Outcome

At the end of this phase, analysts should understand:

- why the system scored trust a certain way
- why a narrative cluster exists
- why a regional report reached its conclusion
- where AI agents agree or disagree

### Must-Build Features

#### 2.1 Evidence Panels

Every article page should have an evidence panel.

Include:

- source metadata
- source reliability profile
- trust score explanation
- anomaly explanation
- sentiment reasoning
- related sources
- contradiction candidates

#### 2.2 Agent Disagreement View

Expose the internal triad reasoning.

Show:

- Analyst output
- Sentinel output
- Arbiter decision
- areas of agreement
- areas of disagreement
- final synthesis

Purpose:

- analyst trust
- QA
- model debugging

#### 2.3 Confidence Framework

Separate confidence from trust.

Recommended fields:

- `source_trust_score`
- `analysis_confidence`
- `cluster_confidence`
- `report_confidence`
- `timeline_confidence`

These should not be conflated.

#### 2.4 Structured Claim Extraction

Extract claims from article content.

Suggested `Claim` fields:

- `article_id`
- `statement`
- `subject`
- `predicate`
- `object`
- `claim_type`
- `certainty`
- `evidence_level`
- `disputed`
- `supporting_article_ids`
- `contradicting_article_ids`

Purpose:

- contradiction detection
- claim comparison
- event synthesis

#### 2.5 Contradiction Engine v2

The current contradiction logic is useful but still simple.

Upgrade it to include:

- claim-level contradiction
- framing contradiction
- sentiment contradiction
- omission/silence mismatch
- source credibility weighting

#### 2.6 Narrative Cluster Explainability

Each convergence cluster should expose:

- origin article
- earliest seen timestamp
- propagation window
- participating sources
- countries involved
- common themes
- outliers
- threat rationale
- confidence rationale

### Phase 2 Engineering Tasks

- extend `AiAnalysis`
- add `Claim` model or structured JSON layer
- build agent comparison UI
- persist confidence values
- improve contradiction logic
- add tests for explainability rendering and data integrity

### Phase 2 Success Criteria

- analysts can inspect evidence behind system conclusions
- reports become reviewable and defensible
- contradictions are more meaningful
- trust in the platform materially increases

---

## Phase 3: Analyst Workflow Platform

### Objective

Turn VERITAS into a daily-use intelligence operating system.

### Outcome

Users should be able to work inside VERITAS, not just look at it.

### Must-Build Features

#### 3.1 Watchlists v2

Upgrade current saved article/watchlist logic into analyst-grade tracking.

Support:

- named watchlists
- multiple watchlists per user
- topic watchlists
- entity watchlists
- narrative watchlists
- alert preferences per watchlist

#### 3.2 Topic Dossiers

Introduce persistent dossier pages for tracked themes.

Examples:

- Ukraine grain exports
- Taiwan chip diplomacy
- AI regulation war
- election interference in Romania

Dossier should show:

- executive summary
- latest signals
- timeline
- cluster map
- contradictions
- top sources
- perspective comparison
- notes

#### 3.3 Entity Tracking

Add first-class `Entity` support.

Examples:

- politicians
- ministries
- companies
- militias
- outlets

Capabilities:

- entity pages
- entity-related signals
- co-occurrence graph
- sentiment over time
- region spread

#### 3.4 Annotations and Analyst Notes

Users should be able to add:

- notes on articles
- notes on reports
- notes on dossiers
- manual tags
- analyst judgments

Recommended tags:

- propaganda
- escalation
- economic pressure
- election manipulation
- cyber activity
- strategic ambiguity
- likely coordination

#### 3.5 Saved Searches

Allow users to save semantic and structured searches.

Good examples:

- “maritime escalation in South China Sea”
- “NATO troop framing”
- “energy sabotage narratives”

#### 3.6 Workspace / Case Collections

Users should be able to create collections of relevant intelligence objects.

A collection should support:

- title
- description
- linked articles
- linked dossiers
- linked entities
- linked reports
- notes

### Phase 3 Engineering Tasks

- add watchlist domain models
- add dossier pages and controllers
- add entity extraction pipeline
- add annotation system
- add saved-search system
- add user workflow tests

### Phase 3 Success Criteria

- analysts can track ongoing topics
- analysts can build reusable intelligence collections
- VERITAS becomes a work environment, not just a visualization

---

## Phase 4: Alerts, Real-Time Intelligence, and Operational Awareness

### Objective

Make the platform operationally alive.

### Outcome

Users should receive meaningful signal changes without manually refreshing pages or re-querying constantly.

### Must-Build Features

#### 4.1 Alert Engine

Add a rule-based and event-based alerting system.

Alert types:

- narrative spike
- threat escalation
- watchlist resurfacing
- contradiction spike
- outlier emergence
- perspective divergence spike
- source anomaly

#### 4.2 Notification Center

Create an in-app notification center.

Include:

- unread count
- priority levels
- link to source evidence
- mark read/unread
- filter by alert type

#### 4.3 Solid Cable Real-Time Feed

Implement real-time dashboard updates.

Live feed should:

- stream in new signals
- show status changes
- update report progress
- update alert counts
- update narrative clusters when recalculated

#### 4.4 Operational Status Console

Build an internal system health view.

Show:

- ingestion health
- queue size
- failed jobs
- stale pipelines
- provider/API status
- last successful feed sync

#### 4.5 Narrative Shift Detection

Detect not just quantity spikes, but framing changes.

Examples:

- from neutral to alarmist
- from local framing to geopolitical framing
- from humanitarian frame to military frame

### Phase 4 Engineering Tasks

- alert domain model
- alert generation jobs
- websocket channels for feed/report/alert updates
- queue health monitoring
- admin/system dashboard
- real-time UI updates

### Phase 4 Success Criteria

- users see intelligence movement in near real time
- alerts feel meaningful, not noisy
- platform health is observable

---

## Phase 5: Perspective System Deepening

### Objective

Make perspective a first-class intelligence lens across the whole platform.

### Outcome

Perspective should meaningfully alter what the platform shows, not just mildly change retrieval.

### Must-Build Features

#### 5.1 Perspective Model Expansion

Current perspective filters are too simple.

Expand them with:

- source preferences
- source penalties
- geographic weighting
- sentiment weighting
- narrative priority weighting
- ideology profile
- rhetoric profile

#### 5.2 Perspective Compare Mode

This should become a headline feature.

Compare two perspectives and show:

- shared narrative
- diverging emphasis
- suppressed coverage
- different threat framing
- source overlap
- claim overlap

#### 5.3 Perspective-Aware Reports

Allow reports to be generated:

- neutral
- perspective-specific
- compare-mode

#### 5.4 Perspective-Aware Globe / Heatmap

When the globe is implemented, perspective should alter:

- arc intensity
- region glow
- active hotspots
- contradiction highlights
- source emphasis

#### 5.5 Perspective Drift Analysis

Track how a perspective’s framing on a topic changes over time.

This is a major differentiator.

### Phase 5 Engineering Tasks

- redesign perspective model
- expand retrieval weighting logic
- add compare-mode UI
- integrate perspective into report and cluster generation
- add tests for perspective-specific behavior

### Phase 5 Success Criteria

- perspective becomes a core VERITAS capability
- compare mode becomes a standout feature
- outputs feel materially different under different lenses

---

## Phase 6: Globe, Visual War Room, and Narrative Propagation

### Objective

Build the cinematic visual layer on top of a trustworthy intelligence backend.

### Outcome

The globe should visualize intelligence patterns meaningfully:

- where a narrative starts
- where it spreads
- where it mutates
- where contradictions appear
- where sentiment shifts

### Must-Build Features

#### 6.1 Globe Core

Build the 3D globe with real data bindings.

Display:

- article geolocations
- narrative arcs
- heatmap overlays
- cluster hotspots
- report regions

#### 6.2 Time Travel Slider

Replay intelligence evolution over time.

Capabilities:

- scrub by hour/day/week
- animate arcs over time
- show narrative emergence and spread
- compare snapshots

#### 6.3 Bias / Sentiment Heatmap

Map regional narrative behavior.

Good dimensions:

- sentiment
- threat framing
- source volume
- contradiction density
- anomaly density

#### 6.4 Narrative Arc Propagation

Visualize probable path:

- origin source/country
- relay sources
- downstream pickup
- mutation points

#### 6.5 Globe Interaction

User should be able to:

- click regions
- filter by topic
- filter by perspective
- filter by source type
- select time windows
- open dossier from globe node

### Phase 6 Engineering Tasks

- Three.js / Globe.gl integration
- real data adapter layer
- timeline state management
- performance optimization
- mobile fallback behavior

### Phase 6 Success Criteria

- globe is operationally useful
- visuals reflect actual backend intelligence state
- time travel becomes a real analysis tool

---

## Phase 7: Team Intelligence, Collaboration, and Production Ops

### Objective

Make VERITAS usable by teams under pressure.

### Outcome

The product should support collaboration, auditability, and exportability.

### Must-Build Features

#### 7.1 Shared Workspaces

Team-level spaces with shared:

- watchlists
- dossiers
- notes
- collections
- alerts

#### 7.2 Role-Based Access

Support roles such as:

- admin
- analyst
- reviewer
- viewer

#### 7.3 Report Export

Allow export to:

- PDF dossier
- shareable internal link
- print view

#### 7.4 Audit Log

Track:

- admin changes
- source configuration edits
- analyst annotations
- alert rule changes
- report generation actions

#### 7.5 Reliability + Monitoring

Production quality requires:

- provider health monitoring
- error tracking
- queue monitoring
- job retry metrics
- stale pipeline alerts
- API rate limit handling

### Phase 7 Engineering Tasks

- team/workspace models
- access control audit
- export system
- admin ops console
- logging and monitoring integration

### Phase 7 Success Criteria

- product can support multiple serious users
- operational risk is controlled
- collaboration becomes possible

---

## Intelligence Objects To Add Over Time

These models or conceptual objects will make VERITAS stronger:

- `Source`
- `Claim`
- `Entity`
- `Event`
- `TopicDossier`
- `Watchlist`
- `Alert`
- `FeedSnapshot`
- `IngestionRun`
- `SourceProfile`
- `NarrativeCluster`
- `AnalystNote`
- `Workspace`

These are more valuable long-term than adding random UI widgets.

---

## UI Surfaces That Should Exist

Recommended product pages / views:

- War Room Dashboard
- Article Intelligence Page
- Topic Dossier Page
- Narrative Cluster Page
- Region Intelligence Page
- Entity Page
- Perspective Compare Page
- Alert Center
- Watchlists
- Analyst Collections
- Admin Ops Console
- System Health Panel

---

## AI Implementation Guidance

This section is specifically for AI coding workflows.

### Rule 1

Do not add visually impressive features before the underlying intelligence object exists.

Bad:

- adding a fancy heatmap with fake data

Good:

- first define how anomaly density is measured
- then render the heatmap

### Rule 2

Prefer explicit data models over hidden JSON blobs when the concept matters product-wise.

Bad:

- storing every intelligence concept inside one generic text or JSON field

Good:

- introducing clear models and fields for core concepts

### Rule 3

Every AI-generated conclusion must have:

- source basis
- confidence
- fallback behavior
- failure state

### Rule 4

For every major intelligence feature, implement:

1. domain logic
2. persistence
3. UI surface
4. tests
5. explainability

### Rule 5

Do not let “AI magic” replace system design.

LLMs should synthesize, compare, and summarize.
They should not be the only source of truth.

---

## Suggested Sprint Sequence

## Sprint 1

Production ingestion foundation

- Source model
- ingestion tracking
- canonicalization
- dedupe
- article extraction service
- DB integrity improvements

## Sprint 2

Explainability layer

- evidence panels
- agent disagreement view
- confidence framework
- trust rationale

## Sprint 3

Analyst workflow core

- watchlists v2
- saved searches
- annotations
- collections
- topic dossiers

## Sprint 4

Alerts + real-time operations

- alert engine
- notification center
- Solid Cable live updates
- ops console

## Sprint 5

Perspective deepening

- richer perspective model
- compare mode
- perspective-aware reports

## Sprint 6

Globe integration

- globe core
- time slider
- narrative arcs
- heatmap overlays

## Sprint 7

Team/product maturity

- workspaces
- exports
- audit logs
- production monitoring

---

## Immediate Next Build Recommendations

If implementation resumes now, start here:

1. Add DB unique index for saved article integrity
2. Introduce `Source` model and source normalization
3. Extract article fetch/parse into dedicated services
4. Add ingestion status tracking
5. Build evidence panel for article pages
6. Add tests around ingestion + analysis pipeline

That sequence gives the highest leverage.

---

## What Makes VERITAS Win

VERITAS wins if it becomes:

- more explainable than generic AI tools
- more operational than a typical news dashboard
- more usable than a pure research prototype
- more visually intuitive than legacy OSINT software

The winning combination is:

- trust
- clarity
- speed
- perspective intelligence
- cinematic usability

That is the path to “a Palantir for the people”.
