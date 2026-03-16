# NarrativeDnaService
#
# Builds a force-directed graph data structure from a given article's
# narrative routes. Returns nodes (unique outlets) + edges (propagation
# links between them), sorted chronologically for animated reveal.
#
# Usage: NarrativeDnaService.new(article).call
# Returns: { meta:, nodes:, edges: }

class NarrativeDnaService
  FRAMING_COLORS = {
    "original"    => "#22c55e",
    "amplified"   => "#f59e0b",
    "distorted"   => "#ef4444",
    "neutralized" => "#3b82f6"
  }.freeze

  def initialize(article)
    @article = article
  end

  def call
    routes = NarrativeRoute
      .joins(:narrative_arc)
      .where(narrative_arcs: { article_id: @article.id })
      .where.not(hops: nil)

    return empty_result if routes.empty?

    nodes = {}
    edges = []

    routes.each do |route|
      hops = route.hops
      next if hops.blank? || hops.size < 2

      hops.each_with_index do |hop, index|
        nid = node_key(hop)

        unless nodes[nid]
          nodes[nid] = {
            id:            nid,
            type:          index.zero? ? "origin" : "hop",
            source_name:   hop["source_name"]    || "Unknown",
            country:       hop["source_country"] || "?",
            lat:           hop["lat"],
            lng:           hop["lng"],
            published_at:  hop["published_at"],
            framing_shift: hop["framing_shift"] || "original",
            confidence:    hop["confidence_score"] || 0.5,
            bias_color:    framing_color(hop["framing_shift"]),
            reach_count:   0
          }
        end

        nodes[nid][:reach_count] += 1

        next_hop = hops[index + 1]
        next unless next_hop

        edges << {
          id:            "#{route.id}_#{index}",
          source:        nid,
          target:        node_key(next_hop),
          route_id:      route.id,
          framing_shift: hop["framing_shift"],
          color:         framing_color(hop["framing_shift"]),
          delay_hours:   (hop["delay_from_previous"].to_f / 3600).round(2),
          confidence:    hop["confidence_score"] || 0.5,
          sort_time:     hop["published_at"] || ""
        }
      end
    end

    # Normalize reach to 0.2–1.0 scale relative to most-referenced outlet
    max_reach = nodes.values.map { |n| n[:reach_count] }.max.to_f
    nodes.each_value do |n|
      n[:reach] = max_reach > 0 ? (n[:reach_count] / max_reach).clamp(0.2, 1.0) : 0.5
      n.delete(:reach_count)
    end

    sorted_edges = edges.sort_by { |e| e[:sort_time] }

    {
      meta:  build_meta(routes.to_a, nodes),
      nodes: nodes.values,
      edges: sorted_edges
    }
  end

  private

  def node_key(hop)
    name    = (hop["source_name"]    || "unknown").downcase.gsub(/[^a-z0-9]+/, "_")
    country = (hop["source_country"] || "xx").downcase.gsub(/[^a-z0-9]+/, "_")
    "#{name}_#{country}"
  end

  def framing_color(shift)
    FRAMING_COLORS[shift] || "#6b7280"
  end

  def build_meta(routes, nodes)
    manipulation_scores = routes.map(&:manipulation_score).compact
    speed_scores        = routes.map(&:propagation_speed).compact

    {
      article_id:            @article.id,
      headline:              @article.headline,
      total_routes:          routes.size,
      total_nodes:           nodes.size,
      max_manipulation:      manipulation_scores.max&.round(3) || 0,
      manipulation_avg:      manipulation_scores.any? ? (manipulation_scores.sum / manipulation_scores.size).round(3) : 0,
      propagation_speed_avg: speed_scores.any? ? (speed_scores.sum / speed_scores.size).round(1) : 0
    }
  end

  def empty_result
    {
      meta: {
        article_id:            @article.id,
        headline:              @article.headline,
        total_routes:          0,
        total_nodes:           0,
        max_manipulation:      0,
        manipulation_avg:      0,
        propagation_speed_avg: 0
      },
      nodes: [],
      edges: []
    }
  end
end
