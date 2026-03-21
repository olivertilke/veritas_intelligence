class EmbeddingService
  def initialize
    @client = OpenRouterClient.new
  end

  def generate(article)
    # Demo mode: skip if article already has an embedding, never call external API
    if VeritasMode.demo?
      return article.embedding.present?
    end

    # Ensure there's enough text to embed — headline is the minimum viable fallback
    return false unless article.headline.present? || article.content.present? || article.ai_analysis&.summary.present?

    Rails.logger.info "[SEMANTIC INTEL] Generating embedding for Article ##{article.id}"

    # We combine the most semantically dense parts of the article
    # Falls back to headline-only if content and summary are unavailable
    text_to_embed = [
      ("HEADLINE: #{article.headline}" if article.headline.present?),
      ("TOPIC: #{article.ai_analysis&.geopolitical_topic || 'Unknown'}" if article.ai_analysis&.geopolitical_topic.present?),
      ("SUMMARY: #{article.ai_analysis&.summary}" if article.ai_analysis&.summary.present?),
      (ActionController::Base.helpers.strip_tags(article.content.to_s)[0..1000] if article.content.present?)
    ].compact.join("\n\n")

    begin
      vector = @client.embed(text_to_embed)
      
      if vector && vector.length == 1536
        article.update!(embedding: vector)
        Rails.logger.info "[SEMANTIC INTEL] ✅ Vector (1536 dims) saved for Article ##{article.id}"
        true
      else
        Rails.logger.error "[SEMANTIC INTEL] ❌ Invalid vector received: #{vector&.length} dims"
        false
      end
    rescue StandardError => e
      Rails.logger.error "[SEMANTIC INTEL] ❌ Failed to generate embedding: #{e.message}"
      false
    end
  end
end
