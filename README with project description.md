## VERITAS — Next-Gen Intelligence Platform

VERITAS is being rebuilt to meet an elite command-center standard: not a news dashboard, but a geospatial narrative-intelligence engine.

### Current Reality

The codebase currently delivers a strong visual prototype with a live globe, timeline, perspective controls, and AI-assisted analysis. It does not yet meet the reliability, data-fusion depth, and temporal rigor expected from an operator-grade system.

### Key Documents

- **Master Roadmap:** `docs/VERITAS_MASTER_EXECUTION_PLAN.md` — single source of truth for all development (8 phases, 40+ work packages)
- **Code Audit:** `docs/VERITAS_NEXTGEN_AUDIT.md` — historical blind code audit identifying technical debt
- **AI Rules:** `ai_execution_rules.md` — 35 rules for AI-assisted coding sessions
- **Agent Config:** `AGENTS.md` / `CLAUDE.md` — AI agent identity and project context

### Target Vision

Build VERITAS as a world-scale narrative fusion platform that answers:

- How narratives originate, mutate, and propagate across sources, regions, and political lenses
- Which entities, events, and framing shifts drive those movements
- How confidence changes over time, with replayable evidence and lineage

### Non-Negotiable Product Bar

- 4D intelligence: time-versioned scene snapshots, replayable state, and deterministic timeline behavior
- Multi-signal fusion: semantic similarity, event correlation, entity overlap, source reliability, and contradiction tracking
- Operator-grade rendering: high-density overlays, perspective-aware projections, and low-latency interaction at scale
- Observable system health: real telemetry for ingestion, queues, analysis, websockets, and UI status
- Testable contracts: stable API payloads and replay-safe behavior under load

### Execution Direction

All development is orchestrated from `docs/VERITAS_MASTER_EXECUTION_PLAN.md`:

- **Phase 0:** Critical bug fixes & safety (threat_level, Null Island, CDN pinning, SQL safety)
- **Phase 1:** Intelligence Graph Foundation (intel_nodes + intel_edges)
- **Phase 2:** Temporal Engine & 4D Replay (scene snapshots + deltas)
- **Phase 3:** Globe Architecture Decomposition (3164 LOC → 7 modules)
- **Phase 4:** Multi-Signal Fusion & Inference (scoring, state machines, claims)
- **Phase 5:** Sensor Network & Data Sources (ACLED, FIRMS, USGS, OpenSky, CelesTrak)
- **Phase 6:** Operator Console & War Room UX (4 modes, telemetry, overlays)
- **Phase 7:** Autonomous Agents & Predictive Intelligence (hunters, counterfactuals)
- **Phase 8:** Platform Hardening & Scale (queues, observability, tests, security)

### Platform Stack (Current Base)

- Backend: Ruby on Rails 8
- Data: PostgreSQL + pgvector
- Real-time: Solid Cable + ActionCable
- Jobs: Solid Queue
- Rendering: Globe.gl / Three.js + D3 fallback map
- AI integration: OpenRouter-backed multi-model analysis pipeline (Gemini, GPT, Claude)
- Styling: Tailwind CSS (dark theme, neon palette)

### Guiding Principle

Less theater, more truth infrastructure.
