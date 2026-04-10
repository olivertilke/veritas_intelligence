# VERITAS User Stories

**Last updated:** 10 April 2026
**Total:** 28 user stories | ✅ 26 DONE | 🔮 2 PLANNED

---

## Core Intelligence

### 1. ✅ 3D Globe Visualization
**As an** analyst, **I can** view a real-time 3D globe with article data points color-coded by sentiment, **so that** I can immediately see where narrative activity is concentrated globally.

**Implementation:** Globe.gl + Three.js, `globe_controller.js`, points sized by threat level, colored by sentiment (green=bullish, red=bearish, cyan=neutral).

---

### 2. ✅ Narrative Route Arcs
**As an** analyst, **I can** see animated arcs on the globe showing how narratives propagate from origin countries to destination countries, **so that** I can trace disinformation routes visually.

**Implementation:** `NarrativeRoute` model (488 LOC), ARCWEAVER 2.0 generator, arcs colored by manipulation score, animated packet flow.

---

### 3. ✅ Perspective Slider
**As an** analyst, **I can** switch between geopolitical perspectives (US Liberal, US Conservative, China State, Russia State, Western Mainstream, Global South), **so that** I can see how the same events are framed differently by different media ecosystems.

**Implementation:** `PerspectiveFilter` model, `perspective_controller.js`, 6 pre-configured filters with source keyword matching.

---

### 4. ✅ Timeline Slider
**As an** analyst, **I can** scrub through time using a timeline slider, **so that** I can see how narratives evolved and when key shifts occurred.

**Implementation:** `timeline_controller.js`, filters articles and arcs by `published_at` range.

---

### 5. ✅ TRIAD AI Analysis Pipeline
**As an** analyst, **I can** see every article analyzed by 3 independent AI agents (Analyst, Sentinel, Arbiter), **so that** I get a multi-perspective intelligence assessment rather than a single-model opinion.

**Implementation:** `AnalysisPipeline` service, `AnalystAgent`, `SentinelAgent`, `ArbiterAgent`, all routed through `OpenRouterClient`. Analyst assigns topic/sentiment/threat. Sentinel flags anomalies/bias. Arbiter resolves disagreements.

---

### 6. ✅ Tribunal Verdict
**As an** analyst, **I can** view a synthesized tribunal verdict for any article, **so that** I get a single authoritative intelligence assessment combining all three agents' findings.

**Implementation:** `TribunalService` (174 LOC), `tribunal_controller.js`, synthesizes stored JSONB agent responses into war-room prose.

---

### 7. ✅ Narrative DNA
**As an** analyst, **I can** view a force-directed graph showing how a single story mutated as it crossed borders and sources, **so that** I can trace narrative manipulation from origin to amplification to distortion.

**Implementation:** `NarrativeDnaService`, `narrative_dna_controller.js` (D3.js), nodes represent article versions, edges show semantic drift.

---

### 8. ✅ Narrative Surge Detection
**As an** analyst, **I can** be alerted when a sudden amplification spike is detected for a narrative, **so that** I can identify coordinated information campaigns in real-time.

**Implementation:** `NarrativeSurgeDetectorService` (251 LOC), `API::SurgeChecksController`.

---

### 9. ✅ Narrative Signature Clustering
**As an** analyst, **I can** see recurring narrative patterns grouped into semantic clusters, **so that** I can identify when the same narrative is being recycled or repurposed across different sources.

**Implementation:** `NarrativeSignature` model, `NarrativeSignatureClusterJob`, pgvector centroid matching with cosine distance.

---

### 10. ✅ Contradiction Detection
**As an** analyst, **I can** see when two sources directly contradict each other on the same event, with a severity score, **so that** I can identify where the information landscape is most contested.

**Implementation:** `ContradictionLog` model, `ContradictionDetectionService` (157 LOC), severity scoring based on embedding distance and threat level.

---

### 11. ✅ Source Credibility Scoring
**As an** analyst, **I can** view a rolling trust score for each news source, **so that** I can calibrate my trust in reporting based on historical accuracy and anomaly patterns.

**Implementation:** `SourceCredibility` model (85 LOC), `SourceCredibilityService`, exponential moving average (alpha=0.1), anomaly rate tracking, coordination flags.

---

### 12. ✅ Embedding Drift Detection
**As an** analyst, **I can** see when narrative clusters semantically shift over time, **so that** I can detect when framing of a story is being gradually manipulated.

**Implementation:** `EmbeddingSnapshot` model, `EmbeddingDriftService` (105 LOC), `CaptureEmbeddingSnapshotJob`.

---

## Analyst Workflows

### 13. ✅ War-Room Dashboard
**As an** analyst, **I can** view a 3-panel dashboard (article feed | globe | threat matrix), **so that** I have a unified operational view of the global narrative landscape.

**Implementation:** `pages/home.html.erb`, responsive 3-panel layout, real-time updates via ActionCable.

---

### 14. ✅ Article Feed & Detail View
**As an** analyst, **I can** browse articles in a sidebar feed and click to see full content with AI analysis, **so that** I can drill into specific intelligence signals.

