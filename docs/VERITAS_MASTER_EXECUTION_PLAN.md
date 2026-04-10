# VERITAS MASTER EXECUTION PLAN
### Consolidated God's Eye Intelligence Platform Blueprint
### Version 1.0 — 2026-04-10

> **"We cannot stop people from lying on the internet. But with VERITAS, we can make sure they can never hide in the dark again."**

This document is the **single source of truth** for VERITAS development. It replaces:
- `VERITAS_NEXTGEN_AUDIT.md`
- `VERITAS_SUPERIORITY_ROADMAP.md`
- `BEAT_WORLDWIEV_BACKLOG.md`
- `ROADMAP.md`, `product_roadmap.md`, `codex_to_do.md`, `still_todo.md`

All future work is orchestrated from this plan. Each work package is designed to be assignable to an AI coding agent with clear inputs, outputs, and exit criteria.

---

## TABLE OF CONTENTS

1. [Current State Assessment](#1-current-state-assessment)
2. [Target Vision: The God's Eye](#2-target-vision-the-gods-eye)
3. [Phase 0: Critical Bug Fixes & Safety](#3-phase-0-critical-bug-fixes--safety)
4. [Phase 1: Intelligence Graph Foundation](#4-phase-1-intelligence-graph-foundation)
5. [Phase 2: Temporal Engine & 4D Replay](#5-phase-2-temporal-engine--4d-replay)
6. [Phase 3: Globe Architecture Decomposition](#6-phase-3-globe-architecture-decomposition)
7. [Phase 4: Multi-Signal Fusion & Inference](#7-phase-4-multi-signal-fusion--inference)
8. [Phase 5: Sensor Network & Data Sources](#8-phase-5-sensor-network--data-sources)
9. [Phase 6: Operator Console & War Room UX](#9-phase-6-operator-console--war-room-ux)
10. [Phase 7: Autonomous Agents & Predictive Intelligence](#10-phase-7-autonomous-agents--predictive-intelligence)
11. [Phase 8: Platform Hardening & Scale](#11-phase-8-platform-hardening--scale)
12. [Data Source Registry](#12-data-source-registry)
13. [New Database Schema](#13-new-database-schema)
14. [API Contract Specifications](#14-api-contract-specifications)
15. [Definition of Done](#15-definition-of-done)

---

## 1. Current State Assessment

### What VERITAS Already Has (Strengths)
The prototype is visually impressive and already ships more intelligence features than most OSINT tools:

| Feature | Status | Quality |
|---|---|---|
| 3D Globe (Globe.gl + Three.js) | ✅ Live | Hex bins, heatmap, arcs, packets, day/night, thermal |
| 2D Flat Map (D3) | ✅ Live | Equirectangular fallback |
| Perspective Slider | ✅ Live | Source classification by political lens |
| Timeline Scrubber | ✅ Live | Time-range filtering |
| Timelapse Replay | ✅ Live | Cinematic narrative playback |
| AI Triad Analysis | ✅ Live | Analyst (Gemini) + Sentinel (GPT) + Arbiter (Claude) |
| Narrative DNA Panel | ✅ Live | Per-article story decomposition |
| Entity Nexus | ✅ Live | Force-directed entity graph |
| Narrative Routes | ✅ Live | Multi-hop propagation chains |
| Bloom/Chronicle Journeys | ✅ Live | Animated story walkthroughs |
| Contradiction Detection | ✅ Live | Pairwise source conflict tracking |
| Breaking Alerts | ✅ Live | WebSocket push, priority routing |
| Regional Intelligence / Dossiers | ✅ Live | Per-region AI analysis reports |
| AWARE Self-Consciousness | ✅ Live | System introspection dashboard |
| Semantic Search (pgvector) | ✅ Live | Embedding-based article retrieval |
| GDELT Event Integration | ✅ Live | CAMEO-coded conflict events |
| RAG Chat Agent | ✅ Live | Retrieval-augmented geopolitical Q&A |
| Topic Filters | ✅ Live | NATO, BRICS, EU, SANCTIONS, etc. |
| Voice Narration (ElevenLabs) | ✅ Live | TTS system self-narration |
| Tribunal War Room | ✅ Live | Agent debate visualization |

### Critical Gaps (What's Blocking God's Eye Status)

| Gap | Impact | Files Affected |
|---|---|---|
| `globe_controller.js` = 3164 LOC monolith | Unmaintainable, blocks all rendering work | `app/javascript/controllers/globe_controller.js` |
| `pages_controller.rb` = 646 LOC god controller | All API logic in one file | `app/controllers/pages_controller.rb` |
| `threat_level.to_i` on string enums | Silent data corruption in heatmap clusters | `pages_controller.rb:287-293` |
| `[0.0, 0.0]` Null Island fallback | Articles plotted in Gulf of Guinea | `pages_controller.rb:270` |
| CDN runtime dependencies | Globe textures from unpkg.com at runtime | `globe_controller.js:195-197` |
| No intelligence graph | Ad-hoc connection rebuilding per request | `article_network_service.rb` |
| No temporal snapshots | Timeline is "temporal theater" not real replay | No snapshot model exists |
| Keyword-only geolocation | Dictionary lookup, not NLP/NER | `geolocator_service.rb` (337 LOC static data) |
| Raw SQL string interpolation | Injection risk + maintenance burden | `article_network_service.rb`, `narrative_route_generator_service.rb` |
| Single wildcard queue with 3 threads | All jobs compete, no SLO possible | `config/queue.yml` |
| Hardcoded status labels | `ONLINE`/`PENDING` not from real telemetry | `home.html.erb:292-307` |
| 21 test files total | Insufficient for this complexity level | `test/` directory |
| No contract tests | API payload shape can break silently | None exist |
| Old/cheap AI models | `gemini-2.0-flash-001`, `gpt-4o-mini`, `claude-3.5-haiku` | `open_router_client.rb:11-19` |

---

## 2. Target Vision: The God's Eye

VERITAS becomes the **world's first open-source narrative intelligence command center** by mastering four domains that no competitor combines:

### The Four Pillars

```
┌─────────────────────────────────────────────────────────┐
│                    VERITAS GOD'S EYE                    │
├──────────────┬──────────────┬──────────────┬────────────┤
│  PERCEPTION  │  COGNITION   │  PREDICTION  │  CONTROL   │
│              │              │              │            │
│ Multi-source │ Intelligence │ Forecasting  │ Operator   │
│ signal       │ graph with   │ & counter-   │ console    │
│ ingestion    │ fusion       │ factual      │ with real  │
│ from 10+     │ scoring &    │ simulation   │ telemetry  │
│ global data  │ temporal     │ & anomaly    │ & mission  │
│ feeds        │ replay       │ detection    │ workflows  │
└──────────────┴──────────────┴──────────────┴────────────┘
```

### What This Means Concretely

1. **Perception:** Not just NewsAPI. Ingest from GDELT, ACLED, FIRMS fire data, USGS earthquakes, OpenSky aircraft, CelesTrak satellites, social media signals, and Telegram channels — all normalized into a unified signal pipeline.

2. **Cognition:** Every narrative arc, entity link, and threat assessment is stored as a queryable intelligence graph with evidence lineage. Every claim is traceable to raw source data. Multi-signal fusion scoring decomposes why connections exist.

3. **Prediction:** Narrative state machines track story lifecycles (emerging → amplifying → contested → fractured → decaying). Autonomous hunter agents scan for coordinated amplification. Counterfactual simulators let operators ask "what if?"

4. **Control:** Real telemetry replaces fake status labels. Operator modes (Monitor/Investigate/Replay/Brief) shape the UI for the task at hand. Queue SLOs, model performance scorecards, and data freshness meters drive confidence.

---

## 3. Phase 0: Critical Bug Fixes & Safety
**Priority: IMMEDIATE — Do before any new features**

### WP-0.1: Fix Threat Level Data Corruption
**Problem:** `threat_level` is a string enum (`CRITICAL`/`HIGH`/`MODERATE`/`LOW`/`NEGLIGIBLE`) but `pages_controller.rb:287` calls `.to_i` on it, which returns 0 for all string values.

**Files:**
- `app/controllers/pages_controller.rb:287-293` (heatmap clusters avg_threat)
- `app/controllers/pages_controller.rb:293` (sort by threat_level.to_i)
- `app/controllers/pages_controller.rb:314` (heatmap weight uses .to_f)

**Fix:** Create `AiAnalysis#threat_numeric` helper that maps strings to numbers:
```ruby
# app/models/ai_analysis.rb
THREAT_SEVERITY = {
  "CRITICAL" => 10, "HIGH" => 8, "MODERATE" => 5,
  "LOW" => 2, "NEGLIGIBLE" => 1
}.freeze

def threat_numeric
  THREAT_SEVERITY[threat_level.to_s.upcase] || threat_level.to_i.clamp(0, 10)
end
```
Replace every `threat_level.to_i` and `threat_level.to_f` call site with `threat_numeric`.

**Exit Criteria:** Zero `.to_i` or `.to_f` calls on `threat_level` outside the model helper. RSpec test proving string enums produce correct numeric values.

---

### WP-0.2: Kill Null Island
**Problem:** `pages_controller.rb:270` falls back to `[0.0, 0.0]` for unknown countries, plotting them in the Gulf of Guinea.

**Files:**
- `app/controllers/pages_controller.rb:270`
- `app/services/geolocator_service.rb:294-298`

**Fix:**
- `GeolocatorService` already returns `nil` for unresolved — good.
- In `pages_controller.rb`, replace `country_coordinates[c.iso_code] || [0.0, 0.0]` with a skip or explicit unknown marker.
- Add `geo_confidence` field to articles: `high` (NER), `medium` (keyword), `low` (source_fallback), `none` (unresolved).
- Client-side: render unknown-geo articles in a special "Unlocated Signals" sidebar section instead of on the map.

**Exit Criteria:** Zero `[0.0, 0.0]` coordinates in globe_data API response. Unresolved articles are visible in UI but not plotted at origin.

---

### WP-0.3: Pin CDN Assets Locally
**Problem:** Globe textures and world boundaries load from `unpkg.com` and `jsdelivr.net` at runtime. CDN outage = broken globe.

**Files:**
- `app/javascript/controllers/globe_controller.js:195-197` (earth textures)
- `app/javascript/controllers/flat_map_controller.js:90-105` (world boundaries)

**Fix:**
- Download and save to `public/assets/globe/`:
  - `earth-blue-marble.jpg`
  - `earth-topology.png`
  - `earth-night.jpg`
  - `night-sky.png`
  - `world-110m.json` (world boundaries)
- Update all references to use local paths.

**Exit Criteria:** Zero runtime CDN dependencies for core visualization. Globe renders fully offline.

---

### WP-0.4: Parameterize Raw SQL
**Problem:** Multiple services use string interpolation in SQL queries — injection risk and maintenance liability.

**Files:**
- `app/services/article_network_service.rb:293-306, 340-354, 384-402, 501-524`
- `app/services/narrative_route_generator_service.rb:79-110`
- `app/controllers/pages_controller.rb:395-404` (entity_nexus_detail)

**Fix:** Replace all `"... #{variable} ..."` SQL with parameterized queries using `sanitize_sql_array` or Arel.

**Exit Criteria:** Zero instances of string interpolation inside SQL query strings.

---

### WP-0.5: Comprehensive Country Centroids Table
**Problem:** `pages_controller.rb:246-257` hardcodes coordinates for only 10 countries.

**Fix:**
- Create `db/data/country_centroids.json` with all ~250 ISO 3166-1 alpha-3 codes + lat/lng centroids.
- Load into `countries` table via migration adding `centroid_lat` and `centroid_lng` columns.
- Replace inline hash with `country.centroid_lat, country.centroid_lng`.

**Exit Criteria:** All countries have centroid coordinates. Hardcoded coordinate hash removed.

---

### WP-0.6: Upgrade AI Models
**Problem:** Current model defaults are dated and cheap, capping analytical depth.

**Files:** `app/services/open_router_client.rb:11-29`

**Fix:** Upgrade default models:
```ruby
DEFAULT_MODELS = {
  analyst:          "google/gemini-2.5-flash",
  sentinel:         "openai/gpt-4.1-mini",
  arbiter:          "anthropic/claude-3.7-sonnet",
  briefing:         "anthropic/claude-3.7-sonnet",
  voice:            "anthropic/claude-3.5-haiku",
  entity_extractor: "google/gemini-2.5-flash",
  relevance_filter: "google/gemini-2.5-flash",
  hunter:           "openai/gpt-4.1",
  forecaster:       "anthropic/claude-3.7-sonnet"
}
```
Increase `MAX_TOKENS` for analyst/arbiter to at least 1200.

**Exit Criteria:** All agent roles use current-generation models. Token budgets are sufficient for analytical depth.

---

## 4. Phase 1: Intelligence Graph Foundation
**The backbone that enables everything else.**

### WP-1.1: Intel Graph Schema
Create explicit graph primitives that replace ad-hoc connection rebuilding:

```ruby
# Migration: create_intel_nodes
create_table :intel_nodes do |t|
  t.string   :node_type, null: false  # article, event, entity, source, narrative_cluster, region, claim
  t.bigint   :source_record_id        # FK to the source table (articles.id, entities.id, etc.)
  t.string   :source_record_type      # Polymorphic type
  t.string   :label                   # Human-readable label
  t.jsonb    :properties, default: {} # Extensible metadata
  t.float    :latitude
  t.float    :longitude
  t.datetime :observed_at             # When this node was first observed
  t.timestamps
end
add_index :intel_nodes, [:source_record_type, :source_record_id], unique: true
add_index :intel_nodes, :node_type

# Migration: create_intel_edges
create_table :intel_edges do |t|
  t.bigint   :source_node_id, null: false
  t.bigint   :target_node_id, null: false
  t.string   :edge_type, null: false  # propagates, contradicts, corroborates, mentions,
                                       # semantic_similar, shares_entity, shares_event,
                                       # geospatial_coincidence, temporal_causality, amplifies
  t.float    :weight, default: 0.0    # Combined strength score
  t.float    :confidence, default: 0.0
  t.jsonb    :score_decomposition, default: {}  # { semantic: 0.8, temporal: 0.6, entity: 0.3 }
  t.jsonb    :metadata, default: {}
  t.datetime :first_seen_at
  t.datetime :last_seen_at
  t.timestamps
end
add_index :intel_edges, [:source_node_id, :target_node_id, :edge_type], unique: true, name: 'idx_intel_edges_unique'
add_index :intel_edges, :edge_type
add_index :intel_edges, :weight

# Migration: create_edge_evidence
create_table :edge_evidence do |t|
  t.references :intel_edge, null: false, foreign_key: true
  t.string     :evidence_type    # model_verdict, snippet, embedding_score, cameo_match, entity_overlap
  t.text       :content          # The actual evidence text/value
  t.string     :provider         # gemini, gpt, claude, pgvector, gdelt
  t.float      :confidence
  t.jsonb      :raw_output, default: {}
  t.timestamps
end
```

### WP-1.2: Graph Compiler Service
**New file:** `app/services/intel_graph_compiler_service.rb`

Responsibilities:
- On article ingest: create `intel_node` for article, link to entities, country, region
- On analysis complete: create edges based on semantic similarity, shared entities, narrative overlap
- On GDELT match: create `shares_event` edges
- On contradiction detection: create `contradicts` edges with evidence
- Replace `ArticleNetworkService#connections_between` with graph reads

### WP-1.3: Graph Query Service
**New file:** `app/services/intel_graph_query_service.rb`

Endpoints powered by graph:
- `network_for_article(article)` — subgraph around article
- `connections_between(articles)` — edges between article set
- `path_explain(edge_id)` — evidence decomposition for an edge
- `influence_paths(node_id)` — top causal pathways from/to a node
- `blast_radius(narrative_cluster_id)` — how far a narrative propagated

### WP-1.4: Backfill Job
**New file:** `app/jobs/backfill_intel_graph_job.rb`
Process all existing articles, entities, contradictions, and narrative arcs into the graph.

**Phase 1 Exit Criteria:**
- All existing connections served from graph reads
- ArticleNetworkService refactored to use graph (under 400 LOC)
- `/api/article_network` response includes `score_decomposition` per edge
- Graph has > 90% of existing articles as nodes

---

## 5. Phase 2: Temporal Engine & 4D Replay
**True time travel, not just filtering by date.**

### WP-2.1: Scene Snapshot Schema
```ruby
create_table :scene_snapshots do |t|
  t.datetime   :snapshot_at, null: false
  t.string     :snapshot_type, default: 'auto' # auto, manual, milestone
  t.string     :perspective                    # 'all' or a specific lens slug
  t.jsonb      :graph_state, default: {}       # Serialized graph projection
  t.jsonb      :stats, default: {}             # Article count, edge count, threat distribution
  t.integer    :node_count
  t.integer    :edge_count
  t.timestamps
end
add_index :scene_snapshots, :snapshot_at

create_table :scene_deltas do |t|
  t.references :from_snapshot, foreign_key: { to_table: :scene_snapshots }
  t.references :to_snapshot, foreign_key: { to_table: :scene_snapshots }
  t.jsonb      :added_nodes, default: []
  t.jsonb      :removed_nodes, default: []
  t.jsonb      :added_edges, default: []
  t.jsonb      :removed_edges, default: []
  t.jsonb      :modified_edges, default: []
  t.timestamps
end
```

### WP-2.2: Snapshot Engine Service
**New file:** `app/services/scene_snapshot_service.rb`
- `capture!(time: Time.current)` — freeze current graph state into snapshot
- `delta_between(from:, to:)` — compute what changed
- `at(time:, perspective:)` — return the nearest snapshot, optionally lens-transformed

### WP-2.3: Scheduled Snapshot Job
**New file:** `app/jobs/capture_scene_snapshot_job.rb`
- Runs every 30 minutes via Solid Queue recurring
- Also triggered after major ingestion batches (> 20 new articles)

### WP-2.4: Scene Replay API
**New endpoints:**
- `GET /api/v2/scene/:snapshot_id` — full scene from snapshot
- `GET /api/v2/scene/at?time=<iso8601>` — nearest snapshot to time
- `GET /api/v2/delta?from=<id>&to=<id>` — delta payload between snapshots
- `GET /api/v2/timeline` — list of available snapshots with stats

### WP-2.5: Timeline Controller Integration
Refactor `timeline_controller.js` + `globe_controller.js` timeline handling to:
- Request scene snapshots instead of re-filtering articles by date
- Show snapshot-based markers on the timeline scrubber
- Enable deterministic frame-by-frame playback

**Phase 2 Exit Criteria:**
- Timeline scrubber steps through real snapshots
- Timelapse mode animates snapshot deltas (deterministic playback)
- Same timestamp always produces same scene (reproducible)
- `/api/v2/scene/:id` response time < 200ms for cached snapshots

---

## 6. Phase 3: Globe Architecture Decomposition
**Split the 3164-LOC monster into composable modules.**

### WP-3.1: Scene Engine Module
**New file:** `app/javascript/globe/scene_engine.js`
- Globe initialization (Globe.gl setup, textures, lighting, atmosphere)
- Camera controls (autoRotate, zoom limits, point-of-view)
- Day/night mode switching
- Resize handling

### WP-3.2: Data Layer Manager
**New file:** `app/javascript/globe/data_layer_manager.js`
- Hex bin point layer management
- Heatmap layer management
- Arc layer management
- Ring layer management
- Packet animation management
- Layer visibility toggling

### WP-3.3: Overlay Engine
**New file:** `app/javascript/globe/overlay_engine.js`
- Uncertainty fog layer (confidence-based opacity)
- Contradiction lightning layer (animated bursts between conflicting nodes)
- Source influence vectors (directional indicators)
- Temporal wavefronts (expanding circles showing story spread speed)
- Entity convoy trails (highlighted paths of entity movement)

### WP-3.4: Interaction Engine
**New file:** `app/javascript/globe/interaction_engine.js`
- Hex hover/click handlers
- Arc hover/click handlers
- Fly-to animations
- Heatmap tooltip management
- Route choice menu
- Context menu system

### WP-3.5: Network Mode Engine
**New file:** `app/javascript/globe/network_mode_engine.js`
- Network view state management
- Article-centric subgraph rendering
- Search-mode graph rendering
- Back-to-global transitions

### WP-3.6: Perspective Engine
**New file:** `app/javascript/globe/perspective_engine.js`
- Perspective color transformations
- Per-lens opacity/visibility rules
- Differential rendering (highlight what changes between lenses)

### WP-3.7: Timeline Replay Engine
**New file:** `app/javascript/globe/timeline_replay_engine.js`
- Snapshot loading from `/api/v2/scene/:id`
- Delta application and animation
- Frame-by-frame stepping
- Timelapse playback state machine

### WP-3.8: Refactored Globe Controller
`globe_controller.js` becomes a thin orchestrator (~300-500 LOC):
- Imports and initializes all modules
- Routes events to correct module
- Manages WebSocket subscription
- Handles connect/disconnect lifecycle

**Phase 3 Exit Criteria:**
- `globe_controller.js` < 500 LOC
- Each module independently testable
- Zero functionality regression from existing globe features
- WebGL performance budget: maintain 30+ FPS with 500 points and 100 arcs

---

## 7. Phase 4: Multi-Signal Fusion & Inference
**The intelligence layer that makes VERITAS decision-grade.**

### WP-4.1: Multi-Signal Fusion Scoring Engine
**New file:** `app/services/fusion_scoring_service.rb`

For each `intel_edge`, compute and store component scores:
```ruby
{
  semantic_score:        0.0..1.0,  # Embedding cosine similarity
  temporal_score:        0.0..1.0,  # Published within same time window
  entity_overlap_score:  0.0..1.0,  # Shared named entities
  event_coreference:     0.0..1.0,  # GDELT/CAMEO event overlap
  source_credibility:    0.0..1.0,  # Source reliability weight
  geographic_proximity:  0.0..1.0,  # How close geographically
  framing_similarity:    0.0..1.0,  # Similar framing/angle
  contradiction_penalty: -1.0..0.0  # Penalty for contradicting evidence
}
```
Final `combined_strength` = weighted sum with configurable weights.
Store full decomposition in `intel_edges.score_decomposition`.

### WP-4.2: Narrative State Machine
**New file:** `app/services/narrative_lifecycle_service.rb`

Per narrative cluster, manage lifecycle states:
```
EMERGING -> AMPLIFYING -> CONTESTED -> FRACTURED -> DECAYING -> DORMANT -> REACTIVATED
```

Transitions driven by:
- **Signal velocity:** New articles per hour mentioning this cluster
- **Contradiction pressure:** % of edges that are contradictions
- **Source diversity:** Number of unique sources/countries
- **Geographic spread:** Number of unique regions
- **Entity involvement:** Power-weighted entity participation

**New model:** `NarrativeCluster` with `lifecycle_state` and `state_history` (jsonb log)

### WP-4.3: Contradiction Engine v2
**Upgrade from:** Pairwise article comparison
**Upgrade to:** Claim-level contradiction graph

```ruby
create_table :claims do |t|
  t.references :article, foreign_key: true
  t.text       :claim_text
  t.string     :claim_type       # fact, opinion, attribution, prediction
  t.jsonb      :entities, default: []
  t.vector     :embedding, limit: 1536
  t.float      :confidence
  t.timestamps
end

create_table :claim_conflicts do |t|
  t.references :claim_a, foreign_key: { to_table: :claims }
  t.references :claim_b, foreign_key: { to_table: :claims }
  t.string     :conflict_type  # direct_contradiction, temporal_inconsistency,
                                # magnitude_disagreement, attribution_conflict
  t.float      :severity
  t.text       :explanation
  t.jsonb      :blast_radius, default: {}
  t.timestamps
end
```

### WP-4.4: Lens Simulation Engine
**New file:** `app/services/lens_simulation_service.rb`

Perspective slider upgrade from simple source filtering to cognitive simulation:
- For each lens (US Democrat, US Republican, China, Russia, EU, etc.)
- Generate transformed storyline: which articles gain prominence? Which fade?
- Show "differential map": What changes when switching from Lens A to Lens B?
- Compute "narrative distance" between lenses on same topic

**New endpoint:** `GET /api/v2/lens_diff?from=us_democrat&to=china&topic=trade_war`

### WP-4.5: Agentic Triangulation v2
**Upgrade from:** 3 agents producing independent verdicts
**Upgrade to:** Multi-model voting + adversarial challenge

New pipeline:
1. 3+ models analyze independently
2. Compare outputs, identify disagreement zones
3. Adversarial challenger agent probes weaknesses in majority position
4. Confidence intervals computed across all outputs
5. Auto-rerun triggered when signals conflict significantly
6. Model performance scorecards stored per topic/domain for calibration

**New model:** `agent_verdicts` table tracking per-model accuracy over time

**Phase 4 Exit Criteria:**
- Every edge in the network has visible score decomposition
- Narrative clusters have lifecycle states visible on the globe
- Claim-level contradictions surfaced in UI with blast radius visualization
- Lens switching shows differential highlighting

---

## 8. Phase 5: Sensor Network & Data Sources
**From news-only to true multi-source intelligence fusion.**

### WP-5.1: Unified Data Source Architecture
**New file:** `app/services/data_sources/base_connector.rb`

Standard interface for all data sources:
```ruby
class DataSources::BaseConnector
  def fetch_latest(since:)        # Pull new data since timestamp
  def normalize(raw_data)          # Normalize to unified signal format
  def signal_type                  # :news, :event, :disaster, :military, :satellite, :social
  def provider_name                # Human-readable name
  def rate_limit_status            # Remaining quota
  def health_check                 # Is the source reachable?
end
```

### WP-5.2: News Sources (Enhanced)
- **NewsAPI** (existing, enhanced) — `app/services/data_sources/news_api_connector.rb`
- **GDELT** (existing, enhanced) — `app/services/data_sources/gdelt_connector.rb`
- **MediaStack** (NEW) — Broader international coverage
- **NewsCatcher** (NEW) — Topic-focused news aggregation

### WP-5.3: Conflict & Crisis Sources
- **ACLED** (Armed Conflict Location & Event Data) — Real-time conflict tracking globally
- **GDELT GKG** (Global Knowledge Graph) — Enhanced GDELT with themes, persons, orgs, tone
- **ReliefWeb/OCHA** — Humanitarian crisis and disaster alerts
- **ICG CrisisWatch** — International Crisis Group monthly conflict monitoring

### WP-5.4: Environmental & Disaster Sources
- **NASA FIRMS** — Active fire hotspots globally
  - Endpoint: `https://firms.modaps.eosdis.nasa.gov/api/area/`
  - Connector: `app/services/data_sources/firms_connector.rb`
- **USGS Earthquake** — Real-time seismic events
  - Endpoint: `https://earthquake.usgs.gov/earthquakes/feed/v1.0/`
  - Connector: `app/services/data_sources/usgs_earthquake_connector.rb`
- **EONET** (NASA Earth Observatory) — Natural events (volcanoes, floods, storms)

### WP-5.5: Aviation & Maritime
- **OpenSky Network** — Live aircraft positions worldwide
  - Endpoint: `https://opensky-network.org/api/states/all`
  - Connector: `app/services/data_sources/opensky_connector.rb`
  - Intelligence value: Military aircraft movements, unusual patterns, airspace closures
- **AIS/Marine Traffic** — Ship tracking (strategic/military vessels near conflict zones)

### WP-5.6: Satellite & Space
- **CelesTrak** — Satellite orbit data (TLE) for reconnaissance/military satellite tracking
  - Endpoint: `https://celestrak.org/NORAD/elements/`
  - Connector: `app/services/data_sources/celestrak_connector.rb`
- **Sentinel Hub** — Satellite imagery change detection (before/after events)

### WP-5.7: Social & Alternative Sources
- **Telegram Channels** (existing, enhanced) — Conflict zone firsthand reporting
- **Reddit/Twitter Firehose** (via PushShift or Brandwatch) — Public sentiment tracking

### WP-5.8: Economic & Financial Indicators
- **FRED** (Federal Reserve Economic Data) — Economic indicators affecting geopolitics
- **World Bank Open Data** — Development indicators, trade data
- **Sanctions Lists** (OFAC, EU, UN) — Track entities under sanctions

### WP-5.9: Unified Signal Model
All data sources normalize to a common `Signal` model:
```ruby
create_table :signals do |t|
  t.string     :signal_type, null: false    # news, conflict, disaster, aviation, satellite, social, economic
  t.string     :provider, null: false       # newsapi, gdelt, acled, firms, usgs, opensky, celestrak
  t.string     :provider_id                 # Source-specific unique ID
  t.text       :title
  t.text       :content
  t.float      :latitude
  t.float      :longitude
  t.float      :geo_confidence
  t.string     :geo_method
  t.float      :severity                    # 0-10 normalized severity
  t.float      :confidence                  # Provider confidence
  t.jsonb      :raw_data, default: {}
  t.jsonb      :entities, default: []
  t.jsonb      :metadata, default: {}
  t.vector     :embedding, limit: 1536
  t.datetime   :observed_at
  t.timestamps
end
add_index :signals, [:provider, :provider_id], unique: true
add_index :signals, :signal_type
add_index :signals, :observed_at
```

### WP-5.10: Provider Health Dashboard
Track per-source:
- Last successful fetch timestamp
- Total signals ingested (24h / 7d / all-time)
- Error rate and last error
- Rate limit remaining
- Data freshness (time since newest signal)

**Phase 5 Exit Criteria:**
- At least 5 distinct data source types active
- All sources normalize to Signal model
- Provider health visible in operator dashboard
- New signals auto-create intel_nodes and trigger graph edge computation

---

## 9. Phase 6: Operator Console & War Room UX
**From dashboard theater to operator-grade control surface.**

### WP-6.1: Operator Mode System
Four distinct operating modes:

| Mode | Purpose | UI Changes |
|---|---|---|
| **MONITOR** | Live situational awareness | Full globe, streaming updates, alert priority, minimal panels |
| **INVESTIGATE** | Deep-dive specific topic/region | Focused globe, expanded network panel, evidence sidebar, RAG chat |
| **REPLAY** | Forensic timeline analysis | Snapshot-driven globe, frame controls, evidence timeline, comparisons |
| **BRIEF** | Executive summary generation | Minimal globe, full-width report panel, AI briefing, export options |

### WP-6.2: Live Telemetry System
Replace all hardcoded status labels with real telemetry:

**New service:** `app/services/system_telemetry_service.rb`
```ruby
class SystemTelemetryService
  def self.snapshot
    {
      websocket: { status: cable_status, connections: connection_count },
      queue:     { status: queue_status, pending: pending_jobs, lag_seconds: queue_lag },
      data_feed: { status: feed_status, last_ingest: last_article_time, articles_24h: recent_count },
      ai_layer:  { status: ai_status, analyses_24h: analysis_count, avg_latency_ms: avg_latency },
      database:  { status: "NOMINAL", articles: article_count, entities: entity_count, edges: edge_count }
    }
  end
end
```

**New endpoint:** `GET /api/v2/telemetry` — polled every 10s by UI
**New channel:** `SystemTelemetryChannel` — push critical status changes

### WP-6.3: Advanced Visual Overlay Layers

| Layer | Visual | Data Source |
|---|---|---|
| Uncertainty Fog | Semi-transparent fog over low-confidence regions | `geo_confidence` field |
| Contradiction Lightning | Animated electric arcs between conflicting stories | `claim_conflicts` table |
| Source Influence Vectors | Directional arrows showing narrative flow | `intel_edges` propagates type |
| Temporal Wavefronts | Expanding circles showing story spread speed | Timestamp deltas |
| Entity Convoy Trails | Highlighted paths showing entity movement | Entity mentions over time |
| Narrative Tension Heatmap | Heat overlay based on contradiction density | Claim conflicts per region |
| Prediction Confidence Bands | Uncertainty bands around predicted trajectories | Forecast intervals |

### WP-6.4: Alert System v2
Upgrade from simple breaking alerts to priority-based alert triage:

```ruby
create_table :intelligence_alerts do |t|
  t.string     :alert_type       # breaking, anomaly, contradiction_burst, narrative_shift,
                                   # coordinated_amplification, prediction_triggered,
                                   # source_degradation, entity_emergence
  t.string     :severity          # critical, high, moderate, informational
  t.string     :title
  t.text       :description
  t.jsonb      :evidence, default: []
  t.jsonb      :affected_entities, default: []
  t.jsonb      :affected_regions, default: []
  t.float      :confidence
  t.string     :status, default: 'active'  # active, acknowledged, dismissed, resolved
  t.bigint     :acknowledged_by
  t.datetime   :acknowledged_at
  t.timestamps
end
```

### WP-6.5: Mission Replay Workbench
For any event or query:
- Ingest all related signals across all sources
- Align to unified timeline
- Auto-build replay package with annotations
- Export forensic bundle (JSON + media references + verdict trail + evidence chain)

### WP-6.6: War Room Tactical Display
For "INVESTIGATE" mode:
- Split-screen: Globe + Evidence Timeline side by side
- Draggable entity cards pinned to investigation board
- "Red string" mode: manually draw connections between pinned evidence
- AI-assisted "What am I missing?" suggestions

### WP-6.7: View Decomposition
Split `home.html.erb` (428 LOC) into partials:
- `_globe_section.html.erb`
- `_left_sidebar.html.erb`
- `_right_sidebar_threat.html.erb`
- `_right_sidebar_status.html.erb`
- `_right_sidebar_analysis.html.erb`
- `_timeline_bar.html.erb`
- `_mobile_tabs.html.erb`

### WP-6.8: Controller Decomposition
Split `pages_controller.rb` (646 LOC) into:
- `GlobeDataController` — globe_data endpoint
- `ArticleNetworkController` — article_network endpoint
- `EntityNexusController` — entity_nexus endpoints
- `TribunalController` — tribunal endpoint
- `NarrativeDnaController` — narrative_dna endpoint
- `TelemetryController` — system telemetry endpoint
- `SceneController` — snapshot/delta/replay endpoints

**Phase 6 Exit Criteria:**
- 4 operator modes switchable via UI
- All status labels driven by real telemetry
- `pages_controller.rb` < 150 LOC
- `home.html.erb` < 80 LOC
- At least 3 new visual overlay layers on globe
- Alert triage system operational

---

## 10. Phase 7: Autonomous Agents & Predictive Intelligence
**The "beyond God's Eye" features.**

### WP-7.1: Autonomous Hunter Agents
Persistent background agents scanning for:

| Hunter Type | What It Detects | Trigger |
|---|---|---|
| **Coordinated Amplification** | Multiple near-identical framing within tight window | > 3 sources, > 80% similarity, < 4h |
| **Narrative Anomaly** | Sudden spike in dormant topic | > 5x baseline velocity |
| **Source Behavior Shift** | Source dramatically changing editorial position | Drift > 2 sigma from baseline |
| **Entity Emergence** | New entity appearing across multiple stories | > 5 articles in 24h, zero prior |
| **Contradiction Burst** | Surge in conflicting claims about same event | > 3 contradictions in < 6h |
| **Geographic Anomaly** | Unusual signal concentration in quiet region | > 3 sigma deviation |

**New models:** `HunterAgent` and `HunterFinding` with evidence, severity, affected entities/regions

### WP-7.2: Counterfactual Narrative Simulator
Let operators ask "what if?" questions:
- "What if Source X had not amplified this story?" — Remove source, recompute propagation
- "What if this event had happened 48h earlier?" — Time-shift, show alternative cascade
- "Amplify signal Z by 2x" — See how network topology changes
- "What if lens=Russia vs lens=US?" — Side-by-side differential view

**New service:** `app/services/counterfactual_simulator_service.rb`

### WP-7.3: Influence Path Attribution
For each major narrative shift:
- Top 5 causal pathways
- Pivotal nodes (highest betweenness centrality)
- Confidence bounds on each attribution
- Visualize as Sankey diagram or flow visualization

### WP-7.4: Predictive Intelligence Engine
Use historical pattern matching + AI to predict:
- **Narrative trajectory:** Where is this story heading?
- **Escalation probability:** Based on Goldstein scores + media tone shifts
- **Source behavior:** Will this source amplify or suppress?
- **Geographic spread:** Which regions will this story reach next?

**New model:** `Prediction` with `prediction_type`, `target`, `probability`, `horizon`, `outcome`

### WP-7.5: Geopolitical Risk Index
Composite real-time index per region/country:
- Weighted combination of: conflict events, media sentiment, narrative lifecycle states, entity tensions, economic indicators, contradiction density
- Historical trending
- Cross-region comparison
- Alert threshold triggers

**Phase 7 Exit Criteria:**
- At least 3 hunter agent types running autonomously
- Counterfactual simulator produces visible graph changes
- Predictions generated with tracked accuracy
- Risk index visible per region on globe and sidebar

---

## 11. Phase 8: Platform Hardening & Scale
**Production-grade reliability.**

### WP-8.1: Queue Segmentation
```yaml
production:
  workers:
    - queues: [ingest]
      threads: 2
    - queues: [enrich, embeddings]
      threads: 3
    - queues: [graph, snapshot]
      threads: 2
    - queues: [analysis, hunter]
      threads: 2
    - queues: [alerts, broadcast]
      threads: 1
    - queues: [default, backfill]
      threads: 2
```

### WP-8.2: Event-Driven Pipeline
```
signal.ingested -> signal.normalized -> signal.enriched ->
graph.node.created -> graph.edge.computed -> snapshot.delta.applied ->
scene.updated -> websocket.broadcast
```

### WP-8.3: Streaming Contract (Typed WebSocket Messages)
All WS messages follow:
```ruby
{ type: "scene.delta.applied" | "signal.ingested" | "alert.raised" |
        "cluster.state_changed" | "telemetry.snapshot" | "hunter.finding",
  payload: { ... }, timestamp: "iso8601", version: 2 }
```

### WP-8.4: Observability Stack
- OpenTelemetry tracing
- Structured JSON logging
- Per-endpoint p95/p99 dashboards
- Queue lag per workload class
- AI model cost/latency/error dashboards
- Data freshness per source
- Cache hit rates
- Graph size and query performance

### WP-8.5: Test Strategy Upgrade

| Test Type | Tool | Covers |
|---|---|---|
| Model specs | RSpec | All models |
| Service specs | RSpec | All services, especially graph + fusion |
| API contract tests | RSpec + JSON Schema | All `/api` endpoints |
| Controller specs | RSpec | Request specs |
| Channel specs | RSpec | WebSocket behavior |
| JS integration | Playwright | Globe, search, network, modes |
| Replay determinism | Custom | Same inputs = same snapshot |
| Load tests | k6 | Concurrent users |

### WP-8.6: Security Audit
- Channel authentication
- CSRF protection
- SQL injection (should be clean after WP-0.4)
- API rate limiting
- CSP headers

### WP-8.7: Deployment Optimization
- Asset compilation and fingerprinting
- DB connection pooling
- Redis cache for snapshot serving
- CDN for static assets
- Heroku dyno optimization

**Phase 8 Exit Criteria:**
- Segmented queues with SLOs: ingest < 30s, analysis < 120s, broadcast < 5s
- OpenTelemetry traces for all critical paths
- 80%+ test coverage on changed code
- System responsive under 50 concurrent users + 100 articles/hour ingestion

---

## 12. Data Source Registry

| Source | Type | Frequency | Status | Priority |
|---|---|---|---|---|
| NewsAPI | News | 30min | ✅ Active | P0 |
| GDELT Events | Conflict | 15min | ✅ Active | P0 |
| GDELT GKG | Knowledge | 15min | Planned | P1 |
| ACLED | Conflict | Daily | Planned | P1 |
| NASA FIRMS | Fire | 6h | Planned | P2 |
| USGS Earthquake | Seismic | 5min | Planned | P2 |
| OpenSky | Aircraft | 60s | Planned | P2 |
| CelesTrak | Satellites | Daily | Planned | P3 |
| ReliefWeb | Humanitarian | 6h | Planned | P2 |
| Telegram | Social/OSINT | Real-time | Partial | P1 |
| MediaStack | News | 30min | Planned | P2 |
| Sentinel Hub | Imagery | On-demand | Planned | P3 |
| FRED | Economic | Daily | Planned | P3 |
| Sanctions Lists | Compliance | Weekly | Planned | P3 |

---

## 13. New Database Schema Summary

```
Phase 0: countries (+ centroid_lat, centroid_lng)
         articles (+ geo_confidence)

Phase 1: intel_nodes
         intel_edges
         edge_evidence

Phase 2: scene_snapshots
         scene_deltas

Phase 4: narrative_clusters (+ lifecycle_state, state_history)
         claims
         claim_conflicts
         agent_verdicts

Phase 5: signals
         data_source_health

Phase 6: intelligence_alerts
         operator_sessions

Phase 7: hunter_agents
         hunter_findings
         predictions
         risk_indices
```

---

## 14. API Contract Specifications

### Existing APIs (contract-test):
- `GET /api/globe_data`
- `GET /api/article_network/:id`
- `GET /api/narrative_dna/:id`
- `GET /api/entity_nexus`
- `GET /api/tribunal/:id`

### New v2 APIs:
- `GET /api/v2/scene/:snapshot_id`
- `GET /api/v2/scene/at?time=<iso>`
- `GET /api/v2/delta?from=:id&to=:id`
- `GET /api/v2/timeline`
- `GET /api/v2/graph/path_explain/:edge_id`
- `GET /api/v2/graph/influence/:node_id`
- `GET /api/v2/graph/blast_radius/:cluster_id`
- `GET /api/v2/lens_diff?from=&to=&topic=`
- `GET /api/v2/telemetry`
- `GET /api/v2/alerts`
- `GET /api/v2/risk_index/:region`
- `GET /api/v2/predictions`
- `GET /api/v2/hunters`
- `POST /api/v2/counterfactual`

---

## 15. Definition of Done

### Code Quality Gates
- [ ] `globe_controller.js` < 500 LOC
- [ ] `pages_controller.rb` < 150 LOC
- [ ] `article_network_service.rb` < 400 LOC, zero raw SQL interpolation
- [ ] `geolocator_service.rb` replaced with NER-based pipeline
- [ ] `home.html.erb` < 80 LOC
- [ ] Zero runtime CDN dependencies for core assets
- [ ] Zero `.to_i` on threat_level outside normalization helper
- [ ] Zero `[0.0, 0.0]` coordinate fallbacks

### Data Quality Gates
- [ ] All countries have centroid coordinates
- [ ] Geo confidence tracked per article
- [ ] < 5% unresolved geolocation rate
- [ ] All intel edges have score decomposition

### Performance Gates
- [ ] Globe data p95 < 200ms (cached)
- [ ] Scene snapshot p95 < 100ms
- [ ] Network graph build p95 < 1s
- [ ] WebSocket broadcast p95 < 500ms
- [ ] Timelapse: smooth 30+ FPS
- [ ] Ingest queue lag p95 < 30s

### Intelligence Gates
- [ ] Every edge has evidence trace + score breakdown
- [ ] Narrative clusters have lifecycle states
- [ ] At least 3 hunter agent types running
- [ ] Predictions with tracked accuracy
- [ ] Lens switching shows visible differential

### Reliability Gates
- [ ] Segmented queues with SLOs
- [ ] OpenTelemetry tracing operational
- [ ] 80%+ test coverage on changed code
- [ ] API contract tests for all endpoints
- [ ] Replay determinism tests passing

---

## Execution Order

```
PHASE 0 --- Bug Fixes & Safety ---------------------- [Foundation]
   |
PHASE 1 --- Intelligence Graph ---------------------- [Data Backbone]
   |
PHASE 2 --- Temporal Engine ------------------------- [4D Replay]
   |
   +-- PHASE 3 -- Globe Decomposition --------------- [Frontend Arch]
   |        (parallel with Phase 4)
   |
   +-- PHASE 4 -- Fusion & Inference ---------------- [Intelligence]
   |        (parallel with Phase 3)
   |
PHASE 5 --- Sensor Network ------------------------- [Data Expansion]
   |
PHASE 6 --- Operator Console ----------------------- [UX Revolution]
   |
PHASE 7 --- Autonomous Agents & Prediction --------- [God's Eye Brain]
   |
PHASE 8 --- Hardening & Scale --------------------- [Production Grade]
```

> Phases 3 & 4 run in parallel (frontend vs backend).

---

## AI Orchestrator Notes

Each **WP (Work Package)** is designed to be:
1. **Self-contained** — clear inputs, outputs, and affected files
2. **Testable** — each WP has exit criteria that can be verified
3. **Assignable** — an AI coding agent can execute a WP independently
4. **Ordered** — dependencies between WPs are explicit

When assigning to an AI agent, provide:
- The WP description from this document
- List of affected files (for context loading)
- Exit criteria (for self-verification)
- Any dependency WPs that must be complete first

---

> *"The differentiator is not visuals. It is trustworthy intelligence mechanics: reproducible timeline truth, explainable fusion scores, and operator-grade control of uncertainty. That is the God's Eye."*
