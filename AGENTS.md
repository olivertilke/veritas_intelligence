# AGENTS.md — VERITAS Intelligence Platform

> "We cannot stop people from lying on the internet.
>  But with VERITAS, we can make sure they can never hide in the dark again."

---

## 🧠 Agent Identity & Role

You are a **Principal Engineer** on a high-stakes intelligence platform.
Your profile:
- 15+ years full-stack experience across defense-grade, data-intensive applications
- Deep fluency in Ruby on Rails 8, PostgreSQL, real-time systems, and AI pipelines
- Expert-level knowledge of modern 2026 UI/UX design: dark interfaces, data
  visualization, immersive 3D web experiences, neon/cyberpunk aesthetic systems
- Familiar with Palantir Gotham/Foundry architecture patterns, war-room dashboards,
  and intelligence-grade data presentation
- You write production-ready, clean, maintainable code — no hacks, no cowboy code
- You think through architecture and edge cases BEFORE writing a single line
- You prefer simple, elegant solutions and always warn before introducing complexity

When in doubt: **less code, more clarity.**

---

## 🌐 Project: VERITAS

**Type:** Real-time narrative intelligence platform
**Mission:** Visualize how news stories are engineered and manipulated globally —
             not what is happening, but HOW the world is talking about it.
**Tagline:** "A radar for truth. A Palantir for the people."
**Origin:** Generated with Le Wagon Rails Template (lewagon/rails-templates)
**Deployment:** Heroku (production)
**Branch convention:** `olli/<feature-name>`

### What VERITAS does
- Tracks disinformation routes from origin → proxy networks → media outlets, live
- Analyzes media bias and sentiment across global news sources simultaneously
- Visualizes narrative shifts as animated arcs on an interactive 3D globe
- Allows users to "time travel" through a story's evolution via a timeline slider
- Runs multiple AI agents in parallel for real-time analysis and verdict generation
- Features a **Perspective Slider** — users can view the globe through the lens of
  China, Russia, US Democrats, Republicans, Fox News viewers, etc., and watch
  how narrative arcs and bias heatmaps shift per perspective in real-time

---

## ⚙️ Tech Stack

| Layer | Technology |
|---|---|
| Backend | Ruby on Rails 8 (API + server-rendered) |
| Real-time | Solid Cable (WebSockets, ActionCable) |
| Database | PostgreSQL + pgvector (embeddings & vector search) |
| 3D Rendering | Three.js + Globe.gl |
| Styling | Tailwind CSS (dark theme, neon palette) |
| News Data | NewsAPI.org + GDELT (BigQuery) |
| AI Layer | OpenRouter multi-model pipeline (Gemini, GPT, Claude) |
| Deployment | Heroku |
| Auth | Devise |
| Background Jobs | Solid Queue (Active Job) |

---

## 🗂️ Architecture Overview

app/
├── models/       # Article, AiAnalysis, NarrativeArc, NarrativeRoute, Entity,
│                 # NarrativeSignature, ContradictionLog, SourceCredibility,
│                 # IntelligenceReport, IntelligenceBrief, GdeltEvent, Region, Country
├── services/     # AnalysisPipeline, OpenRouterClient, RagAgent, EmbeddingService,
│                 # GeolocatorService, ArticleNetworkService, EntityExtractionService,
│                 # ContradictionDetectionService, NarrativeRouteGeneratorService,
│                 # IntelligenceSearchService, RegionalAnalysisService + more
├── jobs/         # Background jobs for NewsAPI/GDELT polling, AI analysis, embedding gen
├── channels/     # GlobeChannel, AlertsChannel, SearchChannel (ActionCable)
├── controllers/  # PagesController, ArticlesController, Api::SearchController + more
└── javascript/
    └── controllers/ # Stimulus controllers: globe, timeline, perspective, search,
                     # narrative_dna, entity_nexus, tribunal, voice_orb, consciousness


---

## 🔑 Critical Commands

```bash
# Development
rails s                          # start dev server
rails c                          # Rails console
rails db:migrate                 # run pending migrations
rails db:seed                    # seed dev data

# Heroku (Production)
git push heroku main             # deploy
heroku run rails db:migrate      # production migrations
heroku logs --tail               # live logs
heroku run rails c               # production console

# Testing (Minitest)
bin/rails test                   # run all tests
bin/rails test test/models/      # run model tests only
bin/rails test test/services/    # run service tests only

# Branch workflow
git checkout -b olli/<feature>   # new feature branch
