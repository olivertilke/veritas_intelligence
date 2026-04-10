class AiAnalysis < ApplicationRecord
  include ConfidenceScoreable

  belongs_to :article

  after_update_commit :broadcast_color_update, if: :analysis_complete?

  THREAT_SEVERITY = {
    "CRITICAL" => 10, "HIGH" => 8, "MODERATE" => 5,
    "LOW" => 2, "NEGLIGIBLE" => 1
  }.freeze

  def threat_numeric
    THREAT_SEVERITY[threat_level.to_s.upcase] || threat_level.to_i.clamp(0, 10)
  end

  # Normalize threat_level to a human-readable label.
  # Handles both string values (CRITICAL/HIGH/...) and legacy numeric (1-10).
  def threat_label
    case threat_numeric
    when 8..10 then "CRITICAL"
    when 5..7  then "HIGH"
    when 3..4  then "MODERATE"
    when 2     then "LOW"
    else "NEGLIGIBLE"
    end
  end

  def threat_color
    case threat_numeric
    when 8..10 then "#ff3a5e"
    when 5..7  then "#ff6b2b"
    when 3..4  then "#ffc107"
    when 2     then "#22c55e"
    else "#6b7280"
    end
  end

  private

  def analysis_complete?
    analysis_status == "complete" && saved_change_to_analysis_status?
  end

  def broadcast_color_update
    ActionCable.server.broadcast("globe", {
      type: "update_point",
      point: {
        id:    article_id,
        color: sentiment_color || "#00f0ff"
      }
    })
  rescue StandardError => e
    Rails.logger.warn "[VERITAS Globe] Broadcast skipped for Article ##{article_id}: #{e.class} #{e.message}"
  end
end