**Implementation:** `ArticlesController`, `articles/show.html.erb`, sidebar with sentiment-colored indicators.

---

### 15. ✅ Semantic Vector Search
**As an** analyst, **I can** search for articles using natural language and get semantically relevant results (not just keyword matches), **so that** I can find related intelligence even when different terminology is used.

**Implementation:** `IntelligenceSearchService` (135 LOC), `RagAgent` (367 LOC), pgvector nearest-neighbor search, `SearchChannel` for real-time results.

---

### 16. ✅ Intelligence Reports (Regional)
**As an** analyst, **I can** view threat assessments per region with a verdict (STABLE / GUARDED / ELEVATED / SEVERE), **so that** I can prioritize my attention on the most dangerous areas.

**Implementation:** `IntelligenceReport` model (106 LOC), `RegionalAnalysisService` (322 LOC), signal stats and verdict reasoning.

---

### 17. ✅ Intelligence Briefs
**As an** analyst, **I can** read AI-generated daily, weekly, or alert-level intelligence briefings, **so that** I get a concise executive summary of what VERITAS has learned.

**Implementation:** `IntelligenceBrief` model, `GenerateIntelligenceBriefJob`, covers narrative trends, contradictions, blind spots, source alerts, confidence map.

---

### 18. ✅ Breaking Alerts
**As an** analyst, **I can** receive real-time breaking alerts when significant narrative anomalies are detected, **so that** I can respond to emerging threats immediately.

**Implementation:** `BreakingAlert` model (60 LOC), `BreakingAlertBroadcastService`, `AlertsChannel` (ActionCable), globe pulse ring animation.

---

### 19. ✅ Entity Extraction & Nexus Graph
**As an** analyst, **I can** see named entities (people, organizations, countries, events) extracted from articles and their relationship network, **so that** I can understand who is connected to what and how influence flows.

**Implementation:** `Entity` model (50 LOC), `EntityMention`, `EntityExtractionService`, `EntityNexusService` (250 LOC), `entity_nexus_controller.js`.

---

### 20. ✅ Trending Topics
**As an** analyst, **I can** see what topics are currently trending across the intelligence feed, **so that** I can quickly identify what the global narrative landscape is focused on.

**Implementation:** `API::TrendingTopicsController`.

---

### 21. ✅ Saved Articles / Watchlist
**As an** analyst, **I can** save articles to a personal watchlist, **so that** I can track specific intelligence signals over time.

**Implementation:** `SavedArticle` model, `SavedArticlesController`.

---

## Platform & Experience

### 22. ✅ AWARE (Self-Narration)
**As an** analyst, **I can** ask VERITAS to narrate its own state — what it's confident about, where it has blind spots, what it's watching, **so that** I understand the system's epistemic boundaries.

**Implementation:** `IntroSpectionService` (154 LOC), `pages/aware.html.erb`, `consciousness_controller.js`.

---

### 23. ✅ Voice Orb (ElevenLabs TTS)
**As an** analyst, **I can** hear VERITAS speak its analysis and self-narration aloud via a voice interface, **so that** I can consume intelligence hands-free or in a briefing-room setting.

**Implementation:** `ElevenLabsService`, `voice_orb_controller.js` (363 LOC), animated orb visualization.

---

### 24. ✅ DEMO / LIVE Mode Toggle
**As a** developer or presenter, **I can** toggle between DEMO mode (seeded data, zero API calls) and LIVE mode (real-time NewsAPI + AI analysis), **so that** the app works reliably for demonstrations without burning API quotas.

**Implementation:** `VeritasMode` concern, `API::ModeController`, `veritas_mode.rb` initializer.

---

### 25. ✅ Per-User AI Model Configuration
**As an** analyst, **I can** choose which AI models power each agent role (analyst, arbiter, sentinel, voice, briefing), **so that** I can customize the intelligence pipeline to my preferences.

**Implementation:** `UserModelConfig` model (83 LOC), `ModelConfigsController`, `model_settings_controller.js`.

---

### 26. ✅ Multiple View Modes (Globe / Flat Map / Heatmap)
**As an** analyst, **I can** switch between 3D globe, flat map, and heatmap visualizations, **so that** I can choose the view that best suits my analysis needs.

**Implementation:** `flat_map_controller.js`, `view_mode_controller.js`, `heatmap_toggle_controller.js`, `day_night_toggle_controller.js`.

---

### 27. ✅ Authentication & Admin Panel
**As an** admin, **I can** manage users, toggle admin roles, send invitations, and manually trigger narrative route generation, **so that** the platform is operationally managed.

**Implementation:** Devise authentication, Pundit authorization, `Admin::UsersController`, `Admin::NarrativeRoutesController`.

---

### 28. 🔮 Telegram Channel Monitoring
**As an** analyst, **I can** ingest and analyze messages from monitored Telegram channels, **so that** I can track narrative propagation through encrypted messaging platforms.

**Implementation:** `TelegramChannel` model, `TelegramReceiverJob`, Telegram-specific article fields (views, forwards, channel_id, message_id).
