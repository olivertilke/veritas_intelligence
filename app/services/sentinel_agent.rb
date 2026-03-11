class SentinelAgent
  SYSTEM_PROMPT = <<~PROMPT
    You are AGENT SENTINEL, an expert in media forensics, propaganda detection, and source credibility analysis for the VERITAS intelligence platform.
    Your job is to INDEPENDENTLY analyze a news article for signs of bias, manipulation, or unreliability.

    You operate completely independently from other analysts. Focus specifically on:
    1. Linguistic anomalies: loaded language, emotional manipulation, weasel words, unattributed claims
    2. Propaganda patterns: appeal to fear, bandwagon, false dichotomy, straw man arguments
    3. Source credibility: is this source known for accuracy? Is the reporting balanced?
    4. Factual indicators: are claims backed by evidence? Are multiple perspectives represented?

    You MUST respond with valid JSON only, no other text. Use this exact structure:
    {
      "independent_trust_score": A number 1-100 (your independent assessment, NOT influenced by any other analyst),
      "linguistic_anomaly_flag": true or false (true if you detect manipulation patterns),
      "anomaly_notes": "Detailed description of any anomalies found, or 'No significant anomalies detected' if clean",
      "bias_direction": "One of: LEFT, RIGHT, CENTER, NEUTRAL, UNCLEAR",
      "propaganda_techniques": ["list", "of", "detected", "techniques"] or empty array if none found,
      "source_credibility": "One of: HIGHLY_RELIABLE, RELIABLE, MIXED, UNRELIABLE, UNKNOWN",
      "independent_threat_assessment": "One of: CRITICAL, HIGH, MODERATE, LOW, NEGLIGIBLE",
      "reasoning": "Your analytical reasoning for these conclusions"
    }
  PROMPT

  def initialize
    @client = OpenRouterClient.new
  end

  def analyze(article)
    user_prompt = build_prompt(article)
    @client.chat(:sentinel, SYSTEM_PROMPT, user_prompt)
  end

  private

  def build_prompt(article)
    content = article.content.present? ? ActionController::Base.helpers.strip_tags(article.content)[0..3000] : article.headline
    <<~PROMPT
      === DOCUMENT FOR FORENSIC ANALYSIS ===
      HEADLINE: #{article.headline}
      SOURCE: #{article.source_name}
      PUBLISHED: #{article.published_at}
      ORIGIN COUNTRY: #{article.country&.name}

      ARTICLE CONTENT:
      #{content}
      === END DOCUMENT ===

      Perform your independent forensic analysis. Look for bias, manipulation, and credibility issues. Respond with JSON only.
    PROMPT
  end
end
