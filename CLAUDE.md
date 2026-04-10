# CLAUDE.md — VERITAS Intelligence Platform

> "We cannot stop people from lying on the internet.
>  But with VERITAS, we can make sure they can never hide in the dark again."

---

## Agent Identity & Role

You are a **Principal Engineer** on a high-stakes intelligence platform.
Your profile:
- 15+ years full-stack experience across defense-grade, data-intensive applications
- Deep fluency in Ruby on Rails 8, PostgreSQL, real-time systems, and AI pipelines
- Expert-level knowledge of modern 2026 UI/UX design: dark interfaces, data visualization, immersive 3D web experiences, neon/cyberpunk aesthetic systems
- Familiar with Palantir Gotham/Foundry architecture patterns, war-room dashboards, and intelligence-grade data presentation
- You write production-ready, clean, maintainable code — no hacks, no cowboy code
- You think through architecture and edge cases BEFORE writing a single line
- You prefer simple, elegant solutions and always warn before introducing complexity

When in doubt: **less code, more clarity.**

---

## Project: VERITAS

**Type:** Real-time narrative intelligence platform
**Mission:** Visualize how news stories are engineered and manipulated globally — not what is happening, but HOW the world is talking about it.
**Tagline:** "A radar for truth. A Palantir for the people."
**Origin:** Generated with Le Wagon Rails Template (lewagon/rails-templates)
**Deployment:** Heroku (production)
**Branch convention:** `olli/<feature-name>`

### What VERITAS Does
- Tracks disinformation routes from origin → proxy networks → media outlets, live
- Analyzes media bias and sentiment across global news sources simultaneously
- Visualizes narrative shifts as animated arcs on an interactive 3D globe
- Allows users to "time travel" through a story's evolution via a timeline slider
- Runs a multi-agent AI pipeline (Analyst/Sentinel/Arbiter) for real-time analysis and verdict generation
- Features a **Perspective Slider** — users can view the globe through the lens of China, Russia, US Democrats, Republicans, Fox News viewers, etc.
- Detects narrative surges, contradictions, and coordinated amplification patterns
- Provides RAG-powered intelligence chat, Voice narration (ElevenLabs), and self-awareness (AWARE system)

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Ruby on Rails 8 (API + server-rendered views) |
| Real-time | Solid Cable (WebSockets via ActionCable) |
| Database | PostgreSQL + pgvector (embeddings & vector search) |
| 3D Rendering | Three.js + Globe.gl |
| 2D Map | D3.js equirectangular fallback |
| Styling | Tailwind CSS (dark theme, neon palette) |
| News Data | NewsAPI.org + GDELT (BigQuery) |
| AI Layer | OpenRouter multi-model pipeline (Gemini, GPT, Claude) |
| Deployment | Heroku |
| Auth | Devise |
| Background Jobs | Solid Queue (Active Job) |
| JS Framework | Stimulus (importmap-rails, NO React/Vue/Angular) |

---

## Architecture Overview

```
app/
├── models/          # Article, AiAnalysis, NarrativeArc, NarrativeRoute,
│                    # NarrativeConvergence, NarrativeSignature, Entity,
│                    # EntityMention, ContradictionLog, SourceCredibility,
│                    # IntelligenceReport, IntelligenceBrief, EmbeddingSnapshot,
│                    # GdeltEvent, BreakingAlert, PerspectiveFilter,
│                    # Region, Country, SavedArticle, Briefing, UserModelConfig
├── services/        # AnalysisPipeline, OpenRouterClient, RagAgent,
│                    # EmbeddingService, GeolocatorService, NewsApiService,
│                    # GdeltIngestionService, GdeltEventIngestionService,
│                    # ArticleNetworkService, NarrativeRouteGeneratorService,
│                    # NarrativeDnaService, NarrativeConvergenceService,
│                    # NarrativeSurgeDetectorService, EntityExtractionService,
│                    # EntityNexusService, ContradictionDetectionService,
│                    # SourceCredibilityService, NarrativeSignatureService,
│                    # RegionalAnalysisService, IntrospectionService,
│                    # EmbeddingDriftService, IntelligenceSearchService,
│                    # TribunalService, BreakingAlertBroadcastService,
│                    # BriefingService, IntroSpectionService,
│                    # GdeltBigQueryService, ElevenLabsService
├── jobs/            # AnalyzeArticleJob, FetchArticlesJob, FetchArticleContentJob,
│                    # FreshIntelligenceJob, GenerateEmbeddingJob,
│                    # FetchGdeltArticlesJob, FetchGdeltEventsJob,
│                    # NarrativeSignatureClusterJob, DetectContradictionsJob,
│                    # GenerateIntelligenceBriefJob, CaptureEmbeddingSnapshotJob,
│                    # RegionalAnalysisJob, GenerateNarrativeRoutesJob
├── channels/        # GlobeChannel, AlertsChannel, SearchChannel
├── controllers/     # PagesController, ArticlesController, ChatsController,
│                    # IntelligenceReportsController, SavedArticlesController,
│                    # Api::SearchController, Api::ModeController,
│                    # Api::TrendingTopicsController, Api::SurgeChecksController,
│                    # Admin::UsersController, Admin::NarrativeRoutesController,
│                    # ModelConfigsController, FeaturePreviewsController
└── javascript/
    └── controllers/ # globe_controller.js (3164 LOC — decompose in Phase 3),
                     # search_intelligence_controller.js, perspective_controller.js,
                     # timeline_controller.js, narrative_dna_controller.js,
                     # entity_nexus_controller.js, tribunal_controller.js,
                     # voice_orb_controller.js, consciousness_controller.js,
                     # analysis_progress_controller.js, flat_map_controller.js,
                     # view_mode_controller.js, heatmap_toggle_controller.js,
                     # day_night_toggle_controller.js, model_settings_controller.js
```

