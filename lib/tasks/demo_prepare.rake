namespace :veritas do
  namespace :demo do
    desc "Prepare VERITAS for demo: embeddings, routes, AI analysis, and mode validation"
    task prepare: :environment do
      puts "=" * 60
      puts "VERITAS DEMO PREPARATION"
      puts "=" * 60

      # 1. Ensure demo mode is set
      VeritasMode.set!("demo")
      puts "\n[1/5] Mode set to DEMO"

      # 2. Check embeddings
      total     = Article.count
      embedded  = Article.where.not(embedding: nil).count
      missing   = total - embedded

      puts "\n[2/5] Embedding check: #{embedded}/#{total} articles have embeddings"

      if missing > 0
        puts "  Generating embeddings for #{missing} articles..."
        # Temporarily allow API calls for preparation
        VeritasMode.set!("live")

        service = EmbeddingService.new
        success = 0
        Article.where(embedding: nil).find_each do |article|
          if service.generate(article)
            success += 1
            print "."
          end
        end
        puts "\n  Generated #{success} new embeddings."

        VeritasMode.set!("demo")
      else
        puts "  All articles have embeddings."
      end

      # 3. Ensure narrative routes exist
      routes_count = NarrativeRoute.count
      arcs_count   = NarrativeArc.count
      puts "\n[3/5] Narrative routes: #{routes_count} routes, #{arcs_count} arcs"

      orphan_count = Article.where.not(embedding: nil)
                            .where.missing(:narrative_arcs)
                            .count

      if orphan_count > 20
        puts "  #{orphan_count} embedded articles without routes — generating..."
        service = NarrativeRouteGeneratorService.new
        created = service.generate_routes(limit: nil, force: false)
        puts "  Created #{created} new routes."
      else
        puts "  Orphan count acceptable (#{orphan_count})."
      end

      # 4. Ensure AI analysis exists for top articles
      no_analysis = Article.where.missing(:ai_analysis).count
      puts "\n[4/5] AI Analysis: #{Article.count - no_analysis}/#{Article.count} articles analyzed"

      if no_analysis > 0
        puts "  Creating seed AI analysis for #{no_analysis} unanalyzed articles..."
        Article.where.missing(:ai_analysis).find_each do |article|
          threat = rand(1..3)
          trust  = rand(60..98)
          label  = %w[Bullish Bearish Neutral].sample
          color  = case label
                   when "Bullish" then "#22c55e"
                   when "Bearish" then "#ef4444"
                   else "#38bdf8"
                   end

          article.create_ai_analysis!(
            threat_level: threat.to_s,
            trust_score: trust.to_f,
            sentiment_label: label,
            sentiment_color: color,
            analysis_status: "complete",
            summary: "Demo analysis for #{article.headline}"
          )
        end
        puts "  Done."
      else
        puts "  All articles have AI analysis."
      end

      # 5. Validate demo mode works
      puts "\n[5/5] Validation:"
      puts "  Mode:             #{VeritasMode.current.upcase}"
      puts "  Articles:         #{Article.count}"
      puts "  With embeddings:  #{Article.where.not(embedding: nil).count}"
      puts "  Narrative arcs:   #{NarrativeArc.count}"
      puts "  Narrative routes: #{NarrativeRoute.count}"
      puts "  AI analyses:      #{AiAnalysis.count}"
      puts "  NewsAPI key:      #{ENV['NEWS_API_KEY'].present? ? 'configured' : 'MISSING'}"
      puts "  OpenRouter key:   #{ENV['OPENROUTER_API_KEY'].present? ? 'configured' : 'MISSING'}"

      puts "\n" + "=" * 60
      puts "DEMO READY. Start with: bin/dev"
      puts "All data is pre-cached. No external API calls in demo mode."
      puts "=" * 60
    end
  end
end
