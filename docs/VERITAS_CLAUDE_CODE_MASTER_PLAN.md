# VERITAS — Claude Code/Antigravity Master Execution Plan
### Version 1.0 — 2026-04-10
### Status: PENDING REVIEW (read instructions below before doing anything)

---

## HOW TO USE THIS DOCUMENT

You are Claude Code, a senior level master coder and architect working on the VERITAS Intelligence Platform.

**Before you write a single line of code, follow these steps in order:**

### Step 1: Read Context
```
Read your CLAUDE.md file in the project root.
Read this entire document.
```

### Step 2: Self-Review
Evaluate this plan critically. Think about:
- Does the phasing make sense given what you see in the actual codebase?
- Are there dependencies between work packages that aren't captured?
- Are the exit criteria realistic and testable?
- Would you reorder anything based on the current code?
- Are there quick wins or risks the plan misses?

Write your review into a file called `docs/PLAN_REVIEW.md` with:
- Your assessment of each block
- Any suggested changes to ordering or scope
- Risks or concerns you see
- Your recommended first 3 work packages to tackle

### Step 3: Save Your Working Plan
After review, create `docs/ACTIVE_ROADMAP.md` with your finalized task list. This becomes your single source of truth for what to do next. Update it after completing each work package.

### Step 4: Branch Strategy
For each work package:
```bash
git checkout -b wp/<work-package-id>   # e.g. wp/0.1-threat-level-fix
# ... do the work ...
git add -A
git commit -m "WP-0.1: Fix threat level data corruption"
git push origin wp/0.1-threat-level-fix
git checkout main
```
Keep commits focused. One WP = one branch = one PR-ready unit.

### Step 5: Execute Block by Block
Only start the next block when all exit criteria for the current block are met. After each work package, update `docs/ACTIVE_ROADMAP.md` with status.

---

## PROJECT CONTEXT

VERITAS is a geospatial narrative intelligence platform. 3D globe, multi-source news ingestion, AI-powered analysis (3-model triangulation), narrative propagation tracking, entity networks, and real-time WebSocket updates.

**Stack:** Rails 8, PostgreSQL + pgvector, Solid Queue/Cable, Globe.gl/Three.js, D3, OpenRouter multi-model AI pipeline.

**Repo:** `olivertilke/veritas_intelligence`

**The goal of this plan:** Transform VERITAS from a strong visual prototype into an operator-grade intelligence command center. We're adding sensor data layers (flights, fires, earthquakes, satellites), building a real intelligence graph, decomposing the monolithic frontend, and upgrading the UX to command-center quality.

**Cost constraint:** All new data sources and APIs must be 100% free. No paid tiers, no trials-that-expire. OpenRouter usage stays within existing budget.
**BIGQUERY SAFETY CONSTRAINT (CRITICAL):** The existing GDELT integration uses Google BigQuery. Any modifications to BigQuery queries or the `GdeltBigQueryService` MUST strictly adhere to the 3-Tier Safety System (see `GDELT_UPGRADE_PLAN.md`). A single unbounded query can scan terabytes of data and incur massive costs. Never remove `_PARTITIONTIME` filters, never remove `LIMIT` clauses, and ensure the app-side byte counter limit is respected.

---

## BLOCK 1: CHIRURGIE — Code Foundation
**Goal:** Fix critical bugs, decompose monoliths, make the codebase agent-friendly.
**Why first:** Every subsequent block will be 10x easier with clean, modular code. An AI agent working on a 200-LOC module is dramatically more accurate than one working inside a 3164-LOC blob.

---

### WP-0.1: Fix Threat Level Data Corruption
**Problem:** `threat_level` is a string enum (`CRITICAL`/`HIGH`/`MODERATE`/`LOW`/`NEGLIGIBLE`) but code calls `.to_i` on it, which returns 0 for all strings. Silent data corruption in heatmap clusters.

**Files to inspect:**
- `app/controllers/pages_controller.rb` — look for `threat_level.to_i` and `threat_level.to_f`
- `app/models/ai_analysis.rb` — threat_level field definition

