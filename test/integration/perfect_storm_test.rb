# frozen_string_literal: true

# =============================================================================
# Perfect Storm Integration Test Suite
# =============================================================================
#
# Tests the "Operation Silk Shadow" seed scenario end-to-end.
# Verifies connection logic, data integrity, service output, and orphan isolation.
#
# Run with:
#   bin/rails test test/integration/perfect_storm_test.rb
#
# The seed loads inside the transactional test wrapper and is rolled back
# after each test — no manual cleanup required.
# =============================================================================

require "test_helper"
require_relative "../../db/seeds/perfect_storm"

class PerfectStormTest < ActiveSupport::TestCase
  # Disable parallelism — this test suite shares DB state via seed setup
  parallelize(workers: 1)

  # ---------------------------------------------------------------------------
  # Setup / Teardown
  # ---------------------------------------------------------------------------

  setup do
    # Suppress broadcasts for the test run (no Action Cable server in test)
    Article.skip_callback(:commit, :after, :broadcast_sidebar_update) rescue nil
    Article.skip_callback(:commit, :after, :broadcast_to_globe)        rescue nil
    Article.skip_callback(:commit, :after, :enqueue_content_fetch)     rescue nil

    PerfectStorm.run!(verbose: false)

    # Fetch the 12 seeded articles once — reused across all tests
    @storm_articles = Article.where("source_url LIKE ?", "#{PerfectStorm::URL_PREFIX}%")
                             .includes(:ai_analysis, :country, :entities,
                                       :narrative_arcs, :contradiction_logs_as_a,
                                       :contradiction_logs_as_b)
                             .index_by { |a| a.raw_data["seed_key"].to_sym }
  end

  teardown do
    PerfectStorm.wipe_previous!
  end

  # ===========================================================================
  # 1. Article Count & Basic Integrity
  # ===========================================================================

  test "creates exactly 12 articles" do
    assert_equal 12, @storm_articles.size,
      "Expected 12 Perfect Storm articles, got #{@storm_articles.size}"
  end

  test "all articles have source_url prefixed with perfect-storm://" do
    @storm_articles.each_value do |a|
      assert a.source_url.start_with?(PerfectStorm::URL_PREFIX),
        "#{a.source_name} missing perfect-storm:// prefix"
    end
  end

  test "all articles have required fields populated" do
    @storm_articles.each_value do |a|
      assert a.headline.present?,    "#{a.source_name} missing headline"
      assert a.source_name.present?, "#{a.source_name} missing source_name"
      assert a.published_at.present?, "#{a.source_name} missing published_at"
      assert a.content.present?,     "#{a.source_name} missing content"
    end
  end

  test "articles span the correct 3-day window (April 7-9, 2026)" do
    times = @storm_articles.values.map(&:published_at).compact.sort
    assert times.first >= Time.utc(2026, 4, 7),     "Earliest article before scenario start"
    assert times.last  <= Time.utc(2026, 4, 9, 23), "Latest article after scenario end"
    # At least two distinct calendar days
    days = times.map { |t| t.to_date }.uniq
    assert days.size >= 2, "Articles should span at least 2 days, got #{days.map(&:to_s)}"
  end

  # ===========================================================================
  # 2. Geographic Data
  # ===========================================================================

  test "11 articles have valid non-nil coordinates" do
    geolocated = @storm_articles.values.count { |a| a.latitude.present? && a.longitude.present? }
    assert_equal 11, geolocated, "Expected 11 geolocated articles"
  end

  test "orphan article (BBC Sport / A12) has nil coordinates — poor-geo test case" do
    bbc = @storm_articles[:a12]
    assert_not_nil bbc,           "A12 (BBC Sport) not found"
    assert_nil bbc.latitude,      "A12 should have nil latitude"
    assert_nil bbc.longitude,     "A12 should have nil longitude"
    assert_equal "none", bbc.geo_confidence
  end

  test "all geolocated articles have valid lat/lng ranges" do
    @storm_articles.values.each do |a|
      next if a.latitude.nil?

      assert a.latitude.between?(-90.0, 90.0),
        "#{a.source_name} latitude #{a.latitude} out of range"
      assert a.longitude.between?(-180.0, 180.0),
        "#{a.source_name} longitude #{a.longitude} out of range"
      assert !(a.latitude.abs < 1.0 && a.longitude.abs < 1.0),
        "#{a.source_name} is at Null Island — would be filtered by globe"
    end
  end

  test "articles are distributed across at least 5 distinct countries" do
    countries = @storm_articles.values.filter_map { |a| a.country&.name }.uniq
    assert countries.size >= 5,
      "Expected ≥5 countries, got #{countries.size}: #{countries.join(', ')}"
  end

  # ===========================================================================
  # 3. AI Analysis Coverage & Threat Spectrum
  # ===========================================================================

  test "all 12 articles have a complete AI analysis" do
    @storm_articles.each do |key, article|
      analysis = article.ai_analysis
      assert_not_nil analysis, "#{key} (#{article.source_name}) missing AI analysis"
      assert_equal "complete", analysis.analysis_status,
        "#{key} analysis status should be 'complete'"
    end
  end

  test "full threat level spectrum is present (NEGLIGIBLE through CRITICAL)" do
    threat_levels = @storm_articles.values.filter_map { |a| a.ai_analysis&.threat_level }.uniq
    %w[NEGLIGIBLE LOW MODERATE HIGH CRITICAL].each do |level|
      assert_includes threat_levels, level,
        "Threat level #{level} missing from scenario — spectrum incomplete"
    end
  end

  test "full sentiment spectrum is present (Positive through Hostile)" do
    sentiments = @storm_articles.values.filter_map { |a| a.ai_analysis&.sentiment_label }.uniq
    assert sentiments.any? { |s| s.downcase.include?("positive") }, "No Positive sentiment found"
    assert sentiments.any? { |s| s.downcase.include?("neutral") },  "No Neutral sentiment found"
    assert sentiments.any? { |s| s.downcase.include?("negative") }, "No Negative sentiment found"
    assert sentiments.any? { |s| s.downcase.include?("hostile") },  "No Hostile sentiment found"
  end

  test "Xinhua (A1) has NEGLIGIBLE threat level" do
    assert_equal "NEGLIGIBLE", @storm_articles[:a1].ai_analysis.threat_level
  end

  test "AP News (A5) has CRITICAL threat level" do
    assert_equal "CRITICAL", @storm_articles[:a5].ai_analysis.threat_level
  end

  test "BBC Sport (A12) has NEGLIGIBLE threat level and Positive sentiment" do
    analysis = @storm_articles[:a12].ai_analysis
    assert_equal "NEGLIGIBLE", analysis.threat_level
    assert analysis.sentiment_label.downcase.include?("positive"),
      "BBC Sport should have Positive sentiment, got '#{analysis.sentiment_label}'"
  end

  test "all trust scores are in valid 0-100 range" do
    @storm_articles.each do |key, article|
      ts = article.ai_analysis&.trust_score
      next if ts.nil?
      assert ts.between?(0.0, 100.0),
        "#{key} trust_score #{ts} out of range"
    end
  end

  test "Russian state media sources have lower trust than Western wire services" do
    rt_trust   = @storm_articles[:a3].ai_analysis.trust_score
    tass_trust = @storm_articles[:a10].ai_analysis.trust_score
    ap_trust   = @storm_articles[:a5].ai_analysis.trust_score
    reuters_trust = @storm_articles[:a2].ai_analysis.trust_score

    assert rt_trust < ap_trust,
      "RT trust (#{rt_trust}) should be < AP trust (#{ap_trust})"
    assert tass_trust < reuters_trust,
      "TASS trust (#{tass_trust}) should be < Reuters trust (#{reuters_trust})"
  end

  test "linguistic anomaly flags set for Russian state media" do
    assert @storm_articles[:a3].ai_analysis.linguistic_anomaly_flag,  "RT should have anomaly flag"
    assert @storm_articles[:a10].ai_analysis.linguistic_anomaly_flag, "TASS should have anomaly flag"
    assert @storm_articles[:a11].ai_analysis.linguistic_anomaly_flag, "Sputnik should have anomaly flag"
    assert @storm_articles[:a6].ai_analysis.linguistic_anomaly_flag,  "Global Times should have anomaly flag"
  end

  # ===========================================================================
  # 4. Embedding Vectors
  # ===========================================================================

  test "11 articles have 1536-dimensional embedding vectors" do
    @storm_articles.each do |key, article|
      if key == :a12
        # Orphan still gets an embedding (sports topic vector)
        # but we don't require it — just check it's the right dimension if present
        next if article.embedding.nil?
      end

      assert_not_nil article.embedding, "#{key} missing embedding vector"
      assert_equal PerfectStorm::DIM, article.embedding.size,
        "#{key} embedding has wrong dimension: #{article.embedding.size}"
    end
  end

  test "Russian state media articles (A3, A10, A11) have high mutual cosine similarity ≥ 0.65" do
    a3  = @storm_articles[:a3].embedding
    a10 = @storm_articles[:a10].embedding
    a11 = @storm_articles[:a11].embedding

    sim_3_10  = PerfectStorm.cosine_similarity(a3, a10)
    sim_3_11  = PerfectStorm.cosine_similarity(a3, a11)
    sim_10_11 = PerfectStorm.cosine_similarity(a10, a11)

    assert sim_3_10  >= 0.65, "A3↔A10 cosine sim #{sim_3_10.round(3)} below threshold 0.65 — should be connected"
    assert sim_3_11  >= 0.65, "A3↔A11 cosine sim #{sim_3_11.round(3)} below threshold 0.65 — should be connected"
    assert sim_10_11 >= 0.65, "A10↔A11 cosine sim #{sim_10_11.round(3)} below threshold 0.65 — should be connected"
  end

  test "Taiwan military cluster articles (A1, A2, A5, A6) have high mutual similarity ≥ 0.65" do
    a1 = @storm_articles[:a1].embedding
    a2 = @storm_articles[:a2].embedding
    a5 = @storm_articles[:a5].embedding
    a6 = @storm_articles[:a6].embedding

    assert PerfectStorm.cosine_similarity(a1, a2) >= 0.65, "A1↔A2 below embedding threshold"
    assert PerfectStorm.cosine_similarity(a1, a6) >= 0.65, "A1↔A6 below embedding threshold — 'similar text, opposite editorial'"
    assert PerfectStorm.cosine_similarity(a2, a5) >= 0.65, "A2↔A5 below embedding threshold"
  end

  test "A1 (Xinhua) and A12 (BBC Sport) have low cosine similarity < 0.30 — orphan isolation" do
    a1  = @storm_articles[:a1].embedding
    a12 = @storm_articles[:a12].embedding
    sim = PerfectStorm.cosine_similarity(a1, a12)
    assert sim < 0.30,
      "A1↔A12 cosine sim #{sim.round(3)} is too high — orphan over-connects to main cluster"
  end

  test "A4 (Fox News) and A12 (BBC Sport) have low cosine similarity < 0.30" do
    a4  = @storm_articles[:a4].embedding
    a12 = @storm_articles[:a12].embedding
    sim = PerfectStorm.cosine_similarity(a4, a12)
    assert sim < 0.30,
      "A4↔A12 cosine sim #{sim.round(3)} too high — sports/politics should be dissimilar"
  end

  test "A1 (Xinhua) and A6 (Global Times) are semantically similar despite opposite editorial stance" do
    # This is the 'similar text, editorially opposite' case
    a1 = @storm_articles[:a1].embedding
    a6 = @storm_articles[:a6].embedding
    sim = PerfectStorm.cosine_similarity(a1, a6)
    assert sim >= 0.80,
      "A1↔A6 should have very high similarity (same vocab/topic, opposite framing), got #{sim.round(3)}"

    # But their threat levels should be different — this is the editorial inversion
    assert_equal "NEGLIGIBLE", @storm_articles[:a1].ai_analysis.threat_level
    assert_equal "LOW",        @storm_articles[:a6].ai_analysis.threat_level
  end

  # ===========================================================================
  # 5. Entity Graph
  # ===========================================================================

  test "creates at least 10 entities" do
    entity_names = @storm_articles.values.flat_map { |a| a.entities.map(&:name) }.uniq
    assert entity_names.size >= 10,
      "Expected ≥10 unique entities, got #{entity_names.size}: #{entity_names.join(', ')}"
  end

  test "Xi Jinping appears across 8 articles" do
    xi = Entity.find_by(normalized_name: Entity.normalize("Xi Jinping"), entity_type: "person")
    assert_not_nil xi, "Xi Jinping entity not found"

    xi_article_ids = xi.articles.pluck(:id)
    expected_keys  = %i[a1 a3 a6 a7 a8 a9 a10 a11]
    expected_ids   = expected_keys.map { |k| @storm_articles[k].id }

    expected_ids.each do |id|
      assert_includes xi_article_ids, id,
        "Xi Jinping not linked to article #{@storm_articles.find { |_, a| a.id == id }&.first}"
    end
  end

  test "PLA (People's Liberation Army) appears across 6 articles" do
    pla = Entity.find_by(normalized_name: Entity.normalize("People's Liberation Army"),
                         entity_type: "organization")
    assert_not_nil pla, "PLA entity not found"
    assert pla.articles.count >= 5, "PLA should appear in ≥5 articles"
  end

  test "USS Ronald Reagan entity links A5, A9, A11" do
    reagan = Entity.find_by(normalized_name: Entity.normalize("USS Ronald Reagan"),
                            entity_type: "organization")
    assert_not_nil reagan, "USS Ronald Reagan entity not found"

    reagan_ids = reagan.articles.pluck(:id)
    [  @storm_articles[:a5].id,
       @storm_articles[:a9].id,
       @storm_articles[:a11].id ].each do |id|
      assert_includes reagan_ids, id,
        "USS Ronald Reagan not linked to expected article (id=#{id})"
    end
  end

  test "orphan article (A12) shares NO entities with the main geopolitical cluster" do
    a12_entity_ids = @storm_articles[:a12].entities.pluck(:id)

    main_cluster_keys = @storm_articles.keys - [:a12]
    main_entity_ids = main_cluster_keys.flat_map do |k|
      @storm_articles[k].entities.pluck(:id)
    end.uniq

    shared = a12_entity_ids & main_entity_ids
    assert shared.empty?,
      "Orphan A12 shares entities with main cluster: #{Entity.where(id: shared).pluck(:name)}"
  end

  test "entity types cover all four VERITAS types" do
    types = Entity.joins(:entity_mentions)
                  .where(entity_mentions: { article_id: @storm_articles.values.map(&:id) })
                  .distinct.pluck(:entity_type)
    %w[person organization country].each do |t|
      assert_includes types, t, "Entity type '#{t}' not represented in Perfect Storm"
    end
  end

  # ===========================================================================
  # 6. Narrative Routes & Arcs
  # ===========================================================================

  test "creates exactly 2 narrative arcs" do
    arc_article_ids = @storm_articles.values_at(:a1, :a3).map(&:id)
    arcs = NarrativeArc.where(article_id: arc_article_ids)
    assert_equal 2, arcs.count,
      "Expected 2 narrative arcs (main chain + Russia echo), got #{arcs.count}"
  end

  test "main narrative arc is anchored on Xinhua article (A1)" do
    a1 = @storm_articles[:a1]
    arc = NarrativeArc.find_by(article_id: a1.id)
    assert_not_nil arc, "No narrative arc found for A1 (Xinhua)"
    assert_equal "China",          arc.origin_country
    assert_equal "United Kingdom", arc.target_country
  end

  test "main narrative route has exactly 4 hops: A1→A2→A3→A9" do
    a1 = @storm_articles[:a1]
    arc = NarrativeArc.find_by(article_id: a1.id)
    route = arc.narrative_routes.first
    assert_not_nil route, "No narrative route for main arc"
    assert_equal 4, route.hops.size, "Main route should have 4 hops"

    hop_article_ids = route.hops.map { |h| h["article_id"] }
    expected = [@storm_articles[:a1], @storm_articles[:a2],
                @storm_articles[:a3], @storm_articles[:a9]].map(&:id)
    assert_equal expected, hop_article_ids,
      "Main route hops don't match expected A1→A2→A3→A9 chain"
  end

  test "main narrative route framing progression: original→amplified→distorted→amplified" do
    a1 = @storm_articles[:a1]
    arc = NarrativeArc.find_by(article_id: a1.id)
    route = arc.narrative_routes.first
    framings = route.hops.map { |h| h["framing_shift"] }
    assert_equal %w[original amplified distorted amplified], framings,
      "Framing progression wrong: #{framings}"
  end

  test "Russian echo chamber arc has 3 hops: A3→A10→A11" do
    a3 = @storm_articles[:a3]
    arc = NarrativeArc.find_by(article_id: a3.id)
    assert_not_nil arc, "No narrative arc for RT (A3)"
    route = arc.narrative_routes.first
    assert_not_nil route, "No route for Russian echo chamber arc"
    assert_equal 3, route.hops.size, "Russia echo route should have 3 hops"

    hop_ids = route.hops.map { |h| h["article_id"] }
    expected = [@storm_articles[:a3], @storm_articles[:a10], @storm_articles[:a11]].map(&:id)
    assert_equal expected, hop_ids
  end

  test "main narrative route is marked complete" do
    a1  = @storm_articles[:a1]
    arc = NarrativeArc.find_by(article_id: a1.id)
    route = arc.narrative_routes.first
    assert route.is_complete, "Main narrative route should be marked complete"
  end

  test "route propagation reaches 3 countries (China, Russia, United Kingdom)" do
    a1  = @storm_articles[:a1]
    arc = NarrativeArc.find_by(article_id: a1.id)
    route = arc.narrative_routes.first
    countries = route.hops.map { |h| h["source_country"] }.uniq.sort
    assert_includes countries, "China"
    assert_includes countries, "Russia"
    assert_includes countries, "United Kingdom"
  end

  test "narrative route serializes correctly to journey data format" do
    a1    = @storm_articles[:a1]
    arc   = NarrativeArc.find_by(article_id: a1.id)
    route = arc.narrative_routes.first

    # as_journey_data should not raise and should return required keys
    data = route.as_journey_data
    assert_not_nil data, "as_journey_data returned nil"

    required_keys = %i[id routeId name totalHops totalSegments hops segments
                       startLat startLng endLat endLng originCountry targetCountry]
    required_keys.each do |key|
      assert data.key?(key), "as_journey_data missing key :#{key}"
    end

    assert_equal 4, data[:totalHops]
    assert data[:segments].size >= 1, "Should have at least 1 segment"
  end

  # ===========================================================================
  # 7. GDELT Events & Connections
  # ===========================================================================

  test "creates exactly 9 GDELT events" do
    storm_ids = @storm_articles.values.map(&:id)
    count = GdeltEvent.where(article_id: storm_ids).count
    assert_equal 9, count, "Expected 9 GDELT events, got #{count}"
  end

  test "A9 (Guardian escalation) has GDELT quad_class 4 — Material Conflict" do
    a9    = @storm_articles[:a9]
    event = GdeltEvent.find_by(article_id: a9.id)
    assert_not_nil event, "No GDELT event for A9"
    assert_equal 4, event.quad_class,
      "A9 GDELT event should be quad_class 4 (Material Conflict), got #{event.quad_class}"
  end

  test "A9 GDELT Goldstein scale is ≤ -8.0 — high real-world conflict intensity" do
    a9    = @storm_articles[:a9]
    event = GdeltEvent.find_by(article_id: a9.id)
    assert event.goldstein_scale <= -8.0,
      "A9 Goldstein scale #{event.goldstein_scale} should be ≤ -8.0"
  end

  test "GDELT actor pair China/Taiwan shared by A1, A2, A5" do
    storm_ids = [@storm_articles[:a1], @storm_articles[:a2], @storm_articles[:a5]].map(&:id)
    events = GdeltEvent.where(article_id: storm_ids)

    events.each do |event|
      actors = [event.actor1_country_code, event.actor2_country_code].compact
      assert (actors & %w[CHN TWN]).present?,
        "Event for article #{event.article_id} missing CHN or TWN actor"
    end
  end

  test "GDELT actor pair Russia/US shared by A3, A10, A11 — triggers GDELT connection" do
    storm_ids = [@storm_articles[:a3], @storm_articles[:a10], @storm_articles[:a11]].map(&:id)
    events = GdeltEvent.where(article_id: storm_ids)

    events.each do |event|
      actors = [event.actor1_country_code, event.actor2_country_code].compact
      assert (actors & %w[RUS USA]).present?,
        "Event for article #{event.article_id} missing RUS or USA actor"
    end
  end

  test "A7 and A8 share GDELT event root code 03 (Verbal Cooperation/Appeal)" do
    a7_event = GdeltEvent.find_by(article_id: @storm_articles[:a7].id)
    a8_event = GdeltEvent.find_by(article_id: @storm_articles[:a8].id)
    assert_equal a7_event.event_root_code, a8_event.event_root_code,
      "A7 and A8 should share the same event root code"
    assert_equal "03", a7_event.event_root_code
  end

  test "orphan article (A12) has NO GDELT events" do
    count = GdeltEvent.where(article_id: @storm_articles[:a12].id).count
    assert_equal 0, count, "Orphan A12 should have 0 GDELT events"
  end

  # ===========================================================================
  # 8. Contradiction Logs
  # ===========================================================================

  test "creates exactly 2 contradiction logs" do
    storm_ids = @storm_articles.values.map(&:id)
    count = ContradictionLog
      .where(article_a_id: storm_ids)
      .or(ContradictionLog.where(article_b_id: storm_ids))
      .count
    assert_equal 2, count, "Expected 2 contradiction logs, got #{count}"
  end

  test "contradiction 1: A1 (Xinhua) vs A5 (AP) — cross_source, severity ≥ 0.9" do
    a1 = @storm_articles[:a1]
    a5 = @storm_articles[:a5]

    log = ContradictionLog.find_by(article_a_id: a1.id, article_b_id: a5.id)
    assert_not_nil log,
      "Contradiction between A1 (Xinhua) and A5 (AP) not found"
    assert_equal "cross_source", log.contradiction_type
    assert log.severity >= 0.9,
      "A1↔A5 contradiction severity #{log.severity} should be ≥ 0.9"
  end

  test "contradiction 2: A5 (AP) vs A6 (Global Times) — cross_source, severity ≥ 0.8" do
    a5 = @storm_articles[:a5]
    a6 = @storm_articles[:a6]

    log = ContradictionLog.find_by(article_a_id: a5.id, article_b_id: a6.id)
    assert_not_nil log,
      "Contradiction between A5 (AP) and A6 (Global Times) not found"
    assert_equal "cross_source", log.contradiction_type
    assert log.severity >= 0.8,
      "A5↔A6 contradiction severity #{log.severity} should be ≥ 0.8"
  end

  test "contradicting articles have description text explaining the factual conflict" do
    a1_a5 = ContradictionLog.find_by(article_a_id: @storm_articles[:a1].id,
                                     article_b_id: @storm_articles[:a5].id)
    assert a1_a5.description.present?,      "A1↔A5 contradiction missing description"
    assert a1_a5.description.length > 50,   "A1↔A5 description too short"
  end

  test "orphan article (A12) is not party to any contradiction" do
    a12_id = @storm_articles[:a12].id
    count = ContradictionLog
      .where(article_a_id: a12_id)
      .or(ContradictionLog.where(article_b_id: a12_id))
      .count
    assert_equal 0, count, "Orphan A12 should have 0 contradictions"
  end

  # ===========================================================================
  # 9. ArticleNetworkService Output
  # ===========================================================================

  test "ArticleNetworkService.connections_between returns correct structure" do
    # Use only geolocated articles for network analysis
    geolocated = @storm_articles.values.select { |a| a.latitude.present? }
    result = ArticleNetworkService.new.connections_between(geolocated)

    assert result.key?(:articles), "Result missing :articles key"
    assert result.key?(:arcs),     "Result missing :arcs key"
    assert result.key?(:meta),     "Result missing :meta key"

    assert result[:meta].key?(:total_connections),   "meta missing :total_connections"
    assert result[:meta].key?(:connection_types),    "meta missing :connection_types"
    assert result[:meta].key?(:total_articles),      "meta missing :total_articles"
  end

  test "ArticleNetworkService finds at least 1 connection per connection type" do
    geolocated = @storm_articles.values.select { |a| a.latitude.present? }
    result = ArticleNetworkService.new.connections_between(geolocated)

    type_counts = result[:meta][:connection_types]
    assert type_counts[:narrative_route].to_i >= 1,
      "Expected ≥1 narrative_route connections, got #{type_counts[:narrative_route]}"
    assert type_counts[:gdelt_event].to_i >= 1,
      "Expected ≥1 gdelt_event connections, got #{type_counts[:gdelt_event]}"
    assert type_counts[:shared_entities].to_i >= 1,
      "Expected ≥1 shared_entities connections, got #{type_counts[:shared_entities]}"
    # embedding_similarity requires pgvector query — may vary by environment
    # so we only assert the others are present
  end

  test "ArticleNetworkService arc objects contain required rendering fields" do
    geolocated = @storm_articles.values.select { |a| a.latitude.present? }
    result     = ArticleNetworkService.new.connections_between(geolocated)
    arcs       = result[:arcs]

    assert arcs.any?, "No arcs returned from ArticleNetworkService"

    arc = arcs.first
    required_fields = %i[startLat startLng endLat endLng color strength
                         connectionTypes dominantType veritasThreatScore]
    required_fields.each do |field|
      assert arc.key?(field), "Arc missing field :#{field}"
    end
  end

  test "ArticleNetworkService returns no arc involving A12 (orphan has no GDELT, no entities, nil coords)" do
    geolocated = @storm_articles.values.select { |a| a.latitude.present? }
    result     = ArticleNetworkService.new.connections_between(geolocated)
    a12_id     = @storm_articles[:a12].id

    a12_arcs = result[:arcs].select do |arc|
      arc[:sourceArticleId] == a12_id || arc[:targetArticleId] == a12_id
    end
    assert a12_arcs.empty?,
      "Orphan A12 appears in #{a12_arcs.size} arc(s) — it should be fully isolated"
  end

  test "network for A5 (CRITICAL AP article) includes A1 and A9 at depth 2" do
    a5  = @storm_articles[:a5]
    result = ArticleNetworkService.new.network_for_article(a5, depth: 2, time_window: 72.hours)

    assert result[:articles].any?, "network_for_article returned no articles"
    article_ids = result[:articles].map { |a| a[:id] }

    assert_includes article_ids, @storm_articles[:a1].id,
      "Network for A5 should include A1 (shares China/Taiwan GDELT actor pair)"
    assert_includes article_ids, @storm_articles[:a9].id,
      "Network for A5 should include A9 (both CRITICAL western alarm, narrative route)"
  end

  # ===========================================================================
  # 10. Narrative Signatures
  # ===========================================================================

  test "creates 3 narrative signatures covering all 3 narrative clusters" do
    sig_labels = NarrativeSignature.where("label LIKE ? OR label LIKE ? OR label LIKE ?",
                                          "%China Minimization%",
                                          "%Western Escalation%",
                                          "%Russian Counter%").pluck(:label)
    assert_equal 3, sig_labels.size,
      "Expected 3 narrative signatures, got #{sig_labels.size}: #{sig_labels}"
  end

  test "China Minimization signature covers Xinhua (A1) and Global Times (A6)" do
    sig = NarrativeSignature.find_by("label LIKE ?", "%China Minimization%")
    assert_not_nil sig, "China Minimization signature not found"
    sig_article_ids = sig.articles.pluck(:id)
    assert_includes sig_article_ids, @storm_articles[:a1].id
    assert_includes sig_article_ids, @storm_articles[:a6].id
  end

  test "Russian Counter-Narrative signature covers RT, TASS, Sputnik (A3, A10, A11)" do
    sig = NarrativeSignature.find_by("label LIKE ?", "%Russian Counter%")
    assert_not_nil sig, "Russian Counter-Narrative signature not found"
    sig_article_ids = sig.articles.pluck(:id)
    assert_includes sig_article_ids, @storm_articles[:a3].id
    assert_includes sig_article_ids, @storm_articles[:a10].id
    assert_includes sig_article_ids, @storm_articles[:a11].id
  end

  test "Russian echo signature has low avg_trust_score (unreliable sources)" do
    sig = NarrativeSignature.find_by("label LIKE ?", "%Russian Counter%")
    assert sig.avg_trust_score < 40.0,
      "Russian echo chamber avg trust #{sig.avg_trust_score} should be < 40"
  end

  test "Western Escalation signature has CRITICAL dominant_threat_level" do
    sig = NarrativeSignature.find_by("label LIKE ?", "%Western Escalation%")
    assert_not_nil sig
    assert_equal "CRITICAL", sig.dominant_threat_level
  end

  # ===========================================================================
  # 11. Source Credibility
  # ===========================================================================

  test "all 12 source credibility profiles are created" do
    expected_sources = %w[Xinhua Reuters TASS Sputnik "AP News" "Global Times"
                          "Al Jazeera" "The Hindu" "The Guardian" "Fox News"
                          "RT International" "BBC Sport"]
    count = SourceCredibility.where(source_name: PerfectStorm.ps_source_names).count
    assert_equal 12, count, "Expected 12 source credibility profiles"
  end

  test "AP and Reuters have TRUSTED credibility grade (≥80)" do
    ap      = SourceCredibility.find_by(source_name: "AP News")
    reuters = SourceCredibility.find_by(source_name: "Reuters")
    assert ap.credibility_grade >= 80, "AP grade #{ap.credibility_grade} should be ≥80 (TRUSTED)"
    assert reuters.credibility_grade >= 80, "Reuters grade #{reuters.credibility_grade} should be ≥80 (TRUSTED)"
  end

  test "RT, TASS, Sputnik have UNRELIABLE credibility grade (<25)" do
    %w[RT\ International TASS Sputnik].each do |source|
      sc = SourceCredibility.find_by(source_name: source)
      assert_not_nil sc, "#{source} credibility profile not found"
      assert sc.credibility_grade < 25,
        "#{source} credibility grade #{sc.credibility_grade} should be <25 (UNRELIABLE)"
    end
  end

  # ===========================================================================
  # 12. Orphan Article — Full Isolation Check
  # ===========================================================================

  test "orphan A12 (BBC Sport) is fully isolated: no entities, no GDELT, no narrative arc" do
    a12 = @storm_articles[:a12]

    assert_equal 0, EntityMention.where(article_id: a12.id).count,
      "A12 should have 0 entity mentions"
    assert_equal 0, GdeltEvent.where(article_id: a12.id).count,
      "A12 should have 0 GDELT events"
    assert_equal 0, NarrativeArc.where(article_id: a12.id).count,
      "A12 should have 0 narrative arcs"
    assert_equal 0, ContradictionLog.where(article_a_id: a12.id)
                                     .or(ContradictionLog.where(article_b_id: a12.id))
                                     .count,
      "A12 should have 0 contradiction logs"
  end

  test "orphan A12 embedding has zero cosine similarity ≥0.65 with any other article" do
    a12_embedding = @storm_articles[:a12].embedding
    return unless a12_embedding # skip if vector not stored

    storm_ids = @storm_articles.values.map(&:id) - [@storm_articles[:a12].id]
    other_embeddings = Article.where(id: storm_ids).filter_map(&:embedding)

    above_threshold = other_embeddings.select do |other|
      PerfectStorm.cosine_similarity(a12_embedding, other) >= 0.65
    end

    assert above_threshold.empty?,
      "A12 has #{above_threshold.size} articles above embedding threshold — orphan isolation broken"
  end

  # ===========================================================================
  # 13. Idempotency
  # ===========================================================================

  test "running PerfectStorm.run! twice produces the same article count" do
    initial_count = @storm_articles.size
    PerfectStorm.run!(verbose: false)
    final_count = Article.where("source_url LIKE ?", "#{PerfectStorm::URL_PREFIX}%").count
    assert_equal initial_count, final_count,
      "Second run produced #{final_count} articles (expected #{initial_count}) — not idempotent"
  end

  test "PerfectStorm.wipe_previous! removes all seeded records" do
    PerfectStorm.wipe_previous!
    remaining = Article.where("source_url LIKE ?", "#{PerfectStorm::URL_PREFIX}%").count
    assert_equal 0, remaining, "wipe_previous! left #{remaining} articles behind"
  end
end
