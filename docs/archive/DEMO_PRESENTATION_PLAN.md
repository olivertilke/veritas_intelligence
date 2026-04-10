# VERITAS Demo Presentation Plan

**Date:** Friday, 21 March 2026
**Duration:** 8 minutes
**Presenter:** Vince

---

## Pre-Demo Setup

- [ ] Seed with curated data: `NEWS_API_KEY= rails db:seed`
- [ ] Verify Voice Orb audio works on presentation machine/speakers
- [ ] Pre-select hero article: **"NATO warships enter Black Sea amid rising tensions with Russian naval forces"** (Reuters)
- [ ] Pre-load the AWARE page in a browser tab for fast navigation
- [ ] Close unnecessary browser tabs — Globe.gl needs GPU headroom
- [ ] App should be in **DEMO mode** (default) — zero API calls, instant responses

---

## ACT 1: The Hook (0:00 – 1:30)

> **"What if you could see lies spreading in real-time?"**

| Time | Action | What to say |
|------|--------|-------------|
| 0:00 | Start on landing page | Deliver pitch: *VERITAS is a radar for truth — it doesn't tell you what's happening, it shows you HOW the world is talking about it* |
| 0:20 | Sign in → Dashboard loads | The 3-panel war room appears — globe spins up with live data points |
| 0:40 | **Let the globe breathe** — don't click anything | Point out the arcs flowing between countries. *"Each arc is a narrative route — a story traveling from origin to amplification"* |
| 1:00 | Hover over a bright arc | *"The color and thickness show manipulation score — how much the story mutated as it spread"* |

**Goal:** Visual spectacle. Let the globe sell itself. Don't rush.

---

## ACT 2: The Intelligence Layer (1:30 – 3:30)

> **"Let's look under the hood"**

| Time | Action | What to say |
|------|--------|-------------|
| 1:30 | Click the NATO/Black Sea article from the left feed | *"Every article is analyzed by 3 independent AI agents"* |
| 1:50 | Show the AI analysis panel (Analyst → Sentinel → Arbiter) | *"The Analyst reads it. The Sentinel flags threats. The Arbiter delivers a verdict. They disagree with each other — that's by design."* |
| 2:20 | Open the **Tribunal** for that article | *"The Tribunal synthesizes all three into a single intelligence assessment — threat level, trust score, geopolitical classification"* |
| 2:50 | Click into **Narrative DNA** | *"This is Narrative DNA — it traces how a single story mutated as it crossed borders. Original → amplified → distorted → neutralized"* |
| 3:15 | Point out the force-directed graph nodes | *"Each node is a version of the same story. The further apart they drift, the more the narrative was manipulated"* |

**Goal:** Show depth. The audience should think *"this is real intelligence, not a toy."*

### Hero Article Chain (for reference)

The NATO Black Sea storyline has 6 articles from different sources, each framing the same event differently:

1. **Reuters** (trust 88) — Neutral factual reporting of NATO deployment
2. **RT** (trust 42) — Claims NATO provocation, territorial encroachment
3. **BBC** (trust 85) — Ukraine welcomes NATO presence as long overdue
4. **AP** (trust 91) — Satellite imagery contradicts Russian claims
5. **Xinhua** (trust 55) — China urges restraint, frames NATO as aggressor
6. **Fox News** (trust 58) — Frames it as Biden "sleepwalking into WWIII"

**Contradiction highlights:**
- AP satellite data vs RT territorial claims (severity: 0.95)
- Reuters buffer zone report vs RT encroachment claim (severity: 0.92)

---

## ACT 3: The Differentiator (3:30 – 5:30)

> **"Now watch what happens when we change perspective"**

| Time | Action | What to say |
|------|--------|-------------|
| 3:30 | Go back to globe, open **Perspective Slider** | *"Every story looks different depending on who's telling it"* |
| 3:45 | Switch to **China State Media** perspective | *"This is how Chinese state media frames these events"* — arcs and heatmaps shift |
| 4:10 | Switch to **Russia State Media** | *"And here's Russia's version"* — watch the globe transform again |
| 4:30 | Switch to **US Liberal** or **US Conservative** | *"Even within one country, the narrative diverges"* |
| 4:50 | Show a **Contradiction** (e.g., RT vs AP on Black Sea) | *"VERITAS automatically detects when sources directly contradict each other and scores the severity"* |
| 5:15 | Show **Source Credibility** score on RT vs Reuters | *"Every source builds a rolling trust score over time — the system gets smarter with every article it processes"* |

**Goal:** This is the "Palantir for the people" moment. Perspective shift is the killer feature.

---

## ACT 4: The Intelligence Brief (5:30 – 6:30)

> **"VERITAS doesn't just analyze — it briefs you"**

| Time | Action | What to say |
|------|--------|-------------|
| 5:30 | Open **Intelligence Reports** (regional) | *"Each region gets a live threat verdict — STABLE, GUARDED, ELEVATED, or SEVERE"* |
| 5:50 | Show one report detail | Point out signal stats, the verdict reasoning |
| 6:10 | Show **Intelligence Brief** (daily) | *"Every day, VERITAS writes its own executive briefing — what changed, what's emerging, what to watch"* |

**Goal:** Show compounding intelligence. This isn't a snapshot — it's a system that learns.

---

## ACT 5: The Closer (6:30 – 8:00)

> **"And VERITAS knows what it knows"**

| Time | Action | What to say |
|------|--------|-------------|
| 6:30 | Navigate to **AWARE** | *"We built a self-awareness layer. VERITAS can narrate its own state — what it's confident about, where it has gaps, what it's watching"* |
| 7:00 | Trigger the **Voice Orb** | Let VERITAS speak. The ElevenLabs voice delivers a self-narration. **Let it play for 20-30 seconds.** |
| 7:30 | Return to globe, let it spin | Deliver closing line |
| 7:45 | **Closing statement** | *"We cannot stop people from lying on the internet. But with VERITAS, we can make sure they can never hide in the dark again."* |

**Goal:** Mic drop. The voice narration is cinematic. End on the tagline.

---

## Timing Buffer

You have ~15 seconds of buffer built in. If something loads slowly, **skip Act 4** (Intelligence Brief) and go straight from contradictions → AWARE. The closer is non-negotiable.

---

## Emergency Fallbacks

| Problem | Fallback |
|---------|----------|
| Globe doesn't render | Switch to Flat Map view |
| Voice Orb audio fails | Read the AWARE self-narration text manually — it's still compelling |
| Narrative DNA doesn't load | Skip to Perspective Slider — it's the stronger feature anyway |
| Article analysis is slow | Pre-click the hero article before the demo so it's cached |
| Lost for time | Cut Act 4 entirely — go from contradictions straight to AWARE |

---

## Key Numbers to Drop

Use these stats naturally during the presentation:

- **46 curated intelligence signals** across 11 regions and 60 countries
- **3 independent AI agents** analyzing every article (Analyst, Sentinel, Arbiter)
- **6 perspective lenses** (US Liberal, US Conservative, China State, Russia State, Western Mainstream, Global South)
- **20 cross-source contradictions** detected and severity-scored
- **21 source credibility profiles** with rolling trust scores
- **4 narrative signature clusters** (Military, Trade, Diplomacy, Cyber)
- **8 interconnected storylines** spanning Black Sea, Taiwan, Iran, cyber warfare, Sahel, Red Sea, US elections, BRICS