**Fix:**
1. Add `threat_numeric` helper to `AiAnalysis`:
```ruby
THREAT_SEVERITY = {
  "CRITICAL" => 10, "HIGH" => 8, "MODERATE" => 5,
  "LOW" => 2, "NEGLIGIBLE" => 1
}.freeze

def threat_numeric
  THREAT_SEVERITY[threat_level.to_s.upcase] || 0
end
```
2. Replace every `.to_i` / `.to_f` call on `threat_level` with `threat_numeric`.

**Exit criteria:**
- [ ] Zero `.to_i` or `.to_f` calls on `threat_level` outside the model helper
- [ ] Test proving string enums produce correct numeric values

---

### WP-0.2: Kill Null Island
**Problem:** Unknown countries fall back to `[0.0, 0.0]`, plotting articles in the Gulf of Guinea.

**Files to inspect:**
- `app/controllers/pages_controller.rb` — look for `[0.0, 0.0]` fallback in globe_data
- `app/services/geolocator_service.rb`

**Fix:**
1. Replace `[0.0, 0.0]` fallback with `nil` / skip
2. Add `geo_confidence` field to articles: `high`, `medium`, `low`, `none`
3. Unresolved articles should be excluded from map points but visible in a sidebar count or "Unlocated Signals" indicator

**Exit criteria:**
- [ ] Zero `[0.0, 0.0]` coordinates in globe_data API response
- [ ] Unresolved articles not plotted on map

---

### WP-0.3: Pin CDN Assets Locally
**Problem:** Globe textures and world boundaries load from `unpkg.com` and `jsdelivr.net` at runtime. CDN outage = broken globe.

**Files to inspect:**
- `app/javascript/controllers/globe_controller.js` — earth texture URLs
- `app/javascript/controllers/flat_map_controller.js` — world boundary URLs

**Fix:**
1. Download assets to `public/assets/globe/`: earth-blue-marble.jpg, earth-topology.png, earth-night.jpg, night-sky.png, world-110m.json
2. Update all references to local paths

**Exit criteria:**
- [ ] Zero runtime CDN dependencies for core visualization assets
- [ ] Globe renders fully with no external network requests for textures

---

### WP-0.4: Parameterize Raw SQL
**Problem:** Multiple services use string interpolation (`"... #{variable} ..."`) in SQL queries. Injection risk + maintenance burden.

**Files to inspect:**
- `app/services/article_network_service.rb` — multiple raw SQL blocks
- `app/services/narrative_route_generator_service.rb` — pgvector queries
- `app/controllers/pages_controller.rb` — entity_nexus_detail

**Fix:** Replace all string-interpolated SQL with `sanitize_sql_array` or Arel parameterized queries.

**Exit criteria:**
- [ ] Zero instances of `#{variable}` inside SQL query strings in services and controllers

---

### WP-0.5: Country Centroids Table
**Problem:** `pages_controller.rb` hardcodes coordinates for only ~10 countries.

**Fix:**
1. Create `db/data/country_centroids.json` with all ~250 ISO 3166-1 alpha-3 codes + lat/lng centroids (source: public domain datasets)
2. Add migration: `countries` table with `iso_code`, `name`, `centroid_lat`, `centroid_lng`
3. Seed from JSON file
4. Replace hardcoded coordinate hash in pages_controller with DB lookup

**Exit criteria:**
- [ ] All countries have centroid coordinates in DB
- [ ] Hardcoded coordinate hash removed from controller

---

### WP-3.1–3.8: Globe Controller Decomposition
**Problem:** `globe_controller.js` is ~3164 LOC — a monolith owning scene setup, data layers, overlays, interactions, network mode, search mode, timeline, and event cleanup.

**Target structure:**
```
app/javascript/globe/
├── scene_engine.js          # Globe.gl init, textures, camera, day/night, resize
├── data_layer_manager.js    # Hex bins, heatmap, arcs, rings, packets, layer toggling
├── overlay_engine.js        # Future overlay layers (uncertainty fog, etc.)
├── interaction_engine.js    # Click/hover handlers, fly-to, tooltips, context menus
├── network_mode_engine.js   # Article-centric subgraph, search-mode graph, transitions
├── perspective_engine.js    # Perspective color transforms, per-lens visibility
├── timeline_replay_engine.js # Timeline/timelapse state machine (prep for Phase 2 snapshots)
└── globe_controller.js      # Thin orchestrator: imports modules, routes events, manages WS
```

