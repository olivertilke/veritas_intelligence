class EnhanceAiAnalyses < ActiveRecord::Migration[8.1]
  def change
    add_column :ai_analyses, :analyst_response, :jsonb
    add_column :ai_analyses, :sentinel_response, :jsonb
    add_column :ai_analyses, :arbiter_response, :jsonb
    add_column :ai_analyses, :analysis_status, :string, default: 'pending'
  end
end
