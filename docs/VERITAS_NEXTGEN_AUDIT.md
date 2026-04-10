# VERITAS Next-Gen Audit

> **⚠️ HISTORICAL DOCUMENT** — This audit was conducted in April 2026 as a blind code review.
> All findings have been incorporated into `docs/VERITAS_MASTER_EXECUTION_PLAN.md` (Phase 0 and beyond).
> Use the Master Plan as the canonical action document, not this file.

Scope: code-derived only. This report ignores old docs and README claims and evaluates the current codebase against an elite command-center benchmark.

## 1) Executive Verdict

VERITAS is a visually ambitious prototype, not an operator-grade intelligence platform. The system is trying to look like a real-time fusion center, but the implementation is still dominated by one giant globe controller, one oversized page controller, heuristic geolocation, runtime CDN dependencies, and a lot of event spaghetti. The shape is impressive. The engineering bar is not.

The core issue is concentration of complexity. `app/javascript/controllers/globe_controller.js` is about 3163 LOC, `app/controllers/pages_controller.rb` is 645 LOC, `app/services/article_network_service.rb` is 734 LOC, and `app/views/pages/home.html.erb` is 427 LOC. Those are not support files. They are the product. That is a sign of an application that is still assembled, not decomposed.

Against a WorldView-like command center benchmark, this codebase is missing the hard parts: clean data contracts, durable graph snapshots, reliable geospatial normalization, low-coupling streaming, and measurable operator telemetry. It can demo. It is not yet something a serious analyst would trust under load.

## 2) What The Code Actually Does Today

- The 3D globe is powered by Globe.gl in `app/javascript/controllers/globe_controller.js:189-280`, with Earth textures and background art loaded directly from `unpkg` at runtime.
- The flat map is a D3 equirectangular projection in `app/javascript/controllers/flat_map_controller.js:47-105`, and it fetches world boundaries from `jsdelivr` at runtime.
- The UI is highly event-driven. `app/javascript/controllers/globe_controller.js:60-78` wires more than a dozen `window` events, and `app/javascript/controllers/flat_map_controller.js:27-30` adds another event fan-in layer.
- The main globe data feed is `/api/globe_data` in `app/controllers/pages_controller.rb:163-337`. It returns points, heatmap, regions, and heatmap clusters. It explicitly leaves `arcs` and `routes` empty there and relies on `/api/article_network` for arcs.
- The globe data endpoint hard-caps the working set at 250 articles and then trims points and heatmap data again at 200 entries (`app/controllers/pages_controller.rb:217-326`).
- Country coordinates in `globe_data` are hardcoded for a narrow ISO subset, and anything else falls back to `[0.0, 0.0]` (`app/controllers/pages_controller.rb:244-280`).
- `avg_threat` in `heatmap_clusters` is computed with `threat_level.to_i` even though `AiAnalysis#threat_level` is documented and handled as a string enum (`app/controllers/pages_controller.rb:283-305`, `app/models/ai_analysis.rb:8-21`). That is a likely zeroing bug for string values.
- Article network rendering is capped again at the API layer. Global mode renders at most 30 arcs and search mode at most 25 (`app/controllers/pages_controller.rb:446-490`).
- `ArticleNetworkService` is a multi-signal graph builder with a frontend render cap of 60 and multiple raw SQL paths using string interpolation plus `ActiveRecord::Base.connection.execute` (`app/services/article_network_service.rb:30-33`, `app/services/article_network_service.rb:293-306`, `app/services/article_network_service.rb:340-354`, `app/services/article_network_service.rb:384-402`, `app/services/article_network_service.rb:501-524`).
- Narrative route generation uses pgvector nearest-neighbor SQL and then `Article.find` per returned row, which is an avoidable N+1 pattern (`app/services/narrative_route_generator_service.rb:79-110`).
- The route generator also falls back to a hardcoded ccTLD map for country inference when article geography is missing (`app/services/narrative_route_generator_service.rb:260-293`).
- `GeolocatorService` is a giant static lookup table plus a source-name fallback, using substring matching and a "last occurrence wins" heuristic (`app/services/geolocator_service.rb:17-212`, `app/services/geolocator_service.rb:243-290`).
- OpenRouter defaults are older small models with tight token budgets: `gemini-2.0-flash-001`, `gpt-4o-mini`, and `claude-3.5-haiku` (`app/services/open_router_client.rb:11-29`).
- News ingestion is still NewsAPI-centered with a daily fetch budget of 90 calls, a broad geopolitical keyword query, and a recurring fetch job that bails when the budget is exhausted (`app/services/news_api_service.rb:8-28`, `app/jobs/fetch_articles_job.rb:12-21`).
- The queue is configured with a wildcard worker queue and only three threads (`config/queue.yml:1-9`).
- ActionCable exposes public streams for `globe` and `alerts`, while search streaming is keyed off the user-supplied query string in `app/channels/intelligence_search_channel.rb:1-4` and `app/channels/globe_channel.rb:1-4`, `app/channels/alerts_channel.rb:1-4`.
- The test surface is thin. There are 21 files under `test/` and no `spec/` tree at all.
- The home page uses a lot of inline styles and hardcoded status text, including static `SYSTEM_STATUS` labels and fixed `ONLINE`/`PENDING` values (`app/views/pages/home.html.erb:263-307`).