**Approach:**
- Extract one module at a time, starting with `scene_engine.js` (lowest risk)
- After each extraction, verify zero functionality regression
- `globe_controller.js` becomes a thin orchestrator < 500 LOC

**Exit criteria:**
- [ ] `globe_controller.js` < 500 LOC
- [ ] Each module is a self-contained ES module with clear imports/exports
- [ ] All existing globe features still work (hex bins, heatmap, arcs, search, network, timelapse, perspectives)
- [ ] No global `window.` event listeners outside the orchestrator

---

### WP-6.7: View Decomposition
**Problem:** `home.html.erb` is ~428 LOC of inline styles, hardcoded status labels, and mixed concerns.

**Target:**
```
app/views/pages/
├── home.html.erb            # < 80 LOC shell that renders partials
├── _globe_section.html.erb
├── _left_sidebar.html.erb
├── _right_sidebar_threat.html.erb
├── _right_sidebar_status.html.erb
├── _right_sidebar_analysis.html.erb
├── _timeline_bar.html.erb
└── _mobile_tabs.html.erb
```

**Exit criteria:**
- [ ] `home.html.erb` < 80 LOC
- [ ] All UI sections render correctly from partials

---

### WP-6.8: Controller Decomposition
**Problem:** `pages_controller.rb` is ~646 LOC handling all API endpoints.

**Target:**
```
app/controllers/
├── pages_controller.rb           # Only home action, < 50 LOC
├── api/globe_data_controller.rb  # /api/globe_data
├── api/article_network_controller.rb
├── api/entity_nexus_controller.rb
├── api/tribunal_controller.rb
├── api/narrative_dna_controller.rb
└── api/search_controller.rb
```

**Exit criteria:**
- [ ] `pages_controller.rb` < 150 LOC
- [ ] Each API endpoint in its own controller
- [ ] All routes updated, zero broken endpoints

---

### Block 1 Exit Criteria (ALL must pass):
- [ ] Zero threat_level.to_i outside model helper
- [ ] Zero [0.0, 0.0] coordinate fallbacks
- [ ] Zero CDN runtime dependencies for globe assets
- [ ] Zero raw SQL string interpolation in services
- [ ] globe_controller.js < 500 LOC
- [ ] pages_controller.rb < 150 LOC
- [ ] home.html.erb < 80 LOC
- [ ] All existing features still working

---

## BLOCK 2: INTELLIGENCE GRAPH
**Goal:** Replace ad-hoc connection rebuilding with a real queryable graph.
**Depends on:** Block 1 complete.

---

### WP-1.1: Intel Graph Schema
Create the graph data model:

```ruby
# intel_nodes — vertices
create_table :intel_nodes do |t|
  t.string   :node_type, null: false  # article, event, entity, source, narrative_cluster, region, claim
  t.bigint   :source_record_id
  t.string   :source_record_type      # Polymorphic
  t.string   :label
  t.jsonb    :properties, default: {}
  t.float    :latitude
  t.float    :longitude
  t.datetime :observed_at
  t.timestamps
end
add_index :intel_nodes, [:source_record_type, :source_record_id], unique: true
add_index :intel_nodes, :node_type

# intel_edges — edges with evidence
create_table :intel_edges do |t|
  t.bigint   :source_node_id, null: false
  t.bigint   :target_node_id, null: false
  t.string   :edge_type, null: false  # propagates, contradicts, corroborates, mentions,
                                       # semantic_similar, shares_entity, shares_event
  t.float    :weight, default: 0.0
  t.float    :confidence, default: 0.0
  t.jsonb    :score_decomposition, default: {}
  t.jsonb    :metadata, default: {}
  t.datetime :first_seen_at
  t.datetime :last_seen_at
  t.timestamps
end
add_index :intel_edges, [:source_node_id, :target_node_id, :edge_type], unique: true, name: 'idx_intel_edges_unique'

# edge_evidence — why an edge exists
create_table :edge_evidence do |t|
  t.references :intel_edge, null: false, foreign_key: true
  t.string     :evidence_type    # model_verdict, embedding_score, entity_overlap, cameo_match
  t.text       :content
  t.string     :provider         # gemini, gpt, claude, pgvector, gdelt
  t.float      :confidence
  t.jsonb      :raw_output, default: {}
  t.timestamps
end
```

