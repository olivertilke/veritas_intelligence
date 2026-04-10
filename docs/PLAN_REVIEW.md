# VERITAS Master Execution Plan — Self-Review

## Assessment of Phasing and Structure
The phrasing and block structure of this plan is excellent. Leading with **Block 1: CHIRURGIE** is the right strategy. Attempting to build an operator-grade intelligence platform on top of a 3164-line "god controller" (`globe_controller.js`) and a 600+ line API/view controller (`pages_controller.rb`) would cripple our development velocity. By decomposing the frontend and backend first, we enable faster, modular feature additions.

The progression from structural cleanup (Block 1) -> graph data model (Block 2) -> multi-source ingestion (Block 3) -> temporal tracking (Block 4) -> and advanced operational UI (Block 5) reflects a mature architectural evolution.

## Dependencies & Scope
- **Block 2 (Intelligence Graph)** and **Block 3 (Sensor Network)** can likely be run in parallel, provided the new data sources initially just ingest into the unified `Signal` model and the Graph compiler picks them up iteratively.
- **Block 4 (Temporal Engine)** absolutely requires Block 2. You cannot snapshot a graph that doesn't exist.
- Defining **100% free APIs** for Block 3 is a great constraint, but we need to strictly monitor API limits and rate throttling via the new `BaseConnector` pattern.

## Identified Risks & Concerns
1. **The Globe Controller Refactor (WP-3.1–3.8)**: Extracting a 3164 LOC Three.js/Globe.gl monolith is the highest risk item in Block 1. Since visual WebGL code is notoriously difficult to unit-test, we risk subtle regressions in rendering, animations, or event handling.
   * *Mitigation*: We must strictly extract *one module at a time* (starting with `scene_engine.js`) and do manual/visual verification before proceeding to the next extraction. Do not attempt a "big bang" rewrite of this file.
2. **Data Source Rate Limits**: Free tiers on APIs like OpenSky or NASA FIRMS are often strict. The `fetch_latest` and background jobs must gracefully back off when HTTP 429 maps are hit to avoid bans.
3. **Database Performance**: Building the intel graph (Block 2) and snapshotting it frequently (Block 4) could rapidly bloat the database if we're not careful. We must ensure robust indexing on the polymorphic associations.

## Recommended First 3 Work Packages
I recommend we tackle the highest-risk/highest-reward bug fixes first. They are relatively isolated changes that immediately improve data integrity and security, warming us up for the larger refactors:

1. **WP-0.1: Fix Threat Level Data Corruption** — Small model/controller change, but instantly fixes broken heatmap logic.
2. **WP-0.2: Kill Null Island** — High visibility fix for the globe, stopping bad coordinates.
3. **WP-0.4: Parameterize Raw SQL** — Critical security fix that eliminates injection risks before we start building more advanced graph queries.