## 3) Critical Gaps Vs Benchmark

### Visual And Rendering

- The globe and flat map are not isolated renderers. They are tangled into a controller mesh that listens to many global events, fetches data from multiple endpoints, and mutates scene state directly (`app/javascript/controllers/globe_controller.js:60-78`, `app/javascript/controllers/globe_controller.js:1312-1515`).
- Runtime CDN asset loading is a reliability weakness. Earth textures and map boundaries are pulled live from `unpkg` and `jsdelivr` instead of being pinned and served locally (`app/javascript/controllers/globe_controller.js:195-197`, `app/javascript/controllers/flat_map_controller.js:90-105`).
- The UI is still composed like a dashboard skin, not an operator console. `app/views/pages/home.html.erb:1-427` is full of inline styles, static labels, and hardcoded status chips that do not appear to be driven by live telemetry.
- The flat map uses a simple equirectangular projection. That is acceptable for a fallback view, but it is not a high-fidelity intelligence visualization layer by itself (`app/javascript/controllers/flat_map_controller.js:55-60`).

### Data Fusion

- The main API intentionally ships partial data. `/api/globe_data` excludes arcs and routes and trims points and heatmap data aggressively (`app/controllers/pages_controller.rb:217-242`).
- Country placement is incomplete and brittle. Hardcoded ISO coordinate mappings cover only a subset of countries, and unresolved cases get dropped onto the origin at `[0.0, 0.0]` (`app/controllers/pages_controller.rb:244-280`).
- Threat aggregation is inconsistent. The system knows `threat_level` is a string enum in one place, then still uses `to_i` in another, which is exactly the kind of silent data corruption that kills analyst trust (`app/controllers/pages_controller.rb:283-305`, `app/models/ai_analysis.rb:8-21`).
- The network graph is bounded by caps rather than by a coherent model. `article_network` slices global arcs to 30 and search arcs to 25 before the client sees them (`app/controllers/pages_controller.rb:446-490`), while `ArticleNetworkService` itself applies a 60-arc render limit (`app/services/article_network_service.rb:30-33`, `app/services/article_network_service.rb:501-524`).
- Narrative route generation still relies on heuristic fallbacks for geography, including ccTLD inference and source-name guessing (`app/services/narrative_route_generator_service.rb:129-130`, `app/services/narrative_route_generator_service.rb:260-293`).
- `GeolocatorService` is a stopgap dictionary, not a real geoparsing engine. Substring matching and "last match wins" are too weak for intelligence-grade location resolution (`app/services/geolocator_service.rb:243-290`).

### Temporal And 4D Intelligence

- The UI advertises timeline and timelapse behavior, but the server is still serving capped slices of the current article set, not a clearly versioned time-snapshot model (`app/controllers/pages_controller.rb:163-337`, `app/javascript/controllers/globe_controller.js:1327-1503`).
- Search and network views re-fetch and restage scene state, but there is no evidence in the cited paths of a durable scene history, replay log, or persisted temporal graph snapshot store.
- The result is temporal theater. It moves. It does not yet prove lineage.

### Operational Reliability

- The job system is under-instrumented and underspecified relative to the workload. `config/queue.yml:1-9` uses a wildcard worker queue with only three threads, while most jobs are still routed to `:default` (`app/jobs/fetch_articles_job.rb:1-81`, `app/jobs/generate_narrative_routes_job.rb:1-32`, `app/jobs/detect_narrative_convergences_job.rb:1-12`).
- The real-time channels are public by default in the wrong places. `globe` and `alerts` are broadcast streams with no visible segmentation in the cited code, and the search channel key is derived from untrusted query text in `app/channels/intelligence_search_channel.rb:1-4`.
- The code still leans on raw SQL string interpolation for vector search and connection-building. That is a maintainability and safety liability, not just a style issue (`app/services/narrative_route_generator_service.rb:79-110`, `app/services/article_network_service.rb:293-306`, `app/services/article_network_service.rb:340-354`, `app/services/article_network_service.rb:384-402`).
- The model stack is dated and constrained. Fixed small-token budgets plus older model defaults make the system cheap to run, but they also cap analytical depth (`app/services/open_router_client.rb:11-29`).
- The test surface is too small for the amount of branching logic in the data and rendering pipeline. Twenty-one test files is not enough for this level of branching, caching, and fallback behavior.