**Exit criteria:**
- [ ] Migration runs cleanly
- [ ] Models created with proper associations and validations

---

### WP-1.2: Graph Compiler Service
**New file:** `app/services/intel_graph_compiler_service.rb`

This service runs after article ingestion and analysis to populate the graph:
- On article ingest: create `intel_node` for article, link to entities, country, region
- On analysis complete: create edges (semantic similarity, shared entities, narrative overlap)
- On GDELT match: create `shares_event` edges
- On contradiction detection: create `contradicts` edges with evidence

---

### WP-1.3: Graph Query Service
**New file:** `app/services/intel_graph_query_service.rb`

Query methods:
- `network_for_article(article)` — subgraph around an article
- `connections_between(articles)` — edges between article set
- `path_explain(edge_id)` — evidence decomposition for edge

---

### WP-1.4: Refactor ArticleNetworkService
Refactor `ArticleNetworkService` to read from the graph instead of rebuilding connections from scratch. Target: < 400 LOC, zero raw SQL.

---

### WP-1.5: Backfill Job
**New file:** `app/jobs/backfill_intel_graph_job.rb`
Process all existing articles, entities, contradictions, and narrative arcs into the graph.

---

### Block 2 Exit Criteria:
- [ ] All existing connections served from graph reads
- [ ] ArticleNetworkService < 400 LOC, zero raw SQL interpolation
- [ ] `/api/article_network` response includes `score_decomposition` per edge
- [ ] Graph has > 90% of existing articles as nodes

---

## BLOCK 3: SENSOR NETWORK — Free Sources Only
**Goal:** Multi-source intelligence fusion. Flights, fires, earthquakes, satellites on the globe.
**Depends on:** Block 1 complete. Can run parallel with Block 2.
**Constraint:** 100% free APIs only.

---

### WP-5.1: Base Connector Architecture
**New file:** `app/services/data_sources/base_connector.rb`

```ruby
module DataSources
  class BaseConnector
    def fetch_latest(since:)        # Pull new data since timestamp
      raise NotImplementedError
    end

    def normalize(raw_data)          # Normalize to unified Signal format
      raise NotImplementedError
    end

    def signal_type                  # :news, :event, :disaster, :aviation, :satellite
      raise NotImplementedError
    end

    def provider_name
      raise NotImplementedError
    end

    def rate_limit_status
      raise NotImplementedError
    end

    def health_check
      raise NotImplementedError
    end
  end
end
```

---

### WP-5.9: Unified Signal Model
All external data normalizes to this:

```ruby
create_table :signals do |t|
  t.string     :signal_type, null: false    # news, conflict, disaster, aviation, satellite
  t.string     :provider, null: false       # newsapi, gdelt, acled, firms, usgs, opensky, celestrak
  t.string     :provider_id
  t.text       :title
  t.text       :content
  t.float      :latitude
  t.float      :longitude
  t.float      :geo_confidence
  t.string     :geo_method
  t.float      :severity                    # 0-10 normalized
  t.jsonb      :raw_data, default: {}
  t.jsonb      :metadata, default: {}
  t.datetime   :observed_at
  t.timestamps
end
add_index :signals, [:provider, :provider_id], unique: true
add_index :signals, :signal_type
add_index :signals, :observed_at
```

---

### WP-5.S1: OpenSky Network Connector (🥇 Priority)
**The jaw-dropper.** Live aircraft positions on the globe.

- **API:** `https://opensky-network.org/api/states/all` — free, anonymous (10s rate limit), registered (5s)
- **New file:** `app/services/data_sources/opensky_connector.rb`
- **New job:** `app/jobs/fetch_opensky_job.rb` — runs every 60s via Solid Queue recurring
- **Globe integration:** New aircraft layer in `data_layer_manager.js` — small plane icons moving in real-time
- **Intelligence value:** Military aircraft movements, unusual flight patterns, airspace anomalies

**Exit criteria:**
- [ ] Live aircraft positions visible on globe
- [ ] Layer toggle to show/hide aircraft
- [ ] Refresh every 60 seconds
- [ ] Rate limiting respected

---

### WP-5.S2: NASA FIRMS Connector (🥈 Priority)
**Active fire hotspots from space.**

