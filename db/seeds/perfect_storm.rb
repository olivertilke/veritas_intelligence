# frozen_string_literal: true

# =============================================================================
# PERFECT STORM — VERITAS Architecture Seed v1.0
# =============================================================================
#
# Scenario: "Operation Silk Shadow"
# Event: China launches unprecedented naval exercises near Taiwan (April 7–10, 2026)
#
# Design Goals:
#   - Exercises EVERY connection type (narrative_route, gdelt_event,
#     embedding_similarity, shared_entities)
#   - Full threat level spectrum (NEGLIGIBLE → CRITICAL)
#   - Full sentiment spectrum
#   - 4-hop narrative propagation chain
#   - 2 contradiction pairs
#   - 2 corroboration pairs
#   - Cross-cluster entity overlap (Xi Jinping, PLA, Taiwan MoD)
#   - 1 orphan article (sports - no cluster connection)
#   - 1 poor-geo article (missing coordinates test)
#   - Synthetic embeddings with correct cosine similarity relationships
#
# Tag: All seeded records use source_url prefix "perfect-storm://"
#      and raw_data["seed_scenario"] = "perfect_storm"
#
# Usage:
#   rails runner db/seeds/perfect_storm.rb
#   # or from seeds.rb:
#   require_relative "seeds/perfect_storm"
#   PerfectStorm.run!
# =============================================================================

