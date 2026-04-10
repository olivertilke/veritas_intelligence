# Perfect Storm — Expected Visual & Intelligence Output

**Scenario:** Operation Silk Shadow  
**Event:** China launches unprecedented naval exercises near Taiwan (April 7–10, 2026)  
**Seed tag:** `source_url LIKE 'perfect-storm://%'`  
**Run:** `rails runner db/seeds/perfect_storm.rb`  
**Test:** `bin/rails test test/integration/perfect_storm_test.rb`

---

## Quick Reference: The 12 Articles

| Key | Source | Country | Published | Threat | Sentiment | Role |
|-----|--------|---------|-----------|--------|-----------|------|
| A1 | Xinhua | China | Apr 7 08:00 | NEGLIGIBLE | Neutral | **ORIGIN** — "routine drills" |
| A2 | Reuters | UK | Apr 7 10:30 | HIGH | Bearish | Hop 2 — Western amplification |
| A3 | RT International | Russia | Apr 7 14:00 | HIGH | Hostile | Hop 3 — US provocation distortion |
| A4 | Fox News | USA | Apr 8 09:00 | MODERATE | Negative | Domestic politics angle |
| A5 | AP News | USA | Apr 7 16:00 | **CRITICAL** | Very Negative | Corroborates scale, CONTRADICTS A1 |
| A6 | Global Times | China | Apr 7 18:00 | LOW | Neutral | Contradiction pair 2 (vs A5) |
| A7 | Al Jazeera | Qatar | Apr 8 06:00 | MODERATE | Negative | ASEAN regional reaction |
| A8 | The Hindu | India | Apr 8 12:00 | LOW | Neutral | India/Global South lens |
| A9 | The Guardian | UK | Apr 9 07:00 | **CRITICAL** | Very Negative | Hop 4 — escalation confirmed |
| A10 | TASS | Russia | Apr 9 09:00 | HIGH | Hostile | Russian echo chamber |
| A11 | Sputnik | Russia | Apr 9 11:00 | HIGH | Hostile | Russian echo chamber |
| A12 | BBC Sport | UK | Apr 8 14:00 | NEGLIGIBLE | Positive | **ORPHAN** — cricket, nil coords |

---

## Globe View

### Points (Globe.gl `points` layer)

11 points should render on the globe — A12 (BBC Sport) has nil coordinates and will be **filtered out** by the `null_island?` and `valid_coordinates?` guards in `globe_data`.

| Point | Location | Color (sentiment) | Size |
|-------|----------|------------------|------|
| A1 Xinhua | Beijing (39.9°N, 116.4°E) | `#38bdf8` (cyan/neutral) | 0.4 |
| A2 Reuters | London (51.5°N, -0.1°E) | `#ef4444` (red/bearish) | 0.4 |
| A3 RT | Moscow (55.8°N, 37.6°E) | `#dc2626` (dark red/hostile) | 0.4 |
| A4 Fox News | New York (40.7°N, -74.0°E) | `#f97316` (orange/negative) | 0.4 |
| A5 AP | Washington DC (38.9°N, -77.0°E) | `#dc2626` (dark red/very negative) | 0.4 |
| A6 Global Times | Beijing (39.9°N, 116.4°E) | `#38bdf8` (cyan/neutral) | 0.4 |
| A7 Al Jazeera | Doha (25.3°N, 51.5°E) | `#f97316` (orange/negative) | 0.4 |
| A8 The Hindu | New Delhi (28.6°N, 77.2°E) | `#38bdf8` (cyan/neutral) | 0.4 |
| A9 The Guardian | London (51.5°N, -0.1°E) | `#dc2626` (dark red/very negative) | 0.4 |
| A10 TASS | Moscow (55.8°N, 37.6°E) | `#dc2626` (dark red/hostile) | 0.4 |
| A11 Sputnik | Moscow (55.8°N, 37.6°E) | `#dc2626` (dark red/hostile) | 0.4 |

**Two points stack at Beijing** (A1 + A6), **two at London** (A2 + A9), **three at Moscow** (A3, A10, A11). The globe should show visible clusters at these locations.

### Heatmap Layer

The thermal overlay will show:
- **Taiwan Strait region** (24°N, 122°E): hottest zone — GDELT event A9 has goldstein_scale -9.0, quad_class 4. No direct article point, but heatmap weight extends from surrounding articles.
- **East Asia cluster**: Beijing × 2 articles, hot due to A5 (CRITICAL threat)
- **Moscow cluster**: 3 articles × HIGH threat, hostile sentiment → visible hot zone
- **Washington DC / New York**: A4 + A5 → moderate heat
- **London**: A2 (HIGH) + A9 (CRITICAL) → hot