- **API:** `https://firms.modaps.eosdis.nasa.gov/api/area/` — free, API key required (register at earthdata.nasa.gov)
- **New file:** `app/services/data_sources/firms_connector.rb`
- **New job:** `app/jobs/fetch_firms_job.rb` — runs every 6 hours
- **Globe integration:** Fire markers as glowing orange/red dots on globe, brightness by confidence
- **Intelligence value:** Wildfires near conflict zones, industrial fires, potential military activity

**Exit criteria:**
- [ ] Fire hotspots visible on globe as distinct layer
- [ ] Layer toggle
- [ ] Tooltip showing confidence, brightness temperature, satellite source

---

### WP-5.S3: USGS Earthquake Connector (🥉 Priority)
**Real-time seismic events.**

- **API:** `https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson` — free, no key needed
- **New file:** `app/services/data_sources/usgs_earthquake_connector.rb`
- **New job:** `app/jobs/fetch_usgs_job.rb` — runs every 15 minutes
- **Globe integration:** Concentric ring animations at epicenters, size by magnitude
- **Intelligence value:** Natural disaster monitoring, nuclear test detection correlation

**Exit criteria:**
- [ ] Earthquake events visible on globe with magnitude-scaled rings
- [ ] Layer toggle
- [ ] Auto-refresh

---

### WP-5.S4: CelesTrak Satellite Connector (🏅)
**Satellite orbit tracking — pure God's Eye aesthetic.**

- **API:** `https://celestrak.org/NORAD/elements/gp.php?GROUP=active&FORMAT=json` — free, no key
- **New file:** `app/services/data_sources/celestrak_connector.rb`
- **New job:** `app/jobs/fetch_celestrak_job.rb` — runs daily
- **Globe integration:** Satellite orbital paths as thin arcs above the globe surface. Focus on reconnaissance/military sats.
- **SGP4 propagation:** Use `satellite.js` npm package to compute real-time positions from TLE data
- **Intelligence value:** Which spy satellites are over which regions right now

**Exit criteria:**
- [ ] Satellite orbits visible as arcs above globe
- [ ] Real-time position computation via SGP4
- [ ] Filter by satellite category (military, weather, comms, etc.)

---

### WP-5.S5: ACLED Conflict Connector
**Armed conflict events worldwide.**

- **API:** `https://api.acleddata.com/acled/read` — free for research/non-commercial, registration required
- **New file:** `app/services/data_sources/acled_connector.rb`
- **New job:** `app/jobs/fetch_acled_job.rb` — runs daily
- **Globe integration:** Conflict markers (explosions, protests, riots) with severity coloring
- **Intelligence value:** Core OSINT — ground truth for conflict narratives

**Exit criteria:**
- [ ] Conflict events visible on globe
- [ ] Categorized by event type (battle, protest, explosion, violence against civilians, etc.)
- [ ] Links to related news articles when available

---

### WP-5.S6: ReliefWeb/OCHA Connector
**Humanitarian crisis alerts.**

- **API:** `https://api.reliefweb.int/v1/reports` — free, no key
- **New file:** `app/services/data_sources/reliefweb_connector.rb`
- **Globe integration:** Humanitarian alert markers

**Exit criteria:**
- [ ] Humanitarian alerts visible on globe
- [ ] Layer toggle

---

### WP-5.10: Provider Health Dashboard
Track per-source: last fetch, total signals, error rate, rate limit remaining, data freshness.

**New service:** `app/services/system_telemetry_service.rb`
**New endpoint:** `GET /api/v2/telemetry`

**Exit criteria:**
- [ ] Health status for each active data source queryable via API

---

### Block 3 Exit Criteria:
- [ ] At least 5 distinct data source types active (news + flights + fires + earthquakes + satellites)
- [ ] All sources normalize to Signal model
- [ ] Each source has its own globe layer with toggle
- [ ] Provider health visible via telemetry endpoint
- [ ] BaseConnector pattern used consistently

---

## BLOCK 4: TEMPORAL ENGINE — 4D Replay
**Goal:** True time travel. Scene snapshots, deterministic replay, delta animations.
**Depends on:** Block 2 (graph must exist to snapshot).

---

