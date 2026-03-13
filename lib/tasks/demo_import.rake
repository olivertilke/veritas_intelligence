namespace :veritas do
  desc "Import a large demo batch of real articles from NewsAPI. Usage: bin/rails 'veritas:import_demo_articles[200]'"
  task :import_demo_articles, [:limit] => :environment do |_task, args|
    limit = args[:limit].to_i
    limit = 200 if limit <= 0

    if ENV["NEWS_API_KEY"].blank?
      abort "NEWS_API_KEY is missing. Set it before running the import."
    end

    if Region.count.zero? || Country.count.zero?
      abort "Regions/Countries are missing. Seed base geography first with `bin/rails db:seed`."
    end

    service = NewsApiService.new
    articles = service.fetch_demo_batch(limit: limit)

    if articles.empty?
      puts "No articles returned from NewsAPI demo batch import."
      next
    end

    created = 0
    skipped = 0

    articles.each do |attrs|
      article = Article.create!(attrs)
      AnalyzeArticleJob.perform_later(article.id)
      created += 1
    rescue ActiveRecord::RecordInvalid => e
      skipped += 1
      Rails.logger.warn "[veritas:import_demo_articles] Skipped #{attrs[:source_url]}: #{e.message}"
    end

    puts "Imported #{created} real articles for demo use. Skipped #{skipped}."
    puts "Database now contains #{Article.count} total articles."
  end
end
