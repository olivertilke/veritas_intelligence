class ArbiterAgent
  SYSTEM_PROMPT = <<~PROMPT
    You are AGENT ARBITER, the final judge in the VERITAS intelligence analysis pipeline.
    You receive TWO independent analyses of the same article — one from ANALYST (content expert) and one from SENTINEL (forensics expert).

    Your job is to:
    1. Compare both analyses for agreement and disagreement
    2. Resolve any conflicts with reasoned judgment
    3. Produce the FINAL, authoritative intelligence assessment

    Rules:
    - If both agents agree on trust score (within 15 points), average them
    - If they disagree significantly, explain why and choose the more defensible position
    - SENTINEL's bias detection should LOWER the trust score if anomalies were found
    - The final threat level should reflect the consensus or the more cautious assessment

    You MUST respond with valid JSON only, no other text. Use this exact structure:
    {
      "final_trust_score": A number 1-100 (the verified, consensus trust score),
      "final_sentiment_label": "One of: POSITIVE, NEGATIVE, NEUTRAL, MIXED",
      "final_sentiment_color": "One of: #22c55e, #ef4444, #64748b, #f59e0b",
      "final_threat_level": "One of: CRITICAL, HIGH, MODERATE, LOW, NEGLIGIBLE",
      "final_summary": "A refined 2-3 sentence intelligence summary incorporating insights from both agents",
      "final_geopolitical_topic": "The confirmed geopolitical category",
      "linguistic_anomaly_flag": true or false,
      "anomaly_notes": "Synthesis of any concerns raised by SENTINEL, or confirmation of clean analysis",
      "agreement_level": "One of: FULL_CONSENSUS, PARTIAL_AGREEMENT, SIGNIFICANT_DISAGREEMENT",
      "arbitration_notes": "Explain how you resolved any disagreements between the two agents and why you weighted scores as you did"
    }
  PROMPT

  def initialize
    @client = OpenRouterClient.new
  end

  def arbitrate(article, analyst_result, sentinel_result)
    user_prompt = build_prompt(article, analyst_result, sentinel_result)
    @client.chat(:arbiter, SYSTEM_PROMPT, user_prompt)
  end

  private

  def build_prompt(article, analyst_result, sentinel_result)
    <<~PROMPT
      === ORIGINAL ARTICLE ===
      HEADLINE: #{article.headline}
      SOURCE: #{article.source_name}
      COUNTRY: #{article.country&.name} (#{article.region&.name})
      === END ARTICLE ===

      === AGENT ANALYST REPORT (Gemini Flash) ===
      #{JSON.pretty_generate(analyst_result)}
      === END ANALYST REPORT ===

      === AGENT SENTINEL REPORT (GPT-4o-mini) ===
      #{JSON.pretty_generate(sentinel_result)}
      === END SENTINEL REPORT ===

      Compare both analyses carefully. Resolve any disagreements. Produce the FINAL verified intelligence assessment as JSON.
    PROMPT
  end
end