### WP-2.1: Scene Snapshot Schema
```ruby
create_table :scene_snapshots do |t|
  t.datetime   :snapshot_at, null: false
  t.string     :snapshot_type, default: 'auto'  # auto, manual, milestone
  t.string     :perspective
  t.jsonb      :graph_state, default: {}
  t.jsonb      :stats, default: {}
  t.integer    :node_count
  t.integer    :edge_count
  t.timestamps
end

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

---

### WP-2.2: Snapshot Engine Service
**New file:** `app/services/scene_snapshot_service.rb`
- `capture!(time:)` — freeze current graph state
- `delta_between(from:, to:)` — compute changes
- `at(time:, perspective:)` — return nearest snapshot

---

### WP-2.3: Scheduled Snapshot Job
Runs every 30 minutes via Solid Queue recurring. Also triggered after major ingestion batches.

---

### WP-2.4: Scene Replay API
- `GET /api/v2/scene/:snapshot_id`
- `GET /api/v2/scene/at?time=<iso8601>`
- `GET /api/v2/delta?from=<id>&to=<id>`
- `GET /api/v2/timeline` — list snapshots with stats

---

### WP-2.5: Timeline Controller Integration
Refactor timeline/timelapse to step through real snapshots instead of re-filtering articles.

---

### Block 4 Exit Criteria:
- [ ] Timeline scrubber steps through real snapshots
- [ ] Timelapse animates snapshot deltas (deterministic)
- [ ] Same timestamp always produces same scene
- [ ] `/api/v2/scene/:id` response < 200ms cached

---

## BLOCK 5: FUSION & OPERATOR UX
**Goal:** Intelligence-grade analysis + command center UX.
**Depends on:** Blocks 2 + 4.

---

### WP-4.1: Fusion Scoring Engine
**New file:** `app/services/fusion_scoring_service.rb`

Per `intel_edge`, compute and store:
```ruby
{
  semantic_score:        0.0..1.0,
  temporal_score:        0.0..1.0,
  entity_overlap_score:  0.0..1.0,
  event_coreference:     0.0..1.0,
  source_credibility:    0.0..1.0,
  geographic_proximity:  0.0..1.0,
  framing_similarity:    0.0..1.0,
  contradiction_penalty: -1.0..0.0
}
```
Store in `intel_edges.score_decomposition`.

---

### WP-4.2: Narrative State Machine
**New file:** `app/services/narrative_lifecycle_service.rb`

Lifecycle states per narrative cluster:
```
EMERGING → AMPLIFYING → CONTESTED → FRACTURED → DECAYING → DORMANT → REACTIVATED
```

Transitions driven by signal velocity, contradiction pressure, source diversity, geographic spread.

---

### WP-6.1: Operator Mode System
Four modes that reshape the UI:

| Mode | Purpose |
|---|---|
| MONITOR | Live situational awareness — full globe, streaming, alerts |
| INVESTIGATE | Deep-dive — focused globe, expanded network, evidence sidebar |
| REPLAY | Forensic timeline — snapshot-driven, frame controls |
| BRIEF | Executive summary — minimal globe, report panel, export |

---

### WP-6.2: Live Telemetry (Replace Fake Labels)
Replace all hardcoded `ONLINE`/`PENDING` status chips with real data from `SystemTelemetryService`. Polled every 10s.

---

### WP-6.3: Visual Overlay Layers
New globe layers:
- Uncertainty Fog — semi-transparent over low-confidence regions
- Contradiction Lightning — animated arcs between conflicting stories
- Source Influence Vectors — directional arrows showing narrative flow
- Temporal Wavefronts — expanding circles showing story spread speed

---

### WP-6.4: Alert System v2
Priority-based alert triage with types: breaking, anomaly, contradiction_burst, narrative_shift, coordinated_amplification, source_degradation, entity_emergence.

---

### Block 5 Exit Criteria:
- [ ] Every edge has visible score decomposition
- [ ] Narrative clusters have lifecycle states
- [ ] 4 operator modes switchable
- [ ] All status labels driven by real telemetry
- [ ] At least 2 new overlay layers on globe

---

## BLOCK 6: HUNTER AGENTS & RISK INDEX (Selective)
**Goal:** Autonomous detection + regional risk scoring.
**Depends on:** Block 5.

---

### WP-7.1: Hunter Agents (3 types only)
Background agents scanning the intelligence graph:

| Hunter | Detects | Trigger |
|---|---|---|
| Coordinated Amplification | Near-identical framing in tight window | >3 sources, >80% similarity, <4h |
| Narrative Anomaly | Sudden spike in dormant topic | >5x baseline velocity |
| Entity Emergence | New entity across multiple stories | >5 articles in 24h, zero prior |

**New models:** `HunterAgent`, `HunterFinding`
**New job:** `app/jobs/run_hunter_agents_job.rb` — runs every 30 minutes

---

### WP-7.3: Influence Path Attribution
For major narrative shifts: top 5 causal pathways, pivotal nodes (highest betweenness centrality), confidence bounds. Visualize as Sankey diagram.

---

### WP-7.5: Geopolitical Risk Index
Composite real-time index per region/country. Weighted combination of conflict events, media sentiment, narrative lifecycle states, entity tensions, contradiction density. Historical trending.

---

### Block 6 Exit Criteria:
- [ ] 3 hunter agent types running autonomously
- [ ] Influence paths visualized for top narratives
- [ ] Risk index visible per region on globe

---

## BLOCK 7: HARDENING (Selective)
**Goal:** Production stability without over-engineering.
**Depends on:** Blocks 1-6 done.

---

### WP-8.1: Queue Segmentation
Replace wildcard worker with dedicated queues:
```yaml
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