## 4) Prioritized Roadmap

### 0-30 Days

- Normalize threat values once and only once. Remove every `to_i` conversion on enum threat values and route all threat rendering through a shared normalization helper.
- Remove raw SQL string interpolation in pgvector and graph queries. Parameterize the vector and time window inputs instead of embedding them into SQL strings.
- Replace `[0.0, 0.0]` fallback geography with explicit unknown-state handling and logging. Unknown should be visible, not silently plotted as the Gulf of Guinea.
- Pin or self-host globe textures and world boundary assets. Runtime CDN dependencies are not acceptable for an operator surface.
- Add contract tests for `/api/globe_data` and `/api/article_network` so the payload shape is locked down.
- Add targeted service tests for `GeolocatorService`, `NarrativeRouteGeneratorService`, and `ArticleNetworkService`.

### 30-90 Days

- Split the current monolith controllers into smaller scene adapters. The globe, flat map, timeline, search, and network modes should not live in one event-heavy controller.
- Introduce a real graph data model. Add explicit tables or materialized views for `graph_edges`, `route_hops`, `geo_lookup`, and `scene_snapshots` so the frontend stops reconstructing truth from raw articles on every request.
- Replace hardcoded country coordinates with a canonical country centroids table keyed by ISO code.
- Replace substring geolocation heuristics with a proper geoparsing pipeline. At minimum, separate place-name extraction from source-country fallback.
- Turn `ArticleNetworkService` into a graph compiler that consumes precomputed relations instead of repeatedly building the same graph from scratch.
- Add websocket or stream telemetry for load, latency, and dropped-update counts so the UI can show actual health instead of static labels.

### 90-180 Days

- Move from live recomputation to versioned intelligence snapshots. The system should be able to replay a story at any timestamp without rebuilding the entire scene from scratch.
- Add a proper streaming backbone for analysis events and scene deltas. ActionCable should be the last-mile delivery layer, not the place where all state management ends up.
- Evaluate a stronger geospatial rendering stack if the roadmap demands richer overlays and time playback. Globe.gl can stay as a renderer if the scene model is cleaned up, but it should not be the architecture.
- Add observability as a first-class feature: OpenTelemetry traces, structured logs, queue latency metrics, cache hit rates, API p95, websocket fanout metrics, and error budgets.
- Upgrade the test strategy from "some unit coverage" to endpoint contracts, rendering integration tests, and replay tests for temporal state.

## 5) Target Architecture Proposal

The clean version is simple: ingest -> normalize -> enrich -> snapshot -> render.

- Ingest stays NewsAPI/GDELT/other sources.
- Normalize writes canonical `articles`, `entities`, `countries`, and `signals` records.
- Enrich computes embeddings, narrative routes, threat scores, and geoparsed locations in background jobs.
- Snapshot stores time-bounded scene graphs and perspective-specific projections.
- Render reads compact, versioned JSON deltas instead of rebuilding truth in the browser from partial API slices.

Keep the browser as a renderer. Keep Rails as the orchestration layer. Push graph compilation, geolocation, and temporal replay out of the hot path.

## 6) Definition Of Done Metrics

- `app/javascript/controllers/globe_controller.js` is under 500 LOC and no longer owns global scene orchestration, network mode, search mode, and event cleanup in one file.
- `app/controllers/pages_controller.rb` is under 300 LOC and does not build graph payloads inline.
- `app/services/article_network_service.rb` is under 400 LOC and contains zero raw SQL string interpolation.
- Runtime CDN usage for core globe and map assets is 0. All critical visual assets are pinned or self-hosted.
- Threat normalization has 0 `to_i` conversions on enum threat values outside a single compatibility shim.
- Geolocation fallback to `[0.0, 0.0]` is under 1 percent of geolocated articles, and every unresolved case is explicitly tagged.
- `/api/globe_data` and `/api/article_network` each have contract tests that lock payload shape, cap behavior, and empty-state behavior.
- Public endpoint p95 latency for cached globe data is under 200 ms, and uncached graph builds stay under 1 second for the supported workload.
- Queue latency for default jobs stays under 60 seconds at p95, with separate queue budgets per workload class instead of a wildcard worker.
- Test coverage for the changed controllers and services is above 80 percent line coverage, with integration tests for globe load, search, network view, and cable broadcasts.
- Every live status label in the operator UI comes from telemetry or job state, not hardcoded text.

Bottom line: VERITAS needs decomposition, normalization, and proof. Right now it has ambition, motion, and a lot of styled surfaces. It does not yet have the control-plane discipline that an elite intelligence console requires.