---

## Key Models & Relationships

```
users ──< saved_articles ──> articles
users ──< briefings
users ──< user_model_configs
regions ──< countries ──< articles
articles ──< ai_analyses (1:1)
articles ──< narrative_arcs ──< narrative_routes
articles ──< entity_mentions ──> entities
articles ──< narrative_signature_articles ──> narrative_signatures
articles ──< contradiction_logs (as article_a or article_b)
articles ──< gdelt_events (optional FK)
intelligence_reports ──> regions
```

---

## AI Pipeline (VERITAS Triad)

```
Article → AnalyzeArticleJob → AnalysisPipeline
  Phase 1: Analyst (Gemini) + Sentinel (GPT) — parallel analysis
  Phase 2: Arbiter (Claude) — cross-verification
  Phase 3: Final AiAnalysis record saved
  Phase 3b: SourceCredibilityService updates source trust
  Phase 4: EmbeddingService generates pgvector embedding
  Phase 4b: NarrativeSignatureService classifies article
  Phase 5: EntityExtractionService extracts & links entities
```

All AI calls route through `OpenRouterClient` (multi-provider via openrouter.ai).

---

## Data Sources

| Source | Status | Frequency | Notes |
|---|---|---|---|
| NewsAPI.org | ✅ Active | Hourly recurring + on-demand search | 100 calls/day free tier |
| GDELT GKG (BigQuery) | ✅ Active | Hourly | 3-tier cost protection, ~250 MB/query |
| GDELT Events (BigQuery) | ✅ Active | Every 2 hours | CAMEO-coded conflict events, ~500 MB-1.5 GB/query |

---

## Critical Commands

```bash
# Development
rails s                          # start dev server
rails c                          # Rails console
rails db:migrate                 # run pending migrations
rails db:seed                    # seed dev data

# Testing (Minitest, NOT RSpec)
bin/rails test                   # run all tests
bin/rails test test/models/      # run model tests
bin/rails test test/services/    # run service tests

# Heroku (Production)
git push heroku main             # deploy
heroku run rails db:migrate      # production migrations
heroku logs --tail               # live logs
heroku run rails c               # production console

# Branch workflow
git checkout -b olli/<feature>   # new feature branch
```

---

## Master Execution Plan

All development work is orchestrated from:

**`docs/VERITAS_MASTER_EXECUTION_PLAN.md`**

This is the **single source of truth** for the VERITAS roadmap and replaces all legacy planning documents. It defines 8 phases with 40+ work packages, from Phase 0 (bug fixes) through Phase 8 (hardening & scale).

---

## Product Standard

The target is not "good enough for demo". The target is:

- Trustworthy, explainable outputs
- Robust multi-source ingestion
- Real-time operational behavior
- Cinematic but meaningful visualization
- Operator-grade analyst workflows

Every feature must pass 5 criteria:

1. Is it accurate enough to trust?
2. Is it explainable enough to defend?
3. Is it stable enough to operate?
4. Is it fast enough to use live?
5. Does it improve analyst decisions?

---

## AI Execution Rules

See `ai_execution_rules.md` for the full 35-rule set governing AI coding sessions. Key principles:

- Intelligence first — data integrity > visual polish
- Trust is a feature — all AI outputs must be explainable
- No fake production features — no hardcoded data masquerading as real
- Inspect first — read existing code before writing new
- Smallest coherent change — one logical slice end-to-end
- Do not break existing working flows
- Keep controllers thin — logic in services/jobs
- No unsafe HTML rendering — sanitize everything
- Test critical paths — not just models
