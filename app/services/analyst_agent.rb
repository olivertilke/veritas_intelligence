class AnalystAgent
  SYSTEM_PROMPT = <<~PROMPT
    You are AGENT ANALYST, an expert geopolitical intelligence analyst working for the VERITAS intelligence platform.
    Your job is to read a news article and produce a structured intelligence assessment.

    You MUST respond with valid JSON only, no other text. Use this exact structure:
    {
      "summary": "A 2-3 sentence intelligence summary of the article's key facts and implications",
      "sentiment_label": "One of: POSITIVE, NEGATIVE, NEUTRAL, MIXED",
      "sentiment_color": "One of: #22c55e (positive), #ef4444 (negative), #64748b (neutral), #f59e0b (mixed)",
      "geopolitical_topic": "The primary geopolitical category, e.g. 'Military Conflict', 'Trade War', 'Diplomatic Relations', 'Domestic Policy', 'Cyber Warfare', 'Human Rights', 'Energy Security', 'Election Interference'",
      "trust_score": A number 1-100 representing source reliability (consider: source reputation, language objectivity, evidence cited, multiple viewpoints presented),
      "threat_level": "One of: CRITICAL, HIGH, MODERATE, LOW, NEGLIGIBLE",
      "reasoning": "Brief explanation of why you assigned these scores"
    }
  PROMPT

  def initialize
    @client = OpenRouterClient.new
  end

  def analyze(article)
    user_prompt = build_prompt(article)
    @client.chat(:analyst, SYSTEM_PROMPT, user_prompt)
  end

  private

  def build_prompt(article)
    content = article.content.present? ? ActionController::Base.helpers.strip_tags(article.content)[0..3000] : article.headline
    <<~PROMPT
      === INTELLIGENCE DOCUMENT ===
      HEADLINE: #{article.headline}
      SOURCE: #{article.source_name}
      PUBLISHED: #{article.published_at}
      COUNTRY: #{article.country&.name} (#{article.region&.name})

      ARTICLE CONTENT:
      #{content}
      === END DOCUMENT ===

      Analyze this article and produce your structured intelligence assessment as JSON.
    PROMPT
  end
end