---

### WP-8.3: Typed WebSocket Messages
All WS messages follow a standard envelope:
```json
{
  "type": "scene.delta.applied | signal.ingested | alert.raised | telemetry.snapshot",
  "payload": {},
  "timestamp": "iso8601",
  "version": 2
}
```

---

### WP-8.5: Test Strategy
- Contract tests for all `/api` endpoints (lock payload shape)
- Service specs for graph compiler, fusion scoring, snapshot engine
- Model specs for all new models

---

### Block 7 Exit Criteria:
- [ ] Segmented queues operational
- [ ] All WS messages use typed envelope
- [ ] Contract tests for all API endpoints
- [ ] Service specs for core services

---

## DATA SOURCE REGISTRY (Free Only)

| Source | Type | API | Free? | Key? | Refresh |
|---|---|---|---|---|---|
| NewsAPI | News | REST | ✅ (dev) | Yes | 30min |
| GDELT Events | Conflict | BigQuery | ✅ (1TB/mo) | Yes | 15min |
| OpenSky | Aviation | REST | ✅ | Optional | 60s |
| NASA FIRMS | Fire | REST | ✅ | Yes (free reg) | 6h |
| USGS Earthquake | Seismic | GeoJSON | ✅ | No | 15min |
| CelesTrak | Satellite | JSON/TLE | ✅ | No | Daily |
| ACLED | Conflict | REST | ✅ (non-comm) | Yes (free reg) | Daily |
| ReliefWeb | Humanitarian | REST | ✅ | No | 6h |

---

## AI MODEL CONFIGURATION

Update if budget allows, otherwise keep current models:

| Role | Current | Suggested Upgrade |
|---|---|---|
| Analyst | gemini-2.0-flash-001 | google/gemini-2.5-flash |
| Sentinel | gpt-4o-mini | openai/gpt-4.1-mini |
| Arbiter | claude-3.5-haiku | anthropic/claude-3.5-haiku (keep for cost) |
| Relevance Filter | gemini-2.0-flash-001 | google/gemini-2.5-flash |
| Voice | claude-3.5-haiku | keep |

Note: Model upgrades are optional. Prioritize free model tiers where possible. Don't upgrade unless the orchestrator explicitly approves increased token costs.

---

## REMINDER TO CLAUDE CODE

Before executing anything:
1. ✅ Read CLAUDE.md
2. ✅ Read this entire document
3. ✅ Write `docs/PLAN_REVIEW.md` with your critical assessment
4. ✅ Write `docs/ACTIVE_ROADMAP.md` with your finalized task list
5. ✅ Get orchestrator confirmation before starting Block 1
6. ✅ One WP = one branch = one commit = one push
7. ✅ Update ACTIVE_ROADMAP.md after each WP

**Do not start coding until steps 1-4 are complete.**

---

> *"Less theater, more truth infrastructure. The God's Eye sees everything — but only if the plumbing is clean."*