### Arc Layer (ArticleNetworkService)

When `/api/article_network/global` is called, `ArticleNetworkService#connections_between` will compute arcs between the 11 geolocated articles. Expected arc inventory:

#### Narrative Route Arcs (strength: 1.0 — dominant type, red/orange color)

| Arc | Route | Framing | Color |
|-----|-------|---------|-------|
| A1 → A2 | Main chain hop 1→2 | original → amplified | Orange-red |
| A2 → A3 | Main chain hop 2→3 | amplified → distorted | Red |
| A3 → A9 | Main chain hop 3→4 | distorted → amplified | Orange-red |
| A3 → A10 | Russia echo hop 1→2 | original → amplified | Orange |
| A10 → A11 | Russia echo hop 2→3 | amplified → amplified | Orange |

#### GDELT Event Arcs (strength: 0.8 — China/Taiwan actor pair)

| Arc | Shared Actor Pair | CAMEO Code | Goldstein |
|-----|------------------|------------|-----------|
| A1 ↔ A2 | CHN → TWN | 15 (Exhibit force) | -3.5 / -5.0 |
| A1 ↔ A5 | CHN → TWN | 15 / 153 | -3.5 / -7.0 |
| A2 ↔ A5 | CHN → TWN | 15 / 153 | -5.0 / -7.0 |
| A3 ↔ A10 | RUS → USA | 131 (Threaten) | -4.0 / -3.8 |
| A3 ↔ A11 | RUS → USA | 131 | -4.0 / -3.5 |
| A10 ↔ A11 | RUS → USA | 131 | -3.8 / -3.5 |
| A7 ↔ A8 | ASEAN/IND → CHN | 036 (Appeal) | +1.0 / +0.8 |

#### Shared Entity Arcs (strength: 0.3 — entity co-mention)

The strongest entity connections come from **Xi Jinping** (appears in 8 articles) and **Taiwan** as country entity (appears in 11 articles). The `shared_entities` connection requires ≥2 shared entities between a pair. Key pairs:

| Arc | Shared Entities |
|-----|----------------|
| A1 ↔ A3 | Xi Jinping, PLA, China |
| A1 ↔ A6 | Xi Jinping, PLA, PLA Eastern Theater Command, China |
| A2 ↔ A5 | Taiwan Ministry of Defense, PLA, China, Taiwan |
| A3 ↔ A10 | Xi Jinping, China, Taiwan, Maria Zakharova |
| A5 ↔ A9 | USS Ronald Reagan, US Pentagon, Taiwan Ministry of Defense |
| A7 ↔ A8 | Xi Jinping, ASEAN, China, Taiwan |

#### Multi-Type Arcs (highest strength — multiple signals)

The following arcs will have multiple connection types and thus highest combined strength (appearing first in the sorted arc list):

| Arc | Types | Combined Strength |
|-----|-------|------------------|
| A1 ↔ A2 | narrative_route + gdelt_event + shared_entities | ~1.0 (capped) |
| A2 ↔ A5 | gdelt_event + embedding_similarity + shared_entities | ~0.85 |
| A3 ↔ A10 | narrative_route + gdelt_event + embedding_similarity + shared_entities | ~1.0 (capped) |
| A3 ↔ A11 | narrative_route + gdelt_event + embedding_similarity + shared_entities | ~1.0 (capped) |
| A10 ↔ A11 | narrative_route + gdelt_event + embedding_similarity + shared_entities | ~1.0 (capped) |

**Arc colors** (veritasThreatScore-derived):
- Score ≥ 7: `#ff4444` (red) — A9 arcs, A5 arcs
- Score ≥ 5: `#ff8c00` (orange) — A2 arcs, A3 arcs
- Score ≥ 3: `#ffd700` (yellow) — A4, A7, A8 arcs
- Score < 3: `#6088a0` (grey-blue) — A7 ↔ A8 (positive Goldstein, de-escalation)

**A12 (BBC Sport) appears in ZERO arcs.** This is the control case — confirm no arc starts or ends at nil coordinates.

---

## Narrative DNA Panel

Click any article on the globe to open the Narrative DNA panel. Expected state per article:

### A1 — Xinhua (ORIGIN)
- **Route displayed:** "Operation Silk Shadow: Beijing → London → Moscow → London"
- **Total hops:** 4 | **Hop index:** 0 (origin)
- **Manipulation score:** LOW (starts at 10/100)
- **Framing label:** ORIGINAL
- **Journey color:** Green (#22c55e)
- **Propagation speed:** 1200 km/h
- **Countries reached:** China → UK → Russia → UK

### A3 — RT International (DISTORTION NODE)
- **Route displayed:** Main chain (hop 3) + Russia echo chain (hop 1)
- **Framing label at hop 3:** CONCERNING (score ~34/100 after distortion)
- **Journey color:** Amber (#f59e0b blending toward red)
- **Drift intensity:** High (framing_shift = "distorted")
- **Sentiment shift:** Neutral → Hostile (delta: -1.5)

### A9 — The Guardian (ESCALATION, HOP 4)
- **Route:** Final hop of main chain
- **Framing label:** AMPLIFIED
- **Threat level:** CRITICAL
- **GDELT enrichment:** gdeltGoldsteinScale: -9.0, gdeltQuadClassLabel: "Material Conflict"
- **veritasThreatScore:** ~8.5 (CRITICAL threat context + high drift + GDELT conflict bonus)
- **Arc color:** Red (#ff4444 via score_color)

### A12 — BBC Sport (ORPHAN)
- **No narrative route displayed** (no NarrativeArc record)
- **No connections panel** (zero entity mentions → no entity arcs)
- **Coordinates:** nil → not plotted on globe at all
- **Expected:** The DNA panel shows "No narrative route data available" state

---

## Threat Matrix Panel

The Threat Matrix (sidebar) should surface articles ordered by threat severity then narrative richness:

| Rank | Article | Threat | Trust | Arcs |
|------|---------|--------|-------|------|
| 1 | AP: Taiwan Military Says Drills Largest in 30 Years | CRITICAL | 88 | ✓ |
| 2 | The Guardian: US Carrier Group Moves Toward Taiwan | CRITICAL | 85 | ✓ |
| 3 | Reuters: China Launches Largest Military Drills | HIGH | 78 | ✓ |
| 4 | RT: US Provocations Forced Beijing's Hand | HIGH | 31 | ✓ |
| 5 | TASS: US Military Escalation Near China's Border | HIGH | 28 | ✓ |
| 6 | Sputnik: Pentagon Confirms Carrier Deployment | HIGH | 27 | ✓ |
| 7 | Fox News: China's Taiwan Provocation | MODERATE | 55 | – |
| 8 | Al Jazeera: Asian Nations Urge Restraint | MODERATE | 74 | – |
| 9 | The Hindu: India Monitors Taiwan Strait | LOW | 80 | – |
| 10 | Global Times: Taiwan Authorities Downplay PLA | LOW | 29 | ✓ |
| 11 | Xinhua: PLA Conducts Routine Naval Exercises | NEGLIGIBLE | 62 | ✓ |
| 12 | BBC Sport: England Set New Test Cricket Record | NEGLIGIBLE | 91 | – |

---

## Entity Nexus Graph

The Entity Nexus force-directed graph (`/api/entity_nexus`) should display:

### Nodes (10 entities)

| Entity | Type | Color | Mention Count | Expected Size |
|--------|------|-------|---------------|---------------|
| Xi Jinping | person | `#38bdf8` (cyan) | 8 | Large |
| China | country | `#22c55e` (green) | 10 | Largest |
| Taiwan | country | `#22c55e` (green) | 11 | Largest |
| People's Liberation Army | organization | `#a78bfa` (purple) | 6 | Large |
| Taiwan Ministry of Defense | organization | `#a78bfa` (purple) | 4 | Medium |
| US Pentagon | organization | `#a78bfa` (purple) | 4 | Medium |
| USS Ronald Reagan | organization | `#a78bfa` (purple) | 3 | Medium |
| ASEAN | organization | `#a78bfa` (purple) | 2 | Small |
| Maria Zakharova | person | `#38bdf8` (cyan) | 2 | Small |
| PLA Eastern Theater Command | organization | `#a78bfa` (purple) | 3 | Medium |

### Expected Graph Shape
- **Central hub:** China and Taiwan are most connected (appear in almost every article)
- **Xi Jinping** has high betweenness centrality (connects the China, Russia, and Western clusters)
- **Strong edge:** Xi Jinping ↔ PLA (co-appear in A1, A3, A6, A9, A10)
- **Isolated cluster:** ASEAN ↔ Taiwan Ministry of Defense (only appear together in A7)
- **No connection to BBC Sport cluster** (A12 has zero entity mentions)

### Clicking Xi Jinping
Expected detail response (`/api/entity_nexus/:id`):
- `mentions_count`: 8
- `connected_entities`: PLA, China, Taiwan, Maria Zakharova, Taiwan Ministry of Defense
- Top 8 articles: A1, A3, A6, A7, A8, A9, A10, A11
- Sentiment breakdown: ~25% Neutral, ~62% Negative/Hostile, ~0% Positive

---

## Contradiction Panel (AWARE System)

The AWARE page (`/aware`) and Contradiction panel should list:

### Contradiction 1 — Severity: 0.92 (CRITICAL)
- **Type:** cross_source
- **Source A:** Xinhua | **Source B:** AP News
- **Conflict:** Xinhua calls drills "routine and scheduled"; AP News, citing DIA satellite imagery, reports them as "largest in 30 years" — Taiwan activated full combat alert
- **Embedding similarity:** 0.71 (same topic, opposing conclusions)

### Contradiction 2 — Severity: 0.85 (HIGH)
- **Type:** cross_source
- **Source A:** AP News | **Source B:** Global Times
- **Conflict:** AP reports Taiwan "full combat alert" with general saying "rehearsal for invasion"; Global Times simultaneously reports Taiwan authorities are "downplaying to prevent panic"
- **Embedding similarity:** 0.73

These two contradictions should appear in `ContradictionLog.recent.limit(10)` on the AWARE page.

---

## AI Tribunal (War Room)

Clicking any article opens the Tribunal panel (`/api/tribunal/:article_id`). Expected verdicts:

### A1 (Xinhua) — Tribunal
- **Analyst (Gemini):** Flags minimizing language. "Routine" framing unsupported by scale metrics.
- **Sentinel (GPT):** Cross-reference with satellite data shows 50+ warship deployment. Inconsistent with routine designation.
- **Arbiter (Claude):** Verdict — DISTORTION DETECTED. China's official framing contradicts independently verifiable scale data from multiple Western intelligence sources.
- **Trust score:** 62 (Mixed)

### A3 (RT) — Tribunal
- **Analyst:** Notes inversion of agency — article frames China as reactive rather than initiating.
- **Sentinel:** Linguistic anomaly flag triggered. Loaded framing ("US encirclement", "NATO adventurism") without sourced attribution.
- **Arbiter:** Verdict — NARRATIVE MANIPULATION DETECTED. Systematic blame inversion technique common to Russian state media. Anomaly flag confirmed.
- **Trust score:** 31 (Questionable) | Anomaly flag: TRUE

### A9 (Guardian) — Tribunal
- **Analyst:** Corroborates A5 (AP) on carrier deployment. Official Pentagon confirmation sourced.
- **Sentinel:** ADIZ violation count (47 incursions) is verifiable via Taiwan MoD reports. Consistent with other sources.
- **Arbiter:** Verdict — HIGH CREDIBILITY. Multi-source corroboration. No linguistic anomalies.
- **Trust score:** 85 (Trusted)

### A12 (BBC Sport) — Tribunal
- **All agents:** Content is sports journalism with no geopolitical relevance.
- **Arbiter:** No threat assessment applicable. NEGLIGIBLE threat level confirmed.
- **Trust score:** 91 (Trusted) — accurate reporting of a sporting event

---

## Narrative Signatures (AWARE System)

Three signatures should appear in the AWARE `@signatures` list:

### 1. China Minimization Pattern — Operation Silk Shadow
- **Match count:** 2 articles (Xinhua A1, Global Times A6)
- **Avg trust score:** 45.5
- **Dominant threat:** LOW
- **Status:** DORMANT (last_seen_at is April 7, 2026 → >6 hours ago)
- **Source distribution:** `{ "Xinhua" => 1, "Global Times" => 1 }`

### 2. Western Escalation Framing — Taiwan Strait Crisis
- **Match count:** 3 articles (Reuters A2, AP A5, Guardian A9)
- **Avg trust score:** 83.7
- **Dominant threat:** CRITICAL
- **Status:** DORMANT (last event April 9, 2026)
- **Source distribution:** `{ "Reuters" => 1, "AP News" => 1, "The Guardian" => 1 }`

### 3. Russian Counter-Narrative Echo Chamber — US Provocation Framing
- **Match count:** 3 articles (RT A3, TASS A10, Sputnik A11)
- **Avg trust score:** 28.7 — **lowest of all signatures**
- **Dominant threat:** HIGH
- **Status:** DORMANT (last event April 9, 2026)
- **Source distribution:** `{ "RT International" => 1, "TASS" => 1, "Sputnik" => 1 }`
- **Note:** All three articles published within 3 hours from Moscow — coordinated amplification pattern

---

## Source Credibility Panel

Expected `SourceCredibility` grades on the AWARE page:

| Source | Grade | Label | Notes |
|--------|-------|-------|-------|
| BBC Sport | 92 | TRUSTED | Sports reporting — high accuracy |
| AP News | 89 | TRUSTED | Wire service, sourced reporting |
| The Guardian | 83 | TRUSTED | Multi-source corroboration |
| Reuters | 86 | TRUSTED | Wire service |
| The Hindu | 80 | TRUSTED | Calibrated regional reporting |
| Al Jazeera | 74 | RELIABLE | Some editorial framing |
| Fox News | 52 | MIXED | Domestic politics angle |
| Xinhua | 45 | MIXED | State media, minimizing language |
| Global Times | 22 | QUESTIONABLE | State media, anomaly flagged |
| RT International | 18 | UNRELIABLE | Anomaly flag + blame inversion |
| TASS | 16 | UNRELIABLE | Anomaly flag |
| Sputnik | 15 | UNRELIABLE | Anomaly flag + coordinated timing |

---

## Breaking Alert

One breaking alert should appear in the system:

- **Headline:** "PLA Exercises Near Taiwan — US Carrier Group Repositioned | VERITAS CRITICAL"
- **Severity:** 4 (maximum)
- **Location:** Taiwan Strait (24°N, 122°E)
- **Expected display:** Red pulse on the globe at Taiwan Strait coordinates
- **Briefing:** Summarizes the scenario, flags Russian state media distortion pattern

---

## Visual Verification Checklist

Run this checklist after loading the seed and opening the app:

### Globe
- [ ] 11 points visible (A12 absent — nil coords)
- [ ] 3-point cluster visible at Moscow
- [ ] 2-point cluster visible at London
- [ ] 2-point cluster visible at Beijing
- [ ] Heatmap hot zone over East Asia / Taiwan Strait
- [ ] Arc from Beijing → London (A1→A2, narrative route, orange)
- [ ] Arc from London → Moscow (A2→A3, narrative route, red — distortion)
- [ ] Arc from Moscow → London (A3→A9, narrative route, red)
- [ ] Arc cluster around Moscow (A3↔A10↔A11, Russia echo, orange)
- [ ] Arc between Beijing and Washington DC (A1↔A5, GDELT China/Taiwan)
- [ ] Arc between Doha and New Delhi (A7↔A8, GDELT Verbal Appeal, grey-blue)
- [ ] NO arc involving BBC Sport (orphan isolation confirmed)

### Threat Matrix sidebar
- [ ] A5 (AP, CRITICAL) at top
- [ ] A9 (Guardian, CRITICAL) second
- [ ] A12 (BBC Sport, NEGLIGIBLE) at bottom with Positive sentiment marker

### Entity Nexus
- [ ] 10 nodes render
- [ ] China and Taiwan are largest nodes
- [ ] Xi Jinping in top 3 by size
- [ ] No node connected only to A12

### AWARE System
- [ ] 2 contradictions listed
- [ ] 3 narrative signatures listed
- [ ] Russian echo signature has lowest trust score
- [ ] 1 breaking alert showing CRITICAL severity

### Tribunal (click A3 — RT)
- [ ] Linguistic anomaly flag shown
- [ ] Trust score ~31
- [ ] Arbiter verdict mentions distortion or manipulation

---

## What This Scenario Proves

If all checklist items pass, the following VERITAS subsystems are confirmed operational:

1. **Data ingestion** — Articles created with correct metadata, geo, and embeddings
2. **AI analysis pipeline** — Threat/sentiment/trust scores correctly persisted
3. **NLP / Entity Extraction** — 10 entities correctly linked across 11 articles
4. **pgvector similarity** — Russian cluster articles connect via embedding; BBC Sport does not
5. **NarrativeRouteGenerator** — 4-hop and 3-hop routes built from hop data
6. **ArticleNetworkService** — All 4 connection types fire; strength ordering is correct
7. **GDELT enrichment** — Actor pairs generate connections; quad_class 4 boosts arc scores
8. **ContradictionDetection** — 2 factual contradictions detected with correct severity
9. **NarrativeSignature** — 3 distinct narrative clusters classified
10. **SourceCredibility** — Trust gradient from 92 (BBC) to 15 (Sputnik) correctly assigned
11. **Globe rendering** — Points, arcs, heatmap, regions all render from live data
12. **Orphan isolation** — A12 (BBC Sport) has zero connections to the geopolitical cluster

**The Perfect Storm is the engine test. If this renders, VERITAS is real.**