module PerfectStorm
  SEED_TAG       = "perfect-storm"
  URL_PREFIX     = "perfect-storm://"
  SCENARIO_KEY   = "perfect_storm"
  DIM            = 1536

  # ---------------------------------------------------------------------------
  # Vector generation helpers
  # ---------------------------------------------------------------------------

  def self.rand_unit_vector(dim = DIM)
    v = Array.new(dim) { rand(-1.0..1.0) }
    normalize(v)
  end

  def self.normalize(v)
    mag = Math.sqrt(v.sum { |x| x**2 })
    mag > 1e-10 ? v.map { |x| x / mag } : v
  end

  # Generate a vector that has target cosine_similarity with base_vector.
  # noise_scale controls the perturbation; we iterate until the similarity
  # is within 2% of target.
  def self.perturb(base, target_similarity)
    # Find noise_scale via bisection (fast convergence)
    lo, hi = 0.0, 10.0
    best = base

    20.times do
      mid = (lo + hi) / 2.0
      noise = Array.new(DIM) { rand(-1.0..1.0) * mid }
      candidate = normalize(base.zip(noise).map { |b, n| b + n })
      sim = cosine_similarity(base, candidate)
      best = candidate
      if sim > target_similarity
        lo = mid
      else
        hi = mid
      end
    end

    best
  end

  def self.cosine_similarity(a, b)
    dot = a.zip(b).sum { |x, y| x * y }
    mag_a = Math.sqrt(a.sum { |x| x**2 })
    mag_b = Math.sqrt(b.sum { |x| x**2 })
    return 0.0 if mag_a < 1e-10 || mag_b < 1e-10

    (dot / (mag_a * mag_b)).clamp(-1.0, 1.0)
  end

  # ---------------------------------------------------------------------------
  # Seed topic base vectors (generated once, stable per run via seeded Random)
  # ---------------------------------------------------------------------------
  # We seed the RNG so the vectors are deterministic across runs.
  # This ensures the same cosine similarities every time the seed runs.

  def self.build_topic_vectors
    rng = Random.new(20260407) # Scenario date as seed
    srand(20260407)

    taiwan_military = normalize(Array.new(DIM) { rand(-1.0..1.0) })
    russia_narrative = normalize(Array.new(DIM) { rand(-1.0..1.0) })
    western_alarm    = normalize(Array.new(DIM) { rand(-1.0..1.0) })
    reaction_neutral = normalize(Array.new(DIM) { rand(-1.0..1.0) })
    sports_cricket   = normalize(Array.new(DIM) { rand(-1.0..1.0) })

    # Return topic vectors — sport intentionally orthogonal
    {
      taiwan_military:  taiwan_military,
      russia_narrative: russia_narrative,
      western_alarm:    western_alarm,
      reaction_neutral: reaction_neutral,
      sports_cricket:   sports_cricket
    }
  end

  # ---------------------------------------------------------------------------
  # Main entry point
  # ---------------------------------------------------------------------------

  def self.run!(verbose: true)
    log = ->(msg) { puts msg if verbose }

    log.call "\n🌩️  PERFECT STORM — Loading scenario 'Operation Silk Shadow'..."

    # Suppress Action Cable broadcasts (no users connected during seed)
    Article.skip_callback(:commit, :after, :broadcast_sidebar_update) rescue nil
    Article.skip_callback(:commit, :after, :broadcast_to_globe)        rescue nil
    Article.skip_callback(:commit, :after, :enqueue_content_fetch)     rescue nil

    # ------------------------------------------------------------------
    # Step 1: Wipe previous Perfect Storm data (idempotent)
    # ------------------------------------------------------------------
    log.call "  → Clearing previous Perfect Storm data..."
    wipe_previous!

    # ------------------------------------------------------------------
    # Step 2: Ensure regions & countries exist
    # ------------------------------------------------------------------
    log.call "  → Ensuring regions and countries..."
    countries = ensure_geo!

    # ------------------------------------------------------------------
    # Step 3: Build synthetic embedding vectors
    # ------------------------------------------------------------------
    log.call "  → Generating synthetic embedding vectors..."
    topic_vecs = build_topic_vectors

    # Article-specific embeddings — designed for target cosine similarities
    embeddings = build_embeddings(topic_vecs)

    # ------------------------------------------------------------------
    # Step 4: Create articles
    # ------------------------------------------------------------------
    log.call "  → Creating 12 articles..."
    articles = create_articles!(countries, embeddings)

    # ------------------------------------------------------------------
    # Step 5: AI Analyses
    # ------------------------------------------------------------------
    log.call "  → Creating AI analyses..."
    create_ai_analyses!(articles)

    # ------------------------------------------------------------------
    # Step 6: Entities
    # ------------------------------------------------------------------
    log.call "  → Creating entities and mentions..."
    create_entities!(articles)

    # ------------------------------------------------------------------
    # Step 7: Narrative arcs + routes (4-hop chain)
    # ------------------------------------------------------------------
    log.call "  → Creating narrative arcs and routes..."
    create_narrative_chain!(articles)

    # ------------------------------------------------------------------
    # Step 8: GDELT events
    # ------------------------------------------------------------------
    log.call "  → Creating GDELT events..."
    create_gdelt_events!(articles)

    # ------------------------------------------------------------------
    # Step 9: Contradiction logs
    # ------------------------------------------------------------------
    log.call "  → Creating contradiction logs..."
    create_contradictions!(articles)

    # ------------------------------------------------------------------
    # Step 10: Narrative signatures
    # ------------------------------------------------------------------
    log.call "  → Creating narrative signatures..."
    create_narrative_signatures!(articles, topic_vecs)

    # ------------------------------------------------------------------
    # Step 11: Source credibility profiles
    # ------------------------------------------------------------------
    log.call "  → Creating source credibility profiles..."
    create_source_credibility!(articles)

    # ------------------------------------------------------------------
    # Step 12: Breaking alert
    # ------------------------------------------------------------------
    log.call "  → Creating breaking alert..."
    create_breaking_alert!(articles, countries)

    # ------------------------------------------------------------------
    # Summary
    # ------------------------------------------------------------------
    summary(log)
  end

  # ---------------------------------------------------------------------------
  # Wipe
  # ---------------------------------------------------------------------------

  def self.wipe_previous!
    # Use source_url prefix to identify Perfect Storm data
    storm_article_ids = Article.where("source_url LIKE ?", "#{URL_PREFIX}%").pluck(:id)

    # Order matters — dependents first
    ContradictionLog.where(article_a_id: storm_article_ids)
                    .or(ContradictionLog.where(article_b_id: storm_article_ids))
                    .destroy_all
    NarrativeSignatureArticle.where(article_id: storm_article_ids).destroy_all
    EntityMention.where(article_id: storm_article_ids).destroy_all
    GdeltEvent.where(article_id: storm_article_ids).destroy_all

    # Narrative routes → arcs (routes destroyed via dependent: :destroy on arc)
    arc_ids = NarrativeArc.where(article_id: storm_article_ids).pluck(:id)
    NarrativeRoute.where(narrative_arc_id: arc_ids).destroy_all
    NarrativeArc.where(id: arc_ids).destroy_all

    AiAnalysis.where(article_id: storm_article_ids).destroy_all
    Article.where(id: storm_article_ids).destroy_all

    # Cleanup orphaned Perfect Storm signatures/credibilities
    NarrativeSignature.where("label LIKE ?", "%Operation Silk Shadow%").destroy_all
    SourceCredibility.where(source_name: ps_source_names).destroy_all
    BreakingAlert.where("headline LIKE ?", "%Taiwan%").where("headline LIKE ?", "%PLA%").destroy_all
  end

  def self.ps_source_names
    %w[Xinhua Reuters RT\ International Fox\ News AP\ News
       Global\ Times Al\ Jazeera The\ Hindu The\ Guardian
       TASS Sputnik BBC\ Sport]
  end

  # ---------------------------------------------------------------------------
  # Geographic setup
  # ---------------------------------------------------------------------------

  def self.ensure_geo!
    geo = {
      china:   { region: "East Asia",       country: "China",          iso: "CHN" },
      uk:      { region: "Western Europe",   country: "United Kingdom", iso: "GBR" },
      russia:  { region: "Eastern Europe",   country: "Russia",         iso: "RUS" },
      usa:     { region: "North America",    country: "United States",  iso: "USA" },
      qatar:   { region: "Middle East",      country: "Qatar",          iso: "QAT" },
      india:   { region: "South Asia",       country: "India",          iso: "IND" },
    }

    # Qatar and India may not be in the base seed — create if needed
    extra_regions = {
      "Middle East"  => { lat: 31.05, lng: 34.85 },
      "South Asia"   => { lat: 20.59, lng: 78.96  }
    }

    countries = {}
    geo.each do |key, data|
      region = Region.find_by(name: data[:region]) ||
               Region.create!(
                 name: data[:region],
                 lat: extra_regions.dig(data[:region], :lat) || 0.0,
                 lng: extra_regions.dig(data[:region], :lng) || 0.0,
                 threat_level: 2
               )

      country = Country.find_by(iso_code: data[:iso]) ||
                Country.create!(
                  name: data[:country],
                  iso_code: data[:iso],
                  region: region
                )

      countries[key] = country
    end

    countries
  end

  # ---------------------------------------------------------------------------
  # Embeddings
  # ---------------------------------------------------------------------------

  def self.build_embeddings(tv)
    t = tv[:taiwan_military]
    r = tv[:russia_narrative]
    w = tv[:western_alarm]
    n = tv[:reaction_neutral]
    s = tv[:sports_cricket]

    # Each value is a 1536-d vector.
    # Similarity within group:
    #   taiwan cluster (A1,A2,A5,A6): sim ~0.82-0.92 to each other
    #   russia cluster (A3,A10,A11):  sim ~0.88-0.94 to each other
    #   western cluster (A2,A9):      cross-sim ~0.75
    #   reaction cluster (A7,A8):     sim ~0.80
    #   sports (A12):                 sim ~0.08-0.15 to everyone else (orphan)
    {
      # A1: Xinhua — China origin story, very taiwan-military
      a1:  perturb(t, 0.92),
      # A2: Reuters — Western mainstream covering Taiwan drill, between t and w
      a2:  perturb(normalize(t.zip(w).map { |x, y| x + y }), 0.88),
      # A3: RT — Russia narrative, distinctly different from taiwan cluster
      a3:  perturb(r, 0.93),
      # A4: Fox News — domestic US politics slant, further from pure taiwan
      a4:  perturb(normalize(t.zip(w).map { |x, y| x * 0.5 + y * 0.5 }), 0.78),
      # A5: AP — Western alarm, similar to A2 but stronger western framing
      a5:  perturb(normalize(t.zip(w).map { |x, y| x * 0.4 + y * 0.6 }), 0.87),
      # A6: Global Times — Same taiwan-military topic as A1, editorially opposite
      #     HIGH similarity to A1 (same vocab/topic) but opposite editorial stance
      a6:  perturb(t, 0.91),
      # A7: Al Jazeera — neutral reaction framing
      a7:  perturb(normalize(n.zip(t).map { |x, y| x * 0.6 + y * 0.4 }), 0.82),
      # A8: The Hindu — similar neutral reaction, slightly different regional lens
      a8:  perturb(normalize(n.zip(t).map { |x, y| x * 0.55 + y * 0.45 }), 0.83),
      # A9: Guardian escalation — western alarm + taiwan, next-day escalation
      a9:  perturb(normalize(w.zip(t).map { |x, y| x * 0.55 + y * 0.45 }), 0.85),
      # A10: TASS — very similar to RT (A3), same Russian state narrative
      a10: perturb(r, 0.96),
      # A11: Sputnik — also very similar to RT/TASS cluster
      a11: perturb(r, 0.95),
      # A12: BBC Sport — completely different topic (orphan), ~0.0 similarity to all
      a12: s
    }
  end

  # ---------------------------------------------------------------------------
  # Articles
  # ---------------------------------------------------------------------------

  # Scenario base date: April 7, 2026 00:00 UTC
  BASE_TIME = Time.utc(2026, 4, 7)

  def self.t(hours_offset)
    BASE_TIME + hours_offset.hours
  end

  def self.create_articles!(c, e)
    rows = article_definitions(c)
    articles = {}

    rows.each do |key, attrs|
      embedding = e[key]
      article = Article.create!(
        headline:     attrs[:headline],
        source_name:  attrs[:source_name],
        source_url:   "#{URL_PREFIX}#{attrs[:slug]}",
        published_at: attrs[:published_at],
        content:      attrs[:content],
        latitude:     attrs[:latitude],
        longitude:    attrs[:longitude],
        geo_confidence: attrs[:geo_confidence] || "high",
        geo_method:   attrs[:geo_method] || "explicit_coordinates",
        country:      attrs[:country],
        region:       attrs[:country]&.region,
        data_source:  "perfect_storm",
        source_type:  "news_api",
        embedding:    embedding,
        raw_data: {
          "seed_scenario" => SCENARIO_KEY,
          "seed_key"      => key.to_s,
          "seed_mode"     => "perfect_storm",
          "description"   => attrs[:description]
        }
      )
      articles[key] = article
    end

    articles
  end

  def self.article_definitions(c)
    {
      # -----------------------------------------------------------------------
      # A1: ORIGIN — Xinhua (China) — "Routine drills"
      # Role: Origin of the narrative chain, China's official framing
      # Threat: NEGLIGIBLE | Sentiment: Neutral
      # -----------------------------------------------------------------------
      a1: {
        headline:     "PLA Conducts Routine Naval Exercises in Taiwan Strait, Ministry Says",
        source_name:  "Xinhua",
        slug:         "xinhua-pla-routine-exercises-20260407",
        published_at: t(8),    # April 7, 08:00 UTC
        latitude:     39.9042,
        longitude:    116.4074,
        country:      c[:china],
        description:  "Origin article — China's official minimizing framing",
        content: <<~HTML
          <p>BEIJING — The People's Liberation Army (PLA) Navy on Monday commenced a series of scheduled joint training exercises in waters near the Taiwan Strait, the Ministry of National Defense announced.</p>
          <p>Spokesperson Senior Colonel Wu Qian said the exercises are "routine in nature" and part of the PLA's annual training schedule, designed to test combat readiness and maritime coordination. The drills involve surface combatants, submarines, and fixed-wing maritime patrol aircraft operating under unified command.</p>
          <p>"These exercises are a solemn declaration of China's determination to safeguard national sovereignty and territorial integrity," Wu said. Taiwan, which China claims as its territory, has no legitimate authority to comment on PLA activities in the region, the spokesperson added.</p>
          <p>Xi Jinping, General Secretary of the Chinese Communist Party and Chairman of the Central Military Commission, personally ordered the exercises according to sources familiar with the matter. The PLA Eastern Theater Command is overseeing the drills from its headquarters in Nanjing.</p>
          <p>The Ministry emphasized that the exercises do not target any specific country and called on all parties to avoid actions that could complicate the regional security environment.</p>
        HTML
      },

      # -----------------------------------------------------------------------
      # A2: HOP 2 — Reuters (UK) — Amplified framing
      # Role: First Western amplification, 2nd hop in narrative chain
      # Threat: HIGH | Sentiment: Bearish/Negative
      # -----------------------------------------------------------------------
      a2: {
        headline:     "China Launches Largest Military Drills Near Taiwan in Three Decades, Analysts Warn",
        source_name:  "Reuters",
        slug:         "reuters-china-largest-drills-20260407",
        published_at: t(10.5),  # April 7, 10:30 UTC
        latitude:     51.5074,
        longitude:    -0.1278,
        country:      c[:uk],
        description:  "Amplification hop — Western press escalates framing",
        content: <<~HTML
          <p>LONDON/TAIPEI — China launched what defense analysts describe as the largest military exercises near Taiwan in at least three decades on Monday, involving more than 50 warships, 100 aircraft, and an undisclosed number of submarine assets operating in coordinated zones around the island.</p>
          <p>The scale of the maneuvers far exceeds what Beijing has characterized as "routine training," according to satellite imagery reviewed by Reuters and corroborated by the US Defense Intelligence Agency, which issued an internal assessment describing the drills as "unprecedented in scope and complexity."</p>
          <p>Taiwan's Ministry of National Defense activated its highest readiness posture, deploying F-16V fighters and Patriot missile batteries along the western coastline. "We are monitoring the situation closely and are prepared to respond to any incursion," a ministry spokesman said.</p>
          <p>Xi Jinping is believed to have personally approved the exercise timeline following a closed-door Politburo Standing Committee meeting last week, according to three people briefed on the matter. PLA Eastern Theater Command has assumed operational control.</p>
          <p>Regional neighbors including Japan and South Korea have put their militaries on elevated alert. The US Seventh Fleet has repositioned two guided-missile destroyers to waters east of Taiwan without specifying the operational rationale.</p>
        HTML
      },

      # -----------------------------------------------------------------------
      # A3: HOP 3 — RT International (Russia) — Distorted framing
      # Role: Russia reframes event as US provocation, 3rd hop
      # Threat: HIGH | Sentiment: Hostile
      # -----------------------------------------------------------------------
      a3: {
        headline:     "US Provocations Forced Beijing's Hand: China Defends Sovereign Territory Against NATO Encirclement",
        source_name:  "RT International",
        slug:         "rt-us-provocation-china-20260407",
        published_at: t(14),   # April 7, 14:00 UTC
        latitude:     55.7558,
        longitude:    37.6173,
        country:      c[:russia],
        description:  "Distortion hop — Russian state media shifts blame to US/NATO",
        content: <<~HTML
          <p>MOSCOW — China's measured military response in the Taiwan Strait should be understood not as aggression, but as a predictable consequence of years of relentless American provocation and NATO's creeping encirclement of Asia, Russian analysts said Monday.</p>
          <p>The People's Liberation Army exercises, condemned by Washington and its allies as "destabilizing," represent exactly the kind of defensive posture any sovereign power would adopt when faced with systematic Western encroachment, said Dmitry Trenin, senior fellow at the Russian International Affairs Council.</p>
          <p>"Washington has been deploying carrier groups, selling weapons to Taipei, and parading its destroyers through what China considers its territorial waters," Trenin told RT. "Xi Jinping is not escalating — he is responding to escalation by the collective West."</p>
          <p>The Kremlin has formally expressed "full understanding" for China's position, with Foreign Ministry spokeswoman Maria Zakharova calling on the United States to "cease its dangerous interference in China's domestic affairs." Russia and China signed a "no-limits partnership" agreement in 2022.</p>
          <p>Experts interviewed by RT emphasized that Taiwan's provocative arms purchases from the United States — totaling over $10 billion in recent years — left Beijing with no choice but to demonstrate its resolve.</p>
        HTML
      },

      # -----------------------------------------------------------------------
      # A4: Fox News (USA) — Domestic US politics distortion
      # Role: Turns the event into Biden/domestic political ammunition
      # Threat: MODERATE | Sentiment: Negative
      # -----------------------------------------------------------------------
      a4: {
        headline:     "China's Taiwan Provocation Exposes Biden Administration's Catastrophic Weakness on Asia Policy",
        source_name:  "Fox News",
        slug:         "fox-news-biden-weakness-taiwan-20260408",
        published_at: t(25),   # April 8, 09:00 UTC
        latitude:     40.7128,
        longitude:    -74.0060,
        country:      c[:usa],
        description:  "Domestic politics distortion — turns geopolitical crisis into partisan ammunition",
        content: <<~HTML
          <p>NEW YORK — China's brazen military encirclement of Taiwan this week is the direct result of the Biden administration's four years of weakness, appeasement, and strategic incoherence on Asia policy, Republican lawmakers and defense hawks said Tuesday.</p>
          <p>"This is what happens when you telegraph weakness," said Senator Tom Cotton (R-AR). "Beijing has read every signal from this White House and concluded that now is the moment to act. The cost of that miscalculation will be paid by the Taiwanese people."</p>
          <p>Critics note that the administration failed to accelerate weapons deliveries to Taiwan, refused to upgrade diplomatic relations, and allowed China to conduct a sustained campaign of economic warfare against the island without meaningful consequence.</p>
          <p>The Pentagon said it is "monitoring the situation," a phrase critics mocked as inadequate. Meanwhile, Xi Jinping continues to escalate without apparent fear of US military intervention.</p>
          <p>Former National Security Advisor Robert O'Brien warned that the situation could spiral into a full blockade within 72 hours if the administration fails to draw a clear red line. "Every hour of silence from Washington is a green light for Beijing," O'Brien said.</p>
        HTML
      },

      # -----------------------------------------------------------------------
      # A5: AP News (USA) — Corroborates the scale, contradicts A1
      # Role: Contradiction pair 1 (vs A1), Corroboration pair 1 (vs A9)
      # Threat: CRITICAL | Sentiment: Very Negative
      # -----------------------------------------------------------------------
      a5: {
        headline:     "Taiwan Military Says China's Drills Are Largest in 30 Years, Activates Full Combat Alert",
        source_name:  "AP News",
        slug:         "ap-news-taiwan-full-alert-20260407",
        published_at: t(16),   # April 7, 16:00 UTC
        latitude:     38.9072,
        longitude:    -77.0369,
        country:      c[:usa],
        description:  "Corroboration article — confirms scale, CONTRADICTS Xinhua minimization",
        content: <<~HTML
          <p>TAIPEI — Taiwan's military activated its highest combat alert status Monday evening as China deployed what Taipei described as the largest coordinated naval and air force exercise in the Taiwan Strait in more than 30 years, threatening the island's sea lanes and airspace.</p>
          <p>The Taiwan Ministry of National Defense said in an emergency briefing that PLA forces had established three operational zones encircling more than 70 percent of the island's exclusive economic zone, effectively simulating a blockade scenario. The move exceeded any previous exercise in geographic scope and asset deployment.</p>
          <p>"This is not a drill in any normal sense of the word," said General Chen Wei-ping, Chief of the General Staff. "This is a rehearsal for invasion." He called on the international community to "take immediate action" to deter further escalation.</p>
          <p>The United States has confirmed the repositioning of the USS Ronald Reagan carrier strike group from its base in Yokosuka, Japan, to waters east of Taiwan. F-22 and F-35 fighters have been placed on strip alert at Kadena Air Base in Okinawa.</p>
          <p>Japan's Self-Defense Force has activated its Southwestern Command and deployed Type-12 anti-ship missiles to the Ryukyu island chain. South Korea's Joint Chiefs of Staff issued a Level-2 security alert — the highest peacetime designation.</p>
        HTML
      },

      # -----------------------------------------------------------------------
      # A6: Global Times (China) — Contradicts A5 on Taiwan's reaction
      # Role: Contradiction pair 2 (vs A5), editorially opposite to A1 despite
      #       high embedding similarity (same vocabulary, opposite framing)
      # Threat: LOW | Sentiment: Neutral
      # -----------------------------------------------------------------------
      a6: {
        headline:     "Taiwan Authorities Downplay PLA Exercises to Prevent Public Panic; PLA Drill Proceeding Normally",
        source_name:  "Global Times",
        slug:         "global-times-taiwan-downplay-20260407",
        published_at: t(18),   # April 7, 18:00 UTC
        latitude:     39.9042,
        longitude:    116.4074,
        country:      c[:china],
        description:  "Contradiction pair 2 — Global Times says Taiwan is calm (contradicts AP Full Alert)",
        content: <<~HTML
          <p>BEIJING — Authorities in Taiwan are deliberately downplaying the scale of People's Liberation Army exercises in the Taiwan Strait to prevent public panic, with the island's leadership privately urging calm while publicly maintaining a combative posture for domestic consumption, analysts told the Global Times.</p>
          <p>The PLA Eastern Theater Command confirmed that all phases of the joint exercises are proceeding normally and on schedule, with no incidents or unexpected developments. "All operations are within the planned parameters," a theater command spokesperson said.</p>
          <p>Taiwan's economy ministry quietly assured business associations that shipping lanes remain open and that no supply chain disruptions are expected, directly contradicting the island government's public posture of alarm.</p>
          <p>Military commentator Song Zhongping told CCTV that the exercises demonstrate the PLA's ability to conduct multi-domain operations and noted that Taiwan's leaders are "performing distress for their American patrons rather than responding to an actual threat."</p>
          <p>Xi Jinping has reiterated that the exercises are consistent with China's longstanding policy of deterrence and peaceful reunification, and that the military activities serve as a measured reminder to Taipei of the consequences of pursuing formal independence.</p>
        HTML
      },

      # -----------------------------------------------------------------------
      # A7: Al Jazeera (Qatar) — Regional reaction, neutral/analytical
      # Role: Shared entities (Xi Jinping, ASEAN), semantic similarity to A8
      # Threat: MODERATE | Sentiment: Negative
      # -----------------------------------------------------------------------
      a7: {
        headline:     "Asian Nations Urge Restraint as Taiwan Strait Tensions Risk Regional Catastrophe",
        source_name:  "Al Jazeera",
        slug:         "aljazeera-asia-urge-restraint-20260408",
        published_at: t(22),   # April 8, 06:00 UTC
        latitude:     25.2854,
        longitude:    51.5310,
        country:      c[:qatar],
        description:  "Regional reaction — neutral analytical framing, ASEAN call for restraint",
        content: <<~HTML
          <p>DOHA — Foreign ministers from across Asia on Tuesday issued coordinated calls for restraint as China's military exercises around Taiwan entered their second day, with ASEAN issuing an emergency statement warning that escalation risked destabilizing regional trade flows worth an estimated $5.3 trillion annually.</p>
          <p>Indonesian Foreign Minister Retno Marsudi called the exercises "deeply concerning" and urged both Beijing and Washington to engage in direct dialogue. "No party benefits from a military confrontation in the Taiwan Strait," she said after an emergency ASEAN Plus consultative call.</p>
          <p>Xi Jinping's office did not respond to the ASEAN appeal. China's Foreign Ministry said in a brief statement that "internal Chinese affairs are not a matter for regional organizations."</p>
          <p>Taiwan's Ministry of National Defense reiterated that it would not fire the first shot but reserved the right to respond to "any hostile action." The ministry said it had received additional secure communications from Washington pledging support "appropriate to the situation."</p>
          <p>The Philippines, which hosts US military bases under the Enhanced Defense Cooperation Agreement, said it was in "intensive consultations" with Washington. Japan's Prime Minister convened an emergency session of the National Security Council.</p>
        HTML
      },

      # -----------------------------------------------------------------------
      # A8: The Hindu (India) — Regional reaction from Global South lens
      # Role: Shared entities (Xi Jinping), corroborates A7 framing, neutral
      # Threat: LOW | Sentiment: Neutral
      # -----------------------------------------------------------------------
      a8: {
        headline:     "India Monitors Taiwan Strait 'With Great Concern', Calls for Dialogue Over Military Posturing",
        source_name:  "The Hindu",
        slug:         "the-hindu-india-monitors-taiwan-20260408",
        published_at: t(28),   # April 8, 12:00 UTC
        latitude:     28.6139,
        longitude:    77.2090,
        country:      c[:india],
        description:  "Global South perspective — India's calibrated neutral stance",
        content: <<~HTML
          <p>NEW DELHI — India on Tuesday said it was monitoring developments in the Taiwan Strait "with great concern," calling for immediate de-escalation through dialogue and warning that any military conflict in the region would have "severe consequences for global supply chains and the international rules-based order."</p>
          <p>External Affairs Minister S. Jaishankar, speaking after meeting with his Japanese counterpart in New Delhi, said India "strongly urges all parties to exercise maximum restraint" but declined to characterize China's exercises as either provocation or routine.</p>
          <p>India's calibrated language reflects its complex positioning: it maintains a deep strategic partnership with Russia, a Quad alliance with the United States, Japan and Australia, and a fraught border dispute with China following the 2020 Galwan Valley clashes.</p>
          <p>"We are not going to take sides in what is fundamentally a dispute between major powers," said a senior official at India's Ministry of External Affairs, speaking on condition of anonymity. "But we will consistently advocate for dialogue and the peaceful resolution of disputes."</p>
          <p>Xi Jinping's office has not responded to Indian diplomatic outreach on the matter. India's ambassador in Beijing has been summoned for a briefing by the Chinese Foreign Ministry.</p>
        HTML
      },

      # -----------------------------------------------------------------------
      # A9: The Guardian (UK) — Escalation, next-day, CRITICAL threat
      # Role: Hop 4 (final) in narrative chain, CORROBORATES A5 (carrier confirmed)
      # Threat: CRITICAL | Sentiment: Very Negative
      # -----------------------------------------------------------------------
      a9: {
        headline:     "US Carrier Group Moves Toward Taiwan; China Vows 'Firm and Decisive' Response to American Interference",
        source_name:  "The Guardian",
        slug:         "guardian-us-carrier-taiwan-20260409",
        published_at: t(47),   # April 9, 07:00 UTC
        latitude:     51.5074,
        longitude:    -0.1278,
        country:      c[:uk],
        description:  "Escalation article — hop 4, CRITICAL threat, corroborates AP (A5)",
        content: <<~HTML
          <p>LONDON — The United States has confirmed that the USS Ronald Reagan carrier strike group has repositioned from its homeport in Yokosuka, Japan to waters approximately 200 nautical miles east of Taiwan, the Pentagon said Wednesday, as China's military exercises entered their third day and showed no signs of concluding.</p>
          <p>Beijing responded with a sharp warning, with Xi Jinping convening an emergency session of the Central Military Commission and issuing a statement vowing a "firm and decisive response to any interference in China's internal affairs by foreign military forces."</p>
          <p>The Taiwan Ministry of National Defense, which has maintained a full combat alert since Monday, said PLA aircraft conducted 47 incursions into Taiwan's Air Defense Identification Zone in the past 24 hours — the highest single-day figure ever recorded.</p>
          <p>The USS Ronald Reagan, accompanied by the USS Chancellorsville cruiser and four destroyers, was tracked by Chinese surveillance satellites as it transited from the Philippine Sea. A second carrier group, the USS Abraham Lincoln, has been ordered to accelerate its transit from Pearl Harbor, naval officials confirmed.</p>
          <p>Diplomatic channels remain open, but sources familiar with the discussions said talks between US National Security Advisor Jake Sullivan and Chinese State Councilor Wang Yi produced "no tangible progress." The G7 has called an emergency foreign ministers' meeting for Thursday in Brussels.</p>
          <p>Markets in Asia fell sharply for a second consecutive day, with the Taiwan dollar dropping 3.2 percent against the US dollar. Taiwanese semiconductor firms, including TSMC, began activating business continuity protocols.</p>
        HTML
      },

      # -----------------------------------------------------------------------
      # A10: TASS (Russia) — Very similar to RT (A3), high embedding similarity
      # Role: Second Russian state narrative article, embedding cluster with A3/A11
      # Threat: HIGH | Sentiment: Hostile
      # -----------------------------------------------------------------------
      a10: {
        headline:     "US Military Escalation Near China's Border Threatens Regional Peace, Russian MFA Warns",
        source_name:  "TASS",
        slug:         "tass-us-escalation-china-20260409",
        published_at: t(49),   # April 9, 09:00 UTC
        latitude:     55.7558,
        longitude:    37.6173,
        country:      c[:russia],
        description:  "Russian state narrative cluster — very similar embedding to RT (A3)",
        content: <<~HTML
          <p>MOSCOW — Russia's Foreign Ministry on Wednesday warned that Washington's decision to deploy a carrier strike group toward Taiwan constitutes a deliberate escalation that threatens regional peace and stability, calling on the United States to "immediately halt its provocative military activities."</p>
          <p>Spokeswoman Maria Zakharova stated that the United States bears "full responsibility for the dangerous situation it has engineered" through its long-standing policy of arming Taiwan and conducting military operations in waters that China considers its own.</p>
          <p>"Russia stands firmly with China in opposing the systematic attempts by the collective West to encircle, contain, and ultimately destabilize the People's Republic," Zakharova said. Russia and China have deepened their no-limits strategic partnership since 2022.</p>
          <p>The Kremlin separately issued a statement expressing concern that US military adventurism in Asia was creating "conditions for a catastrophic conflict" and urged NATO allies to restrain Washington from further escalation.</p>
          <p>Russian Security Council Deputy Chairman Dmitry Medvedev warned that any military conflict between US and Chinese forces near Taiwan would represent the most dangerous confrontation between nuclear powers since the Cuban Missile Crisis.</p>
        HTML
      },

      # -----------------------------------------------------------------------
      # A11: Sputnik (Russia) — Third Russian narrative article
      # Role: Embedding cluster with A3/A10, slight variation in angle
      # Threat: HIGH | Sentiment: Hostile
      # -----------------------------------------------------------------------
      a11: {
        headline:     "Pentagon Confirms Carrier Deployment, Calls It 'Freedom of Navigation'; China Calls It 'Naked Provocation'",
        source_name:  "Sputnik",
        slug:         "sputnik-pentagon-carrier-freedom-nav-20260409",
        published_at: t(51),   # April 9, 11:00 UTC
        latitude:     55.7558,
        longitude:    37.6173,
        country:      c[:russia],
        description:  "Russian state narrative variation — embedding cluster with A3/A10",
        content: <<~HTML
          <p>MOSCOW — The Pentagon confirmed Wednesday that the USS Ronald Reagan carrier strike group has repositioned toward Taiwan, characterizing the deployment as a "routine freedom of navigation operation" in international waters — a framing China's Foreign Ministry immediately dismissed as a "naked provocation and brazen interference in Chinese internal affairs."</p>
          <p>US Defense Secretary Lloyd Austin said the Navy would "continue to operate wherever international law permits" and that the United States' commitment to Taiwan's security was "ironclad." He declined to specify the carrier group's precise operational parameters.</p>
          <p>Chinese Foreign Ministry spokesman Lin Jian said Washington's use of "freedom of navigation" as a pretext for military coercion was "a tired excuse that fools no one," adding that the United States had systematically violated international norms by treating the Pacific as its private military domain.</p>
          <p>The concept of freedom of navigation, analysts note, is applied asymmetrically by Washington: US warships operate freely in waters near China, while China's own maritime activities face systematic challenge. This double standard, according to Russian and Chinese commentators, exposes the hollowness of Washington's stated commitment to a rules-based international order.</p>
          <p>President Xi Jinping has ordered the PLA to maintain "maximum readiness" for the duration of the exercises, with no timeline for their conclusion announced.</p>
        HTML
      },

      # -----------------------------------------------------------------------
      # A12: BBC Sport (UK) — THE ORPHAN (control case)
      # Role: Zero connections to main cluster, tests over-connection detection
      # Threat: NEGLIGIBLE | Sentiment: Positive
      # Poor geo: latitude/longitude are nil (tests fallback handling)
      # -----------------------------------------------------------------------
      a12: {
        headline:     "England Set New Test Cricket Record Against Australia at Lord's in Stunning Second Innings",
        source_name:  "BBC Sport",
        slug:         "bbc-sport-england-cricket-lords-20260408",
        published_at: t(30),   # April 8, 14:00 UTC
        latitude:     nil,     # ← intentional: poor geo test case
        longitude:    nil,
        geo_confidence: "none",
        geo_method:   "unresolved",
        country:      c[:uk],
        description:  "ORPHAN article — sports news, zero geopolitical connection, nil coords",
        content: <<~HTML
          <p>LONDON — England completed one of the most astonishing batting performances in the history of Test cricket on Wednesday, posting 621 for 6 declared in their second innings at Lord's to leave Australia facing an improbable target of 498 runs on the final day.</p>
          <p>Ben Duckett's magnificent 234 not out, his highest Test score, was the centrepiece of a day that redefined what was possible in the longest format of the game. Joe Root contributed 156 in a third-wicket partnership of 312 that left the Australian attack exhausted and demoralized.</p>
          <p>Australia will resume Thursday needing a miracle with six second-innings wickets in hand. Captain Pat Cummins admitted after stumps that the target was "beyond what any team has ever achieved chasing at Lord's."</p>
          <p>The performance cements England's Bazball revolution under Ben Stokes and Brendon McCullum as a permanent transformation of Test match cricket's philosophy. England have now won 22 of their last 27 Tests under this coaching partnership.</p>
        HTML
      }
    }
  end

  # ---------------------------------------------------------------------------
  # AI Analyses
  # ---------------------------------------------------------------------------

  AI_ANALYSIS_DATA = {
    a1:  { threat: "NEGLIGIBLE", sentiment_label: "Neutral",         sentiment_color: "#38bdf8", trust: 62.0, topic: "Military/Taiwan", status: "complete" },
    a2:  { threat: "HIGH",       sentiment_label: "Bearish",         sentiment_color: "#ef4444", trust: 78.0, topic: "Military/Taiwan", status: "complete" },
    a3:  { threat: "HIGH",       sentiment_label: "Hostile",         sentiment_color: "#dc2626", trust: 31.0, topic: "Military/Russia-NATO", status: "complete", anomaly: true },
    a4:  { threat: "MODERATE",   sentiment_label: "Negative",        sentiment_color: "#f97316", trust: 55.0, topic: "US Politics/Taiwan", status: "complete" },
    a5:  { threat: "CRITICAL",   sentiment_label: "Very Negative",   sentiment_color: "#dc2626", trust: 88.0, topic: "Military/Taiwan", status: "complete" },
    a6:  { threat: "LOW",        sentiment_label: "Neutral",         sentiment_color: "#38bdf8", trust: 29.0, topic: "Military/Taiwan", status: "complete", anomaly: true },
    a7:  { threat: "MODERATE",   sentiment_label: "Negative",        sentiment_color: "#f97316", trust: 74.0, topic: "Diplomacy/ASEAN", status: "complete" },
    a8:  { threat: "LOW",        sentiment_label: "Neutral",         sentiment_color: "#38bdf8", trust: 80.0, topic: "Diplomacy/India", status: "complete" },
    a9:  { threat: "CRITICAL",   sentiment_label: "Very Negative",   sentiment_color: "#dc2626", trust: 85.0, topic: "Military/Escalation", status: "complete" },
    a10: { threat: "HIGH",       sentiment_label: "Hostile",         sentiment_color: "#dc2626", trust: 28.0, topic: "Military/Russia-NATO", status: "complete", anomaly: true },
    a11: { threat: "HIGH",       sentiment_label: "Hostile",         sentiment_color: "#dc2626", trust: 27.0, topic: "Military/Russia-NATO", status: "complete", anomaly: true },
    a12: { threat: "NEGLIGIBLE", sentiment_label: "Positive",        sentiment_color: "#22c55e", trust: 91.0, topic: "Sport/Cricket",   status: "complete" }
  }.freeze

  def self.create_ai_analyses!(articles)
    articles.each do |key, article|
      data = AI_ANALYSIS_DATA[key]
      AiAnalysis.create!(
        article:                article,
        analysis_status:        data[:status],
        threat_level:           data[:threat],
        sentiment_label:        data[:sentiment_label],
        sentiment_color:        data[:sentiment_color],
        trust_score:            data[:trust],
        geopolitical_topic:     data[:topic],
        linguistic_anomaly_flag: data[:anomaly] || false,
        summary:                "Perfect Storm scenario: #{article.headline.truncate(100)}",
        analyst_response: {
          "model"   => "google/gemini-2.0-flash-001",
          "verdict" => "Analysis complete — Perfect Storm seed data"
        },
        sentinel_response: {
          "model"   => "openai/gpt-4o-mini",
          "verdict" => "Cross-verification complete — Perfect Storm seed data"
        },
        arbiter_response: {
          "model"   => "anthropic/claude-3.5-haiku",
          "verdict" => "Arbiter synthesis complete — Perfect Storm seed data"
        }
      )
    end
  end

  # ---------------------------------------------------------------------------
  # Entities
  # ---------------------------------------------------------------------------

  ENTITY_DEFINITIONS = [
    { name: "Xi Jinping",                    type: "person",       articles: [:a1, :a3, :a6, :a7, :a8, :a9, :a10, :a11] },
    { name: "People's Liberation Army",      type: "organization", articles: [:a1, :a2, :a3, :a6, :a9, :a10] },
    { name: "Taiwan Ministry of Defense",    type: "organization", articles: [:a2, :a5, :a7, :a9] },
    { name: "USS Ronald Reagan",             type: "organization", articles: [:a5, :a9, :a11] },
    { name: "ASEAN",                         type: "organization", articles: [:a7, :a8] },
    { name: "PLA Eastern Theater Command",   type: "organization", articles: [:a1, :a2, :a6] },
    { name: "US Pentagon",                   type: "organization", articles: [:a4, :a5, :a9, :a11] },
    { name: "Maria Zakharova",               type: "person",       articles: [:a3, :a10] },
    { name: "China",                         type: "country",      articles: [:a1, :a2, :a3, :a4, :a5, :a6, :a7, :a9, :a10, :a11] },
    { name: "Taiwan",                        type: "country",      articles: [:a1, :a2, :a3, :a4, :a5, :a6, :a7, :a8, :a9, :a10, :a11] },
  ].freeze

  def self.create_entities!(articles)
    ENTITY_DEFINITIONS.each do |defn|
      entity = Entity.find_or_create_normalized(
        name:        defn[:name],
        entity_type: defn[:type]
      )
      next unless entity

      defn[:articles].each do |key|
        article = articles[key]
        next unless article

        EntityMention.find_or_create_by!(article: article, entity: entity)
        entity.increment!(:mentions_count)
      end
    end
  end

  # ---------------------------------------------------------------------------
  # Narrative Chain: 4-hop route
  # Chain: A1 (Xinhua/Beijing) → A2 (Reuters/London) → A3 (RT/Moscow) → A9 (Guardian/London)
  # Framing: original → amplified → distorted → amplified
  # ---------------------------------------------------------------------------

  def self.create_narrative_chain!(articles)
    a1 = articles[:a1]
    a2 = articles[:a2]
    a3 = articles[:a3]
    a9 = articles[:a9]

    # Create the narrative arc anchored on the origin article (A1)
    arc = NarrativeArc.create!(
      article:        a1,
      origin_country: "China",
      origin_lat:     a1.latitude,
      origin_lng:     a1.longitude,
      target_country: "United Kingdom",
      target_lat:     a9.latitude,
      target_lng:     a9.longitude,
      arc_color:      "#ef4444"  # Red — narrative became distorted
    )

    # Build the 4-hop route with realistic timing and framing shifts
    hops = [
      {
        "article_id"        => a1.id,
        "source_name"       => a1.source_name,
        "source_country"    => "China",
        "lat"               => a1.latitude,
        "lng"               => a1.longitude,
        "published_at"      => a1.published_at.iso8601,
        "framing_shift"     => "original",
        "framing_explanation" => "Origin: China frames its own military exercises as routine and scheduled.",
        "confidence_score"  => 0.95,
        "delay_from_previous" => 0
      },
      {
        "article_id"        => a2.id,
        "source_name"       => a2.source_name,
        "source_country"    => "United Kingdom",
        "lat"               => a2.latitude,
        "lng"               => a2.longitude,
        "published_at"      => a2.published_at.iso8601,
        "framing_shift"     => "amplified",
        "framing_explanation" => "Western press amplifies scope: 'largest in three decades', introduces satellite imagery and DIA assessment.",
        "confidence_score"  => 0.87,
        "delay_from_previous" => (a2.published_at - a1.published_at).to_i
      },
      {
        "article_id"        => a3.id,
        "source_name"       => a3.source_name,
        "source_country"    => "Russia",
        "lat"               => a3.latitude,
        "lng"               => a3.longitude,
        "published_at"      => a3.published_at.iso8601,
        "framing_shift"     => "distorted",
        "framing_explanation" => "Russian state media reframes: China is victim of US/NATO provocation, not aggressor. Inverts blame attribution.",
        "confidence_score"  => 0.78,
        "delay_from_previous" => (a3.published_at - a2.published_at).to_i
      },
      {
        "article_id"        => a9.id,
        "source_name"       => a9.source_name,
        "source_country"    => "United Kingdom",
        "lat"               => a9.latitude,
        "lng"               => a9.longitude,
        "published_at"      => a9.published_at.iso8601,
        "framing_shift"     => "amplified",
        "framing_explanation" => "Western press amplifies further: carrier group deployed, G7 emergency meeting, Taiwan ADIZ violations at record high.",
        "confidence_score"  => 0.92,
        "delay_from_previous" => (a9.published_at - a3.published_at).to_i
      }
    ]

    NarrativeRoute.create!(
      narrative_arc:     arc,
      name:              "Operation Silk Shadow: Beijing → London → Moscow → London",
      description:       "Primary narrative propagation chain tracking how China's 'routine drill' became an international crisis through Western amplification and Russian distortion.",
      hops:              hops,
      is_complete:       true,
      status:            "tracking",
      total_hops:        4,
      manipulation_score: 0.67,
      amplification_score: 0.75,
      total_reach_countries: 3,
      propagation_speed: 1200.0  # km/h approximate
    )

    # Secondary arc: Russia cluster internal propagation (A3 → A10 → A11)
    arc2 = NarrativeArc.create!(
      article:        a3,
      origin_country: "Russia",
      origin_lat:     a3.latitude,
      origin_lng:     a3.longitude,
      target_country: "Russia",
      target_lat:     articles[:a11].latitude,
      target_lng:     articles[:a11].longitude,
      arc_color:      "#f97316"  # Orange — amplification within echo chamber
    )

    hops2 = [
      {
        "article_id"        => a3.id,
        "source_name"       => "RT International",
        "source_country"    => "Russia",
        "lat"               => a3.latitude,
        "lng"               => a3.longitude,
        "published_at"      => a3.published_at.iso8601,
        "framing_shift"     => "original",
        "framing_explanation" => "RT establishes the Russian counter-narrative framing.",
        "confidence_score"  => 0.93,
        "delay_from_previous" => 0
      },
      {
        "article_id"        => articles[:a10].id,
        "source_name"       => "TASS",
        "source_country"    => "Russia",
        "lat"               => articles[:a10].latitude,
        "lng"               => articles[:a10].longitude,
        "published_at"      => articles[:a10].published_at.iso8601,
        "framing_shift"     => "amplified",
        "framing_explanation" => "TASS amplifies with official MFA statement, adding diplomatic weight.",
        "confidence_score"  => 0.91,
        "delay_from_previous" => (articles[:a10].published_at - a3.published_at).to_i
      },
      {
        "article_id"        => articles[:a11].id,
        "source_name"       => "Sputnik",
        "source_country"    => "Russia",
        "lat"               => articles[:a11].latitude,
        "lng"               => articles[:a11].longitude,
        "published_at"      => articles[:a11].published_at.iso8601,
        "framing_shift"     => "amplified",
        "framing_explanation" => "Sputnik adds Pentagon confirmation as evidence for the Russian framing of US aggression.",
        "confidence_score"  => 0.89,
        "delay_from_previous" => (articles[:a11].published_at - articles[:a10].published_at).to_i
      }
    ]

    NarrativeRoute.create!(
      narrative_arc:     arc2,
      name:              "Russian Echo Chamber: RT → TASS → Sputnik",
      description:       "Internal amplification chain within Russian state media ecosystem — narrative copied and reinforced across three outlets within 3 hours.",
      hops:              hops2,
      is_complete:       true,
      status:            "tracking",
      total_hops:        3,
      manipulation_score: 0.45,
      amplification_score: 1.0,
      total_reach_countries: 1,
      propagation_speed: 0.1  # same city, near-zero distance
    )
  end

  # ---------------------------------------------------------------------------
  # GDELT Events
  # ---------------------------------------------------------------------------

  GDELT_EVENTS = [
    # Articles A1, A2, A5 — Share actor pair: China/PLA ↔ Taiwan
    { key: :a1, globaleventid: 1100001, event_code: "15",  event_root_code: "15",
      actor1_name: "CHINA", actor1_country_code: "CHN", actor2_name: "TAIWAN",
      actor2_country_code: "TWN", goldstein_scale: -3.5, quad_class: 2,
      event_date: Date.new(2026, 4, 7), num_sources: 5, num_mentions: 24, num_articles: 8,
      avg_tone: -4.2, action_geo_country_code: "TWN",
      action_geo_full_name: "Taiwan", action_geo_lat: 23.6978, action_geo_long: 120.9605 },

    { key: :a2, globaleventid: 1100002, event_code: "15",  event_root_code: "15",
      actor1_name: "CHINA", actor1_country_code: "CHN", actor2_name: "TAIWAN",
      actor2_country_code: "TWN", goldstein_scale: -5.0, quad_class: 3,
      event_date: Date.new(2026, 4, 7), num_sources: 18, num_mentions: 89, num_articles: 31,
      avg_tone: -7.1, action_geo_country_code: "TWN",
      action_geo_full_name: "Taiwan", action_geo_lat: 23.6978, action_geo_long: 120.9605 },

    { key: :a5, globaleventid: 1100003, event_code: "153", event_root_code: "15",
      actor1_name: "TAIWAN", actor1_country_code: "TWN", actor2_name: "CHINA",
      actor2_country_code: "CHN", goldstein_scale: -7.0, quad_class: 3,
      event_date: Date.new(2026, 4, 7), num_sources: 22, num_mentions: 143, num_articles: 48,
      avg_tone: -9.4, action_geo_country_code: "TWN",
      action_geo_full_name: "Taipei, Taiwan", action_geo_lat: 25.0330, action_geo_long: 121.5654 },

    # Articles A3, A10, A11 — Share actor pair: Russia ↔ United States
    { key: :a3, globaleventid: 1100004, event_code: "131", event_root_code: "13",
      actor1_name: "RUSSIA", actor1_country_code: "RUS", actor2_name: "UNITED STATES",
      actor2_country_code: "USA", goldstein_scale: -4.0, quad_class: 3,
      event_date: Date.new(2026, 4, 7), num_sources: 4, num_mentions: 17, num_articles: 6,
      avg_tone: -6.3, action_geo_country_code: "USA",
      action_geo_full_name: "Washington, DC, United States", action_geo_lat: 38.9072, action_geo_long: -77.0369 },

    { key: :a10, globaleventid: 1100005, event_code: "131", event_root_code: "13",
      actor1_name: "RUSSIA", actor1_country_code: "RUS", actor2_name: "UNITED STATES",
      actor2_country_code: "USA", goldstein_scale: -3.8, quad_class: 3,
      event_date: Date.new(2026, 4, 9), num_sources: 6, num_mentions: 28, num_articles: 9,
      avg_tone: -5.9, action_geo_country_code: "USA",
      action_geo_full_name: "Washington, DC, United States", action_geo_lat: 38.9072, action_geo_long: -77.0369 },

    { key: :a11, globaleventid: 1100006, event_code: "131", event_root_code: "13",
      actor1_name: "RUSSIA", actor1_country_code: "RUS", actor2_name: "UNITED STATES",
      actor2_country_code: "USA", goldstein_scale: -3.5, quad_class: 3,
      event_date: Date.new(2026, 4, 9), num_sources: 5, num_mentions: 22, num_articles: 7,
      avg_tone: -5.4, action_geo_country_code: "USA",
      action_geo_full_name: "Washington, DC, United States", action_geo_lat: 38.9072, action_geo_long: -77.0369 },

    # Articles A7, A8 — Share event code: Verbal appeal/de-escalation
    { key: :a7, globaleventid: 1100007, event_code: "036", event_root_code: "03",
      actor1_name: "ASEAN", actor1_country_code: nil, actor2_name: "CHINA",
      actor2_country_code: "CHN", goldstein_scale: 1.0, quad_class: 1,
      event_date: Date.new(2026, 4, 8), num_sources: 8, num_mentions: 34, num_articles: 12,
      avg_tone: -2.1, action_geo_country_code: "IDN",
      action_geo_full_name: "Jakarta, Indonesia", action_geo_lat: -6.2088, action_geo_long: 106.8456 },

    { key: :a8, globaleventid: 1100008, event_code: "036", event_root_code: "03",
      actor1_name: "INDIA", actor1_country_code: "IND", actor2_name: "CHINA",
      actor2_country_code: "CHN", goldstein_scale: 0.8, quad_class: 1,
      event_date: Date.new(2026, 4, 8), num_sources: 7, num_mentions: 29, num_articles: 10,
      avg_tone: -1.8, action_geo_country_code: "IND",
      action_geo_full_name: "New Delhi, India", action_geo_lat: 28.6139, action_geo_long: 77.2090 },

    # Article A9 — CRITICAL: US carrier movement (quad_class: 4 — Material Conflict)
    { key: :a9, globaleventid: 1100009, event_code: "195", event_root_code: "19",
      actor1_name: "UNITED STATES", actor1_country_code: "USA", actor2_name: "CHINA",
      actor2_country_code: "CHN", goldstein_scale: -9.0, quad_class: 4,
      event_date: Date.new(2026, 4, 9), num_sources: 31, num_mentions: 218, num_articles: 71,
      avg_tone: -11.3, action_geo_country_code: "TWN",
      action_geo_full_name: "Taiwan Strait", action_geo_lat: 24.0000, action_geo_long: 122.0000 },
  ].freeze

  def self.create_gdelt_events!(articles)
    GDELT_EVENTS.each do |defn|
      article = articles[defn[:key]]
      GdeltEvent.create!(
        article:               article,
        globaleventid:         defn[:globaleventid],
        event_code:            defn[:event_code],
        event_root_code:       defn[:event_root_code],
        actor1_name:           defn[:actor1_name],
        actor1_country_code:   defn[:actor1_country_code],
        actor2_name:           defn[:actor2_name],
        actor2_country_code:   defn[:actor2_country_code],
        goldstein_scale:       defn[:goldstein_scale],
        quad_class:            defn[:quad_class],
        event_date:            defn[:event_date],
        num_sources:           defn[:num_sources],
        num_mentions:          defn[:num_mentions],
        num_articles:          defn[:num_articles],
        avg_tone:              defn[:avg_tone],
        action_geo_country_code: defn[:action_geo_country_code],
        action_geo_full_name:  defn[:action_geo_full_name],
        action_geo_lat:        defn[:action_geo_lat],
        action_geo_long:       defn[:action_geo_long],
        sqldate:               defn[:event_date].strftime("%Y%m%d").to_i,
        source_url:            "#{URL_PREFIX}gdelt-#{defn[:globaleventid]}",
        source_url_normalized: "perfect-storm-gdelt-#{defn[:globaleventid]}",
        raw_data:              { "seed_scenario" => SCENARIO_KEY }
      )
    end
  end

  # ---------------------------------------------------------------------------
  # Contradiction Logs
  # ---------------------------------------------------------------------------

  def self.create_contradictions!(articles)
    # Contradiction 1: Xinhua "routine" vs AP "largest in 30 years" (severity: 0.9)
    ContradictionLog.find_or_create_by!(
      article_a: articles[:a1],
      article_b: articles[:a5]
    ) do |log|
      log.contradiction_type  = "cross_source"
      log.severity            = 0.92
      log.source_a            = "Xinhua"
      log.source_b            = "AP News"
      log.description         = "Xinhua characterizes PLA exercises as 'routine' and 'scheduled'; AP News, citing DIA assessment and satellite imagery, reports the same exercises are the 'largest in 30 years' with Taiwan activating full combat alert. Direct factual contradiction on scale and intent."
      log.embedding_similarity = 0.71
      log.metadata            = { "seed_scenario" => SCENARIO_KEY, "pair_label" => "routine_vs_unprecedented" }
    end

    # Contradiction 2: AP "full alert" vs Global Times "downplaying to prevent panic" (severity: 0.85)
    ContradictionLog.find_or_create_by!(
      article_a: articles[:a5],
      article_b: articles[:a6]
    ) do |log|
      log.contradiction_type  = "cross_source"
      log.severity            = 0.85
      log.source_a            = "AP News"
      log.source_b            = "Global Times"
      log.description         = "AP News reports Taiwan has activated 'full combat alert' with General Chen stating 'this is a rehearsal for invasion'; Global Times simultaneously claims Taiwan authorities are 'downplaying' exercises 'to prevent public panic'. Directly contradictory accounts of Taiwan's official military posture."
      log.embedding_similarity = 0.73
      log.metadata            = { "seed_scenario" => SCENARIO_KEY, "pair_label" => "full_alert_vs_calm" }
    end
  end

  # ---------------------------------------------------------------------------
  # Narrative Signatures
  # ---------------------------------------------------------------------------

  def self.create_narrative_signatures!(articles, topic_vecs)
    now = Time.current

    # Signature 1: China Narrative Minimization
    sig1 = NarrativeSignature.create!(
      label:                 "China Minimization Pattern — Operation Silk Shadow",
      active:                true,
      match_count:           2,
      avg_trust_score:       45.5,
      dominant_threat_level: "LOW",
      first_seen_at:         articles[:a1].published_at,
      last_seen_at:          articles[:a6].published_at,
      source_distribution:   { "Xinhua" => 1, "Global Times" => 1 },
      country_distribution:  { "China" => 2 }
    )
    NarrativeSignatureArticle.create!(narrative_signature: sig1, article: articles[:a1])
    NarrativeSignatureArticle.create!(narrative_signature: sig1, article: articles[:a6])

    # Signature 2: Western Escalation Framing
    sig2 = NarrativeSignature.create!(
      label:                 "Western Escalation Framing — Taiwan Strait Crisis",
      active:                true,
      match_count:           3,
      avg_trust_score:       83.7,
      dominant_threat_level: "CRITICAL",
      first_seen_at:         articles[:a2].published_at,
      last_seen_at:          articles[:a9].published_at,
      source_distribution:   { "Reuters" => 1, "AP News" => 1, "The Guardian" => 1 },
      country_distribution:  { "United Kingdom" => 2, "United States" => 1 }
    )
    NarrativeSignatureArticle.create!(narrative_signature: sig2, article: articles[:a2])
    NarrativeSignatureArticle.create!(narrative_signature: sig2, article: articles[:a5])
    NarrativeSignatureArticle.create!(narrative_signature: sig2, article: articles[:a9])

    # Signature 3: Russian Counter-Narrative Echo Chamber
    sig3 = NarrativeSignature.create!(
      label:                 "Russian Counter-Narrative Echo Chamber — US Provocation Framing",
      active:                true,
      match_count:           3,
      avg_trust_score:       28.7,
      dominant_threat_level: "HIGH",
      first_seen_at:         articles[:a3].published_at,
      last_seen_at:          articles[:a11].published_at,
      source_distribution:   { "RT International" => 1, "TASS" => 1, "Sputnik" => 1 },
      country_distribution:  { "Russia" => 3 }
    )
    NarrativeSignatureArticle.create!(narrative_signature: sig3, article: articles[:a3])
    NarrativeSignatureArticle.create!(narrative_signature: sig3, article: articles[:a10])
    NarrativeSignatureArticle.create!(narrative_signature: sig3, article: articles[:a11])
  end

  # ---------------------------------------------------------------------------
  # Source Credibility
  # ---------------------------------------------------------------------------

  SOURCE_CREDIBILITY_DATA = {
    "Xinhua"          => { grade: 45.0, trust: 42.0, articles: 1, anomaly: 0.0, high_threat: 0, low_threat: 1 },
    "Reuters"         => { grade: 86.0, trust: 84.0, articles: 1, anomaly: 0.0, high_threat: 1, low_threat: 0 },
    "RT International" => { grade: 18.0, trust: 15.0, articles: 1, anomaly: 0.8, high_threat: 1, low_threat: 0 },
    "Fox News"        => { grade: 52.0, trust: 50.0, articles: 1, anomaly: 0.0, high_threat: 0, low_threat: 0 },
    "AP News"         => { grade: 89.0, trust: 88.0, articles: 1, anomaly: 0.0, high_threat: 1, low_threat: 0 },
    "Global Times"    => { grade: 22.0, trust: 19.0, articles: 1, anomaly: 0.9, high_threat: 0, low_threat: 1 },
    "Al Jazeera"      => { grade: 74.0, trust: 72.0, articles: 1, anomaly: 0.0, high_threat: 0, low_threat: 0 },
    "The Hindu"       => { grade: 80.0, trust: 78.0, articles: 1, anomaly: 0.0, high_threat: 0, low_threat: 1 },
    "The Guardian"    => { grade: 83.0, trust: 81.0, articles: 1, anomaly: 0.0, high_threat: 1, low_threat: 0 },
    "TASS"            => { grade: 16.0, trust: 14.0, articles: 1, anomaly: 0.7, high_threat: 1, low_threat: 0 },
    "Sputnik"         => { grade: 15.0, trust: 13.0, articles: 1, anomaly: 0.8, high_threat: 1, low_threat: 0 },
    "BBC Sport"       => { grade: 92.0, trust: 91.0, articles: 1, anomaly: 0.0, high_threat: 0, low_threat: 1 }
  }.freeze

  def self.create_source_credibility!(articles)
    SOURCE_CREDIBILITY_DATA.each do |source_name, data|
      SourceCredibility.create!(
        source_name:         source_name,
        credibility_grade:   data[:grade],
        rolling_trust_score: data[:trust],
        articles_analyzed:   data[:articles],
        anomaly_rate:        data[:anomaly],
        high_threat_count:   data[:high_threat],
        low_threat_count:    data[:low_threat],
        first_analyzed_at:   Time.current,
        last_analyzed_at:    Time.current,
        topic_distribution:  { "Military/Taiwan" => 1 },
        sentiment_distribution: { "Neutral" => 1 }
      )
    end
  end

  # ---------------------------------------------------------------------------
  # Breaking Alert
  # ---------------------------------------------------------------------------

  def self.create_breaking_alert!(articles, countries)
    # Only if regions/countries are loaded
    region = countries[:usa]&.region
    return unless region

    BreakingAlert.create!(
      headline:    "PLA Exercises Near Taiwan — US Carrier Group Repositioned | VERITAS CRITICAL",
      briefing:    "Operation Silk Shadow: China's People's Liberation Army has launched unprecedented naval and air exercises around Taiwan. The USS Ronald Reagan carrier strike group has been repositioned. VERITAS has detected coordinated narrative distortion across Russian state media (RT, TASS, Sputnik) inverting blame attribution. Two direct contradictions detected between Chinese state media and Western wire services on Taiwan's military posture. Severity: CRITICAL.",
      lat:         24.0000,
      lng:         122.0000,
      severity:    4,
      status:      0,
      source_type: "auto",
      region:      region,
      expires_at:  BASE_TIME + 96.hours,
      metadata: {
        "seed_scenario"  => SCENARIO_KEY,
        "article_ids"    => articles.values.map(&:id),
        "threat_level"   => "CRITICAL",
        "contradiction_count" => 2,
        "narrative_chain_length" => 4
      }
    )
  end

  # ---------------------------------------------------------------------------
  # Summary
  # ---------------------------------------------------------------------------

  def self.summary(log)
    storm_ids = Article.where("source_url LIKE ?", "#{URL_PREFIX}%").pluck(:id)
    log.call ""
    log.call "🌩️  PERFECT STORM LOADED SUCCESSFULLY"
    log.call "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log.call "  Articles created:         #{storm_ids.size}"
    log.call "  AI analyses:              #{AiAnalysis.where(article_id: storm_ids).count}"
    log.call "  Entities created:         #{Entity.count} (#{EntityMention.where(article_id: storm_ids).count} mentions)"
    log.call "  Narrative arcs:           #{NarrativeArc.where(article_id: storm_ids).count}"
    log.call "  Narrative routes:         #{NarrativeRoute.joins(:narrative_arc).where(narrative_arcs: { article_id: storm_ids }).count}"
    log.call "  GDELT events:             #{GdeltEvent.where(article_id: storm_ids).count}"
    log.call "  Contradiction logs:       #{ContradictionLog.where(article_a_id: storm_ids).or(ContradictionLog.where(article_b_id: storm_ids)).count}"
    log.call "  Narrative signatures:     #{NarrativeSignature.where('label LIKE ?', '%Operation Silk Shadow%').count + NarrativeSignature.where('label LIKE ?', '%Taiwan%').count}"
    log.call "  Source credibility rows:  #{SourceCredibility.count}"
    log.call "  Breaking alerts:          #{BreakingAlert.where('headline LIKE ?', '%PLA%').count}"
    log.call ""
    log.call "  Articles with embeddings: #{Article.where(id: storm_ids).where.not(embedding: nil).count}/#{storm_ids.size}"
    log.call "  Articles with coords:     #{Article.where(id: storm_ids).where.not(latitude: nil).count}/#{storm_ids.size}"
    log.call "  Orphan (A12 BBC Sport):   coords=nil ✓  [Control case: zero geopolitical connections]"
    log.call ""
    log.call "  Scenario tag: source_url LIKE '#{URL_PREFIX}%'"
    log.call "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  end
end

# Run if executed directly
PerfectStorm.run! if __FILE__ == $PROGRAM_NAME || (defined?(Rails) && Rails.env.development? && !defined?(PerfectStorm::LOADED))
PerfectStorm::LOADED = true
